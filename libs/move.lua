mapParts = require("libs/map-parts")

function thingGet()
	if thisArea.get ~= nil then
		if things[thisArea.get] == nil then
			things[thisArea.get] = 1
		else
			things[thisArea.get] = things[thisArea.get] + 1
		end
	end
	if thisArea.unget ~= nil then
		if things[thisArea.unget] > 1 then
			things[thisArea.unget] = things[thisArea.get] - 1
		else
			things[thisArea.unget] = nil
		end
	end
end

function thingUnget()
	if thisArea.get ~= nil then
		if things[thisArea.get] > 1 then
			things[thisArea.get] = things[thisArea.get] - 1
		else
			things[thisArea.get] = nil
		end
	end
	if thisArea.unget ~= nil then
		if things[thisArea.unget] == nil then
			things[thisArea.unget] = 1
		else
			things[thisArea.unget] = things[thisArea.get] + 1
		end
	end
end

function choosesLoad()
	if thisArea.chooses ~= nil then
		chooses = thisArea.chooses
		choosesCount = #chooses
	else
		chooses = nil
	end
end

function findPrevField(fieldName)
	local id = thisAreaId - 1
	
	while id > 0 and MAP[id][fieldName] == nil do
		if path[id] ~= nil then
			id = path[id]
		else
			id = id - 1
		end
		
		if MAP[id] == nil then
			return 0
		end
	end
	
	return id
end

function findAreaByName(label)
	local i = thisAreaId
	while MAP[i].label ~= label do
		i = i + 1
		if i > MAP_COUNT then
			return 0
		end
	end
	
	return i
end

function setArea(id)
	thisAreaId = id
	thisArea = MAP[id]
	
	-- Load parts
	for mapPartName, mapPart in pairs(mapParts) do
		if thisArea[mapPartName] ~= nil then
			mapPart.loadThis()
		else
			mapPart.loadPrev()
		end
	end
	
	-- Chooses
	choosesLoad()
end

function findNextId()
	-- Check end of game
	if thisArea.gameover == true then
		return -1
	end
	
	-- Find target id (next or choosed)
	local id = 0
	
	-- Check goto condition
	if thisArea.gotoIfExist ~= nil then
		if things[thisArea.gotoIfExist[1]] ~= nil and things[thisArea.gotoIfExist[1]] > 0 then
			id = findAreaByName(thisArea.gotoIfExist[2])
		end
	end
	
	-- Else
	if id == 0 then
		-- Goto with text
		if thisArea.goto ~= nil then
			id = findAreaByName(thisArea.goto)
		else
			id = thisAreaId + 1
			
			-- Goto without text
			while MAP[id].goto ~= nil and MAP[id].text == nil do
				id = findAreaByName(MAP[id].goto)
			end
		end
	end
	
	-- Check end of map
	if id > MAP_COUNT then
		setState(STATE_MENU)
		return 0
	end
	
	return id
end

function prevArea()
	if thisAreaId > 1 then
		-- Find prev id
		local id = thisAreaId - 1
		
		if path[thisAreaId] ~= nil then
			id = path[thisAreaId]
			path[thisAreaId] = nil
			pathCounter = pathCounter - 1
		end
		
		-- Load parts
		for mapPartName, mapPart in pairs(mapParts) do
			if thisArea[mapPartName] ~= nil then
				mapPart.loadPrev()
			end
		end
		
		-- Unget if move back
		thingUnget()
	
		-- Varriables
		thisArea = MAP[id]
		thisAreaId = id
	
		-- Chooses
		choosesLoad()
	end
end

function setNextArea(id)
	if id > 0 then
		-- Remember path
		if thisAreaId + 1 < id then
			pathCounter = pathCounter + 1
			path[id] = thisAreaId
		end
	
		-- Varriables
		thisArea = MAP[id]
		thisAreaId = id
		
		-- Load parts
		for mapPartName, mapPart in pairs(mapParts) do
			if thisArea[mapPartName] ~= nil then
				mapPart.loadThis()
			end
		end
	
		-- Chooses
		choosesLoad()
		
		-- Get thing
		thingGet()
	
		-- Glitch check
		if not fastText and thisArea.glitch ~= nil then
			--glitchImage = newImageFromCache("backgrounds/" .. thisArea.glitch .. ".png")
			glitchImage = getImage("backgrounds", thisArea.glitch)
			
			glitchEnd = systime + 1.5
		end
		
		-- Sound
		if thisArea.soundAmbient ~= nil then
			soundAmbientStart(thisArea.soundAmbient)
		end
	elseif id == -1 then
		states.menu.load()
	else
		print("Wrong name of goto or other error.")
	end
end
