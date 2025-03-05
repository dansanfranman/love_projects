io.stdout:setvbuf("no")
local myImage, width, height

function love.load()
	myImage = love.graphics.newImage("img/sheep.png")
	width = myImage:getWidth()
	height = myImage:getHeight()	

	love.graphics.setBackgroundColor(1, 1, 1)
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(1, 0.78, 0.15, 0.5)
	love.graphics.draw(myImage, 100, 100, 0, 2, 2, width*0.5, height*0.5)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(myImage, 200, 100)
end
