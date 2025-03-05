io.stdout:setvbuf("no")

function love.load()
	image = love.graphics.newImage("img/jump.png")
	image2 = love.graphics.newImage("img/jump_2.png")

	frames = {}
	frames2 = {}

	local width = image:getWidth()
	local height = image:getHeight()

	local width2 = image2:getWidth()
	local height2 = image2:getHeight()

	local frame_width = 117
	local frame_height = 233
	local max_frames = 5

	for i=0, 4 do
		table.insert(frames, love.graphics.newQuad(i * frame_width, 0, frame_width, frame_height, width, height))
	end

	for j = 0, 1 do
		for i = 0, 2 do
			if #frames2 == max_frames then
				break
			end
			table.insert(frames2, love.graphics.newQuad(1 + i * (frame_width + 2), 1 + j * (frame_height + 2), frame_width, frame_height, width2, height2))
		end
	end
	currentFrame = 1
end

function love.update(dt)
	currentFrame = currentFrame + 10 * dt

	if currentFrame >= 6 then
		currentFrame = 1
	end
end

function love.draw()
	love.graphics.draw(image, frames[math.floor(currentFrame)], 100, 100)
	love.graphics.draw(image2, frames2[math.floor(currentFrame)], 300, 100)
end
