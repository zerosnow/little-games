--[[

Copyright (c) 2015-2020 www.pinssible.com

]]

--[[
    @description：
    @author：shuangquanw
]]

local SceneBase = class("SceneBase", function()
    return display.newScene()
end)

function SceneBase:ctor(args)
	self.options = {
		name = "<unknown-scene>",
		controller = nil,
	}

	local ops = args or {}
	for k, v in pairs(ops) do self.options[k] = v end

	self.name = self.options.name;


	self:setKeypadEnabled(true)
    self:addNodeEventListener(cc.KEYPAD_EVENT, function(event)  --cc.KEYPAD_EVENT = 6
        if event.key == "back" then
            app:popScene()
        end
    end)


end

function SceneBase:onEnter()
	
	if self.options and self.options.controller then
		self.options.controller:onEnter()
	end
end

function SceneBase:onExit()
	if self.options and self.options.controller then
		self.options.controller:onExit()
	end
end

return SceneBase
