local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
local RunService = game:GetService("RunService")

-- ========== CHAMS PETA & ENEMY ==========
local function getRainbowColor()
    local t = tick()
    local r = math.abs(math.sin(t)) * 255
    local g = math.abs(math.sin(t + 2)) * 255
    local b = math.abs(math.sin(t + 4)) * 255
    return Color3.fromRGB(r, g, b)
end

local function addChamsRGB(model)
    if not model or not model:IsA("Model") then return end
    if not model:FindFirstChild("PetaPetaChams") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PetaPetaChams"
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.25
        highlight.OutlineTransparency = 0
        highlight.Parent = model
    end
end

local chamsHighlights = {}

task.spawn(function()
    while true do
        chamsHighlights = {}
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Model") and (
                string.find(string.lower(item.Name), "peta") -- semua peta, termasuk petapeta_03
                or string.lower(item.Name) == "enemymodel"
                or string.lower(item.Name) == "enemymodels"
            ) then
                addChamsRGB(item)
                local highlight = item:FindFirstChild("PetaPetaChams")
                if highlight then table.insert(chamsHighlights, highlight) end
            end
        end
        task.wait(2)
    end
end)

task.spawn(function()
    while true do
        local color = getRainbowColor()
        for _, highlight in ipairs(chamsHighlights) do
            highlight.FillColor = color
        end
        task.wait(0.1)
    end
end)

-- ========== ESP ITEM LAIN (OPSIONAL/GUI) ==========
local function addESPText(part, labelText)
    if not part or not part:IsA("BasePart") then return end
    if not part:FindFirstChild("ESPText") then
        local bill = Instance.new("BillboardGui")
        bill.Name = "ESPText"
        bill.Size = UDim2.new(0, 100, 0, 40)
        bill.StudsOffset = Vector3.new(0, 2, 0)
        bill.Adornee = part
        bill.AlwaysOnTop = true
        bill.Parent = part

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeTransparency = 0.5
        lbl.TextScaled = true
        lbl.Font = Enum.Font.SourceSansBold
        lbl.Parent = bill
    end
end

local function removeAllItemESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:FindFirstChild("ESPText") then
            obj.ESPText:Destroy()
        end
        if obj:FindFirstChild("ESPBox") then
            obj.ESPBox:Destroy()
        end
    end
end

local espEnabled = false
local espLoop = nil
local staticLoop = 0
local function updateItemESP()
    pcall(function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "BoxBottom" then
                    addESPText(part, "Box")
                    part.ESPText.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif part.Name == "Meshes/safe_Safe" then
                    addESPText(part, "Safe")
                    part.ESPText.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                elseif part.Name == "DollHead" then
                    addESPText(part, "Doll")
                    part.ESPText.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end

        local keyMeshId = "rbxassetid://14621552245"
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("MeshPart") and obj.MeshId == keyMeshId then
                if not obj:FindFirstChild("ESPBox") then
                    addESPText(obj, "Key")
                    obj.ESPText.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                    local box = Instance.new("BoxHandleAdornment", obj)
                    box.Name = "ESPBox"
                    box.Size = obj.Size
                    box.Adornee = obj
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Transparency = 0.7
                    box.Color3 = Color3.fromRGB(255, 255, 0)
                end
            end
        end

        local paperMeshId = "rbxassetid://14725689307"
        local newItems = {
            {MeshId = "rbxassetid://87090876258729", Name = "Doll Head", Color = Color3.fromRGB(200, 200, 200)},
            {MeshId = "rbxassetid://81684921461563", Name = "Rope", Color = Color3.fromRGB(139, 69, 19)},
            {MeshId = "rbxassetid://95226199656060", Name = "Dish", Color = Color3.fromRGB(192, 192, 192)},
            {MeshId = "rbxassetid://105719601831733", Name = "Lighter", Color = Color3.fromRGB(255, 165, 0)},
            {MeshId = "rbxassetid://126055581647891", Name = "Tv", Color = Color3.fromRGB(200, 200, 200)},
            {MeshId = "rbxassetid://128722703886289", Name = "Tv", Color = Color3.fromRGB(200, 200, 200)},
        }

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("MeshPart") then
                if obj.MeshId == paperMeshId then
                    addESPText(obj, "Code Paper")
                    obj.ESPText.TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    for _, item in ipairs(newItems) do
                        if obj.MeshId == item.MeshId then
                            addESPText(obj, item.Name)
                            obj.ESPText.TextLabel.TextColor3 = item.Color
                        end
                    end
                end
            end
        end
    end)
