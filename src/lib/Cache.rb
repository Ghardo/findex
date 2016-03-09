#!/usr/bin/env ruby
require 'rubygems'
require 'json'

class Cache

	def initialize(file)
		@file = file
		@cache = []
		if !self.exists?
			self.save
		else
			self.load
		end
	end

	def load
		buffer = File.open("#{@file}", 'r').read
		@cache = JSON.parse(buffer)
	end

	def save
		fh = File.open("#{@file}", 'w')
		fh.write @cache.sort.to_json
		fh.close
	end

	def clear
		File.delete @file
		@history = []
	end

	def exists?
		return File.exists?(@file)
	end

	def update(paths, exclude_paths = [], exclude = [])
		self.clear
		paths.each {|path|
			continue = false
			exclude_paths.each {|exclude_folder|
				pattern = "^#{exclude_folder}"
				re = Regexp.new(pattern)
				match = re.match(path)
				if match != nil
					continue = true
					break
				end
			}

			if continue
				next
			end

			Dir["#{path}/*"].each {|file|
				if File.executable_real?("#{file}")
					@cache.push File.basename(file)
				end
			}
		}

		@cache = @cache - exclude
		self.save
	end
	
	def get
		@cache
	end
end
