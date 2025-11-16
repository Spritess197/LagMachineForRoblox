-- MAXIMUM SERVER LAG (Combined Methods)
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
lagTitle.Text = "Combined Extreme Lag Methods"
lagTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
lagTitle.BackgroundTransparency = 1
lagTitle.TextSize = 12
lagTitle.Font = Enum.Font.Gotham
lagTitle.TextXAlignment = Enum.TextXAlignment.Left
lagTitle.Parent = lagSection

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 80)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Status: DISABLED\nMethod: LIGHT+CALC\nIntensity: LOW\nFPS: --"
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
local methodBtn = createActionButton(0, "LIGHT+CALC", Color3.fromRGB(120, 80, 200), 1)

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
local currentMethod = "light_calc"
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

-- КОМБИНИРОВАННЫЙ МЕТОД: LIGHTING + CALCULATION
local function startCombinedLightCalc()
    connections.combined = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- === ЧАСТЬ 1: ИНТЕНСИВНЫЕ ВЫЧИСЛЕНИЯ ===
        local heavyCalc = 0
        local calcMultiplier = lagIntensity * 500
        
        -- Очень тяжелые математические операции
        for x = 1, calcMultiplier do
            for y = 1, 20 do
                heavyCalc = heavyCalc + 
                    math.sin(x * y) * math.cos(x / y) * 
                    math.tan(x + y) * math.log(math.abs(x - y) + 1)
            end
        end
        
        -- Дополнительные вычисления с матрицами
        local matrixCalc = 0
        for i = 1, calcMultiplier * 2 do
            matrixCalc = matrixCalc + 
                math.sqrt(i) * math.exp(i * 0.001) * 
                math.atan(i) * math.asin(math.random())
        end
        
        -- Создание больших таблиц и операции с ними
        local largeTable = {}
        for i = 1, calcMultiplier do
            largeTable[i] = {
                x = math.random(1, 1000),
                y = math.random(1, 1000), 
                z = math.random(1, 1000),
                value = math.sin(i) * math.cos(i) * math.tan(i * 0.1),
                nested = {
                    a = math.random(1, 100),
                    b = math.random(1, 100),
                    c = math.random(1, 100)
                }
            }
        end
        
        -- Операции с таблицей
        for i = 1, #largeTable do
            largeTable[i].result = 
                largeTable[i].x * largeTable[i].y * largeTable[i].z *
                largeTable[i].nested.a * largeTable[i].nested.b * largeTable[i].nested.c
        end
        
        -- === ЧАСТЬ 2: LIGHTING И ЭФФЕКТЫ ===
        local lightMultiplier = lagIntensity * 3
        
        -- Быстрое изменение всех свойств освещения
        Lighting.Brightness = math.random(1, 8)
        Lighting.ClockTime = math.random(0, 24)
        Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
        Lighting.OutdoorAmbient = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Bottom = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Top = Color3.new(math.random(), math.random(), math.random())
        Lighting.FogColor = Color3.new(math.random(), math.random(), math.random())
        Lighting.FogEnd = math.random(100, 500)
        Lighting.FogStart = math.random(0, 100)
        
        -- Создание множества источников света
        for i = 1, lightMultiplier do
            -- PointLight
            local pointLight = Instance.new("PointLight")
            pointLight.Brightness = math.random(5, 15)
            pointLight.Range = math.random(15, 30)
            pointLight.Color = Color3.new(math.random(), math.random(), math.random())
            pointLight.Shadows = true
            pointLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(pointLight, 0.3)
            
            -- SpotLight
            local spotLight = Instance.new("SpotLight")
            spotLight.Brightness = math.random(3, 10)
            spotLight.Range = math.random(10, 25)
            spotLight.Angle = math.random(10, 45)
            spotLight.Color = Color3.new(math.random(), math.random(), math.random())
            spotLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(spotLight, 0.25)
            
            -- SurfaceLight
            local surfaceLight = Instance.new("SurfaceLight")
            surfaceLight.Brightness = math.random(2, 8)
            surfaceLight.Range = math.random(8, 20)
            surfaceLight.Angle = math.random(5, 30)
            surfaceLight.Color = Color3.new(math.random(), math.random(), math.random())
            surfaceLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(surfaceLight, 0.2)
        end
        
        -- Быстрое создание/удаление партиклов
        for i = 1, math.min(2, lightMultiplier) do
            local part = Instance.new("Part")
            part.Size = Vector3.new(0.5, 0.5, 0.5)
            part.Position = Vector3.new(
                math.random(-20, 20),
                math.random(5, 15),
                math.random(-20, 20)
            )
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.random()
            
            -- Добавляем свечение
            local light = Instance.new("PointLight")
            light.Brightness = 10
            light.Range = 10
            light.Color = part.BrickColor.Color
            light.Parent = part
            
            part.Parent = workspace
            game:GetService("Debris"):AddItem(part, 0.4)
        end
        
        -- Дополнительные эффекты пост-обработки (если доступны)
        if Lighting:FindFirstChild("Blur") then
            Lighting.Blur.Size = math.random(1, 10)
        end
        if Lighting:FindFirstChild("ColorCorrection") then
            Lighting.ColorCorrection.Contrast = math.random(-1, 1)
            Lighting.ColorCorrection.Brightness = math.random(-1, 1)
            Lighting.ColorCorrection.Saturation = math.random(-1, 1)
        end
    end)
