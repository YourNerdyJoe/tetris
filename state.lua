
local State = {}

State.state = ""

State.mainmenu = {}
State.game = {}

local Gui = require"gui"

function State:setState(state, ...)
	Gui:deleteAll()
	if self[self.state] and self[self.state].cleanUp then
		self[self.state].cleanUp()
	end
	self.state = state
	if self[state] and self[state].init then
		self[state].init(...)
	end
end

local NUM_OF_LEVELS = 4

function State.mainmenu.init()
	local top = 120
	Gui:createButton(96, top, 128, 32, "Start Classic", function() State:setState("game") end)
	for i = 1, NUM_OF_LEVELS do
		Gui:createButton(96, top + i*40, 128, 32, "Level "..i, function() State:setState("game", i) end)
	end
	Gui:createButton(96, top + NUM_OF_LEVELS*40+40, 128, 32, "Exit", function() love.event.quit() end)
end

function State.mainmenu.cleanUp()
	--Gui:deleteAll()
end

local Grid = require"grid"

--[[
function State.game.init()
	Grid:init()
end
]]

return State
