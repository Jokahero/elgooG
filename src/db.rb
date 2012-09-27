#coding: utf-8

require 'mysql'

$db = nil

def connectToDatabase(host, user, password, database)
	begin
		$db = Mysql.new(host, user, password, database)
	rescue Mysql::Error => e
		puts e
		return false
	end
	return true
end

def insertWordOccurence(word, document, xpath, weight, frequency, positions)
	idWord = searchWord(word)
	if idWord == nil then
		idWord = insertWord(word)
	end

	idDocument = searchDocument(document)
	if idDocument == nil then
		idDocument = insertDocument(document)
	end

	idParagraph = searchParagraph(document, xpath)
	if idParagraph == nil then
		idParagraph = insertParagraph(document, xpath)
	end

	# Insert the word for the paragraph
	$db.query("INSERT INTO `Found` (`id`, `word`, `paragraph`, `weight`, `frequency`) VALUES (NULL, #{idWord}, #{idParagraph}, #{weight}, #{frequency});")
	idFound = $db.insert_id

	# Insert each occurence
	positions.each {|pos|
		$db.query("INSERT INTO `Positions` (`found`, `position`) VALUES (#{idFound}, #{pos});")
	}
end

def searchWord(word)
	res = $db.query("SELECT id FROM `Words` WHERE `word` = '#{word}';")
	while row = res.fetch_hash do
		return row['id']
	end
	return nil
end

def insertWord(word)
	$db.query("INSERT INTO `Words` (`id`, `word`) VALUES (NULL, '#{word}');")
	return $db.insert_id
end

def searchDocument(document)
	res = $db.query("SELECT id FROM `Documents` WHERE `label` = '#{document}';")
	while row = res.fetch_hash do
		return row['id']
	end
	return nil
end

def insertDocument(document)
	$db.query("INSERT INTO `Documents` (`id`, `label`) VALUES (NULL, '#{document}');")
	return $db.insert_id
end

def searchParagraph(document, xpath)
	res = $db.query("SELECT id FROM `Paragraphs` WHERE `document` = '#{document}' AND `xpath` = '#{xpath}';")
	while row = res.fetch_hash do
		return row['id']
	end
	return nil
end

def insertParagraph(document, xpath)
	$db.query("INSERT INTO `Paragraphs` (`id`, `document`, `xpath`) VALUES (NULL, '#{document}', '#{xpath}');")
	return $db.insert_id
end

