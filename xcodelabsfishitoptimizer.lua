-- Roblox Lightweight Tools UI - FISH-IT OPTIMIZED
-- Fitur: Anti AFK, Auto Clean, Cache Monitor, FPS Stabilizer, Heavy Stuff Reducer
-- Version: 3.0 - Fish-It Game Optimized
-- Tools by: Xcodelabs

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Buat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XcodelabsTools"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Variabel untuk state
local isMinimized = false
local isAntiAFKEnabled = false
local isAutoCleanEnabled = false
local isFPSBoostEnabled = false
local isHeavyReducerEnabled = false
local lastCleanTime = tick()
local cleanedObjectsCount = 0
local totalCacheObjects = 0
local connections = {}

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 420)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(0.5, 0, 0.55, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Fish-It Optimizer v3.0"
titleText.TextColor3 = Color3.fromRGB(100, 200, 255)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 3
titleText.Parent = titleBar

local subtitleText = Instance.new("TextLabel")
subtitleText.Name = "Subtitle"
subtitleText.Size = UDim2.new(0.5, 0, 0.45, 0)
subtitleText.Position = UDim2.new(0, 12, 0.55, 0)
subtitleText.BackgroundTransparency = 1
subtitleText.Text = "by Xcodelabs"
subtitleText.TextColor3 = Color3.fromRGB(150, 150, 180)
subtitleText.TextSize = 9
subtitleText.Font = Enum.Font.Gotham
subtitleText.TextXAlignment = Enum.TextXAlignment.Left
subtitleText.ZIndex = 3
subtitleText.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -34, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 200, 200)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 3
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -68, 0, 6)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 255)
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.ZIndex = 3
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeButton

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 2
contentFrame.Parent = mainFrame

-- Minimized Frame
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Size = UDim2.new(0, 220, 0, 45)
minimizedFrame.Position = UDim2.new(1, -230, 0, 10)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
minimizedFrame.BackgroundTransparency = 0.1
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false
minimizedFrame.Active = true
minimizedFrame.Draggable = true
minimizedFrame.ZIndex = 2
minimizedFrame.Parent = screenGui

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 10)
minimizedCorner.Parent = minimizedFrame

local minimizedTitle = Instance.new("TextLabel")
minimizedTitle.Size = UDim2.new(1, -45, 1, 0)
minimizedTitle.Position = UDim2.new(0, 12, 0, 0)
minimizedTitle.BackgroundTransparency = 1
minimizedTitle.Text = "🎣 Fish-It Optimizer"
minimizedTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
minimizedTitle.TextSize = 13
minimizedTitle.Font = Enum.Font.GothamBold
minimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
minimizedTitle.ZIndex = 3
minimizedTitle.Parent = minimizedFrame

local maximizeButton = Instance.new("TextButton")
maximizeButton.Size = UDim2.new(0, 30, 0, 30)
maximizeButton.Position = UDim2.new(1, -35, 0.5, -15)
maximizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
maximizeButton.Text = "+"
maximizeButton.TextColor3 = Color3.fromRGB(220, 220, 255)
maximizeButton.TextSize = 18
maximizeButton.Font = Enum.Font.GothamBold
maximizeButton.ZIndex = 3
maximizeButton.Parent = minimizedFrame

local maximizeCorner = Instance.new("UICorner")
maximizeCorner.CornerRadius = UDim.new(0, 8)
maximizeCorner.Parent = maximizeButton

