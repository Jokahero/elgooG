#coding: utf-8

require './src/formulas.rb'

class WordInfo

	@@TITLE_WEIGHT = 15 
	@@UNDER_TITLE_WEIGHT = 2
	@@OCCURENCE_WEIGHT = 1

	attr_accessor :document, :xPathList, :weight, :positions

	def initialize
		@xPathList = Hash.new
		@weight = 0
	end

	def addParagraph(xPath)
		@xPathList << xPath
	end

	def addTitleWeight
		@weight += @@TITLE_WEIGHT
	end

	def addUnderTitleWeight
		@weight = @weight + @@UNDER_TITLE_WEIGHT
	end

	def addOccurence(xPath, position)
		positions = @xPathList[xPath]
		@xPathList[xPath] = Array.new if positions == nil
		@xPathList[xPath] << position
	end

	def getFrequency(xPath)
		return @xPathList[xPath].length
	end

	def eachPath(&block)
		@xPathList.each(&block)
	end

	def getWeight(length, xPath, paragraphCount)
		return computeTF(length, getFrequency(xPath)) * computeIDF(paragraphCount, @xPathList.length) +  @weight
#return getFrequency(xPath) * computeIDF(paragraphCount, @xPathList.length) +  @weight
		#return getFrequency(xPath) + @weight
	end
end # WordInfo

