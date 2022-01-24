binser = require("libs/binser")
require("libs/map-parser")

path = {}
pathCounter = 0

thisArea = {}
thisAreaId = 0

savesList = {}
savesListCount = 0

--[[function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
end]]

function loadMap()
	--MAP = require("map")
	MAP = mapparser("script.txt")
	
	--[[for i=1, 100 do
		print(i)
		tprint(MAP[i])
	end]]
	
	if MAP == nil then
		error("Bad map.")
	end
	
	MAP_COUNT = #MAP
end

function newGame()
	path = {}
	pathCounter = 0
	
	thisArea = {}
	thisAreaId = 0
	setNextArea(1)
	
	characters = {}
	charactersImages = {}
	
	things = {}
	
	setArea(1)
	
	states.game.load()
end

function saveGame()
	-- Filesystem
	local fileInfo = love.filesystem.getInfo("saves")
	if fileInfo == nil then
		love.filesystem.createDirectory("saves")
	elseif fileInfo.type ~= "directory" then
		love.filesystem.remove("saves")
		love.filesystem.createDirectory("saves")
	end
	
	local fileInfo = love.filesystem.getInfo("saves-scr")
	if fileInfo == nil then
		love.filesystem.createDirectory("saves-scr")
	elseif fileInfo.type ~= "directory" then
		love.filesystem.remove("saves-scr")
		love.filesystem.createDirectory("saves-scr")
	end
	
	
	-- Save
	local saveTable = {
		path = path,
		pathCounter = pathCounter,
		things = things,
		thisAreaId = thisAreaId
	}
	
	local name = os.date("%Y-%m-%d-%H-%M-%S")

	love.filesystem.write("saves/" .. name, binser.serialize(saveTable))
	states.game.draw()
	lg.captureScreenshot("saves-scr/" .. name .. ".png")
end

function loadGame(filename)
	if love.filesystem.getInfo(filename) ~= nil then
		local content = love.filesystem.read(filename)
		
		local contentTable = binser.deserialize(content)[1]
		
		if
			contentTable == nil
			or contentTable.things == nil
			or contentTable.thisAreaId == nil
			or contentTable.path == nil
			or contentTable.pathCounter == nil
		then
			print("Bad savefile")
			states.menu.load()
		else
			things = contentTable.things
			thisAreaId = contentTable.thisAreaId
			path = contentTable.path
			pathCounter = contentTable.pathCounter
		
			setArea(thisAreaId)
			states.game.load()
		end
	else
		print("File not found")
	end
end
