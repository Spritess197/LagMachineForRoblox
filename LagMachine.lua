-- SMART SERVER LAG MACHINE (Anti-Ban)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LagEnabled = false
local requestCount = 0
local lastRequestTime = 0

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmartLagGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 180)
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
title.Text = "SMART LAG MACHINE"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.BackgroundTransparency = 1
title.TextSize = 14
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

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Text = "Status: DISABLED (Press L)"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
status.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = content

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 80)
infoLabel.Position = UDim2.new(0, 0, 0, 30)
infoLabel.Text = "🎯 Smart server lag system\n🎮 Press L to toggle\n📡 Uses legitimate requests\n🛡️ Anti-detection methods\n💡 Creates lag without kicks"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.BackgroundTransparency = 1
infoLabel.TextSize = 11
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextWrapped = true
infoLabel.Parent = content

-- ФУНКЦИОНАЛЬНОСТЬ

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
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

-- Переключение по клавише L
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        
        if LagEnabled then
            statusLabel.Text = "Status: SMART LAG! (" .. requestCount .. ")"
            statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            print("🎯 SMART SERVER LAG ACTIVATED!")
        else
            statusLabel.Text = "Status: DISABLED (Press L)"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            print("🛑 Smart lag stopped. Total requests: " .. requestCount)
        end
    end
end)

-- УМНАЯ СИСТЕМА ЛАГОВ (Anti-Ban)
local lagActive = false
local safeRemotes = {}

-- Находим только безопасные Remote объекты
local function findSafeRemotes()
    safeRemotes = {}
    
    -- Ищем в безопасных местах
    local safeLocations = {
        ReplicatedStorage,
        workspace,
        game:GetService("Lighting")
    }
    
    for _, location in pairs(safeLocations) do
        for _, obj in pairs(location:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not safeRemotes[obj] then
                -- Проверяем что это не критически важные системные Remote
                local name = obj.Name:lower()
                if not name:find("admin") and not name:find("ban") and not name:find("kick") and
                   not name:find("mod") and not name:find("report") then
                    table.insert(safeRemotes, obj)
                end
            end
        end
    end
    
    print("🛡️ Safe remotes found: " .. #safeRemotes)
end

-- Умная функция задержки (избегает детекции)
local function smartDelay()
    -- Случайная задержка между 0.1 и 0.5 секундами
    local delayTime = 0.1 + math.random() * 0.4
    wait(delayTime)
end

-- Создание "легитимных" данных для запросов
local function createLegitimateData()
    local dataTypes = {
        -- Легкие данные
        function() return math.random(1, 100) end,
        function() return "player_action_" .. math.random(1, 10) end,
        function() return {action = "move", x = math.random(-10, 10)} end,
        function() return Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)) end,
        function() return true end,
        function() return false end,
        function() return nil end
    }
    
    return dataTypes[math.random(1, #dataTypes)]()
end

-- Умный спам запросами
local function smartLagSystem()
    if not LagEnabled or lagActive or #safeRemotes == 0 then return end
    
    lagActive = true
    local cycleCount = 0
    
    print("🚀 STARTING SMART LAG SYSTEM...")
    
    while LagEnabled do
        cycleCount = cycleCount + 1
        
        -- Используем только 1-3 случайных Remote за цикл (не все сразу)
        local remotesToUse = {}
        for i = 1, math.random(1, 3) do
            if #safeRemotes > 0 then
                table.insert(remotesToUse, safeRemotes[math.random(1, #safeRemotes)])
            end
        end
        
        -- Отправляем "легитимные" запросы
        for _, remote in pairs(remotesToUse) do
            if LagEnabled then
                pcall(function()
                    local data = createLegitimateData()
                    
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(data)
                    else
                        remote:InvokeServer(data)
                    end
                    
                    requestCount = requestCount + 1
                    statusLabel.Text = "Status: SMART LAG! (" .. requestCount .. ")"
                end)
                
                -- Случайная задержка между запросами
                wait(0.05 + math.random() * 0.1)
            end
        end
        
        -- ИМИТАЦИЯ НОРМАЛЬНОЙ ИГРОВОЙ АКТИВНОСТИ
        if LagEnabled then
            -- Иногда двигаем персонажа (легитимное действие)
            if math.random(1, 10) == 1 and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:Move(Vector3.new(math.random(-1, 1), 0, math.random(-1, 1)))
                end
            end
            
            -- Иногда прыгаем
            if math.random(1, 20) == 1 and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Jump = true
                end
            end
        end
        
        -- Выводим статистику
        if cycleCount % 15 == 0 then
            print("🎯 SMART LAG CYCLE #" .. cycleCount .. " - Requests: " .. requestCount)
        end
        
        -- Случайная пауза между циклами
        smartDelay()
    end
    
    lagActive = false
    print("🛑 SMART LAG SYSTEM STOPPED")
end

-- СИСТЕМА "ТЯЖЕЛЫХ" ЗАПРОСОВ (создает лаги но редко)
local heavyLagActive = false

local function heavyLagSystem()
    if not LagEnabled or heavyLagActive or #safeRemotes == 0 then return end
    
    heavyLagActive = true
    
    while LagEnabled do
        -- Ждем случайное время между тяжелыми запросами (30-60 секунд)
        wait(30 + math.random() * 30)
        
        if LagEnabled then
            print("💥 SENDING HEAVY REQUEST...")
            
            -- Отправляем "тяжелый" запрос (но легитимный)
            local remote = safeRemotes[math.random(1, #safeRemotes)]
            if remote then
                pcall(function()
                    -- Создаем "тяжелые" но легитимные данные
                    local heavyData = {
                        playerData = {
                            position = Vector3.new(math.random(-100, 100), math.random(0, 50), math.random(-100, 100)),
                            inventory = {"item1", "item2", "item3"},
                            stats = {health = 100, mana = 50, stamina = 75}
                        },
                        action = "complex_interaction",
                        timestamp = tick()
                    }
                    
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(heavyData)
                    else
                        remote:InvokeServer(heavyData)
                    end
                    
                    requestCount = requestCount + 1
                    print("💣 Heavy request sent! Total: " .. requestCount)
                end)
            end
        end
    end
    
    heavyLagActive = false
end

-- Запускаем системы
findSafeRemotes()

spawn(function()
    while true do
        if LagEnabled and not lagActive then
            smartLagSystem()
        end
        wait(1)
    end
end)

spawn(function()
    while true do
        if LagEnabled and not heavyLagActive then
            heavyLagSystem()
        end
        wait(1)
    end
end)

-- Периодически обновляем список безопасных Remote
spawn(function()
    while true do
        if LagEnabled then
            findSafeRemotes()
        end
        wait(30) -- Обновляем каждые 30 секунд
    end
end)

print("🎯🎯🎯 SMART SERVER LAG MACHINE LOADED!")
print("🎮 Press L to start/stop smart lag")
print("🛡️ Using anti-detection methods")
print("💡 Creates server lag without getting kicked")
print("🚀 Starting with " .. #safeRemotes .. " safe remote objects")
