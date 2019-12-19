class 'GunGameClient'

function GunGameClient:__init()
	print("Initializing GunGameClient")
	self:RegisterVars()
	self:RegisterEvents()
end

function GunGameClient:RegisterVars()
	self.Screens = {}
	self.playersScores = {}
end

function GunGameClient:RegisterEvents()
	Events:Subscribe("Level:LoadResources", self, self.OnLoadResources)
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	Events:Subscribe("Engine:Update", self, self.OnEngineUpdate)
	Events:Subscribe('Extension:Unloading', self, self.OnExtensionUnloading)
	Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	NetEvents:Subscribe('Event:Client', self, self.OnReceive)
	Hooks:Install('UI:PushScreen', 999, self, self.OnPushedScreen)
	Hooks:Install('UI:DrawNametags', 999, self, self.DrawNametags)
	Hooks:Install('UI:DrawMoreNametags', 999, self, self.DrawMoreNametags)
	Hooks:Install('UI:RenderMinimap', 999, self, self.RenderMinimap)
	Hooks:Install('ResourceManager:LoadBundle', 999, self, self.OnLoadBundle)
end

function GunGameClient:CreateKillMessage(p_Hook)
    p_Hook:Return(nil)
end

function GunGameClient:DrawNametags(p_Hook)
    p_Hook:Return(nil)
end

function GunGameClient:DrawMoreNametags(p_Hook)
    p_Hook:Return(nil)
end

function GunGameClient:OnExtensionUnloading()
	self:ResetVars()
end

function GunGameClient:ResetVars()
	Screens = {}
	playersScores = {}
end

function GunGameClient:OnReceive(p_Scores)
	--self.playersScores = p_Scores
	print(p_Scores)
	--WebUI:ExecuteJS("removeOldData()")
	print(json.encode(p_Scores))
	
	WebUI:ExecuteJS(string.format("loadScoreBoardData(%s)", json.encode(p_Scores)))
end

function GunGameClient:OnLoadBundle(p_Hook, p_Bundle)
	print(string.format("Loading bundle '%s'", p_Bundle))
end

function GunGameClient:OnUpdateInput(p_Delta)
	local player = PlayerManager:GetLocalPlayer()
	if InputManager:WentKeyDown(InputDeviceKeys.IDK_Tab) then
		--WebUI:EnableMouse()
		if player.soldier ~= nil then
			WebUI:ExecuteJS("showScoreBoard()")
		end
	elseif InputManager:WentKeyUp(InputDeviceKeys.IDK_Tab) then
		--WebUI:DisableMouse()
		WebUI:ExecuteJS("hideScoreBoard()")
    end
	
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

	if s_Screen.name == "UI/Flow/Screen/SpawnScreenPC" then
		local player = PlayerManager:GetLocalPlayer()
		NetEvents:SendLocal("Event:RequestSpawn", player.id)
	end

	if s_Screen.name:sub(1, 26) == "UI/Flow/Screen/Scoreboards" or s_Screen.name:sub(1, 36) == "UI/Flow/Screen/PreRoundWaitingScreen" then
		p_Hook:Pass(self.Screens['UI/Flow/Screen/EmptyScreen'], p_GraphPriority, p_ParentGraph)
		-- added here to send the event only when the client call the scoreboard and has a soldier 		
		local player = PlayerManager:GetLocalPlayer()
		if player.soldier ~= nil then
			NetEvents:SendLocal('Event:Server', player)
		end
	end

	if s_Screen.name:find("Spawn") then
        p_Hook:Pass(self.Screens['UI/Flow/Screen/EmptyScreen'], p_GraphPriority, p_ParentGraph)
        return
    end

end

function GunGameClient:OnPartitionLoaded(partition)
	local instance = partition.instances 

	WebUI:Init()
	WebUI:BringToFront()
	WebUI:ExecuteJS("hideScoreBoard()")

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