module Findex
	class Rofi
		public
		# --------------------------------------------------------------------------------
		def initialize()
			@attributes = Hash.new
			@entries = Array.new
		end

		def addEntries(entries)
			@entries = @entries|entries
		end

		def clearEntries
			@entries = []
		end

		def error(message)
			dmenuCmd = "rofi -config ~/.config/rofi/findex.rasi -e \"#{message}\""
			%x{#{dmenuCmd}}
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

			dmenuCmd = "echo \"#{@entries.join("\n")}\" | rofi -config ~/.config/rofi/findex.rasi -dmenu -window-title \"findex\""
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