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
	puts "Element : #{element.name} ==> #{toParse}"
end

