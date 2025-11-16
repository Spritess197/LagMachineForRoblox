-- ULTRA FAST MULTI-RESET SCRIPT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Настройки
local MultiResetEnabled = false
local resetCount = 0

-- Создаем простой GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraResetGUI"
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
title.Text = "ULTRA FAST RESET"
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
infoLabel.Text = "⚡ 10+ resets per second\n🎮 Press R to toggle\n♾️ Infinite until disabled"
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
local function toggleMultiReset()
    MultiResetEnabled = not MultiResetEnabled
    
    if MultiResetEnabled then
        statusLabel.Text = "Status: ULTRA FAST RESET!"
        statusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        print("⚡⚡⚡ ULTRA FAST MULTI-RESET ACTIVATED!")
        print("🎮 Press R again to stop")
    else
        statusLabel.Text = "Status: DISABLED (Press R)"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        print("🛑 Ultra fast reset stopped")
        print("📊 Total resets: " .. resetCount)
    end
end

-- Обработка нажатия клавиши R
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        toggleMultiReset()
    end
end)

-- СИСТЕМА СУПЕР-БЫСТРОГО МНОГОКРАТНОГО РЕСЕТА
local resetActive = false

local function ultraFastMultiReset()
    if not MultiResetEnabled or resetActive then return end
    
    resetActive = true
    local cycleCount = 0
    
    print("🚀 STARTING ULTRA FAST MULTI-RESET...")
    
    while MultiResetEnabled do
        cycleCount = cycleCount + 1
        
        -- ЦИКЛ ИЗ 10 МГНОВЕННЫХ РЕСЕТОВ ПОДРЯД
        for i = 1, 10 do
            -- Ресет №1
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
            end
            LocalPlayer:LoadCharacter()
            resetCount = resetCount + 1
            
            -- Мгновенный ресет №2
            wait(0.0001)
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
            end
            LocalPlayer:LoadCharacter()
            resetCount = resetCount + 1
            
            -- Мгновенный ресет №3
            wait(0.0001)
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
            end
            LocalPlayer:LoadCharacter()
            resetCount = resetCount + 1
            
            -- Мгновенный ресет №4
            wait(0.0001)
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
            end
            LocalPlayer:LoadCharacter()
            resetCount = resetCount + 1
            
            -- Мгновенный ресет №5
            wait(0.0001)
            if LocalPlayer.Character then
                LocalPlayer.Character:BreakJoints()
            end
            LocalPlayer:LoadCharacter()
            resetCount = resetCount + 1
        end
        
        -- Выводим статистику каждые 5 циклов
        if cycleCount % 5 == 0 then
            print("⚡ ULTRA RESET CYCLE #" .. cycleCount .. " - Total: " .. resetCount .. " resets")
            print("🚀 Speed: 50+ resets per cycle!")
        end
        
        -- Минимальная пауза между циклами
        wait(0.01)
    end
    
    resetActive = false
    print("🛑 ULTRA FAST MULTI-RESET STOPPED")
end

-- ДОПОЛНИТЕЛЬНЫЙ СУПЕР-БЫСТРЫЙ ЦИКЛ
local ultraResetActive = false

local function additionalUltraReset()
    if not MultiResetEnabled or ultraResetActive then return end
    
    ultraResetActive = true
    
    while MultiResetEnabled do
        -- Дополнительные мгновенные ресеты
        for i = 1, 5 do
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid.Health = 0
                    resetCount = resetCount + 1
                else
                    LocalPlayer.Character:BreakJoints()
                    resetCount = resetCount + 1
                end
            end
            wait(0.0001)
        end
        
        wait(0.02)
    end
    
    ultraResetActive = false
end

-- Запускаем системы
spawn(function()
    while true do
        if MultiResetEnabled and not resetActive then
            ultraFastMultiReset()
        end
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if MultiResetEnabled and not ultraResetActive then
            additionalUltraReset()
        end
        wait(0.1)
    end
end)

print("⚡⚡⚡ ULTRA FAST MULTI-RESET SCRIPT LOADED!")
print("🎮 Press R to start/stop ultra fast reset")
print("🚀 50+ resets per second!")
print("♾️ Will reset infinitely until you press R again!")
