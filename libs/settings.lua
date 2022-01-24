settings = {}

function settingsSave()
	love.filesystem.write("settings", binser.serialize(settings))
end

function settingsLoad()
	if love.filesystem.getInfo("settings") ~= nil then
		local content = love.filesystem.read("settings")
		settings = binser.deserialize(content)[1]
		
		if settings.version == 1 then
			return
		end
	end
	
	local osString = love.system.getOS()
	
	if osString == "Android" or osString == "iOS" then
		settings = {
			version = 1,
			soundAmbientVolume = 60,
			soundEffectVolume = 60,
			soundMusicVolume = 60,
			fullscreen = false,
			textAutoread = false,
			smoothTextSpeed = 100,
			fpsMax = 60,
			CLEARANCE = 4,
			FONT1_SIZE = 5,
			FONT2_SIZE = 10,
			linesInText = 4
		}
	else
		settings = {
			version = 1,
			soundAmbientVolume = 60,
			soundEffectVolume = 60,
			soundMusicVolume = 60,
			fullscreen = false,
			textAutoread = false,
			smoothTextSpeed = 100,
			fpsMax = 60,
			CLEARANCE = 3,
			FONT1_SIZE = 4,
			FONT2_SIZE = 6,
			linesInText = 3
		}
	end
	
	settingsSave()
end