local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local userinputservice = game:GetService("UserInputService")
local textservice = game:GetService("TextService")
local tweenservice = game:GetService("TweenService")
local runservice = game:GetService("RunService")
local coreguiservice = game:GetService("CoreGui")
local contentservice = game:GetService("ContentProvider")
local teleportservice = game:GetService("TeleportService")

local tweentable = {
    default = {
        TweenInfo.new(0.17, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
    }
}
local createtween = function(name, speed, style, direction, loop, reverse, delay)
    name = name
    speed = speed or 0.17
    style = style or Enum.EasingStyle.Sine
    direction = direction or Enum.EasingDirection.InOut
    loop = loop or 0
    reverse = reverse or false
    delay = delay or 0

    tweentable[name] = TweenInfo.new(speed, style, direction, loop, reverse, delay)
end

local drag = function(object, latency)
    object = object
    latency = latency or 0.06

    local toggled = nil
    local input = nil
    local start = nil
    local startpos = nil

    local function updateinput(inp)
        local delta = inp.Position - start
        local position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
        tweenservice:Create(object, TweenInfo.new(latency), {Position = position}):Play()
    end

    object.InputBegan:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseButton1) then
            toggled = true
            start = inp.Position
            startpos = object.Position
            inp.Changed:Connect(function()
                if (inp.UserInputState == Enum.UserInputState.End) then
                    toggled = false
                end
            end)
        end
    end)

    object.InputChanged:Connect(function(inp)
        if (inp.UserInputType == Enum.UserInputType.MouseMovement) then
            input = inp
        end
    end)

    userinputservice.InputChanged:Connect(function(inp)
        if (inp == input and toggled) then
            updateinput(inp)
        end
    end)
end

local library = {
    version = "2.0.2",
    title = title or "sigma " .. tostring(math.random(1,366)),
    fps = 0,
    rank = "private",
    togglemobile = true
}

coroutine.wrap(function()
    runservice.RenderStepped:Connect(function(v)
        library.fps = math.round(1/v)
    end)
end)()

function library:roundnumber(int, float)
    return tonumber(string.format("%." .. (int or 0) .. "f", float))
end

function library:getusername()
    return player.Name
end

function library:checkifloaded()
    if game:IsLoaded() then
        return true
    else
        return false
    end
end

function library:getuserid()
    return player.UserId
end

function library:getplaceid()
    return game.PlaceId
end

function library:getjobid()
    return game.JobId
end

function library:rejoin()
    teleportservice:TeleportToPlaceInstance(library:getplaceid(), library:getjobid(), library:getuserid())
end

function library:copy(input)
    if syn then
        syn.write_clipboard(input)
    end
end

function library:getday(type)
    if type == "word" then
        return os.date("%A")
    elseif type == "short" then
        return os.date("%a")
    elseif type == "month" then
        return os.date("%d")
    elseif type == "year" then
        return os.date("%j")
    end
end

function library:gettime(type)
    if type == "24h" then
        return os.date("%H")
    elseif type == "12h" then
        return os.date("%I")
    elseif type == "minute" then
        return os.date("%M")
    elseif type == "half" then
        return os.date("%p")
    elseif type == "second" then
        return os.date("%S")
    elseif type == "full" then
        return os.date("%X")
    elseif type == "ISO" then
        return os.date("%z")
    elseif type == "zone" then
        return os.date("%Z")
    end
end

function library:getmonth(type)
    if type == "word" then
        return os.date("%B")
    elseif type == "short" then
        return os.date("%b")
    elseif type == "digit" then
        return os.date("%m")
    end
end

function library:getweek(type)
    if type == "year_S" then
        return os.date("%U")
    elseif type == "day" then
        return os.date("%w")
    elseif type == "year_M" then
        return os.date("%W")
    end
end

function library:getyear(type)
    if type == "digits" then
        return os.date("%y")
    elseif type == "full" then
        return os.date("%Y")
    end
end

function library:unlockfps(new)
    if syn then
        setfpscap(new)
    end
end

