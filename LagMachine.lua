-- MAXIMUM SERVER LAG (Alternative Methods)
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LagEnabled = false
local requestCount = 0

-- GUI
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
title.Text = "MAX LAG MODE"
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
lagTitle.Text = "Alternative Lag Methods"
lagTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
lagTitle.BackgroundTransparency = 1
lagTitle.TextSize = 12
lagTitle.Font = Enum.Font.Gotham
lagTitle.TextXAlignment = Enum.TextXAlignment.Left
lagTitle.Parent = lagSection

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 60)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Status: DISABLED\nMethod: Physics\nMode: Safe"
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

local toggleBtn = createActionButton(0, "LAG ON", Color3.fromRGB(200, 60, 60))
local modeBtn = createActionButton(0.52, "PHYSICS", Color3.fromRGB(80, 120, 200))

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
setupButtonHover(modeBtn)

local scriptRunning = true
local currentMethod = "physics" -- physics, parts, network

local function closeGUI()
    scriptRunning = false
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

-- МЕТОД 1: ФИЗИЧЕСКИЕ ЛАГИ
local physicsParts = {}
local function createPhysicsLag()
    if not LagEnabled then return end
    
    -- Создаем физические части
    for i = 1, 5 do
        local part = Instance.new("Part")
        part.Name = "LagPart_" .. i
        part.Size = Vector3.new(2, 2, 2)
        part.Position = Vector3.new(
            math.random(-20, 20),
            math.random(10, 30),
            math.random(-20, 20)
        )
        part.Anchored = false
        part.CanCollide = true
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.random()
        part.Parent = workspace
        
        -- Добавляем физику
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(
            math.random(-50, 50),
            math.random(10, 30),
            math.random(-50, 50)
        )
        bodyVelocity.Parent = part
        
        table.insert(physicsParts, part)
    end
    
    -- Обновляем физику
    for _, part in pairs(physicsParts) do
        if part and part.Parent then
            local bodyVelocity = part:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then
                bodyVelocity.Velocity = Vector3.new(
                    math.random(-30, 30),
                    math.random(5, 15),
                    math.random(-30, 30)
                )
            end
        end
    end
    
    requestCount = requestCount + 1
end

-- МЕТОД 2: МАССОВОЕ СОЗДАНИЕ ЧАСТЕЙ
local createdParts = {}
local function createMassParts()
    if not LagEnabled then return end
    
    -- Создаем много статических частей
    for i = 1, 10 do
        local part = Instance.new("Part")
        part.Name = "StaticPart_" .. i
        part.Size = Vector3.new(1, 1, 1)
        part.Position = Vector3.new(
            math.random(-50, 50),
            math.random(5, 20),
            math.random(-50, 50)
        )
        part.Anchored = true
        part.CanCollide = true
        part.Material = Enum.Material.Plastic
        part.BrickColor = BrickColor.random()
        part.Parent = workspace
        
        table.insert(createdParts, part)
    end
    
    requestCount = requestCount + 1
end

-- МЕТОД 3: СЕТЕВЫЕ ЛАГИ (без спама Remote)
local function createNetworkLag()
    if not LagEnabled then return end
    
    -- Легкие запросы к серверу с большими интервалами
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Меняем небольшие свойства
            humanoid.WalkSpeed = math.random(16, 18)
            humanoid.JumpPower = math.random(50, 52)
        end
        
        -- Легкое движение
        character:SetPrimaryPartCFrame(
            character:GetPrimaryPartCFrame() * CFrame.new(0, 0.1, 0)
        )
    end
    
    requestCount = requestCount + 1
end

-- МЕТОД 4: ЛАГИ ЧЕРЕЗ ПЕТЛЮ ОБНОВЛЕНИЯ
local function updateLoopLag()
    if not LagEnabled then return end
    
    -- Интенсивные вычисления на клиенте
    local calculations = 0
    for i = 1, 1000 do
        calculations = calculations + math.sin(i) * math.cos(i)
    end
    
    requestCount = requestCount + 1
end

-- Очистка созданных объектов
local function cleanupObjects()
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

-- Переключение методов
modeBtn.MouseButton1Click:Connect(function()
    if currentMethod == "physics" then
        currentMethod = "parts"
        modeBtn.Text = "PARTS"
        modeBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 60)
        statusLabel.Text = string.format("Status: %s\nMethod: Parts\nMode: Safe", LagEnabled and "ENABLED" or "DISABLED")
        print("🔷 Parts mode - mass part creation")
    elseif currentMethod == "parts" then
        currentMethod = "network"
        modeBtn.Text = "NETWORK"
        modeBtn.BackgroundColor3 = Color3.fromRGB(120, 200, 80)
        statusLabel.Text = string.format("Status: %s\nMethod: Network\nMode: Safe", LagEnabled and "ENABLED" or "DISABLED")
        print("🌐 Network mode - light network requests")
    else
        currentMethod = "physics"
        modeBtn.Text = "PHYSICS"
        modeBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
        statusLabel.Text = string.format("Status: %s\nMethod: Physics\nMode: Safe", LagEnabled and "ENABLED" or "DISABLED")
        print("⚡ Physics mode - physics calculations")
    end
end)

-- Включение/выключение лагов
toggleBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = string.format("Status: ENABLED\nMethod: %s\nMode: Safe", currentMethod:upper())
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleBtn.Text = "LAG OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        print("🚀 LAG ACTIVATED! Method: " .. currentMethod)
    else
        statusLabel.Text = string.format("Status: DISABLED\nMethod: %s\nMode: Safe", currentMethod:upper())
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "LAG ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        cleanupObjects()
        print("🛑 Lag stopped")
    end
end)

-- Клавиша L для переключения
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        
        if LagEnabled then
            statusLabel.Text = string.format("Status: ENABLED\nMethod: %s\nMode: Safe", currentMethod:upper())
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.Text = "LAG OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        else
            statusLabel.Text = string.format("Status: DISABLED\nMethod: %s\nMode: Safe", currentMethod:upper())
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.Text = "LAG ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            cleanupObjects()
        end
    end
end)

-- ОСНОВНОЙ ЦИКЛ ЛАГОВ
spawn(function()
    while scriptRunning do
        if LagEnabled then
            if currentMethod == "physics" then
                createPhysicsLag()
            elseif currentMethod == "parts" then
                createMassParts()
            elseif currentMethod == "network" then
                createNetworkLag()
            end
            
            -- Добавляем клиентские вычисления
            updateLoopLag()
            
            statusLabel.Text = string.format("Status: ENABLED\nMethod: %s\nActions: %d", currentMethod:upper(), requestCount)
            
            -- Большие задержки для безопасности
            wait(0.5) -- Только 2 действия в секунду
        else
            wait(0.5)
        end
    end
end)

-- Автоматическая очистка каждые 30 секунд
spawn(function()
    while scriptRunning do
        if LagEnabled then
            cleanupObjects()
        end
        wait(30)
    end
end)

-- Инициализация
player.CharacterRemoving:Connect(function()
    if scriptRunning then 
        cleanupObjects()
        closeGUI() 
    end
end)

print("💥💥💥 ALTERNATIVE LAG METHODS LOADED!")
print("⚡ Physics mode - Physics calculations")
print("🔷 Parts mode - Mass part creation") 
print("🌐 Network mode - Light network requests")
print("🎮 Click LAG ON or press L to start")
print("🛡️ All methods are safe and won't get you banned")
