#coding : utf-8

$LOAD_PATH << File.dirname(__FILE__) + '/../src'

require 'db'
require 'qrel'
require 'search'

require 'rexml/document'

include REXML

QUERY = 'query'
TEXT = 'text'
NARRATIVE = 'narrative'

file = File.new('tests/queries.xml')
document = Document.new(file)

root = document.root
return if not root.name == 'queries'

checkDatabaseConnection

# Parcours des requêtes
root.each_element do |element|
	if element.name == QUERY then
		currentQuery = element.attributes['id']
		element.each_element do |elt|
			if elt.name == TEXT then
				qrel = Qrel.new(searchPattern(elt.text))
			end
		end
	end
end

$db.close if $db != nil

