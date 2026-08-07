--[[ 
  Key System with Countdown Timer GUI (1 day)
  - After correct key, show remaining time timer at top right
  - Timer updates every second
  - If time runs out, expire file deleted, user must input key again
  - Timer can be closed manually (just timer, not key)
  - Added: "Buy Permanent Key" button (copies shoppy link)
  - If user enters premium key, GUI says "PERMANENT KEY" (no timer)
  - GUI is English only, premium key is NOT shown anywhere on GUI
  - "Join Discord" button now directly copies the link (no extra GUI)
  - All positions fixed so buttons do not overlap
  - Local for Discord and success clipboard, can be changed freely
  - On script success, clipboard auto-copies success text/link
]]

local GKey = "FREE_1234567890ABCDEFGHIJKLMN"
local PERM_KEY = "PREMIUM_yu6d7gl5itxjilc"
local ScriptURL = "https://pastebin.com/raw/cbqRRDgz"
local KeyLink = "https://link-target.net/1314896/MM1Xm4pr7K2C"
local PermKeyLink = "https://shoppy.gg/product/rw4FHGS"
local TitleText = "Key System"
local InfoText = "Get your key from the button below!"
local DiscordText = "RENRENHUB KEY SYSTEM"
local MainFont = Enum.Font.FredokaOne
local DURATION = 24*60*60 -- 1 day in seconds
local SaveFile = "mykeyexpire.txt"
local DiscordJoinLink = "https://linkfly.to/jbroblox"
local SuccessClipboardText = "https://linkfly.to/jbroblox"

local function getTime() return os.time() end

local function isKeyActive()
    if not (readfile and writefile) then return false end
    if not pcall(readfile, SaveFile) then return false end
    local content = readfile(SaveFile)
    -- Permanent key uses "PERMANENT" word as expire
    if content == "PERMANENT" then
        return "permanent"
    end
    local expire = tonumber(content)
    if not expire then return false end
    return getTime() < expire, expire
end

local function saveExpire()
    if not (writefile) then return end
    local expire = getTime() + DURATION
    writefile(SaveFile, tostring(expire))
    return expire
end

local function savePermanent()
    if not (writefile) then return end
    writefile(SaveFile, "PERMANENT")
end

local function clearExpire()
    if not (delfile) then return end
    pcall(delfile, SaveFile)
end

-- Utility: Format seconds to hh:mm:ss
local function formatTime(sec)
    if sec < 0 then sec = 0 end
    local h = math.floor(sec/3600)
    local m = math.floor((sec%3600)/60)
    local s = sec % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- GUI Timer for Normal Key
local function showKeyTimer(expireTimestamp)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeyTimer"
    gui.Parent = player:FindFirstChildOfClass("PlayerGui")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(40, 50, 90)
    frame.Position = UDim2.new(1, -170, 0, 20)
    frame.Size = UDim2.new(0, 160, 0, 44)
    frame.AnchorPoint = Vector2.new(0,0)
    frame.BackgroundTransparency = 0.10
    frame.Active = true
    frame.Draggable = true

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0,12)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1,0,1,0)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.FredokaOne
    label.TextColor3 = Color3.fromRGB(210,255,180)
    label.TextStrokeTransparency = 0.7
    label.TextSize = 18
    label.TextWrapped = true
    label.Text = "Key Active\n00:00:00"

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = frame
    closeBtn.Size = UDim2.new(0,22,0,22)
    closeBtn.Position = UDim2.new(1,-26,0,4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220,80,80)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.FredokaOne
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.BackgroundTransparency = 0.2
    local cc = Instance.new("UICorner", closeBtn)
    cc.CornerRadius = UDim.new(0,7)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Timer update
    local heartbeat = game:GetService("RunService").Heartbeat
    local running = true
    coroutine.wrap(function()
        while running and gui.Parent do
            local sisa = expireTimestamp - getTime()
            if sisa >= 0 then
                label.TextColor3 = Color3.fromRGB(210,255,180)
                label.Text = "Key Active\n"..formatTime(sisa)
            else
                label.TextColor3 = Color3.fromRGB(255,100,100)
                label.Text = "Key Expired!\n00:00:00"
                clearExpire()
                running = false
            end
            heartbeat:Wait()
        end
    end)()
    gui.AncestryChanged:Connect(function()
        running = false
    end)
end

-- GUI Timer for Permanent Key (just says PERMANENT KEY)
local function showPermanentKey()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "PermanentKeyTimer"
    gui.Parent = player:FindFirstChildOfClass("PlayerGui")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(40, 50, 90)
    frame.Position = UDim2.new(1, -170, 0, 20)
    frame.Size = UDim2.new(0, 160, 0, 44)
    frame.AnchorPoint = Vector2.new(0,0)
    frame.BackgroundTransparency = 0.10
    frame.Active = true
    frame.Draggable = true

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0,12)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1,0,1,0)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.FredokaOne
    label.TextColor3 = Color3.fromRGB(255, 230, 110)
    label.TextStrokeTransparency = 0.7
    label.TextSize = 18
    label.TextWrapped = true
    label.Text = "PERMANENT KEY"

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = frame
    closeBtn.Size = UDim2.new(0,22,0,22)
    closeBtn.Position = UDim2.new(1,-26,0,4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220,80,80)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.FredokaOne
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.BackgroundTransparency = 0.2
    local cc = Instance.new("UICorner", closeBtn)
    cc.CornerRadius = UDim.new(0,7)

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

