
local Score = {}

Score.score = 0

function Score:add(i)
	self.score = self.score + i
end

function Score:draw(x, y)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Score: "..self.score, x, y)
end

return Score

