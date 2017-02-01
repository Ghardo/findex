module Findex
	class Dmenu
		TOOGLE_VALUE='TOGGLE'
		ATTR_INDEX_BOTTOM='-b'
		ATTR_INDEX_STDIN='-f'
		ATTR_INDEX_LINES='-l'
		ATTR_INDEX_CASE='-i'
		ATTR_INDEX_MONITOR='-m'
		ATTR_INDEX_PROMPT='-p'
		ATTR_INDEX_FONT='-fn'

		ATTR_INDEX_NORMAL_FG_COLOR='-nf'
		ATTR_INDEX_NORMAL_BG_COLOR='-nb' 

		ATTR_INDEX_SELECTED_FG_COLOR='-sf'
		ATTR_INDEX_SELECTED_BG_COLOR='-sb'

		public
		# --------------------------------------------------------------------------------
		def initialize(fg:, bg:)
			@attributes = Hash.new
			@entries = Array.new

			setForeground fg
			setBackground bg
		end

		def toggleBottom
			if getAttribute(name: ATTR_INDEX_BOTTOM) == TOOGLE_VALUE
				delAttribute name: ATTR_INDEX_BOTTOM
			else 
				setAttribute name: ATTR_INDEX_BOTTOM, value: TOOGLE_VALUE
			end
		end

		def toggleStdin
			if getAttribute(name: ATTR_INDEX_STDIN) == TOOGLE_VALUE
				delAttribute name: ATTR_INDEX_STDIN
			else 
				setAttribute name: ATTR_INDEX_STDIN, value: TOOGLE_VALUE
			end
		end

		def toggleCase
			if getAttribute(name: ATTR_INDEX_CASE) == TOOGLE_VALUE
				delAttribute name: ATTR_INDEX_CASE
			else 
				setAttribute name: ATTR_INDEX_CASE, value: TOOGLE_VALUE
			end
		end

		def setLines(count)
			setAttribute name: ATTR_INDEX_LINES, value: count
		end

		def setMonitor(monitor)
			setAttribute name: ATTR_INDEX_MONITOR, value: monitor
		end

		def setPrompt(prompt)
			setAttribute name: ATTR_INDEX_PROMPT, value: prompt
		end

		def setFont(font)
			setAttribute name: ATTR_INDEX_FONT, value: font
		end

		def setForeground(color)
			setAttribute name: ATTR_INDEX_NORMAL_FG_COLOR, value: color
			setAttribute name: ATTR_INDEX_SELECTED_BG_COLOR, value: color
		end

		def setBackground(color)
			setAttribute name: ATTR_INDEX_NORMAL_BG_COLOR, value: color
			setAttribute name: ATTR_INDEX_SELECTED_FG_COLOR, value: color
		end

		def addEntries(entries)
			@entries = @entries|entries
		end

		def clearEntries
			@entries = []
		end

		def error(message)
			setForeground "#FF0000"
			setBackground "#000000"
			clearEntries
			setLines 0
			setPrompt message
			show
		end

		def show
			dmenuParams = ''
			@attributes.each_pair{ |key, value|
				if (value == TOOGLE_VALUE)
					dmenuParams = dmenuParams + key + " "
				else

					if value.kind_of?(String)
						dmenuParams = dmenuParams + key + " \"" + value.to_s + "\" " 
					else 
						dmenuParams = dmenuParams + key + " " + value.to_s + " " 
					end
				end
			}

			dmenuCmd = "echo \"#{@entries.join("\n")}\" | dmenu #{dmenuParams.strip!}"
			@choice = %x{#{dmenuCmd}}.chomp


			if choice.length == 0
				@choice = nil
			end

			return @choice	
		end

		def getChoice
			return @choice
		end

		private
		# --------------------------------------------------------------------------------
		def setAttribute(name:, value:)
			@attributes[name] = value
		end

		def getAttribute(name:)
			if @attributes.include?(name)
				return @attributes[name]
			end

			return nil
		end

		def delAttribute(name:) 
			if @attributes.include?(name)
				@attributes.delete(name)
			end
		end

  		attr_accessor :attributes, :entries, :choice
	end
end