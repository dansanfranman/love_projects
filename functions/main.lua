io.stdout:setvbuf("no")

function love.draw()
    love.graphics.print("Hello World!", 100, 100)
end

function example()
    print("example function call")
end

function example2(parameter)
    print(parameter)
end

function example3()
    return 6
end

example()
example2("jeff")
print(example3())
