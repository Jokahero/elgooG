#coding : utf-8

def computeTF(length, frequency)
	return frequency / (length + frequency)
end

def computeIDF(length, count)
	return Math.log(length / count) if count < length
	return 0
end
