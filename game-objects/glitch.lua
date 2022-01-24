table.insert(states.game.objDraw, function ()
	if glitchImage ~= nil then
		lg.setColor(1, 1, 1, 1)
		lg.draw(glitchImage)
		
		textEnable = false
		
		if systime > glitchEnd then
			glitchImage = nil
			textEnable = true
		end
	end
end)