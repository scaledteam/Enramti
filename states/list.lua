local state = {
	mouseUseReleased = false,
	mouseUse = false,
	isScrolling = false,
	mouseYOld = 0
}

state.height = FONT1_HEIGHT + CLEARANCE * 2
state.distance = state.height + CLEARANCE

state.offset = 0
state.speed = 0
state.lastTouchTime = 0

state.xOld = 0
state.yOld = 0

-- Events
function state.load(objects)
	lg.setFont(font1)
	
	setBackgroundByName("list")
	
	state.objects = objects
	
	state.offset = -2 * CLEARANCE
	state.speed = 0
	state.scrolling = false
	state.mouseUse = false
	
	state.scrollEnable = true
	state.mouseUseReleased = false
	state.mouseUse = false
	state.isScrolling = false
	
	state.maxPos = (#state.objects - 1 / state.distance) * state.distance + CLEARANCE
	
	state.lightPos = 0
	state.lightFrom = 0
	state.lightChangedTime = 0
	state.lightOld = 0
	
	state.lastKey = nil
	
	prevState = thisState
	thisState = state
	setStates()
end

function state.draw()
	mouseGet()
	
	if state.scrollEnable and state.mouseUse then
		if state.yOld ~= 0 then
			state.speed = state.yOld - mouseY
			state.lastTouchTime = systime
		else
			state.speed = 0
		end
		
		if state.yOld == 0 then
			state.yOld = mouseY
		end
		
		if state.isScrolling or (state.speed > 0.01 or state.speed < -0.01) then
			state.yOld = mouseY
			state.offset = state.offset + state.speed
			state.isScrolling = true
		else
			state.speed = 0
		end
	else
		state.yOld = 0
		state.isScrolling = false
		state.offset = state.offset + state.speed * 0.05 ^ (systime - state.lastTouchTime)
	end
	
	if mouseY ~= state.mouseYOld then
		state.mouseYOld = mouseY
		state.scrolledByKeyboard = false
	end
	
	-- LIght
	if not state.scrolledByKeyboard and not state.mouseUseReleased and ((0 < mouseY and mouseY < 1) or math.abs(state.speed) > 0.01) then
		local tempLightPos = math.floor((mouseY + state.offset) / state.distance)
		if
			state.objects[tempLightPos + 1]
			and state.objects[tempLightPos + 1].ignore == nil
		then
			state.lightPos = tempLightPos
		end
		
		if state.objects[state.lightPos + 1] and state.objects[state.lightPos + 1].ignore ~= nil then
			state.lightPos = math.min(state.lightPos + 1, #state.objects - 1)
		end
	end
	
	-- Compute lightning
	state.lightDraw = state.lightOld - (state.lightOld - state.lightFrom) * 0.000001 ^ (systime - state.lightChangedTime)

	if state.lightPos ~= state.lightOld then
		state.lightOld = state.lightPos
		state.lightFrom = state.lightDraw
	
		state.lightChangedTime = systime
	end
	
	if -2 * CLEARANCE > state.offset or state.offset > state.maxPos then
		state.offset = math.max(-2 * CLEARANCE, math.min(state.offset, state.maxPos))
		state.speed = 0
	end
	
	-- Draw back button
	backbutton.draw()
	
	lg.push()
	lg.translate(0, -state.offset * h)
	
	mouseY = mouseY + state.offset
	
	-- Draw lightning
	lg.setColor(COLOR_HIGHLIGHT)
	lg.rectangle("fill", 0, (-CLEARANCE * 2 + state.lightDraw * state.distance) * h, w, (CLEARANCE * 2 + state.height) * h)
	
	-- Draw only visible objects
	local listPos = math.floor(state.offset / state.distance)
	lg.translate(0, listPos * state.distance * h)
	mouseY = mouseY - listPos * state.distance
	for pos = listPos + 1, math.min(#state.objects, listPos + 1 / state.distance + 2) do
		local object = state.objects[pos]
		if object then
			object.draw(object, pos - 1)
		end
		
	 	mouseY = mouseY - state.distance
		lg.translate(0, state.distance * h)
	end
	lg.pop()
	
	if state.mouseUseReleased then
		state.mouseUseReleased = false
	end
end

function state.mousepressed(x, y)
	mouseSet(x, y)
	
	-- Back button
	if backbutton.mousepressed() then
		settingsSave()
		prevState.load()
		return
	end
	
	state.mouseUse = true
end

function state.mousereleased(x, y, isTouch)
	if not state.isScrolling and state.mouseUse then
		state.mouseUseReleased = true
	end
	
	state.mouseUse = false
end

function state.wheelmoved(x, y)
	state.speed = state.speed * 0.05 ^ (systime - state.lastTouchTime) - y * 0.01
	state.lastTouchTime = systime
	state.scrolledByKeyboard = false
end

function state.keypressed(key)
	if key == "escape" then
		settingsSave()
		prevState.load()
	elseif key == "up" then
		for i = state.lightPos - 1, 0, -1 do
			if state.objects[i + 1] and state.objects[i + 1].ignore == nil then
				state.lightPos = i
				break
			end
		end
		
		if not (state.offset < state.lightPos * state.distance and state.lightPos * state.distance < state.offset + 1 - state.height) then
			state.speed = state.speed * 0.05 ^ (systime - state.lastTouchTime) - 0.04
			state.lastTouchTime = systime
		end
		
		state.scrolledByKeyboard = true
	elseif key == "down" then
		for i = state.lightPos + 1, #state.objects do
			if state.objects[i + 1] and state.objects[i + 1].ignore == nil then
				state.lightPos = i
				break
			end
		end
			
		if not (state.offset < state.lightPos * state.distance and state.lightPos * state.distance < state.offset + 1 - state.height) then
			state.speed = state.speed * 0.05 ^ (systime - state.lastTouchTime) + 0.04
			state.lastTouchTime = systime
		end
		
		state.scrolledByKeyboard = true
	end
	
	if key == "left" or key == "right" or key == "return" or key == "delete" then
		state.lastKey = key
	else
		state.lastKey = nil
	end
end

return state