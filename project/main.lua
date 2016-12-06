local scottLib = require("scottLib")
local json = require("json")

--set app title
scottLib.setTitle("My App")
--image example
local myImage=scottLib.image.create({image="arrow.png"})
scottLib.image.pos({x = scottLib.centerX, y = scottLib.centerY, obj = myImage})
scottLib.image.rotate({obj = myImage, rotation= 45})
local myX, myY
scottLib.image.color({red= 0, green = 1, blue =0, alpha =1, obj = myImage} )
--text example
local myText=scottLib.text.create({text = "Hello World", x = scottLib.centerX, y = scottLib.screenHeight-20, size= 20})
scottLib.text.color({red= 1, green = 0, blue =0, alpha =1, obj = myText} )
--touch example
function scottLib.tapTouchLis(e)
    print("tap at X:"..e.x..",Y:"..e.y)
end
function scottLib.longTouchLis(e)
    print("long touch at X:"..e.x..",Y:"..e.y)
end
function scottLib.panTouchLis(e)
    myX = e.x
    myY = e.y
    scottLib.image.pos({x = myX, y = myY, obj = myImage})
end

--timers
scottLib.timer.create({time =2000, lis = function ( e )
    print("hello there")
end})

local timerCounter = 1
local timer1
timer1 = scottLib.timer.create({time =10000, lis = function ( e )
    print("it has been 10 seconds")
    timerCounter = timerCounter+1
    if(timerCounter == 10)then
        print("stopped timer")
        scottLib.timer.stop(timer1)
    end
end, loop = true})
--time an date
print("time")
print("-------------")
print(scottLib.getTime())
print("-------------")
print("date")
print("-------------")
print(scottLib.getDate())
print("-------------")

--taptic
scottLib.timer.create({time =2000, lis = function ( e )
    --scottLib.taptic("notification")
end})

--sound

--local soundObj=scottLib.sound.create("click.wav")
--scottLib.sound.volume({obj=soundObj, volume = 1, duration = 0.01})
--scottLib.sound.play(soundObj)

--present media
--scottLib.presentMedia({file = "Demo.m4v"})-- this will delete the title name

--system
scottLib.systemLis = function(type)
    print(type)
end

--Accel
scottLib.accelLis = function(event)
    scottLib.text.set({obj=myText, text = "Accel X:"..event.x..",Y:"..event.y..",Z:"..event.z})
end
scottLib.startAccel()
--networking
scottLib.network.request({url = "http://www.timeapi.org/utc/now", method = "GET", lis = function (e)
    print("The time from utc is :"..e.response)
end})

--save and load
--scottLib.save({"hello"})
local myLoadData = scottLib.load()
print("saved data")
print("----------")
if (myLoadData) then
    print(json.stringify(myLoadData))
else
    print("no data")
end
print("----------")
