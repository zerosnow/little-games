local RIGHT = 1
local LEFT = 2
local UP = 3
local DOWN = 4

local GameLayer = class("GameLayer", function()
    return display.newLayer()
end)

function GameLayer:ctor()
	math.randomseed(os.time())
	self.width = 32
	self.height = 48
	self.bodyWidth = display.width / self.width
	self.bodyHeight = display.height / self.height
	self.body_ = {}
	self.counter = 0
	self.food = nil
	self.direction = RIGHT
    self:createBody(16, 24)
    self:createBody(15, 24)
    self:onStart()
end

function GameLayer:createBody(x, y)
	local body = {} 
	body.sprite = display.newSprite("body.png",{scale9 = true})
	body.x = x * self.bodyWidth
	body.y = y * self.bodyHeight
	body.sprite:align(display.BOTTOM_LEFT, body.x, body.y)
	body.sprite:setContentSize(self.bodyWidth, self.bodyHeight)
	body.sprite:addTo(self)
	self.body_[#self.body_+1] = body	
end

function GameLayer:onStart()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.running))
    self:scheduleUpdate()
end

function GameLayer:running()
	print("1")
	if self.food == nil then 
		self:createFood()
	end
	self.counter = self.counter + 1
	if self.counter == math.floor(60 / #self.body_ + 10) then 
		for i = #self.body_, 2, -1 do
			self.body_[i].sprite:setPosition(self.body_[i-1].sprite:getPosition())
			self.body_[i].x = self.body_[i-1].x
			self.body_[i].y = self.body_[i-1].y
		end
		if self.direction == RIGHT then
			self.body_[1].sprite:setPosition(cc.p(self.body_[1].x + self.bodyWidth, self.body_[1].y ))
			self.body_[1].x = self.body_[1].x + self.bodyWidth
			self.body_[1].y = self.body_[1].y
		elseif self.direction == LEFT then
			self.body_[1].sprite:setPosition(cc.p(self.body_[1].x - self.bodyWidth, self.body_[1].y ))
			self.body_[1].x = self.body_[1].x - self.bodyWidth
			self.body_[1].y = self.body_[1].y
		elseif self.direction == UP then
			self.body_[1].sprite:setPosition(cc.p(self.body_[1].x, self.body_[1].y + self.bodyHeight))
			self.body_[1].x = self.body_[1].x
			self.body_[1].y = self.body_[1].y + self.bodyHeight
		else
			self.body_[1].sprite:setPosition(cc.p(self.body_[1].x, self.body_[1].y - self.bodyHeight))
			self.body_[1].x = self.body_[1].x
			self.body_[1].y = self.body_[1].y - self.bodyHeight
		end
		self.counter = 0
	end
	if self.body_[1].x == self.food.x and self.body_[1].y == self.food.y then 
		self.food = nil
		self:createFood()
		self:createBody(self.body_[#self.body_-1].x * 2 - self.body_[#self.body_].x, self.body_[#self.body_-1].y * 2 - self.body_[#self.body_].y)
	end
end

function GameLayer:createFood()
	local food = {}
	local collision = true
	while collision do
		x = math.random(1, self.width)
		y = math.random(1,self.height)
		collision = false
		for i = 1, #self.body_ do
			if x == self.body_[i].x and y == self.body_[i].y then
				collision = true
			end
		end
	end
	food.sprite = display.newSprite("body.png",{scale9 = true})
	food.x = x * self.bodyWidth
	food.y = y * self.bodyHeight
	self.food = food
	food.sprite:align(display.BOTTOM_LEFT, food.x, food.y)
	food.sprite:setContentSize(self.bodyWidth, self.bodyHeight)
	food.sprite:addTo(self)
	self.food.sprite:runAction(cc.Blink:create(0.5, 100))
end

return GameLayer
