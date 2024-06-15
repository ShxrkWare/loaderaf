local HWID = game:GetService("RbxAnalyticsService"):GetClientId();
local WhitelistedHWIDs = {"51C18368-3003-4A49-9840-4F1B6508C19C","",""}
local qNVAKkuwxNpqruLjSRHg = false

function CheckHWID(hwidval)
for _,whitelisted in pairs(WhitelistedHWIDs) do
 if hwidval == whitelisted then
     return true
 elseif hwidval ~= whitelisted then
     return false
       end
    end
end

qNVAKkuwxNpqruLjSRHg = CheckHWID(HWID)

if qNVAKkuwxNpqruLjSRHg == true then
--////////////////////// [MAIN SCRIPT] /////////////////////////////////
for i = 1, 50 do
    print("dxtware v.1 LOADED SUCCESS 100%")
end

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'dxtware v.1 | Aftermath',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    AimbotTab = Window:AddTab('Aimbot'),
    VisualsTab = Window:AddTab('Visuals'),
    MiscTab = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings'),
}

--// Services
local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

--// Features \\--

local FillColor = Color3.fromRGB(255, 84, 158)
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = Color3.fromRGB(255,255,255)
local textColor = Color3.fromRGB(242, 73, 174)
local NameColor = Color3.fromRGB(255, 255, 255)
local DistanceColor = Color3.fromRGB(255, 255, 255)

local OutlineTransparency = 0
local lp = Players.LocalPlayer
local connections = {}
local HighlightEnabled = false
local NameEnabled = false
local DistanceEnabled = false

--// HighLight \\--
local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local function Highlight(plr)
    if plr == Players.LocalPlayer then
        return
    end

    local plrchar = plr.Character
    if plrchar then
        local highlight = Storage:FindFirstChild(plr.Name)
        if HighlightEnabled then
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = plr.Name
                highlight.FillColor = FillColor
                highlight.DepthMode = DepthMode
                highlight.FillTransparency = FillTransparency
                highlight.OutlineColor = OutlineColor
                highlight.OutlineTransparency = 0
                highlight.Adornee = plrchar
                highlight.Parent = Storage
            end
        elseif highlight then
            highlight:Destroy()
        end
    end
end

Players.PlayerAdded:Connect(Highlight)
for i,v in next, Players:GetPlayers() do
    Highlight(v)
end

Players.PlayerRemoving:Connect(function(plr)
    local plrname = plr.Name
    if Storage[plrname] then
        Storage[plrname]:Destroy()
    end
    if connections[plr] then
        connections[plr]:Disconnect()
    end
end)

--// Name / Distance \\--

local function createTextLabelWithEffects(parent, size, position, text, textColor, textSize, transparency)
	local mainLabel = Instance.new("TextLabel")
	mainLabel.Size = size
	mainLabel.Position = position
	mainLabel.BackgroundTransparency = 1
	mainLabel.Text = text
	mainLabel.TextColor3 = textColor
	mainLabel.TextSize = textSize
	mainLabel.TextTransparency = transparency
	mainLabel.Font = Enum.Font.SourceSans
	mainLabel.TextStrokeTransparency = transparency
	mainLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- Black outline
	mainLabel.Parent = parent

	return mainLabel
end

-- Function to create a BillboardGui for a HumanoidRootPart
local function createBillboardGui(humanoidRootPart, objectName)
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Adornee = humanoidRootPart
	billboardGui.Size = UDim2.new(0, 200, 0, 100)
	billboardGui.StudsOffset = Vector3.new(0, 2, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Name = "HumanoidBillboard"

	local objectNameLabel, distanceLabel

	-- Create the main TextLabel for the object name
	objectNameLabel = createTextLabelWithEffects(billboardGui, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0, 0), objectName, textColor, 25, 0.3)

	-- Create the distance TextLabel
	distanceLabel = createTextLabelWithEffects(billboardGui, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0.5, 0), "", textColor, 25, 0.3)

	-- Parent the BillboardGui to the HumanoidRootPart
	billboardGui.Parent = humanoidRootPart

	-- Function to update the information
    local function updateInfo()
        local player = Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPosition = player.Character.HumanoidRootPart.Position
            local objectPosition = humanoidRootPart.Position
            local distance = math.floor((playerPosition - objectPosition).Magnitude)
            if distanceLabel then
                distanceLabel.Text = DistanceEnabled and string.format("[%d]", distance) or ""
                distanceLabel.TextColor3 = DistanceColor
            end
            if objectNameLabel then
                objectNameLabel.Text = NameEnabled and objectName or ""
                objectNameLabel.TextColor3 = NameColor
            end
        end
    end

	-- Connect to Heartbeat to update the information every frame
	RunService.Heartbeat:Connect(updateInfo)

	return objectNameLabel, distanceLabel
