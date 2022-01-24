-- Smoooth text
thisAreaTextUpdateTime = 0
thisAreaText = nil
thisAreaTextSub = 0
thisAreaTextLength = 0
thisAreaTextSmooth = false

function smoothTextStart()
	if thisArea.text ~= nil then
		thisAreaTextUpdateTime = systime
		thisAreaTextSub = 0
		thisAreaTextLength = utf8.len(thisArea.text)
		thisAreaTextSmooth = true
	end
end

function smoothTextEnd()
	if not thisAreaTextSmooth then
		return true
	elseif thisAreaTextSub < thisAreaTextLength then
		thisAreaTextSub = thisAreaTextLength
		thisAreaText = thisArea.text
		return false
	else
		return true
	end
end

textAutoreadUpdate = 0
textDisableEnd = 0
textTrianglesSize = math.min(states.game.sizeY, states.game.posX * w / h) * 0.4 * h

-- Draw
table.insert(states.game.objDraw, function ()
	if textEnable then
		local alpha = 1
		
		-- Hide text logic
		if textDisableEnd ~= 0 and love.mouse.isDown(1, 2, 3, 4, 5) and mouseY > thisState.posY and thisState.posX < mouseX and mouseX < thisState.posX + thisState.sizeX then
			if systime > textDisableEnd then
				textEnable = false
				textDisableEnd = 0
				return
			else
				alpha = textDisableEnd - systime
			end
			
		end
		
		-- Left arrow
		local size = textTrianglesSize
		
		local centerX = thisState.posX / 2 * w + size / 4
		local centerY = (thisState.posY + thisState.sizeY / 2) * h
		
		lg.setColor(COLOR_LOW[1], COLOR_LOW[2], COLOR_LOW[3], COLOR_LOW[4] * alpha)
		lg.polygon('fill',
			centerX - size, centerY,
			centerX + size / 2, centerY + size * 0.866025404,
			centerX + size / 2, centerY - size * 0.866025404
		)
		lg.polygon('line',
			centerX - size, centerY,
			centerX + size / 2, centerY + size * 0.866025404,
			centerX + size / 2, centerY - size * 0.866025404
		)
		
		size = textTrianglesSize - 2 * CLEARANCE * h
		lg.setColor(COLOR_TEXT[1], COLOR_TEXT[2], COLOR_TEXT[3], COLOR_TEXT[4] * alpha)
		lg.polygon('fill',
			centerX - size, centerY,
			centerX + size / 2, centerY + size * 0.866025404,
			centerX + size / 2, centerY - size * 0.866025404
		)
		lg.polygon('line',
			centerX - size, centerY,
			centerX + size / 2, centerY + size * 0.866025404,
			centerX + size / 2, centerY - size * 0.866025404
		)
		
		-- Chooses
		if chooses ~= nil then
			lg.setColor(COLOR_LOW)
			lg.rectangle("fill", thisState.posX * w, thisState.posY * h, thisState.sizeX * w, thisState.sizeY * h)

			lg.setColor(COLOR_TEXT)
		
			--for i, choose in pairs(chooses) do
			for i = 1, #chooses do
				lg.printf(
					--choose,
					chooses[i],
					(thisState.posX + CLEARANCE + (i - 1) / choosesCount * thisState.sizeX) * w,
					(thisState.posY + CLEARANCE) * h,
					(thisState.sizeX / choosesCount - 2 * CLEARANCE) * w,
					"center"
				)
			end
		
		-- Text
		elseif thisArea.text ~= nil then
			-- Right arrow
			size = textTrianglesSize
		
			centerX = (1 - thisState.posX / 2) * w - size / 4
			centerY = (thisState.posY + thisState.sizeY / 2) * h
		
			lg.setColor(COLOR_LOW[1], COLOR_LOW[2], COLOR_LOW[3], COLOR_LOW[4] * alpha)
			lg.polygon('fill',
				centerX + size, centerY,
				centerX - size / 2, centerY + size * 0.866025404,
				centerX - size / 2, centerY - size * 0.866025404
			)
			lg.polygon('line',
				centerX + size, centerY,
				centerX - size / 2, centerY + size * 0.866025404,
				centerX - size / 2, centerY - size * 0.866025404
			)
		
			size = textTrianglesSize - 2 * CLEARANCE * h
			lg.setColor(COLOR_TEXT[1], COLOR_TEXT[2], COLOR_TEXT[3], COLOR_TEXT[4] * alpha)
			lg.polygon('fill',
				centerX + size, centerY,
				centerX - size / 2, centerY + size * 0.866025404,
				centerX - size / 2, centerY - size * 0.866025404
			)
			lg.polygon('line',
				centerX + size, centerY,
				centerX - size / 2, centerY + size * 0.866025404,
				centerX - size / 2, centerY - size * 0.866025404
			)
			
			lg.setColor(COLOR_LOW[1], COLOR_LOW[2], COLOR_LOW[3], COLOR_LOW[4] * alpha)
			lg.rectangle("fill", thisState.posX * w, thisState.posY * h, thisState.sizeX * w, thisState.sizeY * h)
		
			if thisAreaTextSmooth then
				if thisAreaTextSub < thisAreaTextLength then
					thisAreaTextSub = math.floor(settings.smoothTextSpeed * (systime - thisAreaTextUpdateTime))
					thisAreaText = utf8.sub(thisArea.text, 1, thisAreaTextSub)
				elseif settings.textAutoread and chooses == nil then
					if textAutoreadUpdate == 0 then
						textAutoreadUpdate = systime + 2
					elseif systime > textAutoreadUpdate then
						setNextArea(findNextId())
				
						smoothTextStart()
				
						textAutoreadUpdate = 0
					end
				end
			end
		
			--lg.setColor(COLOR_TEXT)
			lg.setColor(COLOR_TEXT[1], COLOR_TEXT[2], COLOR_TEXT[3], COLOR_TEXT[4] * alpha)
			lg.printf(
				thisAreaText,
				(thisState.posX + CLEARANCE) * w,
				(thisState.posY + CLEARANCE) * h,
				(thisState.sizeX - 2 * CLEARANCE) * w
			)
	
			-- Name
			if thisArea.name ~= nil then
				--lg.setColor(COLOR_LOW)
				lg.setColor(COLOR_LOW[1], COLOR_LOW[2], COLOR_LOW[3], COLOR_LOW[4] * alpha)
				lg.rectangle("fill", thisState.posX * w, (thisState.posY - 0.07) * h, 0.2 * w, 0.07 * h)

				--lg.setColor(COLOR_TEXT)
				lg.setColor(COLOR_TEXT[1], COLOR_TEXT[2], COLOR_TEXT[3], COLOR_TEXT[4] * alpha)
				lg.print(thisArea.name, (thisState.posX + CLEARANCE) * w, (thisState.posY - 0.05) * h)
			end
		end
	end
end)


