io.stdout:setvbuf("no")

local Rectangle = require("rectangle")
local Circle = require("circle")

function love.load()
	r1 = Rectangle(100, 200, 300, 400)
	c1 = Circle(50, 0, 100)
end

function love.update(dt)
	r1:update(dt)
	c1:update(dt)
end

function love.draw()
	r1:draw()
	c1:draw()
end