end

local function setESPMode(on)
    espEnabled = on
    if espLoop then
        espLoop:Disconnect()
        espLoop = nil
    end
    if on then
        updateItemESP()
        espLoop = RunService.RenderStepped:Connect(function()
            staticLoop = staticLoop or 0
            staticLoop = staticLoop + 1
            if staticLoop % 120 == 0 then
                updateItemESP()
            end
        end)
    else
        removeAllItemESP()
        staticLoop = 0
    end
end

-- ========== SPEED ==========
local speedEnabled = false
local speedLoop = nil
local normalSpeed = 16

local function setSpeedMode(on)
    speedEnabled = on
    if speedLoop then
        speedLoop:Disconnect()
        speedLoop = nil
    end
    if on then
        speedLoop = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum and hum.WalkSpeed ~= 32 then
                    hum.WalkSpeed = 32
                end
            end
        end)
    else
        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = normalSpeed
            end
        end
    end
end

-- ========== NOCLIP ==========
local noclipEnabled = false
local noclipLoop = nil
local safeY = nil

local function setNoclipMode(on)
    noclipEnabled = on
    if noclipLoop then
        noclipLoop:Disconnect()
        noclipLoop = nil
    end
    if on then
        noclipLoop = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                    if hrp.Position.Y > 2 then
                        if (not safeY) or (hrp.Position.Y > safeY and hrp.Position.Y > 15) then
                            safeY = hrp.Position.Y
                        end
                    end
                    if hrp.Position.Y < -10 then
                        local newY = (safeY and safeY > 10) and safeY or 25
                        hrp.CFrame = CFrame.new(hrp.Position.X, newY, hrp.Position.Z)
                        if hum.Sit then hum.Sit = false end
                        hum.PlatformStand = false
                    end
                end
            end
        end)
    else
        local char = player.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

-- ========== AURA (AUTO PROMPT) ==========
local auraEnabled = false
local auraLoop = nil
local triggeredPrompts = {}

local function promptFilter(prompt)
    local text = string.lower(prompt.ActionText or "")
    return string.find(text, "search") or string.find(text, "pick up") or string.find(text, "open")
end

local function triggerNearbyPromptsOnce()
    local character = player.Character or player.CharacterAdded:Wait()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Enabled and descendant.Parent and promptFilter(descendant) then
            if descendant.Parent:IsA("BasePart") then
                local distance = (character:WaitForChild("HumanoidRootPart").Position - descendant.Parent.Position).Magnitude
                local uniqueId = descendant:GetDebugId()
                if distance <= descendant.MaxActivationDistance and not triggeredPrompts[uniqueId] then
                    pcall(function()
                        fireproximityprompt(descendant)
                        triggeredPrompts[uniqueId] = true
                    end)
                elseif distance > descendant.MaxActivationDistance and triggeredPrompts[uniqueId] then
                    triggeredPrompts[uniqueId] = nil
                end
            end
        end
    end
end

local function setAuraMode(on)
    auraEnabled = on
    if auraLoop then
        auraLoop:Disconnect()
        auraLoop = nil
    end
    if on then
        auraLoop = RunService.Heartbeat:Connect(function()
            triggerNearbyPromptsOnce()
        end)
    end
end

