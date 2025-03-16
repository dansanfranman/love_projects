local Object = require("classic")
local Button = Object.extend(Object)

function Button:new(x, y, width, height, text, color, textColor, font)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.text = text
	self.color = color

	self.hoveredColor = {r = self.color.r - 0.1, g = self.color.g - 0.1, b = self.color.b - 0.1}
	self.drawColor = self.color
	self.textColor = textColor	
	self.textOffset = {x = font:getWidth(self.text), y = font:getHeight()}
end

function Button:checkCollision(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Button:update(dt, mouseX, mouseY)
	if self:checkCollision(mouseX, mouseY) then
		self.drawColor = self.hoveredColor
	else
		self.drawColor = self.color
	end
end

function Button:draw()
	love.graphics.setColor(self.drawColor.r, self.drawColor.g, self.drawColor.b)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 5, 5)
	love.graphics.setColor(self.textColor.r, self.textColor.g, self.textColor.b)
	love.graphics.print(self.text, self.x + (self.width - self.textOffset.x) * 0.5, self.y + (self.height - self.textOffset.y) * 0.5)
	love.graphics.setColor(1, 1, 1)
end

return Button
