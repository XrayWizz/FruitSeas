-- Admin UI Teleport, Spectate, and Player Tools

local player = game.Players.LocalPlayer
local admins = {123456789, 8026829059} -- Add the UserIds of your admins here
local islandLocations = {
    ["Windmill Village"] = CFrame.new(100, 10, -200),
    ["Shell Town"] = CFrame.new(200, 10, -100),
    ["Orange Town"] = CFrame.new(300, 10, 0),
    ["Jungle"] = CFrame.new(400, 10, 100),
    ["Baratie"] = CFrame.new(500, 10, 200),
    ["Sandora"] = CFrame.new(600, 10, 300),
    ["Arlong Park"] = CFrame.new(700, 10, 400),
    ["Skypiea"] = CFrame.new(0, 600, 0),
    ["Cactus Peak"] = CFrame.new(800, 10, 500),
    ["Indomitable Fortress"] = CFrame.new(900, 10, 600),
    ["Colosseum"] = CFrame.new(1000, 10, 700),
    ["Abandoned Territory"] = CFrame.new(1100, 10, 800),
    ["Logue Town"] = CFrame.new(1200, 10, 900),
}

local npcLocations = {
    ["Windmill Village - Bandit Cave"] = CFrame.new(150, 15, -220),
    ["Shell Town - Marine Tower"] = CFrame.new(210, 50, -90),
    ["Orange Town - Town Center"] = CFrame.new(320, 12, 10),
    ["Jungle - Alphirex Cave"] = CFrame.new(420, 18, 120),
    ["Baratie - Second Floor"] = CFrame.new(530, 20, 210),
    ["Sandora - Upper Town"] = CFrame.new(610, 18, 320),
    ["Arlong Park - Rayleigh"] = CFrame.new(710, 14, 410),
    ["Skypiea - Enel Tree"] = CFrame.new(10, 610, 10),
    ["Cactus Peak - Center"] = CFrame.new(810, 12, 510),
    ["Indomitable Fortress - Tower Roof"] = CFrame.new(910, 60, 610),
    ["Colosseum - Back Area"] = CFrame.new(1010, 14, 710),
    ["Abandoned Territory - Factory Hill"] = CFrame.new(1110, 18, 810),
    ["Logue Town - Center Plaza"] = CFrame.new(1210, 16, 910),
}

-- UI Setup (Sleek Material You 3 Style)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminUI"
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(48, 48, 68)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local contentPanel = Instance.new("Frame")
contentPanel.Size = UDim2.new(1, -100, 1, 0)
contentPanel.Position = UDim2.new(0, 100, 0, 0)
contentPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
contentPanel.BorderSizePixel = 0
contentPanel.Parent = mainFrame

local function createButton(name, parent, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 40)
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.TextColor3 = Color3.fromRGB(230, 230, 240)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(callback)

    return button
end

local buttons = {"Teleport to Islands", "Teleport to NPCs", "Spectate Players", "Teleport to Player"}

local buttonOffset = 10
for _, btnName in ipairs(buttons) do
    createButton(btnName, sidebar, UDim2.new(0.1, 0, 0, buttonOffset), function()
        if not table.find(admins, player.UserId) then return end
        contentPanel:ClearAllChildren()

        if btnName == "Teleport to Islands" then
            local y = 10
            for island, cf in pairs(islandLocations) do
                createButton(island, contentPanel, UDim2.new(0.1, 0, 0, y), function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = cf + Vector3.new(0, 3, 0)
                end)
                y += 45
            end
        elseif btnName == "Teleport to NPCs" then
            local y = 10
            for npc, cf in pairs(npcLocations) do
                createButton(npc, contentPanel, UDim2.new(0.1, 0, 0, y), function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = cf + Vector3.new(0, 3, 0)
                end)
                y += 45
            end
        elseif btnName == "Spectate Players" then
            local y = 10
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player then
                    createButton("Spectate " .. otherPlayer.Name, contentPanel, UDim2.new(0.1, 0, 0, y), function()
                        -- Spectate logic here (camera follow, etc.)
                        local camera = game.Workspace.CurrentCamera
                        camera.CameraSubject = otherPlayer.Character.Humanoid
                        camera.CameraType = Enum.CameraType.Custom
                    end)
                    y += 45
                end
            end
        elseif btnName == "Teleport to Player" then
            local y = 10
            for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
                if otherPlayer ~= player then
                    createButton("Teleport to " .. otherPlayer.Name, contentPanel, UDim2.new(0.1, 0, 0, y), function()
                        local char = player.Character or player.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart")
                        hrp.CFrame = otherPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end)
                    y += 45
                end
            end
        end
    end)
    buttonOffset += 50
end
