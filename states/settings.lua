local state = {
	posX = 0.4,
	sizeX = 0.4
}

state.scrollerThick = 0.5 * FONT1_HEIGHT

function state.load()
	states.list.height = FONT1_HEIGHT + CLEARANCE * 2
	states.list.distance = states.list.height + CLEARANCE
	states.list.load(state.objects)
end

function state.labelDraw(object)
	lg.setColor(COLOR_TEXT)
	lg.printf("- " .. object.name .. " -", 0.1 * w, 0, 0.8 * w, "center")
end

function state.textDraw(object)
	lg.setColor(0.45, 0.45, 0.45, 1)
	lg.rectangle("fill",
		state.posX * w, -CLEARANCE * h,
		state.sizeX * w, thisState.height * h
	)
	
	lg.setColor(COLOR_TEXT)
	lg.print(object.name, 0.1 * w, 0)
end

function state.scrollerDraw(object, pos)
	state.textDraw(object)
	
	if settings[object.setting] == nil then
		settings[object.setting] = object.min
	end
	
	local value = (settings[object.setting] - object.min) / (object.max - object.min)
	
	if thisState.lightPos == pos and (thisState.lastKey == "left" or thisState.lastKey == "right") then
		if thisState.lastKey == "left" then
			value = math.max(0, value - 0.1)
		else
			value = math.min(1, value + 0.1)
		end
		
		thisState.lastKey = nil
		
		if object.int then
			settings[object.setting] = math.floor(object.min + (object.max - object.min) * value + 0.5)
		else
			settings[object.setting] = object.min + (object.max - object.min) * value
		end
		
		if object.change ~= nil then
			object.change(settings[object.setting])
		end
	end
	
	lg.setColor(0.4, 0.8, 0.4, 1)
	
	if thisState.mouseUse and -CLEARANCE < mouseY and mouseY < thisState.height - CLEARANCE then
		if
			state.posX + state.sizeX * value - state.scrollerThick / 2 < mouseX
			and
			mouseX < state.posX + state.sizeX * value + state.scrollerThick / 2
		then
			object.scrollerScroll = true
			thisState.scrollEnable = false
		end
		
		if object.scrollerScroll then
			value = math.min(1, math.max(0, (mouseX - state.posX) / state.sizeX))
			if object.int then
				settings[object.setting] = math.floor(object.min + (object.max - object.min) * value + 0.5)
			else
				settings[object.setting] = object.min + (object.max - object.min) * value
			end
			
			if object.change ~= nil then
				object.change(settings[object.setting])
			end
			
			lg.setColor(0.45, 0.9, 0.45, 1)
		end
	elseif object.scrollerScroll then
		object.scrollerScroll = false
		thisState.scrollEnable = true
	end
	
	-- Background
	lg.rectangle("fill",
		state.posX * w, -CLEARANCE * h,
		state.sizeX * value * w, thisState.height * h
	)
	
	-- Slider
	lg.setColor(0.5, 1, 0.5, 1)
	lg.rectangle("fill",
		(state.posX + state.sizeX * value - state.scrollerThick / 2) * w, -CLEARANCE * h,
		state.scrollerThick * w, (thisState.height) * h
	)
	
	-- Text
	lg.setColor(COLOR_TEXT)
	lg.printf(math.floor(settings[object.setting] * 10) / 10,
		state.posX * w, 0,
		(state.sizeX - CLEARANCE) * w,
		"right"
	)
	lg.print(object.unit, (state.posX + state.sizeX + CLEARANCE) * w, 0)
end

