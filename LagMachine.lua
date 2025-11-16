
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LagEnabled = false
local LagIntensity = 500

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExtremeLagGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0, 400, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "EXTREME LAG 2000"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.BackgroundTransparency = 1
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
closeBtn.BorderSizePixel = 0
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local intensitySection = Instance.new("Frame")
intensitySection.Size = UDim2.new(1, 0, 0, 80)
intensitySection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
intensitySection.BorderSizePixel = 0
intensitySection.Parent = content

local intensityCorner = Instance.new("UICorner")
intensityCorner.CornerRadius = UDim.new(0, 8)
intensityCorner.Parent = intensitySection

local intensityTitle = Instance.new("TextLabel")
intensityTitle.Size = UDim2.new(1, -10, 0, 25)
intensityTitle.Position = UDim2.new(0, 10, 0, 5)
intensityTitle.Text = "Lag Intensity (1-2000)"
intensityTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
intensityTitle.BackgroundTransparency = 1
intensityTitle.TextSize = 12
intensityTitle.Font = Enum.Font.Gotham
intensityTitle.TextXAlignment = Enum.TextXAlignment.Left
intensityTitle.Parent = intensitySection

local intensityInputContainer = Instance.new("Frame")
intensityInputContainer.Size = UDim2.new(1, -20, 0, 30)
intensityInputContainer.Position = UDim2.new(0, 10, 0, 30)
intensityInputContainer.BackgroundTransparency = 1
intensityInputContainer.Parent = intensitySection

local intensityLabel = Instance.new("TextLabel")
intensityLabel.Size = UDim2.new(0, 80, 1, 0)
intensityLabel.Text = "Intensity:"
intensityLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
intensityLabel.BackgroundTransparency = 1
intensityLabel.TextSize = 12
intensityLabel.Font = Enum.Font.Gotham
intensityLabel.TextXAlignment = Enum.TextXAlignment.Left
intensityLabel.Parent = intensityInputContainer

local intensityInput = Instance.new("TextBox")
intensityInput.Size = UDim2.new(1, -85, 1, 0)
intensityInput.Position = UDim2.new(0, 85, 0, 0)
intensityInput.Text = tostring(LagIntensity)
intensityInput.TextColor3 = Color3.fromRGB(255, 255, 255)
intensityInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
intensityInput.BorderSizePixel = 0
intensityInput.TextSize = 12
intensityInput.Font = Enum.Font.Gotham
intensityInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
intensityInput.Parent = intensityInputContainer

local intensityInputCorner = Instance.new("UICorner")
intensityInputCorner.CornerRadius = UDim.new(0, 6)
intensityInputCorner.Parent = intensityInput

local intensityInputPadding = Instance.new("UIPadding")
intensityInputPadding.PaddingLeft = UDim.new(0, 8)
intensityInputPadding.Parent = intensityInput

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 70)
statusLabel.Text = "Status: DISABLED (Press L)"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = intensitySection

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 0, 80)
buttonsFrame.Position = UDim2.new(0, 0, 0, 90)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = content

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 1, 0)
infoLabel.Text = "Press L to toggle extreme lag\n100-500 = Heavy lag\n500-1000 = Extreme lag\n1000-2000 = CRASH level"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.BackgroundTransparency = 1
infoLabel.TextSize = 10
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextWrapped = true
infoLabel.Parent = buttonsFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

intensityInput.FocusLost:Connect(function()
    local newIntensity = tonumber(intensityInput.Text)
    if newIntensity and newIntensity > 0 then
        LagIntensity = math.min(newIntensity, 2000)
        intensityInput.Text = tostring(LagIntensity)
        print("📊 Lag intensity updated: " .. LagIntensity)
    end
end)

local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

local function toggleLag()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = "Status: EXTREME LAG! (" .. LagIntensity .. ")"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        print("EXTREME LAG ACTIVATED! Intensity: " .. LagIntensity)
    else
        statusLabel.Text = "Status: DISABLED (Press L)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("Extreme lag deactivated")
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        toggleLag()
    end
end)

local extremeObjects = {}
local memoryHogs = {}
local cpuTasks = {}

local function createMemoryApocalypse()
    if not LagEnabled then return end
    for i = 1, math.floor(LagIntensity / 5) do
        memoryHogs[i] = {
            data = string.rep("EXTREME_LAG_" .. i, 10000),
            nested = {},
            megaNested = {}
        }
        for j = 1, 1000 do
            memoryHogs[i].nested[j] = {
                moreData = string.rep("NESTED_LAG", 1000),
                numbers = {},
                strings = {}
            }
            for k = 1, 100 do
                memoryHogs[i].nested[j].numbers[k] = math.random(1, 1000000)
                memoryHogs[i].nested[j].strings[k] = string.rep("LAG", 100)
            end
        end
        for j = 1, 100 do
            memoryHogs[i].megaNested[j] = {
                extremeData = string.rep("MEGA_LAG", 5000),
                arrays = {}
            }
            for k = 1, 50 do
                memoryHogs[i].megaNested[j].arrays[k] = {}
                for l = 1, 20 do
                    memoryHogs[i].megaNested[j].arrays[k][l] = math.random(1, 1000000)
                end
            end
        end
    end
