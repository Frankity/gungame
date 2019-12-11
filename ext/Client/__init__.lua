class 'GunGameClient'


function GunGameClient:__init()
	print("Initializing GunGameClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function GunGameClient:RegisterVars()
	
end

function GunGameClient:RegisterEvents()
	self.m_ReadInstanceEvent = Events:Subscribe('Partition:ReadInstance', self, self.ReadInstance)
end

return GunGameClient()