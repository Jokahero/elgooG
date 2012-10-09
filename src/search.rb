#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'db'

def searchPattern(pattern)
	checkDatabaseConnection
	terms = pattern.split(/[^a-zA-ZàÀâÂéÉèÈêÊçÇîÎôÔûÛ]/)
	terms.each {|t|
		puts "-------------------#{t}--------------------"
		puts searchWord t
	}
	$db.close if $db != nil
end

def searchWord(word)
	checkDatabaseConnection
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

searchPattern("village randonnée montagne asie")

