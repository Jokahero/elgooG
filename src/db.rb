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

