#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'parser'

def lookForFiles(path)
	Dir.foreach(path) do |file|
		next if file == '.' or file == '..'
		parseFile(file)
	end
end

ARGV.each do|path|
	puts "Looking for documents in #{path}…"
	lookForFiles(path)
end
