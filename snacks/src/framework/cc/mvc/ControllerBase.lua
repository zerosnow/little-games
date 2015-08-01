--[[

Copyright (c) 2015-2020 www.pinssible.com

]]

--[[
    @description：
    @author：shuangquanw
]]


local ControllerBase = class("ControllerBase", function ()
    return display.newNode()
end)


function ControllerBase:ctor(args)
	self.options = {
		name = "<unknown-Controller>"
	}

	local ops = args or {}
	for k, v in pairs(ops) do self.options[k] = v end
end

function ControllerBase:init(args)
	local ops = args or {}
	for k, v in pairs(ops) do self.options[k] = v end

	
end

function ControllerBase:onEnter()
	if self.options and self.options._view then
		self.options._view:onEnter()
	end
end

function ControllerBase:onExit()
	
	if self.options and self.options._view then
		self.options._view:onExit()
	end
end

return ControllerBase
