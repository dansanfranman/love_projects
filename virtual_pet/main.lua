io.stdout:setvbuf("no")
local Cultist = require("cultist")
local screen_width, screen_height

function love.load()
	setWindow()
	cultist = Cultist(screen_width, screen_height)
end

function love.update(dt)
	cultist:update(dt)
end

function love.draw()
	cultist:draw()
end

function setWindow()
	love.window.setMode(0, 0, {fullscreen = false})
	screen_width = love.graphics.getWidth()
	screen_height = love.graphics.getHeight()

	love.window.setMode(screen_width * 0.2, screen_height, {fullscreen = false, x = 0})
	love.graphics.setBackgroundColor(1, 1, 1)
end
