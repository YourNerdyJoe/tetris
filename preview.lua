
local Preview = {}

local Level = require"level"
local Tetromino = require"tetromino"
local State = require"state"

local ofs_x, ofs_y = 14, 3
local ofs_w, ofs_h = 0, 5

function Preview:create()
	self.blocks = {}
	local cur_lvl = Level:getCurrent()
	if cur_lvl then
		for i = 1, #cur_lvl.tetrominos do
			self.blocks[i] = Tetromino:new(i*ofs_w+ofs_x, i*ofs_h+ofs_y, cur_lvl.tetrominos[i])
		end
	else
		self.next_block = math.random(1, #Tetromino.patterns)
		self.blocks[1] = Tetromino:new(ofs_w+ofs_x, ofs_h+ofs_y, self.next_block)
	end
end

function Preview:destroy()
	self.blocks = nil
end

function Preview:nextBlock()
	local ret = self.next_block
	self.next_block = math.random(1, #Tetromino.patterns)
	self.blocks[1] = Tetromino:new(ofs_w+ofs_x, ofs_h+ofs_y, self.next_block)
	return ret
end

local Grid = require"grid"

function Preview:draw()
	if State.state == "game" then
		love.graphics.print("Next: ", 200, 36)
		if self.blocks then
			for i, v in ipairs(self.blocks) do
				self.blocks[i]:draw(Grid)
			end
		end
	end
end

return Preview

