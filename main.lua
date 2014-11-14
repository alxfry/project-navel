function love.load(arg)
    if arg[3] == "hymn" then
        require "hymn.main"()
    else
        require "minionmaster.main"()
    end
end