-- Check if key is already active
local aktif, expire = isKeyActive()
if aktif == "permanent" then
    showPermanentKey()
    setclipboard(SuccessClipboardText)
    loadstring(game:HttpGet(ScriptURL))()
    return
elseif aktif then
    showKeyTimer(expire)
    setclipboard(SuccessClipboardText)
    loadstring(game:HttpGet(ScriptURL))()
    return
end

-- GUI KEY SYSTEM (with Buy Permanent Key button, no premium key reveal)
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "CustomKeySystem"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
main.Position = UDim2.new(0.34, 0, 0.37, 0)
main.Size = UDim2.new(0, 340, 0, 250)
main.Active = true
main.Draggable = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 18)

local title = Instance.new("TextLabel")
title.Parent = main
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0,0,0,8)
title.Font = MainFont
title.Text = TitleText
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 26
title.TextStrokeTransparency = 0.6

local info = Instance.new("TextLabel")
info.Parent = main
info.BackgroundTransparency = 1
info.Size = UDim2.new(1, -24, 0, 25)
info.Position = UDim2.new(0,12,0,40)
info.Font = MainFont
info.Text = InfoText
info.TextColor3 = Color3.fromRGB(210,210,210)
info.TextSize = 16
info.TextStrokeTransparency = 0.7
info.TextWrapped = true

local discord = Instance.new("TextLabel")
discord.Parent = main
discord.BackgroundTransparency = 1
discord.Size = UDim2.new(1, -24, 0, 18)
discord.Position = UDim2.new(0,12,0,66)
discord.Font = MainFont
discord.Text = DiscordText
discord.TextColor3 = Color3.fromRGB(140,200,255)
discord.TextSize = 14
discord.TextStrokeTransparency = 0.7

local keyBox = Instance.new("TextBox")
keyBox.Parent = main
keyBox.Name = "KeyBox"
keyBox.PlaceholderText = "Enter your key here!"
keyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
keyBox.Position = UDim2.new(0.09, 0, 0.38, 0)
keyBox.Size = UDim2.new(0.82, 0, 0, 36)
keyBox.Font = MainFont
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.TextSize = 17
keyBox.Text = ""
keyBox.TextWrapped = true
keyBox.ClearTextOnFocus = false
local keyBoxCorner = Instance.new("UICorner", keyBox)
keyBoxCorner.CornerRadius = UDim.new(0, 14)

local submit = Instance.new("TextButton")
submit.Parent = main
submit.Text = "Submit"
submit.Font = MainFont
submit.TextColor3 = Color3.fromRGB(255,255,255)
submit.TextSize = 17
submit.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
submit.Position = UDim2.new(0.09, 0, 0.62, 0)
submit.Size = UDim2.new(0.39, -4, 0, 32)
local submitCorner = Instance.new("UICorner", submit)
submitCorner.CornerRadius = UDim.new(0, 14)

local getkey = Instance.new("TextButton")
getkey.Parent = main
getkey.Text = "Get Free Key"
getkey.Font = MainFont
getkey.TextColor3 = Color3.fromRGB(255,255,255)
getkey.TextSize = 17
getkey.BackgroundColor3 = Color3.fromRGB(65, 120, 220)
getkey.Position = UDim2.new(0.52, 4, 0.62, 0)
getkey.Size = UDim2.new(0.39, -4, 0, 32)
local getkeyCorner = Instance.new("UICorner", getkey)
getkeyCorner.CornerRadius = UDim.new(0, 14)

local joinDiscordBtn = Instance.new("TextButton")
joinDiscordBtn.Parent = main
joinDiscordBtn.Text = "Join Discord"
joinDiscordBtn.Font = MainFont
joinDiscordBtn.TextColor3 = Color3.fromRGB(255,255,255)
joinDiscordBtn.TextSize = 16
joinDiscordBtn.BackgroundColor3 = Color3.fromRGB(110,160,245)
joinDiscordBtn.Position = UDim2.new(0.09, 0, 0.78, 0)
joinDiscordBtn.Size = UDim2.new(0.39, -4, 0, 28)
local joinDiscordBtnCorner = Instance.new("UICorner", joinDiscordBtn)
joinDiscordBtnCorner.CornerRadius = UDim.new(0, 10)

local permBtn = Instance.new("TextButton")
permBtn.Parent = main
permBtn.Text = "Buy Permanent Key"
permBtn.Font = MainFont
permBtn.TextColor3 = Color3.fromRGB(255,255,255)
permBtn.TextSize = 16
permBtn.BackgroundColor3 = Color3.fromRGB(200,140,50)
permBtn.Position = UDim2.new(0.52, 4, 0.78, 0)
permBtn.Size = UDim2.new(0.39, -4, 0, 28)
local permBtnCorner = Instance.new("UICorner", permBtn)
permBtnCorner.CornerRadius = UDim.new(0, 12)

