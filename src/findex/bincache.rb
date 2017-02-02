require 'rubygems'
require 'json'
require_relative './jsonwriter.rb'

module Findex
	class BinCache < JsonWriter

		public
		# --------------------------------------------------------------------------------
		def initialize(file)
			@paths = []
			@exclude = []
			super file
		end

		def addPath(path)
			if path.kind_of?(Array)
				@paths = @paths | path
			end

			if path.kind_of?(String)
				@paths.push(path) unless @paths.exists?(path) 
			end
		end

		def addExcludePath(path)
			if path.kind_of?(Array)
				@excludePath = @excludePath | path
			end

			if path.kind_of?(String)
				@excludePath.push(path) unless @excludePath.exists?(path) 
			end
		end

		def addExclude(binary)
			if binary.kind_of?(Array)
				@exclude = @exclude | binary
			end

			if binary.kind_of?(String)
				@exclude.push(binary) unless @exclude.exists?(binary) 
			end
		end

		def getPaths
			return @paths
		end

		def update
			self.clear

			paths = @paths
			paths = paths - @excludePath unless @excludePath == nil

			paths.each { |path|
				Dir["#{path}/*"].each {|file|
					if File.executable_real?("#{file}")
						@entries.push File.basename(file)
					end
				}
			}

			@entries.uniq!
			@entries =  @entries - @exclude
			@entries.sort!
			@entries.uniq!
			self.save
		end

		def get
			return @entries.sort.uniq
		end

		private
		# --------------------------------------------------------------------------------
		attr_accessor :paths, :exclude, :excludePath
	end
end
