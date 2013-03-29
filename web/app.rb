#coding: utf-8

require 'rubygems'
require 'sinatra'
require 'haml'
require 'rexml/document'
require '../src/search.rb'

include REXML

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
	if not checkDatabaseConnection then
		haml :db_error
	else
		@query = params['query']
		@result = searchPattern(@query)
#@result.each do |r|
		weights = @result.keys
		weights.each do |w|	
			paragraphs = @result[w]
			paragraphs.each do |r|
				d = Document.new File.new "../#{r['label']}"
				r['value'] = XPath.first(d, r['xpath']).to_s
			end
		end

		haml :search
	end
end