local feedback = Instance.new("TextLabel")
feedback.Parent = main
feedback.BackgroundTransparency = 1
feedback.Size = UDim2.new(1, 0, 0, 20)
feedback.Position = UDim2.new(0,0,1,-20)
feedback.Font = MainFont
feedback.Text = ""
feedback.TextColor3 = Color3.fromRGB(255,110,110)
feedback.TextSize = 14
feedback.TextStrokeTransparency = 0.75

-- Initial fade-in
main.BackgroundTransparency = 1
title.TextTransparency = 1
info.TextTransparency = 1
discord.TextTransparency = 1
keyBox.BackgroundTransparency = 1
submit.BackgroundTransparency = 1
getkey.BackgroundTransparency = 1
joinDiscordBtn.BackgroundTransparency = 1
permBtn.BackgroundTransparency = 1

local fadeInInfo = TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(main, fadeInInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(title, fadeInInfo, {TextTransparency = 0}):Play()
TweenService:Create(info, fadeInInfo, {TextTransparency = 0}):Play()
TweenService:Create(discord, fadeInInfo, {TextTransparency = 0}):Play()
TweenService:Create(keyBox, fadeInInfo, {BackgroundTransparency = 0.12}):Play()
TweenService:Create(submit, fadeInInfo, {BackgroundTransparency = 0.08}):Play()
TweenService:Create(getkey, fadeInInfo, {BackgroundTransparency = 0.08}):Play()
TweenService:Create(joinDiscordBtn, fadeInInfo, {BackgroundTransparency = 0.10}):Play()
TweenService:Create(permBtn, fadeInInfo, {BackgroundTransparency = 0.09}):Play()

local function checkKey()
    feedback.Text = ""
    if keyBox.Text == GKey then
        feedback.Text = "✅ Correct key! Loading..."
        feedback.TextColor3 = Color3.fromRGB(80,220,80)
        TweenService:Create(keyBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60,130,90)}):Play()
        local expire = saveExpire()
        wait(0.7)
        TweenService:Create(main, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, fadeInInfo, {TextTransparency = 1}):Play()
        TweenService:Create(info, fadeInInfo, {TextTransparency = 1}):Play()
        TweenService:Create(discord, fadeInInfo, {TextTransparency = 1}):Play()
        TweenService:Create(keyBox, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(submit, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(getkey, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(joinDiscordBtn, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(permBtn, fadeInInfo, {BackgroundTransparency = 1}):Play()
        wait(1)
        gui:Destroy()
        setclipboard(SuccessClipboardText)
        showKeyTimer(expire)
        loadstring(game:HttpGet(ScriptURL))()
    elseif keyBox.Text == PERM_KEY then
        feedback.Text = "✅ Permanent key activated!"
        feedback.TextColor3 = Color3.fromRGB(255,220,80)
        TweenService:Create(keyBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(210,180,80)}):Play()
        savePermanent()
        wait(0.7)
        TweenService:Create(main, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, fadeInInfo, {TextTransparency = 1}):Play()
        TweenService:Create(info, fadeInInfo, {TextTransparency = 1}):Play()
        TweenService:Create(discord, fadeInInfo, {TextTransparency = 1}):Play()
        TweenService:Create(keyBox, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(submit, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(getkey, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(joinDiscordBtn, fadeInInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(permBtn, fadeInInfo, {BackgroundTransparency = 1}):Play()
        wait(1)
        gui:Destroy()
        setclipboard(SuccessClipboardText)
        showPermanentKey()
        loadstring(game:HttpGet(ScriptURL))()
    else
        feedback.Text = "❌ Wrong key!"
        feedback.TextColor3 = Color3.fromRGB(255,90,90)
        TweenService:Create(keyBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(130,60,60)}):Play()
        wait(0.5)
        TweenService:Create(keyBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60,60,70)}):Play()
    end
end

getkey.MouseButton1Click:Connect(function()
    setclipboard(KeyLink)
    feedback.Text = "🔗 Key link copied!"
    feedback.TextColor3 = Color3.fromRGB(90,190,255)
end)

permBtn.MouseButton1Click:Connect(function()
    setclipboard(PermKeyLink)
    feedback.Text = "🔗 Permanent Key link copied!"
    feedback.TextColor3 = Color3.fromRGB(255,200,90)
end)

joinDiscordBtn.MouseButton1Click:Connect(function()
    setclipboard(DiscordJoinLink)
    feedback.Text = "🔗 Discord invite copied!"
    feedback.TextColor3 = Color3.fromRGB(140,200,255)
end)

submit.MouseButton1Click:Connect(checkKey)

keyBox.FocusLost:Connect(function(enter)
    if enter then
        checkKey()
    end
end)