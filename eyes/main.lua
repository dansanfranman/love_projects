io.stdout:setvbuf("no")
local Eye = require("eye")
local left, right

function love.load()
	left = Eye({red = 0, green = 1, blue = 0}, "left")
	right = Eye({red = 0, green = 1, blue = 0}, "right")
end

function love.update(dt)
	left:update(dt)
	right:update(dt)
end

function love.draw()
	left:draw()
	right:draw()
end
