io.stdout:setvbuf("no")

function love.load()
	camera_x = 0
	camera_y = 0
	rect = {
		x = 100,
		y = 100,
		width = 100,
		height = 100
	}
	camera_x = -100
	camera_y = -100

	shakeDuration = 10
end

function love.update(dt)
	if shakeDuration > 0 then
		shakeDuration = shakeDuration - dt
	end
end

function love.draw()
	love.graphics.push() -- save current state
		love.graphics.translate(camera_x + 400, camera_y + 300)
		love.graphics.scale(2)
		love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
	love.graphics.pop() -- retrieve state from before we made changes, no longer need the call to origin() below

	-- love.graphics.origin() -- resets coordinate transforms, doesn't change anything already drawn
	love.graphics.push()
		if shakeDuration > 1 then -- screen shake
			love.graphics.translate(love.math.random(-5, 5), love.math.random(-5, 5))
		end
		love.graphics.rectangle("fill", rect.x, rect.y, rect.width, rect.height)
	love.graphics.pop()
end
