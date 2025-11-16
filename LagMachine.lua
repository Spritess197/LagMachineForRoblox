-- MAXIMUM SERVER LAG (Client-Side Methods)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LagEnabled = false
local lagIntensity = 1

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MaxLagGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, 350, 0, 250)
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
title.Text = "EXTREME LAG MODE"
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
lagSection.Size = UDim2.new(1, 0, 0, 150)
lagSection.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
lagSection.BorderSizePixel = 0
lagSection.Parent = content

local sectionCorner = Instance.new("UICorner")
sectionCorner.CornerRadius = UDim.new(0, 8)
sectionCorner.Parent = lagSection

local lagTitle = Instance.new("TextLabel")
lagTitle.Size = UDim2.new(1, -10, 0, 25)
lagTitle.Position = UDim2.new(0, 10, 0, 5)
lagTitle.Text = "Client-Side Extreme Lag"
lagTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
lagTitle.BackgroundTransparency = 1
lagTitle.TextSize = 12
lagTitle.Font = Enum.Font.Gotham
lagTitle.TextXAlignment = Enum.TextXAlignment.Left
lagTitle.Parent = lagSection

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 80)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Status: DISABLED\nMethod: RenderStepper\nIntensity: LOW\nFPS: --"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextWrapped = true
statusLabel.Parent = lagSection

local actionsFrame = Instance.new("Frame")
actionsFrame.Size = UDim2.new(1, 0, 0, 50)
actionsFrame.Position = UDim2.new(0, 0, 0, 160)
actionsFrame.BackgroundTransparency = 1
actionsFrame.Parent = content

local function createActionButton(xPosition, text, color, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(sizeX or 0.48, 0, 0, 35)
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

local toggleBtn = createActionButton(0, "EXTREME LAG ON", Color3.fromRGB(200, 60, 60))
local intensityBtn = createActionButton(0.52, "INTENSITY: LOW", Color3.fromRGB(80, 120, 200))
local methodBtn = createActionButton(0, "RENDER", Color3.fromRGB(120, 80, 200), 1)

methodBtn.Position = UDim2.new(0, 0, 0, 40)

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
setupButtonHover(methodBtn)

local scriptRunning = true
local currentMethod = "render"
local connections = {}

local function closeGUI()
    scriptRunning = false
    -- Отключаем все соединения
    for _, conn in pairs(connections) do
        conn:Disconnect()
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

-- МЕТОД 1: РЕНДЕРИНГ ЛАГ
local function startRenderLag()
    local partCount = lagIntensity * 50
    
    connections.render = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- Интенсивные математические вычисления
        local calculations = 0
        for i = 1, partCount * 10 do
            calculations = calculations + math.sin(i * 0.1) * math.cos(i * 0.1) * math.tan(i * 0.01)
        end
        
        -- Создание и удаление объектов в реальном времени
        for i = 1, math.min(5, partCount) do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 1, 1)
            part.Position = Vector3.new(
                math.random(-100, 100),
                math.random(10, 50),
                math.random(-100, 100)
            )
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.random()
            part.Parent = workspace
            game:GetService("Debris"):AddItem(part, 0.1)
        end
    end)
end

-- МЕТОД 2: ФИЗИКА ЛАГ
local function startPhysicsLag()
    local parts = {}
    
    -- Создаем много физических частей
    for i = 1, lagIntensity * 30 do
        local part = Instance.new("Part")
        part.Name = "PhysicsLag_" .. i
        part.Size = Vector3.new(2, 2, 2)
        part.Position = Vector3.new(
            math.random(-50, 50),
            math.random(20, 40),
            math.random(-50, 50)
        )
        part.Anchored = false
        part.CanCollide = true
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.random()
        part.Parent = workspace
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-20, 20),
            math.random(5, 15),
            math.random(-20, 20)
        )
        bodyVelocity.Parent = part
        
        table.insert(parts, part)
    end
    
    connections.physics = RunService.Heartbeat:Connect(function()
        if not LagEnabled then return end
        
        -- Постоянно обновляем физику
        for _, part in pairs(parts) do
            if part and part.Parent then
                local bodyVelocity = part:FindFirstChildOfClass("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity.Velocity = Vector3.new(
                        math.random(-30, 30),
                        math.random(5, 25),
                        math.random(-30, 30)
                    )
                end
            end
        end
    end)
    
    -- Очистка через 10 секунд
    delay(10, function()
        for _, part in pairs(parts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
    end)
end

-- МЕТОД 3: СВЕТ И ЭФФЕКТЫ ЛАГ
local function startLightingLag()
    connections.lighting = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- Быстро меняем свойства освещения
        Lighting.Brightness = math.random(1, 5)
        Lighting.ClockTime = math.random(0, 24)
        Lighting.ColorShift_Bottom = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Top = Color3.new(math.random(), math.random(), math.random())
        
        -- Создаем временные источники света
        for i = 1, lagIntensity do
            local light = Instance.new("PointLight")
            light.Brightness = math.random(5, 10)
            light.Range = math.random(10, 20)
            light.Color = Color3.new(math.random(), math.random(), math.random())
            light.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(light, 0.2)
        end
    end)
end

