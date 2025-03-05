io.stdout:setvbuf("no")

function love.load()
	Object = require("classic")
	require("rectangle")

	r1 = Rectangle(10, 100, 200, 400)
	r2 = Rectangle()
end

function love.update(dt)
	r1:update(dt) -- variable COLON function -> function(variable)
end

function love.draw()
	r1:draw()
end
