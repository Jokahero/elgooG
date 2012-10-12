#coding: utf-8

$LOAD_PATH << File.dirname(__FILE__)

require 'rexml/document'

include REXML

class QrelElt
	attr_accessor :document, :xpath, :usefullness

	def initialize(string)
		tmp = string.split
		@document = tmp[0]
		@xpath = tmp[1]
		@usefullness = tmp[2] != 0 ? true : false
	end

	def to_s
		return "#{@document}:#{xpath} : #{@usefullness ? 1 : 0}"
	end
end

class Qrel
	attr_accessor :qrels
	def initialize(qrels)
		@qrels = []
		qrels.each {|qrelElt|
			@qrels << QrelElt.new(qrelElt)
		}
	end
end