end

local function createCPUArmageddon()
    if not LagEnabled then return end
    local computations = 0
    local startTime = tick()
    
    while tick() - startTime < (LagIntensity / 200) and LagEnabled do
        for i = 1, LagIntensity * 200 do
            local x = math.sin(tick() * 10 + i) * math.cos(tick() * 8 - i)
            local y = math.tan(x * 2) * math.atan(x * 3)
            local z = math.log(math.abs(y) + 1) * math.exp(math.abs(x))
            computations = computations + z * math.random(1, 100)
        end
        
        for i = 1, math.floor(LagIntensity / 10) do
            table.sort(memoryHogs, function(a, b)
                return #a.data > #b.data
            end)
        end
    end
end

local function createRenderCataclysm()
    if not LagEnabled then return end

    for i = 1, math.floor(LagIntensity / 2) do
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.2, 0.2, 0.2)
        part.Position = Vector3.new(
            math.random(-100, 100),
            math.random(5, 50), 
            math.random(-100, 100)
        )
        part.Anchored = false
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.random()
        part.CanCollide = false
        part.Parent = workspace
        
        local fire = Instance.new("Fire")
        fire.Size = math.random(5, 15)
        fire.Heat = math.random(5, 15)
        fire.Color = Color3.new(math.random(), math.random(), math.random())
        fire.SecondaryColor = Color3.new(math.random(), math.random(), math.random())
        fire.Parent = part
        
        local smoke = Instance.new("Smoke")
        smoke.Size = math.random(5, 15)
        smoke.Opacity = 0.8
        smoke.Color = Color3.new(math.random(), math.random(), math.random())
        smoke.Parent = part
        
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = Color3.new(math.random(), math.random(), math.random())
        sparkles.Parent = part
        
        table.insert(extremeObjects, part)

        spawn(function()
            while part and part.Parent and LagEnabled do
                part.RotVelocity = Vector3.new(
                    math.random(-100, 100),
                    math.random(-100, 100),
                    math.random(-100, 100)
                )
                part.Velocity = Vector3.new(
                    math.sin(tick() * 20) * 20,
                    math.cos(tick() * 15) * 10,
                    math.cos(tick() * 25) * 20
                )
                part.BrickColor = BrickColor.random()
                wait(0.005)
            end
        end)
    end
end

local function createNetworkDoom()
    if not LagEnabled then return end

    for i = 1, math.floor(LagIntensity / 5) do
        spawn(function()
            local requestCount = 0
            while LagEnabled do
                for j = 1, 20 do
                    spawn(function()
                        local start = tick()
                        while tick() - start < 0.1 and LagEnabled do
                            local data = {}
                            for k = 1, 200 do
                                data[k] = {
                                    number = math.random(1, 1000000),
                                    string = string.rep("NETWORK_LAG", 10),
                                    table = {math.random(1, 100), math.random(1, 100)}
                                }
                            end
                        end
                    end)
                end
                requestCount = requestCount + 1
                wait(0.005)
            end
        end)
    end
end

local function createInfiniteLoopHell()
    if not LagEnabled then return end

    for i = 1, math.floor(LagIntensity / 10) do
        spawn(function()
            local counter = 0
            while LagEnabled do
                counter = counter + 1

                for j = 1, 1000 do
                    local x = math.random(1, 1000000)
                    local y = math.random(1, 1000000)
                    local _ = x * y / (x + y + 1)
                end
            end
        end)
    end
end


spawn(function()
    while true do
        if LagEnabled then

            createMemoryApocalypse()
            createCPUArmageddon() 
            createRenderCataclysm()
            createNetworkDoom()
            createInfiniteLoopHell()
            
            wait(0.01) 
        else

            for _, obj in pairs(extremeObjects) do
                if obj and obj.Parent then
                    obj:Destroy()
                end
            end
            extremeObjects = {}
            memoryHogs = {}
            cpuTasks = {}
            wait(0.5)
        end
    end
end)

print("EXTREME LAG MACHINE 2000 LOADED!")
print("Press L to toggle extreme lag")
print("Intensity levels:")
print("100-500 = Heavy lag")
print("500-1000 = Extreme lag") 
print("1000-2000 = INSTANT CRASH level")
print("WARNING: 1500+ may crash Roblox!")

