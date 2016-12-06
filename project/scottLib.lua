local osType = "watchOS"
local m = {}
luaSetWaxConfig({openBindOCFunction=true})
waxClass{"InterfaceController", NSTimer}
local json = require("json")
local titleOfApp = ""
local operQueue = toobjc(NSOperationQueue:currentQueue())
local accel
local gyro
--set func
function string:split( inSplitPattern, outResults )
    if not outResults then
        outResults = {}
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
        table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
        theStart = theSplitEnd + 1
        theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end
--set scene and self
m.setScene = function ( self )
    m.scene = self
end
m.setSelf = function ( self )
    m.mySelf = self
end
--screen properties lib
m.size = WKInterfaceDevice:currentDevice():screenBounds()
m.screenWidth =m.size.width
m.screenHeight =m.size.height
m.centerX =m.size.width*.5
m.centerY =m.size.height*.5
--device info lib
m.deviceName = WKInterfaceDevice:currentDevice():name()
m.model = WKInterfaceDevice:currentDevice():model()
m.wristLocation = WKInterfaceDevice:currentDevice():wristLocation()
m.crownOrientation = WKInterfaceDevice:currentDevice():crownOrientation()
m.preferredContentSizeCategory = WKInterfaceDevice:currentDevice():preferredContentSizeCategory()
--set title
m.setTitle= function(myTitle)
    titleOfApp = myTitle
    m.mySelf:setTitle(myTitle)
end
--time/date lib
m.getTime = function()
    local now = NSDate:date()
    local outputFormatter = NSDateFormatter:init()
    outputFormatter:setDateFormat("HH:mm:ss")
    return outputFormatter:stringFromDate(now)
end
m.getDate = function()
    local now = NSDate:date()
    local outputFormatter = NSDateFormatter:init()
    outputFormatter:setDateFormat("MM-dd-yyyy")
    return outputFormatter:stringFromDate(now)
end
--text lib
m.text ={}
m.text.create = function(prop)
    local myObj = toobjc(SKLabelNode:labelNodeWithText(prop.text))
    myObj:setPosition(CGPoint(prop.x, prop.y))
    m.scene:addChild(myObj)
    if prop.font then
        myObj:setFontName(prop.font)
    end
    if prop.size then
        myObj:setFontSize(prop.size)
    end
    myObj.text = prop.text
    myObj.rotation = 0
    myObj.x, myObj.y = prop.x, prop.y
    return myObj
end
m.text.pos = function()
    local posObj = prop.obj
    posObj.x, posObj.y = prop.x, prop.y
    posObj:setPosition(CGPoint(prop.x, prop.y))
end
m.text.size = function(prop)
    local myObj = prop.obj
    myObj:setFontSize(prop.size)
end
m.text.font = function(prop)
    local myObj = prop.obj
    myObj:setFontName(prop.font)
end
m.text.color = function(prop)
    local myObj = prop.obj
    myObj:setFontColor(toobjc(UIColor:colorWithRed_green_blue_alpha(prop.red,prop.green,prop.blue,prop.alpha)))
end
m.text.hide = function(prop)
    local myObj = prop.obj
    myObj:setHidden(prop.hide)
end
m.text.rotate = function(prop)
    local myObj = prop.obj
    myObj.rotation = prop.rotation
    myObj:setZRotation(prop.rotation)
end

m.text.set = function(prop)
    local myObj = prop.obj
    myObj.text = prop.text
    myObj:setText(prop.text)
end
--image lib
m.image ={}
m.image.create = function(prop)
    local myImage = toobjc(SKTexture:textureWithImageNamed(prop.image))
    local myObj = toobjc(SKSpriteNode:spriteNodeWithTexture(myImage))
    myObj:setPosition(CGPoint(prop.x, prop.y))
    myObj:setColorBlendFactor(1)
    myObj.x, myObj.y = prop.x, prop.y
    myObj.rotation = 0
    m.scene:addChild(myObj)
    return myObj
end

m.image.pos = function(prop)
    local posObj = prop.obj
    posObj:setPosition(CGPoint(prop.x, prop.y))
    posObj.x, posObj.y = prop.x, prop.y
