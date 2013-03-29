#coding: utf-8

require 'rubygems'
require 'sinatra'
require 'haml'
require 'rexml/document'
require '../src/search.rb'

include REXML

class Float
	def round_to(x)
		(self * 10**x).round.to_f / 10**x
	end

	def ceil_to(x)
		(self * 10**x).ceil.to_f / 10**x
	end

	def floor_to(x)
		(self * 10**x).floor.to_f / 10**x
	end
end

before do
	request.env['PATH_INFO'].gsub!(/\/$/, '')
end

not_found do
	status 404
	haml :'404'
end

error do
	status 500
	haml :'500'
end

get '' do
	haml :index
end

get '/search' do
	start = Time.now
	if not checkDatabaseConnection then
		haml :db_error
	else
		@query = params['query']
		@result = searchPattern(@query)
		@result.each do |r|
			d = Document.new File.new "../#{r['label']}"
			r['value'] = XPath.first(d, r['xpath']).to_s
		end
		@time = (Time.now - start).round_to(2)
		haml :search
	end
end
