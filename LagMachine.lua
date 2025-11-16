-- Ultimate Client Lag Machine
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Настройки
local LagEnabled = false
local LagIntensity = 10

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LagMachineGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0, 400, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Header
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
title.Text = "LAG MACHINE"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.BackgroundTransparency = 1
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close button
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

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Intensity section
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
intensityTitle.Text = "Lag Intensity"
intensityTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
intensityTitle.BackgroundTransparency = 1
intensityTitle.TextSize = 12
intensityTitle.Font = Enum.Font.Gotham
intensityTitle.TextXAlignment = Enum.TextXAlignment.Left
intensityTitle.Parent = intensitySection

-- Intensity input
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

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 70)
statusLabel.Text = "Status: DISABLED"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = intensitySection

-- Buttons
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, 0, 0, 70)
buttonsFrame.Position = UDim2.new(0, 0, 0, 90)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = content

-- Enable button
local enableBtn = Instance.new("TextButton")
enableBtn.Size = UDim2.new(1, 0, 0, 35)
enableBtn.Text = "ACTIVATE LAG"
enableBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
enableBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
enableBtn.BorderSizePixel = 0
enableBtn.TextSize = 14
enableBtn.Font = Enum.Font.GothamBold
enableBtn.Parent = buttonsFrame

local enableCorner = Instance.new("UICorner")
enableCorner.CornerRadius = UDim.new(0, 8)
enableCorner.Parent = enableBtn

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0, 45)
infoLabel.Text = "Higher intensity = more lag"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.BackgroundTransparency = 1
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.Parent = buttonsFrame

-- ФУНКЦИОНАЛЬНОСТЬ

-- Закрытие GUI
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Включение/выключение лагов
enableBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = "Status: ACTIVE (Intensity: " .. LagIntensity .. ")"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        enableBtn.Text = "DEACTIVATE LAG"
        enableBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        print("💥 LAG MACHINE ACTIVATED! Intensity: " .. LagIntensity)
    else
        statusLabel.Text = "Status: DISABLED"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        enableBtn.Text = "ACTIVATE LAG"
        enableBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        print("✅ Lag machine deactivated")
    end
end)

-- Обновление интенсивности
intensityInput.FocusLost:Connect(function()
    local newIntensity = tonumber(intensityInput.Text)
    if newIntensity and newIntensity > 0 then
        LagIntensity = math.min(newIntensity, 100) -- Максимум 100
        intensityInput.Text = tostring(LagIntensity)
        if LagEnabled then
            statusLabel.Text = "Status: ACTIVE (Intensity: " .. LagIntensity .. ")"
        end
        print("📊 Lag intensity updated: " .. LagIntensity)
    end
end)

-- Перетаскивание
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

-- СИСТЕМА СОЗДАНИЯ ЛАГОВ
local lagTasks = {}
local memoryHog = {}

local function createMemoryLag()
    if not LagEnabled then return end
    
    -- Создаем огромные таблицы для потребления памяти
    for i = 1, LagIntensity * 100 do
        memoryHog[i] = {}
        for j = 1, 100 do
            memoryHog[i][j] = string.rep("LAG", 100)
        end
    end
end

local function createCPULag()
    if not LagEnabled then return end
    
    -- Интенсивные вычисления для нагрузки на CPU
    local startTime = tick()
    while tick() - startTime < (LagIntensity / 100) and LagEnabled do
        -- Выполняем бесполезные вычисления
        local mathResult = 0
        for i = 1, LagIntensity * 1000 do
            mathResult = mathResult + math.sin(i) * math.cos(i)
        end
    end
end

local function createNetworkLag()
    if not LagEnabled then return end
    
    -- Создаем фиктивные сетевые запросы
    for i = 1, math.min(LagIntensity, 10) do
        spawn(function()
            local startTime = tick()
            while tick() - startTime < 1 and LagEnabled do
                -- Имитация сетевой активности
                wait(0.01)
            end
        end)
    end
end

local function createRenderLag()
    if not LagEnabled then return end
    
    -- Создаем нагрузку на рендеринг
    for i = 1, LagIntensity do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = Vector3.new(math.random(-50, 50), math.random(10, 50), math.random(-50, 50))
        part.Anchored = true
        part.Parent = workspace
        
        -- Анимируем частицы для дополнительной нагрузки
        spawn(function()
            while part and part.Parent and LagEnabled do
                part.Position = part.Position + Vector3.new(
                    math.sin(tick()) * 0.1,
                    math.cos(tick()) * 0.1, 
                    math.sin(tick()) * 0.1
                )
                wait(0.1)
            end
        end)
    end
end

-- Основной цикл создания лагов
spawn(function()
    while true do
        if LagEnabled then
            -- Запускаем все виды лагов одновременно
            createMemoryLag()
            createCPULag() 
            createNetworkLag()
            createRenderLag()
            
            -- Добавляем случайные задержки
            wait(0.1 / LagIntensity)
        else
            -- Очищаем память когда лаги выключены
            memoryHog = {}
            wait(0.5)
        end
    end
end)

print("💥 Ultimate Lag Machine loaded!")
print("📍 Set intensity and click ACTIVATE LAG")
print("⚠️  WARNING: This will significantly lag your game!")
print("💡 Intensity 10 = mild lag, 100 = extreme lag")