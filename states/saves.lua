local saves = {
	posX = 0.1,
	sizeX = 0.8,
	objects = {},
	lastImageId = 0,
	savesImageChannel = love.thread.getChannel("saves-images")
}

function saves.load()
	lg.setFont(font1)
	
	local files = love.filesystem.getDirectoryItems("saves")
	
	local images = {}
	for i, filename in pairs(files) do
		saves.objects[i] = {
			name = filename,
			draw = saves.listDraw
		}
		images[i] = filename
	end
	
	for i = #files + 1, #saves.objects do
		saves.objects[i] = nil
	end
	
	local threadCode = [[
		love.image = require("love.image")
		
		local imagesList = ...
		local savesImageChannel = love.thread.getChannel("saves-images")
		
		for id, name in pairs(imagesList) do
			local filename = "saves-scr/" .. name .. ".png"
			if love.filesystem.getInfo(filename) ~= nil then
				local image = love.image.newImageData(filename)
				
				savesImageChannel:push(image)
				savesImageChannel:push(id)
			end
		end
	]]
	
	love.thread.newThread(threadCode):start(images)
	
	states.list.height = 0.25 + CLEARANCE * 2
	states.list.distance = states.list.height + CLEARANCE
	states.list.load(saves.objects)
	
	states.saves.lastImageId = 0
end

function saves.listDraw(object, pos)
	if states.saves.savesImageChannel:getCount() > 0 then
		local image = states.saves.savesImageChannel:pop()
		local id = states.saves.savesImageChannel:pop()
		
		states.saves.objects[id].image = lg.newImage(image)
	end
	
	lg.setColor(1, 1, 1, 1)
	if object.image ~= nil then
		lg.draw(
			object.image,
			saves.posX * w, -CLEARANCE * h,
			0,
			states.list.height / object.image:getWidth() * w, states.list.height / object.image:getHeight() * h
		)
	else
		lg.rectangle(
			"fill",
			saves.posX * w, -CLEARANCE * h,
			states.list.height * w, states.list.height * h
		)
	end
	
	lg.print(object.name, (saves.posX + states.list.height + CLEARANCE) * w, 0)
	
	lg.printf(
		"×",
		(saves.posX + saves.sizeX - 0.05) * w, 0,
		0.05 * w,
		"center"
	)
	
	
	if thisState.lightPos == pos and (thisState.lastKey == "return" or thisState.lastKey == "delete") then
		if thisState.lastKey == "return" then
			loadGame("saves/" .. object.name)
		else
			love.filesystem.remove("saves/" .. object.name)
			love.filesystem.remove("saves-scr/" .. object.name .. ".png")
			
			for i = 1, #saves.objects do
				if saves.objects[i] == object then
					table.remove(saves.objects, i)
					savesListCount = savesListCount - 1
					break
				end
			end
		end
		
		thisState.lastKey = nil
		
		return
	end
	
	if thisState.mouseUseReleased and mouseInrange(saves.posX, -CLEARANCE, saves.posX + saves.sizeX, states.list.height - CLEARANCE) then
		if mouseX < (saves.posX + saves.sizeX - 0.05) then
			loadGame("saves/" .. object.name)
		else
			love.filesystem.remove("saves/" .. object.name)
			love.filesystem.remove("saves-scr/" .. object.name .. ".png")
			
			for i = 1, #saves.objects do
				if saves.objects[i] == object then
					table.remove(saves.objects, i)
					savesListCount = savesListCount - 1
					break
				end
			end
		end
	end
end

return saves