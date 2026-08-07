local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui") or playerGui

-- ==========================================
-- ========== 1. FIX LAG LIGHTING ===========
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
-- ========== 2. LOGIC CHỨC NĂNG GỐC ============
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
        pcall(function()
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
        end)
        task.wait(2)
    end
end)

task.spawn(function()
    while true do
        local color = getRainbowColor()
        for _, highlight in ipairs(chamsHighlights) do
            if highlight then highlight.FillColor = color end
        end
        task.wait(0.1)
    end
end)

-- ESP ITEM
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
    if espLoop then espLoop:Disconnect() espLoop = nil end
    if on then
        updateItemESP()
        espLoop = RunService.RenderStepped:Connect(function()
            staticLoop = staticLoop or 0
            staticLoop = staticLoop + 1
            if staticLoop % 120 == 0 then updateItemESP() end
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
    if speedLoop then speedLoop:Disconnect() speedLoop = nil end
    if on then
        speedLoop = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum and hum.WalkSpeed ~= 32 then hum.WalkSpeed = 32 end
            end
        end)
    else
        local char = player.Character
        if char then
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = normalSpeed end
        end
    end
end

-- NOCLIP
local noclipEnabled = false
local noclipLoop = nil
local safeY = nil

local function setNoclipMode(on)
    noclipEnabled = on
    if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end
    if on then
        noclipLoop = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
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
                if v:IsA("BasePart") then v.CanCollide = true end
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
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local distance = (hrp.Position - descendant.Parent.Position).Magnitude
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
end

local function setAuraMode(on)
    auraEnabled = on
    if auraLoop then auraLoop:Disconnect() auraLoop = nil end
    if on then
        auraLoop = RunService.Heartbeat:Connect(function() triggerNearbyPromptsOnce() end)
    end
end

-- ==============================================
-- ========== 3. GIAO DIỆN CHUẨN XERO HUB =======
-- ==============================================

if CoreGui:FindFirstChild("XeroHubUI") then
    CoreGui.XeroHubUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XeroHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Nút Cầu Mở/Tắt Menu Dành Cho Mobile (Không bao giờ bị lỗi)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0, 15, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
ToggleButton.Image = "rbxassetid://10723415903"
ToggleButton.Parent = ScreenGui

local btnCorner = Instance.new("UICorner", ToggleButton)
btnCorner.CornerRadius = UDim.new(1, 0)

local btnStroke = Instance.new("UIStroke", ToggleButton)
btnStroke.Color = Color3.fromRGB(0, 170, 255)
btnStroke.Thickness = 2

-- Kéo thả nút mở menu
local draggingBtn, dragInputBtn, mousePosBtn, framePosBtn
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        mousePosBtn = input.Position
        framePosBtn = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingBtn = false end
        end)
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputBtn = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        local delta = input.Position - mousePosBtn
        ToggleButton.Position = UDim2.new(framePosBtn.X.Scale, framePosBtn.X.Offset + delta.X, framePosBtn.Y.Scale, framePosBtn.Y.Offset + delta.Y)
    end
end)

-- Main Frame (Khung Chính)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 490, 0, 310)
MainFrame.Position = UDim2.new(0.5, -245, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 17, 21)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner", MainFrame)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Color3.fromRGB(35, 38, 48)
mainStroke.Thickness = 1

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- TopBar (Thanh Tiêu Đề)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
TopBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TopBar)
TitleText.Position = UDim2.new(0, 14, 0, 0)
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Text = "Renren Hub | Blox Fruits"
TitleText.TextColor3 = Color3.fromRGB(200, 205, 215)
TitleText.Font = Enum.Font.GothamMedium
TitleText.TextSize = 12
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Nút cửa sổ (Minimize, Maximize, Close chuẩn ảnh)
local WindowControls = Instance.new("Frame", TopBar)
WindowControls.Position = UDim2.new(1, -90, 0, 0)
WindowControls.Size = UDim2.new(0, 85, 1, 0)
WindowControls.BackgroundTransparency = 1

local function createWinBtn(text, pos, callback)
    local btn = Instance.new("TextButton", WindowControls)
    btn.Position = pos
    btn.Size = UDim2.new(0, 24, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(160, 165, 175)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createWinBtn("—", UDim2.new(0, 0, 0, 0), function() MainFrame.Visible = false end)
createWinBtn("☐", UDim2.new(0, 28, 0, 0), function() end)
createWinBtn("✕", UDim2.new(0, 56, 0, 0), function() MainFrame.Visible = false end)

-- Kéo thả Main Frame trên điện thoại
local draggingMain, dragInputMain, mousePosMain, framePosMain
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        mousePosMain = input.Position
        framePosMain = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingMain = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMain = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInputMain and draggingMain then
        local delta = input.Position - mousePosMain
        MainFrame.Position = UDim2.new(framePosMain.X.Scale, framePosMain.X.Offset + delta.X, framePosMain.Y.Scale, framePosMain.Y.Offset + delta.Y)
    end
end)

-- Sidebar (Thanh Menu Bên Trái)
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Position = UDim2.new(0, 10, 0, 44)
Sidebar.Size = UDim2.new(0, 135, 1, -50)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 0

local sideLayout = Instance.new("UIListLayout", Sidebar)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 4)

