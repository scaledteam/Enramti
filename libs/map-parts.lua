local mapParts = {
	background = {},
	characters = {},
	soundAmbient = {},
	soundEffect = {},
	soundMusic = {}
}

-- Background
function mapParts.background.loadThis()
	setBackgroundByName(thisArea.background)
end

function mapParts.background.loadPrev()
	local i = findPrevField("background")

	if i ~= 0 then
		setBackgroundByName(MAP[i].background)
	else
		setBackgroundByName("fall")
	end
end


-- Characters
charactersByImage = {}

function updateCharacters()
	charactersImages = {}
	
	for i, character in pairs(characters) do
		local imageFile = getImage("characters", character.image)

		charactersImages[i] = {
			image = imageFile,
			width = imageFile:getWidth(),
			height = imageFile:getHeight()
		}

		if character.scale == nil then
			character.scale = 1
		end
		
		if character.shake and charactersByImage[character.image] == nil then
			charactersByImage[character.image] = {
				offset = math.random() * 3,
				speed = 0.02 + (math.random() - 0.5) * 0.02
			}
		end

		--[[if character.appear ~= nil then
			character.appearTimeEnd = systime + 0.5
		end]]--
	end
end

function mapParts.characters.loadThis()
	characters = thisArea.characters

	updateCharacters()
end

function mapParts.characters.loadPrev()
	local i = findPrevField("characters")

	if i ~= 0 then
		characters = MAP[i].characters
	else
		characters = {}
	end
	
	updateCharacters()
end


-- Sound
function mapParts.soundAmbient.loadThis()
	soundAmbientStart(thisArea.soundAmbient)
end

function mapParts.soundAmbient.loadPrev()
	local i = findPrevField("soundAmbient")

	if i ~= 0 then
		soundAmbientStart(MAP[i].soundAmbient)
	elseif soundAmbient ~= nil then
		love.audio.stop(soundAmbient)
		soundAmbient = nil
	end
end

function mapParts.soundEffect.loadThis()
	soundEffectStart(thisArea.soundEffect)
end

function mapParts.soundEffect.loadPrev()
	local i = findPrevField("soundEffect")

	if i ~= 0 then
		soundEffectStart(MAP[i].soundEffect)
	elseif soundEffect ~= nil then
		love.audio.stop(soundEffect)
		soundEffect = nil
	end
end

function mapParts.soundMusic.loadThis()
	soundMusicStart(thisArea.soundMusic)
end

function mapParts.soundMusic.loadPrev()
	local i = findPrevField("soundMusic")

	if i ~= 0 then
		soundMusicStart(MAP[i].soundMusic)
	elseif soundMusic ~= nil then
		love.audio.stop(soundMusic)
		soundMusic = nil
	end
end

return mapParts