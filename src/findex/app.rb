
require 'yaml'
require 'fileutils'

require_relative './dmenu.rb'
require_relative './history.rb'
require_relative './bincache.rb'
require_relative './comand.rb'

module Findex
	class App
		VERSION="4.1.0"
		CONFIGFOLDER="#{ENV['HOME']}/.config/findex4"

		public
		# --------------------------------------------------------------------------------
		def initialize(configpath: CONFIGFOLDER)
			@configpath = configpath

			initConfig configpath
			initDmenu
			initHistory
			initCache
		end

		def show
			entries = @history.get | @config['alias'].keys | @cache.get
			@dmenu.addEntries entries.uniq
			@dmenu.show

			if @dmenu.getChoice != nil
				begin
					@history.append @dmenu.getChoice 
					resolv @dmenu.getChoice
					
				rescue SystemCallError
					@history.deleteValue @dmenu.getChoice 
					@dmenu.error "ERROR: comand not found"
				else 
					@history.deleteValue @dmenu.getChoice 
					@dmenu.error "ERROR: unknown error"
				end
			end
		end

		def update
			@history.clear
			@cache.clear

			if @config.key?('use_path_env') and @config['use_path_env']
				@cache.addPath ENV['PATH'].split(':')
			end

			if @config.key?('paths') and @config['paths'].kind_of?(Array)
				@cache.addPath @config['paths']
			end

			if @config.key?('exclude_paths') and @config['exclude_paths'].kind_of?(Array)
				@cache.addPath @config['exclude_paths']
			end

			if @config.key?('exclude')
				@cache.addExclude  @config['exclude'].split(',') | ['findex']
			end

			@cache.update
		end
		
		def version
			return VERSION
		end

		def getHistory
			return @history
		end

		def getCache
			return @cache
		end

		private
		# --------------------------------------------------------------------------------
		def initConfig(path)
			if File.directory?(path) == false
				Dir.mkdir path
			end

			if !File.exists?("#{path}/config")
				currentPath = File.realdirpath(File.dirname(__FILE__))
				FileUtils.copy_file "#{currentPath}/../config", "#{path}/config"
			end

			@config = YAML::load( File.open( "#{path}/config" ) )
		end

		def initDmenu
			@dmenu = Findex::Dmenu.new fg: @config['colors']['foreground'], bg: @config['colors']['background']
			@dmenu.toggleStdin
			@dmenu.toggleCase
			@dmenu.setLines @config['dropdown_size']

			if @config.key?('monitor')
				monitor = @config['monitor']

				if monitor != 'auto'
					@dmenu.setMonitor monitor.to_i
				end
			end

		end

		def initHistory
			@history = Findex::History.new file: "#{configpath}/history", size: @config['history_size']
		end

		def initCache
			@cache = Findex::BinCache.new "#{configpath}/cache"
		end

		def resolv(name)
			c = Findex::Comand.new name
			c.setTerminalWrapper @config['terminal_launch']

			comandMatch = (/^(?<comand>.*?)(?<opt>[;#!]+([0-9]+)?)/).match(name)

			if comandMatch != nil
				c.setComand comandMatch['comand']
				options = comandMatch['opt']
			end

			if @config['alias'].keys.include?(c.getComand)
				resolved = @config['alias'][c.getComand]
				
				if resolved.key?('comand')
					c.setComand resolved['comand']
				end

				c.setTerminal resolved['terminal'] if resolved.key?('terminal')
				c.setRoot resolved['root'] if resolved.key?('root')

				if resolved.key?('theme') 
					theme = resolved['theme']
					c.setGtkrc @config['themes'][theme]['gtkrc'] 
					c.setTheme @config['themes'][theme]['gtk_theme'] 
				end

				c.setTitle name
			end

			if options != nil
				c.setTerminal options.index(';') != nil
				c.setRoot options.index('#') != nil
				themeMatch = (/!(?<ti>[0-9])?/).match(options)

				if themeMatch != nil
					if themeMatch['ti'] == nil
						theme = @config['alternative_theme']
					else
						theme = @config['themes'].keys[themeMatch['ti'].to_i - 1]
					end

					c.setGtkrc @config['themes'][theme]['gtkrc'] 
					c.setTheme @config['themes'][theme]['gtk_theme'] 
				end
			end

			return c.execute
		end

		attr_accessor :config, :history, :cache, :dmenu, :configpath
	end
end
