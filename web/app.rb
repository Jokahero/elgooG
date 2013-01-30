#coding: utf-8

require 'rubygems'
require 'sinatra'
require 'haml'

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
