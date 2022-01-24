table.insert(states.game.objDraw, function ()
	if characters ~= nil then
		for i, character in pairs(characters) do
			local angle = 0
			
			if character.shake then
				angle = charactersByImage[character.image].speed * math.sin(3 * systime + charactersByImage[character.image].offset)
			end
			
			--[[if character.appear ~= nil and systime < character.appearTimeEnd then
				lg.setColor(1, 1, 1, 1 - (character.appearTimeEnd - systime) / 0.5)
			else
				lg.setColor(1, 1, 1, 1)
			end]]--
			
			lg.draw(
				charactersImages[i].image,
				character.pos[1] * w,
				(1 - character.pos[2]) * h,
				angle,
				character.scale,
				character.scale,
				charactersImages[i].width / 2,
				charactersImages[i].height
			)
		end
	end
end)