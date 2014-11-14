local tracks
local masterVolume = 0.4

local trackData = {
    "01.wav",
    "02.wav",
    "03.wav",
}

local function load()
    tracks = {}
    for _, filename in ipairs(trackData) do
        local track = love.audio.newSource("music/" .. filename, "static")
        track:setVolume(0.0)
        track:setPitch(1.0) -- (0.5 = one octave lower)
        track:setLooping(true)
        tracks[#tracks + 1] = track
    end

    tracks[1]:setVolume(masterVolume)
    
    for i, track in ipairs(tracks) do
        track:play()
    end
end

local function setTrackVolumes(...)
    local arg = {...}
    for i, v in ipairs(arg) do
        tracks[i]:setVolume(v * masterVolume)
    end
end

local function setTrackPreset(preset)
    if preset == "machinegun" then
        setTrackVolumes(1, 0, 0)
    elseif preset == "grenade" then
        setTrackVolumes(0, 1, 0)
    elseif preset == "bomb" then
        setTrackVolumes(0, 0, 1)
    end
end


local timer = 0

local function update(dt)
    --[[
    timer = timer + dt
    local interval = 15
    if timer >= interval then
        local vol = {}
        for i = 1,8 do vol[i] = math.random() end
        timer = timer - interval
        setTrackVolumes(vol[1], vol[2], vol[3], vol[4], vol[5], vol[6], vol[7], vol[8])
    end
    --]]
end

load()

return {
    load = load,
    update = update,
    setTrackVolumes = setTrackVolumes,
    setTrackPreset = setTrackPreset,
}