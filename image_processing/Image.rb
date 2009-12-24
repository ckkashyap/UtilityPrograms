class Image
	attr_accessor :width,:height

	def initialize(fileName)
		@fileName=fileName
		read
	end

	def read
		File.open(@fileName,"r") do |file|
			file.binmode
			raise "Not a PNM file" unless /^P6$/.match(file.gets)
			loop do
				line=file.gets
				next if /^#/
				if /^\d+ \d+/.match(line)
					(@width,@height)=line.split(/ /).map! {|e| e.to_i}
				else
					break
				end
			end
			@buffer=file.read(@width*@height*3)
		end
	end

	def write(fileName=@fileName)
		File.open(fileName,"w") do |file|
			file.binmode
			file.puts "P6"
			file.puts "#{@width} #{@height}"
			file.puts "255"
			file.write @buffer
		end
	end

	def []=(x,y,v)
		offset=@width*3*y + x*3
		@buffer[offset,3]=v
	end

	def [](x,y)
		offset=@width*3*y + x*3
		return @buffer[offset,3]
	end

	def self.normalizeColor(c)
		c=0 if c<0
		c=255 if c>255
		c
	end

end