-- Content Area (Vùng Nội Dung Bên Phải)
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Position = UDim2.new(0, 152, 0, 44)
ContentArea.Size = UDim2.new(1, -162, 1, -50)
ContentArea.BackgroundTransparency = 1

local pages = {}
local sideBtns = {}

local function createTab(name, icon, isDefault)
    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(50, 55, 65)
    page.Visible = isDefault or false

    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)

    -- Button Sidebar
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = isDefault and Color3.fromRGB(28, 30, 38) or Color3.fromRGB(20, 22, 28)
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 145, 155)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    -- Thanh Indicator màu xanh nhạt bên trái nút tab
    local activeIndicator = Instance.new("Frame", btn)
    activeIndicator.Position = UDim2.new(0, 0, 0.15, 0)
    activeIndicator.Size = UDim2.new(0, 3, 0.7, 0)
    activeIndicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    activeIndicator.Visible = isDefault or false

    local indCorner = Instance.new("UICorner", activeIndicator)
    indCorner.CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(sideBtns) do
            b.Btn.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
            b.Btn.TextColor3 = Color3.fromRGB(140, 145, 155)
            b.Ind.Visible = false
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeIndicator.Visible = true
    end)

    table.insert(pages, page)
    table.insert(sideBtns, {Btn = btn, Ind = activeIndicator})
    return page
end

-- Tạo Các Tab Tương Tự Ảnh
local tabMain = createTab("Auto Farm", "♿", true)
local tabItem = createTab("Utilidades", "⚔", false)
local tabInfo = createTab("Info Hub", "ℹ", false)

-- Tiêu Đề Mục Trong Tab
local function createHeader(parent, text)
    local header = Instance.new("TextLabel", parent)
    header.Size = UDim2.new(1, 0, 0, 28)
    header.BackgroundTransparency = 1
    header.Text = text
    header.TextColor3 = Color3.fromRGB(240, 245, 255)
    header.Font = Enum.Font.GothamBold
    header.TextSize = 18
    header.TextXAlignment = Enum.TextXAlignment.Left
end

-- Thẻ Card Nút Gạt Switch 1:1 Như Trong Ảnh
local function createToggleCard(parent, titleText, defaultState, callback)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = Color3.fromRGB(24, 26, 33)

    local cardCorner = Instance.new("UICorner", card)
    cardCorner.CornerRadius = UDim.new(0, 7)

    local cardStroke = Instance.new("UIStroke", card)
    cardStroke.Color = Color3.fromRGB(35, 38, 48)
    cardStroke.Thickness = 1

    local lbl = Instance.new("TextLabel", card)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Text = titleText
    lbl.TextColor3 = Color3.fromRGB(200, 205, 215)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Nút Switch
    local switch = Instance.new("TextButton", card)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.Size = UDim2.new(0, 36, 0, 20)
    switch.AutoButtonColor = false
    switch.Text = ""
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(42, 45, 56)

    local swCorner = Instance.new("UICorner", switch)
    swCorner.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local state = defaultState
    switch.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(42, 45, 56)
        knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        callback(state)
    end)
end

-- ==============================================
-- ========== GẮN NỘI DUNG VÀO CÁC TAB ==========
-- ==============================================

-- Tab 1: Auto Farm / Chức năng chính
createHeader(tabMain, "Chức Năng Tối Ưu")

createToggleCard(tabMain, "ESP Item (Nhìn Xuyên Tường)", espEnabled, function(val)
    setESPMode(val)
end)

createToggleCard(tabMain, "Aura Auto Prompt (Tự Mở/Nhặt)", auraEnabled, function(val)
    setAuraMode(val)
end)

-- Tab 2: Utilidades / Tốc độ & Noclip
createHeader(tabItem, "Di Chuyển & Vật Lý")

createToggleCard(tabItem, "Tăng Tốc Độ (Speed 32)", speedEnabled, function(val)
    setSpeedMode(val)
end)

createToggleCard(tabItem, "Đi Xuyên Tường (Noclip Anti-Fall)", noclipEnabled, function(val)
    setNoclipMode(val)
end)

-- Tab 3: Info Hub
createHeader(tabInfo, "Thông Tin Script")
local infoCard = Instance.new("Frame", tabInfo)
infoCard.Size = UDim2.new(1, -6, 0, 120)
infoCard.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
local icCorner = Instance.new("UICorner", infoCard)
icCorner.CornerRadius = UDim.new(0, 7)

local infoLbl = Instance.new("TextLabel", infoCard)
infoLbl.Position = UDim2.new(0, 12, 0, 10)
infoLbl.Size = UDim2.new(1, -24, 1, -20)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3 = Color3.fromRGB(170, 175, 185)
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 11
infoLbl.TextXAlignment = Enum.TextXAlignment.Left
infoLbl.TextYAlignment = Enum.TextYAlignment.Top
infoLbl.TextWrapped = true
infoLbl.Text = [[• ESP Chams Rainbow: Tự động kích hoạt.
• Giao diện: Thiết kế chuẩn 1:1 Xero Hub dành riêng cho Mobile.
• Ẩn/Hiện: Bấm nút biểu tượng Ninja nhỏ trên màn hình để bật/tắt menu mượt mà 100%.]]