-- Helper function untuk membuat toggle frame
local function createToggleFrame(name, icon, description, position)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = UDim2.new(1, 0, 0, 65)
	frame.Position = UDim2.new(0, 0, 0, position)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	frame.BorderSizePixel = 0
	frame.ZIndex = 2
	frame.Parent = contentFrame
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 8)
	frameCorner.Parent = frame
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.55, 0, 0, 22)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = icon .. " " .. name
	title.TextColor3 = Color3.fromRGB(220, 220, 255)
	title.TextSize = 13
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 3
	title.Parent = frame
	
	local desc = Instance.new("TextLabel")
	desc.Name = "Description"
	desc.Size = UDim2.new(1, -20, 0, 32)
	desc.Position = UDim2.new(0, 10, 0, 30)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.TextColor3 = Color3.fromRGB(180, 180, 220)
	desc.TextSize = 10
	desc.Font = Enum.Font.Gotham
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextYAlignment = Enum.TextYAlignment.Top
	desc.TextWrapped = true
	desc.ZIndex = 3
	desc.Parent = frame
	
	local toggle = Instance.new("TextButton")
	toggle.Name = "Toggle"
	toggle.Size = UDim2.new(0, 65, 0, 28)
	toggle.Position = UDim2.new(1, -75, 0, 6)
	toggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
	toggle.Text = "OFF"
	toggle.TextColor3 = Color3.fromRGB(255, 180, 180)
	toggle.TextSize = 12
	toggle.Font = Enum.Font.GothamBold
	toggle.ZIndex = 3
	toggle.Parent = frame
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 6)
	toggleCorner.Parent = toggle
	
	return frame, toggle, desc
end

-- Create feature frames
local antiAFKFrame, antiAFKToggle, antiAFKDesc = createToggleFrame("Anti AFK", "🎮", "Mencegah kick AFK", 0)
local cleanFrame, cleanToggle, cleanDesc = createToggleFrame("Auto Clean", "🗑️", "Interval: 5 menit", 72)
local fpsFrame, fpsToggle, fpsDesc = createToggleFrame("FPS Stabilizer", "⚡", "Boost performa game", 144)
local heavyFrame, heavyToggle, heavyDesc = createToggleFrame("Heavy Reducer", "🎯", "Reduce lag objects", 216)

-- Cache Monitor
local cacheMonitorFrame = Instance.new("Frame")
cacheMonitorFrame.Size = UDim2.new(1, 0, 0, 70)
cacheMonitorFrame.Position = UDim2.new(0, 0, 0, 288)
cacheMonitorFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
cacheMonitorFrame.BorderSizePixel = 0
cacheMonitorFrame.ZIndex = 2
cacheMonitorFrame.Parent = contentFrame

local cacheCorner = Instance.new("UICorner")
cacheCorner.CornerRadius = UDim.new(0, 8)
cacheCorner.Parent = cacheMonitorFrame

local cacheTitle = Instance.new("TextLabel")
cacheTitle.Size = UDim2.new(1, -20, 0, 22)
cacheTitle.Position = UDim2.new(0, 10, 0, 6)
cacheTitle.BackgroundTransparency = 1
cacheTitle.Text = "📊 Cache Monitor"
cacheTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
cacheTitle.TextSize = 13
cacheTitle.Font = Enum.Font.GothamBold
cacheTitle.TextXAlignment = Enum.TextXAlignment.Left
cacheTitle.ZIndex = 3
cacheTitle.Parent = cacheMonitorFrame

local cacheCount = Instance.new("TextLabel")
cacheCount.Size = UDim2.new(1, -20, 0, 18)
cacheCount.Position = UDim2.new(0, 10, 0, 30)
cacheCount.BackgroundTransparency = 1
cacheCount.Text = "Scanning..."
cacheCount.TextColor3 = Color3.fromRGB(150, 220, 150)
cacheCount.TextSize = 11
cacheCount.Font = Enum.Font.GothamMedium
cacheCount.TextXAlignment = Enum.TextXAlignment.Left
cacheCount.ZIndex = 3
cacheCount.Parent = cacheMonitorFrame

local cacheStatus = Instance.new("TextLabel")
cacheStatus.Size = UDim2.new(1, -20, 0, 16)
cacheStatus.Position = UDim2.new(0, 10, 0, 50)
cacheStatus.BackgroundTransparency = 1
cacheStatus.Text = "Last Clean: Never"
cacheStatus.TextColor3 = Color3.fromRGB(180, 180, 220)
cacheStatus.TextSize = 9
cacheStatus.Font = Enum.Font.Gotham
cacheStatus.TextXAlignment = Enum.TextXAlignment.Left
cacheStatus.ZIndex = 3
cacheStatus.Parent = cacheMonitorFrame

-- ==========================
-- ANTI AFK SYSTEM (REAL)
-- ==========================
local lastAFKAction = tick()
local afkActionCount = 0

