#!/usr/bin/env ruby
SCRIPTSELF=File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
SCRIPTPATH=File.realdirpath(File.dirname(SCRIPTSELF))
$LOAD_PATH.unshift(SCRIPTPATH)
require 'rubygems'
require 'getoptlong'
require 'json'
require 'fileutils'
require 'yaml'
require 'lib/Cache.rb'
require 'lib/History.rb'

VERSION="3.5.0"

APPFOLDER="#{ENV['HOME']}/.config/findex"

if File.directory?(APPFOLDER) == false
	Dir.mkdir APPFOLDER
end

if !File.exists?("#{APPFOLDER}/config")
	FileUtils.copy_file "#{SCRIPTPATH}/default.yaml", "#{APPFOLDER}/config"
end

def update_cache(cache, cfg)
	if cfg['exclude'] != nil and cfg['exclude'].kind_of?(String)
		exclude = cfg['exclude'].split(',')
	else
		exclude = []
	end

	if cfg['exclude_path'] != nil and cfg['exclude_path'].kind_of?(String)
		exclude_paths = cfg['exclude_path'].split(',')
	else
		exclude_paths = []
	end

	cache.update ENV['PATH'].split(':'), exclude_paths, exclude
end

def phelp(short, long, desc)
	puts "%-2s, %-20s %s" % [ short, long, desc ]
end

cfg = YAML::load( File.open( "#{APPFOLDER}/config" ) )

ENV['PATH']="#{ENV['PATH']}:#{cfg['path']}"

h = History.new "#{APPFOLDER}/history", cfg['history_size'].to_i
cache = Cache.new "#{APPFOLDER}/cache"
if !cache.exists?
	update_pathcache cache, cfg
end

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--update', '-u', GetoptLong::NO_ARGUMENT ],
  [ '--clear-history', '-c', GetoptLong::NO_ARGUMENT ],
	[ '--version', '-v', GetoptLong::NO_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
    when '--help'
		puts "Fast Quick Launcher using dmenu\n\n"
		puts "Usage: findex [OPTION]\n\n"
		phelp '-h', '--help', 'prints this help'
		phelp '-u', '--update', 'updates the executables cache'
		phelp '-c', '--clear-history', 'deletes the history'
		phelp '-v', '--version', 'prints the version'
		exit 0
    when '--update'
		update_cache cache,cfg
		exit 0
    when '--clear-history'
		h.clear
		exit 0
	when '--version'
		puts "Version #{VERSION}"
		exit 0
  end
end

pcache = (cache.get + cfg['alias'].keys).sort

h.get.each{|his|
	index = pcache.find(his)
	if index != nil
		pcache.delete index
	end
}

dmenu = h.get|pcache
choice = %x{echo "#{dmenu.join("\n")}" | dmenu -i -l #{cfg['dropdown_size']} -nb "#{cfg['colors']['normal']['background']}" -nf "#{cfg['colors']['normal']['foreground']}" -sb "#{cfg['colors']['selected']['background']}" -sf "#{cfg['colors']['selected']['foreground']}"}.chomp
if choice.length == 0
	exit 0
end

match = (/(?<app>[^;!#]+)((?<opt>([;#]))|!(?<theme>[0-9]{,1}))?$/).match(choice)
app = match['app']
terminal = (match['opt'] != nil and match['opt'].include?(";"))
sudo = (match['opt'] != nil and match['opt'].include?("#"))
theme = match['theme'] != nil

if theme
	if match['theme'].to_i >= 1
		theme_key = cfg['themes'].keys[match['theme'].to_i - 1]
	else
		theme_key = cfg['alternative_theme']
	end

	ENV['GTK2_RC_FILES'] = cfg['themes'][theme_key]['gtkrc']
	ENV['GTK_THEME'] = cfg['themes'][theme_key]['gtk_theme']
end

h.append choice
h.save

app_cfg = nil
if cfg['alias'].include?(app)

	app_cfg = cfg['alias'][app]

	if app_cfg.include?('command') 
		command = app_cfg['command']
	else
		command = app
	end

	if app_cfg.include?('theme') and app_cfg['theme'] != false and theme == false
		ENV['GTK2_RC_FILES'] = cfg['themes'][app_cfg['theme']]['gtkrc']
		ENV['GTK_THEME'] = cfg['themes'][app_cfg['theme']]['gtk_theme']
	end

	terminal = (app_cfg.include?("terminal") and app_cfg['terminal'] == true)
	sudo = (app_cfg.include?("sudo") and app_cfg["sudo"])
else
	command = app
end

if terminal
	if sudo
		command = "sudo #{command}"
	end
	
	exec("nohup #{cfg['terminal_launch'].gsub('%TITLE%', app).gsub('%COMMAND%', command)} >/dev/null 2>&1 &")
else
	if sudo
		command = "gksu -k #{command}"
	end
	
	exec("nohup #{command} >/dev/null 2>&1 &")
end
