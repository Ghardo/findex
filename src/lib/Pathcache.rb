#!/usr/bin/env ruby
require 'rubygems'
require 'json'

class Pathcache
	def initialize(file)
		@file = file
	end

	def exists?
		return File.exists?(@file)
	end

	def update(paths, exclude_paths = [], exclude = [])
		binarys = []
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
					binarys.push File.basename(file)
				end
			}
		}

		binarys = binarys - exclude

		fh_pathcache = File.open(@file, 'w')
		fh_pathcache.puts binarys.sort.to_json
		fh_pathcache.close
	end
	
	def get
		buffer = File.open(@file, 'r').read
		JSON.parse(buffer)
	end
end