table.insert(states.game.objMouse, function (x, y)
	if chooses ~= nil then
		-- Do choose
		if y > thisState.posY and thisState.posX < x then
			for i = 1, choosesCount do
				if x < i / choosesCount * thisState.sizeX + thisState.posX then
					setNextArea(findAreaByName(thisArea.chooses[i]))
					
					smoothTextStart()
					break
				end
			end
		-- Go to prev area
		--elseif x < thisState.backFieldSize then
		elseif x < thisState.posX and y > thisState.posY then
			prevArea()
			
			thisAreaText = thisArea.text
			thisAreaTextSmooth = false
		end
	else
		-- Hide text
		if y > thisState.posY and thisState.posX < x and x < thisState.posX + thisState.sizeX then
			--textEnable = false
			textDisableEnd = systime + 1
		-- Go to prev area
		--elseif x < thisState.backFieldSize then
		elseif x < thisState.posX and y > thisState.posY then
			prevArea()
			
			thisAreaText = thisArea.text
			thisAreaTextSmooth = false
		-- Go to next area
		elseif smoothTextEnd() then
			setNextArea(findNextId())
			
			smoothTextStart()
		end
	end
end)


-- React
table.insert(states.game.objKeys, function (key)
	-- Do choose
	if chooses ~= nil then
		for i = 1, 9 do
			if key == tostring(i) then
				setNextArea(findAreaByName(thisArea.chooses[i]))
				smoothTextStart()
			end
		end
	end
	
	-- Go to prev area
	if key == "left" then
		prevArea()
		
		thisAreaText = thisArea.text
		thisAreaTextSmooth = false
	
	-- Go to next area
	elseif key == "right" or key == "space" or key == "return" then
		if chooses == nil then
			if smoothTextEnd() then
				setNextArea(findNextId())
				
				smoothTextStart()
			end
		end
	end
end)