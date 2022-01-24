width, height = 0, 0
scale = 0

w, h = 1920, 1080
offsetX, offsetY = 0, 0

background = nil

function computeScale()
	scale = math.min(width / w, height / h)
	if width / height > w / h then
		offsetX = (width - scale * w) / 2
		offsetY = 0
	else
		offsetX = 0
		offsetY = (height - scale * h) / 2
	end
end

backgroundChangeTime = 0
backgroundOld = nil
BACKGROUND_CHANGE_INTERVAL = 0.5

function setBackground(image)
	backgroundOld = background
	background = image
	
	if backgroundOld ~= nil then
		backgroundChangeTime = systime + BACKGROUND_CHANGE_INTERVAL
	end
end

function setBackgroundByName(backgroundName)
	backgroundOld = background
	background = getImage("backgrounds", backgroundName)
	
	if backgroundOld ~= nil then
		backgroundChangeTime = systime + BACKGROUND_CHANGE_INTERVAL
	end
end

function backgroundDraw()
	--love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.draw(background)
	
	if systime < backgroundChangeTime then
		local alpha = (backgroundChangeTime - systime) / BACKGROUND_CHANGE_INTERVAL
		
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(backgroundOld)
		
		love.graphics.setColor(1, 1, 1, 1 - alpha)
		love.graphics.draw(background)
	else
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(background)
	end
end

function drawBlackBorders()
	lg.setColor(0, 0, 0, 1)
	if offsetY ~= 0 then
		lg.rectangle("fill", 0, 0, width, offsetY)
		lg.rectangle("fill", width, height, -width, -offsetY)
	elseif offsetX ~= 0 then
		lg.rectangle("fill", 0, 0, offsetX, height)
		lg.rectangle("fill", width, height, -offsetX, -height)
	end
end
