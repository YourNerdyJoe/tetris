
local Grid = require"grid"
Grid:init()

local Score = require"score"

local State = require"state"

local Gui = require"gui"

local Level = require"level"

local Tetromino = require"tetromino"

local Preview = require"preview"

local image = nil

function newTetromino()
	if not Level.curLevel then
		return Tetromino:new(5, 0, Preview:nextBlock())
	else
		local next_tet = Level:nextTetromino()
		if next_tet then
			return Tetromino:new(5, 0, next_tet)
		end
	end
end

local curBlock = nil

local timer, timer_count = 0.5, 0.0
local move_timer, move_timer_count = 0.125, 0.0

local paused = false

function togglePaused()
	paused = not paused
end

function State.game.init(lvl)
	Grid:init()
	timer, timer_count = 0.5, 0.0
	move_timer, move_timer_count = 0.125, 0.0
	Gui:createButton(48, 360, 64, 32, "Quit", function() State:setState("mainmenu") end)
	Gui:createButton(128, 360, 64, 32, "Pause", togglePaused)
	Level:startLevel(lvl)
	Preview:create()
	curBlock = newTetromino()
	Score.score = 0
	paused = false
end

function State.game.cleanUp()
	Preview:destroy()
end

-- Load
function love.load(arg)
	math.randomseed(os.time())
	
	State:setState("mainmenu")
	
	image = love.graphics.newImage("logo.png")
end

local key_pressed_ccw, key_pressed_cw = false, false

-- Key Pressed
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	
	--cw
	if key == "e" or key == "x" then
		curBlock:rotate(1)
		if curBlock:checkCollision(Grid) then
			curBlock:rotate(-1)
		end
	end
	
	--ccw
	if key == "q" or key == "z" then
		curBlock:rotate(-1)
		if curBlock:checkCollision(Grid) then
			curBlock:rotate(1)
		end
	end
	
	if key == "p" then
		togglePaused()
	end
end

function keyDownLeft()
	return love.keyboard.isDown("a") or love.keyboard.isDown("left")
end

function keyDownRight()
	return love.keyboard.isDown("d") or love.keyboard.isDown("right")
end

function keyDownDown()
	return love.keyboard.isDown("s") or love.keyboard.isDown("down")
end

function keyDownCw()
	return love.keyboard.isDown("e") or love.keyboard.isDown("x")
end

function keyDownCcw()
	return love.keyboard.isDown("q") or love.keyboard.isDown("z")
end

-- Mouse Click
function love.mousepressed(x, y, mouse_button)
	Gui:handleEvent("mousepressed", x, y, mouse_button)
end

function blockFall()
	if curBlock then
		curBlock:move(0, 1)
		if curBlock:checkCollision(Grid) then
			curBlock:move(0, -1)
			curBlock:addToGrid(Grid)
			Grid:clearLines(Score)
			curBlock = newTetromino()
		end
	end
end

function blockMove()
	local dir = 0
	if keyDownLeft() then dir = dir - 1 end
	if keyDownRight() then dir = dir + 1 end
	
	curBlock:move(dir, 0)
	if curBlock:checkCollision(Grid) then
		curBlock:move(-dir, 0)
	end

	--if keyDownCw() then curBlock:rotate(1) end
	--if keyDownCcw() then curBlock:rotate(-1) end

	if keyDownDown() then
		blockFall()
	end
end

-- Update
function love.update(dt)
	if State.state == "game" then
		if Level:isRunning() and not paused then
			timer_count = timer_count + dt
			move_timer_count = move_timer_count + dt
	
			while timer_count >= timer do
				blockFall()
				timer_count = timer_count - timer
			end
			while move_timer_count >= move_timer and curBlock do
				blockMove()
				move_timer_count = move_timer_count - move_timer
			end
		end
	end
end

-- Render
function love.draw()
	love.graphics.setColor(255, 255, 255)
	if State.state == "game" then
		Grid:draw()
		if curBlock then curBlock:draw(Grid) end
		Score:draw(200, 10)
		if paused then
			love.graphics.print("Paused", 132, 340)
		end
		if Level.lost then
			love.graphics.print("Game Over", 48, 340)
		end
	elseif State.state == "mainmenu" then
		if image then
			love.graphics.draw(image, 75, 10)
		end
	end
	Preview:draw()
	Gui:draw()
end

