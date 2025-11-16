-- ULTIMATE SERVER LAG (Simple Working Version)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LagEnabled = false
local lagIntensity = 1

-- GUI (простой рабочий вариант)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MaxLagGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, 320, 0, 200)
mainContainer.Position = UDim2.new(0, 400, 0, 20)
mainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainContainer.BackgroundTransparency = 0.1
mainContainer.BorderSizePixel = 0
mainContainer.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainContainer

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.BorderSizePixel = 0
header.Parent = mainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "ULTIMATE LAG MODE"
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
content.Parent = mainContainer

local lagSection = Instance.new("Frame")
lagSection.Size = UDim2.new(1, 0, 0, 120)
lagSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
lagSection.BorderSizePixel = 0
lagSection.Parent = content

local sectionCorner = Instance.new("UICorner")
sectionCorner.CornerRadius = UDim.new(0, 8)
sectionCorner.Parent = lagSection

local lagTitle = Instance.new("TextLabel")
lagTitle.Size = UDim2.new(1, -10, 0, 25)
lagTitle.Position = UDim2.new(0, 10, 0, 5)
lagTitle.Text = "All Methods Combined"
lagTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
lagTitle.BackgroundTransparency = 1
lagTitle.TextSize = 12
lagTitle.Font = Enum.Font.Gotham
lagTitle.TextXAlignment = Enum.TextXAlignment.Left
lagTitle.Parent = lagSection

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 60)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Status: DISABLED\nIntensity: LOW\nFPS: --"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextWrapped = true
statusLabel.Parent = lagSection

local actionsFrame = Instance.new("Frame")
actionsFrame.Size = UDim2.new(1, 0, 0, 40)
actionsFrame.Position = UDim2.new(0, 0, 0, 130)
actionsFrame.BackgroundTransparency = 1
actionsFrame.Parent = content

local function createActionButton(xPosition, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, 0, 0, 35)
    btn.Position = UDim2.new(xPosition, 0, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = actionsFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

local toggleBtn = createActionButton(0, "ULTIMATE LAG ON", Color3.fromRGB(200, 60, 60))
local intensityBtn = createActionButton(0.52, "INTENSITY: LOW", Color3.fromRGB(80, 120, 200))

-- Функции для кнопок
local function setupButtonHover(button)
    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor * 1.2}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor}):Play()
    end)
end

setupButtonHover(closeBtn)
setupButtonHover(toggleBtn)
setupButtonHover(intensityBtn)

local scriptRunning = true
local lagConnection = nil

local function closeGUI()
    scriptRunning = false
    if lagConnection then
        lagConnection:Disconnect()
    end
    screenGui:Destroy()
end

closeBtn.MouseButton1Click:Connect(closeGUI)

-- Перетаскивание окна
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
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
        mainContainer.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- УЛЬТИМАТИВНЫЙ МЕТОД ЛАГОВ
local function startUltimateLag()
    if lagConnection then
        lagConnection:Disconnect()
    end
    
    lagConnection = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- Интенсивные вычисления
        local heavyCalc = 0
        for i = 1, lagIntensity * 1000 do
            heavyCalc = heavyCalc + math.sin(i) * math.cos(i) * math.tan(i * 0.1)
        end
        
        -- Быстрое изменение освещения
        Lighting.Brightness = math.random(1, 8)
        Lighting.ClockTime = math.random(0, 24)
        Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
        
        -- Создание временных объектов
        for i = 1, lagIntensity * 3 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = Vector3.new(
                math.random(-20, 20),
                math.random(5, 15),
                math.random(-20, 20)
            )
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.random()
            part.Parent = workspace
            game:GetService("Debris"):AddItem(part, 0.2)
        end
    end)
end

-- Переключение интенсивности
intensityBtn.MouseButton1Click:Connect(function()
    if lagIntensity == 1 then
        lagIntensity = 3
        intensityBtn.Text = "INTENSITY: MEDIUM"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 60)
    elseif lagIntensity == 3 then
        lagIntensity = 6
        intensityBtn.Text = "INTENSITY: HIGH"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
    else
        lagIntensity = 1
        intensityBtn.Text = "INTENSITY: LOW"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    end
    statusLabel.Text = string.format("Status: %s\nIntensity: %s\nFPS: --", 
        LagEnabled and "ENABLED" or "DISABLED", 
        lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
end)

-- Включение/выключение лагов
toggleBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = string.format("Status: ENABLED\nIntensity: %s\nFPS: DROPPING", 
            lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleBtn.Text = "ULTIMATE LAG OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        startUltimateLag()
        print("💥 ULTIMATE LAG ACTIVATED! Intensity: " .. lagIntensity)
    else
        statusLabel.Text = string.format("Status: DISABLED\nIntensity: %s\nFPS: NORMAL", 
            lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "ULTIMATE LAG ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        if lagConnection then
            lagConnection:Disconnect()
        end
        print("🛑 Ultimate lag stopped")
    end
end)

-- Клавиша L для переключения
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        
        if LagEnabled then
            statusLabel.Text = string.format("Status: ENABLED\nIntensity: %s\nFPS: DROPPING", 
                lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.Text = "ULTIMATE LAG OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
            startUltimateLag()
        else
            statusLabel.Text = string.format("Status: DISABLED\nIntensity: %s\nFPS: NORMAL", 
                lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.Text = "ULTIMATE LAG ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            if lagConnection then
                lagConnection:Disconnect()
            end
        end
    end
end)

-- Мониторинг FPS
spawn(function()
    local lastTick = tick()
    local frameCount = 0
    
    while scriptRunning do
        frameCount = frameCount + 1
        if tick() - lastTick >= 1 then
            local fps = frameCount
            frameCount = 0
            lastTick = tick()
            
            if LagEnabled then
                statusLabel.Text = string.format("Status: ENABLED\nIntensity: %s\nFPS: %d", 
                    lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH",
                    fps)
            end
        end
        wait(0.1)
    end
end)

player.CharacterRemoving:Connect(function()
    if scriptRunning then closeGUI() end
end)

print("💥 ULTIMATE LAG LOADED!")
print("🎮 GUI should be visible!")
print("🎮 Click ULTIMATE LAG ON or press L to start")
print("⚡ All methods combined for maximum lag!")