function state.switchDraw(object, pos)
	state.textDraw(object)
	
	if thisState.lightPos == pos and thisState.lastKey == "return" then
		thisState.lastKey = nil
		
		settings[object.setting] = not settings[object.setting]
		if object.change ~= nil then
			object.change(settings[object.setting])
		end
	end
	
	lg.setColor(1, 0, 0, 0.3)
	lg.rectangle("fill",
		state.posX * w, -CLEARANCE * h,
		state.sizeX / 2 * w, thisState.height * h
	)
	lg.setColor(0, 1, 0, 0.3)
	lg.rectangle("fill",
		(state.posX + state.sizeX / 2) * w, -CLEARANCE * h,
		state.sizeX / 2 * w, thisState.height * h
	)
	
	if mouseInrange(state.posX, -CLEARANCE, state.posX + state.sizeX, thisState.height - CLEARANCE) then
		if thisState.mouseUseReleased then
			lg.setColor(1, 1, 1, 0.3)
					
			local value = mouseX > (state.posX + state.sizeX / 2)
	
			if value ~= settings[object.setting] then
				settings[object.setting] = value
		
				if object.change ~= nil then
					object.change(value)
				end
			end
		else
			lg.setColor(1, 1, 1, 0.2)
		end
		lg.rectangle("fill",
			(state.posX + math.floor((mouseX - state.posX) / (state.sizeX / 2)) * state.sizeX / 2) * w, -CLEARANCE * h,
			state.sizeX / 2 * w, thisState.height * h
		)
	end
	
	lg.setColor(COLOR_TEXT)
	
	lg.printf("Выключено", state.posX * w, 0, state.sizeX / 2 * w, "center")
	lg.printf("Включено", (state.posX + state.sizeX / 2) * w, 0, state.sizeX / 2 * w, "center")
end

state.objects = {
	{
		name = "Основные",
		draw = state.labelDraw,
		ignore = true
	},
	{
		name = "Громкость окружения",
		setting = "soundAmbientVolume",
		unit = "%",
		draw = state.scrollerDraw,
		change = function (value)
			if soundAmbient ~= nil then
				soundAmbient:setVolume(value / 100)
			end
		end,
		min = 0,
		max = 100
	},
	{
		name = "Громкость музыки",
		setting = "soundMusicVolume",
		unit = "%",
		draw = state.scrollerDraw,
		change = function (value)
			if soundMusic ~= nil then
				soundMusic:setVolume(value / 100)
			end
		end,
		min = 0,
		max = 100
	},
	{
		name = "Громкость эффектов",
		setting = "soundEffectVolume",
		unit = "%",
		draw = state.scrollerDraw,
		change = function (value)
			if soundEffect ~= nil then
				soundEffect:setVolume(value / 100)
			end
		end,
		min = 0,
		max = 100
	},
	{
		name = "Полный экран",
		setting = "fullscreen",
		draw = state.switchDraw,
		change = function (value)
			love.window.setFullscreen(value)
		end
	},
	{
		name = "Авточтение текста",
		setting = "textAutoread",
		draw = state.switchDraw
	},
	{
		name = "Скорость текста",
		setting = "smoothTextSpeed",
		unit = "зн/сек",
		draw = state.scrollerDraw,
		min = 50,
		max = 200
	},
	{
		name = "Тестовые",
		draw = state.labelDraw,
		ignore = true
	},
	{
		name = "Ограничение FPS",
		setting = "fpsMax",
		unit = "кадр/сек",
		draw = state.scrollerDraw,
		change = function (value)
			fpsMinDt = 1 / value
		end,
		min = 25,
		max = 300
	},
	{
		name = "Скорость промотки",
		setting = "fastTextInterval",
		unit = "шаг/сек",
		draw = state.scrollerDraw,
		change = function (value)
			FAST_TEXT_INTERVAL = 1 / value
		end,
		min = 1,
		max = 300
	},
	{
		name = "Шрифты",
		draw = state.labelDraw,
		ignore = true
	},
	{
		name = "Размер шрифта 1",
		setting = "FONT1_SIZE",
		unit = "",
		draw = state.scrollerDraw,
		min = 2,
		max = 5
	},
	{
		name = "Размер шрифта 2",
		setting = "FONT2_SIZE",
		unit = "",
		draw = state.scrollerDraw,
		min = 2,
		max = 14
	},
	{
		name = "Размер зазора",
		setting = "CLEARANCE",
		unit = "",
		draw = state.scrollerDraw,
		min = 0,
		max = 5
	},
	{
		name = "Строк в тексте",
		setting = "linesInText",
		unit = "",
		draw = state.scrollerDraw,
		min = 0,
		max = 5,
		int = true
	}
}

return state