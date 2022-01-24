function love.conf(t)
	t.window.title = "new-game"
	t.window.resizable = true
	
	t.window.minwidth = 456
	t.window.minheight = 256
	
	t.modules.data = false
	t.modules.joystick = false
	t.modules.physics = false
end