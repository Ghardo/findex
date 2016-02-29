#!/usr/bin/env ruby
require 'rubygems'
require 'json'

class History
	def initialize(file, size)
		@size = size
		@file = file
		@history = []
		if !File.exists?(file)
			self.save
		else
			self.load
		end
	end

	def append(value)
		if value.length == 0
			p "leerer String"
			return
		end

		key = @history.index(value)
		if key != nil
			@history.delete_at key
		end
		if @history.length == @size
			@history.shift
		end

		@history.push value
	end

	def clear
		File.delete @file
		@history = []
	end

	def get
		@history.reverse
	end

	def load
		buffer = File.open("#{@file}", 'r').read
		@history = JSON.parse(buffer)
	end

	def save
		fh = File.open("#{@file}", 'w')
		fh.write @history.to_json
		fh.close
	end
end
