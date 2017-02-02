
module Findex
	class Comand

		public
		# --------------------------------------------------------------------------------
		def initialize(comand)
			@comand = comand
			@terminal = false
			@root = false
			@title = nil
			@gtkrc = nil
			@theme = nil
			@terminalWrapper = nil
			@paths = nil
		end

		def setComand(value)
			@comand = value
		end

		def getComand
			return @comand
		end

		def setTerminal(value)
			@terminal = value
		end

		def getTerminal
			return @terminal
		end

		def setRoot(value)
			@root = value
		end 

		def getRoot
			return @root
		end

		def setTitle(value)
			@title = value
		end

		def getTitle
			return @title
		end

		def setGtkrc(value)
			@gtkrc = value
		end

		def getGtkrc
			return @gtkrc
		end

		def setTheme(value)
			@theme = value
		end

		def getTheme
			return @theme
		end

		def setTerminalWrapper(value)
			@terminalWrapper = value
		end

		def getTerminalWrapper
			return @terminalWrapper
		end

		def setPaths(paths)
			@paths = paths
		end

		def getPaths
			return @paths
		end 

		def execute

			setThemeEnv
			setPathEnv

			if @terminal
				execute_terminal
			else
				execute_gui
			end

		end

		private
		# --------------------------------------------------------------------------------
		def setThemeEnv
			ENV['GTK2_RC_FILES'] = @gtkrc unless @gtkrc == nil
			ENV['GTK_THEME'] = @theme unless @theme == nil
		end

		def setPathEnv
			ENV['PATH'] = @paths.join(':') unless @paths == nil
		end

		def execute_gui()

			comand = getComand
			comand = "gksu -k #{comand}" if @root

			exec("#{comand}")
		end

		def execute_terminal() 
			title = getTitle
			title = @comand if @title == nil

			comand = getComand
			comand = "sudo #{comand}" if @root

			wrapper = getTerminalWrapper

			exec("#{wrapper.gsub('%TITLE%', title).gsub('%COMAND%', comand)}")
		end

		attr_accessor :comand, :terminal, :root, :theme, :title, :terminalWrapper
	end
end
