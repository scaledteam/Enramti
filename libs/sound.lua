soundAmbient = nil
soundMusic = nil
soundEffect = nil

function soundAmbientStart(filename)
	if soundAmbient ~= nil then
		love.audio.stop(soundAmbient)
	end
	
	if filename ~= "" then
		fullPath = "sounds/" .. filename .. ".mp3"
		if love.filesystem.getInfo(fullPath) ~= nil then
			soundAmbient = love.audio.newSource(fullPath, "stream")
			soundAmbient:setVolume(settings.soundAmbientVolume / 100)
			soundAmbient:setLooping(true)
			love.audio.play(soundAmbient)
		end
	end
end

function soundEffectStart(filename)
	if soundEffect ~= nil then
		love.audio.stop(soundEffect)
	end
	
	if filename ~= "" then
		fullPath = "sounds/" .. filename .. ".mp3"
		if love.filesystem.getInfo(fullPath) ~= nil then
			soundEffect = love.audio.newSource(fullPath, "stream")
			soundEffect:setVolume(settings.soundEffectVolume / 100)
			love.audio.play(soundEffect)
		end
	end
end

function soundMusicStart(filename)
	if soundMusic ~= nil then
		love.audio.stop(soundMusic)
	end
	
	if filename ~= "" then
		fullPath = "sounds/" .. filename .. ".mp3"
		if love.filesystem.getInfo(fullPath) ~= nil then
			soundMusic = love.audio.newSource(fullPath, "stream")
			soundMusic:setVolume(settings.soundMusicVolume / 100)
			soundMusic:setLooping(true)
			love.audio.play(soundMusic)
		end
	end
end