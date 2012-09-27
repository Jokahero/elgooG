#coding : utf-8

require 'rexml/document'

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

def parseFile(fileName)
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
	end
end

def parseWords(element)
	toParse = element.text
	return if toParse == nil
	words = toParse.split(/\W+/)
	words.each do |word|
		truncated = word[0..4]
		next if $escaped_words.include?(truncated.downcase)
		next if truncated.strip == ''
		puts truncated
	end
end

def createStopList
	file = File.new("samples/stoplist.txt")
	file.each_line do |line|
		$escaped_words << line.strip		
	end
end

createStopList
