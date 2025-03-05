io.stdout:setvbuf("no")
local lume = require("lume")

function love.load()

end

function love.update(dt)

end

function love.keypressed(key)
	if key == "f1" then
		saveGame()
	elseif key == "f2" then
		loadGame()
	elseif key == "f3" then
		clearDataAndRestart()
	end
end

function saveGame()
	local data = {x = 123, y = 456}
	local serialized = lume.serialize(data)
	print(serialized)
	love.filesystem.write("savedata.txt", serialized)
end

function loadGame()
	local file_name = "savedata.txt"
	if love.filesystem.getInfo(file_name) then
		file = love.filesystem.read(file_name)
		local deserialized = lume.deserialize(file)
		print(deserialized.x, deserialized.y)
	end
end

function clearDataAndRestart()
	love.filesystem.remove("savedata.txt")
	love.event.quit("restart")
end
	

function love.draw()
    love.graphics.print("Hello World!", 100, 100)
end

print("Console output is working as intended!")
