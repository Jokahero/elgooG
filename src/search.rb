#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'db'
require 'lingua/stemmer'

FOLLOW_WEIGHT = 15
$escaped_words = []

def createStopList
	stemmer = Lingua::Stemmer.new(:language => "fr")
	file = File.new("../Collection/stoplist.txt")
	file.each_line do |line|
		$escaped_words << stemmer.stem(line.strip)
	end
end

class Term
	attr_accessor :term, :found, :next

	def initialize(string)
		terms = string.split(/[^a-zA-ZàÀâÂéÉèÈêÊçÇîÎôÔûÛ]/)
		stemmer = Lingua::Stemmer.new(:language => "fr")
		stemmed = ""
		valid = false
		for i in 0...terms.size do
			stemmed = stemmer.stem(terms[i])
			if not $escaped_words.include?(stemmed) then
				valid = true
				break
			end
		end
		if valid then
			@found = searchWord stemmed
			if i < terms.size then
				@next = Term.new(terms[i+1..-1].join(" "))
			else
				@next = nil
			end
		end
	end
end

def searchPattern(pattern)
	root = Term.new(pattern)

	# Order paragraphs by total weight
	pars = weightForParagraphs(root)
	result = {}
#weights = []
	pars.each {|k, v|
		res = $db.query("SELECT `Paragraphs`.`xpath`, `Documents`.`label` FROM `Paragraphs`, `Documents` WHERE `Paragraphs`.id = #{k} AND `Paragraphs`.`document` = `Documents`.`id`;")
		row = res.fetch_hash
#		weights << v
		result[v] = [] if !result[v]
		result[v] << row
	}

#	weights.sort! {|x,y| y <=> x}
	return result
end

def searchWord(word)
	res = $db.query("SELECT `Found`.`id`, `Found`.`paragraph`, `Found`.`weight` FROM `Found`, `Words` WHERE `Words`.`word` = '#{word}' AND `Words`.`id` = `Found`.`word` ORDER BY `Found`.`weight` DESC;")
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

def weightForParagraphs(start)
	poids = {}
	tmp = start
	while tmp != nil do
		if tmp.found != nil then
			tmp.found.each{|k, v|
				poids[k] = 0 if not poids.has_key? k
				poids[k] += v['weight'].to_i
				if not tmp.next == nil and not tmp.next.found == nil and tmp.next.found.has_key? k then
					v['positions'].each do |p|
						poids[k] += FOLLOW_WEIGHT if tmp.next.found[k]['positions'].include? (p.to_i + 1).to_s	
					end
				end
			}
		end
		tmp = tmp.next
	end

	return poids
end


if $0 == __FILE__ then
	checkDatabaseConnection
	searchPattern(ARGV.join(" ")).each do |r|
		puts "#{r['label']}      #{row['xpath']} #{v > 0 ? 1 : 0}"
	end
	$db.close if $db != nil
end

