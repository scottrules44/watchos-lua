local scottLib = require("scottLib")

waxClass{"ExtensionDelegate"}
function applicationDidBecomeActive(self)
    self:ORIGapplicationDidBecomeActive();
	print("lua applicationDidBecomeActive")
end

function applicationWillResignActive(self)
	self:ORIGapplicationWillResignActive();
	print("lua applicationWillResignActive")
end

---InterfaceController
waxClass{"InterfaceController"}
luaSetWaxConfig({openBindOCFunction=true})
IBOutlet "skInterface"
local sceneSet = 0
function start(self)
    if sceneSet == 0 then
        local myScene =SKScene:sceneWithSize(CGSize(scottLib.screenWidth, scottLib.screenHeight))

        self:skInterface():presentScene(myScene)
        scottLib.setScene(myScene)
        require("main")
        scottLib.mySystemLis("became activate")
    else
        scottLib.mySystemLis("activate")
    end
    sceneSet = 1
    --
end


function willActivate(self)
    if sceneSet == 1 then
    end
    scottLib.setSelf(self)
	self:performSelector_withObject_afterDelay("start", nil, 2)

	self:ORIGwillActivate()
end

function didDeactivate(self)
    scottLib.mySystemLis("deactivate")
	self:ORIGdidDeactivate()
    UIGraphicsEndImageContext();
end

--touch actions
function longTouch(self, sender)
    scottLib.myLongLis(sender)
end

function panTouch(self, sender)
    scottLib.myPanLis(sender)
end

function tapTouch(self, sender)
    scottLib.myTapLis(sender)
end
--network config
function configNetwork(self)
end
