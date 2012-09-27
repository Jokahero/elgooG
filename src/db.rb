#coding: utf-8

require 'mysql'

$db = nil

def connectToDatabase(host='localhost', user='root', password='root', database='elgoog')
	begin
		$db = Mysql.new(host, user, password, database)
	rescue Mysql::Error => e
		puts e
		return false
	end
	return true
end

def searchWord(word)
	res = $db.query("SELECT id FROM `Words` WHERE `word` = '#{word}';")
	while row = res.fetch_hash do
		return row['id']
	end
end

def insertWord(word)
	$db.query("INSERT INTO `Words` (`id`, `word`) VALUES (NULL, '#{word}');")
	return $db.insert_id
end
