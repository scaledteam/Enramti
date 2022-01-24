local pause = {
	pos = 0,
	posDraw = 0,
	
	posOld = 0,
	posFrom = 0,
	posChangedTime = 0,
	
	reactEnable = false,
	reactTime = 0
}

pause.sizeX = 2.8 * FONT2_HEIGHT
pause.posX = (1 - pause.sizeX) * 0.5

pause.sizeY = 5 * FONT2_HEIGHT
pause.posY = (1 - pause.sizeY) * 0.5

pause.background = nil

function pause.load()
	lg.setFont(font2)
	
	if thisState == states.game then
		pause.background = background
		
		pause.pos = 0
		pause.posDraw = 0
		
		pause.posOld = 0
		pause.posFrom = 0
		pause.posChangedTime = 0
	elseif pause.background ~= nil then
		setBackground(pause.background)
	end
	
	thisState = pause
	setStates()
end

pause.oldX = 0
pause.oldY = 0

function pause.draw()
	mouseGet()
	
	-- Mouse effects
	if mouseX ~= pause.oldX or mouseY ~= pause.oldY then
		pause.oldX = mouseX
		pause.oldY = mouseY
		
		if mouseInrange(pause.posX, pause.posY, pause.posX + pause.sizeX, pause.posY + pause.sizeY) then
			pause.pos = math.floor((mouseY - pause.posY) / FONT2_HEIGHT)
		end
	end
	
	-- Draw
	lg.setColor(COLOR_LOW)
	lg.rectangle("fill", 
		(pause.posX - CLEARANCE) * w, (pause.posY - CLEARANCE) * h,
		(pause.sizeX + 2 * CLEARANCE) * w, (pause.sizeY + 2 * CLEARANCE) * h
	)
	
	-- Highlight
	pause.posDraw = pause.posOld - (pause.posOld - pause.posFrom) * 0.000001 ^ (systime - pause.posChangedTime)
	
	if pause.pos ~= pause.posOld then
		pause.posOld = pause.pos
		pause.posFrom = pause.posDraw
		
		pause.posChangedTime = systime
	end
	
	lg.setColor(COLOR_HIGHLIGHT)
	lg.rectangle("fill", (pause.posX - CLEARANCE * 0.5) * w, (pause.posY + FONT2_HEIGHT * pause.posDraw - CLEARANCE * 0.5) * h, (pause.sizeX + CLEARANCE) * w, (FONT2_HEIGHT + CLEARANCE) * h)
	
	lg.setColor(COLOR_TEXT)
	--[[lg.printf(
		"Продолжить\nСохраниться\nСохранения\nНастройки\nВыйти",
		pause.posX * w, pause.posY * h,
		pause.sizeX * w,
		"center"
	)]]--
	lg.printf(
		"Продолжить",
		pause.posX * w, pause.posY * h,
		pause.sizeX * w,
		"center"
	)
	lg.printf(
		"Сохраниться",
		pause.posX * w, (pause.posY + FONT2_HEIGHT) * h,
		pause.sizeX * w,
		"center"
	)
	lg.printf(
		"Сохранения",
		pause.posX * w, (pause.posY + FONT2_HEIGHT*2) * h,
		pause.sizeX * w,
		"center"
	)
	lg.printf(
		"Настройки",
		pause.posX * w, (pause.posY + FONT2_HEIGHT*3) * h,
		pause.sizeX * w,
		"center"
	)
	lg.printf(
		"Выйти",
		pause.posX * w, (pause.posY + FONT2_HEIGHT*4) * h,
		pause.sizeX * w,
		"center"
	)
	
	if pause.reactEnable and systime > pause.reactTime then
		pause.reactEnable = false
		pause.react()
	end
end

function pause.react()
	if pause.pos == 0 then
		states.game.load()
		pause.background = nil
	elseif pause.pos == 1 then
		states.game.load()
		saveGame()
		pause.background = nil
	elseif pause.pos == 2 then
		states.saves.load()
	elseif pause.pos == 3 then
		states.settings.load()
	elseif pause.pos == 4 then
		states.menu.load()
		pause.background = nil
	end
end

function pause.mousepressed(x, y)
	mouseSet(x, y)
	
	if mouseInrange(
		pause.posX - CLEARANCE, pause.posY - CLEARANCE,
		pause.posX + pause.sizeX + CLEARANCE, pause.posY + pause.sizeY + CLEARANCE
	) then
		if mouseInrange(pause.posX, pause.posY, pause.posX + pause.sizeX, pause.posY + pause.sizeY) then
			local posNow = math.floor((mouseY - pause.posY) / FONT2_HEIGHT)
			if pause.pos ~= posNow then
				pause.pos = posNow
			
				pause.reactEnable = true
				pause.reactTime = systime + 0.3
			else
				pause.react()
			end
		end
	else
		states.game.load()
	end
end

function pause.keypressed(key)
	if key == "return" then
		--[[if pause.pos == 0 then
			states.game.load()
			pause.background = nil
		elseif pause.pos == 1 then
			saveGame()
			states.game.load()
			pause.background = nil
		elseif pause.pos == 2 then
			states.saves.load()
		elseif pause.pos == 3 then
			states.settings.load()
		elseif pause.pos == 4 then
			states.menu.load()
			pause.background = nil
		end]]--
		pause.react()
	elseif key == "up" then
		pause.pos = math.fmod(pause.pos + 4, 5)
	elseif key == "down" then
		pause.pos = math.fmod(pause.pos + 6, 5)
	elseif key == "escape" then
		states.game.load()
		pause.background = nil
	end
end

return pause
