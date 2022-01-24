#! /usr/bin/luajit

-- 
-- Created by Scaled
--

function mapparser(filename)
	local autoPoses = {0.5, 0.25, 0.75, 0.125, 0.375, 0.625, 0.875}

	local script = {}
	local tableBuffer = {}

	local ARRAY_MODE_NONE = 0
	local ARRAY_MODE_CHARACTERS = 1
	local ARRAY_MODE_CHOOSES = 2
	local arrayMode = ARRAY_MODE_NONE
	local arrayBuffer = {}
	
	for line in love.filesystem.lines(filename) do
		if line == "" then
			-- nothing
		elseif line:sub(1,1) == "#" then
			-- nothing
		elseif arrayMode ~= ARRAY_MODE_NONE and (line:sub(1,1) == " " or  line:sub(1,1) == "\t") then
			local text = line:gsub("^%s+", "")
			if arrayMode == ARRAY_MODE_CHARACTERS then
				local separator = text:find(":")
				if separator then
					table.insert(arrayBuffer, {
						image = text:sub(1, separator-1),
						pos = {tonumber(text:sub(separator+1, -1)), 0}
					})
				else
					table.insert(arrayBuffer, {
						image = text,
						pos = {autoPoses[#arrayBuffer+1], 0}
					})
				end
			elseif arrayMode == ARRAY_MODE_CHOOSES then
				table.insert(arrayBuffer, text)
			end
		else
			if arrayMode == ARRAY_MODE_CHOOSES then
				arrayMode = ARRAY_MODE_NONE
				
				table.insert(script, tableBuffer)
				tableBuffer = {}
			end
			
			local separator = line:find(":")
			if separator then
				local name = line:sub(1, separator-1)
				local text = line:sub(separator+1, -1):gsub("^%s+", "")
				
				--name_lower = name:lower()
				if name == "Фон" then
					tableBuffer.background = text
				elseif name == "Музыка" then
					tableBuffer.soundMusic = text
				elseif name == "Звук" then
					tableBuffer.soundEffect = text
				elseif name == "Глюк" then
					tableBuffer.glitch = text
				elseif name == "Метка" then
					tableBuffer.label = text
				
				elseif name == "ПереходЕслиЕсть" then
					local separator = text:find(":")
					if separator then
						tableBuffer.gotoIfExist = {text:sub(1, separator-1), text:sub(separator+1, -1)}
					else
						tableBuffer.gotoIfExist = {text, text}
					end
				elseif name == "Переход" then
					tableBuffer.goto = text
					
					table.insert(script, tableBuffer)
					tableBuffer = {}
				
				elseif name == "Дать" then
					tableBuffer.get = text
				elseif name == "Отобрать" then
					tableBuffer.unget = text
					
				elseif name == "Персонажи" then
					arrayBuffer = {}
					tableBuffer.characters = arrayBuffer
					arrayMode = ARRAY_MODE_CHARACTERS
				elseif name == "Выбор" then
					arrayBuffer = {}
					tableBuffer.chooses = arrayBuffer
					arrayMode = ARRAY_MODE_CHOOSES
				
				else
					if name:find(" ") then
						tableBuffer.text = line
					else
						tableBuffer.name = name
						tableBuffer.text = text
					end
					table.insert(script, tableBuffer)
					tableBuffer = {}
				end
			elseif line == "КонецИгры" then
				tableBuffer.gameover = true
				table.insert(script, tableBuffer)
				tableBuffer = {}
			else
				tableBuffer.text = line
				table.insert(script, tableBuffer)
				tableBuffer = {}
			end
		end
	end
	
	return script
end
