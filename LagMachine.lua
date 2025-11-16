-- PROPER ULTRA FAST RESPAWN SCRIPT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Настройки
local RespawnEnabled = false
local respawnCount = 0

-- Создаем простой GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraRespawnGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 120)
mainFrame.Position = UDim2.new(0, 400, 0, 150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "ULTRA RESPAWN"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.BackgroundTransparency = 1
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
closeBtn.BorderSizePixel = 0
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -40)
content.Position = UDim2.new(0, 10, 0, 35)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Text = "Status: DISABLED (Press R)"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = content

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.Position = UDim2.new(0, 0, 0, 25)
infoLabel.Text = "⚡ Proper respawn system\n🎮 Press R to toggle\n♾️ Respawns infinitely"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.BackgroundTransparency = 1
infoLabel.TextSize = 10
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Center
infoLabel.TextWrapped = true
infoLabel.Parent = content

-- ФУНКЦИОНАЛЬНОСТЬ

-- Закрытие GUI
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

-- ФУНКЦИЯ ПЕРЕКЛЮЧЕНИЯ ПО КНОПКЕ R
local function toggleRespawn()
    RespawnEnabled = not RespawnEnabled
    
    if RespawnEnabled then
        statusLabel.Text = "Status: ULTRA RESPAWN!"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        print("⚡⚡⚡ ULTRA RESPAWN ACTIVATED!")
        print("🎮 Press R again to stop")
        
        -- Немедленно запускаем первый респавн
        LocalPlayer:LoadCharacter()
    else
        statusLabel.Text = "Status: DISABLED (Press R)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("🛑 Ultra respawn stopped")
        print("📊 Total respawns: " .. respawnCount)
    end
end

-- Обработка нажатия клавиши R
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        toggleRespawn()
    end
end)

-- ПРАВИЛЬНАЯ СИСТЕМА РЕСПАВНА
local respawnActive = false

local function properUltraRespawn()
    if not RespawnEnabled or respawnActive then return end
    
    respawnActive = true
    local cycleCount = 0
    
    print("🚀 STARTING PROPER ULTRA RESPAWN...")
    
    while RespawnEnabled do
        cycleCount = cycleCount + 1
        
        -- Ждем пока появится персонаж
        if not LocalPlayer.Character then
            LocalPlayer:LoadCharacter()
            respawnCount = respawnCount + 1
            wait(0.1) -- Ждем загрузки персонажа
        end
        
        -- Если персонаж есть - убиваем и респавним
        if LocalPlayer.Character then
            -- Способ 1: Официальный респавн (самый надежный)
            LocalPlayer:LoadCharacter()
            respawnCount = respawnCount + 1
            
            -- Ждем немного перед следующим респавном
            wait(0.05)
            
            -- Дополнительный быстрый респавн
            LocalPlayer:LoadCharacter()
            respawnCount = respawnCount + 1
            
            wait(0.05)
            
            -- Еще один респавн
            LocalPlayer:LoadCharacter()
            respawnCount = respawnCount + 1
        end
        
        -- Выводим статистику
        if cycleCount % 10 == 0 then
            print("⚡ RESPAWN CYCLE #" .. cycleCount .. " - Total: " .. respawnCount .. " respawns")
        end
        
        wait(0.1) -- Пауза между циклами
    end
    
    respawnActive = false
    print("🛑 PROPER ULTRA RESPAWN STOPPED")
end

-- ДОПОЛНИТЕЛЬНАЯ СИСТЕМА ДЛЯ МАКСИМАЛЬНОЙ СКОРОСТИ
local fastRespawnActive = false

local function fastRespawnLoop()
    if not RespawnEnabled or fastRespawnActive then return end
    
    fastRespawnActive = true
    
    while RespawnEnabled do
        -- Используем только LoadCharacter() - самый надежный метод
        LocalPlayer:LoadCharacter()
        respawnCount = respawnCount + 1
        
        -- Очень короткая задержка
        wait(0.08)
        
        -- Еще один быстрый респавн
        LocalPlayer:LoadCharacter()
        respawnCount = respawnCount + 1
        
        wait(0.08)
    end
    
    fastRespawnActive = false
end

-- СИСТЕМА СЛЕДЕНИЯ ЗА СОСТОЯНИЕМ ПЕРСОНАЖА
local monitorActive = false

local function monitorCharacter()
    if not RespawnEnabled or monitorActive then return end
    
    monitorActive = true
    
    while RespawnEnabled do
        -- Если персонажа нет - создаем
        if not LocalPlayer.Character then
            LocalPlayer:LoadCharacter()
            respawnCount = respawnCount + 1
            print("🔁 Character missing - respawning")
        end
        
        -- Если персонаж "сломан" (нет Humanoid) - респавним
        if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer:LoadCharacter()
            respawnCount = respawnCount + 1
            print("🔧 Broken character - respawning")
        end
        
        wait(0.2)
    end
    
    monitorActive = false
end

-- Запускаем все системы
spawn(function()
    while true do
        if RespawnEnabled and not respawnActive then
            properUltraRespawn()
        end
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if RespawnEnabled and not fastRespawnActive then
            fastRespawnLoop()
        end
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if RespawnEnabled and not monitorActive then
            monitorCharacter()
        end
        wait(0.1)
    end
end)

print("⚡⚡⚡ PROPER ULTRA RESPAWN SCRIPT LOADED!")
print("🎮 Press R to start/stop ultra respawn")
print("🔧 Uses proper LoadCharacter() method")
print("🚀 10-15 respawns per second!")
print("♾️ Will respawn infinitely until you press R again!")
