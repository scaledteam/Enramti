local game = {
	objDraw = {},
	objKeys = {},
	objMouse = {}
}
game.sizeY = settings.linesInText * FONT1_HEIGHT + 2 * CLEARANCE
game.posY = 1 - game.sizeY

game.posX = 0.15
--game.posX = game.sizeY / w * h
game.sizeX = 1 - game.posX * 2

function game.load()
	lg.setFont(font1)
	
	if thisState ~= states.pause then
		smoothTextStart()
	end
	
	if preloadPos ~= thisAreaId then
		preloadPos = thisAreaId - 1
		preloadLastPos = thisAreaId
		preloadLoadedCount = 0
	end
	
	thisState = game
	setStates()
end

-- Preload logic
PRELOAD_MAX = math.floor(IMAGE_CACHE_SIZE * 0.6)
preloadPos = 0
preloadLastPos = 0
preloadLoadedCount = 0

function preloadMap()
	if thisAreaId < preloadPos then
		preloadPos = thisAreaId
		preloadCount = thisAreaId
	
	elseif thisAreaId > preloadPos then
		preloadPos = thisAreaId
			
		if MAP[preloadPos].background ~= nil then
			--print("delete backgrounds/" .. MAP[preloadPos].background)
			
			preloadLoadedCount = preloadLoadedCount - 1
		end
			
		if MAP[preloadPos].glitch ~= nil then
			--print("delete glitch/" .. MAP[preloadPos].background)
			
			preloadLoadedCount = preloadLoadedCount - 1
		end
		
		if MAP[preloadPos].characters ~= nil then
			for i, character in pairs(MAP[preloadPos].characters) do
				--print("delete characters/" .. character.image)
				
				preloadLoadedCount = preloadLoadedCount - 1
			end
		end
		
		while preloadLoadedCount < PRELOAD_MAX and preloadLastPos < MAP_COUNT do
			preloadLastPos = preloadLastPos + 1
			
			if MAP[preloadLastPos].background ~= nil then
				preloadLoadedCount = preloadLoadedCount + 1
				
				--print("load backgrounds/" .. MAP[preloadLastPos].background)
				preloadImageSafe("backgrounds", MAP[preloadLastPos].background)
			end
			
			if MAP[preloadLastPos].glitch ~= nil then
				preloadLoadedCount = preloadLoadedCount + 1
				
				--print("load glitch/" .. MAP[preloadLastPos].background)
				preloadImageSafe("backgrounds", MAP[preloadLastPos].glitch)
			end
			
			if MAP[preloadLastPos].characters ~= nil then
				for i, character in pairs(MAP[preloadLastPos].characters) do
					preloadLoadedCount = preloadLoadedCount + 1
					
					--print("load characters/" .. character.image)
					preloadImageSafe("characters", character.image)
				end
			end
		end
	end
end


-- Fast text
fastText = false
fastTextUpdate = 0
FAST_TEXT_INTERVAL = 1 / 25

function fastTextLogic()
	if fastText then
		while systime > fastTextUpdate do
			fastTextUpdate = fastTextUpdate + FAST_TEXT_INTERVAL
			
			if chooses == nil and thisAreaId < MAP_COUNT then
				setNextArea(findNextId())
			
				thisAreaText = thisArea.text
				thisAreaTextSmooth = false
			else
				fastText = false
				break
			end
		end
	end
end

-- Events
function game.draw()
	--[[for i, func in pairs(game.objDraw) do
		func()
	end]]--
	for i=1, #game.objDraw do
		game.objDraw[i]()
	end
	
	-- Fast text
	fastTextLogic()
	
	-- Preload logic
	preloadMap()
end

function interruptCheck()
	-- Delete glitch
	if glitchImage ~= nil then
		glitchImage = nil
		textEnable = true
		return true
	end
	
	-- Enable text if disabled
	if not textEnable then
		textEnable = true
		textDisableEnd = 0
		return true
	end
	
	-- Fast text
	if fastText then
		fastText = false
		return true
	end
	
	return false
end

function game.mousepressed(x, y)
	mouseSet(x, y)
	
	if interruptCheck() then
		return
	end
	
	for i=1, #game.objMouse do
		if game.objMouse[i](mouseX, mouseY) then
			break
		end
	end
	--[[for i, func in pairs(game.objMouse) do
		if func(mouseX, mouseY) then
			break
		end
	end]]--
end

function game.keypressed(key)
	if interruptCheck() then
		return
	end
	
	for i=1, #game.objKeys do
		game.objKeys[i](key)
	end
	--[[for i, func in pairs(game.objKeys) do
		func(key)
	end]]
end

function game.wheelmoved(x, y)
	-- Next area
	if y < 0 then
		setNextArea(findNextId())
		
		thisAreaText = thisArea.text
	-- Prev area
	elseif y > 0 then
		prevArea()
		
		thisAreaText = thisArea.text
	end
end

return game