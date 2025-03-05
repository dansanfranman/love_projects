io.stdout:setvbuf("no")
require("example")

function love.load()
	print(test)
end

function love.update(dt)
	abc = "xyz"
end

function love.draw()
	print(abc)
    love.graphics.print("Hello World!", 100, 100)
end
