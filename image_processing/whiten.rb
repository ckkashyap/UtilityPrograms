require 'Image'

def whiten(image)
	px=image.width/2
	py=image.height/2
	max_distance=Math.sqrt((px*px) + (py*py))/1.1
	max_distance=image.height/2-5
	image.applyFunction do |x,y,r,g,b|
		distance=Math.sqrt((x-px)*(x-px) + (y-py)*(y-py))
		fraction=distance/max_distance
		oneMinusFraction=1-fraction

		(r,g,b)=[r,g,b].map! do |c| 
			255*fraction + c*oneMinusFraction
		end
		
		[r,g,b]
	end
end


image1=ARGV[0]
image2=ARGV[1] || "out.pnm"

image=Image.new(image1)
whiten(image)
image.write image2

