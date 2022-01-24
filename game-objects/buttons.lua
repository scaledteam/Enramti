-- Back button
table.insert(states.game.objDraw, function ()
	if textEnable then
		backbutton.draw()
		--[[local size = (FONT1_HEIGHT + CLEARANCE) * 0.5 * h
		lg.setColor(COLOR_LOW)
		lg.circle("fill", size, size, size)
		lg.circle("line", size, size, size)
		lg.setColor(COLOR_TEXT)
		lg.printf("←", 0, CLEARANCE / 2 * h, size * 2, "center")]]--
	end
end)

table.insert(states.game.objMouse, function (x, y)
	if backbutton.mousepressed() then
		states.pause.load()
		return true
	else
		return false
	end
end)

table.insert(states.game.objKeys, function (key)
	if key == "escape" then
		states.pause.load()
	end
end)


-- Fast text button
table.insert(states.game.objDraw, function ()
	if textEnable then
		local size = (FONT1_HEIGHT + CLEARANCE)
		lg.setColor(COLOR_LOW)
		--lg.circle("fill", (1.5 * size + CLEARANCE) * h, 0.5 * size * h, 0.5 * size * h)
		--lg.circle("line", (1.5 * size + CLEARANCE) * h, 0.5 * size * h, 0.5 * size * h)
		lg.rectangle("fill", (size + CLEARANCE / 2) * h, 0, size * h, size * h)
		lg.setColor(COLOR_TEXT)
		lg.printf("»", (size + CLEARANCE / 2) * h, CLEARANCE / 2 * h, size * h, "center")
	end
end)

table.insert(states.game.objMouse, function (x, y)
	local size = (FONT1_HEIGHT + CLEARANCE)
	if y < size and (size + CLEARANCE / 2) / w * h < x and x < (size * 2 + CLEARANCE / 2) / w * h then
		fastText = true
		fastTextUpdate = systime
		return true
	else
		return false
	end
end)

table.insert(states.game.objKeys, function (key)
	if key == "up" then
		fastText = true
		fastTextUpdate = systime
	end
end)


-- Fast text button
--[[table.insert(states.game.objDraw, function ()
	if textEnable then
		local size = (FONT1_HEIGHT + CLEARANCE)
		lg.setColor(COLOR_LOW)
		lg.rectangle("fill", (thisState.posX + thisState.sizeX) * w - size * h, (thisState.posY - size) * h, size * h, size * h)
		lg.setColor(COLOR_TEXT)
		lg.printf("»", (thisState.posX + thisState.sizeX) * w - size * h, (thisState.posY - size) * h, size * h, "center")
	end
end)

table.insert(states.game.objMouse, function (x, y)
	local size = (FONT1_HEIGHT + CLEARANCE)
	if y < size and (size + CLEARANCE) / w * h < x and x < (size * 2 + CLEARANCE ) / w * h then
		fastText = true
		fastTextUpdate = systime
		return true
	else
		return false
	end
end)]]--