-- ========== GUI ==========
local function createGUI()
    local uniqueName = "ESPAndAuraGUI_" .. tostring(math.random(1000,9999)) .. "_" .. tostring(math.floor(tick()))
    local gui = Instance.new("ScreenGui")
    gui.Name = uniqueName
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    -- Bubble Button 🐾
    local bubbleBtn = Instance.new("TextButton", gui)
    bubbleBtn.Size = UDim2.new(0, 40, 0, 40)
    bubbleBtn.Position = UDim2.new(0, 10, 0.5, -20)
    bubbleBtn.Text = "🐾"
    bubbleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bubbleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    bubbleBtn.BorderSizePixel = 0
    bubbleBtn.ZIndex = 2
    bubbleBtn.Active = true
    bubbleBtn.Draggable = true

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 220, 0, 340)
    frame.Position = UDim2.new(0, 60, 0.5, -170)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Visible = true

    bubbleBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Renren Hub 💫"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true

    -- ESP Toggle Button (untuk item selain PetaPeta & Enemy)
    local espBtn = Instance.new("TextButton", frame)
    espBtn.Size = UDim2.new(1, -20, 0, 40)
    espBtn.Position = UDim2.new(0, 10, 0, 40)
    espBtn.Text = "ESP Item: OFF"
    espBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    espBtn.TextColor3 = Color3.new(0, 0, 0)
    espBtn.Font = Enum.Font.SourceSansBold
    espBtn.TextScaled = true

    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.Text = espEnabled and "ESP Item: ON" or "ESP Item: OFF"
        setESPMode(espEnabled)
    end)

    -- Aura Button (Proximity Prompt)
    local auraBtn = Instance.new("TextButton", frame)
    auraBtn.Size = UDim2.new(1, -20, 0, 40)
    auraBtn.Position = UDim2.new(0, 10, 0, 90)
    auraBtn.Text = "Aura: OFF"
    auraBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    auraBtn.TextColor3 = Color3.new(1, 1, 1)
    auraBtn.Font = Enum.Font.SourceSansBold
    auraBtn.TextScaled = true

    auraBtn.MouseButton1Click:Connect(function()
        auraEnabled = not auraEnabled
        auraBtn.Text = auraEnabled and "Aura: ON" or "Aura: OFF"
        setAuraMode(auraEnabled)
    end)

    -- Speed Toggle Button
    local speedBtn = Instance.new("TextButton", frame)
    speedBtn.Size = UDim2.new(1, -20, 0, 40)
    speedBtn.Position = UDim2.new(0, 10, 0, 140)
    speedBtn.Text = "Speed: OFF"
    speedBtn.BackgroundColor3 = Color3.fromRGB(100, 149, 237)
    speedBtn.TextColor3 = Color3.new(1, 1, 1)
    speedBtn.Font = Enum.Font.SourceSansBold
    speedBtn.TextScaled = true

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedBtn.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
        setSpeedMode(speedEnabled)
    end)

    -- Noclip Toggle Button
    local noclipBtn = Instance.new("TextButton", frame)
    noclipBtn.Size = UDim2.new(1, -20, 0, 40)
    noclipBtn.Position = UDim2.new(0, 10, 0, 190)
    noclipBtn.Text = "Noclip: OFF"
    noclipBtn.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
    noclipBtn.TextColor3 = Color3.new(1, 1, 1)
    noclipBtn.Font = Enum.Font.SourceSansBold
    noclipBtn.TextScaled = true

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        noclipBtn.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
        setNoclipMode(noclipEnabled)
    end)

    -- Info Button
    local infoBtn = Instance.new("TextButton", frame)
    infoBtn.Size = UDim2.new(1, -20, 0, 35)
    infoBtn.Position = UDim2.new(0, 10, 0, 250)
    infoBtn.Text = "Info"
    infoBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    infoBtn.TextColor3 = Color3.new(1, 1, 1)

    infoBtn.MouseButton1Click:Connect(function()
        local infoGui = Instance.new("TextLabel", gui)
        infoGui.Size = UDim2.new(0.6, 0, 0.22, 0)
        infoGui.Position = UDim2.new(0.2, 0, 0.4, 0)
        infoGui.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        infoGui.TextColor3 = Color3.new(1, 1, 1)
        infoGui.TextScaled = true
        infoGui.TextWrapped = true
        infoGui.Text = [[
ESP Chams Rainbow: PetaPeta, EnemyModel/EnemyModels (selalu aktif, TANPA text)
ESP Item: Box, Safe, Key, dll (bisa ON/OFF)
Aura: Search/Pick Up/Open otomatis (sekali per item)
Speed: Loop, 32 WalkSpeed, bisa ON/OFF
Noclip: Bisa ON/OFF, anti jatuh ke bawah map, tembus tembok
By: Renren Hub 💫
]]
        task.delay(5, function()
            infoGui:Destroy()
        end)
    end)
end

pcall(createGUI)