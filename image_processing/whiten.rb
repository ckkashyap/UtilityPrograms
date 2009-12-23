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


	def whiten
		px=@width/2
		py=@height/2
		max_distance=Math.sqrt((px*px) + (py*py))/1.1
		max_distance=@height/2-5
		@width.times do |x|
			@height.times do |y|
				distance=Math.sqrt((x-px)*(x-px) + (y-py)*(y-py))
				fraction=distance/max_distance
				oneMinusFraction=1-fraction
				color=self[x,y]
				(rc,gc,bc)=color.unpack("C*")
				rc=255*fraction+rc*oneMinusFraction
				gc=255*fraction+gc*oneMinusFraction
				bc=255*fraction+bc*oneMinusFraction

				rc=0 if rc<0
				rc=255 if rc>255
				gc=0 if gc<0
				gc=255 if gc>255
				bc=0 if bc<0
				bc=255 if bc>255

				
				self[x,y]=[rc,gc,bc].pack("C*")
			end
		end
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

				ri=255-ri
				gi=100-gi
				red=strength*ri+strengthInverse*rc
				green=strength*gi+strengthInverse*gc
				blue=strength*bi+strengthInverse*bc
				red=255 if red > 255
				green=255 if green > 255
				blue=255 if blue > 255
				red=0 if red < 0
				green=0 if green < 0
				blue=0 if blue < 0
				self[x,y]=[red,green,blue].pack("C*")
			end
		end
	end
end



# To superimpose image1 on image2 and produce image3
# ruby superimpose.rb image1 image2 image3 percentage

image1=ARGV[0]
image2=ARGV[1] || "out.pnm"

image=Image.new(image1)
image.whiten
image.write image2

