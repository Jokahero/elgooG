#coding : utf-8

require 'rexml/document'

require './src/db.rb'
require './src/wordinfo.rb'

include REXML

BALADE = 'BALADE'
PRESENTATION = 'PRESENTATION'
RECIT = 'RECIT'

TITRE = 'TITRE'
AUTEUR = 'AUTEUR'
DESCRIPTION = 'DESCRIPTION'

DATE = 'DATE'
PARAGRAPHE = 'P'
SECTION = 'SEC'
SOUS_TITRE = 'SOUS-TITRE' 

$escaped_words = []

$words = Hash.new

$current_path = ""

$document

$paragraph_count = 0

def parseFile(fileName)
	#return if not fileName == 'samples/d001.xml'
	$document = fileName
		
	file = File.new(fileName)
	document = Document.new(file)

	root = document.root
	return if not root.name == BALADE
	root.each_element do |element|
		
		if element.name == PRESENTATION
			parsePresentation(element)
		elsif element.name == RECIT
			parseRecit(element)
		end
	end
	insertWords
end

def insertWords
	#puts "Inseting #{$words.length} words ..."
	$words.each do |word, wordInfo|
		wordInfo.eachPath do |path, positions|
			insertWordOccurences(word, $document, path, wordInfo.getWeight($words.length, path, $paragraph_count), wordInfo.getFrequency(path), positions)
		end
	end
	$words.clear
	$paragraph_count = 0
end

def parsePresentation(element) 
	element.elements.each do |node|
		if node.name == DESCRIPTION
			parseSection(node)
		elsif node.name == TITRE
			parseWords(node)
		end
	end	
end

def parseRecit(element)
	element.elements.each do |node|
		parseSection(node) if node.name == SECTION
	end
end

def parseSection(element)
	element.elements.each do |node|
		parseWords(node) if node.name == PARAGRAPHE or node.name == SOUS_TITRE
		$paragraph_count += 1 if node.name == PARAGRAPHE
		#insertWords
	end
end

def parseWords(element)
	toParse = element.text
	return if toParse == nil
	words = toParse.split(/\W+/)
	position = 0
	words.each do |word|
		truncated = word[0..4]
		next if truncated.strip == ''
		position += 1
		next if $escaped_words.include?(truncated.downcase)
		#puts "#{truncated} at #{position}"

		treatWordOccurence(word.downcase, position, element.xpath)
	end
end

def createStopList
	file = File.new("samples/stoplist.txt")
	file.each_line do |line|
		$escaped_words << line.strip		
	end
end

def treatWordOccurence(word, position, xpath)
	$words[word] = WordInfo.new if $words[word] == nil
	$words[word].addOccurence(xpath, position)
end

createStopList

