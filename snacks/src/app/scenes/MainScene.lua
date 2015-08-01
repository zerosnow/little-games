
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	self.width = 16
	self.height = 24
	self.bodyWidth = display.width / self.width
	self.bodyHeight = display.height / self.height
	self.body_ = {}
    self:createBody(8,12)
    self:Start()
end

function MainScene:createBody(x, y)
	local body = {} 
	body.sprite = display.newSprite("body.png")
	body.x = x * self.bodyWidth
	body.y = y * self.bodyHeight
	self.body_[#self.body_+1] = body	
end

function MainScene:Start()
	-- body
end

function MainScene:createFood()
	-- body
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
