class 'GunGameServer'

local soldierAppearance = { 
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Jungle",
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Navy", 
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Ninja",
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Para", 
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Ranger",
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Specact",
	"Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Urban" 
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
--[[ local weapons = {
	secondaryWeapon = secondaryWeapon,
	primaryWeapon = primaryWeapon
} ]]

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

local playersScores = {

}



local m_AreaWidth = 10
local m_AreaLength = 20
local m_AreaHeight = 10

local m_StartingPos = {x=0, y=100, z=0}

function GunGameServer:__init()
	print("Initializing GunGameServer")
	self:RegisterEvents()
	self:RegisterVars()
end

function GunGameServer:RegisterEvents()
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)
	--Events:Subscribe('Level:LoadResources', OnLoadResources)
	Events:Subscribe("Player:Respawn", self, self.OnPlayerSpawn)
	Events:Subscribe('Extension:Unloading', self, self.OnExtensionUnloading)
	Events:Subscribe("Player:Killed", self, self.OnPlayerKilled)
	Events:Subscribe('Server:LevelLoaded', self, self.OnLevelLoaded)

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

--[[ 	local weaponcasted = _G[weapon.typeInfo.name](weapon)

	if string.fing(weaponcasted.name:lower(), "knife") then
		local victimScore = playersScores[player.name]

		if victimScore == nil then 
			victimScore = {}
		end

		victimScore.score = math.min(victimScore.score - 1, 1)
		self:UpdateWeapon(player)
		
		--player.score = victimScore.score
	end ]]


	if playersScores[inflictor.name] == nil then 
		playersScores[inflictor.name] = {score = 1}
	end
	local inflictorScore = playersScores[inflictor.name]
	
	print("updating score of ".. inflictor.name .. ", old: ".. inflictor.score)

	inflictorScore.score = math.max(inflictorScore.score + 1, #self.weaponOrder)
	print("new: ".. inflictor.score)
	self:UpdateWeapon(inflictor)
	--player.score 
	--player.kills
	--player.deaths

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
				print('Found soldier customization asset ' .. asset.name)
				soldierAsset = asset
			end
			
		end
--rcon command to disable spawn on friend
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
				print('Found soldier weapon unlock asset ' .. asset.name)
				weapons.primaryWeapon = asset
			elseif asset.name == 'Weapons/Glock17/U_Glock17' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				weapons.secondaryWeapon = asset
			elseif asset.name == 'Weapons/Gadgets/T-UGS/U_UGS' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				thirdWeapon = asset
			elseif asset.name == 'Weapons/Knife/U_Knife' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				knife = asset
			elseif asset.name == 'Weapons/Gadgets/Medicbag/U_Medkit' then
				print('Found soldier weapon unlock asset ' .. asset.name)
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
			
			for _, sAsset in pairs(soldierAppearance) do 
				if asset.name == sAsset then
					print('Found appearance asset ' .. asset.name)
					table.insert(soldierAppFound, asset)
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
	print("updating weapon, score: "..score)
	print(#self.weaponOrder)
	print(self.weaponOrder[score])
	player:SelectWeapon(WeaponSlot.WeaponSlot_0, self.weaponOrder[score], {  })
	
	player.soldier:SetWeaponSecondaryAmmoByIndex(0, 1)

end

function GunGameServer:OnPlayerSpawn(player)
	print('checking player')
	if player == nil or player.soldier == nil then
		print('playr should be dead to spawn')
		return
	end

	
	self:UpdateWeapon(player)
	
--	player:SelectWeapon(WeaponSlot.WeaponSlot_0, weaponOrder[1], {  })
	player:SelectWeapon(WeaponSlot.WeaponSlot_1, knife, {})
	--player.soldier:SetWeaponPrimaryAmmoByIndex(0, 0)
	--player.soldier:SetWeaponSecondaryAmmoByIndex(0, 1)

	for i = 2, 8, 1 do
		player:SelectWeapon(i, knife, {})
		player.soldier:SetWeaponPrimaryAmmoByIndex(i, 0)
		player.soldier:SetWeaponSecondaryAmmoByIndex(i, 0)
	end
	
	print('Setting soldier class and appearance')
	player:SelectUnlockAssets(soldierAsset, { getRandomSoldierApp() })

	
	
	for _, input in next, inputsToDisable do
		player:EnableInput(input, false)
	end

	print('Soldier spawned')

end

function GunGameServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	
end

g_GunGameServer = GunGameServer()

