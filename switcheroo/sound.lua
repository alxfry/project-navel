require "libs/slam"

local soundData = {
    alarm =     { file = "alarm 01 jay.wav" },
    birdshoot = { file = "bird shoot 01 jay.wav", volume = 0.3 },
    blip =      { file = "blip 01 jay.wav" },
    bomb =      { file = "bomb 01 jay.wav", volume = 0.5 },
    cannon =    { file = "cannon 01 jay.wav", volume = 0.35 },
    gameover =  { file = "hit 01 jay.wav", volume = 0.3 },
    death =     { file = "peitsch 01 jay.wav", volume = 0.8 },
    spawn =     { file = "power up 01 jay.wav", volume = 0.3 },
    shoot =     { file = "shoot 01 jay.wav", volume = 0.05 },
    step =      { file = "step 01 jay.wav", loop = true, volume = 0.0 },
    switch =    { file = "switch 01 jay.wav" },
    swoosh =    { file = "swoosh 01 jay.wav", volume = 0.3 },
}

local function load()
    for key, data in pairs(soundData) do
        local source = love.audio.newSource("sound/" .. data.file, "static")
        source:setVolume(data.volume or 1)
        source:setPitch(data.pitch or 1)
        source:setLooping(data.loop)
        soundData[key].source = source
    end
end

local function play(sound)
    return soundData[sound].source:play()
end

local function stop(sound)
    soundData[sound].source:stop()
end

local function update(dt)
end

load()

return {
    load = load,
    update = update,
    play = play,
    stop = stop,
}