#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'parser'
require 'mysql'

db = nil

def lookForFiles(path)
	Dir.foreach(path) do |file|
		next if file == '.' or file == '..'
		fname = path + '/' + file
		if File.extname(fname) == '.xml' then
			puts "Parsing #{fname}"
			parseFile(fname)
		end
	end
end

def connectToDatabase(host='localhost', user='root', password='root', database='elgoogaa')
	begin
		db = Mysql.new
		db.connect(host, user, password, database)
	rescue Mysql::Error => e
		puts e
		return false
	end
	return true
end

if not connectToDatabase then
	puts "Unable to establish connection to the database!"
	exit 1
end

ARGV.each do|path|
	puts "Looking for documents in #{path}…"
	lookForFiles(path)
end

db.close

