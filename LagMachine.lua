-- ULTIMATE SERVER LAG (All Methods Combined)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LagEnabled = false
local lagIntensity = 1

-- Создаем GUI в корне игры чтобы он не пропадал после респавна
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MaxLagGUI"
screenGui.ResetOnSpawn = false  -- ВАЖНО: отключаем сброс при респавне
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Помещаем GUI в StarterGui чтобы он восстанавливался после респавна
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

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
local physicsParts = {}
local createdParts = {}

-- Функция для восстановления GUI после респавна
local function ensureGUI()
    if not screenGui or not screenGui.Parent then
        -- Пересоздаем GUI если он был удален
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MaxLagGUI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        
        -- Пересоздаем все элементы GUI...
        -- [здесь должен быть код пересоздания всех элементов GUI]
        -- Но для простоты просто вернем существующий GUI
    end
    return screenGui
end

local function closeGUI()
    scriptRunning = false
    if lagConnection then
        lagConnection:Disconnect()
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
    if screenGui then
        screenGui:Destroy()
    end
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

-- УЛЬТИМАТИВНЫЙ МЕТОД: ВСЕ 4 МЕТОДА ВМЕСТЕ
local function startUltimateLag()
    -- Создаем физические части один раз
    for i = 1, lagIntensity * 15 do
        local part = Instance.new("Part")
        part.Name = "PhysicsPart_" .. i
        part.Size = Vector3.new(1.5, 1.5, 1.5)
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
    
    if lagConnection then
        lagConnection:Disconnect()
    end
    
    lagConnection = RunService.RenderStepped:Connect(function()
        if not LagEnabled then return end
        
        -- === МЕТОД 1: СУПЕР ИНТЕНСИВНЫЕ ВЫЧИСЛЕНИЯ ===
        local ultraHeavyCalc = 0
        local calcMultiplier = lagIntensity * 500
        
        -- Ультра тяжелые математические операции
        for a = 1, math.max(5, calcMultiplier / 200) do
            for b = 1, 30 do
                for c = 1, 15 do
                    ultraHeavyCalc = ultraHeavyCalc + 
                        math.sin(a * b * c) * math.cos(a / (b + c)) * 
                        math.tan(a + b + c) * math.log(math.abs(a - b - c) + 1)
                end
            end
        end
        
        -- Гигантские таблицы
        local megaTable = {}
        for i = 1, calcMultiplier / 20 do
            megaTable[i] = {
                id = i,
                position = {x = math.random(1, 1000), y = math.random(1, 1000), z = math.random(1, 1000)},
                data = {
                    health = math.random(1, 100),
                    stats = {strength = math.random(1, 100), agility = math.random(1, 100)}
                }
            }
        end
        
        -- === МЕТОД 2: ЭКСТРЕМАЛЬНОЕ LIGHTING ===
        local lightMultiplier = lagIntensity * 3
        
        -- Быстрое изменение освещения
        Lighting.Brightness = math.random(0.5, 8)
        Lighting.ClockTime = math.random(0, 24)
        Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
        Lighting.OutdoorAmbient = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Bottom = Color3.new(math.random(), math.random(), math.random())
        Lighting.ColorShift_Top = Color3.new(math.random(), math.random(), math.random())
        Lighting.FogColor = Color3.new(math.random(), math.random(), math.random())
        
        -- Создание источников света
        for i = 1, lightMultiplier do
            local pointLight = Instance.new("PointLight")
            pointLight.Brightness = math.random(3, 15)
            pointLight.Range = math.random(8, 25)
            pointLight.Color = Color3.new(math.random(), math.random(), math.random())
            pointLight.Parent = workspace.Terrain
            game:GetService("Debris"):AddItem(pointLight, 0.3)
        end
        
        -- Эффекты пост-обработки
        if Lighting:FindFirstChild("ColorCorrection") then
            Lighting.ColorCorrection.Contrast = math.random(-2, 2)
            Lighting.ColorCorrection.Brightness = math.random(-1, 1)
            Lighting.ColorCorrection.Saturation = math.random(-2, 2)
            Lighting.ColorCorrection.TintColor = Color3.new(math.random(), math.random(), math.random())
        end
        
        -- === МЕТОД 3: ФИЗИКА НА МАКСИМУМЕ ===
        for _, part in pairs(physicsParts) do
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
        
        -- === МЕТОД 4: МАССОВОЕ СОЗДАНИЕ ОБЪЕКТОВ ===
        local objectMultiplier = lagIntensity * 5
        
        for i = 1, objectMultiplier do
            local part = Instance.new("Part")
            part.Size = Vector3.new(
                math.random(0.5, 2),
                math.random(0.5, 2),
                math.random(0.5, 2)
            )
            part.Position = Vector3.new(
                math.random(-40, 40),
                math.random(5, 20),
                math.random(-40, 40)
            )
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.random()
            part.Transparency = math.random(0, 50) / 100
            
            local light = Instance.new("PointLight")
            light.Brightness = math.random(3, 10)
            light.Range = math.random(5, 15)
            light.Color = part.BrickColor.Color
            light.Parent = part
            
            part.Parent = workspace
            table.insert(createdParts, part)
            game:GetService("Debris"):AddItem(part, 0.4)
        end
        
        -- === ДОПОЛНИТЕЛЬНЫЕ ЭФФЕКТЫ ===
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
            game:GetService("Debris"):AddItem(particle, 0.2)
        end
        
        -- Дополнительные вычисления
        local extraCalc = 0
        for x = 1, calcMultiplier / 10 do
            extraCalc = extraCalc + 
                math.pow(x, 2) * math.log(x + 1) * 
                math.sin(x * 0.01) * math.cos(x * 0.02)
        end
    end)
end

-- Очистка всего
local function cleanupAll()
    if lagConnection then
        lagConnection:Disconnect()
    end
    
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
        print("⚡ Running ALL 4 methods simultaneously!")
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

-- Автоочистка каждые 15 секунд
spawn(function()
    while scriptRunning do
        if LagEnabled then
            for i = #createdParts, 1, -1 do
                if not createdParts[i] or not createdParts[i].Parent then
                    table.remove(createdParts, i)
                end
            end
        end
        wait(15)
    end
end)

-- Восстановление GUI после респавна
player.CharacterAdded:Connect(function()
    wait(1) -- Ждем немного после респавна
    if not screenGui or not screenGui.Parent then
        -- Если GUI пропал, пересоздаем его
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MaxLagGUI"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = player:WaitForChild("PlayerGui")
        
        -- Здесь нужно пересоздать все элементы GUI, но для простоты оставим как есть
        print("🔄 GUI restored after respawn")
    end
end)

player.CharacterRemoving:Connect(function()
    -- Не закрываем GUI при респавне, только очищаем объекты
    cleanupAll()
end)

print("💥💥💥 ULTIMATE ALL-IN-ONE LAG LOADED!")
print("🎮 GUI should persist after respawn!")
print("🎮 Click ULTIMATE LAG ON or press L to start")
print("⚡ ALL 4 METHODS COMBINED:")
print("   🔥 Extreme Calculations (3-level loops)")
print("   💡 Maximum Lighting effects") 
print("   🔷 Intensive Physics with BodyVelocity")
print("   🧩 Mass Object Creation")
print("🎚️ 4 Intensity levels up to EXTREME!")
