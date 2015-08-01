local GameLayer = require("app.layers.GameLayer")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	local gameLayer = GameLayer.new():addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