end

local function checkForHumanoidRootParts()
	local localPlayer = Players.LocalPlayer

	for _, object in ipairs(Workspace:GetChildren()) do
		local humanoidRootPart = object:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart and not humanoidRootPart:FindFirstChild("HumanoidBillboard") then
			if object ~= localPlayer.Character then
				createBillboardGui(humanoidRootPart, object.Name)
			end
		end
	end
end

local Sections = {

    --// Aimbot Tab

    Aimbot = Tabs.AimbotTab:AddLeftGroupbox('Aimbot'),
    
    --// Visuals Tab

    Visuals = Tabs.VisualsTab:AddLeftGroupbox('Visuals'),
}

Sections.Visuals:AddToggle('PlayerChams', {
    Text = 'Charm Plr',
    Default = false,
    Tooltip = nil,

    Callback = function(v)
        HighlightEnabled = v
        for i, v in next, Players:GetPlayers() do
            Highlight(v)
        end
    end
}):AddColorPicker('PlrChamsColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Plr Chams Fill Color',
    Transparency = 0,

    Callback = function(Value)
        FillColor = Value
        for i, v in pairs(Storage:GetChildren()) do
            v.FillColor = FillColor
        end
    end
}):AddColorPicker('PlrChamsOutlineColor', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Plr Chams Outline Color',
    Transparency = 0,

    Callback = function(Value)
        OutlineColor = Value
        for i, v in pairs(Storage:GetChildren()) do
            v.OutlineColor = OutlineColor
        end
    end
})

Sections.Visuals:AddToggle('ShowName', {
    Text = 'Show Name',
    Default = false,
    Tooltip = nil,

    Callback = function(v)
        NameEnabled = v
    end
}):AddColorPicker('Name Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Name Color',
    Transparency = 0,

    Callback = function(Value)
        NameColor = Value
    end
})

local gravityChanged = false

Sections.Visuals:AddLabel('Keybind'):AddKeyPicker('GravityKeyBind', {
    Default = 'V',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Change Gravity',
    NoUI = false,

    Callback = function(Value)
        if not gravityChanged then
            Workspace.Gravity = 1
            gravityChanged = true
        else
            Workspace.Gravity = 70
            gravityChanged = false
        end
    end,
})

Sections.Visuals:AddToggle('ShowDistance', {
    Text = 'Show Distance',
    Default = false,
    Tooltip = nil,

    Callback = function(v)
        DistanceEnabled = v
    end
}):AddColorPicker('Distance Color', {
    Default = Color3.fromRGB(255, 255, 255),
    Title = 'Distance Color',
    Transparency = 0,

    Callback = function(Value)
        DistanceColor = Value
    end
})

Library:OnUnload(function()
    Library.Unloaded = true
end)

local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('dxtware')
SaveManager:SetFolder('dxtware/Aftermath')

SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
SaveManager:LoadAutoloadConfig()

while true do
	checkForHumanoidRootParts()
	wait(1)
end





--Full Bright
game.Lighting.Atmosphere:Destroy()
game.Lighting.Sky:Destroy()
game.Lighting.Bloom:Destroy()
game.Lighting.BrightnessContrast:Destroy()
game.Lighting.ColorCorrection:Destroy()
game.Lighting.SunRays:Destroy()
game.Lighting.IsNight:Destroy()

end

