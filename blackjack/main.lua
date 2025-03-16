io.stdout:setvbuf("no")

local Card = require("card")
local Chip = require("chip")
local Button = require("button")
local Action = require("action")

local screen_width, screen_height
local suits = {
	"clubs",
	"diamond",
	"spade",
	"heart",
	}

local game_over_text
local score = 0
local dealer_score = 0
local show_score = false
local show_dealer_score = false
local cash = 200
local initial_bet = 10
local this_bet = 0
local disable_input = false
local restart_game_timer = 0

local actions = {}
local buttons = {}
local chips = {}
local hit_button, stand_button, split_button, double_down_button, surrender_button
local betting_zone

local lose_sfx, win_sfx, card_sfx
local cascades = {}
local cascade_draw_index = 1
local card_back

function restart()
	disable_input = true
	for card = 1, #deck do
		deck[card]:moveToPosition({x = 0, y = 2000})
	end

	for card = 1, #hand do
		hand[card]:moveToPosition({x = 0, y = 2000})
	end

	for card = 1, #dealerHand do
		dealerHand[card]:moveToPosition({x = 0, y = 2000})
	end


	score = 0
	dealer_score = 0
	show_dealer_score = false
	if cash <= initial_bet then
		cash = 200
	end

	this_bet = 0

	restart_game_timer = 0

	loadGame()
	disable_input = false
end

function loadGame()
	local font_parent = "assets/Fonts/"
	local font = "Bristol and Bath.ttf"
	game_font_location = font_parent .. font
	game_font_size = 24
	game_font = love.graphics.newFont(game_font_location, game_font_size)
	game_font:setFilter("nearest", "nearest")
	love.graphics.setFont(game_font)

	win_sfx = love.audio.newSource("assets/SFX/level_up.wav", "static")
	lose_sfx = love.audio.newSource("assets/SFX/ghostly_laugh.wav", "static")
	card_sfx = 
	{
		love.audio.newSource("assets/SFX/sndHit1.wav", "static"),
		love.audio.newSource("assets/SFX/sndHit2.wav", "static"),
		love.audio.newSource("assets/SFX/sndHit3.wav", "static"),
		love.audio.newSource("assets/SFX/sndHit4.wav", "static")
	}
	game_over_text = ""
	deck = {}
	hand = {}
	dealerHand = {}

	screen_width, screen_height = love.graphics.getDimensions()
	createChips()
	buildDeck()
	shuffleDeck()
	adjustDeck()

	setBettingZone()
	placeBet()
end

function setBettingZone()
	betting_zone = {x = screen_width * 0.65, y = screen_height * 0.25, w = screen_width * 0.2, h = screen_height * 0.6, r = 5}
end

function placeBet()
	local button_start = screen_height * 0.4 
	button_start = createHitButton(button_start)
	button_start = createStandButton(button_start)
	button_start = createSplitButton(button_start)
	button_start = createDoubleDownButton(button_start)
	button_start = createSurrenderButton(button_start)

	if peekDeckForSplit() then
		buttons = {hit_button, stand_button, split_button, double_down_button, surrender_button}
	else
		buttons = {hit_button, stand_button, double_down_button, surrender_button}
	end
	cash = cash - initial_bet
	this_bet = initial_bet

	show_score = true
	-- draw first 2 Cards
	local draw_action = Action(draw, 1, 0.25, Action(draw, 1, 1))
	table.insert(actions, draw_action)
end

