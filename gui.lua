
local Gui = {}

Gui.objects = {}

function Gui:createButton(x, y, w, h, msg, onClick)
	local o = {
		type = "button",
		x = x or 0,
		y = y or 0,
		w = w or 32,
		h = h or 32,
		msg = msg,
		events = { 
			mousepressed = function(self, x, y, button)
				if x >= self.x and x < self.x + self.w and
				y >= self.y and y < self.y + self.h and
				(button == "l" or button == 1) then
					if self.onClick then self:onClick() end
				end
			end
		},
		onClick = onClick
	}
	
	self.objects[#self.objects + 1] = o
	
	return o
end

function Gui:deleteAll()
	self.objects = {}
end

function Gui:handleEvent(event, ...)
	for i, v in pairs(self.objects) do
		if v.events[event] then
			v.events[event](v, ...)
		end
	end
end

Gui.button = {}

function Gui.button.draw(o)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("line", o.x, o.y, o.w, o.h)
	if o.msg then
		love.graphics.print(o.msg, o.x+4, o.y+4)
	end
end

function Gui:draw()
	for i, v in pairs(self.objects) do
		if Gui[v.type] and Gui[v.type].draw then
			Gui[v.type].draw(v)
		end
	end
end

return Gui

