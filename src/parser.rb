#coding : utf-8

require 'rexml/document'

include REXML

def parseFile(fileName)
	file = File.new(fileName)
	document = Document.new(file)

end

#parseFile("/home/moi/Etudes/M2/Ouaib sémantique/Collection/d001.xml")
