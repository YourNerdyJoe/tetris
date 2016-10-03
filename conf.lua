
function love.conf(t)
	t.window = t.window or t.screen
	
	t.version = "0.9.1"
	
	t.window.title = "tetris"
	t.window.width = 320
	t.window.height = 480

	t.window.fullscreen = false

	t.modules.audio = true
	t.modules.joystick = false
	t.modules.mouse = true
	t.modules.physics = false
	t.modules.sound = true

	t.console = true
end
