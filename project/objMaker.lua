waxClass{"objMaker"}

function initTimer(self, func, time, loop)
  self.super:init()
  self.func = func
  self.time = time
  self.loop = loop
  return self
end
function initBlank(self)
    self.super:init()
    self.name = "hello"
    return self
end
function scottLibTimerHandler(timer)
    timer.func()
end
