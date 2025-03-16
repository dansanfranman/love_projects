local Object = require("classic")
local Chip = Object:extend()
local scale = 0.25

function Chip:new(value, x, y, font, textColor)
	self.value = value
	self.x = x
	self.y = y
	self.font = font
	self.textColor = textColor

	self.image = love.graphics.newImage("assets/Chips/chips_" .. value .. ".png")
	self.offset = {x = self.image:getWidth() * 0.5, y = self.image:getHeight() * 0.5}
	self.textOffset = {x = self.font:getWidth(self.value) * 0.5, y = self.font:getHeight() * 0.5 + 5}
	self.collider = {radius = 65}
	
	self.isClicked = false
end

function Chip:update(dt, mouseX, mouseY)
	if self.isClicked then
		self.x = mouseX
		self.y =mouseY
	end
end

function Chip:checkCollision(x, y)
	return x >= self.x - self.collider.radius and x <= self.x + self.collider.radius and y >= self.y - self.collider.radius and y <= self.y + self.collider.radius
end

function Chip:clicked()
	self.isClicked = true
end

function Chip:released()
	self.isClicked = false
end

function Chip:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, scale, scale, self.offset.x, self.offset.y)
	love.graphics.setColor(self.textColor)
	love.graphics.print(self.value, self.x, self.y, 0, 1, 1, self.textOffset.x, self.textOffset.y)
	love.graphics.setColor(1, 1, 1, 1)
end

return Chip