local function performAntiAFK()
	if not isAntiAFKEnabled then return end
	
	local currentTime = tick()
	if currentTime - lastAFKAction >= 18 then
		lastAFKAction = currentTime
		afkActionCount = afkActionCount + 1
		
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
		
		antiAFKDesc.Text = string.format("Active | Actions: %d", afkActionCount)
		print(string.format("[Anti AFK] Action #%d", afkActionCount))
	end
end

table.insert(connections, player.Idled:Connect(function()
	if isAntiAFKEnabled then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
		print("[Anti AFK] Prevented kick!")
	end
end))

-- ==========================
-- CACHE MONITOR (REAL)
-- ==========================
local lastCacheUpdate = tick()

local function countCacheObjects()
	local particles = 0
	local sounds = 0
	local decals = 0
	local totalCount = 0
	local checked = 0
	
	pcall(function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			checked = checked + 1
			if checked > 400 then break end
			
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
				if not obj.Enabled then
					particles = particles + 1
					totalCount = totalCount + 1
				end
			elseif obj:IsA("Sound") then
				if not obj.IsPlaying and not obj.Looped then
					sounds = sounds + 1
					totalCount = totalCount + 1
				end
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				if obj.Transparency >= 0.95 then
					decals = decals + 1
					totalCount = totalCount + 1
				end
			end
		end
	end)
	
	totalCacheObjects = totalCount
	cacheCount.Text = string.format("Total: %d (%dP %dS %dD)", totalCount, particles, sounds, decals)
	
	if totalCount < 25 then
		cacheCount.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif totalCount < 70 then
		cacheCount.TextColor3 = Color3.fromRGB(255, 200, 100)
	else
		cacheCount.TextColor3 = Color3.fromRGB(255, 100, 100)
	end
	
	return totalCount
end

-- ==========================
-- AUTO CLEAN CACHE (REAL)
-- ==========================
local function performCleanCache()
	if not isAutoCleanEnabled then return end
	
	lastCleanTime = tick()
	cleanedObjectsCount = 0
	
	print("[Auto Clean] Starting...")
	
	pcall(function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if cleanedObjectsCount >= 100 then break end
			
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") then
				if not obj.Enabled then
					obj:Destroy()
					cleanedObjectsCount = cleanedObjectsCount + 1
				end
			elseif obj:IsA("Sound") then
				if not obj.IsPlaying and not obj.Looped then
					obj:Destroy()
					cleanedObjectsCount = cleanedObjectsCount + 1
				end
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				if obj.Transparency >= 0.95 then
					obj:Destroy()
					cleanedObjectsCount = cleanedObjectsCount + 1
				end
			end
		end
		
		collectgarbage("collect")
	end)
	
	cacheStatus.Text = string.format("Last Clean: %d items removed", cleanedObjectsCount)
	print(string.format("[Auto Clean] Cleaned %d objects", cleanedObjectsCount))
	
	spawn(function()
		wait(1)
		countCacheObjects()
	end)
	
	StarterGui:SetCore("SendNotification", {
		Title = "Auto Clean";
		Text = string.format("Cleaned %d objects!", cleanedObjectsCount);
		Duration = 2;
	})
end

-- ==========================
-- FPS STABILIZER (REAL - REDUCES RENDERING LOAD)
-- ==========================
local originalLightingSettings = {}
local reducedParts = {}

local function enableFPSBoost()
	print("[FPS Boost] Enabling optimizations...")
	
	-- Save original Lighting settings
	pcall(function()
		originalLightingSettings = {
			GlobalShadows = Lighting.GlobalShadows,
			Brightness = Lighting.Brightness,
			EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
			EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
		}
		
		-- Optimize Lighting for FPS
		Lighting.GlobalShadows = false
		Lighting.EnvironmentDiffuseScale = 0.5
		Lighting.EnvironmentSpecularScale = 0.5
	end)
	
	-- Reduce quality of distant parts
	pcall(function()
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Parent ~= character then
				local distance = (obj.Position - character.HumanoidRootPart.Position).Magnitude
				if distance > 150 then
					if obj.Material ~= Enum.Material.SmoothPlastic then
						table.insert(reducedParts, {part = obj, originalMaterial = obj.Material})
						obj.Material = Enum.Material.SmoothPlastic
					end
					if obj.CastShadow then
						obj.CastShadow = false
					end
				end
			end
		end
	end)
	
	-- Disable some post effects
	pcall(function()
		for _, effect in pairs(Lighting:GetChildren()) do
			if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
				effect.Enabled = false
			end
		end
	end)
	
	fpsDesc.Text = "Active | Shadows OFF"
	print("[FPS Boost] Optimizations applied")
