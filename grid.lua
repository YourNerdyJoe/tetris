
local Grid = {}

local Block = require"block"

Grid.x = 1
Grid.y = 0
Grid.width = 10
Grid.height = 20
Grid.blockSize = 16
Grid.blocks = {}

function Grid:init()
	for i = 1, self.height do
		self.blocks[i] = {}
		for j = 1, self.width do
			self.blocks[i][j] = 0
		end
	end
end

function Grid:copy(t)
	for i = 1, #t do
		for j = 1, self.width do
			self.blocks[self.height - i + 1][j] = t[#t - i + 1][j]
		end
	end
end

function Grid:isPointInBounds(x, y)
	return x > 0 and x <= self.width and y > 0 and y <= self.height
end

function Grid:isPointLose(x, y)
	return y <= 0
end

function Grid:clearLines(score)
	local lines_cleared = 0
	
	for i = 1, self.height do
		local clear = true

		for j = 1, self.width do
			if self.blocks[i][j] == 0 then
				clear = false
			end
		end

		if clear then
			for k = i - 1, 1, -1 do
				for j = 1, self.width do
					self.blocks[k + 1][j] = self.blocks[k][j]
				end
			end
			for j = 1, self.width do
				self.blocks[1][j] = 0
			end
			
			lines_cleared = lines_cleared + 1
		end
	end
	
	if score then
		score:add(lines_cleared*lines_cleared*100)
	end
end

function Grid:draw()
	local x = self.x * self.blockSize
	local y = self.y * self.blockSize
	
	for i=0, self.width do
		love.graphics.line(i*self.blockSize + x, y, i*self.blockSize + x, self.height*self.blockSize + y)
	end
	for i=0, self.height do
		love.graphics.line(x, i*self.blockSize + y, self.width*self.blockSize + x, i*self.blockSize + y)
	end

	for i = 1, self.height do
		for j = 1, self.width do
			if self.blocks[i][j] ~= 0 then
				Block.draw(self, j+self.x, i+self.y, self.blocks[i][j])
			end
		end
	end
end

return Grid

