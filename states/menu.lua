local menu = {
	pos = 0,
	posDraw = 0,
	
	posOld = 0,
	posFrom = 0,
	posChangedTime = 0,
	
	reactEnable = false,
	reactTime = 0
}

menu.posX = CLEARANCE * 2
menu.sizeX = 2.8 * FONT2_HEIGHT

menu.sizeY = FONT2_HEIGHT * 4
menu.posY = (1 - menu.sizeY - CLEARANCE * 2)

function menu.load()
	lg.setFont(font2)
	
	setBackgroundByName("menu")
	
	if thisState == nil then
		w = background:getWidth()
		h = background:getHeight()
	end
	
	if thisState ~= states.list then
		soundMusicStart("menu")
		menu.pos = 0
		menu.posDraw = 0
		
		menu.posOld = 0
		menu.posFrom = 0
		menu.posChangedTime = 0
	end
	
	thisState = menu
	setStates()
end

menu.oldX = 0
menu.oldY = 0

function menu.draw()
	mouseGet()
	
	-- Mouse effects
	if mouseX ~= menu.oldX or mouseY ~= menu.oldY then
		menu.oldX = mouseX
		menu.oldY = mouseY
		
		if mouseInrange(menu.posX, menu.posY, menu.posX + menu.sizeX, menu.posY + menu.sizeY) then
			menu.pos = math.floor((mouseY - menu.posY) / FONT2_HEIGHT)
		end
	end
	
	-- Draw
	lg.setColor(COLOR_LOW)
	lg.rectangle("fill",
		(menu.posX - CLEARANCE) * w, (menu.posY - CLEARANCE) * h,
		(menu.sizeX + CLEARANCE * 2) * w, (menu.sizeY + CLEARANCE * 2) * h
	)
	
	-- moving highlight
	menu.posDraw = menu.posOld - (menu.posOld - menu.posFrom) * 0.000001 ^ (systime - menu.posChangedTime)
	
	if menu.pos ~= menu.posOld then
		menu.posOld = menu.pos
		menu.posFrom = menu.posDraw
		
		menu.posChangedTime = systime
	end
	
	lg.setColor(COLOR_HIGHLIGHT)
	lg.rectangle("fill", (menu.posX - CLEARANCE * 0.5) * w, (menu.posY + FONT2_HEIGHT * menu.posDraw - CLEARANCE * 0.5) * h, (menu.sizeX + CLEARANCE) * w, (FONT2_HEIGHT + CLEARANCE) * h)
	
	lg.setColor(COLOR_TEXT)
	--lg.print("Играть\nСохранения\nНастройки\nВыход", menu.posX * w, (menu.posY * h))
	lg.print("Играть", menu.posX * w, (menu.posY) * h)
	lg.print("Сохранения", menu.posX * w, (menu.posY + FONT2_HEIGHT) * h)
	lg.print("Настройки", menu.posX * w, (menu.posY + FONT2_HEIGHT*2) * h)
	lg.print("Выход", menu.posX * w, (menu.posY + FONT2_HEIGHT*3) * h)
	
	if menu.reactEnable and systime > menu.reactTime then
		menu.reactEnable = false
		menu.react()
	end
end

function menu.react()
	if menu.pos == 0 then
		newGame()
	elseif menu.pos == 1 then
		states.saves.load()
	elseif menu.pos == 2 then
		states.settings.load()
	elseif menu.pos == 3 then
		preloadChannelOutput:push("exit")
		love.event.quit()
	end
end

function menu.mousepressed(x, y, button, istouch)
	mouseSet(x, y)
	
	if mouseInrange(menu.posX, menu.posY, menu.posX + menu.sizeX, menu.posY + menu.sizeY) then
		local posNow = math.floor((mouseY - menu.posY) / FONT2_HEIGHT)
		if menu.pos ~= posNow then
			menu.pos = posNow
			
			menu.reactEnable = true
			menu.reactTime = systime + 0.3
		else
			menu.react()
		end
	end
end

function menu.keypressed(key)
	if key == "return" then
		menu.react()
	elseif key == "up" then
		menu.pos = math.fmod(menu.pos + 3, 4)
	elseif key == "down" then
		menu.pos = math.fmod(menu.pos + 5, 4)
	elseif key == "escape" then
		preloadChannelOutput:push("exit")
		love.event.quit()
	end
end

return menu
