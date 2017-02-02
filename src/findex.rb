#!/usr/bin/env ruby

require 'rubygems'
require 'getoptlong'
require 'fileutils'

require_relative './findex/module.rb'

APPFOLDER="#{ENV['HOME']}/.config/findex4"

findex = nil
setup = !File.directory?(APPFOLDER)

if setup
	puts "initializing app folder"
	Dir.mkdir APPFOLDER

	findex = Findex::App.new
	findex.update
end

findex = Findex::App.new if findex == nil

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--update', '-u', GetoptLong::NO_ARGUMENT ],
  [ '--clear-history', '-c', GetoptLong::NO_ARGUMENT ],
  [ '--version', '-v', GetoptLong::NO_ARGUMENT ]
)

def phelp(short, long, desc)
	puts "%-2s, %-20s %s" % [ short, long, desc ]
end

opts.each do |opt, arg|
  case opt
    when '--help'
		puts "Fast Quick Launcher using dmenu\n"
		puts "Version #{Findex::App::VERSION}\n\n"
		puts "Usage: findex [OPTION]\n\n"
		phelp '-h', '--help', 'prints this help'
		phelp '-u', '--update', 'updates the executables cache'
		phelp '-c', '--clear-history', 'deletes the history'
		phelp '-v', '--version', 'prints the version'
		exit 0
    when '--update'
		findex.update
		exit 0
    when '--clear-history'
		findex.getHistory.clear
		exit 0
	when '--version'
		puts "Version #{Findex::App::VERSION}"
		exit 0
  end
end

findex.show