-- МЕТОД 4: ИНТЕНСИВНЫЕ ВЫЧИСЛЕНИЯ
local function startCalculationLag()
    connections.calculation = RunService.Heartbeat:Connect(function()
        if not LagEnabled then return end
        
        -- Очень интенсивные вычисления
        local heavyCalc = 0
        for x = 1, lagIntensity * 1000 do
            for y = 1, 10 do
                heavyCalc = heavyCalc + math.sqrt(x * y) * math.log(x + y)
            end
        end
        
        -- Дополнительные операции с таблицами
        local largeTable = {}
        for i = 1, lagIntensity * 500 do
            largeTable[i] = {
                x = math.random(1, 1000),
                y = math.random(1, 1000),
                z = math.random(1, 1000),
                value = math.sin(i) * math.cos(i)
            }
        end
    end)
end

-- Очистка всех методов
local function cleanupAll()
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    connections = {}
    
    -- Удаляем все созданные части
    for _, obj in pairs(workspace:GetChildren()) do
        if string.find(obj.Name, "PhysicsLag_") or string.find(obj.Name, "RenderLag_") then
            obj:Destroy()
        end
    end
end

-- Переключение интенсивности
intensityBtn.MouseButton1Click:Connect(function()
    if lagIntensity == 1 then
        lagIntensity = 3
        intensityBtn.Text = "INTENSITY: MEDIUM"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 60)
    elseif lagIntensity == 3 then
        lagIntensity = 5
        intensityBtn.Text = "INTENSITY: HIGH"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
    else
        lagIntensity = 1
        intensityBtn.Text = "INTENSITY: LOW"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    end
    statusLabel.Text = string.format("Status: %s\nMethod: %s\nIntensity: %s\nFPS: --", 
        LagEnabled and "ENABLED" or "DISABLED", 
        currentMethod:upper(),
        lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
end)

-- Переключение методов
methodBtn.MouseButton1Click:Connect(function()
    cleanupAll()
    
    if currentMethod == "render" then
        currentMethod = "physics"
        methodBtn.Text = "PHYSICS"
        methodBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
    elseif currentMethod == "physics" then
        currentMethod = "lighting"
        methodBtn.Text = "LIGHTING"
        methodBtn.BackgroundColor3 = Color3.fromRGB(180, 80, 200)
    elseif currentMethod == "lighting" then
        currentMethod = "calculation"
        methodBtn.Text = "CALCULATION"
        methodBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
    else
        currentMethod = "render"
        methodBtn.Text = "RENDER"
        methodBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
    end
    
    statusLabel.Text = string.format("Status: %s\nMethod: %s\nIntensity: %s\nFPS: --", 
        LagEnabled and "ENABLED" or "DISABLED", 
        currentMethod:upper(),
        lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
    
    if LagEnabled then
        startCurrentMethod()
    end
end)

-- Запуск текущего метода
local function startCurrentMethod()
    cleanupAll()
    
    if currentMethod == "render" then
        startRenderLag()
    elseif currentMethod == "physics" then
        startPhysicsLag()
    elseif currentMethod == "lighting" then
        startLightingLag()
    elseif currentMethod == "calculation" then
        startCalculationLag()
    end
end

-- Включение/выключение лагов
toggleBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = string.format("Status: ENABLED\nMethod: %s\nIntensity: %s\nFPS: DROPPING", 
            currentMethod:upper(),
            lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleBtn.Text = "EXTREME LAG OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        startCurrentMethod()
        print("💥 EXTREME LAG ACTIVATED! Method: " .. currentMethod .. " Intensity: " .. lagIntensity)
    else
        statusLabel.Text = string.format("Status: DISABLED\nMethod: %s\nIntensity: %s\nFPS: NORMAL", 
            currentMethod:upper(),
            lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "EXTREME LAG ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        cleanupAll()
        print("🛑 Extreme lag stopped")
    end
end)

-- Клавиша L для переключения
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        
        if LagEnabled then
            statusLabel.Text = string.format("Status: ENABLED\nMethod: %s\nIntensity: %s\nFPS: DROPPING", 
                currentMethod:upper(),
                lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.Text = "EXTREME LAG OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
            startCurrentMethod()
        else
            statusLabel.Text = string.format("Status: DISABLED\nMethod: %s\nIntensity: %s\nFPS: NORMAL", 
                currentMethod:upper(),
                lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH")
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.Text = "EXTREME LAG ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            cleanupAll()
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
                statusLabel.Text = string.format("Status: ENABLED\nMethod: %s\nIntensity: %s\nFPS: %d", 
                    currentMethod:upper(),
                    lagIntensity == 1 and "LOW" or lagIntensity == 3 and "MEDIUM" or "HIGH",
                    fps)
            end
        end
        wait(0.1)
    end
end)

print("💥💥💥 EXTREME CLIENT-SIDE LAG LOADED!")
print("🎮 Click EXTREME LAG ON or press L to start")
print("⚡ Render - Intensive rendering calculations")
print("🔷 Physics - Physics objects with BodyVelocity") 
print("💡 Lighting - Rapid lighting changes")
print("🧮 Calculation - Heavy mathematical computations")
print("🎚️ Adjust intensity for more/less lag")
