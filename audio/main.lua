io.stdout:setvbuf("no")

function love.load()
	song = love.audio.newSource("song.ogg", "stream")
	song:setLooping(true)
	-- method 1
	-- love.audio.play(song)
	-- method 2
	song:play()

	sfx = love.audio.newSource("sfx.ogg", "static")
end

function love.keypressed(key)
	if key == "space" then
		sfx:play()
	end
end

function love.draw()
    love.graphics.print("Hello World!", 100, 100)
end