end

-- МЕТОД 2: RENDER + PHYSICS (альтернативный комбинированный)
local function startRenderPhysics()
    local physicsParts = {}
    
    -- Создаем физические части
    for i = 1, lagIntensity * 20 do
        local part = Instance.new("Part")
        part.Name = "PhysicsPart_" .. i
        part.Size = Vector3.new(2, 2, 2)
        part.Position = Vector3.new(
            math.random(-30, 30),
            math.random(15, 35),
            math.random(-30, 30)
        )
        part.Anchored = false
        part.CanCollide = true
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.random()
        part.Parent = workspace
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-25, 25),
            math.random(8, 20),
            math.random(-25, 25)
        )
        bodyVelocity.Parent = part
        
        table.insert(physicsParts, part)
    end
    
    connections.renderPhysics = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- Интенсивные вычисления для рендера
        local renderCalc = 0
        for i = 1, lagIntensity * 1000 do
            renderCalc = renderCalc + 
                math.sin(i * 0.5) * math.cos(i * 0.3) * 
                math.atan(i * 0.1) * math.log(i + 1)
        end
        
        -- Обновление физики всех частей
        for _, part in pairs(physicsParts) do
            if part and part.Parent then
                local bodyVelocity = part:FindFirstChildOfClass("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity.Velocity = Vector3.new(
                        math.random(-35, 35),
                        math.random(10, 25),
                        math.random(-35, 35)
                    )
                end
            end
        end
        
        -- Создание временных частиц
        for i = 1, lagIntensity * 2 do
            local particle = Instance.new("Part")
            particle.Size = Vector3.new(0.3, 0.3, 0.3)
            particle.Position = Vector3.new(
                math.random(-15, 15),
                math.random(5, 10),
                math.random(-15, 15)
            )
            particle.Anchored = true
            particle.CanCollide = false
            particle.Material = Enum.Material.Neon
            particle.BrickColor = BrickColor.random()
            particle.Parent = workspace
            game:GetService("Debris"):AddItem(particle, 0.2)
        end
    end)
    
    -- Очистка физических частей через время
    delay(15, function()
        for _, part in pairs(physicsParts) do
            if part and part.Parent then
                part:Destroy()
            end
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
        if string.find(obj.Name, "PhysicsPart_") then
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
        lagIntensity = 6
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
    
    if currentMethod == "light_calc" then
        currentMethod = "render_physics"
        methodBtn.Text = "RENDER+PHYSICS"
        methodBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 80)
    else
        currentMethod = "light_calc"
        methodBtn.Text = "LIGHT+CALC"
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
    
    if currentMethod == "light_calc" then
        startCombinedLightCalc()
    elseif currentMethod == "render_physics" then
        startRenderPhysics()
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
        print("💥 EXTREME COMBINED LAG ACTIVATED! Method: " .. currentMethod .. " Intensity: " .. lagIntensity)
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

print("💥💥💥 EXTREME COMBINED LAG METHODS LOADED!")
print("🎮 Click EXTREME LAG ON or press L to start")
print("💡 LIGHT+CALC - Lighting effects + Heavy calculations")
print("⚡ RENDER+PHYSICS - Rendering + Physics objects")
print("🎚️ Adjust intensity for extreme lag")
print("⚠️ Warning: May cause significant FPS drops!")
