def debug(message)
	puts "DEBUG:: #{message}"
end

class Image
	def initialize(fileName)
		@fileName=fileName
		read
	end

	def height
		@height
	end
	def width
		@width
	end

	def read
		debug "Reading #{@fileName}"
		File.open(@fileName,"r") do |file|
			file.binmode
			debug file.gets #P6
			debug file.gets #comment
			line=file.gets
			debug file.gets #255
			(width,height)=line.split(/ /)
			@width=width.to_i
			@height=height.to_i
			debug "Width=#{@width} Height=#{@height}"
			@buffer=file.read(@width*@height*3)
		end
	end

	def write(fileName=@fileName)
		File.open(fileName,"w") do |file|
			file.binmode
			file.puts "P6"
			file.puts "# Comment"
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

	def superimpose(image,strength)
		strengthInverse=1-strength
		image.width.times do |x|
			image.height.times do |y|
				imageColor=image[x,y]
				color=self[x,y]
				(rc,gc,bc)=color.unpack("C*")
				(ri,gi,bi)=imageColor.unpack("C*")
				next if ri==255 && gi==255 && bi==255

				red=strength*ri+strengthInverse*rc
				green=strength*gi+strengthInverse*gc
				blue=strength*bi+strengthInverse*bc
				self[x,y]=[red,green,blue].pack("C*")
			end
		end
	end
end



# To superimpose image1 on image2 and produce image3
# ruby superimpose.rb image1 image2 image3 percentage

image1=ARGV[0]
image2=ARGV[1]
image3=ARGV[2] || "out.pnm"
percentage=ARGV[3] || 50
percentage=percentage/100.0

transparency=Image.new(image1)
image=Image.new(image2)

image.superimpose(transparency,percentage)
image.write image3

