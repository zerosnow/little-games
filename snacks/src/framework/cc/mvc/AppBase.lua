
local AppBase = class("AppBase")

AppBase.APP_ENTER_BACKGROUND_EVENT = "APP_ENTER_BACKGROUND_EVENT"
AppBase.APP_ENTER_FOREGROUND_EVENT = "APP_ENTER_FOREGROUND_EVENT"

function AppBase:ctor(appName, packageRoot)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.name = appName
    self.packageRoot = packageRoot or "app"

    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create(AppBase.APP_ENTER_BACKGROUND_EVENT,
                                handler(self, self.onEnterBackground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create(AppBase.APP_ENTER_FOREGROUND_EVENT,
                                handler(self, self.onEnterForeground))
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

    self.snapshots_ = {}

    -- set global app
    app = self

    self.sceneStack = { }
end

function AppBase:run()

end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" then
        os.exit()
    end
end

function AppBase:enterScene(sceneName, args, transitionType, time, more)
	local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
	local sceneClass = require(scenePackageName)
	local scene = sceneClass.new(unpack(checktable(args)))
	display.replaceScene(scene, transitionType, time, more)
end

function AppBase:createView(viewName, ...)
    local viewPackageName = self.packageRoot .. ".views." .. viewName
    local viewClass = require(viewPackageName)
    return viewClass.new(...)
end

function AppBase:onEnterBackground()
    self:dispatchEvent({name = AppBase.APP_ENTER_BACKGROUND_EVENT})
    if PinNotification then
        PinNotification:dispatchEvent({name = PinNotification.APP_ENTER_BACKGROUND_EVENT})
    end
end

function AppBase:onEnterForeground()
    self:dispatchEvent({name = AppBase.APP_ENTER_FOREGROUND_EVENT})
    if PinNotification then
        PinNotification:dispatchEvent({name = PinNotification.APP_ENTER_FOREGROUND_EVENT})
    end
end

function AppBase:clearSceneStack()
    self.sceneStack = {}
end

function AppBase:gotoScene(viewID, args, transitionType, time, more)
    local currentScene = self:_createScene(viewID, args)
    local trans = g_viewTable[viewID].transition or {}
    display.pushScene(currentScene, trans.transitionType, trans.time, trans.more)
    local sceneInfo = {viewID = viewID, scene = currentScene}

    if viewID == "PrepareScene" or viewID == "LoginScene" then
        
    else
        table.insert(self.sceneStack, sceneInfo)
    end
    

end

function AppBase:popScene( )

    dump(self.sceneStack, "AppBase:popScene")
    if self.sceneStack and #self.sceneStack > 1 then
        table.remove(self.sceneStack, #self.sceneStack)
        local sceneInfo = self.sceneStack[#self.sceneStack]

        if sceneInfo and sceneInfo.scene then
            display.popScene( )
        end
    else
        if device.platform == 'android' then
            luaj.callStaticMethod("org.cocos2dx.lua.AppActivity", "goBackground", {}, "()V")
        end
    end

end


function AppBase:_createScene(viewID, args)

    -- view
    args = args or {}
    local viewPackageName = self.packageRoot .. ".views." .. g_viewTable[viewID].view
    local viewClass = require(viewPackageName)
    local viewObj = viewClass.new()

    -- controller
    local controlPackageName = self.packageRoot .. ".controllers." .. g_viewTable[viewID].controller
    local controllerClass = require(controlPackageName)
    args._view = viewObj
    local controllerObj = controllerClass.new(args)

    -- scene
    local sceneClass = cc.mvc.SceneBase
    -- if g_viewTable[viewID] ~= SceneBase then
    --      sceneClass = 
    -- end
    local scene = sceneClass.new({name = viewID, controller = controllerObj})

    viewObj:addTo(controllerObj)
    controllerObj:addTo(scene)

    return scene;
end


return AppBase
