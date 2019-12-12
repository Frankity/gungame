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
	self.LoadEvent = Events:Subscribe("Level:LoadResources", self, self.OnLoadResources)
	self.ReadInstanceEvent = Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	self.UpdateEvent = Events:Subscribe("Engine:Update", self, self.OnEngineUpdate)
	Hooks:Install('UI:PushScreen', 999, self, self.OnPushedScreen)
	Hooks:Install('ResourceManager:LoadBundle',999, self, self.OnLoadBundle)
end

function GunGameClient:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))
end


function GunGameClient:OnLoadResources(p_Dedicated)
	print("OnLoadResources")
	
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
	if(s_Screen.name == "UI/Flow/Screen/Weapon/CrosshairDefault") then
		p_Hook:Pass(self.Screens['UI/Flow/Screen/Weapon/DebugScreenCrosshairs'], p_GraphPriority, p_ParentGraph)
	end

end

function GunGameClient:SetSetting(p_SettingName, p_Field, p_Value)
	local p_Setting = ResourceManager:GetSettings(p_SettingName)
	if p_Setting ~= nil then
		print(p_SettingName)
		local s_Setting = _G[p_SettingName](p_Setting)
		s_Setting[firstToLower(p_Field)] = p_Value
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