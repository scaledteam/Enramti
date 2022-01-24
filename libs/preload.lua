preloadThread = nil
preloadChannelInput = nil
preloadChannelOutput = nil

function preloadStart()
	local threadCode = [[
	love.timer = require("love.timer")
	love.image = require("love.image")
	require("libs/fps-limiter")
	
	local channelInput = love.thread.getChannel("commands")
	local channelOutput = love.thread.getChannel("data")
	
	while true do
		fpsLimiterStart()
		
		if channelInput:getCount() > 0 then
			while channelInput:getCount() > 0 do
				local filename = channelInput:pop()
			
				if filename ~= "exit" then
					local image = love.image.newImageData(filename)
			
					channelOutput:push(filename)
					channelOutput:push(image)
				else
					return
				end
			end
			
			collectgarbage()
			collectgarbage()
		end
		
		fpsLimiterEnd()
	end
	]]
	
	preloadThread = love.thread.newThread(threadCode)
	preloadThread:start()
	preloadChannelInput = love.thread.getChannel("data")
	preloadChannelOutput = love.thread.getChannel("commands")
end

function preloadImage(filename)
	if imageCacheByName[filename] == nil then
		preloadChannelOutput:push(filename)
	end
end

function preloadImageSafe(category, name)
	local fullPath = category .. "/" .. name .. ".png"
	
	if love.filesystem.getInfo(fullPath) == nil then
		fullPath = category .. "/fall.png"
	end
	
	preloadImage(fullPath)
end

function preloadSendToCache()
	if preloadChannelInput:getCount() > 0 then
		local filename = preloadChannelInput:pop()
		local image = preloadChannelInput:pop()
		
		addImageToCache(filename, love.graphics.newImage(image))
	end
end