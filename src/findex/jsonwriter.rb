require 'rubygems'
require 'json'

module Findex
	class JsonWriter
		public
		# --------------------------------------------------------------------------------
		def initialize(file)
			@file = file
			@entries = []
			if !self.exists?
				self.save
			else
				self.load
			end
		end

		def exists?
			return File.exists?(@file)
		end

		def load
			buffer = File.open("#{@file}", 'r').read
			@entries = JSON.parse(buffer)
		end

		def save
			fh = File.open("#{@file}", 'w')
			fh.write @entries.to_json
			fh.close
		end

		def clear
			File.delete @file unless File.exists?(@file)
			@entries = []
		end

		private
		# --------------------------------------------------------------------------------
		attr_accessor :file, :entries
	end

end