
local Level = {}

local Grid = require"grid"

function newLevel(tetrominos, starting_blocks)
	local o = {
		tetrominos = tetrominos or {},
		starting_blocks = starting_blocks,
	}
	return o	
end

local X = 8

Level.levels = {
	newLevel({2, 1}, {
		{ 0, 0, X, X, X, X, X, X, X, 0, },
		{ 0, 0, X, X, X, X, X, X, X, 0, },
		{ X, X, X, X, X, X, X, X, X, 0, },
		{ X, X, X, X, X, X, X, X, X, 0, },
	}),
	newLevel({5, 1, 5, 1}, {
		{ X, 0, 0, 0, 0, 0, 0, 0, X, X, },
		{ X, X, 0, 0, 0, 0, 0, X, X, X, },
		{ X, X, X, 0, 0, 0, X, X, X, X, },
		{ X, X, X, X, 0, X, X, X, X, X, },
	}),
	newLevel({6, 7, 6, 7, 2}, {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		{ 0, 0, X, 0, 0, 0, 0, 0, 0, 0, },
		{ X, 0, X, 0, X, 0, X, 0, 0, 0, },
		{ X, 0, X, 0, X, 0, X, 0, 0, X, },
	}),
	newLevel({7, 3, 5, 3, 5}, {
		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, },
		{ X, X, X, X, 0, 0, 0, 0, 0, X, },
		{ X, X, 0, 0, 0, 0, 0, 0, 0, X, },
		{ 0, 0, 0, 0, 0, 0, 0, 0, X, X, },
	}),
}

function Level:startLevel(lvl)
	self.curLevel = lvl
	self.curTetromino = 0
	if lvl and self.levels[lvl] and self.levels[lvl].starting_blocks then
		Grid:copy(self.levels[lvl].starting_blocks)
	end
	self.lost = false
end

function Level:getCurrent()
	if self.curLevel then
		return self.levels[self.curLevel]
	end
end

function Level:nextTetromino()
	self.curTetromino = self.curTetromino + 1
	local ret = self.curTetromino
	if self:isRunning() then
		return self:getCurrent().tetrominos[ret]
	end
end

function Level:isRunning()
	return (not self.curLevel or 
		self.curTetromino <= #self.levels[self.curLevel].tetrominos) and 
		not self.lost
end

return Level

