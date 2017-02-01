require 'rubygems'
require 'json'
require_relative './jsonwriter.rb'

module Findex
	class History < JsonWriter
		public
		# --------------------------------------------------------------------------------
		def initialize(file:, size:)
			@size = size
			super file
		end

		def append(value)
			if value.length == 0
				p "empty string"
				return
			end

			self.deleteValue value

			@entries.push value
			self.save
		end

		def deleteValue(value)
			key = @entries.index(value)
			if key != nil
				@entries.delete_at key
			end
			if @entries.length == @size
				@entries.shift
			end

			self.save
		end

		def get
			return @entries.reverse
		end

		private
		# --------------------------------------------------------------------------------
		attr_accessor :size
	end
end