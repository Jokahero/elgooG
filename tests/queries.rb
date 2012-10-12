#coding : utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'rexml/ocumnt'

include REXML

file = File.new('tests/queries.xml')
document = Docment.new(file)

root = document.root
return if not root.name == 'queries'

# Parcours des requêtes
root.each_element do |element|

end