function peekDeckForSplit()
	return deck[#deck].value == deck[#deck - 1].value
end

function love.load()
	loadGame()
end

function createChips()
	local black = {0, 0, 0, 1}
	local white = {1, 1, 1, 1}

	chips = {
		Chip(1, screen_width - 100, screen_height - 100, game_font, white),
		Chip(5, screen_width - 100, screen_height - 200, game_font, black),
		Chip(10, screen_width - 100, screen_height - 300, game_font, black),
		Chip(50, screen_width - 100, screen_height - 400, game_font, black),
		Chip(100, screen_width - 100, screen_height - 500, game_font, black),
		Chip(500, screen_width - 100, screen_height - 600, game_font, black),
		Chip(1000, screen_width - 100, screen_height - 700, game_font,black)
	}
end

function createHitButton(button_start)
	local height = 50 
	hit_button = Button(50, button_start, 175, height, "Hit", {r = 1, g = 1, b = 1}, {r = 0, g = 0, b = 0}, game_font)
	hit_button.clicked = function() draw() end
	return button_start + height + 25
end

function createStandButton(button_start)
	local height = 50
	stand_button = Button(50, button_start, 175, height, "Stand", {r = 1, g = 1, b = 1}, {r = 0, g = 0, b = 0}, game_font)
	stand_button.clicked = function() stand() end
	return button_start + height + 25
end

function createSplitButton(button_start)
	local height = 50
	split_button = Button(50, button_start, 175, height, "Split", {r = 1, g = 1, b = 1}, {r = 0, g = 0, b = 0}, game_font)
	return button_start + height + 25
end

function createDoubleDownButton(button_start)
	local height = 50
	double_down_button = Button(50, button_start, 175, height, "Double Down", {r = 1, g = 1, b = 1}, {r = 0, g = 0, b = 0}, game_font)
	double_down_button.clicked = function() doubleDown() end
	return button_start + height + 25
end

function createSurrenderButton(button_start)
	local height = 50
	surrender_button = Button(50, button_start, 175, height, "Surrender", {r = 1, g = 1, b = 1}, {r = 0, g = 0, b = 0}, game_font)
	surrender_button.clicked = function() surrender() end
	return button_start + height + 25
end

function buildDeck()
	card_back = love.graphics.newImage("assets/Cards/card_back_dark_inner.png")
	for index, suit in ipairs(suits) do
		for cardIndex = 1, 13 do
			local card = Card(cardIndex, suit, card_back, "assets/Cards/card_" .. suit .. "_" .. cardIndex .. ".png")
			table.insert(deck, card)
		end
	end
end

function love.mousepressed(x, y, button, isTouch)
	if disable_input then
		return
	end

	for chip = #chips, 1, -1 do
		if chips[chip]:checkCollision(x, y) then
			chips[chip]:clicked()
			break
		end
	end

	for button = 1, #buttons do
		if buttons[button]:checkCollision(x, y) then
			buttons[button]:clicked()
		end
	end
end

function love.mousereleased(x, y, button, isTouch)
	for chip = 1, #chips do
		if chips[chip].isClicked then
			chips[chip]:released(betting_zone)
			break
		end
	end
end

function love.keypressed(key)
	if key == "up" then
		game_font_size = game_font_size + 1
	elseif key == "down" then
		game_font_size = game_font_size - 1
	end
	game_font = love.graphics.newFont(game_font_location, game_font_size)
	love.graphics.setFont(game_font)
end

function love.update(dt)
	updateDeck(dt)
	updateHand(dt)
	checkRestartTimer(dt)

	for action = 1, #actions do
		actions[action]:update(dt)
	end

	local mouse_pos_x, mouse_pos_y = love.mouse.getPosition()
	for chip = 1, #chips do
		chips[chip]:update(dt, mouse_pos_x, mouse_pos_y)
	end

	for button = 1, #buttons do
		buttons[button]:update(dt, mouse_pos_x, mouse_pos_y)
	end
end

function updateDeck(dt)
	for card = 1, #deck do
		deck[card]:update(dt)
	end
end

function updateHand(dt)
	for card = 1, #hand do
		hand[card]:update(dt)
	end

	for card = 1, #dealerHand do
		dealerHand[card]:update(dt)
	end
end

function checkRestartTimer(dt)
	if restart_game_timer > 0 then
		restart_game_timer = restart_game_timer - dt
		if restart_game_timer <= 0 then
			restart()
		end
	end
end

function createCascadeIn()
	cascade_timer = love.timer.getTime()
	local actionFunc = function(parent, dt) 
							local last_pos = cascades[#cascades]
							local new_pos
							if last_pos then
								new_pos = {x = last_pos.x + 75, y = last_pos.y}
							else
								new_pos = {x = -30, y = -30}
							end
							if new_pos.x > screen_width then
								new_pos.x = 0
								new_pos.y = new_pos.y + 110
							end
							if new_pos.y <= screen_height then
								table.insert(cascades, new_pos)
								parent.count = parent.count + 1
							else
								local diff = love.timer.getTime() - cascade_timer
								restart_game_timer = diff
								createCascadeOut()
							end
						end

	local action = Action(actionFunc, 1, 0.01, nil)						
	table.insert(actions, action)
end

function createCascadeOut()
	local actionFunc = function(parent)
							if cascade_draw_index < #cascades then
								cascade_draw_index = cascade_draw_index + 1
								parent.count = parent.count + 1
							else
								cascades = {}
								cascade_draw_index = 1
							end
						end
	local action = Action(actionFunc, 1, 0.01, nil)
	table.insert(actions, action)
end

function love.draw()
	
	love.graphics.clear(0.055, 0.333, 0.157)

	love.graphics.rectangle("line", betting_zone.x, betting_zone.y, betting_zone.w, betting_zone.h, betting_zone.r, betting_zone.r)

	for button = 1, #buttons do
		buttons[button]:draw()
	end

	for card = 1, #deck do
		deck[card]:draw()
	end

	for card = 1, #hand do
		hand[card]:draw()
	end

	for card = 1, #dealerHand do
		dealerHand[card]:draw()
	end

	for chip = 1, #chips do
		chips[chip]:draw()
	end

	drawTextElements()
	drawCascade()
end

function drawTextElements()
	love.graphics.print(game_over_text, screen_width * 0.5, screen_height * 0.5)
	love.graphics.print("DRAG CHIPS HERE\nTO BET", betting_zone.x + betting_zone.w * 0.5, betting_zone.y + betting_zone.h * 0.5)

	if show_score then
		love.graphics.print("SCORE: " .. score, screen_width * 0.35, screen_height - 100)
	end

	if show_dealer_score then
		love.graphics.print("SCORE: " .. dealer_score, screen_width * 0.6, 300)
	end
end

function printDeck()
	for index, card in ipairs(deck) do
		print(index, card:print())
	end
end

function shuffleDeck()
	local temp, rand
	for index = 1, #deck do
		rand = love.math.random(index, #deck)
		temp = deck[index]
		deck[index] = deck[rand]
		deck[rand] = temp
	end
end	

function draw()
	local card = deck[#deck]
	card:faceUp()
	score = score + card:getValue(score)
	card_sfx[love.math.random(1, 4)]:play()
	table.insert(hand, card)
	table.remove(deck, #deck)

	adjustHand()
	adjustDeck()

	local text
	if score > 21 then
		text = "You Bust!"
		lose_sfx:play()
		setupRestart(text)
		return false
	elseif score == 21 then
		stand()
	end
	return true 
end

function dealerDraw()
	local card = deck[#deck]
	card:faceUp()
	table.insert(dealerHand, card)
	table.remove(deck, #deck)
	card_sfx[love.math.random(1, 4)]:play()

	adjustDealerHand()
	adjustDeck()

	return card:getValue(dealer_score)
end

function stand()
	show_dealer_score = true
	dealer_score = 0

	local actionFunc = function(parentAction)
		incrementDealerScore()
		if dealer_score < 17 then
			parentAction.count = parentAction.count + 1
		end
	end

	local continueWithFunc = function(parentAction)
		local text
		if dealer_score > 21 or score > dealer_score then
			cash = cash + 2 * this_bet
			text = "You Win!"
			win_sfx:play()
		elseif dealer_score == 21 or dealer_score > score then
			text = "You Lose!"
			lose_sfx:play()
		else
			text = "You Drew!"
			cash = cash + this_bet
		end
		setupRestart(text)
	end

	local continueWith = Action(continueWithFunc, 1, 0, nil)
	local action = Action(actionFunc, 1, 1, continueWith)
		
	table.insert(actions, action)
end

function incrementDealerScore(dealerScore)
	dealer_score = dealer_score + dealerDraw()
end

function doubleDown()
	if #hand <= 2 and cash > initial_bet then
		cash = cash - initial_bet
		this_bet = this_bet + initial_bet
		if draw() then -- returns true unless drawing busts us
			stand()
		end
	end
end

function surrender()
	if #hand <= 2 then
		setupRestart("You surrendered!")	
	end
end

function setupRestart(text)
	createCascadeIn()
	disable_input = true
	game_over_text = text
	restart_game_timer = 30
end

function adjustDealerHand()
	local offset = 30
	local total_offset = offset * #dealerHand

	for card = 1, #dealerHand do
		dealerHand[card]:moveToPosition({x = 0.5 * screen_width + offset * card - total_offset, y = screen_height * 0.4 - offset * card + 0.5 * total_offset})
	end
end

function adjustHand()
	local offset = 30
	local total_offset = offset * #hand
	for card = 1, #hand do
		hand[card]:moveToPosition({x = 0.5 * screen_width + offset * card - total_offset, y = screen_height - 100 - offset * card + 0.5 * total_offset})
	end
end

function adjustDeck()
	local offset = 20
	local total_offset = offset * #deck

	for card = 1, #deck do
		deck[card]:moveToPosition({x = 0.5 * screen_width + offset * card - 0.5 * total_offset, y = 100})
	end
end

function drawCascade()
	for position = cascade_draw_index, #cascades do
		love.graphics.draw(card_back, cascades[position].x, cascades[position].y, 0.15, 0.15, 0.15)
	end
end
