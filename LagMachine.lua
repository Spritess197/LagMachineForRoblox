-- ULTIMATE SERVER LAG (All Methods Combined)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LagEnabled = false
local lagIntensity = 1

-- GUI (старый рабочий вариант)
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
local connections = {}
local physicsParts = {}
local createdParts = {}

local function closeGUI()
    scriptRunning = false
    -- Отключаем все соединения
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    -- Очищаем все объекты
    for _, part in pairs(physicsParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    for _, part in pairs(createdParts) do
        if part and part.Parent then
            part:Destroy()
        end
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

-- УЛЬТИМАТИВНЫЙ МЕТОД: ВСЕ ВМЕСТЕ
local function startUltimateLag()
    -- Создаем физические части один раз
    for i = 1, lagIntensity * 25 do
        local part = Instance.new("Part")
        part.Name = "UltimatePhysics_" .. i
        part.Size = Vector3.new(1.5, 1.5, 1.5)
        part.Position = Vector3.new(
            math.random(-40, 40),
            math.random(20, 50),
            math.random(-40, 40)
        )
        part.Anchored = false
        part.CanCollide = true
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.random()
        part.Parent = workspace
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-30, 30),
            math.random(10, 25),
            math.random(-30, 30)
        )
        bodyVelocity.Parent = part
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 1000
        bodyGyro.D = 100
        bodyGyro.Parent = part
        
        table.insert(physicsParts, part)
    end
    
    -- ОСНОВНОЙ ЦИКЛ ВСЕХ МЕТОДОВ
    connections.ultimate = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- === МЕТОД 1: СУПЕР ИНТЕНСИВНЫЕ ВЫЧИСЛЕНИЯ ===
        local ultraHeavyCalc = 0
        local calcMultiplier = lagIntensity * 1000
        
        -- Ультра тяжелые математические операции (3 уровня вложенности)
        for a = 1, math.max(10, calcMultiplier / 100) do
            for b = 1, 50 do
                for c = 1, 20 do
                    ultraHeavyCalc = ultraHeavyCalc + 
                        math.sin(a * b * c) * math.cos(a / (b + c)) * 
                        math.tan(a + b + c) * math.log(math.abs(a - b - c) + 1) *
                        math.sqrt(a * b * c) * math.exp((a + b + c) * 0.0001) *
                        math.atan(a * b) * math.asin(math.random()) *
                        math.acos(math.random())
                end
            end
        end
        
        -- Гигантские таблицы с глубокой вложенностью
        local megaTable = {}
        for i = 1, calcMultiplier / 10 do
            megaTable[i] = {
                id = i,
                position = {
                    x = math.random(1, 10000),
                    y = math.random(1, 10000),
                    z = math.random(1, 10000)
                },
                rotation = {
                    x = math.random(0, 360),
                    y = math.random(0, 360),
                    z = math.random(0, 360)
                },
                data = {
                    health = math.random(1, 1000),
                    mana = math.random(1, 1000),
                    stamina = math.random(1, 1000),
                    level = math.random(1, 100),
                    stats = {
                        strength = math.random(1, 100),
                        agility = math.random(1, 100),
                        intelligence = math.random(1, 100),
                        luck = math.random(1, 100)
                    },
                    inventory = {
                        item1 = {name = "sword", damage = math.random(10, 100)},
                        item2 = {name = "shield", defense = math.random(5, 50)},
                        item3 = {name = "potion", heal = math.random(20, 200)}
                    }
                },
                calculated = {
                    damage = math.random(1, 1000) * math.random(1, 100),
                    defense = math.random(1, 500) * math.random(1, 50),
                    speed = math.random(1, 100) * math.random(1, 10)
                }
            }
        end
        
        -- Интенсивные операции с таблицей
        for i = 1, #megaTable do
            local item = megaTable[i]
            item.final = {
                totalPower = item.calculated.damage + item.calculated.defense + item.calculated.speed,
                combatScore = item.data.stats.strength * 2 + item.data.stats.agility * 1.5 + item.data.stats.intelligence,
                effectiveness = item.data.inventory.item1.damage * item.data.inventory.item2.defense
            }
        end
        
        -- === МЕТОД 2: ЭКСТРЕМАЛЬНОЕ LIGHTING ===
        local lightMultiplier = lagIntensity * 5
        
        -- Безумно быстрое изменение ВСЕХ свойств освещения
        Lighting.Brightness = math.random(0.5, 10)
        Lighting.ClockTime = math.random(0, 24)
        Lighting.GeographicLatitude = math.random(-90, 90)
        Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
        Lighting.OutdoorAmbient = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Bottom = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Top = Color3.new(math.random(), math.random(), math.random())
        Lighting.FogColor = Color3.new(math.random(), math.random(), math.random())
        Lighting.FogEnd = math.random(50, 1000)
        Lighting.FogStart = math.random(0, 500)
        Lighting.GlobalShadows = math.random() > 0.5
        Lighting.ShadowSoftness = math.random()
        
        -- Массовое создание всех типов источников света
        for i = 1, lightMultiplier do
            -- PointLight
            local pointLight = Instance.new("PointLight")
            pointLight.Brightness = math.random(3, 20)
            pointLight.Range = math.random(10, 40)
            pointLight.Color = Color3.new(math.random(), math.random(), math.random())
            pointLight.Shadows = true
            pointLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(pointLight, 0.2)
            
            -- SpotLight
            local spotLight = Instance.new("SpotLight")
            spotLight.Brightness = math.random(2, 15)
            spotLight.Range = math.random(8, 35)
            spotLight.Angle = math.random(5, 60)
            spotLight.Color = Color3.new(math.random(), math.random(), math.random())
            spotLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(spotLight, 0.15)
            
            -- SurfaceLight
            local surfaceLight = Instance.new("SurfaceLight")
            surfaceLight.Brightness = math.random(1, 12)
            surfaceLight.Range = math.random(5, 25)
            surfaceLight.Angle = math.random(3, 45)
            surfaceLight.Color = Color3.new(math.random(), math.random(), math.random())
            surfaceLight.Face = Enum.NormalId[{"Top", "Bottom", "Left", "Right", "Front", "Back"}[math.random(1, 6)]]
            surfaceLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(surfaceLight, 0.1)
        end
        
        -- === МЕТОД 3: ФИЗИКА НА МАКСИМУМЕ ===
        for _, part in pairs(physicsParts) do
            if part and part.Parent then
                -- Обновляем BodyVelocity
                local bodyVelocity = part:FindFirstChildOfClass("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity.Velocity = Vector3.new(
                        math.random(-40, 40),
                        math.random(5, 30),
                        math.random(-40, 40)
                    )
                end
                
                -- Обновляем BodyGyro
                local bodyGyro = part:FindFirstChildOfClass("BodyGyro")
                if bodyGyro then
                    bodyGyro.CFrame = CFrame.Angles(
                        math.rad(math.random(0, 360)),
                        math.rad(math.random(0, 360)),
                        math.rad(math.random(0, 360))
                    )
                end
                
                -- Добавляем случайные силы
                if math.random(1, 10) == 1 then
                    local force = Instance.new("BodyForce")
                    force.Force = Vector3.new(
                        math.random(-100, 100),
                        math.random(50, 200),
                        math.random(-100, 100)
                    )
                    force.Parent = part
                    game:GetService("Debris"):AddItem(force, 0.1)
                end
            end
        end
        
        -- === МЕТОД 4: МАССОВОЕ СОЗДАНИЕ ОБЪЕКТОВ ===
        local objectMultiplier = lagIntensity * 8
        
        for i = 1, objectMultiplier do
            -- Создаем части с разными свойствами
            local part = Instance.new("Part")
            part.Size = Vector3.new(
                math.random(0.5, 3),
                math.random(0.5, 3),
                math.random(0.5, 3)
            )
            part.Position = Vector3.new(
                math.random(-60, 60),
                math.random(5, 25),
                math.random(-60, 60)
            )
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material[{"Neon", "Plastic", "Metal", "Wood", "Glass"}[math.random(1, 5)]]
            part.BrickColor = BrickColor.random()
            part.Transparency = math.random(0, 50) / 100
            part.Reflectance = math.random(0, 50) / 100
            
            -- Добавляем свечение
            local light = Instance.new("PointLight")
            light.Brightness = math.random(5, 15)
            light.Range = math.random(5, 20)
            light.Color = part.BrickColor.Color
            light.Parent = part
            
            part.Parent = workspace
            table.insert(createdParts, part)
            game:GetService("Debris"):AddItem(part, 0.3)
        end
        
        -- === МЕТОД 5: ДОПОЛНИТЕЛЬНЫЕ ЭФФЕКТЫ ===
        -- Быстрое изменение пост-обработки
        if Lighting:FindFirstChild("Blur") then
            Lighting.Blur.Size = math.random(0, 20)
        end
        if Lighting:FindFirstChild("ColorCorrection") then
            Lighting.ColorCorrection.Contrast = math.random(-2, 2)
            Lighting.ColorCorrection.Brightness = math.random(-1, 1)
            Lighting.ColorCorrection.Saturation = math.random(-2, 2)
            Lighting.ColorCorrection.TintColor = Color3.new(math.random(), math.random(), math.random())
        end
        
        -- Создание партиклов
        for i = 1, math.min(3, lagIntensity) do
            local particle = Instance.new("Part")
            particle.Size = Vector3.new(0.2, 0.2, 0.2)
            particle.Position = Vector3.new(
                math.random(-10, 10),
                math.random(2, 8),
                math.random(-10, 10)
            )
            particle.Anchored = true
            particle.CanCollide = false
            particle.Material = Enum.Material.Neon
            particle.BrickColor = BrickColor.random()
            particle.Parent = workspace
            game:GetService("Debris"):AddItem(particle, 0.1)
        end
        
        -- === МЕТОД 6: ДОПОЛНИТЕЛЬНЫЕ ВЫЧИСЛЕНИЯ ===
        -- Еще больше математики для гарантированного лага
        local extraCalc = 0
        for x = 1, calcMultiplier / 5 do
            extraCalc = extraCalc + 
                math.pow(x, 2) * math.log(x + 1) * 
                math.sin(x * 0.01) * math.cos(x * 0.02) *
                math.tan(x * 0.005) * math.atan(x * 0.001)
        end
    end)