end

local function disableFPSBoost()
	print("[FPS Boost] Restoring settings...")
	
	-- Restore Lighting
	pcall(function()
		for key, value in pairs(originalLightingSettings) do
			Lighting[key] = value
		end
	end)
	
	-- Restore materials
	pcall(function()
		for _, data in pairs(reducedParts) do
			if data.part and data.part.Parent then
				data.part.Material = data.originalMaterial
				data.part.CastShadow = true
			end
		end
		reducedParts = {}
	end)
	
	-- Re-enable effects
	pcall(function()
		for _, effect in pairs(Lighting:GetChildren()) do
			if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
				effect.Enabled = true
			end
		end
	end)
	
	fpsDesc.Text = "Boost performa game"
	print("[FPS Boost] Settings restored")
end

-- ==========================
-- HEAVY STUFF REDUCER (REAL - REMOVES UNNECESSARY OBJECTS)
-- ==========================
local removedHeavyObjects = 0

local function enableHeavyReducer()
	print("[Heavy Reducer] Scanning for heavy objects...")
	removedHeavyObjects = 0
	
	pcall(function()
		-- Remove excessive particles
		for _, obj in pairs(Workspace:GetDescendants()) do
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
				if obj.Rate and obj.Rate > 50 then
					obj.Rate = 20 -- Reduce emission rate
					removedHeavyObjects = removedHeavyObjects + 1
				end
			end
			
			-- Remove far away decorative parts (Fish-It specific)
			if obj:IsA("MeshPart") or obj:IsA("Part") then
				if obj:FindFirstChild("Decoration") or obj.Name:match("Deco") or obj.Name:match("Detail") then
					local distance = character.HumanoidRootPart and (obj.Position - character.HumanoidRootPart.Position).Magnitude or 999
					if distance > 200 then
						obj:Destroy()
						removedHeavyObjects = removedHeavyObjects + 1
					end
				end
			end
			
			-- Limit to avoid freeze
			if removedHeavyObjects >= 50 then break end
		end
		
		-- Reduce terrain water quality (Fish-It specific)
		if Workspace.Terrain then
			sethiddenproperty(Workspace.Terrain, "Decoration", false)
		end
	end)
	
	heavyDesc.Text = string.format("Reduced %d objects", removedHeavyObjects)
	print(string.format("[Heavy Reducer] Reduced %d heavy objects", removedHeavyObjects))
	
	StarterGui:SetCore("SendNotification", {
		Title = "Heavy Reducer";
		Text = string.format("Reduced %d objects!", removedHeavyObjects);
		Duration = 2;
	})
end

local function disableHeavyReducer()
	heavyDesc.Text = "Reduce lag objects"
	print("[Heavy Reducer] Disabled")
end

-- ==========================
-- TOGGLE FUNCTIONS
-- ==========================
local function toggleMinimize()
	isMinimized = not isMinimized
	mainFrame.Visible = not isMinimized
	minimizedFrame.Visible = isMinimized
end

local function destroyMenu()
	for _, conn in pairs(connections) do
		conn:Disconnect()
	end
	
	if isFPSBoostEnabled then
		disableFPSBoost()
	end
	
	screenGui:Destroy()
	print("[Xcodelabs Tools] Destroyed")
	
	StarterGui:SetCore("SendNotification", {
		Title = "Xcodelabs Tools";
		Text = "Tools closed!";
		Duration = 2;
	})
end

local function toggleAntiAFK()
	isAntiAFKEnabled = not isAntiAFKEnabled
	
	if isAntiAFKEnabled then
		antiAFKToggle.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
		antiAFKToggle.Text = "ON"
		antiAFKToggle.TextColor3 = Color3.fromRGB(180, 255, 180)
		antiAFKDesc.Text = "Active | Actions: 0"
		afkActionCount = 0
	else
		antiAFKToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
		antiAFKToggle.Text = "OFF"
		antiAFKToggle.TextColor3 = Color3.fromRGB(255, 180, 180)
		antiAFKDesc.Text = "Mencegah kick AFK"
	end
