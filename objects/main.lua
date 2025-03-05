io.stdout:setvbuf("no")

function love.load()
	listOfRectangles = {}
end

function createRect()
	rect = {}
	rect.x = 100
	rect.y = 100
	rect["width"] = 70
	rect.width = 80
	rect.height = 90

	rect.speed = 100

	table.insert(listOfRectangles, rect)
end

function love.keypressed(key)
	if key == "space" then
		createRect()
	end
end

function love.update(dt)
	for index, rect in ipairs(listOfRectangles) do
		rect.x = rect.x + rect.speed * dt
	end
end

function love.draw()
	for i,v in ipairs(listOfRectangles) do
		love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
	end
end

print("Console output is working as intended!")