end

-- Очистка всего
local function cleanupAll()
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    connections = {}
    
    -- Удаляем все созданные части
    for _, part in pairs(physicsParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    for _, part in pairs(createdParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    physicsParts = {}
    createdParts = {}
end

-- Переключение интенсивности
intensityBtn.MouseButton1Click:Connect(function()
    if lagIntensity == 1 then
        lagIntensity = 4
        intensityBtn.Text = "INTENSITY: MEDIUM"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 60)
    elseif lagIntensity == 4 then
        lagIntensity = 8
        intensityBtn.Text = "INTENSITY: HIGH"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 60)
    elseif lagIntensity == 8 then
        lagIntensity = 12
        intensityBtn.Text = "INTENSITY: EXTREME"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    else
        lagIntensity = 1
        intensityBtn.Text = "INTENSITY: LOW"
        intensityBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    end
    statusLabel.Text = string.format("Status: %s\nIntensity: %s\nFPS: --", 
        LagEnabled and "ENABLED" or "DISABLED", 
        lagIntensity == 1 and "LOW" or lagIntensity == 4 and "MEDIUM" or lagIntensity == 8 and "HIGH" or "EXTREME")
end)

-- Включение/выключение ультимативных лагов
toggleBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = string.format("Status: ENABLED\nIntensity: %s\nFPS: DROPPING", 
            lagIntensity == 1 and "LOW" or lagIntensity == 4 and "MEDIUM" or lagIntensity == 8 and "HIGH" or "EXTREME")
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleBtn.Text = "ULTIMATE LAG OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        startUltimateLag()
        print("💥💥💥 ULTIMATE LAG ACTIVATED! Intensity: " .. lagIntensity)
        print("⚡ Running ALL methods simultaneously!")
        print("🔥 Extreme calculations + Physics + Lighting + Objects!")
    else
        statusLabel.Text = string.format("Status: DISABLED\nIntensity: %s\nFPS: NORMAL", 
            lagIntensity == 1 and "LOW" or lagIntensity == 4 and "MEDIUM" or lagIntensity == 8 and "HIGH" or "EXTREME")
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "ULTIMATE LAG ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        cleanupAll()
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
                lagIntensity == 1 and "LOW" or lagIntensity == 4 and "MEDIUM" or lagIntensity == 8 and "HIGH" or "EXTREME")
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.Text = "ULTIMATE LAG OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
            startUltimateLag()
        else
            statusLabel.Text = string.format("Status: DISABLED\nIntensity: %s\nFPS: NORMAL", 
                lagIntensity == 1 and "LOW" or lagIntensity == 4 and "MEDIUM" or lagIntensity == 8 and "HIGH" or "EXTREME")
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.Text = "ULTIMATE LAG ON"
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
                statusLabel.Text = string.format("Status: ENABLED\nIntensity: %s\nFPS: %d", 
                    lagIntensity == 1 and "LOW" or lagIntensity == 4 and "MEDIUM" or lagIntensity == 8 and "HIGH" or "EXTREME",
                    fps)
            end
        end
        wait(0.1)
    end
end)

-- Автоочистка каждые 20 секунд
spawn(function()
    while scriptRunning do
        if LagEnabled then
            -- Частичная очистка старых объектов
            for i = #createdParts, 1, -1 do
                if not createdParts[i] or not createdParts[i].Parent then
                    table.remove(createdParts, i)
                end
            end
        end
        wait(20)
    end
end)

print("💥💥💥 ULTIMATE ALL-IN-ONE LAG LOADED!")
print("🎮 GUI should be visible now!")
print("🎮 Click ULTIMATE LAG ON or press L to start")
print("⚡ ALL METHODS COMBINED:")
print("   🔥 Extreme Calculations (3-level loops)")
print("   💡 Maximum Lighting effects") 
print("   🔷 Intensive Physics with BodyVelocity & BodyGyro")
print("   🧩 Mass Object Creation")
print("   ✨ Particle Effects")
print("🎚️ 4 Intensity levels up to EXTREME!")
print("⚠️ WARNING: Will cause MAJOR FPS drops!")
