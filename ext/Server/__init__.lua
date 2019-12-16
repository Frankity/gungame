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

local unlocksForWeapons = {
	l96pso = Guid("10969667-1B5B-CE2F-B6C0-11E89D00B713", "D"),
	ak74eotech = Guid("53B10FA8-2C64-BDB5-B195-6676EA575730", "D"),
	p90eotech = Guid("899132E3-168E-D0D8-3CF4-E52A623D024D", "D"),
	l86eotech = Guid("894F1EB5-555E-4A81-95CF-08AD25C69DCA", "D"),
	m96pso = Guid("2AAFF0F1-A2B7-F23C-523A-982B3F4C1F47", "D"),
	daoeotech = Guid("5256443A-9281-349D-ACE1-1807D0178147", "D"),
	mp7eotech = Guid("D182E80D-F6AE-91E4-C2B8-39DBCD12F18B","D"),
	ump45eotech = Guid("50DB86F0-493C-E9A1-91C7-E3C600FB928B", "D"),
	m249eotech = Guid("9A05157E-5916-7390-E49A-58125357587D", "D"),
	type95eotech = Guid("344B9D0A-7A7C-6B7C-4600-19A8DC30548F", "D"),
	mg36eotech = Guid("8C3CA26E-AA4E-22BA-ADBE-7F60617BF31E", "D"),
	pp19eotech = Guid("6C1F61A9-099D-4E2C-CD23-EC9B78675352", "D")
} 
-- we located weapons guid to use
local weapons = {
	m9 =     {guid = Guid("B145A444-BC4D-48BF-806A-0CEFA0EC231B", "D"), attachments = {}}, -- https://github.com/Powback/Venice-EBX/blob/071473993867cd2297dc662517c61edaff51e8fe/Weapons/M9/U_M9.txt
	m44 =    {guid = Guid("1EA227D8-2EB5-A63B-52FF-BBA9CFE34AD8", "D"), attachments = {}},
	g18 =    {guid = Guid("DB364A96-08FB-4C6E-856B-BD9749AE0A92", "D"), attachments = {}},
	m1911 =  {guid = Guid("A76BB99E-ABFE-48E9-9972-5D87E5365DAB", "D"), attachments = {}},
	spas12 = {guid = Guid("6D99F118-04BD-449A-BA0E-1978DDF5894D", "D"), attachments = {}},
	l96 =    {guid = Guid("CBAEC77C-A6AD-4D63-96BD-61FCA6C18417", "D"), attachments = {unlocksForWeapons.l96pso}},
	ak74 =   {guid = Guid("3BA55147-6619-4697-8E2B-AC6B1D183C0E", "D"), attachments = {unlocksForWeapons.ak74eotech}},
	p90 =    {guid = Guid("C12E6868-FC08-4E25-8AD0-1C51201EA69B", "D"), attachments = {unlocksForWeapons.p90eotech}},
	l86 =    {guid = Guid("BA0AF247-2E5B-4574-8F89-515DFA1C767D", "D"), attachments = {unlocksForWeapons.l86eotech}},
	m98 =    {guid = Guid("05EB2892-8B51-488E-8956-4350C3D2BA27", "D"), attachments = {unlocksForWeapons.m96pso}},
	dao12 =  {guid = Guid("27F63AEA-DD70-4929-9B08-5FF8F075B75E", "D"), attachments = {unlocksForWeapons.daoeotech}},
	mp7 =    {guid = Guid("04C8604E-37DE-4B51-B70A-66468003D604", "D"), attachments = {unlocksForWeapons.mp7eotech}},
	ump45 =  {guid = Guid("2A267103-14F2-4255-B0D4-819139A4E202", "D"), attachments = {unlocksForWeapons.ump45eotech}},
	m249 =   {guid = Guid("AEAA518B-9253-40C2-AA18-A11F8F2D474C", "D"), attachments = {unlocksForWeapons.m249eotech}},
	type95 = {guid = Guid("FE05ACAA-32FC-4FD7-A34B-61413F6F7B1A", "D"), attachments = {unlocksForWeapons.type95eotech}},
	mg36 =   {guid = Guid("95E00B23-BAD4-4F3B-A85E-990204EFF26B", "D"), attachments = {unlocksForWeapons.mg36eotech}},
	pp19 =   {guid = Guid("CECC74B7-403F-4BA1-8ECD-4A59FB5379BD", "D"), attachments = {unlocksForWeapons.pp19eotech}},
}

-- variable declarations
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

-- list with weapons in order
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

-- list to store scores on kill	
local playersScores = {}

local spawnPlaces = {}

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
	Events:Subscribe('Player:Left', self, self.OnPlayerLeft)
	Events:Subscribe('Engine:Update', self, self.OnEngineUpdate)
	Events:Subscribe('Server:RoundOver', self, self.OnServerRoundOver)
	NetEvents:Subscribe('Event:Server', self, self.OnReceive)
	NetEvents:Subscribe("Event:RequestSpawn", self, self.OnRequestSpawn)
end

function GunGameServer:OnPlayerJoining(playerName, PlayerGUID, ip)
end

