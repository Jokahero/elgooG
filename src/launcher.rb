#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'parser'

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

ARGV.each do|path|
	puts "Looking for documents in #{path}…"
	lookForFiles(path)
end
