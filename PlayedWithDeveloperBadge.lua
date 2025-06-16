-- Put this in ServerScriptService
local BadgeService = game:GetService("BadgeService")
local Players = game:GetService("Players")

local DEV_USER_IDS = {
	[DEVIDHERE] = true
}

local BADGE_ID = BADGEIDHERE

local function isDev(userId)
	return DEV_USER_IDS[userId] == true
end

-- Helper to check if any dev is online
local function isAnyDevOnline()
	for _, player in ipairs(Players:GetPlayers()) do
		if isDev(player.UserId) then
			return true
		end
	end
	return false
end

local function awardBadgeToPlayer(player)
	-- Safety check: don't award to devs themselves :p
	if isDev(player.UserId) then return end

	local success, err = pcall(function()
		if not BadgeService:UserHasBadgeAsync(player.UserId, BADGE_ID) then
			BadgeService:AwardBadge(player.UserId, BADGE_ID)
		end
	end)
	if not success then
		warn("Failed to award badge to " .. player.Name .. ": " .. tostring(err))
	else
		print("Awarded badge to " .. player.Name)
	end
end

Players.PlayerAdded:Connect(function(player)
	wait(1) -- slight delay to ensure player list updates

	if isDev(player.UserId) then
		-- A dev joined: award badge to all non-dev players currently online
		for _, p in ipairs(Players:GetPlayers()) do
			awardBadgeToPlayer(p)
		end
	else
		-- Non-dev joined: check if any dev is online, award badge if yes
		if isAnyDevOnline() then
			awardBadgeToPlayer(player)
		end
	end
end)

--this is a comment
--the thing above is a comment
--yes i got bored dont ask.
--did i mention the thing above is a comment?
