local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ==========================================
-- KHỞI TẠO GIAO DIỆN WINDUI (TỪ SCRIPT.LUA)
-- ==========================================
local Window = WindUI:CreateWindow({
    Folder = "RenrenHub",
    Title = "Renren Hub 💫",
    Icon = "sparkles",
    Author = "Renren Hub",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 350),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "Open Renren Hub",
    Icon = "pointer",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(200, 0, 255), Color3.fromRGB(0, 200, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "star" }),
    ESP = Window:Tab({ Title = "ESP & Visuals", Icon = "eye" }),
    Credits = Window:Tab({ Title = "Info & Credits", Icon = "award" })
}

-- ==========================================
-- LOGIC CHỨC NĂNG NGUYÊN BẢN CỦA KETTHUC.LUA
-- ==========================================

-- 1. CHAMS PETA & ENEMY (TỰ ĐỘNG CHẠY NGẦM RAINBOW)
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
                string.find(string.lower(item.Name), "peta")
                or string.lower(item.Name) == "enemymodel"
                or string.lower(item.Name) == "enemymodels"
                or string.lower(item.Name) == "enemymodel_stage6"
                or string.lower(item.Name) == "enemymodel_stage7"
                or string.lower(item.Name) == "enemymodel_stage8"
                or string.lower(item.Name) == "enemymodel_stage9"
                or string.lower(item.Name) == "enemymodel_stage10"
                or string.lower(item.Name) == "stage"
                or string.lower(item.Name) == "enemy"      
              
                
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

-- 2. ESP ITEM LAIN
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
            {MeshId = "rbxassetid://105719601831733", Name = "Light", Color = Color3.fromRGB(255, 165, 0)},
            {MeshId = "rbxassetid://126055581647891", Name = "TV", Color = Color3.fromRGB(200, 200, 200)},
            {MeshId = "rbxassetid://128722703886289", Name = "TV", Color = Color3.fromRGB(200, 200, 200)},
            {MeshId = "rbxassetid://70516035370579", Name = "Petapeta StageNew", Color = Color3.fromRGB(255, 50, 50)},
            {MeshId = "rbxassetid://78479442306609", Name = "👶 Kid / Box", Color = Color3.fromRGB(255, 215, 0)},
            {MeshId = "rbxassetid://95425765471937", Name = "Red Candle", Color = Color3.fromRGB(255, 70, 70)},
            {MeshId = "rbxassetid://113824635091846", Name = "Candle Stand", Color = Color3.fromRGB(255, 165, 0)},
            {MeshId = "rbxassetid://87563522345335", Name = "Bowl", Color = Color3.fromRGB(220, 220, 255)},
            {MeshId = "rbxassetid://95226199656060", Name = "Dish", Color = Color3.fromRGB(192, 192, 192)},
        }
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

-- 3. SPEED
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
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum and hum.WalkSpeed ~= 32 then
                    hum.WalkSpeed = 32
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = normalSpeed
            end
        end
    end
end

-- 4. NOCLIP
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
            local char = LocalPlayer.Character
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
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

-- 5. AURA (AUTO PROMPT)
local auraEnabled = false
local auraLoop = nil
local triggeredPrompts = {}

local function promptFilter(prompt)
    local text = string.lower(prompt.ActionText or "")
    return string.find(text, "search") or string.find(text, "pick up") or string.find(text, "open")
end

local function triggerNearbyPromptsOnce()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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

-- ==========================================
-- GẮN CÁC NÚT ĐIỀU KHIỂN VÀO WINDUI
-- ==========================================

-- --- TAB MAIN ---
Tabs.Main:Section({ Title = "Player & Auto Features" })

Tabs.Main:Toggle({
    Title = "Auto Proximity Prompt (Aura)",
    Default = false,
    Callback = function(state)
        setAuraMode(state)
    end
})

Tabs.Main:Toggle({
    Title = "Speed Hack (WalkSpeed 32)",
    Default = false,
    Callback = function(state)
        setSpeedMode(state)
    end
})

Tabs.Main:Toggle({
    Title = "Noclip (Anti-Fall Map)",
    Default = false,
    Callback = function(state)
        setNoclipMode(state)
    end
})

-- --- TAB ESP ---
Tabs.ESP:Section({ Title = "Visuals & ESP" })

Tabs.ESP:Toggle({
    Title = "ESP Item (Box, Safe, Key, Doll, etc.)",
    Default = false,
    Callback = function(state)
        setESPMode(state)
    end
})

Tabs.ESP:Paragraph({
    Title = "ESP Chams Rainbow (Auto Active)",
    Desc = "Chams Rainbow cho PetaPeta và EnemyModel/EnemyModels tự động hoạt động ngầm (không cần bật).",
})

-- --- TAB CREDITS & INFO ---
Tabs.Credits:Section({ Title = "Renren Hub Info" })

Tabs.Credits:Paragraph({
    Title = "Thông Tin Script",
    Desc = "ESP Chams Rainbow: PetaPeta, EnemyModel/EnemyModels (Tự động)\nESP Item: Box, Safe, Key, Doll, Rope... (ON/OFF)\nAura: Search / Pick Up / Open tự động\nSpeed: WalkSpeed 32 cố định\nNoclip: Tuyên xuyên tường, chống té vực\n\nBy: Renren Hub 💫",
})

Tabs.Credits:Button({
    Title = "Thông Báo Hub",
    Callback = function()
        WindUI:Notify({
            Title = "Renren Hub 💫",
            Content = "Đã tải giao diện WindUI thành công!",
            Duration = 5,
        })
    end
})