function GunGameServer:OnRequestSpawn(player)
	if not player.alive then

		local transform = LinearTransform(
            Vec3(1,0,0),
            Vec3(0,1,0),
            Vec3(0,0,1),
            Vec3(0,0,0)
        )

        local spawnTransform = getRandomSpawnPoint().trans
        transform.trans.x = spawnTransform.x
        transform.trans.y = spawnTransform.y
		transform.trans.z = spawnTransform.z
		
        local soldier = player:CreateSoldier(soldierBlueprint, transform)
        
        if soldier == nil then
            print("failed to create soldier")
		end
		
		local playerScore = playersScores[player.id]
		local score = 1
	
		if playerScore ~= nil then
			score = playerScore.score
		end
	
		local weapon = ResourceManager:SearchForInstanceByGUID(self.weaponOrder[score].guid)
		local attachments = {}
	
		for _, attGuid in pairs(self.weaponOrder[score].attachments) do
			local attachment = ResourceManager:SearchForInstanceByGUID(attGuid)
			if attachment~= nil then
				table.insert(attachments, attachment)
			end
		end
	
		if weapon == nil then
			print("QUE COJONES")
			return
		end
	
		player:SelectWeapon(WeaponSlot.WeaponSlot_0, weapon, attachments)
	
        player:SpawnSoldierAt(soldier, transform, CharacterPoseType.CharacterPoseType_Stand)
	
		player.soldier:SetWeaponSecondaryAmmoByIndex(0, 1) 

        print('soldier spawned')

	end
end

function GunGameServer:OnEngineUpdate(deltaTime, simDeltaTime)
	local players = PlayerManager:GetPlayers()	
end

function GunGameServer:OnServerRoundOver(roundTime, winningTeam)
	self:ResetVars()
end
 
function GunGameServer:OnPlayerLeft(player)
    if player == nil then return end
    playersScores[player.id] = nil
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
    -- we check for the player inegrity cause "some times frostbite acts dumb --FoolHen"
	if player == nil or inflictor == nil then return end
	
    if playersScores[inflictor.id] == nil then
        local dataPlayer = {name = player.name, score = 1}
        playersScores[inflictor.id] = dataPlayer
    end
    
    local inflictorScore = playersScores[inflictor.id]
    print('score ' .. inflictorScore.score)
    print("updating score of ".. inflictor.name .. ", old: ".. inflictorScore.score)

    -- Update score
	inflictorScore.score = math.min(inflictorScore.score + 1, #self.weaponOrder)

    -- TEST: If the player suicided, set their score to #weapons - 1 if it isn't that already
    if player.id == inflictor.id and inflictorScore.score < #self.weaponOrder - 1 then
        inflictorScore.score = #self.weaponOrder - 1
	end

	print("new: ".. playersScores[inflictor.id].score)
	
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
	-- seeking for this to only load the desired spawnpoints just for debugging 
		if instance.typeInfo.name == "WorldPartData" then
			local wPData = WorldPartData(instance)
			local logic = "Levels/MP_012/TeamDeathmatch_Logic"
			if wPData.name:lower() == logic:lower() then
				print('found')
				if instance.typeInfo.name == 'AlternateSpawnEntityData' then
					local spawnData = AlternateSpawnEntityData(instance)
					if spawnData.team ~= TeamId.TeamNeutral then -- Make sure it's not a spectator position
						table.insert(spawnPlaces, spawnData.transform)
					end
				end
			end
		end
	
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
			if asset.name == 'Weapons/Knife/U_Knife' then
				knife = asset
			end
		end
		if instance.typeInfo.name == 'UnlockAsset' then
			for i, sAsset in pairs(soldierAppearance) do 
				local appearanceInatance = ResourceManager:SearchForInstanceByGUID(sAsset)
				if appearanceInatance ~= nil then
					table.insert(soldierAppFound, appearanceInatance)
				end
			end
		end
	end
end

function getRandomSoldierApp() 
    return soldierAppFound[math.random(1,#soldierAppFound)] 
end

function getRandomSpawnPoint()
	return spawnPlaces[math.random(1,#spawnPlaces)]
end

function GunGameServer:UpdateWeapon(player)
	if player == nil or player.soldier == nil then return end

	local playerScore = playersScores[player.id]
	local score = 1

	if playerScore ~= nil then
		score = playerScore.score
	end

	local weapon = ResourceManager:SearchForInstanceByGUID(self.weaponOrder[score].guid)
	local attachments = {}

	for _, attGuid in pairs(self.weaponOrder[score].attachments) do
		local attachment = ResourceManager:SearchForInstanceByGUID(attGuid)
		if attachment~= nil then
			table.insert(attachments, attachment)
		end
	end

	if weapon == nil then
		print("QUE COJONES")
		return
	end

	player:SelectWeapon(WeaponSlot.WeaponSlot_0, weapon, attachments)

	player.soldier:SetWeaponSecondaryAmmoByIndex(0, 1)

end

function endRound()
	print("ending round")
	ChatManager:SendMessage(" won the match, restarting in 10 seconds")
	RCON:SendCommand('mapList.runNextRound',{})
end

function GunGameServer:OnPlayerSpawn(player)

 	

end

function GunGameServer:ReadInstance(p_Instance,p_PartitionGuid, p_Guid)
end

function GunGameServer:OnReceive(player)
	-- sending player scores table to the client which requested it
	local players = PlayerManager:GetPlayers()
	for _, p in pairs(players) do
		if playersScores ~= nil then
			playersScores[p.id].ping = p.ping
		end
	end
	NetEvents:SendTo('Event:Client', player, playersScores)
end

g_GunGameServer = GunGameServer()