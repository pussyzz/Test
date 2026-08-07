local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
local RunService = game:GetService("RunService")

-- ========== LOGIC CHỨC NĂNG (GIỮ NGUYÊN) ==========
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
            staticLoop = (staticLoop or 0) + 1
            if staticLoop % 120 == 0 then updateItemESP() end
        end)
    else
        removeAllItemESP()
        staticLoop = 0
    end
end

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

-- ========== GIAO DIỆN MỚI (MODERN DARK UI LIKE RYSHUB) ==========
local function createModernGUI()
    local oldGui = playerGui:FindFirstChild("RenrenHubModernUI")
    if oldGui then oldGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "RenrenHubModernUI"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    -- Logo Nút Tròn Nhỏ Trôi Dạt
    local logoBtn = Instance.new("ImageButton", gui)
    logoBtn.Size = UDim2.new(0, 42, 0, 42)
    logoBtn.Position = UDim2.new(0, 15, 0.4, 0)
    logoBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    logoBtn.Active = true
    logoBtn.Draggable = true
    logoBtn.Image = "rbxassetid://10723415903" -- Icon ninja/hub
    
    local logoCorner = Instance.new("UICorner", logoBtn)
    logoCorner.CornerRadius = UDim.new(0, 12)
    
    local logoStroke = Instance.new("UIStroke", logoBtn)
    logoStroke.Color = Color3.fromRGB(0, 220, 130)
    logoStroke.Thickness = 1.5

    -- Bảng Khung Chính
    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.new(0, 480, 0, 310)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    logoBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- Thanh Tiêu Đề TopBar
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundTransparency = 1

    local titleText = Instance.new("TextLabel", topBar)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Size = UDim2.new(0, 120, 1, 0)
    titleText.Text = "Renren Hub"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left

    local versionBadge = Instance.new("TextLabel", topBar)
    versionBadge.Position = UDim2.new(0, 110, 0.22, 0)
    versionBadge.Size = UDim2.new(0, 55, 0, 22)
    versionBadge.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    versionBadge.Text = "v2.0.0"
    versionBadge.TextColor3 = Color3.fromRGB(0, 0, 0)
    versionBadge.Font = Enum.Font.GothamBold
    versionBadge.TextSize = 10
    
    local badgeCorner = Instance.new("UICorner", versionBadge)
    badgeCorner.CornerRadius = UDim.new(0, 10)

    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Position = UDim2.new(1, -35, 0, 8)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    -- Thanh Sidebar Bên Trái
    local sideBar = Instance.new("Frame", mainFrame)
    sideBar.Position = UDim2.new(0, 10, 0, 45)
    sideBar.Size = UDim2.new(0, 130, 1, -55)
    sideBar.BackgroundTransparency = 1

    -- Vùng Nội Dung Bên Phải
    local contentArea = Instance.new("Frame", mainFrame)
    contentArea.Position = UDim2.new(0, 145, 0, 45)
    contentArea.Size = UDim2.new(1, -155, 1, -55)
    contentArea.BackgroundTransparency = 1

    -- Hàm Tạo Trang Tab
    local tabs = {}
    local tabButtons = {}

    local function createTab(name, icon)
        local page = Instance.new("ScrollingFrame", contentArea)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
        page.Visible = false

        local pageLayout = Instance.new("UIListLayout", page)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 8)

        local tabBtn = Instance.new("TextButton", sideBar)
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        tabBtn.Text = "  " .. icon .. "  " .. name
        tabBtn.TextColor3 = Color3.fromRGB(140, 140, 150)
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 12
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local tabCorner = Instance.new("UICorner", tabBtn)
        tabCorner.CornerRadius = UDim.new(0, 8)

        tabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(tabs) do p.Visible = false end
            for _, b in pairs(tabButtons) do 
                b.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
                b.TextColor3 = Color3.fromRGB(140, 140, 150)
            end
            page.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(tabs, page)
        table.insert(tabButtons, tabBtn)
        return page, tabBtn
    end

    -- Tạo Các Tab Menu
    local pageUtil, btnUtil = createTab("Utilidades", "🛠")
    local pageVisual, btnVisual = createTab("Visuales", "👁")
    local pageInfo, btnInfo = createTab("Info Hub", "⚙")

    -- Mặc định chọn Tab đầu tiên
    pageUtil.Visible = true
    btnUtil.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btnUtil.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Hàm Tạo Thẻ Card Mới + Nút Gạt Toggle Switch
    local function createToggleCard(parentPage, title, desc, defaultState, callback)
        local card = Instance.new("Frame", parentPage)
        card.Size = UDim2.new(1, -8, 0, 58)
        card.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        
        local cardCorner = Instance.new("UICorner", card)
        cardCorner.CornerRadius = UDim.new(0, 8)

        local titleLbl = Instance.new("TextLabel", card)
        titleLbl.Position = UDim2.new(0, 12, 0, 10)
        titleLbl.Size = UDim2.new(0.7, 0, 0, 18)
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 12
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local descLbl = Instance.new("TextLabel", card)
        descLbl.Position = UDim2.new(0, 12, 0, 28)
        descLbl.Size = UDim2.new(0.7, 0, 0, 22)
        descLbl.Text = desc
        descLbl.TextColor3 = Color3.fromRGB(130, 130, 140)
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextSize = 10
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.TextWrapped = true

        -- Nút Toggle Switch
        local switchBg = Instance.new("TextButton", card)
        switchBg.Position = UDim2.new(1, -50, 0.5, -11)
        switchBg.Size = UDim2.new(0, 40, 0, 22)
        switchBg.AutoButtonColor = false
        switchBg.Text = ""
        switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(45, 45, 55)

        local switchCorner = Instance.new("UICorner", switchBg)
        switchCorner.CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame", switchBg)
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = defaultState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local knobCorner = Instance.new("UICorner", knob)
        knobCorner.CornerRadius = UDim.new(1, 0)

        local state = defaultState
        switchBg.MouseButton1Click:Connect(function()
            state = not state
            switchBg.BackgroundColor3 = state and Color3.fromRGB(34, 197, 94) or Color3.fromRGB(45, 45, 55)
            knob.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            callback(state)
        end)
    end

    -- THÊM CÁC CHỨC NĂNG VÀO TRANG

    -- 1. Tab Utilidades
    createToggleCard(pageUtil, "Speed Hack", "Tăng tốc độ di chuyển nhân vật lên 32.", speedEnabled, function(val)
        setSpeedMode(val)
    end)

    createToggleCard(pageUtil, "NoClip", "Đi xuyên qua tất cả các bức tường trên map.", noclipEnabled, function(val)
        setNoclipMode(val)
    end)

    createToggleCard(pageUtil, "Aura Auto-Prompt", "Tự động nhặt/mở item xung quanh vị trí đứng.", auraEnabled, function(val)
        setAuraMode(val)
    end)

    -- 2. Tab Visuales
    createToggleCard(pageVisual, "Item ESP", "Định vị hiển thị vị trí các vật phẩm quan trọng.", espEnabled, function(val)
        setESPMode(val)
    end)

    -- 3. Tab Info
    local infoCard = Instance.new("Frame", pageInfo)
    infoCard.Size = UDim2.new(1, -8, 0, 140)
    infoCard.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    local infoCorner = Instance.new("UICorner", infoCard)
    infoCorner.CornerRadius = UDim.new(0, 8)

    local infoLbl = Instance.new("TextLabel", infoCard)
    infoLbl.Position = UDim2.new(0, 12, 0, 10)
    infoLbl.Size = UDim2.new(1, -24, 1, -20)
    infoLbl.BackgroundTransparency = 1
    infoLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 11
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.TextYAlignment = Enum.TextYAlignment.Top
    infoLbl.TextWrapped = true
    infoLbl.Text = [[
✨ Renren Hub Version 2.0
• ESP Chams Rainbow Quái/Enemy: Luôn bật tự động
• ESP Item: Soi Box, Safe, Key, Doll Head, Rope, Tv,...
• Aura: Tự động Search/Pick Up/Open item sát bên
• Anti-Fall Noclip: Đi xuyên tường + chống rơi khỏi map

Cảm ơn bạn đã trải nghiệm!]]
end

pcall(createModernGUI)
