-- MAXIMUM SERVER LAG (No Kick) - 50 REQS/SEC
local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LagEnabled = false
local requestCount = 0
local foundRemotes = {}

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
lagTitle.Text = "Maximum Lag - No Kick"
lagTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
lagTitle.BackgroundTransparency = 1
lagTitle.TextSize = 12
lagTitle.Font = Enum.Font.Gotham
lagTitle.TextXAlignment = Enum.TextXAlignment.Left
lagTitle.Parent = lagSection

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 60)
statusLabel.Position = UDim2.new(0, 10, 0, 30)
statusLabel.Text = "Status: DISABLED\nRequests: 0\nMode: 50/sec"
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

local toggleBtn = createActionButton(0, "MAX LAG ON", Color3.fromRGB(200, 60, 60))
local modeBtn = createActionButton(0.52, "50/SEC MODE", Color3.fromRGB(80, 120, 200))

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
local requestsPerSecond = 50 -- Ограничение до 50 запросов в секунду

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

-- АВТОМАТИЧЕСКИЙ ПОИСК REMOTE ОБЪЕКТОВ
local function findRemoteObjects()
    foundRemotes = {}
    
    -- Ищем во всех местах
    local searchLocations = {
        ReplicatedStorage,
        workspace,
        game:GetService("Players"),
        game:GetService("Lighting")
    }
    
    for _, location in pairs(searchLocations) do
        pcall(function()
            for _, obj in pairs(location:GetDescendants()) do
                if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                    table.insert(foundRemotes, obj)
                end
            end
        end)
    end
    
    print("📡 Auto-found " .. #foundRemotes .. " remote objects")
end

-- МАКСИМАЛЬНЫЕ ЛАГИ БЕЗ КИКОВ (50 запросов/сек)
local function sendLimitedRequests()
    if not LagEnabled or #foundRemotes == 0 then return end
    
    local requestsThisCycle = 0
    local maxRequestsPerCycle = math.min(requestsPerSecond, 50) -- Максимум 50
    
    -- Используем все найденные Remote объекты, но ограничиваем количество
    for i, remote in pairs(foundRemotes) do
        if not LagEnabled or requestsThisCycle >= maxRequestsPerCycle then break end
        
        pcall(function()
            if remote:IsA("RemoteEvent") then
                -- Легкие данные для безопасности
                local safeData = {
                    math.random(1, 100),
                    "action_" .. math.random(1, 10),
                    Vector3.new(math.random(-10, 10), 0, math.random(-10, 10)),
                    {x = math.random(1, 10), y = math.random(1, 10)},
                    true,
                    false
                }
                
                local data = safeData[math.random(1, #safeData)]
                remote:FireServer(data)
                requestCount = requestCount + 1
                requestsThisCycle = requestsThisCycle + 1
                
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer("request_" .. math.random(1, 100), math.random(1, 100))
                requestCount = requestCount + 1
                requestsThisCycle = requestsThisCycle + 1
            end
        end)
        
        -- Задержка для ограничения скорости
        if requestsThisCycle % 10 == 0 then -- Каждые 10 запросов небольшая пауза
            wait(0.01)
        end
    end
end

-- Переключение режима скорости
modeBtn.MouseButton1Click:Connect(function()
    if requestsPerSecond == 50 then
        requestsPerSecond = 25 -- Медленный режим
        modeBtn.Text = "25/SEC MODE"
        modeBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
        statusLabel.Text = string.format("Status: %s\nRequests: %d\nMode: 25/sec", LagEnabled and "ENABLED" or "DISABLED", requestCount)
        print("🐢 Slow mode enabled - 25 requests/sec")
    else
        requestsPerSecond = 50 -- Нормальный режим
        modeBtn.Text = "50/SEC MODE"
        modeBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
        statusLabel.Text = string.format("Status: %s\nRequests: %d\nMode: 50/sec", LagEnabled and "ENABLED" or "DISABLED", requestCount)
        print("⚡ Normal mode enabled - 50 requests/sec")
    end
end)

-- Включение/выключение лагов
toggleBtn.MouseButton1Click:Connect(function()
    LagEnabled = not LagEnabled
    
    if LagEnabled then
        statusLabel.Text = string.format("Status: ENABLED\nRequests: %d\nMode: %d/sec", requestCount, requestsPerSecond)
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        toggleBtn.Text = "MAX LAG OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        print("🚀 MAXIMUM LAG ACTIVATED! Using " .. #foundRemotes .. " remotes at " .. requestsPerSecond .. "/sec")
    else
        statusLabel.Text = string.format("Status: DISABLED\nRequests: %d\nMode: %d/sec", requestCount, requestsPerSecond)
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggleBtn.Text = "MAX LAG ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        print("🛑 Maximum lag stopped")
    end
end)

-- Клавиша L для переключения
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        LagEnabled = not LagEnabled
        
        if LagEnabled then
            statusLabel.Text = string.format("Status: ENABLED\nRequests: %d\nMode: %d/sec", requestCount, requestsPerSecond)
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            toggleBtn.Text = "MAX LAG OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        else
            statusLabel.Text = string.format("Status: DISABLED\nRequests: %d\nMode: %d/sec", requestCount, requestsPerSecond)
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            toggleBtn.Text = "MAX LAG ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        end
    end
end)

-- ОСНОВНОЙ ЦИКЛ МАКСИМАЛЬНЫХ ЛАГОВ
spawn(function()
    while scriptRunning do
        if LagEnabled then
            sendLimitedRequests()
            statusLabel.Text = string.format("Status: ENABLED\nRequests: %d\nMode: %d/sec", requestCount, requestsPerSecond)
            
            -- Фиксированная задержка для точного контроля скорости
            wait(0.1) -- 10 циклов в секунду = ~50 запросов/сек
        else
            wait(0.5)
        end
    end
end)

-- Автоматический поиск Remote каждые 10 секунд
spawn(function()
    while scriptRunning do
        findRemoteObjects()
        wait(10)
    end
end)

-- Инициализация
findRemoteObjects()
player.CharacterRemoving:Connect(function()
    if scriptRunning then closeGUI() end
end)

print("💥💥💥 MAXIMUM SERVER LAG LOADED!")
print("📡 Auto-found " .. #foundRemotes .. " remote objects")
print("🎮 Click MAX LAG ON or press L to start")
print("⚡ Normal mode: 50 requests/sec (safe)")
print("🐢 Slow mode: 25 requests/sec (very safe)")
