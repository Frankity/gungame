class 'GunGameServer'

local weaponList = {firstWeapon = ""} --, secondWeapon = "", thirdWeapon = "", fourthWeapon = "", fifthWeapon = "", sixthWeapon = "", seventhWeapon = "", egithWeapon = "", ninthWeapon = "", tenWeapon = ""}

local soldierAsset = nil
local soldierBlueprint = nil
local weapon = nil
local M320 = nil
local weaponAtt0 = nil
local weaponAtt1 = nil
local drPepper = nil

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
	weapon = nil
	M320 = nil
	weaponAtt0 = nil
	weaponAtt1 = nil
	drPepper = nil
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

		if instance.typeInfo.name == 'SoldierBlueprint' then
			soldierBlueprint = SoldierBlueprint(instance)
			print('Found soldier blueprint ' .. soldierBlueprint.name)
		end

		if instance.typeInfo.name == 'SoldierWeaponUnlockAsset' then
			local asset = SoldierWeaponUnlockAsset(instance)

			if asset.name == 'Weapons/M416/U_M416' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				weapon = asset
			elseif asset.name == 'Weapons/Glock17/U_Glock17' then
				print('Found soldier weapon unlock asset ' .. asset.name)
				M320 = asset
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
			if asset.name == 'Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Recon_Appearance_DrPepper' then
				print('Found appearance asset ' .. asset.name)
				drPepper = asset
			end
		end
	end
end


function GunGameServer:OnPlayerSpawn(player)
	print('checking player')
	if player == nil then
		print('playr should be dead to spawn')
		return
	end

	local transform = LinearTransform(
		Vec3(1, 0, 0),
		Vec3(0, 1, 0),
		Vec3(0, 0, 1),
		Vec3(0, 0, 0)
	)

	print(soldierBlueprint)

	print('Setting soldier primary weapon')
	player:SelectWeapon(WeaponSlot.WeaponSlot_0, weapon, { weaponAtt0, weaponAtt1 })
	player:SelectWeapon(WeaponSlot.WeaponSlot_1, M320, {})

	print('Setting soldier class and appearance')
	player:SelectUnlockAssets(soldierAsset, { drPepper })

	print('Creating soldier')
	local soldier = player:CreateSoldier(soldierBlueprint, transform)

	if soldier == nil then
		print('Failed to create player soldier')
		return
	end

	print('Spawning soldier')
	player:SpawnSoldierAt(soldier, transform, CharacterPoseType.CharacterPoseType_Prone)

	player.soldier:SetWeaponPrimaryAmmoByIndex(WeaponSlot.WeaponSlot_1, 0)
	player.soldier:SetWeaponSecondaryAmmoByIndex(WeaponSlot.WeaponSlot_1, 10)

	player.soldier:SetCurrentPrimaryAmmo(0)
	player.soldier:SetCurrentPrimaryAmmo(0)
	print('Soldier spawned')

--[[ 	local weaponUnlock = _G[weapon.typeInfo.name](weapon)
	weaponUnlock.unlockWeaponAndSlot.weapon = ak74mUnlock
	weaponUnlock.unlockWeaponAndSlot.slot = 1
	-- weaponUnlockPickupData.unlockWeaponAndSlot.unlockAssets:add() -- add attachments etc

	weaponUnlock.timeToLive = 300
	weaponUnlock.unspawnOnPickup = true
	weaponUnlock.positionIsStatic  = true
	weaponUnlock.allowPickup = true
	weaponUnlock.ignoreNullWeaponSlots = true
	weaponUnlock.forceWeaponSlotSelection  = true
	weaponUnlock.hasAutomaticAmmoPickup = true
	weaponUnlock.interactionRadius = 2.5
	weaponUnlock.replaceAllContent = true
	weaponUnlock.weapons:add(weapon)

	local s_Params = EntityCreationParams()
	s_Params.transform = player.soldier.transform
	s_Params.variationNameHash = 0
	s_Params.networked = true

	local entity = EntityManager:CreateEntity(weaponUnlockPickupEntityData, s_Params)
	entity:Init(Realm.Realm_Server, true) ]]

end

--[[ function GunGameClient:FirstWeapon(player)
	local weapon = ResourceManager:FindInstanceByGUID(Guid(weaponList.firstWeapon))
	if weapon == nil then
		error("instance not found")
	end

	local weaponUnlock = _G[weapon.typeInfo.name](weapon)
	weaponUnlock.unlockWeaponAndSlot.weapon = ak74mUnlock
	weaponUnlock.unlockWeaponAndSlot.slot = 1
	-- weaponUnlockPickupData.unlockWeaponAndSlot.unlockAssets:add() -- add attachments etc

	weaponUnlock.timeToLive = 300
	weaponUnlock.unspawnOnPickup = true
	weaponUnlock.positionIsStatic  = true
	weaponUnlock.allowPickup = true
	weaponUnlock.ignoreNullWeaponSlots = true
	weaponUnlock.forceWeaponSlotSelection  = true
	weaponUnlock.hasAutomaticAmmoPickup = true
	weaponUnlock.interactionRadius = 2.5
	weaponUnlock.replaceAllContent = true
	weaponUnlock.weapons:add(weapon)

	local s_Params = EntityCreationParams()
	s_Params.transform = player.soldier.transform
	s_Params.variationNameHash = 0
	s_Params.networked = true

	local entity = EntityManager:CreateEntity(weaponUnlockPickupEntityData, s_Params)
	entity:Init(Realm.Realm_Server, true)

end ]]

function GunGameServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
	
end

g_GunGameServer = GunGameServer()

