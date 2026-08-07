local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui") or playerGui

-- ==========================================
-- ========== VÀI DÒNG FIX LAG NHẸ ==========
-- ==========================================
pcall(function()
    settings().Rendering.QualityLevel = "Level01"
    game:GetService("Lighting").GlobalShadows = false
    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false
        end
    end
end)

-- ==============================================
-- ========== CHỨC NĂNG GỐC (GIỮ NGUYÊN) ==========
-- ==============================================

-- CHAMS PETA & ENEMY
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

-- ESP ITEM LAIN
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

-- SPEED
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

-- NOCLIP
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

-- AURA (AUTO PROMPT)
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

-- ==============================================
-- ========== GIAO DIỆN FLUENT MỚI ============
-- ==============================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Renren Hub",
    SubTitle = "Bản Tối Ưu Hóa",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 300),
    Acrylic = false, 
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Các Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Chức Năng Chính", Icon = "home" }),
    Info = Window:AddTab({ Title = "Thông Tin", Icon = "info" })
}

-- Gắn chức năng vào UI
Tabs.Main:AddToggle("ToggleESP", {Title = "ESP Item (Nhìn xuyên tường)", Default = false }):OnChanged(function(Value)
    setESPMode(Value)
end)

Tabs.Main:AddToggle("ToggleAura", {Title = "Aura (Tự động nhặt/mở)", Default = false }):OnChanged(function(Value)
    setAuraMode(Value)
end)

Tabs.Main:AddToggle("ToggleSpeed", {Title = "Chạy Nhanh (Speed 32)", Default = false }):OnChanged(function(Value)
    setSpeedMode(Value)
end)

Tabs.Main:AddToggle("ToggleNoclip", {Title = "Đi Xuyên Tường (Noclip)", Default = false }):OnChanged(function(Value)
    setNoclipMode(Value)
end)

Tabs.Info:AddParagraph({
    Title = "Thông tin Script",
    Content = "ESP Chams Rainbow: Luôn bật\nESP Item: Bật/Tắt\nAura: Tự động Search/Pick Up/Open\nSpeed & Noclip: Đã được fix\nBy: Renren Hub 💫"
})

Window:SelectTab(1)

-- ==============================================
-- ======= NÚT BẤM (ORB CẦU XANH) ĐỂ BẬT/TẮT ====
-- ==============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileToggleMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.Text = ""
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = ScreenGui

local UICorner = Instance.new("UICorner", ToggleBtn)
UICorner.CornerRadius = UDim.new(1, 0)

local UIStroke = Instance.new("UIStroke", ToggleBtn)
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 2

local UIGradient = Instance.new("UIGradient", ToggleBtn)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 50, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
}
UIGradient.Rotation = 45

-- Kéo thả mượt mà
local dragging = false
local dragInput, mousePos, framePos

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = ToggleBtn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        ToggleBtn.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Quét tìm menu Fluent trực tiếp mỗi lần bấm (Khắc phục triệt để lỗi mất nút sau vài lần tắt mở)
ToggleBtn.MouseButton1Click:Connect(function()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        -- Nhận diện giao diện của Fluent dựa trên cấu trúc các thành phần con bên trong
        if gui:IsA("ScreenGui") and gui ~= ScreenGui then
            local container = gui:FindFirstChild("Container") or gui:FindFirstChildWhichIsA("Frame", true)
            if container and (container.Name == "Container" or container.Size.X.Offset > 300) then
                gui.Enabled = not gui.Enabled
                break
            end
        end
    end
end)