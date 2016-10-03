
local Block = {}

local Colors = require"colors"

function Block.draw(grid, x, y, b)
	local blockSize = grid.blockSize
	local col = Colors[b + 1]
	love.graphics.setColor(col[1], col[2], col[3])
	love.graphics.rectangle("fill", (x-1)*blockSize, (y-1)*blockSize, blockSize, blockSize)
end

return Block

