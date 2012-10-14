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

	def lookup(document, xpath)
		@qrels.each {|qrel|
			if qrel.document == document and qrel.xpath == xpath then
				return qrel
			end
		}

		return nil
	end

	def compare(qrelElt)
		comp = lookup(qrelElt.document, qrelElt.xpath)
		if comp == nil then
			return qrelElt.usefullness == 0
		else
			return qrelElt.usefullness == 0 and comp.usefullness == 0 or qrelElt.usefullness != 0 and qrelElt != 0
		end
	end
end

