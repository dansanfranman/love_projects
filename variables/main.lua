io.stdout:setvbuf("no")

function love.draw()
    love.graphics.print("Hello World!", 100, 100)
end

a = 5
b = 3
print(a + b)

print("hello, " .. a .. " that was a and this is b: " .. b)