function library:watermark(text)
    for i,v in pairs(coreguiservice:GetChildren()) do
        if v.Name == "watermark" then
            v:Destroy()
        end
    end

    text = text or "sigma"

    local watermark = Instance.new("ScreenGui")
    local watermarkpadding = Instance.new("UIPadding")
    local watermarklayout = Instance.new("UIListLayout")
    local edge = Instance.new("Frame")
    local edgecorner = Instance.new("UICorner")
    local background = Instance.new("Frame")
    local barfolder = Instance.new("Folder")
    local bar = Instance.new("Frame")
    local barcorner = Instance.new("UICorner")
    local barlayout = Instance.new("UIListLayout")
    local backgroundgradient = Instance.new("UIGradient")
    local backgroundcorner = Instance.new("UICorner")
    local watertext = Instance.new("TextLabel")
    local waterpadding = Instance.new("UIPadding")
    local backgroundlayout = Instance.new("UIListLayout")

    watermark.Name = "watermark"
    watermark.Parent = coreguiservice
    watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    watermarklayout.Name = "watermarkLayout"
    watermarklayout.Parent = watermark
    watermarklayout.FillDirection = Enum.FillDirection.Horizontal
    watermarklayout.SortOrder = Enum.SortOrder.LayoutOrder
    watermarklayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    watermarklayout.Padding = UDim.new(0, 4)

    watermarkpadding.Name = "watermarkPadding"
    watermarkpadding.Parent = watermark
    watermarkpadding.PaddingBottom = UDim.new(0, 6)
    watermarkpadding.PaddingLeft = UDim.new(0, 6)

    edge.Name = "edge"
    edge.Parent = watermark
    edge.AnchorPoint = Vector2.new(0.5, 0.5)
    edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    edge.Position = UDim2.new(0.5, 0, -0.03, 0)
    edge.Size = UDim2.new(0, 0, 0, 26)
    edge.BackgroundTransparency = 1

    edgecorner.CornerRadius = UDim.new(0, 2)
    edgecorner.Name = "edgeCorner"
    edgecorner.Parent = edge

    background.Name = "background"
    background.Parent = edge
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.BackgroundTransparency = 1
    background.ClipsDescendants = true
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(0, 0, 0, 24)

    barfolder.Name = "barFolder"
    barfolder.Parent = background

    bar.Name = "bar"
    bar.Parent = barfolder
    bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
    bar.BackgroundTransparency = 0
    bar.Size = UDim2.new(0, 0, 0, 1)

    barcorner.CornerRadius = UDim.new(0, 2)
    barcorner.Name = "barCorner"
    barcorner.Parent = bar

    barlayout.Name = "barLayout"
    barlayout.Parent = barfolder
    barlayout.SortOrder = Enum.SortOrder.LayoutOrder

    backgroundgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    backgroundgradient.Rotation = 90
    backgroundgradient.Name = "backgroundGradient"
    backgroundgradient.Parent = background

    backgroundcorner.CornerRadius = UDim.new(0, 2)
    backgroundcorner.Name = "backgroundCorner"
    backgroundcorner.Parent = background

    watertext.Name = "notifText"
    watertext.Parent = background
    watertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    watertext.BackgroundTransparency = 1.000
    watertext.Position = UDim2.new(0, 0, -0.0416666679, 0)
    watertext.Size = UDim2.new(0, 0, 0, 24)
    watertext.Font = Enum.Font.Code
    watertext.Text = text
    watertext.TextColor3 = Color3.fromRGB(198, 198, 198)
    watertext.TextTransparency = 1
    watertext.TextSize = 14.000
    watertext.RichText = true

    local newsize = textservice:GetTextSize(watertext.Text, watertext.TextSize, watertext.Font, Vector2.new(math.huge, math.huge))
    watertext.Size = UDim2.new(0, newsize.X + 8, 0, 24)

    waterpadding.Name = "notifPadding"
    waterpadding.Parent = watertext
    waterpadding.PaddingBottom = UDim.new(0, 4)
    waterpadding.PaddingLeft = UDim.new(0, 4)
    waterpadding.PaddingRight = UDim.new(0, 4)
    waterpadding.PaddingTop = UDim.new(0, 4)

    backgroundlayout.Name = "backgroundLayout"
    backgroundlayout.Parent = background
    backgroundlayout.SortOrder = Enum.SortOrder.LayoutOrder
    backgroundlayout.VerticalAlignment = Enum.VerticalAlignment.Center

    createtween("wm", 0.24)
    createtween("wm_2", 0.04)
    coroutine.wrap(function()
        tweenservice:Create(edge, tweentable["wm"], {BackgroundTransparency = 0}):Play()
        tweenservice:Create(edge, tweentable["wm"], {Size = UDim2.new(0, newsize.X + 10, 0, 26)}):Play()
        tweenservice:Create(background, tweentable["wm"], {BackgroundTransparency = 0}):Play()
        tweenservice:Create(background, tweentable["wm"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
        wait(.2)
        tweenservice:Create(bar, tweentable["wm"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
        wait(.1)
        tweenservice:Create(watertext, tweentable["wm"], {TextTransparency = 0}):Play()
    end)()

    local watermarkfunctions = {}
    function watermarkfunctions:addwatermark(text)
        text = text or "sigma"

        local edge = Instance.new("Frame")
        local edgecorner = Instance.new("UICorner")
        local background = Instance.new("Frame")
        local barfolder = Instance.new("Folder")
        local bar = Instance.new("Frame")
        local barcorner = Instance.new("UICorner")
        local barlayout = Instance.new("UIListLayout")
        local backgroundgradient = Instance.new("UIGradient")
        local backgroundcorner = Instance.new("UICorner")
        local watertext = Instance.new("TextLabel")
        local waterpadding = Instance.new("UIPadding")
        local backgroundlayout = Instance.new("UIListLayout")

        edge.Name = "edge"
        edge.Parent = watermark
        edge.AnchorPoint = Vector2.new(0.5, 0.5)
        edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        edge.Position = UDim2.new(0.5, 0, -0.03, 0)
        edge.Size = UDim2.new(0, 0, 0, 26)
        edge.BackgroundTransparency = 1

        edgecorner.CornerRadius = UDim.new(0, 2)
        edgecorner.Name = "edgeCorner"
        edgecorner.Parent = edge

        background.Name = "background"
        background.Parent = edge
        background.AnchorPoint = Vector2.new(0.5, 0.5)
        background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        background.BackgroundTransparency = 1
        background.ClipsDescendants = true
        background.Position = UDim2.new(0.5, 0, 0.5, 0)
        background.Size = UDim2.new(0, 0, 0, 24)

        barfolder.Name = "barFolder"
        barfolder.Parent = background

        bar.Name = "bar"
        bar.Parent = barfolder
        bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
        bar.BackgroundTransparency = 0
        bar.Size = UDim2.new(0, 0, 0, 1)

        barcorner.CornerRadius = UDim.new(0, 2)
        barcorner.Name = "barCorner"
        barcorner.Parent = bar

        barlayout.Name = "barLayout"
        barlayout.Parent = barfolder
        barlayout.SortOrder = Enum.SortOrder.LayoutOrder

        backgroundgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
        backgroundgradient.Rotation = 90
        backgroundgradient.Name = "backgroundGradient"
        backgroundgradient.Parent = background

        backgroundcorner.CornerRadius = UDim.new(0, 2)
        backgroundcorner.Name = "backgroundCorner"
        backgroundcorner.Parent = background

        watertext.Name = "notifText"
        watertext.Parent = background
        watertext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        watertext.BackgroundTransparency = 1.000
        watertext.Position = UDim2.new(0, 0, -0.0416666679, 0)
        watertext.Size = UDim2.new(0, 0, 0, 24)
        watertext.Font = Enum.Font.Code
        watertext.Text = text
        watertext.TextColor3 = Color3.fromRGB(198, 198, 198)
        watertext.TextTransparency = 1
        watertext.TextSize = 14.000
        watertext.RichText = true

        local newsize = textservice:GetTextSize(watertext.Text, watertext.TextSize, watertext.Font, Vector2.new(math.huge, math.huge))
        watertext.Size = UDim2.new(0, newsize.X + 8, 0, 24)

        waterpadding.Name = "notifPadding"
        waterpadding.Parent = watertext
        waterpadding.PaddingBottom = UDim.new(0, 4)
        waterpadding.PaddingLeft = UDim.new(0, 4)
        waterpadding.PaddingRight = UDim.new(0, 4)
        waterpadding.PaddingTop = UDim.new(0, 4)

        backgroundlayout.Name = "backgroundLayout"
        backgroundlayout.Parent = background
        backgroundlayout.SortOrder = Enum.SortOrder.LayoutOrder
        backgroundlayout.VerticalAlignment = Enum.VerticalAlignment.Center

        coroutine.wrap(function()
            tweenservice:Create(edge, tweentable["wm"], {BackgroundTransparency = 0}):Play()
            tweenservice:Create(edge, tweentable["wm"], {Size = UDim2.new(0, newsize.X + 10, 0, 26)}):Play()
            tweenservice:Create(background, tweentable["wm"], {BackgroundTransparency = 0}):Play()
            tweenservice:Create(background, tweentable["wm"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
            wait(.2)
            tweenservice:Create(bar, tweentable["wm"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
            wait(.1)
            tweenservice:Create(watertext, tweentable["wm"], {TextTransparency = 0}):Play()
        end)()

        local newwatermarkfunctions = {}
        function newwatermarkfunctions:hide()
            edge.Visible = false
            return newwatermarkfunctions
        end
        function newwatermarkfunctions:show()
            edge.Visible = true
            return newwatermarkfunctions
        end
        function newwatermarkfunctions:text(new)
            new = new or text
            watertext.Text = new

            local newsize = textservice:GetTextSize(watertext.Text, watertext.TextSize, watertext.Font, Vector2.new(math.huge, math.huge))
            watertext.Size = UDim2.new(0, newsize.X + 8, 0, 24)
            coroutine.wrap(function()
                tweenservice:Create(edge, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 10, 0, 26)}):Play()
                tweenservice:Create(background, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
                tweenservice:Create(bar, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
                tweenservice:Create(watertext, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
            end)()

            return newwatermarkfunctions
        end
        function newwatermarkfunctions:remove()
            watermark:Destroy()
            return newwatermarkfunctions
        end
        return newwatermarkfunctions
    end

    function watermarkfunctions:hide()
        edge.Visible = false
        return watermarkfunctions
    end
    function watermarkfunctions:show()
        edge.Visible = true
        return watermarkfunctions
    end
    function watermarkfunctions:text(new)
        new = new or text
        watertext.Text = new

        local newsize = textservice:GetTextSize(watertext.Text, watertext.TextSize, watertext.Font, Vector2.new(math.huge, math.huge))
        coroutine.wrap(function()
            tweenservice:Create(edge, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 10, 0, 26)}):Play()
            tweenservice:Create(background, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
            tweenservice:Create(bar, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
            tweenservice:Create(watertext, tweentable["wm_2"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
        end)()

        return watermarkfunctions
    end
    function watermarkfunctions:remove()
        watermark:Destroy()
        return watermarkfunctions
    end

    if library.togglemobile then
        local toggleconnection
        toggleconnection = watertext.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                for i,v in pairs(coreguiservice:GetChildren()) do
                    if v.Name == "screen" then
                        v.Enabled = not v.Enabled
                    end
                end
            end
        end)
        watermarkfunctions.toggleconnection = toggleconnection
    end

    return watermarkfunctions
end

function library:initnotifications(text, duration, callback)
    local existing = coreguiservice:FindFirstChild("Notifications")
    if existing then
        return library.notificationinstance
    end

    local notifications = Instance.new("ScreenGui")
    local notificationslayout = Instance.new("UIListLayout")
    local notificationspadding = Instance.new("UIPadding")

    notifications.Name = "Notifications"
    notifications.Parent = coreguiservice
    notifications.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    notificationslayout.Name = "notificationsLayout"
    notificationslayout.Parent = notifications
    notificationslayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationslayout.Padding = UDim.new(0, 4)

    notificationspadding.Name = "notificationsPadding"
    notificationspadding.Parent = notifications
    notificationspadding.PaddingLeft = UDim.new(0, 6)
    notificationspadding.PaddingTop = UDim.new(0, 18)

    local notification = {}
    function notification:notify(text, duration, type, callback)
        createtween("notification_load", 0.2)

        text = text or "please wait."
        duration = duration or 5
        type = type or "notification"
        callback = callback or function() end

        local edge = Instance.new("Frame")
        local edgecorner = Instance.new("UICorner")
        local background = Instance.new("Frame")
        local barfolder = Instance.new("Folder")
        local bar = Instance.new("Frame")
        local barcorner = Instance.new("UICorner")
        local barlayout = Instance.new("UIListLayout")
        local backgroundgradient = Instance.new("UIGradient")
        local backgroundcorner = Instance.new("UICorner")
        local notiftext = Instance.new("TextLabel")
        local notifpadding = Instance.new("UIPadding")
        local backgroundlayout = Instance.new("UIListLayout")

        edge.Name = "edge"
        edge.Parent = notifications
        edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        edge.BackgroundTransparency = 1.000
        edge.Size = UDim2.new(0, 0, 0, 26)

        edgecorner.CornerRadius = UDim.new(0, 2)
        edgecorner.Name = "edgeCorner"
        edgecorner.Parent = edge

        background.Name = "background"
        background.Parent = edge
        background.AnchorPoint = Vector2.new(0.5, 0.5)
        background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        background.BackgroundTransparency = 1.000
        background.ClipsDescendants = true
        background.Position = UDim2.new(0.5, 0, 0.5, 0)
        background.Size = UDim2.new(0, 0, 0, 24)

        barfolder.Name = "barFolder"
        barfolder.Parent = background

        bar.Name = "bar"
        bar.Parent = barfolder
        bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
        bar.BackgroundTransparency = 0.200
        bar.Size = UDim2.new(0, 0, 0, 1)
        if type == "notification" then
            bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
        elseif type == "alert" then
            bar.BackgroundColor3 = Color3.fromRGB(255, 246, 112)
        elseif type == "error" then
            bar.BackgroundColor3 = Color3.fromRGB(255, 74, 77)
        elseif type == "success" then
            bar.BackgroundColor3 = Color3.fromRGB(131, 255, 103)
        elseif type == "information" then
            bar.BackgroundColor3 = Color3.fromRGB(126, 117, 255)
        end

        barcorner.CornerRadius = UDim.new(0, 2)
        barcorner.Name = "barCorner"
        barcorner.Parent = bar

        barlayout.Name = "barLayout"
        barlayout.Parent = barfolder
        barlayout.SortOrder = Enum.SortOrder.LayoutOrder

        backgroundgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
        backgroundgradient.Rotation = 90
        backgroundgradient.Name = "backgroundGradient"
        backgroundgradient.Parent = background

        backgroundcorner.CornerRadius = UDim.new(0, 2)
        backgroundcorner.Name = "backgroundCorner"
        backgroundcorner.Parent = background

        notiftext.Name = "notifText"
        notiftext.Parent = background
        notiftext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        notiftext.BackgroundTransparency = 1.000
        notiftext.Size = UDim2.new(0, 230, 0, 26)
        notiftext.Font = Enum.Font.Code
        notiftext.Text = text
        notiftext.TextColor3 = Color3.fromRGB(198, 198, 198)
        notiftext.TextSize = 14.000
        notiftext.TextTransparency = 1.000
        notiftext.TextXAlignment = Enum.TextXAlignment.Left
        notiftext.RichText = true

        notifpadding.Name = "notifPadding"
        notifpadding.Parent = notiftext
        notifpadding.PaddingBottom = UDim.new(0, 4)
        notifpadding.PaddingLeft = UDim.new(0, 4)
        notifpadding.PaddingRight = UDim.new(0, 4)
        notifpadding.PaddingTop = UDim.new(0, 4)

        backgroundlayout.Name = "backgroundLayout"
        backgroundlayout.Parent = background
        backgroundlayout.SortOrder = Enum.SortOrder.LayoutOrder
        backgroundlayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local newsize = textservice:GetTextSize(notiftext.Text, notiftext.TextSize, notiftext.Font, Vector2.new(math.huge, math.huge))
        createtween("notification_wait", duration, Enum.EasingStyle.Quad)
        local isrunning = false
        coroutine.wrap(function()
            isrunning = true
            tweenservice:Create(edge, tweentable["notification_load"], {BackgroundTransparency = 0}):Play()
            tweenservice:Create(background, tweentable["notification_load"], {BackgroundTransparency = 0}):Play()
            tweenservice:Create(notiftext, tweentable["notification_load"], {TextTransparency = 0}):Play()
            tweenservice:Create(edge, tweentable["notification_load"], {Size = UDim2.new(0, newsize.X + 10, 0, 26)}):Play()
            tweenservice:Create(background, tweentable["notification_load"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
            tweenservice:Create(notiftext, tweentable["notification_load"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
            wait()
            tweenservice:Create(bar, tweentable["notification_wait"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
            repeat wait() until bar.Size == UDim2.new(0, newsize.X + 8, 0, 1)
            isrunning = false
            tweenservice:Create(edge, tweentable["notification_load"], {BackgroundTransparency = 1}):Play()
            tweenservice:Create(background, tweentable["notification_load"], {BackgroundTransparency = 1}):Play()
            tweenservice:Create(notiftext, tweentable["notification_load"], {TextTransparency = 1}):Play()
            tweenservice:Create(bar, tweentable["notification_load"], {BackgroundTransparency = 1}):Play()
            tweenservice:Create(edge, tweentable["notification_load"], {Size = UDim2.new(0, 0, 0, 26)}):Play()
            tweenservice:Create(background, tweentable["notification_load"], {Size = UDim2.new(0, 0, 0, 24)}):Play()
            tweenservice:Create(notiftext, tweentable["notification_load"], {Size = UDim2.new(0, 0, 0, 24)}):Play()
            tweenservice:Create(bar, tweentable["notification_load"], {Size = UDim2.new(0, 0, 0, 1)}):Play()
            wait(.2)
            edge:Destroy()
        end)()

        createtween("notification_reset", 0.4)
        local notificationfunctions = {}
        function notificationfunctions:text(new)
            new = new or text
            notiftext.Text = new

            newsize = textservice:GetTextSize(notiftext.Text, notiftext.TextSize, notiftext.Font, Vector2.new(math.huge, math.huge))
            if isrunning then
                tweenservice:Create(edge, tweentable["notification_load"], {Size = UDim2.new(0, newsize.X + 10, 0, 26)}):Play()
                tweenservice:Create(background, tweentable["notification_load"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
                tweenservice:Create(notiftext, tweentable["notification_load"], {Size = UDim2.new(0, newsize.X + 8, 0, 24)}):Play()
                wait()
                tweenservice:Create(bar, tweentable["notification_reset"], {Size = UDim2.new(0, 0, 0, 1)}):Play()
                wait(.4)
                tweenservice:Create(bar, tweentable["notification_wait"], {Size = UDim2.new(0, newsize.X + 8, 0, 1)}):Play()
            end

            return notificationfunctions
        end
        return notificationfunctions
    end

    library.notificationinstance = notification
    return notification
end

function library:introduction()
    for i,v in pairs(coreguiservice:GetChildren()) do
        if v.Name == "introduction" then
            v:Destroy()
        end
    end

    createtween("introduction",0.175)
    local introduction = Instance.new("ScreenGui")
    local edge = Instance.new("Frame")
    local edgecorner = Instance.new("UICorner")
    local background = Instance.new("Frame")
    local backgroundgradient = Instance.new("UIGradient")
    local backgroundcorner = Instance.new("UICorner")
    local barfolder = Instance.new("Folder")
    local bar = Instance.new("Frame")
    local barcorner = Instance.new("UICorner")
    local barlayout = Instance.new("UIListLayout")
    local sigmalogo = Instance.new("ImageLabel")
    local hashlogo = Instance.new("ImageLabel")
    local sigma = Instance.new("TextLabel")
    local text = Instance.new("TextLabel")
    local pagelayout = Instance.new("UIListLayout")

    introduction.Name = "introduction"
    introduction.Parent = coreguiservice
    introduction.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    edge.Name = "edge"
    edge.Parent = introduction
    edge.AnchorPoint = Vector2.new(0.5, 0.5)
    edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    edge.BackgroundTransparency = 1
    edge.Position = UDim2.new(0.511773348, 0, 0.5, 0)
    edge.Size = UDim2.new(0, 300, 0, 308)

    edgecorner.CornerRadius = UDim.new(0, 2)
    edgecorner.Name = "edgeCorner"
    edgecorner.Parent = edge

    background.Name = "background"
    background.Parent = edge
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.BackgroundTransparency = 1
    background.ClipsDescendants = true
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(0, 298, 0, 306)

    backgroundgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    backgroundgradient.Rotation = 90
    backgroundgradient.Name = "backgroundGradient"
    backgroundgradient.Parent = background

    backgroundcorner.CornerRadius = UDim.new(0, 2)
    backgroundcorner.Name = "backgroundCorner"
    backgroundcorner.Parent = background

    barfolder.Name = "barFolder"
    barfolder.Parent = background

    bar.Name = "bar"
    bar.Parent = barfolder
    bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
    bar.BackgroundTransparency = 0.200
    bar.Size = UDim2.new(0, 0, 0, 1)

    barcorner.CornerRadius = UDim.new(0, 2)
    barcorner.Name = "barCorner"
    barcorner.Parent = bar

    barlayout.Name = "barLayout"
    barlayout.Parent = barfolder
    barlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    barlayout.SortOrder = Enum.SortOrder.LayoutOrder

    sigmalogo.Name = "sigmaLogo"
    sigmalogo.Parent = background
    sigmalogo.AnchorPoint = Vector2.new(0.5, 0.5)
    sigmalogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sigmalogo.BackgroundTransparency = 1.000
    sigmalogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    sigmalogo.Size = UDim2.new(0, 448, 0, 150)
    sigmalogo.Visible = true
    sigmalogo.Image = "http://www.roblox.com/asset/?id=9365068051"
    sigmalogo.ImageColor3 = Color3.fromRGB(159, 115, 255)
    sigmalogo.ImageTransparency = 1

    hashlogo.Name = "hashLogo"
    hashlogo.Parent = background
    hashlogo.AnchorPoint = Vector2.new(0.5, 0.5)
    hashlogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hashlogo.BackgroundTransparency = 1.000
    hashlogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    hashlogo.Size = UDim2.new(0, 150, 0, 150)
    hashlogo.Visible = true
    hashlogo.Image = "http://www.roblox.com/asset/?id=9365069861"
    hashlogo.ImageColor3 = Color3.fromRGB(159, 115, 255)
    hashlogo.ImageTransparency = 1

    sigma.Name = "sigma"
    sigma.Parent = background
    sigma.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sigma.BackgroundTransparency = 1.000
    sigma.Size = UDim2.new(0, 80, 0, 21)
    sigma.Font = Enum.Font.Code
    sigma.Text = "powered by sigma"
    sigma.TextColor3 = Color3.fromRGB(124, 124, 124)
    sigma.TextSize = 10.000
    sigma.TextTransparency = 1

    text.Name = "text"
    text.Parent = background
    text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    text.BackgroundTransparency = 1.000
    text.Position = UDim2.new(0.912751675, 0, 0, 0)
    text.Size = UDim2.new(0, 26, 0, 21)
    text.Font = Enum.Font.Code
    text.Text = "hash"
    text.TextColor3 = Color3.fromRGB(124, 124, 124)
    text.TextSize = 10.000
    text.TextTransparency = 1
    text.RichText = true

    pagelayout.Name = "pageLayout"
    pagelayout.Parent = introduction
    pagelayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pagelayout.SortOrder = Enum.SortOrder.LayoutOrder
    pagelayout.VerticalAlignment = Enum.VerticalAlignment.Center

    createtween("sigmarotation", 0)
    local minusamount = -16
    coroutine.wrap(function()
        while wait() do
            minusamount = minusamount + 0.4
            tweenservice:Create(sigmalogo, tweentable["sigmarotation"], {Rotation = sigmalogo.Rotation - minusamount}):Play()
        end
    end)()

    tweenservice:Create(edge, tweentable["introduction"], {BackgroundTransparency = 0}):Play()
    tweenservice:Create(background, tweentable["introduction"], {BackgroundTransparency = 0}):Play()
    wait(.2)
    tweenservice:Create(bar, tweentable["introduction"], {Size = UDim2.new(0, 298, 0, 1)}):Play()
    wait(.2)
    tweenservice:Create(sigma, tweentable["introduction"], {TextTransparency = 0}):Play()
    tweenservice:Create(text, tweentable["introduction"], {TextTransparency = 0}):Play()
    wait(.3)
    tweenservice:Create(sigmalogo, tweentable["introduction"], {ImageTransparency = 0}):Play()
    wait(2)
    tweenservice:Create(sigmalogo, tweentable["introduction"], {ImageTransparency = 1}):Play()
    wait(.2)
    tweenservice:Create(hashlogo, tweentable["introduction"], {ImageTransparency = 0}):Play()
    wait(2)
    tweenservice:Create(hashlogo, tweentable["introduction"], {ImageTransparency = 1}):Play()
    wait(.1)
    tweenservice:Create(text, tweentable["introduction"], {TextTransparency = 1}):Play()
    wait(.1)
    tweenservice:Create(sigma, tweentable["introduction"], {TextTransparency = 1}):Play()
    wait(.1)
    tweenservice:Create(bar, tweentable["introduction"], {Size = UDim2.new(0, 0, 0, 1)}):Play()
    wait(.1)
    tweenservice:Create(background, tweentable["introduction"], {BackgroundTransparency = 1}):Play()
    tweenservice:Create(edge, tweentable["introduction"], {BackgroundTransparency = 1}):Play()
    wait(.2)
    introduction:Destroy()
end

function library:init(key)
    for i,v in pairs(coreguiservice:GetChildren()) do
        if v.Name == "screen" then
            v:Destroy()
        end
    end

    local title = library.title
    key = key or Enum.KeyCode.RightAlt

    local screen = Instance.new("ScreenGui")
    local edge = Instance.new("Frame")
    local edgecorner = Instance.new("UICorner")
    local background = Instance.new("Frame")
    local backgroundcorner = Instance.new("UICorner")
    local backgroundgradient = Instance.new("UIGradient")
    local headerlabel = Instance.new("TextLabel")
    local headerpadding = Instance.new("UIPadding")
    local barfolder = Instance.new("Folder")
    local bar = Instance.new("Frame")
    local barcorner = Instance.new("UICorner")
    local barlayout = Instance.new("UIListLayout")
    local tabbuttonsedge = Instance.new("Frame")
    local tabbuttoncorner = Instance.new("UICorner")
    local tabbuttons = Instance.new("Frame")
    local tabbuttoncorner_2 = Instance.new("UICorner")
    local tabbuttonsgradient = Instance.new("UIGradient")
    local tabbuttonlayout = Instance.new("UIListLayout")
    local tabbuttonpadding = Instance.new("UIPadding")
    local containeredge = Instance.new("Frame")
    local tabbuttoncorner_3 = Instance.new("UICorner")
    local container = Instance.new("Frame")
    local containercorner = Instance.new("UICorner")
    local containergradient = Instance.new("UIGradient")

    screen.Name = "screen"
    screen.Parent = coreguiservice
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    edge.Name = "edge"
    edge.Parent = screen
    edge.AnchorPoint = Vector2.new(0.5, 0.5)
    edge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    edge.Position = UDim2.new(0.5, 0, 0.5, 0)
    edge.Size = UDim2.new(0, 594, 0, 406)

    drag(edge, 0.04)
    local canchangevisibility = true
    userinputservice.InputBegan:Connect(function(input)
        if canchangevisibility and input.KeyCode == key then
            edge.Visible = not edge.Visible
        end
    end)

    edgecorner.CornerRadius = UDim.new(0, 2)
    edgecorner.Name = "edgeCorner"
    edgecorner.Parent = edge

    background.Name = "background"
    background.Parent = edge
    background.AnchorPoint = Vector2.new(0.5, 0.5)
    background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    background.Position = UDim2.new(0.5, 0, 0.5, 0)
    background.Size = UDim2.new(0, 592, 0, 404)
    background.ClipsDescendants = true

    backgroundcorner.CornerRadius = UDim.new(0, 2)
    backgroundcorner.Name = "backgroundCorner"
    backgroundcorner.Parent = background

    backgroundgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    backgroundgradient.Rotation = 90
    backgroundgradient.Name = "backgroundGradient"
    backgroundgradient.Parent = background

    headerlabel.Name = "headerLabel"
    headerlabel.Parent = background
    headerlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    headerlabel.BackgroundTransparency = 1.000
    headerlabel.Size = UDim2.new(0, 592, 0, 38)
    headerlabel.Font = Enum.Font.Code
    headerlabel.Text = title
    headerlabel.TextColor3 = Color3.fromRGB(198, 198, 198)
    headerlabel.TextSize = 16.000
    headerlabel.TextXAlignment = Enum.TextXAlignment.Left
    headerlabel.RichText = true

    headerpadding.Name = "headerPadding"
    headerpadding.Parent = headerlabel
    headerpadding.PaddingBottom = UDim.new(0, 6)
    headerpadding.PaddingLeft = UDim.new(0, 12)
    headerpadding.PaddingRight = UDim.new(0, 6)
    headerpadding.PaddingTop = UDim.new(0, 6)

    barfolder.Name = "barFolder"
    barfolder.Parent = background

    bar.Name = "bar"
    bar.Parent = barfolder
    bar.BackgroundColor3 = Color3.fromRGB(159, 115, 255)
    bar.BackgroundTransparency = 0.200
    bar.Size = UDim2.new(0, 592, 0, 1)
    bar.BorderSizePixel = 0

    barcorner.CornerRadius = UDim.new(0, 2)
    barcorner.Name = "barCorner"
    barcorner.Parent = bar

    barlayout.Name = "barLayout"
    barlayout.Parent = barfolder
    barlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    barlayout.SortOrder = Enum.SortOrder.LayoutOrder

    tabbuttonsedge.Name = "tabButtonsEdge"
    tabbuttonsedge.Parent = background
    tabbuttonsedge.AnchorPoint = Vector2.new(0.5, 0.5)
    tabbuttonsedge.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabbuttonsedge.Position = UDim2.new(0.1435, 0, 0.536000013, 0)
    tabbuttonsedge.Size = UDim2.new(0, 152, 0, 360)

    tabbuttoncorner.CornerRadius = UDim.new(0, 2)
    tabbuttoncorner.Name = "tabButtonCorner"
    tabbuttoncorner.Parent = tabbuttonsedge

    tabbuttons.Name = "tabButtons"
    tabbuttons.Parent = tabbuttonsedge
    tabbuttons.AnchorPoint = Vector2.new(0.5, 0.5)
    tabbuttons.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    tabbuttons.ClipsDescendants = true
    tabbuttons.Position = UDim2.new(0.5, 0, 0.5, 0)
    tabbuttons.Size = UDim2.new(0, 150, 0, 358)

    tabbuttoncorner_2.CornerRadius = UDim.new(0, 2)
    tabbuttoncorner_2.Name = "tabButtonCorner"
    tabbuttoncorner_2.Parent = tabbuttons

    tabbuttonsgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    tabbuttonsgradient.Rotation = 90
    tabbuttonsgradient.Name = "tabButtonsGradient"
    tabbuttonsgradient.Parent = tabbuttons

    tabbuttonlayout.Name = "tabButtonLayout"
    tabbuttonlayout.Parent = tabbuttons
    tabbuttonlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabbuttonlayout.SortOrder = Enum.SortOrder.LayoutOrder

    tabbuttonpadding.Name = "tabButtonPadding"
    tabbuttonpadding.Parent = tabbuttons
    tabbuttonpadding.PaddingBottom = UDim.new(0, 4)
    tabbuttonpadding.PaddingLeft = UDim.new(0, 4)
    tabbuttonpadding.PaddingRight = UDim.new(0, 4)
    tabbuttonpadding.PaddingTop = UDim.new(0, 4)

    containeredge.Name = "containerEdge"
    containeredge.Parent = background
    containeredge.AnchorPoint = Vector2.new(0.5, 0.5)
    containeredge.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    containeredge.Position = UDim2.new(0.637000024, 0, 0.536000013, 0)
    containeredge.Size = UDim2.new(0, 414, 0, 360)

    tabbuttoncorner_3.CornerRadius = UDim.new(0, 2)
    tabbuttoncorner_3.Name = "tabButtonCorner"
    tabbuttoncorner_3.Parent = containeredge

    container.Name = "container"
    container.Parent = containeredge
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.Size = UDim2.new(0, 412, 0, 358)

    containercorner.CornerRadius = UDim.new(0, 2)
    containercorner.Name = "containerCorner"
    containercorner.Parent = container

    containergradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
    containergradient.Rotation = 90
    containergradient.Name = "containerGradient"
    containergradient.Parent = container

    local tablibrary = {
        isfirst = true,
        currenttab = ""
    }
    createtween("tab_text_colour", 0.16)
    function tablibrary:newtab(title)
        title = title or "tab"

        local tabbutton = Instance.new("TextButton")
        local page = Instance.new("ScrollingFrame")
        local pagelayout = Instance.new("UIListLayout")
        local pagepadding = Instance.new("UIPadding")

        tabbutton.Name = "tabButton"
        tabbutton.Parent = tabbuttons
        tabbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabbutton.BackgroundTransparency = 1.000
        tabbutton.ClipsDescendants = true
        tabbutton.Position = UDim2.new(-0.0281690136, 0, 0, 0)
        tabbutton.Size = UDim2.new(0, 150, 0, 22)
        tabbutton.AutoButtonColor = false
        tabbutton.Font = Enum.Font.Code
        tabbutton.Text = title
        tabbutton.TextColor3 = Color3.fromRGB(170, 170, 170)
        tabbutton.TextSize = 15.000
        tabbutton.RichText = true

        page.Name = "page"
        page.Parent = container
        page.Active = true
        page.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        page.BackgroundTransparency = 1.000
        page.BorderSizePixel = 0
        page.Size = UDim2.new(0, 412, 0, 358)
        page.BottomImage = "http://www.roblox.com/asset/?id=3062506202"
        page.MidImage = "http://www.roblox.com/asset/?id=3062506202"
        page.ScrollBarThickness = 1
        page.TopImage = "http://www.roblox.com/asset/?id=3062506202"
        page.ScrollBarImageColor3 = Color3.fromRGB(159, 115, 255)
        page.Visible = false

        pagelayout.Name = "pageLayout"
        pagelayout.Parent = page
        pagelayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pagelayout.SortOrder = Enum.SortOrder.LayoutOrder
        pagelayout.Padding = UDim.new(0, 4)

        pagepadding.Name = "pagePadding"
        pagepadding.Parent = page
        pagepadding.PaddingBottom = UDim.new(0, 6)
        pagepadding.PaddingLeft = UDim.new(0, 6)
        pagepadding.PaddingRight = UDim.new(0, 6)
        pagepadding.PaddingTop = UDim.new(0, 6)

        if tablibrary.isfirst then
            page.Visible = true
            tabbutton.TextColor3 = Color3.fromRGB(159, 115, 255)
            tablibrary.currenttab = title
        end

        tabbutton.MouseButton1Click:Connect(function()
            tablibrary.currenttab = title
            for i,v in pairs(container:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            page.Visible = true

            for i,v in pairs(tabbuttons:GetChildren()) do
                if v:IsA("TextButton") then
                    tweenservice:Create(v, tweentable["tab_text_colour"], {TextColor3 = Color3.fromRGB(170, 170, 170)}):Play()
                end
            end
            tweenservice:Create(tabbutton, tweentable["tab_text_colour"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
        end)

        local function updatepagesize()
            local correction = pagelayout.AbsoluteContentSize
            page.CanvasSize = UDim2.new(0, correction.X+13, 0, correction.Y+13)
        end

        page.ChildAdded:Connect(updatepagesize)
        page.ChildRemoved:Connect(updatepagesize)

        tablibrary.isfirst = false

        createtween("hover", 0.16)
        local components = {}
        function components:newlabel(text, alignment)
            text = text or "label"
            alignment = alignment or "left"

            local label = Instance.new("TextLabel")
            local labelpadding = Instance.new("UIPadding")

            label.Name = "label"
            label.Parent = page
            label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1.000
            label.Position = UDim2.new(0.00499999989, 0, 0, 0)
            label.Size = UDim2.new(0, 396, 0, 24)
            label.Font = Enum.Font.Code
            label.Text = text
            label.TextColor3 = Color3.fromRGB(190, 190, 190)
            label.TextSize = 14.000
            label.TextWrapped = true
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.RichText = true

            labelpadding.Name = "pagePadding"
            labelpadding.Parent = page
            labelpadding.PaddingBottom = UDim.new(0, 6)
            labelpadding.PaddingLeft = UDim.new(0, 12)
            labelpadding.PaddingRight = UDim.new(0, 6)
            labelpadding.PaddingTop = UDim.new(0, 6)

            if alignment:lower():find("le") then
                label.TextXAlignment = Enum.TextXAlignment.Left
            elseif alignment:lower():find("cent") then
                label.TextXAlignment = Enum.TextXAlignment.Center
            elseif alignment:lower():find("ri") then
                label.TextXAlignment = Enum.TextXAlignment.Right
            end

            updatepagesize()

            local labelfunctions = {}
            function labelfunctions:text(text)
                text = text or "new label text"
                label.Text = text
                return labelfunctions
            end
            function labelfunctions:remove()
                label:Destroy()
                return labelfunctions
            end
            function labelfunctions:hide()
                label.Visible = false
                updatepagesize()
                return labelfunctions
            end
            function labelfunctions:show()
                label.Visible = true
                updatepagesize()
                return labelfunctions
            end
            function labelfunctions:align(new)
                new = new or "le"
                if new:lower():find("le") then
                    label.TextXAlignment = Enum.TextXAlignment.Left
                elseif new:lower():find("cent") then
                    label.TextXAlignment = Enum.TextXAlignment.Center
                elseif new:lower():find("ri") then
                    label.TextXAlignment = Enum.TextXAlignment.Right
                end
            end
            return labelfunctions
        end

        function components:newbutton(text, callback)
            text = text or "button"
            callback = callback or function() end

            local buttonframe = Instance.new("Frame")
            local buttonlayout = Instance.new("UIListLayout")
            local button = Instance.new("TextButton")
            local buttoncorner = Instance.new("UICorner")
            local buttonbackground = Instance.new("Frame")
            local buttongradient = Instance.new("UIGradient")
            local buttonbackcorner = Instance.new("UICorner")
            local buttonlabel = Instance.new("TextLabel")

            buttonframe.Name = "buttonFrame"
            buttonframe.Parent = page
            buttonframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonframe.BackgroundTransparency = 1.000
            buttonframe.Size = UDim2.new(0, 396, 0, 24)

            buttonlayout.Name = "buttonLayout"
            buttonlayout.Parent = buttonframe
            buttonlayout.FillDirection = Enum.FillDirection.Horizontal
            buttonlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            buttonlayout.SortOrder = Enum.SortOrder.LayoutOrder
            buttonlayout.VerticalAlignment = Enum.VerticalAlignment.Center
            buttonlayout.Padding = UDim.new(0, 4)

            button.Name = "button"
            button.Parent = buttonframe
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.Size = UDim2.new(0, 396, 0, 24)
            button.AutoButtonColor = false
            button.Font = Enum.Font.SourceSans
            button.Text = ""
            button.TextColor3 = Color3.fromRGB(0, 0, 0)
            button.TextSize = 14.000

            buttoncorner.CornerRadius = UDim.new(0, 2)
            buttoncorner.Name = "buttonCorner"
            buttoncorner.Parent = button

            buttonbackground.Name = "buttonBackground"
            buttonbackground.Parent = button
            buttonbackground.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonbackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
            buttonbackground.Size = UDim2.new(0, 394, 0, 22)

            buttongradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            buttongradient.Rotation = 90
            buttongradient.Name = "buttonGradient"
            buttongradient.Parent = buttonbackground

            buttonbackcorner.CornerRadius = UDim.new(0, 2)
            buttonbackcorner.Name = "buttonBackCorner"
            buttonbackcorner.Parent = buttonbackground

            buttonlabel.Name = "buttonLabel"
            buttonlabel.Parent = buttonbackground
            buttonlabel.AnchorPoint = Vector2.new(0.5, 0.5)
            buttonlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonlabel.BackgroundTransparency = 1.000
            buttonlabel.ClipsDescendants = true
            buttonlabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            buttonlabel.Size = UDim2.new(0, 394, 0, 22)
            buttonlabel.Font = Enum.Font.Code
            buttonlabel.Text = text
            buttonlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            buttonlabel.TextSize = 14.000
            buttonlabel.RichText = true

            button.MouseEnter:Connect(function()
                tweenservice:Create(button, tweentable["hover"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            button.MouseLeave:Connect(function()
                tweenservice:Create(button, tweentable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)

            button.MouseButton1Down:Connect(function()
                tweenservice:Create(buttonlabel, tweentable["hover"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
            end)
            button.MouseButton1Up:Connect(function()
                tweenservice:Create(buttonlabel, tweentable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
            end)

            button.MouseButton1Click:Connect(function()
                callback()
            end)

            local newsizex = 396
            local amnt = 0
            local function resizebuttons()
                local amount = buttonframe:GetChildren()
                local resized = 396
                amount = #amount - 1
                amnt = amount
                local amounttosubtract = (amount / 2)
                resized = (396 / amount) - amounttosubtract
                newsizex = (resized)

                for i,v in pairs(buttonframe:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.Size = UDim2.new(0, resized, 0, 24)
                        for z,x in pairs(v:GetDescendants()) do
                            if x:IsA("TextLabel") or x:IsA("Frame") then
                                x.Size = UDim2.new(0, resized - 2, 0, 22)
                            end
                        end
                    end
                end
            end

            buttonframe.ChildAdded:Connect(resizebuttons)
            buttonframe.ChildRemoved:Connect(resizebuttons)

            updatepagesize()

            local buttonfunctions = {}
            function buttonfunctions:addbutton(text, callback_2)
                if amnt < 4 then
                    text = text or "button"
                    callback_2 = callback_2 or function() end

                    local button = Instance.new("TextButton")
                    local buttoncorner = Instance.new("UICorner")
                    local buttonbackground = Instance.new("Frame")
                    local buttongradient = Instance.new("UIGradient")
                    local buttonbackcorner = Instance.new("UICorner")
                    local buttonlabel = Instance.new("TextLabel")

                    button.Name = "button"
                    button.Parent = buttonframe
                    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    button.Size = UDim2.new(0, newsizex - amnt, 0, 24)
                    button.AutoButtonColor = false
                    button.Font = Enum.Font.SourceSans
                    button.Text = ""
                    button.TextColor3 = Color3.fromRGB(0, 0, 0)
                    button.TextSize = 14.000

                    buttoncorner.CornerRadius = UDim.new(0, 2)
                    buttoncorner.Name = "buttonCorner"
                    buttoncorner.Parent = button

                    buttonbackground.Name = "buttonBackground"
                    buttonbackground.Parent = button
                    buttonbackground.AnchorPoint = Vector2.new(0.5, 0.5)
                    buttonbackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    buttonbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
                    buttonbackground.Size = UDim2.new(0, (newsizex - 2) - amnt, 0, 22)

                    buttongradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                    buttongradient.Rotation = 90
                    buttongradient.Name = "buttonGradient"
                    buttongradient.Parent = buttonbackground

                    buttonbackcorner.CornerRadius = UDim.new(0, 2)
                    buttonbackcorner.Name = "buttonBackCorner"
                    buttonbackcorner.Parent = buttonbackground

                    buttonlabel.Name = "buttonLabel"
                    buttonlabel.Parent = buttonbackground
                    buttonlabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    buttonlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    buttonlabel.BackgroundTransparency = 1.000
                    buttonlabel.ClipsDescendants = true
                    buttonlabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                    buttonlabel.Size = UDim2.new(0, newsizex - 2, 0, 22)
                    buttonlabel.Font = Enum.Font.Code
                    buttonlabel.Text = text
                    buttonlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                    buttonlabel.TextSize = 14.000
                    buttonlabel.RichText = true

                    updatepagesize()

                    button.MouseEnter:Connect(function()
                        tweenservice:Create(button, tweentable["hover"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    end)
                    button.MouseLeave:Connect(function()
                        tweenservice:Create(button, tweentable["hover"], {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
                    end)

                    button.MouseButton1Down:Connect(function()
                        tweenservice:Create(buttonlabel, tweentable["hover"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                    end)
                    button.MouseButton1Up:Connect(function()
                        tweenservice:Create(buttonlabel, tweentable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                    end)

                    button.MouseButton1Click:Connect(function()
                        callback_2()
                    end)

                    local buttonfunctions2 = {}
                    function buttonfunctions2:fire()
                        callback_2()
                        return buttonfunctions2
                    end
                    function buttonfunctions2:hide()
                        button.Visible = false
                        return buttonfunctions2
                    end
                    function buttonfunctions2:show()
                        button.Visible = true
                        return buttonfunctions2
                    end
                    function buttonfunctions2:text(text)
                        text = text or "button new text"
                        buttonlabel.Text = text
                        return buttonfunctions2
                    end
                    function buttonfunctions2:remove()
                        button:Destroy()
                        return buttonfunctions2
                    end
                    function buttonfunctions2:setfunction(new)
                        new = new or function() end
                        callback_2 = new
                        return buttonfunctions2
                    end
                    return buttonfunctions2
                elseif amnt > 4 then
                    print("more than 4 buttons are not supported.")
                end
                return buttonfunctions
            end
            function buttonfunctions:fire()
                callback()
                return buttonfunctions
            end
            function buttonfunctions:hide()
                button.Visible = false
                return buttonfunctions
            end
            function buttonfunctions:show()
                button.Visible = true
                return buttonfunctions
            end
            function buttonfunctions:text(text)
                text = text or "button new text"
                buttonlabel.Text = text
                return buttonfunctions
            end
            function buttonfunctions:remove()
                button:Destroy()
                return buttonfunctions
            end
            function buttonfunctions:setfunction(new)
                new = new or function() end
                callback = new
                return buttonfunctions
            end
            return buttonfunctions
        end

        function components:newsection(text)
            text = text or "section"

            local sectionframe = Instance.new("Frame")
            local sectionlayout = Instance.new("UIListLayout")
            local leftbar = Instance.new("Frame")
            local sectionlabel = Instance.new("TextLabel")
            local sectionpadding = Instance.new("UIPadding")
            local rightbar = Instance.new("Frame")

            sectionframe.Name = "sectionFrame"
            sectionframe.Parent = page
            sectionframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionframe.BackgroundTransparency = 1.000
            sectionframe.ClipsDescendants = true
            sectionframe.Size = UDim2.new(0, 396, 0, 18)

            sectionlayout.Name = "sectionLayout"
            sectionlayout.Parent = sectionframe
            sectionlayout.FillDirection = Enum.FillDirection.Horizontal
            sectionlayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlayout.VerticalAlignment = Enum.VerticalAlignment.Center
            sectionlayout.Padding = UDim.new(0, 4)

            sectionlabel.Name = "sectionLabel"
            sectionlabel.Parent = sectionframe
            sectionlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionlabel.BackgroundTransparency = 1.000
            sectionlabel.ClipsDescendants = true
            sectionlabel.Position = UDim2.new(0.0252525248, 0, 0.020833334, 0)
            sectionlabel.Size = UDim2.new(0, 0, 0, 18)
            sectionlabel.Font = Enum.Font.Code
            sectionlabel.LineHeight = 1
            sectionlabel.Text = text
            sectionlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            sectionlabel.TextSize = 14.000
            sectionlabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionlabel.RichText = true

            sectionpadding.Name = "sectionPadding"
            sectionpadding.Parent = sectionlabel
            sectionpadding.PaddingBottom = UDim.new(0, 6)
            sectionpadding.PaddingLeft = UDim.new(0, 0)
            sectionpadding.PaddingRight = UDim.new(0, 6)
            sectionpadding.PaddingTop = UDim.new(0, 6)

            rightbar.Name = "rightBar"
            rightbar.Parent = sectionframe
            rightbar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            rightbar.BorderSizePixel = 0
            rightbar.Position = UDim2.new(0.308080822, 0, 0.479166657, 0)
            rightbar.Size = UDim2.new(0, 403, 0, 1)
            updatepagesize()

            local newsectionsize = textservice:GetTextSize(sectionlabel.Text, sectionlabel.TextSize, sectionlabel.Font, Vector2.new(math.huge,math.huge))
            sectionlabel.Size = UDim2.new(0, newsectionsize.X, 0, 18)

            local sectionfunctions = {}
            function sectionfunctions:text(new)
                new = new or text
                sectionlabel.Text = new
                local newsectionsize = textservice:GetTextSize(sectionlabel.Text, sectionlabel.TextSize, sectionlabel.Font, Vector2.new(math.huge,math.huge))
                sectionlabel.Size = UDim2.new(0, newsectionsize.X, 0, 18)
                return sectionfunctions
            end
            function sectionfunctions:hide()
                sectionframe.Visible = false
                return sectionfunctions
            end
            function sectionfunctions:show()
                sectionframe.Visible = true
                return sectionfunctions
            end
            function sectionfunctions:remove()
                sectionframe:Destroy()
                return sectionfunctions
            end
            return sectionfunctions
        end

        function components:newtoggle(text, default, callback)
            text = text or "toggle"
            default = default or false
            callback = callback or function() end

            local togglebutton = Instance.new("TextButton")
            local togglelayout = Instance.new("UIListLayout")
            local toggleedge = Instance.new("Frame")
            local toggleedgecorner = Instance.new("UICorner")
            local toggle = Instance.new("Frame")
            local togglecorner = Instance.new("UICorner")
            local togglegradient = Instance.new("UIGradient")
            local toggledesign = Instance.new("Frame")
            local toggledesigncorner = Instance.new("UICorner")
            local toggledesigngradient = Instance.new("UIGradient")
            local togglelabel = Instance.new("TextLabel")
            local togglelabelpadding = Instance.new("UIPadding")
            local extras = Instance.new("Folder")
            local extraslayout = Instance.new("UIListLayout")

            togglebutton.Name = "toggleButton"
            togglebutton.Parent = page
            togglebutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            togglebutton.BackgroundTransparency = 1.000
            togglebutton.ClipsDescendants = false
            togglebutton.Size = UDim2.new(0, 396, 0, 22)
            togglebutton.Font = Enum.Font.Code
            togglebutton.Text = ""
            togglebutton.TextColor3 = Color3.fromRGB(190, 190, 190)
            togglebutton.TextSize = 14.000
            togglebutton.TextXAlignment = Enum.TextXAlignment.Left

            togglelayout.Name = "toggleLayout"
            togglelayout.Parent = togglebutton
            togglelayout.FillDirection = Enum.FillDirection.Horizontal
            togglelayout.SortOrder = Enum.SortOrder.LayoutOrder
            togglelayout.VerticalAlignment = Enum.VerticalAlignment.Center

            toggleedge.Name = "toggleEdge"
            toggleedge.Parent = togglebutton
            toggleedge.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleedge.Size = UDim2.new(0, 18, 0, 18)

            toggleedgecorner.CornerRadius = UDim.new(0, 2)
            toggleedgecorner.Name = "toggleEdgeCorner"
            toggleedgecorner.Parent = toggleedge

            toggle.Name = "toggle"
            toggle.Parent = toggleedge
            toggle.AnchorPoint = Vector2.new(0.5, 0.5)
            toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Position = UDim2.new(0.5, 0, 0.5, 0)
            toggle.Size = UDim2.new(0, 16, 0, 16)

            togglecorner.CornerRadius = UDim.new(0, 2)
            togglecorner.Name = "toggleCorner"
            togglecorner.Parent = toggle

            togglegradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            togglegradient.Rotation = 90
            togglegradient.Name = "toggleGradient"
            togglegradient.Parent = toggle

            toggledesign.Name = "toggleDesign"
            toggledesign.Parent = toggle
            toggledesign.AnchorPoint = Vector2.new(0.5, 0.5)
            toggledesign.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggledesign.BackgroundTransparency = 1.000
            toggledesign.Position = UDim2.new(0.5, 0, 0.5, 0)

            toggledesigncorner.CornerRadius = UDim.new(0, 2)
            toggledesigncorner.Name = "toggleDesignCorner"
            toggledesigncorner.Parent = toggledesign

            toggledesigngradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(157, 115, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(106, 69, 181))}
            toggledesigngradient.Rotation = 90
            toggledesigngradient.Name = "toggleDesignGradient"
            toggledesigngradient.Parent = toggledesign

            togglelabel.Name = "toggleLabel"
            togglelabel.Parent = togglebutton
            togglelabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            togglelabel.BackgroundTransparency = 1.000
            togglelabel.Position = UDim2.new(0.0454545468, 0, 0, 0)
            togglelabel.Size = UDim2.new(0, 377, 0, 22)
            togglelabel.Font = Enum.Font.Code
            togglelabel.LineHeight = 1.150
            togglelabel.Text = text
            togglelabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            togglelabel.TextSize = 14.000
            togglelabel.TextXAlignment = Enum.TextXAlignment.Left
            togglelabel.RichText = true

            togglelabelpadding.Name = "toggleLabelPadding"
            togglelabelpadding.Parent = togglelabel
            togglelabelpadding.PaddingLeft = UDim.new(0, 6)

            extras.Name = "Extras"
            extras.Parent = togglebutton

            extraslayout.Name = "ExtrasLayout"
            extraslayout.Parent = extras
            extraslayout.FillDirection = Enum.FillDirection.Horizontal
            extraslayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            extraslayout.SortOrder = Enum.SortOrder.LayoutOrder
            extraslayout.VerticalAlignment = Enum.VerticalAlignment.Center
            extraslayout.Padding = UDim.new(0, 2)

            local newtogglelabelsize = textservice:GetTextSize(togglelabel.Text, togglelabel.TextSize, togglelabel.Font, Vector2.new(math.huge,math.huge))
            togglelabel.Size = UDim2.new(0, newtogglelabelsize.X + 6, 0, 22)

            togglebutton.MouseEnter:Connect(function()
                tweenservice:Create(togglelabel, tweentable["hover"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
            end)
            togglebutton.MouseLeave:Connect(function()
                tweenservice:Create(togglelabel, tweentable["hover"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
            end)

            createtween("toggle_form", 0.13)
            local on = default
            if default then
                on = true
            else
                on = false
            end
            togglebutton.MouseButton1Click:Connect(function()
                on = not on
                local sizeon = on and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                local transparency = on and 0 or 1
                tweenservice:Create(toggledesign, tweentable["toggle_form"], {Size = sizeon}):Play()
                tweenservice:Create(toggledesign, tweentable["toggle_form"], {BackgroundTransparency = transparency}):Play()
                callback(on)
            end)

            local togglefunctions = {}
            function togglefunctions:text(new)
                new = new or text
                togglelabel.Text = new
                return togglefunctions
            end
            function togglefunctions:hide()
                togglebutton.Visible = false
                return togglefunctions
            end
            function togglefunctions:show()
                togglebutton.Visible = true
                return togglefunctions
            end
            function togglefunctions:change()
                on = not on
                local sizeon = on and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                local transparency = on and 0 or 1
                tweenservice:Create(toggledesign, tweentable["toggle_form"], {Size = sizeon}):Play()
                tweenservice:Create(toggledesign, tweentable["toggle_form"], {BackgroundTransparency = transparency}):Play()
                callback(on)
                return togglefunctions
            end
            function togglefunctions:remove()
                togglebutton:Destroy()
                return togglefunctions
            end
            function togglefunctions:set(state)
                on = state
                local sizeon = on and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                local transparency = on and 0 or 1
                tweenservice:Create(toggledesign, tweentable["toggle_form"], {Size = sizeon}):Play()
                tweenservice:Create(toggledesign, tweentable["toggle_form"], {BackgroundTransparency = transparency}):Play()
                callback(on)
                return togglefunctions
            end
            local callback_t
            function togglefunctions:setfunction(new)
                new = new or function() end
                callback = new
                callback_t = new
                return togglefunctions
            end
            updatepagesize()
            function togglefunctions:addkeybind(default_t)
                callback_t = callback
                default_t = default_t or Enum.KeyCode.P

                local keybind = Instance.new("TextButton")
                local keybindcorner = Instance.new("UICorner")
                local keybindbackground = Instance.new("Frame")
                local keybindgradient = Instance.new("UIGradient")
                local keybindbackcorner = Instance.new("UICorner")
                local keybindbuttonlabel = Instance.new("TextLabel")
                local keybindlabelstraint = Instance.new("UISizeConstraint")
                local keybindbackgroundstraint = Instance.new("UISizeConstraint")
                local keybindstraint = Instance.new("UISizeConstraint")

                keybind.Name = "keybind"
                keybind.Parent = extras
                keybind.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                keybind.Position = UDim2.new(0.780303001, 0, 0, 0)
                keybind.Size = UDim2.new(0, 87, 0, 22)
                keybind.AutoButtonColor = false
                keybind.Font = Enum.Font.SourceSans
                keybind.Text = ""
                keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybind.TextSize = 14.000
                keybind.Active = false

                keybindcorner.CornerRadius = UDim.new(0, 2)
                keybindcorner.Name = "keybindCorner"
                keybindcorner.Parent = keybind

                keybindbackground.Name = "keybindBackground"
                keybindbackground.Parent = keybind
                keybindbackground.AnchorPoint = Vector2.new(0.5, 0.5)
                keybindbackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                keybindbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
                keybindbackground.Size = UDim2.new(0, 85, 0, 20)

                keybindgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                keybindgradient.Rotation = 90
                keybindgradient.Name = "keybindGradient"
                keybindgradient.Parent = keybindbackground

                keybindbackcorner.CornerRadius = UDim.new(0, 2)
                keybindbackcorner.Name = "keybindBackCorner"
                keybindbackcorner.Parent = keybindbackground

                keybindbuttonlabel.Name = "keybindButtonLabel"
                keybindbuttonlabel.Parent = keybindbackground
                keybindbuttonlabel.AnchorPoint = Vector2.new(0.5, 0.5)
                keybindbuttonlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                keybindbuttonlabel.BackgroundTransparency = 1.000
                keybindbuttonlabel.ClipsDescendants = true
                keybindbuttonlabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                keybindbuttonlabel.Size = UDim2.new(0, 85, 0, 20)
                keybindbuttonlabel.Font = Enum.Font.Code
                keybindbuttonlabel.Text = ". . ."
                keybindbuttonlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                keybindbuttonlabel.TextSize = 14.000
                keybindbuttonlabel.RichText = true

                keybindlabelstraint.Name = "keybindLabelStraint"
                keybindlabelstraint.Parent = keybindbuttonlabel
                keybindlabelstraint.MinSize = Vector2.new(28, 20)

                keybindbackgroundstraint.Name = "keybindBackgroundStraint"
                keybindbackgroundstraint.Parent = keybindbackground
                keybindbackgroundstraint.MinSize = Vector2.new(28, 20)

                keybindstraint.Name = "keybindStraint"
                keybindstraint.Parent = keybind
                keybindstraint.MinSize = Vector2.new(30, 22)

                local shortcuts = {
                    return = "enter"
                }

                keybindbuttonlabel.Text = shortcuts[default_t.Name] or default_t.Name
                createtween("keybind", 0.08)

                local newkeybindsize = textservice:GetTextSize(keybindbuttonlabel.Text, keybindbuttonlabel.TextSize, keybindbuttonlabel.Font, Vector2.new(math.huge,math.huge))
                keybindbuttonlabel.Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)
                keybindbackground.Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)
                keybind.Size = UDim2.new(0, newkeybindsize.X + 8, 0, 22)

                function resizekeybind()
                    newkeybindsize = textservice:GetTextSize(keybindbuttonlabel.Text, keybindbuttonlabel.TextSize, keybindbuttonlabel.Font, Vector2.new(math.huge,math.huge))
                    tweenservice:Create(keybindbuttonlabel, tweentable["keybind"], {Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)}):Play()
                    tweenservice:Create(keybindbackground, tweentable["keybind"], {Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)}):Play()
                    tweenservice:Create(keybind, tweentable["keybind"], {Size = UDim2.new(0, newkeybindsize.X + 8, 0, 22)}):Play()
                end
                keybindbuttonlabel:GetPropertyChangedSignal("Text"):Connect(resizekeybind)
                resizekeybind()
                updatepagesize()

                local chosenkey = default_t.Name

                keybind.MouseButton1Click:Connect(function()
                    keybindbuttonlabel.Text = ". . ."
                    local inputwait = userinputservice.InputBegan:wait()
                    if userinputservice.WindowFocused and inputwait.KeyCode.Name ~= "Unknown" then
                        local result = shortcuts[inputwait.KeyCode.Name] or inputwait.KeyCode.Name
                        keybindbuttonlabel.Text = result
                        chosenkey = inputwait.KeyCode.Name
                    end
                end)

                local chattextbox = player.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
                if userinputservice.WindowFocused then
                    userinputservice.InputBegan:Connect(function(c, p)
                        if not p then
                            if c.KeyCode.Name == chosenkey and not chattextbox:IsFocused() then
                                on = not on
                                local sizeon = on and UDim2.new(0, 12, 0, 12) or UDim2.new(0, 0, 0, 0)
                                local transparency = on and 0 or 1
                                tweenservice:Create(toggledesign, tweentable["toggle_form"], {Size = sizeon}):Play()
                                tweenservice:Create(toggledesign, tweentable["toggle_form"], {BackgroundTransparency = transparency}):Play()
                                callback_t(on)
                                return
                            end
                        end
                    end)
                end

                local extrakeybindfunctions = {}
                function extrakeybindfunctions:setkey(new)
                    new = new or chosenkey.Name
                    chosenkey = new.Name
                    keybindbuttonlabel.Text = new.Name
                    return extrakeybindfunctions
                end
                function extrakeybindfunctions:fire()
                    callback_t(chosenkey)
                    return extrakeybindfunctions
                end
                function extrakeybindfunctions:setfunction(new)
                    new = new or function() end
                    callback_t = new
                    return extrakeybindfunctions
                end
                function extrakeybindfunctions:hide()
                    keybind.Visible = false
                    return extrakeybindfunctions
                end
                function extrakeybindfunctions:show()
                    keybind.Visible = true
                    return extrakeybindfunctions
                end
                return extrakeybindfunctions
            end

            if default then
                toggledesign.Size = UDim2.new(0, 12, 0, 12)
                toggledesign.BackgroundTransparency = 0
                callback(true)
            end
            return togglefunctions
        end

        function components:newkeybind(text, default, callback)
            text = text or "keybind"
            default = default or Enum.KeyCode.P
            callback = callback or function() end

            local keybindframe = Instance.new("Frame")
            local keybindbutton = Instance.new("TextButton")
            local keybindlayout = Instance.new("UIListLayout")
            local keybindlabel = Instance.new("TextLabel")
            local keybindpadding = Instance.new("UIPadding")
            local keybindfolder = Instance.new("Folder")
            local keybindfolderlayout = Instance.new("UIListLayout")
            local keybind = Instance.new("TextButton")
            local keybindcorner = Instance.new("UICorner")
            local keybindbackground = Instance.new("Frame")
            local keybindgradient = Instance.new("UIGradient")
            local keybindbackcorner = Instance.new("UICorner")
            local keybindbuttonlabel = Instance.new("TextLabel")
            local keybindlabelstraint = Instance.new("UISizeConstraint")
            local keybindbackgroundstraint = Instance.new("UISizeConstraint")
            local keybindstraint = Instance.new("UISizeConstraint")

            keybindframe.Name = "keybindFrame"
            keybindframe.Parent = page
            keybindframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindframe.BackgroundTransparency = 1.000
            keybindframe.ClipsDescendants = true
            keybindframe.Size = UDim2.new(0, 396, 0, 24)

            keybindbutton.Name = "keybindButton"
            keybindbutton.Parent = keybindframe
            keybindbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindbutton.BackgroundTransparency = 1.000
            keybindbutton.Size = UDim2.new(0, 396, 0, 24)
            keybindbutton.AutoButtonColor = false
            keybindbutton.Font = Enum.Font.SourceSans
            keybindbutton.Text = ""
            keybindbutton.TextColor3 = Color3.fromRGB(0, 0, 0)
            keybindbutton.TextSize = 14.000

            keybindlayout.Name = "keybindLayout"
            keybindlayout.Parent = keybindbutton
            keybindlayout.FillDirection = Enum.FillDirection.Horizontal
            keybindlayout.SortOrder = Enum.SortOrder.LayoutOrder
            keybindlayout.VerticalAlignment = Enum.VerticalAlignment.Center
            keybindlayout.Padding = UDim.new(0, 4)

            keybindlabel.Name = "keybindLabel"
            keybindlabel.Parent = keybindbutton
            keybindlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindlabel.BackgroundTransparency = 1.000
            keybindlabel.Size = UDim2.new(0, 396, 0, 24)
            keybindlabel.Font = Enum.Font.Code
            keybindlabel.Text = text
            keybindlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            keybindlabel.TextSize = 14.000
            keybindlabel.TextWrapped = true
            keybindlabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindlabel.RichText = true

            keybindpadding.Name = "keybindPadding"
            keybindpadding.Parent = keybindlabel
            keybindpadding.PaddingBottom = UDim.new(0, 6)
            keybindpadding.PaddingLeft = UDim.new(0, 2)
            keybindpadding.PaddingRight = UDim.new(0, 6)
            keybindpadding.PaddingTop = UDim.new(0, 6)

            keybindfolder.Name = "keybindFolder"
            keybindfolder.Parent = keybindframe

            keybindfolderlayout.Name = "keybindFolderLayout"
            keybindfolderlayout.Parent = keybindfolder
            keybindfolderlayout.FillDirection = Enum.FillDirection.Horizontal
            keybindfolderlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            keybindfolderlayout.SortOrder = Enum.SortOrder.LayoutOrder
            keybindfolderlayout.VerticalAlignment = Enum.VerticalAlignment.Center
            keybindfolderlayout.Padding = UDim.new(0, 4)

            keybind.Name = "keybind"
            keybind.Parent = keybindfolder
            keybind.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            keybind.Position = UDim2.new(0.780303001, 0, 0, 0)
            keybind.Size = UDim2.new(0, 87, 0, 22)
            keybind.AutoButtonColor = false
            keybind.Font = Enum.Font.SourceSans
            keybind.Text = ""
            keybind.TextColor3 = Color3.fromRGB(0, 0, 0)
            keybind.TextSize = 14.000
            keybind.Active = false

            keybindcorner.CornerRadius = UDim.new(0, 2)
            keybindcorner.Name = "keybindCorner"
            keybindcorner.Parent = keybind

            keybindbackground.Name = "keybindBackground"
            keybindbackground.Parent = keybind
            keybindbackground.AnchorPoint = Vector2.new(0.5, 0.5)
            keybindbackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindbackground.Position = UDim2.new(0.5, 0, 0.5, 0)
            keybindbackground.Size = UDim2.new(0, 85, 0, 20)

            keybindgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            keybindgradient.Rotation = 90
            keybindgradient.Name = "keybindGradient"
            keybindgradient.Parent = keybindbackground

            keybindbackcorner.CornerRadius = UDim.new(0, 2)
            keybindbackcorner.Name = "keybindBackCorner"
            keybindbackcorner.Parent = keybindbackground

            keybindbuttonlabel.Name = "keybindButtonLabel"
            keybindbuttonlabel.Parent = keybindbackground
            keybindbuttonlabel.AnchorPoint = Vector2.new(0.5, 0.5)
            keybindbuttonlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindbuttonlabel.BackgroundTransparency = 1.000
            keybindbuttonlabel.ClipsDescendants = true
            keybindbuttonlabel.Position = UDim2.new(0.5, 0, 0.5, 0)
            keybindbuttonlabel.Size = UDim2.new(0, 85, 0, 20)
            keybindbuttonlabel.Font = Enum.Font.Code
            keybindbuttonlabel.Text = ". . ."
            keybindbuttonlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            keybindbuttonlabel.TextSize = 14.000
            keybindbuttonlabel.RichText = true

            keybindlabelstraint.Name = "keybindLabelStraint"
            keybindlabelstraint.Parent = keybindbuttonlabel
            keybindlabelstraint.MinSize = Vector2.new(28, 20)

            keybindbackgroundstraint.Name = "keybindBackgroundStraint"
            keybindbackgroundstraint.Parent = keybindbackground
            keybindbackgroundstraint.MinSize = Vector2.new(28, 20)

            keybindstraint.Name = "keybindStraint"
            keybindstraint.Parent = keybind
            keybindstraint.MinSize = Vector2.new(30, 22)

            local shortcuts = {
                return = "enter"
            }

            keybindbuttonlabel.Text = shortcuts[default.Name] or default.Name
            createtween("keybind", 0.08)

            local newkeybindsize = textservice:GetTextSize(keybindbuttonlabel.Text, keybindbuttonlabel.TextSize, keybindbuttonlabel.Font, Vector2.new(math.huge,math.huge))
            keybindbuttonlabel.Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)
            keybindbackground.Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)
            keybind.Size = UDim2.new(0, newkeybindsize.X + 8, 0, 22)

            function resizekeybind()
                newkeybindsize = textservice:GetTextSize(keybindbuttonlabel.Text, keybindbuttonlabel.TextSize, keybindbuttonlabel.Font, Vector2.new(math.huge,math.huge))
                tweenservice:Create(keybindbuttonlabel, tweentable["keybind"], {Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)}):Play()
                tweenservice:Create(keybindbackground, tweentable["keybind"], {Size = UDim2.new(0, newkeybindsize.X + 6, 0, 20)}):Play()
                tweenservice:Create(keybind, tweentable["keybind"], {Size = UDim2.new(0, newkeybindsize.X + 8, 0, 22)}):Play()
            end
            keybindbuttonlabel:GetPropertyChangedSignal("Text"):Connect(resizekeybind)
            resizekeybind()

            local chosenkey = default
            keybindbutton.MouseButton1Click:Connect(function()
                keybindbuttonlabel.Text = "..."
                local inputwait = userinputservice.InputBegan:wait()
                if userinputservice.WindowFocused and inputwait.KeyCode.Name ~= "Unknown" then
                    local result = shortcuts[inputwait.KeyCode.Name] or inputwait.KeyCode.Name
                    keybindbuttonlabel.Text = result
                    chosenkey = inputwait.KeyCode.Name
                end
            end)

            keybind.MouseButton1Click:Connect(function()
                keybindbuttonlabel.Text = ". . ."
                local inputwait = userinputservice.InputBegan:wait()
                if userinputservice.WindowFocused and inputwait.KeyCode.Name ~= "Unknown" then
                    local result = shortcuts[inputwait.KeyCode.Name] or inputwait.KeyCode.Name
                    keybindbuttonlabel.Text = result
                    chosenkey = inputwait.KeyCode.Name
                end
            end)

            local chattextbox = player.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
            if userinputservice.WindowFocused then
                userinputservice.InputBegan:Connect(function(c, p)
                    if not p then
                        if c.KeyCode.Name == chosenkey and not chattextbox:IsFocused() then
                            callback(chosenkey)
                            return
                        end
                    end
                end)
            end

            updatepagesize()

            local keybindfunctions = {}
            function keybindfunctions:fire()
                callback(chosenkey)
                return keybindfunctions
            end
            function keybindfunctions:setfunction(new)
                new = new or function() end
                callback = new
                return keybindfunctions
            end
            function keybindfunctions:setkey(new)
                new = new or chosenkey.Name
                chosenkey = new.Name
                keybindbuttonlabel.Text = new.Name
                return keybindfunctions
            end
            function keybindfunctions:text(new)
                new = new or keybindlabel.Text
                keybindlabel.Text = new
                return keybindfunctions
            end
            function keybindfunctions:hide()
                keybindframe.Visible = false
                return keybindfunctions
            end
            function keybindfunctions:show()
                keybindframe.Visible = true
                return keybindfunctions
            end
            return keybindfunctions
        end

        function components:newtextbox(text, default, place, format, type, autoexec, autoclear, callback)
            text = text or "text box"
            default = default or ""
            place = place or ""
            format = format or "all"
            type = type or "small"
            autoexec = autoexec or true
            autoclear = autoclear or false
            callback = callback or function() end

            if type == "small" then
                local textboxframe = Instance.new("Frame")
                local textboxfolder = Instance.new("Folder")
                local textboxfolderlayout = Instance.new("UIListLayout")
                local textbox = Instance.new("Frame")
                local textboxlayout = Instance.new("UIListLayout")
                local textboxstraint = Instance.new("UISizeConstraint")
                local textboxcorner = Instance.new("UICorner")
                local textboxtwo = Instance.new("Frame")
                local textboxtwostraint = Instance.new("UISizeConstraint")
                local textboxtwogradient = Instance.new("UIGradient")
                local textboxtwocorner = Instance.new("UICorner")
                local textboxvalues = Instance.new("TextBox")
                local textboxvaluesstraint = Instance.new("UISizeConstraint")
                local textboxtwolayout = Instance.new("UIListLayout")
                local textboxlabel = Instance.new("TextLabel")
                local textboxpadding = Instance.new("UIPadding")
                local textboxvaluespadding = Instance.new("UIPadding")

                textboxframe.Name = "textboxFrame"
                textboxframe.Parent = page
                textboxframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxframe.BackgroundTransparency = 1.000
                textboxframe.ClipsDescendants = true
                textboxframe.Size = UDim2.new(0, 396, 0, 24)

                textboxfolder.Name = "textboxFolder"
                textboxfolder.Parent = textboxframe

                textboxfolderlayout.Name = "textboxFolderLayout"
                textboxfolderlayout.Parent = textboxfolder
                textboxfolderlayout.FillDirection = Enum.FillDirection.Horizontal
                textboxfolderlayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                textboxfolderlayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxfolderlayout.VerticalAlignment = Enum.VerticalAlignment.Center
                textboxfolderlayout.Padding = UDim.new(0, 4)

                textbox.Name = "textbox"
                textbox.Parent = textboxfolder
                textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                textbox.Size = UDim2.new(0, 133, 0, 22)

                textboxlayout.Name = "textboxLayout"
                textboxlayout.Parent = textbox
                textboxlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxlayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxlayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxstraint.Name = "textboxStraint"
                textboxstraint.Parent = textbox
                textboxstraint.MinSize = Vector2.new(50, 22)

                textboxcorner.CornerRadius = UDim.new(0, 2)
                textboxcorner.Name = "textboxCorner"
                textboxcorner.Parent = textbox

                textboxtwo.Name = "textboxTwo"
                textboxtwo.Parent = textbox
                textboxtwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxtwo.Size = UDim2.new(0, 131, 0, 20)

                textboxtwostraint.Name = "textboxTwoStraint"
                textboxtwostraint.Parent = textboxtwo
                textboxtwostraint.MinSize = Vector2.new(48, 20)

                textboxtwogradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                textboxtwogradient.Rotation = 90
                textboxtwogradient.Name = "textboxTwoGradient"
                textboxtwogradient.Parent = textboxtwo

                textboxtwocorner.CornerRadius = UDim.new(0, 2)
                textboxtwocorner.Name = "textboxTwoCorner"
                textboxtwocorner.Parent = textboxtwo

                textboxvalues.Name = "textBoxValues"
                textboxvalues.Parent = textboxtwo
                textboxvalues.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxvalues.BackgroundTransparency = 1.000
                textboxvalues.Position = UDim2.new(0.664141417, 0, 0.0416666679, 0)
                textboxvalues.Size = UDim2.new(0, 131, 0, 20)
                textboxvalues.Font = Enum.Font.Code
                textboxvalues.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                textboxvalues.PlaceholderText = place
                textboxvalues.Text = ""
                textboxvalues.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxvalues.TextSize = 14.000
                textboxvalues.ClearTextOnFocus = autoclear
                textboxvalues.ClipsDescendants = true
                textboxvalues.TextXAlignment = Enum.TextXAlignment.Right

                textboxvaluespadding.Name = "textBoxValuesPadding"
                textboxvaluespadding.Parent = textboxvalues
                textboxvaluespadding.PaddingBottom = UDim.new(0, 6)
                textboxvaluespadding.PaddingLeft = UDim.new(0, 6)
                textboxvaluespadding.PaddingRight = UDim.new(0, 4)
                textboxvaluespadding.PaddingTop = UDim.new(0, 6)

                textboxvaluesstraint.Name = "textBoxValuesStraint"
                textboxvaluesstraint.Parent = textboxvalues
                textboxvaluesstraint.MinSize = Vector2.new(48, 20)

                textboxtwolayout.Name = "textboxTwoLayout"
                textboxtwolayout.Parent = textboxtwo
                textboxtwolayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxtwolayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxtwolayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxlabel.Name = "textboxLabel"
                textboxlabel.Parent = textboxframe
                textboxlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxlabel.BackgroundTransparency = 1.000
                textboxlabel.Size = UDim2.new(0, 396, 0, 24)
                textboxlabel.Font = Enum.Font.Code
                textboxlabel.Text = text
                textboxlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxlabel.TextSize = 14.000
                textboxlabel.TextWrapped = true
                textboxlabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxlabel.RichText = true

                textboxpadding.Name = "textboxPadding"
                textboxpadding.Parent = textboxlabel
                textboxpadding.PaddingBottom = UDim.new(0, 6)
                textboxpadding.PaddingLeft = UDim.new(0, 2)
                textboxpadding.PaddingRight = UDim.new(0, 6)
                textboxpadding.PaddingTop = UDim.new(0, 6)

                local forcedminsize = textservice:GetTextSize(textboxvalues.PlaceholderText, textboxvalues.TextSize, textboxvalues.Font, Vector2.new(math.huge,math.huge))
                local forcedmaxsize = textservice:GetTextSize(textboxlabel.Text, textboxlabel.TextSize, textboxlabel.Font, Vector2.new(math.huge,math.huge))
                local newtextboxsize = textservice:GetTextSize(textboxvalues.Text, textboxvalues.TextSize, textboxvalues.Font, Vector2.new(math.huge,math.huge))

                createtween("TextBox", 0.07)

                textboxstraint.MinSize = Vector2.new(forcedminsize.X + 4, 22)
                textboxtwostraint.MinSize = Vector2.new(forcedminsize.X + 2, 20)
                textboxvaluesstraint.MinSize = Vector2.new(forcedminsize.X + 2, 20)
                textboxstraint.MaxSize = Vector2.new(386 - forcedmaxsize.X, 22)
                textboxtwostraint.MaxSize = Vector2.new(388 - forcedmaxsize.X, 20)
                textboxvaluesstraint.MaxSize = Vector2.new(388 - forcedmaxsize.X, 20)

                function resizetextstraints()
                    forcedminsize = textservice:GetTextSize(textboxvalues.PlaceholderText, textboxvalues.TextSize, textboxvalues.Font, Vector2.new(math.huge,math.huge))
                    if place ~= "" then
                        textboxstraint.MinSize = Vector2.new(forcedminsize.X + 10, 22)
                        textboxtwostraint.MinSize = Vector2.new(forcedminsize.X + 8, 20)
                        textboxvaluesstraint.MinSize = Vector2.new(forcedminsize.X + 8, 20)
                    else
                        textboxstraint.MinSize = Vector2.new(28, 22)
                        textboxtwostraint.MinSize = Vector2.new(26, 20)
                        textboxvaluesstraint.MinSize = Vector2.new(26, 20)
                    end
                end
                function resizetextbox()
                    newtextboxsize = textservice:GetTextSize(textboxvalues.Text, textboxvalues.TextSize, textboxvalues.Font, Vector2.new(math.huge,math.huge))
                    if newtextboxsize.X < (396 - forcedmaxsize.X) - 10 then
                        tweenservice:Create(textboxvalues, tweentable["TextBox"], {Size = UDim2.new(0, newtextboxsize.X + 8, 0, 20)}):Play()
                        tweenservice:Create(textboxtwo, tweentable["TextBox"], {Size = UDim2.new(0, newtextboxsize.X + 8, 0, 20)}):Play()
                        tweenservice:Create(textbox, tweentable["TextBox"], {Size = UDim2.new(0, newtextboxsize.X + 10, 0, 22)}):Play()
                    else
                        tweenservice:Create(textboxvalues, tweentable["TextBox"], {Size = UDim2.new(0, (396 - forcedmaxsize.X) - 12, 0, 20)}):Play()
                        tweenservice:Create(textboxtwo, tweentable["TextBox"], {Size = UDim2.new(0, (396 - forcedmaxsize.X) - 12, 0, 20)}):Play()
                        tweenservice:Create(textbox, tweentable["TextBox"], {Size = UDim2.new(0, (396 - forcedmaxsize.X) - 10, 0, 22)}):Play()
                    end
                end
                function setmaxsize()
                    forcedmaxsize = textservice:GetTextSize(textboxlabel.Text, textboxlabel.TextSize, textboxlabel.Font, Vector2.new(math.huge,math.huge))
                    local def = 396 - forcedmaxsize.X
                    textboxstraint.MaxSize = Vector2.new(def - 10, 22)
                    textboxtwostraint.MaxSize = Vector2.new(def - 12, 20)
                    textboxvaluesstraint.MaxSize = Vector2.new(def - 12, 20)
                end

                resizetextbox()
                resizetextstraints()
                setmaxsize()
                updatepagesize()

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(resizetextbox)
                textboxvalues:GetPropertyChangedSignal("Text"):Connect(setmaxsize)
                textboxvalues:GetPropertyChangedSignal("Text"):Connect(resizetextstraints)
                textboxvalues:GetPropertyChangedSignal("PlaceholderText"):Connect(resizetextstraints)
                textboxvalues:GetPropertyChangedSignal("PlaceholderText"):Connect(setmaxsize)
                textboxvalues:GetPropertyChangedSignal("PlaceholderText"):Connect(resizetextbox)
                textboxlabel:GetPropertyChangedSignal("Text"):Connect(setmaxsize)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "numbers" then
                        textboxvalues.Text = textboxvalues.Text:gsub("%D+", "")
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "lower" then
                        textboxvalues.Text = textboxvalues.Text:lower()
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "upper" then
                        textboxvalues.Text = textboxvalues.Text:upper()
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "all" or format == "" then
                        textboxvalues.Text = textboxvalues.Text
                    end
                end)

                textboxframe.MouseEnter:Connect(function()
                    tweenservice:Create(textboxlabel, tweentable["TextBox"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                end)

                textboxframe.MouseLeave:Connect(function()
                    tweenservice:Create(textboxlabel, tweentable["TextBox"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                end)

                textboxvalues.Focused:Connect(function()
                    textboxvalues:GetPropertyChangedSignal("Text"):Connect(resizetextbox)
                    tweenservice:Create(textbox, tweentable["TextBox"], {BackgroundColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                end)

                textboxvalues.FocusLost:Connect(function()
                    tweenservice:Create(textbox, tweentable["TextBox"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)

                textboxvalues.FocusLost:Connect(function(enterpressed)
                    if not autoexec then
                        if enterpressed then
                            callback(textboxvalues.Text)
                        end
                    else
                        callback(textboxvalues.Text)
                    end
                end)

                updatepagesize()

                local textboxfunctions = {}
                function textboxfunctions:input(new)
                    new = new or textboxvalues.Text
                    textboxvalues = new
                    return textboxfunctions
                end
                function textboxfunctions:fire()
                    callback(textboxvalues.Text)
                    return textboxfunctions
                end
                function textboxfunctions:setfunction(new)
                    new = new or callback
                    callback = new
                    return textboxfunctions
                end
                function textboxfunctions:text(new)
                    new = new or textboxlabel.Text
                    textboxlabel.Text = new
                    return textboxfunctions
                end
                function textboxfunctions:hide()
                    textboxframe.Visible = false
                    return textboxfunctions
                end
                function textboxfunctions:show()
                    textboxframe.Visible = true
                    return textboxfunctions
                end
                function textboxfunctions:remove()
                    textboxframe:Destroy()
                    return textboxfunctions
                end
                function textboxfunctions:place(new)
                    new = new or textboxvalues.PlaceholderText
                    textboxvalues.PlaceholderText = new
                    return textboxfunctions
                end
                return textboxfunctions
            elseif type == "medium" then
                local textboxframe = Instance.new("Frame")
                local textboxfolder = Instance.new("Folder")
                local textboxfolderlayout = Instance.new("UIListLayout")
                local textbox = Instance.new("Frame")
                local textboxlayout = Instance.new("UIListLayout")
                local textboxstraint = Instance.new("UISizeConstraint")
                local textboxcorner = Instance.new("UICorner")
                local textboxtwo = Instance.new("Frame")
                local textboxtwostraint = Instance.new("UISizeConstraint")
                local textboxtwogradient = Instance.new("UIGradient")
                local textboxtwocorner = Instance.new("UICorner")
                local textboxvalues = Instance.new("TextBox")
                local textboxvaluesstraint = Instance.new("UISizeConstraint")
                local textboxvaluespadding = Instance.new("UIPadding")
                local textboxtwolayout = Instance.new("UIListLayout")
                local textboxlabel = Instance.new("TextLabel")
                local textboxpadding = Instance.new("UIPadding")

                textboxframe.Name = "textboxFrame"
                textboxframe.Parent = page
                textboxframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxframe.BackgroundTransparency = 1.000
                textboxframe.ClipsDescendants = true
                textboxframe.Size = UDim2.new(0, 396, 0, 46)

                textboxfolder.Name = "textboxFolder"
                textboxfolder.Parent = textboxframe

                textboxfolderlayout.Name = "textboxFolderLayout"
                textboxfolderlayout.Parent = textboxfolder
                textboxfolderlayout.FillDirection = Enum.FillDirection.Horizontal
                textboxfolderlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxfolderlayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxfolderlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                textboxfolderlayout.Padding = UDim.new(0, 4)

                textbox.Name = "textbox"
                textbox.Parent = textboxfolder
                textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                textbox.Size = UDim2.new(0, 396, 0, 22)

                textboxlayout.Name = "textboxLayout"
                textboxlayout.Parent = textbox
                textboxlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxlayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxlayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxstraint.Name = "textboxStraint"
                textboxstraint.Parent = textbox
                textboxstraint.MaxSize = Vector2.new(396, 22)
                textboxstraint.MinSize = Vector2.new(396, 22)

                textboxcorner.CornerRadius = UDim.new(0, 2)
                textboxcorner.Name = "textboxCorner"
                textboxcorner.Parent = textbox

                textboxtwo.Name = "textboxTwo"
                textboxtwo.Parent = textbox
                textboxtwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxtwo.Size = UDim2.new(0, 394, 0, 20)

                textboxtwostraint.Name = "textboxTwoStraint"
                textboxtwostraint.Parent = textboxtwo
                textboxtwostraint.MaxSize = Vector2.new(394, 20)
                textboxtwostraint.MinSize = Vector2.new(394, 20)

                textboxtwogradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                textboxtwogradient.Rotation = 90
                textboxtwogradient.Name = "textboxTwoGradient"
                textboxtwogradient.Parent = textboxtwo

                textboxtwocorner.CornerRadius = UDim.new(0, 2)
                textboxtwocorner.Name = "textboxTwoCorner"
                textboxtwocorner.Parent = textboxtwo

                textboxvalues.Name = "textBoxValues"
                textboxvalues.Parent = textboxtwo
                textboxvalues.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxvalues.BackgroundTransparency = 1.000
                textboxvalues.ClipsDescendants = true
                textboxvalues.Position = UDim2.new(-0.587786257, 0, 0, 0)
                textboxvalues.Size = UDim2.new(0, 394, 0, 20)
                textboxvalues.Font = Enum.Font.Code
                textboxvalues.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                textboxvalues.PlaceholderText = place
                textboxvalues.Text = default
                textboxvalues.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxvalues.TextSize = 14.000
                textboxvalues.TextXAlignment = Enum.TextXAlignment.Left

                textboxvaluesstraint.Name = "textBoxValuesStraint"
                textboxvaluesstraint.Parent = textboxvalues
                textboxvaluesstraint.MaxSize = Vector2.new(394, 20)
                textboxvaluesstraint.MinSize = Vector2.new(394, 20)

                textboxvaluespadding.Name = "textBoxValuesPadding"
                textboxvaluespadding.Parent = textboxvalues
                textboxvaluespadding.PaddingBottom = UDim.new(0, 6)
                textboxvaluespadding.PaddingLeft = UDim.new(0, 4)
                textboxvaluespadding.PaddingRight = UDim.new(0, 6)
                textboxvaluespadding.PaddingTop = UDim.new(0, 6)

                textboxtwolayout.Name = "textboxTwoLayout"
                textboxtwolayout.Parent = textboxtwo
                textboxtwolayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxtwolayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxtwolayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxlabel.Name = "textboxLabel"
                textboxlabel.Parent = textboxframe
                textboxlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxlabel.BackgroundTransparency = 1.000
                textboxlabel.Size = UDim2.new(0, 396, 0, 24)
                textboxlabel.Font = Enum.Font.Code
                textboxlabel.Text = text
                textboxlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxlabel.TextSize = 14.000
                textboxlabel.TextWrapped = true
                textboxlabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxlabel.RichText = true

                textboxpadding.Name = "textboxPadding"
                textboxpadding.Parent = textboxlabel
                textboxpadding.PaddingBottom = UDim.new(0, 6)
                textboxpadding.PaddingLeft = UDim.new(0, 2)
                textboxpadding.PaddingRight = UDim.new(0, 6)
                textboxpadding.PaddingTop = UDim.new(0, 6)

                createtween("TextBox", 0.07)
                updatepagesize()

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "numbers" then
                        textboxvalues.Text = textboxvalues.Text:gsub("%D+", "")
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "lower" then
                        textboxvalues.Text = textboxvalues.Text:lower()
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "upper" then
                        textboxvalues.Text = textboxvalues.Text:upper()
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "all" or format == "" then
                        textboxvalues.Text = textboxvalues.Text
                    end
                end)

                textboxframe.MouseEnter:Connect(function()
                    tweenservice:Create(textboxlabel, tweentable["TextBox"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                end)

                textboxframe.MouseLeave:Connect(function()
                    tweenservice:Create(textboxlabel, tweentable["TextBox"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                end)

                textboxvalues.Focused:Connect(function()
                    tweenservice:Create(textbox, tweentable["TextBox"], {BackgroundColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                end)

                textboxvalues.FocusLost:Connect(function()
                    tweenservice:Create(textbox, tweentable["TextBox"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)

                textboxvalues.FocusLost:Connect(function(enterpressed)
                    if not autoexec then
                        if enterpressed then
                            callback(textboxvalues.Text)
                        end
                    else
                        callback(textboxvalues.Text)
                    end
                end)

                local textboxfunctions = {}
                function textboxfunctions:input(new)
                    new = new or textboxvalues.Text
                    textboxvalues = new
                    return textboxfunctions
                end
                function textboxfunctions:fire()
                    callback(textboxvalues.Text)
                    return textboxfunctions
                end
                function textboxfunctions:setfunction(new)
                    new = new or callback
                    callback = new
                    return textboxfunctions
                end
                function textboxfunctions:text(new)
                    new = new or textboxlabel.Text
                    textboxlabel.Text = new
                    return textboxfunctions
                end
                function textboxfunctions:hide()
                    textboxframe.Visible = false
                    return textboxfunctions
                end
                function textboxfunctions:show()
                    textboxframe.Visible = true
                    return textboxfunctions
                end
                function textboxfunctions:remove()
                    textboxframe:Destroy()
                    return textboxfunctions
                end
                function textboxfunctions:place(new)
                    new = new or textboxvalues.PlaceholderText
                    textboxvalues.PlaceholderText = new
                    return textboxfunctions
                end
                return textboxfunctions
            elseif type == "large" then
                local textboxframe = Instance.new("Frame")
                local textboxfolder = Instance.new("Folder")
                local textboxfolderlayout = Instance.new("UIListLayout")
                local textbox = Instance.new("Frame")
                local textboxlayout = Instance.new("UIListLayout")
                local textboxstraint = Instance.new("UISizeConstraint")
                local textboxcorner = Instance.new("UICorner")
                local textboxtwo = Instance.new("Frame")
                local textboxtwostraint = Instance.new("UISizeConstraint")
                local textboxtwogradient = Instance.new("UIGradient")
                local textboxtwocorner = Instance.new("UICorner")
                local textboxvalues = Instance.new("TextBox")
                local textboxvaluesstraint = Instance.new("UISizeConstraint")
                local textboxvaluespadding = Instance.new("UIPadding")
                local textboxtwolayout = Instance.new("UIListLayout")
                local textboxlabel = Instance.new("TextLabel")
                local textboxpadding = Instance.new("UIPadding")

                textboxframe.Name = "textboxFrame"
                textboxframe.Parent = page
                textboxframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxframe.BackgroundTransparency = 1.000
                textboxframe.ClipsDescendants = true
                textboxframe.Position = UDim2.new(0.00499999989, 0, 0.268786132, 0)
                textboxframe.Size = UDim2.new(0, 396, 0, 142)

                textboxfolder.Name = "textboxFolder"
                textboxfolder.Parent = textboxframe

                textboxfolderlayout.Name = "textboxFolderLayout"
                textboxfolderlayout.Parent = textboxfolder
                textboxfolderlayout.FillDirection = Enum.FillDirection.Horizontal
                textboxfolderlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxfolderlayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxfolderlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
                textboxfolderlayout.Padding = UDim.new(0, 4)

                textbox.Name = "textbox"
                textbox.Parent = textboxfolder
                textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                textbox.Position = UDim2.new(0, 0, 0.169014081, 0)
                textbox.Size = UDim2.new(0, 396, 0, 118)

                textboxlayout.Name = "textboxLayout"
                textboxlayout.Parent = textbox
                textboxlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxlayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxlayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxstraint.Name = "textboxStraint"
                textboxstraint.Parent = textbox
                textboxstraint.MaxSize = Vector2.new(396, 118)
                textboxstraint.MinSize = Vector2.new(396, 118)

                textboxcorner.CornerRadius = UDim.new(0, 2)
                textboxcorner.Name = "textboxCorner"
                textboxcorner.Parent = textbox

                textboxtwo.Name = "textboxTwo"
                textboxtwo.Parent = textbox
                textboxtwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxtwo.Size = UDim2.new(0, 394, 0, 114)

                textboxtwostraint.Name = "textboxTwoStraint"
                textboxtwostraint.Parent = textboxtwo
                textboxtwostraint.MaxSize = Vector2.new(394, 116)
                textboxtwostraint.MinSize = Vector2.new(394, 116)

                textboxtwogradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
                textboxtwogradient.Rotation = 90
                textboxtwogradient.Name = "textboxTwoGradient"
                textboxtwogradient.Parent = textboxtwo

                textboxtwocorner.CornerRadius = UDim.new(0, 2)
                textboxtwocorner.Name = "textboxTwoCorner"
                textboxtwocorner.Parent = textboxtwo

                textboxvalues.Name = "textBoxValues"
                textboxvalues.Parent = textboxtwo
                textboxvalues.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxvalues.BackgroundTransparency = 1.000
                textboxvalues.ClipsDescendants = true
                textboxvalues.Size = UDim2.new(0, 394, 0, 114)
                textboxvalues.Font = Enum.Font.Code
                textboxvalues.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                textboxvalues.PlaceholderText = place
                textboxvalues.Text = default
                textboxvalues.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxvalues.TextSize = 14.000
                textboxvalues.TextWrapped = true
                textboxvalues.TextXAlignment = Enum.TextXAlignment.Left
                textboxvalues.TextYAlignment = Enum.TextYAlignment.Top

                textboxvaluesstraint.Name = "textBoxValuesStraint"
                textboxvaluesstraint.Parent = textboxvalues
                textboxvaluesstraint.MaxSize = Vector2.new(394, 116)
                textboxvaluesstraint.MinSize = Vector2.new(394, 116)

                textboxvaluespadding.Name = "textBoxValuesPadding"
                textboxvaluespadding.Parent = textboxvalues
                textboxvaluespadding.PaddingBottom = UDim.new(0, 2)
                textboxvaluespadding.PaddingLeft = UDim.new(0, 2)
                textboxvaluespadding.PaddingRight = UDim.new(0, 2)
                textboxvaluespadding.PaddingTop = UDim.new(0, 2)

                textboxtwolayout.Name = "textboxTwoLayout"
                textboxtwolayout.Parent = textboxtwo
                textboxtwolayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                textboxtwolayout.SortOrder = Enum.SortOrder.LayoutOrder
                textboxtwolayout.VerticalAlignment = Enum.VerticalAlignment.Center

                textboxlabel.Name = "textboxLabel"
                textboxlabel.Parent = textboxframe
                textboxlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                textboxlabel.BackgroundTransparency = 1.000
                textboxlabel.Size = UDim2.new(0, 396, 0, 24)
                textboxlabel.Font = Enum.Font.Code
                textboxlabel.Text = text
                textboxlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
                textboxlabel.TextSize = 14.000
                textboxlabel.TextWrapped = true
                textboxlabel.TextXAlignment = Enum.TextXAlignment.Left
                textboxlabel.RichText = true

                textboxpadding.Name = "textboxPadding"
                textboxpadding.Parent = textboxlabel
                textboxpadding.PaddingBottom = UDim.new(0, 6)
                textboxpadding.PaddingLeft = UDim.new(0, 2)
                textboxpadding.PaddingRight = UDim.new(0, 6)
                textboxpadding.PaddingTop = UDim.new(0, 6)

                createtween("TextBox", 0.07)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "numbers" then
                        textboxvalues.Text = textboxvalues.Text:gsub("%D+", "")
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "lower" then
                        textboxvalues.Text = textboxvalues.Text:lower()
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "upper" then
                        textboxvalues.Text = textboxvalues.Text:upper()
                    end
                end)

                textboxvalues:GetPropertyChangedSignal("Text"):Connect(function()
                    if format == "all" or format == "" then
                        textboxvalues.Text = textboxvalues.Text
                    end
                end)

                textboxframe.MouseEnter:Connect(function()
                    tweenservice:Create(textboxlabel, tweentable["TextBox"], {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()
                end)

                textboxframe.MouseLeave:Connect(function()
                    tweenservice:Create(textboxlabel, tweentable["TextBox"], {TextColor3 = Color3.fromRGB(190, 190, 190)}):Play()
                end)

                textboxvalues.Focused:Connect(function()
                    tweenservice:Create(textbox, tweentable["TextBox"], {BackgroundColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                end)

                textboxvalues.FocusLost:Connect(function()
                    tweenservice:Create(textbox, tweentable["TextBox"], {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                end)

                textboxvalues.FocusLost:Connect(function(enterpressed)
                    if not autoexec then
                        if enterpressed then
                            callback(textboxvalues.Text)
                        end
                    else
                        callback(textboxvalues.Text)
                    end
                end)

                updatepagesize()

                local textboxfunctions = {}
                function textboxfunctions:input(new)
                    new = new or textboxvalues.Text
                    textboxvalues = new
                    return textboxfunctions
                end
                function textboxfunctions:fire()
                    callback(textboxvalues.Text)
                    return textboxfunctions
                end
                function textboxfunctions:setfunction(new)
                    new = new or callback
                    callback = new
                    return textboxfunctions
                end
                function textboxfunctions:text(new)
                    new = new or textboxlabel.Text
                    textboxlabel.Text = new
                    return textboxfunctions
                end
                function textboxfunctions:hide()
                    textboxframe.Visible = false
                    return textboxfunctions
                end
                function textboxfunctions:show()
                    textboxframe.Visible = true
                    return textboxfunctions
                end
                function textboxfunctions:remove()
                    textboxframe:Destroy()
                    return textboxfunctions
                end
                function textboxfunctions:place(new)
                    new = new or textboxvalues.PlaceholderText
                    textboxvalues.PlaceholderText = new
                    return textboxfunctions
                end
                return textboxfunctions
            end
        end

        function components:newselector(text, default, list, callback)
            text = text or "selector"
            default = default or ". . ."
            list = list or {}
            callback = callback or function() end

            local selectorframe = Instance.new("Frame")
            local selectorlabel = Instance.new("TextLabel")
            local selectorlabelpadding = Instance.new("UIPadding")
            local selectorframelayout = Instance.new("UIListLayout")
            local selector = Instance.new("TextButton")
            local selectorcorner = Instance.new("UICorner")
            local selectorlayout = Instance.new("UIListLayout")
            local selectorpadding = Instance.new("UIPadding")
            local selectortwo = Instance.new("Frame")
            local selectortext = Instance.new("TextLabel")
            local textboxvaluespadding = Instance.new("UIPadding")
            local frame = Instance.new("Frame")
            local selectortwolayout = Instance.new("UIListLayout")
            local selectortwogradient = Instance.new("UIGradient")
            local selectortwocorner = Instance.new("UICorner")
            local selectorpadding_2 = Instance.new("UIPadding")
            local selectorcontainer = Instance.new("Frame")
            local selectortwolayout_2 = Instance.new("UIListLayout")

            selectorframe.Name = "selectorFrame"
            selectorframe.Parent = page
            selectorframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorframe.BackgroundTransparency = 1.000
            selectorframe.ClipsDescendants = true
            selectorframe.Position = UDim2.new(0.00499999989, 0, 0.0895953774, 0)
            selectorframe.Size = UDim2.new(0, 396, 0, 46)

            selectorlabel.Name = "selectorLabel"
            selectorlabel.Parent = selectorframe
            selectorlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorlabel.BackgroundTransparency = 1.000
            selectorlabel.Size = UDim2.new(0, 396, 0, 24)
            selectorlabel.Font = Enum.Font.Code
            selectorlabel.Text = text
            selectorlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            selectorlabel.TextSize = 14.000
            selectorlabel.TextWrapped = true
            selectorlabel.TextXAlignment = Enum.TextXAlignment.Left
            selectorlabel.RichText = true

            selectorlabelpadding.Name = "selectorLabelPadding"
            selectorlabelpadding.Parent = selectorlabel
            selectorlabelpadding.PaddingBottom = UDim.new(0, 6)
            selectorlabelpadding.PaddingLeft = UDim.new(0, 2)
            selectorlabelpadding.PaddingRight = UDim.new(0, 6)
            selectorlabelpadding.PaddingTop = UDim.new(0, 6)

            selectorframelayout.Name = "selectorFrameLayout"
            selectorframelayout.Parent = selectorframe
            selectorframelayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectorframelayout.SortOrder = Enum.SortOrder.LayoutOrder

            selector.Name = "selector"
            selector.Parent = selectorframe
            selector.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            selector.ClipsDescendants = true
            selector.Position = UDim2.new(0, 0, 0.0926640928, 0)
            selector.Size = UDim2.new(0, 396, 0, 21)
            selector.AutoButtonColor = false
            selector.Font = Enum.Font.SourceSans
            selector.Text = ""
            selector.TextColor3 = Color3.fromRGB(0, 0, 0)
            selector.TextSize = 14.000

            selectorcorner.CornerRadius = UDim.new(0, 2)
            selectorcorner.Name = "selectorCorner"
            selectorcorner.Parent = selector

            selectorlayout.Name = "selectorLayout"
            selectorlayout.Parent = selector
            selectorlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectorlayout.SortOrder = Enum.SortOrder.LayoutOrder

            selectorpadding.Name = "selectorPadding"
            selectorpadding.Parent = selector
            selectorpadding.PaddingTop = UDim.new(0, 1)

            selectortwo.Name = "selectorTwo"
            selectortwo.Parent = selector
            selectortwo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectortwo.ClipsDescendants = true
            selectortwo.Position = UDim2.new(0.00252525252, 0, 0, 0)
            selectortwo.Size = UDim2.new(0, 394, 0, 20)

            selectortext.Name = "selectorText"
            selectortext.Parent = selectortwo
            selectortext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectortext.BackgroundTransparency = 1.000
            selectortext.Size = UDim2.new(0, 394, 0, 20)
            selectortext.Font = Enum.Font.Code
            selectortext.LineHeight = 1.150
            selectortext.TextColor3 = Color3.fromRGB(160, 160, 160)
            selectortext.TextSize = 14.000
            selectortext.TextXAlignment = Enum.TextXAlignment.Left
            selectortext.Text = default

            textboxvaluespadding.Name = "textBoxValuesPadding"
            textboxvaluespadding.Parent = selectortext
            textboxvaluespadding.PaddingBottom = UDim.new(0, 6)
            textboxvaluespadding.PaddingLeft = UDim.new(0, 6)
            textboxvaluespadding.PaddingRight = UDim.new(0, 6)
            textboxvaluespadding.PaddingTop = UDim.new(0, 6)

            frame.Parent = selectortext
            frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            frame.BorderSizePixel = 0
            frame.Position = UDim2.new(-0.008, 0, 1.78, 0)
            frame.Size = UDim2.new(0, 388, 0, 1)

            selectortwolayout.Name = "selectorTwoLayout"
            selectortwolayout.Parent = selectortwo
            selectortwolayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectortwolayout.SortOrder = Enum.SortOrder.LayoutOrder

            selectortwogradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            selectortwogradient.Rotation = 90
            selectortwogradient.Name = "selectorTwoGradient"
            selectortwogradient.Parent = selectortwo

            selectortwocorner.CornerRadius = UDim.new(0, 2)
            selectortwocorner.Name = "selectorTwoCorner"
            selectortwocorner.Parent = selectortwo

            selectorpadding_2.Name = "selectorPadding"
            selectorpadding_2.Parent = selectortwo
            selectorpadding_2.PaddingTop = UDim.new(0, 1)

            selectorcontainer.Name = "selectorContainer"
            selectorcontainer.Parent = selectortwo
            selectorcontainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            selectorcontainer.BackgroundTransparency = 1.000
            selectorcontainer.Size = UDim2.new(0, 394, 0, 20)

            selectortwolayout_2.Name = "selectorTwoLayout"
            selectortwolayout_2.Parent = selectorcontainer
            selectortwolayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
            selectortwolayout_2.SortOrder = Enum.SortOrder.LayoutOrder

            createtween("selector", 0.08)

            selectorcontainer.ChildAdded:Connect(updatepagesize)
            selectorcontainer.ChildRemoved:Connect(updatepagesize)

            updatepagesize()

            local amount = #list
            local val = (amount * 20)
            function checksizes()
                amount = #list
                val = (amount * 20) + 20
            end
            for i,v in next, list do
                local optionbutton = Instance.new("TextButton")

                optionbutton.Name = "optionButton"
                optionbutton.Parent = selectorcontainer
                optionbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                optionbutton.BackgroundTransparency = 1.000
                optionbutton.Size = UDim2.new(0, 394, 0, 20)
                optionbutton.AutoButtonColor = false
                optionbutton.Font = Enum.Font.Code
                optionbutton.Text = v
                optionbutton.TextColor3 = Color3.fromRGB(160, 160, 160)
                optionbutton.TextSize = 14.000
                if optionbutton.Text == default then
                    optionbutton.TextColor3 = Color3.fromRGB(159, 115, 255)
                    callback(selectortext.Text)
                end

                optionbutton.MouseButton1Click:Connect(function()
                    for z,x in next, selectorcontainer:GetChildren() do
                        if x:IsA("TextButton") then
                            tweenservice:Create(x, tweentable["selector"], {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
                        end
                    end
                    tweenservice:Create(optionbutton, tweentable["selector"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                    selectortext.Text = optionbutton.Text
                    callback(optionbutton.Text)
                end)

                selectorcontainer.Size = UDim2.new(0, 394, 0, val)
                selectortwo.Size = UDim2.new(0, 394, 0, val)
                selector.Size = UDim2.new(0, 396, 0, val + 2)
                selectorframe.Size = UDim2.new(0, 396, 0, val + 26)

                updatepagesize()
                checksizes()
            end

            updatepagesize()
            local selectorfunctions = {}
            local addamount = 0
            function selectorfunctions:addoption(new, callback_f)
                new = new or "option"
                list[new] = new

                local optionbutton = Instance.new("TextButton")

                addamount = addamount + 20

                optionbutton.Name = "optionButton"
                optionbutton.Parent = selectorcontainer
                optionbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                optionbutton.BackgroundTransparency = 1.000
                optionbutton.Size = UDim2.new(0, 394, 0, 20)
                optionbutton.AutoButtonColor = false
                optionbutton.Font = Enum.Font.Code
                optionbutton.Text = new
                optionbutton.TextColor3 = Color3.fromRGB(140, 140, 140)
                optionbutton.TextSize = 14.000
                if optionbutton.Text == default then
                    optionbutton.TextColor3 = Color3.fromRGB(159, 115, 255)
                    callback(selectortext.Text)
                end

                optionbutton.MouseButton1Click:Connect(function()
                    for z,x in next, selectorcontainer:GetChildren() do
                        if x:IsA("TextButton") then
                            tweenservice:Create(x, tweentable["selector"], {TextColor3 = Color3.fromRGB(140, 140, 140)}):Play()
                        end
                    end
                    tweenservice:Create(optionbutton, tweentable["selector"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()
                    selectortext.Text = optionbutton.Text
                    callback(optionbutton.Text)
                end)

                checksizes()
                selectorcontainer.Size = UDim2.new(0, 394, 0, val + addamount)
                selectortwo.Size = UDim2.new(0, 394, 0, val + addamount)
                selector.Size = UDim2.new(0, 396, 0, (val + addamount) + 2)
                selectorframe.Size = UDim2.new(0, 396, 0, (val + addamount) + 26)

                updatepagesize()
                checksizes()
                return selectorfunctions
            end
            local removeamount = 0
            function selectorfunctions:removeoption(option)
                list[option] = nil

                removeamount = removeamount + 20
                addamount = addamount - 20

                for i,v in pairs(selectorcontainer:GetDescendants()) do
                    if v:IsA("TextButton") then
                        if v.Text == option then
                            v:Destroy()
                            selectorcontainer.Size = UDim2.new(0, 394, 0, val - removeamount)
                            selectortwo.Size = UDim2.new(0, 394, 0, val - removeamount)
                            selector.Size = UDim2.new(0, 396, 0, (val - removeamount) + 2)
                            selectorframe.Size = UDim2.new(0, 396, 0, (val + 6) - 20)
                        end
                    end
                end

                if selectortext.Text == option then
                    selectortext.Text = ". . ."
                end

                updatepagesize()
                checksizes()
                return selectorfunctions
            end
            function selectorfunctions:setfunction(new)
                new = new or callback
                callback = new
                return selectorfunctions
            end
            function selectorfunctions:text(new)
                new = new or selectorlabel.Text
                selectorlabel.Text = new
                return selectorfunctions
            end
            function selectorfunctions:hide()
                selectorframe.Visible = false
                return selectorfunctions
            end
            function selectorfunctions:show()
                selectorframe.Visible = true
                return selectorfunctions
            end
            function selectorfunctions:remove()
                selectorframe:Destroy()
                return selectorfunctions
            end
            return selectorfunctions
        end

        function components:newslider(text, suffix, compare, comparesign, values, callback)
            text = text or "slider"
            suffix = suffix or ""
            compare = compare or false
            comparesign = comparesign or "/"
            values = values or {
                min = values.min or 0,
                max = values.max or 100,
                default = values.default or 0
            }
            callback = callback or function() end

            values.max = values.max + 1

            local sliderframe = Instance.new("Frame")
            local sliderfolder = Instance.new("Folder")
            local textboxfolderlayout = Instance.new("UIListLayout")
            local sliderbutton = Instance.new("TextButton")
            local sliderbuttoncorner = Instance.new("UICorner")
            local sliderbackground = Instance.new("Frame")
            local sliderbuttoncorner_2 = Instance.new("UICorner")
            local sliderbackgroundgradient = Instance.new("UIGradient")
            local sliderbackgroundlayout = Instance.new("UIListLayout")
            local sliderindicator = Instance.new("Frame")
            local sliderindicatorstraint = Instance.new("UISizeConstraint")
            local sliderindicatorgradient = Instance.new("UIGradient")
            local sliderindicatorcorner = Instance.new("UICorner")
            local sliderbackgroundpadding = Instance.new("UIPadding")
            local sliderbuttonlayout = Instance.new("UIListLayout")
            local sliderlabel = Instance.new("TextLabel")
            local sliderpadding = Instance.new("UIPadding")
            local slidervalue = Instance.new("TextLabel")

            sliderframe.Name = "sliderFrame"
            sliderframe.Parent = page
            sliderframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderframe.BackgroundTransparency = 1.000
            sliderframe.ClipsDescendants = true
            sliderframe.Position = UDim2.new(0.00499999989, 0, 0.667630076, 0)
            sliderframe.Size = UDim2.new(0, 396, 0, 40)

            sliderfolder.Name = "sliderFolder"
            sliderfolder.Parent = sliderframe

            textboxfolderlayout.Name = "textboxFolderLayout"
            textboxfolderlayout.Parent = sliderfolder
            textboxfolderlayout.FillDirection = Enum.FillDirection.Horizontal
            textboxfolderlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            textboxfolderlayout.SortOrder = Enum.SortOrder.LayoutOrder
            textboxfolderlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
            textboxfolderlayout.Padding = UDim.new(0, 4)

            sliderbutton.Name = "sliderButton"
            sliderbutton.Parent = sliderfolder
            sliderbutton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            sliderbutton.Position = UDim2.new(0.348484844, 0, 0.600000024, 0)
            sliderbutton.Size = UDim2.new(0, 396, 0, 16)
            sliderbutton.AutoButtonColor = false
            sliderbutton.Font = Enum.Font.SourceSans
            sliderbutton.Text = ""
            sliderbutton.TextColor3 = Color3.fromRGB(0, 0, 0)
            sliderbutton.TextSize = 14.000

            sliderbuttoncorner.CornerRadius = UDim.new(0, 2)
            sliderbuttoncorner.Name = "sliderButtonCorner"
            sliderbuttoncorner.Parent = sliderbutton

            sliderbackground.Name = "sliderBackground"
            sliderbackground.Parent = sliderbutton
            sliderbackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderbackground.Size = UDim2.new(0, 394, 0, 14)
            sliderbackground.ClipsDescendants = true

            sliderbuttoncorner_2.CornerRadius = UDim.new(0, 2)
            sliderbuttoncorner_2.Name = "sliderButtonCorner"
            sliderbuttoncorner_2.Parent = sliderbackground

            sliderbackgroundgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(34, 34, 34)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 28, 28))}
            sliderbackgroundgradient.Rotation = 90
            sliderbackgroundgradient.Name = "sliderBackgroundGradient"
            sliderbackgroundgradient.Parent = sliderbackground

            sliderbackgroundlayout.Name = "sliderBackgroundLayout"
            sliderbackgroundlayout.Parent = sliderbackground
            sliderbackgroundlayout.SortOrder = Enum.SortOrder.LayoutOrder
            sliderbackgroundlayout.VerticalAlignment = Enum.VerticalAlignment.Center

            sliderindicator.Name = "sliderIndicator"
            sliderindicator.Parent = sliderbackground
            sliderindicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderindicator.BorderSizePixel = 0
            sliderindicator.Position = UDim2.new(0, 0, -0.100000001, 0)
            sliderindicator.Size = UDim2.new(0, 0, 0, 12)

            sliderindicatorstraint.Name = "sliderIndicatorStraint"
            sliderindicatorstraint.Parent = sliderindicator
            sliderindicatorstraint.MaxSize = Vector2.new(392, 12)

            sliderindicatorgradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(159, 115, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(128, 94, 208))}
            sliderindicatorgradient.Rotation = 90
            sliderindicatorgradient.Name = "sliderIndicatorGradient"
            sliderindicatorgradient.Parent = sliderindicator

            sliderindicatorcorner.CornerRadius = UDim.new(0, 2)
            sliderindicatorcorner.Name = "sliderIndicatorCorner"
            sliderindicatorcorner.Parent = sliderindicator

            sliderbackgroundpadding.Name = "sliderBackgroundPadding"
            sliderbackgroundpadding.Parent = sliderbackground
            sliderbackgroundpadding.PaddingBottom = UDim.new(0, 2)
            sliderbackgroundpadding.PaddingLeft = UDim.new(0, 1)
            sliderbackgroundpadding.PaddingRight = UDim.new(0, 1)
            sliderbackgroundpadding.PaddingTop = UDim.new(0, 2)

            sliderbuttonlayout.Name = "sliderButtonLayout"
            sliderbuttonlayout.Parent = sliderbutton
            sliderbuttonlayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sliderbuttonlayout.SortOrder = Enum.SortOrder.LayoutOrder
            sliderbuttonlayout.VerticalAlignment = Enum.VerticalAlignment.Center

            sliderlabel.Name = "sliderLabel"
            sliderlabel.Parent = sliderframe
            sliderlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderlabel.BackgroundTransparency = 1.000
            sliderlabel.Size = UDim2.new(0, 396, 0, 24)
            sliderlabel.Font = Enum.Font.Code
            sliderlabel.Text = text
            sliderlabel.TextColor3 = Color3.fromRGB(190, 190, 190)
            sliderlabel.TextSize = 14.000
            sliderlabel.TextWrapped = true
            sliderlabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderlabel.RichText = true

            sliderpadding.Name = "sliderPadding"
            sliderpadding.Parent = sliderlabel
            sliderpadding.PaddingBottom = UDim.new(0, 6)
            sliderpadding.PaddingLeft = UDim.new(0, 2)
            sliderpadding.PaddingRight = UDim.new(0, 6)
            sliderpadding.PaddingTop = UDim.new(0, 6)

            slidervalue.Name = "sliderValue"
            slidervalue.Parent = sliderlabel
            slidervalue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            slidervalue.BackgroundTransparency = 1.000
            slidervalue.Position = UDim2.new(0.577319562, 0, 0, 0)
            slidervalue.Size = UDim2.new(0, 169, 0, 15)
            slidervalue.Font = Enum.Font.Code
            slidervalue.Text = values.default
            slidervalue.TextColor3 = Color3.fromRGB(140, 140, 140)
            slidervalue.TextSize = 14.000
            slidervalue.TextXAlignment = Enum.TextXAlignment.Right

            local calc1 = values.max - values.min
            local calc2 = values.default - values.min
            local calc3 = calc2 / calc1
            local calc4 = calc3 * sliderbackground.AbsoluteSize.X
            local calculation = calc4
            sliderindicator.Size = UDim2.new(0, calculation, 0, 12)
            slidervalue.Text = values.default

            createtween("slider_drag", 0.008)

            local valuenum = values.default
            local slidtext = compare and valuenum .. comparesign .. tostring(values.max - 1) .. suffix or valuenum .. suffix
            slidervalue.Text = slidtext
            local function updateslider()
                tweenservice:Create(sliderindicator, tweentable["slider_drag"], {Size = UDim2.new(0, math.clamp(mouse.X - sliderindicator.AbsolutePosition.X, 0, sliderbackground.AbsoluteSize.X), 0, 12)}):Play()

                valuenum = math.floor((((tonumber(values.max) - tonumber(values.min)) / sliderbackground.AbsoluteSize.X) * sliderindicator.AbsoluteSize.X) + tonumber(values.min)) or 0.00

                local slidtext = compare and valuenum .. comparesign .. tostring(values.max - 1) .. suffix or valuenum .. suffix

                slidervalue.Text = slidtext

                pcall(function()
                    callback(valuenum)
                end)

                slidervalue.Text = slidtext

                moveconnection = mouse.Move:Connect(function()
                    valuenum = math.floor((((tonumber(values.max) - tonumber(values.min)) / sliderbackground.AbsoluteSize.X) * sliderindicator.AbsoluteSize.X) + tonumber(values.min))

                    slidtext = compare and valuenum .. comparesign .. tostring(values.max - 1) .. suffix or valuenum .. suffix
                    slidervalue.Text = slidtext

                    pcall(function()
                        callback(valuenum)
                    end)

                    tweenservice:Create(sliderindicator, tweentable["slider_drag"], {Size = UDim2.new(0, math.clamp(mouse.X - sliderindicator.AbsolutePosition.X, 0, sliderbackground.AbsoluteSize.X), 0, 12)}):Play()
                    if not userinputservice.WindowFocused then
                        moveconnection:Disconnect()
                    end
                end)

                releaseconnection = userinputservice.InputEnded:Connect(function(mouse_2)
                    if mouse_2.UserInputType == Enum.UserInputType.MouseButton1 then
                        valuenum = math.floor((((tonumber(values.max) - tonumber(values.min)) / sliderbackground.AbsoluteSize.X) * sliderindicator.AbsoluteSize.X) + tonumber(values.min))

                        slidtext = compare and valuenum .. comparesign .. tostring(values.max - 1) .. suffix or valuenum .. suffix
                        slidervalue.Text = slidtext

                        pcall(function()
                            callback(valuenum)
                        end)

                        tweenservice:Create(sliderindicator, tweentable["slider_drag"], {Size = UDim2.new(0, math.clamp(mouse.X - sliderindicator.AbsolutePosition.X, 0, sliderbackground.AbsoluteSize.X), 0, 12)}):Play()
                        moveconnection:Disconnect()
                        releaseconnection:Disconnect()
                    end
                end)
            end

            sliderbutton.MouseButton1Down:Connect(function()
                updateslider()
            end)

            updatepagesize()

            local sliderfunctions = {}
            function sliderfunctions:value(new)
                local ncalc1 = new - values.min
                local ncalc2 = ncalc1 / calc1
                local ncalc3 = ncalc2 * sliderbackground.AbsoluteSize.X
                local ncalculation = ncalc3
                sliderindicator.Size = UDim2.new(0, ncalculation, 0, 12)
                slidtext = compare and new .. comparesign .. tostring(values.max - 1) .. suffix or new .. suffix
                slidervalue.Text = slidtext
                return sliderfunctions
            end
            function sliderfunctions:max(new)
                new = new or values.max
                values.max = new + 1
                slidtext = compare and valuenum .. comparesign .. tostring(values.max - 1) .. suffix or valuenum .. suffix
                return sliderfunctions
            end
            function sliderfunctions:min(new)
                new = new or values.min
                values.min = new
                slidtext = compare and new .. comparesign .. tostring(values.max - 1) .. suffix or valuenum .. suffix
                tweenservice:Create(sliderindicator, tweentable["slider_drag"], {Size = UDim2.new(0, math.clamp(mouse.X - sliderindicator.AbsolutePosition.X, 0, sliderbackground.AbsoluteSize.X), 0, 12)}):Play()
                return sliderfunctions
            end
            function sliderfunctions:setfunction(new)
                new = new or callback
                callback = new
                return sliderfunctions
            end
            function sliderfunctions:text(new)
                new = new or sliderlabel.Text
                sliderlabel.Text = new
                return sliderfunctions
            end
            function sliderfunctions:hide()
                sliderframe.Visible = false
                return sliderfunctions
            end
            function sliderfunctions:show()
                sliderframe.Visible = true
                return sliderfunctions
            end
            function sliderfunctions:remove()
                sliderframe:Destroy()
                return sliderfunctions
            end
            return sliderfunctions
        end

        function components:newseperator()
            local sectionframe = Instance.new("Frame")
            local sectionlayout = Instance.new("UIListLayout")
            local rightbar = Instance.new("Frame")

            sectionframe.Name = "sectionFrame"
            sectionframe.Parent = page
            sectionframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sectionframe.BackgroundTransparency = 1.000
            sectionframe.ClipsDescendants = true
            sectionframe.Position = UDim2.new(0.00499999989, 0, 0.361271679, 0)
            sectionframe.Size = UDim2.new(0, 396, 0, 12)

            sectionlayout.Name = "sectionLayout"
            sectionlayout.Parent = sectionframe
            sectionlayout.FillDirection = Enum.FillDirection.Horizontal
            sectionlayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlayout.VerticalAlignment = Enum.VerticalAlignment.Center
            sectionlayout.Padding = UDim.new(0, 4)

            rightbar.Name = "rightBar"
            rightbar.Parent = sectionframe
            rightbar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            rightbar.BorderSizePixel = 0
            rightbar.Position = UDim2.new(0.308080822, 0, 0.479166657, 0)
            rightbar.Size = UDim2.new(0, 403, 0, 1)

            updatepagesize()

            local seperatorfunctions = {}
            function seperatorfunctions:hide()
                sectionframe.Visible = false
                return seperatorfunctions
            end
            function seperatorfunctions:show()
                sectionframe.Visible = true
                return seperatorfunctions
            end
            function seperatorfunctions:remove()
                sectionframe:Destroy()
                return seperatorfunctions
            end
            return seperatorfunctions
        end

        function components:open()
            tablibrary.currenttab = title
            for i,v in pairs(container:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            page.Visible = true

            for i,v in pairs(tabbuttons:GetChildren()) do
                if v:IsA("TextButton") then
                    tweenservice:Create(v, tweentable["tab_text_colour"], {TextColor3 = Color3.fromRGB(170, 170, 170)}):Play()
                end
            end
            tweenservice:Create(tabbutton, tweentable["tab_text_colour"], {TextColor3 = Color3.fromRGB(159, 115, 255)}):Play()

            return components
        end
        function components:remove()
            tabbutton:Destroy()
            page:Destroy()
            return components
        end
        function components:hide()
            tabbutton.Visible = false
            page.Visible = false
            return components
        end
        function components:show()
            tabbutton.Visible = true
            return components
        end
        function components:text(text)
            text = text or "new text"
            tabbutton.Text = text
            return components
        end
        return components
    end
    function tablibrary:remove()
        screen:Destroy()
        return tablibrary
    end
    function tablibrary:text(text)
        text = text or "new text"
        headerlabel.Text = text
        return tablibrary
    end
    function tablibrary:updatekeybind(new)
        new = new or key
        key = new
        return tablibrary
    end
    return tablibrary
end
return library
