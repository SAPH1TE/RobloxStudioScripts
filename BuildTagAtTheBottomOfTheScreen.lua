-- =================================
-- Game setup/variable deffinition
-- =================================
-- hours wasted (im new /w lua) -- 2.2
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local startTime = tick()

-- Platform detection
local function getPlatform()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		return "mobile"
	elseif UserInputService.GamepadEnabled then
		return "console"
	else
		return "pc"
	end
end

-- Build variables to print
local function getBuildInfo()
	local gamename = "GAME NAME HERE"
	local version = "GAME VERSION HERE"
	local build = "GAME BUILD HERE"
	local platform = getPlatform()
	local mode = RunService:IsStudio() and "debug active" or "LIVE"
	local username = player.Name
	local userId = player.UserId
	local date = os.date("%Y-%m-%d %H:%M:%S")
	local inputType = UserInputService:GetLastInputType().Name
	local fps = math.floor(1 / RunService.RenderStepped:Wait())


  --Displays the build variables
	return string.format(
		"Name: %s | version: %s | build: %s | platform: %s | mode: %s | user: %s (%d) | date: %s | input: %s | fps: %d",
		gamename, version, build, platform, mode, username, userId, date, inputType, fps
	)
end

-- UI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BuildInfoGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 0, 24)
container.Position = UDim2.new(0, 0, 1, -24)
container.BackgroundTransparency = 1
container.ClipsDescendants = true
container.Parent = screenGui

local label = Instance.new("TextLabel")
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.TextTransparency = 0.7
label.Font = Enum.Font.SourceSansBold
label.TextSize = 16
label.TextXAlignment = Enum.TextXAlignment.Left
label.Text = getBuildInfo()
label.Size = UDim2.new(0, 0, 1, 0)
label.Parent = container

-- Wait for label to fully render before measuring text
RunService.Heartbeat:Wait()
local textWidth = label.TextBounds.X
label.Size = UDim2.new(0, textWidth + 40, 1, 0)

-- Scroll loop
local function scroll()
	while true do
		label.Position = UDim2.new(0, container.AbsoluteSize.X, 0, 0)

		local tweenTime = textWidth / 50 -- tweak 50 for speed
		local tween = TweenService:Create(label, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {
			Position = UDim2.new(0, -textWidth, 0, 0)
		})

		tween:Play()
		tween.Completed:Wait()

		label.Text = getBuildInfo() -- Refresh info (e.g., FPS/input)
		textWidth = label.TextBounds.X
		label.Size = UDim2.new(0, textWidth + 40, 1, 0)

		wait(0.3)
	end
end

task.spawn(scroll)