end
m.image.size = function(prop)
    local myObj = prop.obj
    myObj:setSize(CGSize(prop.width, prop.height))
end
m.image.hide = function(prop)
    local myObj = prop.obj
    myObj:setHidden(prop.hide)
end
m.image.rotate = function(prop)
    local myObj = prop.obj
    myObj.rotation = prop.rotation
    myObj:setZRotation(prop.rotation)
end
m.image.color = function(prop)
    local myObj = prop.obj
    myObj:setColor(toobjc(UIColor:colorWithRed_green_blue_alpha(prop.red,prop.green,prop.blue,prop.alpha)))
end

--touch lib

m.myLongLis = function(sender)
    if m.longTouchLis ~= nil then
        local cords =sender:locationInObject()
        m.longTouchLis({x = cords.x, y = (m.screenHeight-cords.y) })
    end
end
local didBegan = 0
m.myPanLis = function(sender)
    if m.panTouchLis ~= nil then
        local phase = sender:state()
        if didBegan == 0 then
            didBegan = 1
            local cords =sender:locationInObject()
            m.panTouchLis({phase = "began", x = cords.x, y = (m.screenHeight-cords.y) })
        elseif phase == 2 and didBegan == 1 then -- moved
            local cords =sender:locationInObject()
            m.panTouchLis({phase = "moved", x = cords.x, y = (m.screenHeight-cords.y) })
        elseif phase == 3 and didBegan == 1 then -- ended
            didBegan = 0
            local cords =sender:locationInObject()
            m.panTouchLis({phase = "ended", x = cords.x, y = (m.screenHeight-cords.y) })
        end
    end
end
m.myTapLis= function(sender)
    if m.tapTouchLis ~= nil then
        local cords =sender:locationInObject()
        m.tapTouchLis({ x = cords.x, y = (m.screenHeight-cords.y) })
    end
end
--timer lib
m.timer ={}
m.timer.create = function ( prop )
    local time = prop.time
    local func = prop.lis
    local loop = false
    if (prop.loop ~= nil and prop.loop == true) then
        loop = true
    end
    local myObjClass = require("objMaker")
    local myObj =myObjClass:initTimer(func, time,loop)
    local myTime=toobjc(NSTimer:scheduledTimerWithTimeInterval_target_selector_userInfo_repeats(time*.001, myObj,"scottLibTimerHandler", func,loop))

    return myTime
end
m.timer.stop = function(myTimerObj)
    if myTimerObj then
        myTimerObj:invalidate()
        myTimerObj = nil
    end
end
--taptic lib
m.taptic = function(type)
    local myDevice = toobjc(WKInterfaceDevice:currentDevice())
    if type == "notification" then
        myDevice:playHaptic(0)
    elseif type == "directionUp" then
        myDevice:playHaptic(1)
    elseif type == "directionDown" then
        myDevice:playHaptic(2)
    elseif type == "success" then
        myDevice:playHaptic(3)
    elseif type == "failure" then
        myDevice:playHaptic(4)
    elseif type == "retry" then
        myDevice:playHaptic(5)
    elseif type == "start" then
        myDevice:playHaptic(6)
    elseif type == "stop" then
        myDevice:playHaptic(7)
    elseif type == "click" then
        myDevice:playHaptic(8)
    end
end
--sound lib
m.sound = {}
m.sound.create = function(prop)
    local audioNode = toobjc(SKAudioNode:initWithFileNamed(prop))
    audioNode:setAutoplayLooped(false)
    m.scene:addChild(audioNode)
    audioNode.volume = 1
    return audioNode
end
m.sound.play = function(prop)
    prop:runAction(SKAction:play())
end
m.sound.pause = function(prop)
    prop:runAction(SKAction:pause())
end
m.sound.stop = function(prop)
    prop:runAction(SKAction:stop())
end
m.sound.volume = function(prop)
    local duration = prop.duration
    if prop.duration == 0 then duration = 0.01 end
    audioNode.volume = prop.volume
    prop.obj:runAction(SKAction:changeVolumeTo_duration(prop.volume, prop.duration))
