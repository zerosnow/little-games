--[[

Copyright (c) 2015-2020 www.pinssible.com

]]

--[[
    @description：
    @author：shuangquanw
]]



local ViewBase = class("ViewBase", function ()
    return display.newNode()
end)

function ViewBase:ctor(args)
	self.options = {

	}
	local ops = args or {}
	for k, v in pairs(ops) do self.options[k] = v end
	
end

function ViewBase:init(args)
	self.options = {

	}

	local ops = args or {}
	for k, v in pairs(ops) do self.options[k] = v end
end


function ViewBase:onEnter(args)
	if pin.inDevices and LogHelper then
		LogHelper.onEnterView(self.__cname)
	end
	
end

function ViewBase:onExit(args)
	if pin.inDevices and LogHelper then
		LogHelper.onExitView(self.__cname)
	end
end

return ViewBase
