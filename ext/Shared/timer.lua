local Timer = class("Timer")

function Timer:__init(timeInSeconds, looping, object, callback)
    self.callback = callback
    self.object = object
    self.maxTime = timeInSeconds
    self.looping = looping

    self.elapsedTime = 0

    self.event = nil
    
    self:Start()
end

function Timer:OnUpdate(delta, simulationDelta)
    self.elapsedTime = self.elapsedTime + delta
    if self.elapsedTime >= self.maxTime then
        self.callback(self.object)
        if not looping then
            self:Stop()
        else
            self.elapsedTime = 0
        end
    end
end

function Timer:Stop()
    self.event:Unsubscribe()
end

function Timer:Start()
    self.event = Events:Subscribe('Engine:Update', self, self.OnUpdate)
end