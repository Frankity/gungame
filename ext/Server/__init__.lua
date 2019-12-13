class 'GunGameServer'

local soldierAppearance = { 
	jungle = Guid("BE5BE457-641C-424E-B54E-068490322F3D"),
	navy = Guid("F064241F-A3F7-40FB-919C-BDBE1295393F"),
	ninja = Guid("A9923B54-3913-4C95-AF67-AA0491A13DF6"),
	para = Guid("35C84D2A-A360-4648-B0AA-10FAE4D64A8F"),
	ranger = Guid("2558F475-E366-42EF-91E2-3951EF9A3E39"),
	spec = Guid("01A806BA-49FA-4CAD-B923-2ACBD8155834"),
	urban = Guid("BA2F7234-849B-4645-BF84-5A68AEB0293C")
}

local weapons = {
	m9 = Guid("B145A444-BC4D-48BF-806A-0CEFA0EC231B", "D"),
	m44 = Guid("1EA227D8-2EB5-A63B-52FF-BBA9CFE34AD8", "D"),
	g18 = Guid("DB364A96-08FB-4C6E-856B-BD9749AE0A92", "D"),
	m1911 = Guid("A76BB99E-ABFE-48E9-9972-5D87E5365DAB", "D"),
	spas12 = Guid("6D99F118-04BD-449A-BA0E-1978DDF5894D", "D"),
	l96 = Guid(" CBAEC77C-A6AD-4D63-96BD-61FCA6C18417", "D"),
	ak74 = Guid("3BA55147-6619-4697-8E2B-AC6B1D183C0E", "D"),
	p90 = Guid("C12E6868-FC08-4E25-8AD0-1C51201EA69B", "D"),
	l86 = Guid("BA0AF247-2E5B-4574-8F89-515DFA1C767D", "D"),
	m98 = Guid("05EB2892-8B51-488E-8956-4350C3D2BA27", "D"),
	dao12 = Guid("27F63AEA-DD70-4929-9B08-5FF8F075B75E", "D"),
	mp7 = Guid("04C8604E-37DE-4B51-B70A-66468003D604", "D"),
	ump45 = Guid("2A267103-14F2-4255-B0D4-819139A4E202", "D"),
	m249 = Guid("AEAA518B-9253-40C2-AA18-A11F8F2D474C", "D"),
	type95 = Guid("FE05ACAA-32FC-4FD7-A34B-61413F6F7B1A", "D"),
	mg36 = Guid("95E00B23-BAD4-4F3B-A85E-990204EFF26B", "D"),
	pp19 = Guid("CECC74B7-403F-4BA1-8ECD-4A59FB5379BD", "D"),
}

local inputsToDisable = { 17, 18, 19, 20, 21, 22, 23, 31, 40, 41 }
local soldierAppFound = {}
local soldierAsset = nil
local soldierBlueprint = nil
local primaryWeapon = nil
local secondaryWeapon = nil
local thirdWeapon = nil
local weaponAtt0 = nil
local weaponAtt1 = nil
local knife = nil
local noGadget1 = nil
local medicbag = nil

local weaponOrder = {
	weapons.m9,
	weapons.m44,
	weapons.g18,
	weapons.m1911 ,
	weapons.spas12,
	weapons.l96,
	weapons.ak74,
	weapons.p90,
	weapons.l86,
	weapons.m98,
	weapons.dao12 ,
	weapons.mp7,
	weapons.ump45,
	weapons.m249,
	weapons.type95,
	weapons.mg36,
	weapons.pp19
}

local playersScores = {}

function GunGameServer:__init()
	print("Initializing GunGameServer")
	self:RegisterEvents()
	self:RegisterVars()
end

function GunGameServer:RegisterEvents()
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	--Events:Subscribe('Level:LoadResources', OnLoadResources)
	Events:Subscribe('Player:Respawn', self, self.OnPlayerSpawn)
	Events:Subscribe('Extension:Unloading', self, self.OnExtensionUnloading)
	Events:Subscribe('Player:Killed', self, self.OnPlayerKilled)
	Events:Subscribe('Server:LevelLoaded', self, self.OnLevelLoaded)
	Events:Subscribe('Player:Joining', self, self.OnPlayerJoining)
	NetEvents:Subscribe('Event:Server', self, self.OnReceive)

end

function GunGameServer:OnPlayerJoining(playerName, PlayerGUID, ip)

end

function GunGameServer:OnLevelLoaded()
	self.weaponOrder = {
		weapons.m9,
		weapons.m44,
		weapons.g18,
		weapons.m1911 ,
		weapons.spas12,
		weapons.l96,
		weapons.ak74,
		weapons.p90,
		weapons.l86,
		weapons.m98,
		weapons.dao12 ,
		weapons.mp7,
		weapons.ump45,
		weapons.m249,
		weapons.type95,
		weapons.mg36,
		weapons.pp19
	}
end

