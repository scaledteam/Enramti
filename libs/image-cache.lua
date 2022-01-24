IMAGE_CACHE_SIZE = 6
imageCacheCount = 0
imageCacheOrder = {}
imageCacheByName = {}

function changeImageBufferSize(newSize)
	while imageCacheCount > newSize do
		local removeFilename = table.remove(imageCacheOrder, 1).filename
		--imageCacheByName[removeFilename]:release()
		imageCacheByName[removeFilename] = nil
		
		imageCacheCount = imageCacheCount - 1
	end
	
	collectgarbage()
	collectgarbage()
	
	IMAGE_CACHE_SIZE = newSize
end

function getImage(category, name)
	local fullPath = category .. "/" .. name .. ".png"
	
	if imageCacheByName[filename] ~= nil then
		return imageCacheByName[filename].image
	elseif love.filesystem.getInfo(fullPath) == nil then
		return newImageFromCache(category .. "/fall.png")
	else
		return newImageFromCache(fullPath)
	end
end

function addImageToCache(filename, image)
	if imageCacheByName[filename] == nil then
		if imageCacheCount > IMAGE_CACHE_SIZE then
			local removeFilename = table.remove(imageCacheOrder, 1).filename
			--imageCacheByName[removeFilename]:release()
			imageCacheByName[removeFilename] = nil
			
			collectgarbage()
			collectgarbage()
		else
			imageCacheCount = imageCacheCount + 1
		end
		
		local cachedImage = {
			image = image,
			filename = filename
		}
		
		imageCacheByName[filename] = cachedImage
		table.insert(imageCacheOrder, cachedImage)
	end
end

function newImageFromCache(filename)
	if imageCacheByName[filename] == nil then
		local image = love.graphics.newImage(filename)
		addImageToCache(filename, image)
		return image
	else
		return imageCacheByName[filename].image
	end
end