class 'GunGameServer'

local weaponList = {firstWeapon = ""} --, secondWeapon = "", thirdWeapon = "", fourthWeapon = "", fifthWeapon = "", sixthWeapon = "", seventhWeapon = "", egithWeapon = "", ninthWeapon = "", tenWeapon = ""}
local soldierAppearance = { one = "Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Jungle", two = "Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Navy", three = "Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Ninja", four = "Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Para", five = "Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Ranger", six = "Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Specact", seven ="Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_Urban" }
local inputsToDisable = { 16, 18, 19, 20, 21, 22, 23, 31, 40, 41 }
local soldierAppFound = {}
local soldierAsset = nil
local soldierBlueprint = nil
local primaryWeapon = nil
local secondaryWeapon = nil
local thirdWeapon = nil
local weaponAtt0 = nil
local weaponAtt1 = nil

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
	Events:Subscribe('Level:LoadResources', OnLoadResources)
	Events:Subscribe("Player:Respawn", self, self.OnPlayerSpawn)

end

function GunGameServer:RegisterVars()
end

function GunGameServer:OnLoadResources()
	soldierAsset = nil
	soldierBlueprint = nil
	primaryWeapon = nil
	secondaryWeapon = nil
	thirdWeapon = nil
	weaponAtt0 = nil
	weaponAtt1 = nil
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

			if asset.name == 'Weapons/M416/U_M416' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				primaryWeapon = asset
			elseif asset.name == 'Weapons/Glock17/U_Glock17' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				secondaryWeapon = asset
			end
			if asset.name == 'Weapons/Gadgets/T-UGS/U_UGS' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				thirdWeapon = asset
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

function GunGameServer:OnPlayerSpawn(player)
	print('checking player')
	if player == nil then
		print('playr should be dead to spawn')
		return
	end

	print('Setting soldier primary weapon')
	player:SelectWeapon(WeaponSlot.WeaponSlot_0, primaryWeapon, { weaponAtt0, weaponAtt1 })
	player:SelectWeapon(WeaponSlot.WeaponSlot_1, secondaryWeapon, {})

	print('Setting soldier class and appearance')
	player:SelectUnlockAssets(soldierAsset, { getRandomSoldierApp() })

	player.soldier:SetCurrentPrimaryAmmo(0)
	player.soldier:SetCurrentSecondaryAmmo(0)
	
	for _, input in pairs(inputsToDisable) do
		player:EnableInput(input, false)
	end

	print('Soldier spawned')

end

function GunGameServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	
end

g_GunGameServer = GunGameServer()

