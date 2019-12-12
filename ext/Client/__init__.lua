class 'GunGameClient'

function GunGameClient:__init()
	print("Initializing GunGameClient")
	self:RegisterVars()
	self:RegisterEvents()
end


function GunGameClient:RegisterVars()
	self.Screens = {}
end

function GunGameClient:RegisterEvents()
	Events:Subscribe("Level:LoadResources", self, self.OnLoadResources)
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe("Engine:Update", self, self.OnEngineUpdate)
	Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	Hooks:Install('UI:PushScreen', 999, self, self.OnPushedScreen)
	Hooks:Install('ResourceManager:LoadBundle',999, self, self.OnLoadBundle)
	NetEvents:Subscribe('Event:Client', self, self.OnRequest)
	NetEvents:Subscribe('Event:Server', self, self.OnReceive)

end

function GunGameClient:OnReceive(score)
	print('server sent ' .. score)
end

function GunGameClient:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))
end

function GunGameClient:OnUpdateInput(p_Delta)
    if InputManager:WentKeyDown(InputDeviceKeys.IDK_Tab) then
        WebUI:BringToFront()
        --WebUI:EnableMouse()
		WebUI:Show()
	elseif InputManager:WentKeyUp(InputDeviceKeys.IDK_Tab) then
		--WebUI:DisableMouse()
        WebUI:Hide()
    end
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_F2) then
		local player = PlayerManager:GetLocalPlayer()
		NetEvents:SendLocal('Event:Client', player)
	end
end


function GunGameClient:OnLoadResources(p_Dedicated)
	print("OnLoadResources")
	WebUI:Init()
	WebUI:Hide()
end

function GunGameClient:OnEngineUpdate(p_Delta, p_SimDelta)
	if self.m_loadHandle == nil then 
		return 
	end
	
	if not ResourceManager:PollBundleOperation(self.m_loadHandle) then 
		return 
	end
	
	if not ResourceManager:EndLoadData(self.m_loadHandle) then
		print("Bundles failed to load")
		return
	end
	
	self.m_loadHandle = nil
	
end

function GunGameClient:OnPushedScreen(p_Hook, p_Screen, p_GraphPriority, p_ParentGraph)
	if p_Screen == nil then
	    return
	end
	local s_Screen = UIGraphAsset(p_Screen)
	print("Pushed: " .. s_Screen.name)
	if(s_Screen.name == "UI/Flow/Screen/Scoreboards/ScoreboardTwoTeamsHUD32Screen") then
		p_Hook:Pass(self.Screens['UI/Flow/Screen/EmptyScreen'], p_GraphPriority, p_ParentGraph)
	end
end

function GunGameClient:OnPartitionLoaded(partition)
	local instance = partition.instances 


	for _, l_Instance in ipairs(instance) do
		if l_Instance == nil then
			print('Instance is null?')
			break
		end

		if l_Instance.typeInfo.name == "UIScreenAsset" then
			local s_Instance = UIGraphAsset(l_Instance)
			print("Found: " .. s_Instance.name)
			self.Screens[s_Instance.name] = UIGraphAsset(l_Instance)
		end
	end
end
function firstToLower(str)
	return (str:gsub("^%L", string.lower))
end

 
return GunGameClient()