end
--media lib
m.presentMedia = function(prop)
    local fileUrl
    if prop.http ~= nil and prop.http == true then
        fileUrl = toobjc(NSURL:URLWithString(prop.file))
    else
        fileUrl = toobjc(NSURL:fileURLWithPath(prop.file))
    end

    m.mySelf:presentMediaPlayerControllerWithURL_options_completion(fileUrl, nil, toblock(
        function(didPlayToEnd, endTime, error)
            m.mySelf:setTitle(titleOfApp)
            if prop.func then
                prop.func({endTime= endTime, didPlayToEnd = didPlayToEnd})
            end
        end
    , {"id", "BOOL", "NSTimeInterval", "NSError"}))
end
--networking lib
m.network = {}
m.network.request = function(prop)
    local configuration = toobjc(NSURLSessionConfiguration:defaultSessionConfiguration())
    local session = toobjc(NSURLSession:sessionWithConfiguration_delegate_delegateQueue( configuration, "configNetwork",nil))
    local url = toobjc(NSURL:URLWithString(prop.url))
    local timeOut = 100
    if prop.timeout then
        timeOut = prop.timeout
    end
    local request = toobjc(NSMutableURLRequest:requestWithURL_cachePolicy_timeoutInterval(url,0,timeOut))
    request:setHTTPMethod(prop.method)
    if prop.body then
        request:setHTTPBody(prop.body)
    end
    if prop.headers then
        for k,v in pairs( prop.headers ) do
            request:setValue(v):forHTTPHeaderField(k)
        end
    end
    local postDataTask = session:dataTaskWithRequest_completionHandler(request, toblock(
        function(data ,response ,error)
            local myData = toobjc(data)
            local myString = NSString:initWithData_encoding(myData,4)
            --print(error)
            if error then
                if prop.lis then
                    prop.lis({isError = true, error = "unable to make request"})
                end
            else
                if prop.lis then
                    if myString then
                        prop.lis({isError = false, response = myString})
                    else
                        prop.lis({isError = true, error = "no data to return"})
                    end
                end
            end
        end
    ,{"void", "NSData *", "NSURLResponse *", "NSError *"}))
    postDataTask:resume()
end
--physics lib (work in progess)
m.physics = {}
m.physics.add = function (prop)
    if prop.bodyType == "texture" then
        --prop.obj:setPhysicsBody(SKPhysicsBody:bodyWithTexture_size(myObj:texture(), myObj:texture():size()))
    elseif prop.bodyType == "rect" then
        --prop.obj:setPhysicsBody(SKPhysicsBody:bodyWithRectangleOfSize()
    end
end
--system event lib
function m.mySystemLis(event)
    if m.systemLis ~= nil then
        m.systemLis(event)
    end
end
--Accel event lib
function m.startAccel(updateTime)
    if m.accelLis ~= nil then
        accel = CMMotionManager:init()
        if updateTime then
            accel:setAccelerometerUpdateInterval(updateTime*.001)
        else
            accel:setAccelerometerUpdateInterval(.5) -- .5 seconds
        end
        accel:startAccelerometerUpdatesToQueue_withHandler(operQueue, toblock(
            function(accelerometerData, error)
                local myString = tostring(accelerometerData)
                local cutXs = myString:split(" x ")
                local cutYs = cutXs[2]:split(" y ")
                local cutZs = cutYs[2]:split(" z ")
                local cutAts = cutZs[2]:split(" @ ")
                m.accelLis({x = tonumber(cutYs[1]),y = tonumber(cutZs[1]),z = tonumber(cutAts[1]) })
            end
        ,{"void", "CMAccelerometerData *", "NSError *"}))
    end
end
function m.stopAccel()
    accel:stopAccelerometerUpdates()
end
--save and load lib
function m.load()
    local data = NSUserDefaults:standardUserDefaults():objectForKey("appleWatch")
    local dataAsTable
    if(data) then
        dataAsTable =json.parse(data)
    end
    return dataAsTable
end
function m.save(data)
    local defaults = NSUserDefaults:standardUserDefaults()
    defaults:setObject_forKey(json.stringify(data), "appleWatch")
    defaults:synchronize()
end
return m
