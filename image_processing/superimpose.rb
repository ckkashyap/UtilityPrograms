require 'Image'

def superimpose(image1,image2,strength,ox=0,oy=0)
	strengthInverse=1-strength
	image2.width.times do |x|
		image2.height.times do |y|
			next if (y+oy >= image1.height || x+ox >= image1.width)
			imageColor=image2[x,y]
			color=image1[x+ox,y+oy]
			(rc,gc,bc)=color.unpack("C*")
			(ri,gi,bi)=imageColor.unpack("C*")
			next if ri==255 && gi==255 && bi==255

			(red,blue,green)=[[ri,rc],[gi,gc],[bi,bc]].map! do |i|
				Image.normalizeColor (strength*i[0] + strengthInverse*i[1])
			end

			image1[x+ox,y+oy]=[red,green,blue].pack("C*")
		end
	end
end



arguments={}
ARGV.each do |arg|
	(key,val)=arg.split(/=/)
	arguments[key]=val
end

inputImage=arguments["input"] 
superImposeImage=arguments["superimpose"] 
outputImage=arguments["output"] || "out.pnm"
percentage=(arguments["%"] || "30").to_i/100.0
ox=arguments["offset_x"].to_i || 0
oy=arguments["offset_y"].to_i || 0


image=Image.new(inputImage)
transparency=Image.new(superImposeImage)

superimpose(image,transparency,percentage,ox,oy)
image.write outputImage

