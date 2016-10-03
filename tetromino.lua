
local Tetromino = {}
Tetromino.__index = Tetromino

local Grid = require"grid"
local blockSize = Grid.blockSize

local Colors = require"colors"
local Block = require"block"

Tetromino.patterns = {
	{
		{ 1, 0, 0, 0 },
		{ 1, 0, 0, 0 },
		{ 1, 0, 0, 0 },
		{ 1, 0, 0, 0 },
	},
	{
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 2, 2, 0, 0 },
		{ 2, 2, 0, 0 },
	},
	{
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 3, 3, 0, 0 },
		{ 0, 3, 3, 0 },
	},
	{
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 4, 4, 0 },
		{ 4, 4, 0, 0 },
	},
	{
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 5, 0, 0 },
		{ 5, 5, 5, 0 },
	},
	{
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 6, 0, 0, 0 },
		{ 6, 6, 6, 0 },
	},
	{
		{ 0, 0, 0, 0 },
		{ 0, 0, 0, 0 },
		{ 0, 0, 7, 0 },
		{ 7, 7, 7, 0 },
	}
}
		

function Tetromino:new(x, y, patternId)
	local o = {
		x = x or 0,
		y = y or 0,
		patternId = patternId or 0,
		pattern = {},
	}
	for i = 1, #Tetromino.patterns[o.patternId] do
		o.pattern[i] = {}
		for j = 1, #Tetromino.patterns[o.patternId][i] do
			o.pattern[i][j] = Tetromino.patterns[o.patternId][i][j]
		end
	end
	setmetatable(o, self)
	return o
end

function Tetromino:move(dx, dy)
	self.x, self.y = self.x + dx, self.y + dy
end

function Tetromino:blockPosition(bx, by)
	local x = self.x + bx - 1
	local y = self.y + by - 4
	return x, y
end

function Tetromino:checkCollision(grid)
	for i = 1, 4 do
		for j = 1, 4 do
			local x, y = self:blockPosition(j, i)
			if self.pattern[i][j] ~= 0 then
				if grid:isPointInBounds(x, y) and grid.blocks[y][x] ~= 0 then
					return true
				elseif y > grid.height or x <= 0 or x > grid.width then
					return true
				end
			end	
		end
	end
	return false
end

local Level = require"level"

function Tetromino:addToGrid(grid)
	for i=1, 4 do
		for j=1, 4 do
			local x, y = self:blockPosition(j, i)
			if self.pattern[i][j] ~= 0 and grid:isPointInBounds(x, y) then
				grid.blocks[y][x] = self.pattern[i][j]
			end
			if grid:isPointLose(x, y) then
				Level.lost = true
			end
		end
	end
end

--[[ rotation transformation
rotate
x' = -y or y
y' = x  or -x
translate
x'' = x (+ 5)
y'' = y'(+ 5)

dir = 1 or -1
]]
function Tetromino:rotate(dir)
	local temp = {}
	for i = 1, 4 do
		temp[i] = {}
		for j = 1, 4 do
			temp[i][j] = 0
		end
	end
	--rotate and translate
	for i = 1, 4 do
		for j = 1, 4 do
			local x = -i*dir
			local y = j*dir
			if dir > 0 then
				x = x + 5
			else
				y = y + 5
			end
			temp[y][x] = self.pattern[i][j]
		end
	end
	--move to lower left
	--find left most block
	local left, bottom = 0, 0
	local done = false
	for i = 1, 4 do
		for j = 1, 4 do
			if temp[j][i] ~= 0 then
				left = i
				done = true
				break
			end
		end
		if done then break end
	end
	done = false
	--find bottom most block
	for i = 4, 1, -1 do
		for j = 1, 4 do
			if temp[i][j] ~= 0 then
				bottom = i
				done = true
				break
			end
		end
		if done then break end
	end
	--move to bottom left
	for i = 4, 1, -1 do
		for j = 1, 4 do
			local next_x = j + left - 1
			local next_y = i + bottom - 4
			if next_x > 4 or next_y < 1 then
				temp[i][j] = 0
			else
				temp[i][j] = temp[next_y][next_x]
			end
		end
	end
	
	--replace
	self.pattern = temp
end

function Tetromino:draw(grid)
	for i=1, 4 do
		for j=1, 4 do
			if self.pattern[i][j] ~= 0 then
				local x, y = self:blockPosition(j, i)
				Block.draw(grid, x + grid.x, y + grid.y, self.pattern[i][j])
			end
		end
	end
end

return Tetromino

