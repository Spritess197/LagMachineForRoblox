-- MINIMAL LAG SCRIPT
local UserInputService = game:GetService("UserInputService")

local enabled = false
local count = 0

-- Просто текст на экране
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Position = UDim2.new(0, 400, 0, 50)
textLabel.Text = "LAG: OFF (Press L)"
textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.BackgroundTransparency = 0.5
textLabel.TextSize = 14
textLabel.Font = Enum.Font.GothamBold
textLabel.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Включение/выключение по L
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.L then
        enabled = not enabled
        
        if enabled then
            textLabel.Text = "LAG: ON (" .. count .. ")"
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            textLabel.Text = "LAG: OFF (Press L)"
            textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- Цикл лагов
while true do
    if enabled then
        count = count + 1
        textLabel.Text = "LAG: ON (" .. count .. ")"
        
        -- Создаем нагрузку
        for i = 1, 1000 do
            local x = math.random(1, 1000000)
            local y = math.random(1, 1000000)
            local _ = x * y
        end
        
        wait(0.1)
    else
        wait(1)
    end
end