function GunGameServer:OnPlayerKilled(player, inflictor, position, weapon, roadkill, headshot, victimInReviveState)
	if player == nil or inflictor == nil then return end


	if playersScores[inflictor.name] == nil then 
		playersScores[inflictor.name] = {score = 1}
	end
	local inflictorScore = playersScores[inflictor.name]
	
	print("updating score of ".. inflictor.name .. ", old: ".. playersScores[inflictor.name].score)

	inflictorScore.score = math.min(inflictorScore.score + 1, #self.weaponOrder)
	print("new: ".. playersScores[inflictor.name].score)
	self:UpdateWeapon(inflictor)
	
end

function GunGameServer:RegisterVars()
	self:ResetVars()
end

function GunGameServer:ResetVars()
	soldierAppFound = {}
	soldierAsset = nil
	soldierBlueprint = nil
	primaryWeapon = nil
	secondaryWeapon = nil
	thirdWeapon = nil
	weaponAtt0 = nil
	weaponAtt1 = nil
	knife = nil
	noGadget1 = nil
	medicbag = nil
	self.weaponOrder = nil
end

function GunGameServer:OnExtensionUnloading()
	self:ResetVars()
end

function GunGameServer:OnPartitionLoaded(partition)
	local instances = partition.instances	
	for _, instance in pairs(instances) do
	
		if instance.typeInfo.name == 'VeniceSoldierCustomizationAsset' then
			local asset = VeniceSoldierCustomizationAsset(instance)

			if asset.name == 'Gameplay/Kits/RURecon' then
				soldierAsset = asset
			end
			
		end
		if instance.typeInfo.name == 'SoldierBlueprint' then
			soldierBlueprint = SoldierBlueprint(instance)
			print('Found soldier blueprint ' .. soldierBlueprint.name)
		end

		if instance.typeInfo.name == 'SoldierWeaponUnlockAsset' then
			local asset = SoldierWeaponUnlockAsset(instance)
			for i, uAsset in pairs(weapons) do
				local instanceData = ResourceManager:SearchForInstanceByGUID(uAsset)
				if instanceData ~= nil then
					weapons[i] = instanceData
				end
			end
			if asset.name == 'Weapons/M416/U_M416' then
			
				weapons.primaryWeapon = asset
			elseif asset.name == 'Weapons/Glock17/U_Glock17' then
			
				weapons.secondaryWeapon = asset
			elseif asset.name == 'Weapons/Gadgets/T-UGS/U_UGS' then
			
				thirdWeapon = asset
			elseif asset.name == 'Weapons/Knife/U_Knife' then
			
				knife = asset
			elseif asset.name == 'Weapons/Gadgets/Medicbag/U_Medkit' then

				medicbag = asset
			end
		end
		if instance.typeInfo.name == 'UnlockAsset' then
			local asset = UnlockAsset(instance)

			if asset.name == 'Weapons/M416/U_M416_ACOG' then
				print('Found weapon unlock asset ' .. asset.name)
				weaponAtt0 = asset
			end

			if asset.name == 'Weapons/M416/U_M416_Silencer' then
				print('Found weapon unlock asset ' .. asset.name)
				weaponAtt1 = asset
			end

			if asset.name == 'Weapons/Common/NoGadget1' then
				print('Found weapon unlock asset ' .. asset.name)
				noGadget1 = asset
			end
			
			for i, sAsset in pairs(soldierAppearance) do 
				local appearanceInatance = ResourceManager:SearchForInstanceByGUID(sAsset)
				if appearanceInatance ~= nil then
					table.insert(soldierAppFound, appearanceInatance)
				end
			end
		end
	end
end

local function getRandomSoldierApp() 
    return soldierAppFound[math.random(1,#soldierAppFound)] 
end

function GunGameServer:UpdateWeapon(player)
	if player == nil or player.soldier == nil then
		print('playr should be dead to spawn')
		return
	end

	local playerScore = playersScores[player.name]
	local score = 1
	if playerScore ~= nil then
		score = playerScore.score
	end

	player:SelectWeapon(WeaponSlot.WeaponSlot_0, self.weaponOrder[score], {  })
	player.soldier:SetWeaponSecondaryAmmoByIndex(0, 1)

end

function GunGameServer:OnPlayerSpawn(player)
	
	if player == nil or player.soldier == nil then
		print('player should be dead to spawn')
		return
	end

	if playersScores[player.name] == nil then
		playersScores[player.name] = {score = 1}
	end

	self:UpdateWeapon(player)
	player:SelectWeapon(WeaponSlot.WeaponSlot_1, knife, {})
	for i = 2, 8, 1 do
		player:SelectWeapon(i, knife, {})
		player.soldier:SetWeaponPrimaryAmmoByIndex(i, 0)
		player.soldier:SetWeaponSecondaryAmmoByIndex(i, 0)
	end
	
	player:SelectUnlockAssets(soldierAsset, { getRandomSoldierApp() })

	for _, input in next, inputsToDisable do
		player:EnableInput(input, false)
	end

end

function GunGameServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
end

function GunGameServer:OnReceive(player)
	print('player ' .. player.name .. ' ask for score data')
	NetEvents:SendTo('Event:Client', player, playersScores)
end

g_GunGameServer = GunGameServer()