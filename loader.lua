for i = 1, 50 do
    print("dxtware v.1 LOADED SUCCESS 100%")
    end

    local FillColor = Color3.fromRGB(255, 255, 255)
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = Color3.fromRGB(73, 7, 217)
local OutlineTransparency = 0

local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local lp = Players.LocalPlayer
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local function Highlight(plr)
    if plr == Players.LocalPlayer then
        return
    end

    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = FillColor
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Storage
    
    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    connections[plr] = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)
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
    
    -- Services
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    
    -- RGB color for text and circle
    local textColor = Color3.fromRGB(242, 73, 174)
    
    -- Function to create a TextLabel with outline
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
                    distanceLabel.Text = string.format("[%d]", distance)
                end
            end
        end
    
        -- Connect to Heartbeat to update the information every frame
        RunService.Heartbeat:Connect(updateInfo)
    
        return objectNameLabel, distanceLabel
    end
    
    -- Function to check for new HumanoidRootParts and add BillboardGui
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
    
    -- Periodic check for new HumanoidRootParts
    while true do
        checkForHumanoidRootParts()
        wait(1)
    end
