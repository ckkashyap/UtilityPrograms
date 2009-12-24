def debug(message)
	puts "DEBUG:: #{message}"
end

class Image
	attr_accessor :width,:height
	def initialize(fileName)
		@fileName=fileName
		read
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


	def normalize(c)
		c=0 if c<0
		c=255 if c>255
		c
	end

	def superimpose(image,strength,ox=0,oy=0)
		strengthInverse=1-strength
		image.width.times do |x|
			image.height.times do |y|
				imageColor=image[x,y]
				color=self[x+ox,y+oy]
				(rc,gc,bc)=color.unpack("C*")
				(ri,gi,bi)=imageColor.unpack("C*")
				next if ri==255 && gi==255 && bi==255

				(red,blue,green)=[[ri,rc],[gi,gc],[bi,bc]].map! do |i|
					normalize (strength*i[0] + strengthInverse*i[1])
				end

				self[x+ox,y+oy]=[red,green,blue].pack("C*")
			end
		end
	end
end



# To superimpose image1 on image2 and produce image3
# ruby superimpose.rb image1 image2 image3 percentage 
#
arguments={}
ARGV.each do |arg|
	(key,val)=arg.split(/=/)
	arguments[key]=val
end

inputImage=arguments["input"] || (raise "No input image provided")
superImposeImage=arguments["superimpose"] || (raise "No superimpose image provided")
outputImage=arguments["output"] || "out.pnm"
percentage=(arguments["%"] || "50").to_i/100.0
ox=arguments["offset_x"] || 0
oy=arguments["offset_y"] || 0


transparency=Image.new(superImposeImage)
image=Image.new(inputImage)

image.superimpose(transparency,percentage,ox,oy)
image.write outputImage

