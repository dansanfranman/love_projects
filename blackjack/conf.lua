function love.conf(t)
    t.console = true
	t.window.title = "Blackjack"
	t.window.icon = "assets/Cards/card_spade_11.png"
	t.window.width = 1600
	t.window.height = 900

	t.modules.joystick = false
	t.modules.physics = false
	t.modules.touch = false
	t.modules.video = false
    end