end

local function toggleAutoClean()
	isAutoCleanEnabled = not isAutoCleanEnabled
	
	if isAutoCleanEnabled then
		cleanToggle.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
		cleanToggle.Text = "ON"
		cleanToggle.TextColor3 = Color3.fromRGB(180, 255, 180)
		spawn(function()
			wait(0.5)
			performCleanCache()
		end)
	else
		cleanToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
		cleanToggle.Text = "OFF"
		cleanToggle.TextColor3 = Color3.fromRGB(255, 180, 180)
		cleanDesc.Text = "Interval: 5 menit"
	end
end

local function toggleFPSBoost()
	isFPSBoostEnabled = not isFPSBoostEnabled
	
	if isFPSBoostEnabled then
		fpsToggle.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
		fpsToggle.Text = "ON"
		fpsToggle.TextColor3 = Color3.fromRGB(180, 255, 180)
		enableFPSBoost()
	else
		fpsToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
		fpsToggle.Text = "OFF"
		fpsToggle.TextColor3 = Color3.fromRGB(255, 180, 180)
		disableFPSBoost()
	end
end

local function toggleHeavyReducer()
	isHeavyReducerEnabled = not isHeavyReducerEnabled
	
	if isHeavyReducerEnabled then
		heavyToggle.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
		heavyToggle.Text = "ON"
		heavyToggle.TextColor3 = Color3.fromRGB(180, 255, 180)
		enableHeavyReducer()
	else
		heavyToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
		heavyToggle.Text = "OFF"
		heavyToggle.TextColor3 = Color3.fromRGB(255, 180, 180)
		disableHeavyReducer()
	end
end

-- ==========================
-- MAIN UPDATE LOOP
-- ==========================
local function mainUpdate()
	local currentTime = tick()
	
	-- Anti AFK
	performAntiAFK()
	
	-- Cache monitor (every 6 seconds)
	if currentTime - lastCacheUpdate >= 6 then
		countCacheObjects()
		lastCacheUpdate = currentTime
	end
	
	-- Auto clean (every 5 minutes)
	if isAutoCleanEnabled and currentTime - lastCleanTime >= 300 then
		performCleanCache()
	end
	
	-- Update countdown
	if isAutoCleanEnabled then
		local timeLeft = 300 - (currentTime - lastCleanTime)
		if timeLeft > 0 then
			local min = math.floor(timeLeft / 60)
			local sec = math.floor(timeLeft % 60)
			cleanDesc.Text = string.format("Next: %d:%02d", min, sec)
		end
	end
end

-- ==========================
-- CONNECTIONS
-- ==========================
table.insert(connections, minimizeButton.MouseButton1Click:Connect(toggleMinimize))
table.insert(connections, maximizeButton.MouseButton1Click:Connect(toggleMinimize))
table.insert(connections, closeButton.MouseButton1Click:Connect(destroyMenu))
table.insert(connections, antiAFKToggle.MouseButton1Click:Connect(toggleAntiAFK))
table.insert(connections, cleanToggle.MouseButton1Click:Connect(toggleAutoClean))
table.insert(connections, fpsToggle.MouseButton1Click:Connect(toggleFPSBoost))
table.insert(connections, heavyToggle.MouseButton1Click:Connect(toggleHeavyReducer))

table.insert(connections, player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = character:WaitForChild("Humanoid")
end))

table.insert(connections, RunService.Heartbeat:Connect(mainUpdate))

-- Initial scan
spawn(function()
	wait(2)
	countCacheObjects()
end)

-- Notifications
print("=================================")
print("Fish-It Optimizer v3.0 - Xcodelabs")
print("✓ Anti AFK: Ready")
print("✓ Auto Clean: Ready")
print("✓ FPS Stabilizer: Ready")
print("✓ Heavy Reducer: Ready")
print("=================================")

StarterGui:SetCore("SendNotification", {
	Title = "🎣 Fish-It Optimizer v3.0";
	Text = "All systems ready! by Xcodelabs";
	Duration = 4;
})
