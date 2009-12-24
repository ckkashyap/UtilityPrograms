require 'Image'

def superImpose(image1,image2,strength,ox=0,oy=0)
	strengthInverse=1-strength
	image1.applyImage(image2) do |x,y,ri,gi,bi,rc,gc,bc|
		raise "DINGI" if rc.nil?
		(red,blue,green)=[[ri,rc],[gi,gc],[bi,bc]].map! do |i|
			strength*i[0] + strengthInverse*i[1]
		end
		[red,blue,green]
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

superImpose(image,transparency,percentage,ox,oy)
image.write outputImage

