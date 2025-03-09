local Object = require("classic")
local Eye = Object.extend(Object)

local min_width, min_height, screen_width, screen_height

function Eye:new(colour, position)
	self.colour = colour
	self.radius = 80
	if position == "left" then
		self.x = -100
	else
		self.x = 100
	end

	self.pupilPositionX = 0
	self.pupilPositionY = 0

	screen_width = love.graphics.getWidth()
	screen_height = love.graphics.getHeight()

	min_width = screen_width * 0.5
	min_height = screen_height * 0.5
end

function Eye:update(dt)
	local mouse_x, mouse_y = love.mouse.getPosition()
	
	self.pupilPositionX = 20 * (mouse_x - min_width) / (screen_width - min_width)
	self.pupilPositionY = 20 * (mouse_y - min_height) / (screen_height - min_height)

	mouse_x = mouse_x - 0.5 
	mouse_y = mouse_y - 0.5

end

function Eye:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.circle("fill", love.graphics.getWidth() * 0.5 + self.x, love.graphics.getHeight() * 0.5, self.radius)
	love.graphics.setColor(self.colour.red, self.colour.green, self.colour.blue)
	love.graphics.circle("fill", love.graphics.getWidth()  * 0.5 + self.x + self.pupilPositionX, love.graphics.getHeight() * 0.5 + self.pupilPositionY, self.radius * 0.25)
end

return Eye
