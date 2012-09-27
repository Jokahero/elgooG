#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'db'
require 'parser'

HOST = 'localhost'
USER = 'root'
PASS = 'root'
DB = 'elgoog'

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

if not connectToDatabase(HOST, USER, PASS, DB) then
	puts "Unable to establish connection to the database!"
	exit 1
end

ARGV.each do|path|
	puts "Looking for documents in #{path}…"
	lookForFiles(path)
end

$db.close

