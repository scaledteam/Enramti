backbutton = {}

function backbutton.draw()
	local size = (FONT1_HEIGHT + CLEARANCE)
	lg.setColor(COLOR_LOW)
	lg.rectangle("fill", 0, 0, size * h, size * h)
	lg.setColor(COLOR_TEXT)
	lg.printf("←", 0, CLEARANCE / 2 * h, size * h, "center")
end

function backbutton.mousepressed()
	local size = (FONT1_HEIGHT + CLEARANCE)
	if mouseY < size and mouseX < size / w * h then
		return true
	else
		return false
	end
end
