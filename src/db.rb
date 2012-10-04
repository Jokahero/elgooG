#coding: utf-8

require 'mysql'

HOST = 'localhost'
USER = 'root'
PASS = 'root'
DB = 'elgoog'

$db = nil

$words_id = {}
$par_id = {}
$docs_id = {}

def connectToDatabase(host, user, password, database)
	begin
		$db = Mysql.new(host, user, password, database)
	rescue Mysql::Error => e
		puts e
		return false
	end
	return true
end

def checkDatabaseConnection
	return true if $db != nil
	if not connectToDatabase(HOST, USER, PASS, DB) then
		puts "Unable to establish connection to the database!"
		return false
	else
		return true
	end
end

def insertWordOccurences(word, document, xpath, weight, frequency, positions)
	idWord = searchWord(word)
	if idWord == nil then
		idWord = insertWord(word)
	end

	idDocument = searchDocument(document)
	if idDocument == nil then
		idDocument = insertDocument(document)
	end

	idParagraph = searchParagraph(idDocument, xpath)
	if idParagraph == nil then
		idParagraph = insertParagraph(idDocument, xpath)
	end

	# Insert the word for the paragraph
	$db.query("INSERT INTO `Found` (`id`, `word`, `paragraph`, `weight`, `frequency`) VALUES (NULL, #{idWord}, #{idParagraph}, #{weight}, #{frequency});")
	idFound = $db.insert_id

	# Insert each occurence
	positions.each {|pos|
		$db.query("INSERT INTO `Positions` (`found`, `position`) VALUES (#{idFound}, #{pos});")
	}
end

def updateWeight(word, document, xpath, weight)
	idWord = searchWord(word)
	if idWord == nil then
		idWord = insertWord(word)
	end

	idDocument = searchDocument(document)
	if idDocument == nil then
		idDocument = insertDocument(document)
	end

	idParagraph = searchParagraph(idDocument, xpath)
	if idParagraph == nil then
		idParagraph = insertParagraph(idDocument, xpath)
	end

	# Update the word weight
	$db.query("UPDATE `Found` SET VALUES `weigth` = #{weight} WHERE `word` = #{idWord} AND `paragraph` = #{paragraph};")
end

def searchWord(word)
	if $words_id.has_key? word then
		return $words_id[word]
	end
	res = $db.query("SELECT id FROM `Words` WHERE `word` = '#{word}';")
	while row = res.fetch_hash do
		$words_id[word] = row['id']
		return row['id']
	end
	return nil
end

def insertWord(word)
	$db.query("INSERT INTO `Words` (`id`, `word`) VALUES (NULL, '#{word}');")
	$words_id[word] = $db.insert_id
	return $db.insert_id
end

def searchDocument(document)
	if $docs_id.has_key? document then
		return $docs_id[document]
	end
	res = $db.query("SELECT id FROM `Documents` WHERE `label` = '#{document}';")
	while row = res.fetch_hash do
		$docs_id[document] = row['id']
		return row['id']
	end
	return nil
end

def insertDocument(document)
	$db.query("INSERT INTO `Documents` (`id`, `label`) VALUES (NULL, '#{document}');")
	$docs_id[document] = $db.insert_id
	return $db.insert_id
end

def searchParagraph(document, xpath)
	if $par_id.has_key? "#{document}+#{xpath}" then
		return $par_id["#{document}+#{xpath}"]
	end
	res = $db.query("SELECT id FROM `Paragraphs` WHERE `document` = '#{document}' AND `xpath` = '#{xpath}';")
	while row = res.fetch_hash do
		$par_id["#{document}+#{xpath}"] = row['id']
		return row['id']
	end
	return nil
end

def insertParagraph(document, xpath)
	$db.query("INSERT INTO `Paragraphs` (`id`, `document`, `xpath`) VALUES (NULL, '#{document}', '#{xpath}');")
	$par_id["#{document}+#{xpath}"] = $db.insert_id
	return $db.insert_id
end

