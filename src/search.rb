#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'db'

class Term
	attr_accessor :term, :found, :next

	def initialize(string)
		terms = string.split(/[^a-zA-ZàÀâÂéÉèÈêÊçÇîÎôÔûÛ]/)
		@term = terms[0]
		@found = searchWord @term
		if terms.size > 1 then
			@next = Term.new(terms[1..-1].join(" "))
		else
			@next = nil
		end
	end
end

def searchPattern(pattern)
	root = Term.new(pattern)
	# Search commons paragraphs
	common = checkCommonParagraphs(root)
	puts common
end

def searchWord(word)
	res = $db.query("SELECT `Found`.`id`, `Found`.`paragraph`, `Found`.`weight` FROM `Found`, `Words` WHERE `Words`.`word` = '#{word}' AND `Words`.`id` = `Found`.`word`;")
	found = {}
	while row = res.fetch_hash do
		id = row['id']
		paragraph = row['paragraph']
		weight = row['weight']
		found[paragraph] = {} if not found.has_key? paragraph
		found[paragraph]['weight'] = weight
		found[paragraph]['positions'] = []
		resPos = $db.query("SELECT `position` FROM `Positions` WHERE `found` = #{id};")
		while rowPos = resPos.fetch_hash do
			found[paragraph]['positions'] << rowPos['position']
		end
	end

	return found
end

def checkCommonParagraphs(start)
	accu = []
	start.found.each_key {|p|
		accu << p
	}
	checkCommonParagraphsAux(start, accu)
end

def checkCommonParagraphsAux(start, accu)
	accu.each {|p|
		if not start.found.has_key? p then
			accu.delete p
		end
	}

	if start.next != nil then
		checkCommonParagraphsAux(start.next, accu)
	else
		return accu
	end
end

checkDatabaseConnection
searchPattern("village randonnée montagne asie")
$db.close if $db != nil

