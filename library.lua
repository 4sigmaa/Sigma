local clonerer = (cloneref or clonereference or function(instance)
    return instance
end)
local CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local SoundService = cloneref(game:GetService("SoundService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TextService = cloneref(game:GetService("TextService"))
local Teams = cloneref(game:GetService("Teams"))
local TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local DefaultWindowSize = IsMobile and UDim2.fromOffset(640, 600) or UDim2.fromOffset(720, 600)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sigma"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ScreenGui.Parent = gethui()
end)
pcall(protectgui, ScreenGui)

local Colors = {
    Background = Color3.fromRGB(18, 18, 18),
    Sidebar = Color3.fromRGB(26, 26, 26),
    Panel = Color3.fromRGB(36, 36, 36),
    Element = Color3.fromRGB(48, 48, 48),
    ElementHover = Color3.fromRGB(64, 64, 64),
    Text = Color3.fromRGB(235, 235, 235),
    TextDim = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(130, 130, 130),
    Divider = Color3.fromRGB(62, 62, 62),
    ToggleOn = Color3.fromRGB(95, 165, 95),
    Danger = Color3.fromRGB(180, 70, 70),
    Success = Color3.fromRGB(95, 165, 95),
}

local Easing = {
    Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.30, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Slide = TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

local Library = {}
Library.ScreenGui = ScreenGui
Library.Colors = Colors
Library.Easing = Easing
Library.IsMobile = IsMobile
Library.Flags = {}
Library.Tabs = {}
Library.OpenDropdowns = {}
Library.Connections = {}
Library.Windows = {}

local function Create(ClassName, Properties, Children)
    local Instance = Instance.new(ClassName)
    for PropertyName, PropertyValue in pairs(Properties or {}) do
        if PropertyName ~= "Parent" then
            Instance[PropertyName] = PropertyValue
        end
    end
    for _, Child in ipairs(Children or {}) do
        Child.Parent = Instance
    end
    if Properties and Properties.Parent then
        Instance.Parent = Properties.Parent
    end
    return Instance
end

local function CreateCorner(CornerRadius, Parent)
    return Create("UICorner", {
        CornerRadius = CornerRadius or UDim.new(0, 3),
        Parent = Parent,
    })
end

local function CreateStroke(StrokeColor, Thickness, Parent)
    return Create("UIStroke", {
        Color = StrokeColor,
        Thickness = Thickness or 1,
        Parent = Parent,
    })
end

local function CreatePadding(PaddingTop, PaddingBottom, PaddingLeft, PaddingRight, Parent)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, PaddingTop or 0),
        PaddingBottom = UDim.new(0, PaddingBottom or 0),
        PaddingLeft = UDim.new(0, PaddingLeft or 0),
        PaddingRight = UDim.new(0, PaddingRight or 0),
        Parent = Parent,
    })
end

local function CreateListLayout(SortOrder, Padding, Parent)
    return Create("UIListLayout", {
        Padding = UDim.new(0, Padding or 0),
        SortOrder = SortOrder or Enum.SortOrder.LayoutOrder,
        Parent = Parent,
    })
end

local function CloseAllDropdowns()
    for Index = #Library.OpenDropdowns, 1, -1 do
        local DropdownEntry = Library.OpenDropdowns[Index]
        if DropdownEntry.ListFrame and DropdownEntry.ListFrame.Parent then
            DropdownEntry.ListFrame:Destroy()
        end
        if DropdownEntry.OnClose then
            DropdownEntry.OnClose()
        end
        table.remove(Library.OpenDropdowns, Index)
    end
end

Library.CloseAllDropdowns = CloseAllDropdowns

local function MakeDraggable(TargetFrame, DragHandle)
    DragHandle = DragHandle or TargetFrame
    local IsDragging = false
    local DragStart = nil
    local StartPosition = nil
    local BeginConnection = nil

    DragHandle.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            DragStart = Input.Position
            StartPosition = TargetFrame.Position

            BeginConnection = Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    IsDragging = false
                    if BeginConnection then
                        BeginConnection:Disconnect()
                        BeginConnection = nil
                    end
                end
            end)
        end
    end)

    local ChangeConnection = UserInputService.InputChanged:Connect(function(Input)
        if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - DragStart
            TargetFrame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    table.insert(Library.Connections, ChangeConnection)
    return ChangeConnection
end

Library.MakeDraggable = MakeDraggable

local Window = {}
Window.__index = Window

function Library:CreateWindow(Options)
    Options = Options or {}
    local WindowTitle = Options.Title or "Sigma"
    local WindowSubtitle = Options.Subtitle or "Library"
    local WindowSize = Options.Size or DefaultWindowSize
    local ToggleKey = Options.ToggleKey or Enum.KeyCode.RightShift

    local NewWindow = setmetatable({}, Window)
    NewWindow.Title = WindowTitle
    NewWindow.Subtitle = WindowSubtitle
    NewWindow.Size = WindowSize
    NewWindow.Tabs = {}
    NewWindow.TabButtons = {}
    NewWindow.TabIndicators = {}
    NewWindow.ActiveTab = nil
    NewWindow.IsTransitioning = false
    NewWindow.ToggleKey = ToggleKey

    local MainFrame = Create("Frame", {
        Name = WindowTitle .. "Window",
        Size = UDim2.fromOffset(WindowSize.X.Offset - 30, WindowSize.Y.Offset - 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Colors.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
        Parent = ScreenGui,
    })
    CreateCorner(UDim.new(0, 3), MainFrame)
    CreateStroke(Colors.Divider, 1, MainFrame)

    NewWindow.Frame = MainFrame

    TweenService:Create(MainFrame, Easing.Smooth, {
        BackgroundTransparency = 0,
        Size = WindowSize,
    }):Play()

    local SidebarWidth = 180

    local SidebarFrame = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, SidebarWidth, 1, 0),
        BackgroundColor3 = Colors.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = MainFrame,
    })
    CreateCorner(UDim.new(0, 3), SidebarFrame)

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 30),
        Position = UDim2.new(0, 15, 0, 10),
        BackgroundTransparency = 1,
        Text = WindowTitle,
        TextColor3 = Colors.Text,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = SidebarFrame,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 14),
        Position = UDim2.new(0, 15, 0, 32),
        BackgroundTransparency = 1,
        Text = WindowSubtitle,
        TextColor3 = Colors.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = SidebarFrame,
    })

    local CloseButton = Create("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0, 13),
        BackgroundColor3 = Colors.Danger,
        Text = "X",
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 6,
        Parent = SidebarFrame,
    })
    CreateCorner(UDim.new(0, 3), CloseButton)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, Easing.Smooth, {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(WindowSize.X.Offset - 30, WindowSize.Y.Offset - 30),
        }):Play()
        task.delay(0.3, function()
            MainFrame:Destroy()
        end)
    end)

    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Colors.Divider,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = SidebarFrame,
    })

    Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(0, SidebarWidth, 0, 0),
        BackgroundColor3 = Colors.Divider,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = MainFrame,
    })

    local SidebarTabsFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -55),
        Position = UDim2.new(0, 0, 0, 55),
        BackgroundTransparency = 1,
        Parent = SidebarFrame,
    })
    CreatePadding(8, 0, 8, 8, SidebarTabsFrame)
    CreateListLayout(Enum.SortOrder.LayoutOrder, 4, SidebarTabsFrame)

    local ContentArea = Create("Frame", {
        Size = UDim2.new(1, -SidebarWidth - 1, 1, 0),
        Position = UDim2.new(0, SidebarWidth + 1, 0, 0),
        BackgroundColor3 = Colors.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 1,
        Parent = MainFrame,
    })

    NewWindow.SidebarTabsFrame = SidebarTabsFrame
    NewWindow.ContentArea = ContentArea

    MakeDraggable(MainFrame, SidebarFrame)

    local ToggleConnection = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then
            return
        end
        if Input.KeyCode == NewWindow.ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    table.insert(Library.Connections, ToggleConnection)

    table.insert(Library.Windows, NewWindow)
    return NewWindow
end

function Window:SelectTab(TabName)
    if self.ActiveTab == TabName or self.IsTransitioning then
        return
    end
    self.IsTransitioning = true
    CloseAllDropdowns()

    local OldTab = self.ActiveTab
    local NewPage = self.Tabs[TabName]

    for CurrentTabName, TabButton in pairs(self.TabButtons) do
        local TabIndicator = self.TabIndicators[CurrentTabName]
        if CurrentTabName == TabName then
            TweenService:Create(TabButton, Easing.Normal, {
                BackgroundColor3 = Colors.Element,
                TextColor3 = Colors.Text,
            }):Play()
            TweenService:Create(TabIndicator, Easing.Normal, {
                Size = UDim2.new(0, 3, 0, 24),
                BackgroundTransparency = 0,
            }):Play()
        else
            TweenService:Create(TabButton, Easing.Normal, {
                BackgroundColor3 = Colors.Sidebar,
                TextColor3 = Colors.TextDim,
            }):Play()
            TweenService:Create(TabIndicator, Easing.Normal, {
                Size = UDim2.new(0, 3, 0, 0),
                BackgroundTransparency = 1,
            }):Play()
        end
    end

    local function AnimatePageIn(PageFrame)
        PageFrame.Visible = true
        PageFrame.Position = UDim2.new(0, 12, 0, -20)
        TweenService:Create(PageFrame, Easing.Slide, {
            Position = UDim2.new(0, 12, 0, 12),
        }):Play()
    end

    local function AnimatePageOut(PageFrame)
        local OutTween = TweenService:Create(PageFrame, Easing.Slide, {
            Position = UDim2.new(0, 12, 0, 20),
        })
        OutTween:Play()
        return OutTween
    end

    if OldTab and self.Tabs[OldTab] and self.Tabs[OldTab] ~= NewPage then
        local OldPage = self.Tabs[OldTab]
        local OutTween = AnimatePageOut(OldPage)
        OutTween.Completed:Connect(function()
            OldPage.Visible = false
            OldPage.Position = UDim2.new(0, 12, 0, 12)
            AnimatePageIn(NewPage)
            self.ActiveTab = TabName
            self.IsTransitioning = false
        end)
    else
        AnimatePageIn(NewPage)
        self.ActiveTab = TabName
        self.IsTransitioning = false
    end
end

function Window:CreateTab(TabName, Icon)
    local TabPage = Create("ScrollingFrame", {
        Name = TabName .. "Page",
        Size = UDim2.new(1, -24, 1, -24),
        Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Colors.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.ContentArea,
    })
    CreateListLayout(Enum.SortOrder.LayoutOrder, 10, TabPage)

    local TabButton = Create("TextButton", {
        Name = TabName .. "Tab",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Colors.Sidebar,
        BorderSizePixel = 0,
        Text = "  " .. TabName,
        TextColor3 = Colors.TextDim,
        TextSize = 15,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = #self.Tabs + 1,
        ZIndex = 3,
        Parent = self.SidebarTabsFrame,
    })
    CreateCorner(UDim.new(0, 3), TabButton)

    local TabIndicator = Create("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Colors.Text,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = TabButton,
    })
    CreateCorner(UDim.new(1, 0), TabIndicator)

    TabButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= TabName then
            TweenService:Create(TabButton, Easing.Fast, {
                BackgroundColor3 = Colors.ElementHover,
                TextColor3 = Colors.Text,
            }):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= TabName then
            TweenService:Create(TabButton, Easing.Fast, {
                BackgroundColor3 = Colors.Sidebar,
                TextColor3 = Colors.TextDim,
            }):Play()
        end
    end)
    TabButton.MouseButton1Click:Connect(function()
        if self.ActiveTab ~= TabName then
            self:SelectTab(TabName)
        end
    end)

    self.Tabs[TabName] = TabPage
    self.TabButtons[TabName] = TabButton
    self.TabIndicators[TabName] = TabIndicator

    if not self.ActiveTab then
        self:SelectTab(TabName)
    end

    local Tab = {}
    Tab.Page = TabPage
    Tab.Name = TabName

    function Tab:CreateSection(SectionTitle, Order)
        return Create("TextLabel", {
            Name = (SectionTitle:gsub("%s+", "")) .. "Section",
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = SectionTitle,
            TextColor3 = Colors.TextDim,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = Order or 0,
            Parent = TabPage,
        })
    end

    function Tab:CreateGroup(GroupTitle, Order, CustomSize)
        local GroupFrame = Create("Frame", {
            Name = (GroupTitle:gsub("%s+", "")) .. "Group",
            Size = CustomSize or UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Colors.Panel,
            BorderSizePixel = 0,
            LayoutOrder = Order or 0,
            Parent = TabPage,
        })
        if not CustomSize then
            GroupFrame.AutomaticSize = Enum.AutomaticSize.Y
        end
        CreateCorner(UDim.new(0, 3), GroupFrame)
        CreateStroke(Colors.Divider, 1, GroupFrame)
        CreatePadding(12, 12, 12, 12, GroupFrame)

        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = GroupTitle,
            TextColor3 = Colors.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 0,
            Parent = GroupFrame,
        })
        CreateListLayout(Enum.SortOrder.LayoutOrder, 8, GroupFrame)

        local GroupApi = {}
        GroupApi.Frame = GroupFrame
        GroupApi.Title = GroupTitle

        function GroupApi:CreateToggle(ToggleText, Default, Callback, ToggleOrder)
            return Library:CreateToggle(GroupFrame, ToggleText, Default, Callback, ToggleOrder)
        end

        function GroupApi:CreateButton(ButtonText, Callback, ButtonOrder)
            return Library:CreateButton(GroupFrame, ButtonText, Callback, ButtonOrder)
        end

        function GroupApi:CreateDropdown(DropdownText, Options, Callback, DropdownOrder)
            return Library:CreateDropdown(GroupFrame, DropdownText, Options, Callback, DropdownOrder)
        end

        function GroupApi:CreateSlider(SliderText, Min, Max, Default, Callback, SliderOrder, SliderOptions)
            return Library:CreateSlider(GroupFrame, SliderText, Min, Max, Default, Callback, SliderOrder, SliderOptions)
        end

        function GroupApi:CreateTextBox(Placeholder, Callback, TextBoxOrder)
            return Library:CreateTextBox(GroupFrame, Placeholder, Callback, TextBoxOrder)
        end

        function GroupApi:CreateLabel(LabelText, LabelOrder)
            return Library:CreateLabel(GroupFrame, LabelText, LabelOrder)
        end

        function GroupApi:CreateSeparator(SeparatorOrder)
            return Library:CreateSeparator(GroupFrame, SeparatorOrder)
        end

        return GroupApi
    end

    function Tab:CreateLabel(LabelText, LabelOrder)
        return Library:CreateLabel(TabPage, LabelText, LabelOrder)
    end

    function Tab:CreateSeparator(SeparatorOrder)
        return Library:CreateSeparator(TabPage, SeparatorOrder)
    end

    function Tab:CreateHStack(HStackOrder, HStackHeight, HStackPadding)
        local HStackFrame = Create("Frame", {
            Name = "HStack",
            Size = UDim2.new(1, 0, 0, HStackHeight or 0),
            BackgroundTransparency = 1,
            LayoutOrder = HStackOrder or 0,
            Parent = TabPage,
        })
        if not HStackHeight then
            HStackFrame.AutomaticSize = Enum.AutomaticSize.Y
        end
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, HStackPadding or 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Parent = HStackFrame,
        })
        return HStackFrame
    end

    function Tab:CreateVStack(VStackOrder, VStackHeight, VStackPadding)
        local VStackFrame = Create("Frame", {
            Name = "VStack",
            Size = UDim2.new(1, 0, 0, VStackHeight or 0),
            BackgroundTransparency = 1,
            LayoutOrder = VStackOrder or 0,
            Parent = TabPage,
        })
        if not VStackHeight then
            VStackFrame.AutomaticSize = Enum.AutomaticSize.Y
        end
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, VStackPadding or 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = VStackFrame,
        })
        return VStackFrame
    end

    return Tab
end

function Window:Toggle(Visible)
    if Visible == nil then
        self.Frame.Visible = not self.Frame.Visible
    else
        self.Frame.Visible = Visible
    end
end

function Window:Destroy()
    self.Frame:Destroy()
end

function Library:CreateToggle(Parent, ToggleText, Default, Callback, Order)
    local ToggleFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = Order or 0,
        Parent = Parent,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -55, 1, 0),
        BackgroundTransparency = 1,
        Text = ToggleText,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ToggleFrame,
    })

    local ToggleBackground = Create("Frame", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -44, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Default and Colors.ToggleOn or Colors.Element,
        BorderSizePixel = 0,
        Parent = ToggleFrame,
    })
    CreateCorner(UDim.new(0, 3), ToggleBackground)

    local ToggleKnob = Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = Default and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Colors.Text,
        BorderSizePixel = 0,
        Parent = ToggleBackground,
    })
    CreateCorner(UDim.new(0, 2), ToggleKnob)

    local ToggleHitbox = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = ToggleFrame,
    })

    local CurrentState = Default
    local ToggleApi = { Value = CurrentState }

    function ToggleApi:Set(NewValue)
        CurrentState = NewValue
        ToggleApi.Value = NewValue
        TweenService:Create(ToggleBackground, Easing.Normal, {
            BackgroundColor3 = CurrentState and Colors.ToggleOn or Colors.Element,
        }):Play()
        TweenService:Create(ToggleKnob, Easing.Bounce, {
            Position = CurrentState and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
        }):Play()
        if Callback then
            local Success, ErrorMessage = pcall(Callback, CurrentState)
            if not Success then
                warn("[Sigma] Toggle callback error:", ErrorMessage)
            end
        end
    end

    function ToggleApi:Get()
        return CurrentState
    end

    ToggleHitbox.MouseButton1Click:Connect(function()
        ToggleApi:Set(not CurrentState)
    end)

    Library.Flags[ToggleText] = ToggleApi
    return ToggleApi
end

function Library:CreateButton(Parent, ButtonText, Callback, Order)
    local ButtonFrame = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Colors.Element,
        BorderSizePixel = 0,
        Text = ButtonText,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
        LayoutOrder = Order or 0,
        Parent = Parent,
    })
    CreateCorner(UDim.new(0, 3), ButtonFrame)

    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, Easing.Fast, {
            BackgroundColor3 = Colors.ElementHover,
        }):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, Easing.Fast, {
            BackgroundColor3 = Colors.Element,
        }):Play()
    end)
    ButtonFrame.MouseButton1Click:Connect(function()
        local OriginalSize = ButtonFrame.Size
        TweenService:Create(ButtonFrame, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset - 4, OriginalSize.Y.Scale, OriginalSize.Y.Offset),
        }):Play()
        task.delay(0.08, function()
            TweenService:Create(ButtonFrame, Easing.Bounce, {
                Size = OriginalSize,
            }):Play()
        end)
        if Callback then
            local Success, ErrorMessage = pcall(Callback)
            if not Success then
                warn("[Sigma] Button callback error:", ErrorMessage)
            end
        end
    end)

    return ButtonFrame
end

function Library:CreateDropdown(Parent, DropdownText, OptionsList, Callback, Order)
    local DropdownFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Colors.Element,
        BorderSizePixel = 0,
        LayoutOrder = Order or 0,
        ClipsDescendants = false,
        Parent = Parent,
    })
    CreateCorner(UDim.new(0, 3), DropdownFrame)

    local DisplayLabel = Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = DropdownText .. ": " .. (OptionsList[1] or ""),
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = DropdownFrame,
    })

    Create("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = Colors.TextDim,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = DropdownFrame,
    })

    local DropdownHitbox = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = DropdownFrame,
    })

    local IsOpen = false
    local ListFrame = nil
    local CurrentValue = OptionsList[1]
    local DropdownEntry = {
        ListFrame = nil,
        OnClose = function()
            IsOpen = false
        end,
    }
    local DropdownApi = { Value = CurrentValue }

    local function CloseList()
        if ListFrame then
            for Index, Entry in ipairs(Library.OpenDropdowns) do
                if Entry == DropdownEntry then
                    table.remove(Library.OpenDropdowns, Index)
                    break
                end
            end
            local CloseTween = TweenService:Create(ListFrame, Easing.Fast, {
                Size = UDim2.new(1, 0, 0, 0),
            })
            CloseTween:Play()
            CloseTween.Completed:Connect(function()
                if ListFrame then
                    ListFrame:Destroy()
                    ListFrame = nil
                end
            end)
        end
        IsOpen = false
    end

    DropdownHitbox.MouseButton1Click:Connect(function()
        if IsOpen then
            CloseList()
            return
        end

        IsOpen = true
        ListFrame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 4),
            BackgroundColor3 = Colors.Panel,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ZIndex = 10,
            Parent = DropdownFrame,
        })
        CreateCorner(UDim.new(0, 3), ListFrame)
        CreateStroke(Colors.Divider, 1, ListFrame)

        DropdownEntry.ListFrame = ListFrame
        table.insert(Library.OpenDropdowns, DropdownEntry)

        CreateListLayout(Enum.SortOrder.LayoutOrder, 2, ListFrame)
        CreatePadding(4, 4, 0, 0, ListFrame)

        for OptionIndex, OptionText in ipairs(OptionsList) do
            local OptionButton = Create("TextButton", {
                Size = UDim2.new(1, -8, 0, 28),
                Position = UDim2.new(0, 4, 0, 0),
                BackgroundColor3 = Colors.Panel,
                BorderSizePixel = 0,
                Text = "  " .. OptionText,
                TextColor3 = Colors.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                LayoutOrder = OptionIndex,
                ZIndex = 11,
                Parent = ListFrame,
            })
            CreateCorner(UDim.new(0, 2), OptionButton)

            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, Easing.Fast, {
                    BackgroundColor3 = Colors.ElementHover,
                }):Play()
            end)
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, Easing.Fast, {
                    BackgroundColor3 = Colors.Panel,
                }):Play()
            end)
            OptionButton.MouseButton1Click:Connect(function()
                DisplayLabel.Text = DropdownText .. ": " .. OptionText
                CurrentValue = OptionText
                DropdownApi.Value = OptionText
                if Callback then
                    local Success, ErrorMessage = pcall(Callback, OptionText)
                    if not Success then
                        warn("[Sigma] Dropdown error:", ErrorMessage)
                    end
                end
                CloseList()
            end)
        end

        local TargetHeight = 6 + (#OptionsList * 30)
        TweenService:Create(ListFrame, Easing.Normal, {
            Size = UDim2.new(1, 0, 0, TargetHeight),
        }):Play()
    end)

    function DropdownApi:Set(NewValue)
        CurrentValue = NewValue
        DropdownApi.Value = NewValue
        DisplayLabel.Text = DropdownText .. ": " .. tostring(NewValue)
    end

    function DropdownApi:Get()
        return CurrentValue
    end

    Library.Flags[DropdownText] = DropdownApi
    return DropdownApi
end

function Library:CreateSlider(Parent, SliderText, MinimumValue, MaximumValue, DefaultValue, Callback, Order, SliderOptions)
    SliderOptions = SliderOptions or {}
    local Suffix = SliderOptions.Suffix or ""
    local StepSize = SliderOptions.Step or 1

    local SliderFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        LayoutOrder = Order or 0,
        Parent = Parent,
    })

    Create("TextLabel", {
        Size = UDim2.new(0.45, -5, 1, 0),
        BackgroundTransparency = 1,
        Text = SliderText,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SliderFrame,
    })

    local SliderBox = Create("Frame", {
        Size = UDim2.new(0.55, -5, 1, 0),
        Position = UDim2.new(0.45, 5, 0, 0),
        BackgroundColor3 = Colors.Element,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = SliderFrame,
    })
    CreateCorner(UDim.new(0, 3), SliderBox)

    local SliderFill = Create("Frame", {
        Size = UDim2.new((DefaultValue - MinimumValue) / (MaximumValue - MinimumValue), 0, 1, 0),
        BackgroundColor3 = Colors.ElementHover,
        BorderSizePixel = 0,
        Parent = SliderBox,
    })
    CreateCorner(UDim.new(0, 3), SliderFill)

    local ValueLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = tostring(DefaultValue) .. (Suffix ~= "" and "/" .. Suffix or ""),
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 2,
        Parent = SliderBox,
    })

    local SliderHitbox = Create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 3,
        Parent = SliderBox,
    })

    local IsDragging = false
    local CurrentValue = DefaultValue
    local SliderApi = { Value = CurrentValue }

    local function FormatValue(Value)
        if StepSize < 1 then
            return string.format("%.1f", Value)
        end
        return tostring(math.floor(Value))
    end

    local function UpdateSlider(Input)
        local RelativeX = math.clamp((Input.Position.X - SliderBox.AbsolutePosition.X) / SliderBox.AbsoluteSize.X, 0, 1)
        local RawValue = MinimumValue + (MaximumValue - MinimumValue) * RelativeX
        local SteppedValue = math.floor(RawValue / StepSize + 0.5) * StepSize
        SteppedValue = math.clamp(SteppedValue, MinimumValue, MaximumValue)
        CurrentValue = SteppedValue
        SliderApi.Value = SteppedValue

        local RelativePosition = (SteppedValue - MinimumValue) / (MaximumValue - MinimumValue)
        TweenService:Create(SliderFill, Easing.Fast, {
            Size = UDim2.new(RelativePosition, 0, 1, 0),
        }):Play()
        ValueLabel.Text = FormatValue(SteppedValue) .. (Suffix ~= "" and "/" .. Suffix or "")

        if Callback then
            local Success, ErrorMessage = pcall(Callback, SteppedValue)
            if not Success then
                warn("[Sigma] Slider callback error:", ErrorMessage)
            end
        end
    end

    SliderHitbox.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = true
            UpdateSlider(Input)
        end
    end)

    local MoveConnection = UserInputService.InputChanged:Connect(function(Input)
        if IsDragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(Input)
        end
    end)

    local EndConnection = UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            IsDragging = false
        end
    end)

    table.insert(Library.Connections, MoveConnection)
    table.insert(Library.Connections, EndConnection)

    function SliderApi:Set(NewValue)
        NewValue = math.clamp(NewValue, MinimumValue, MaximumValue)
        CurrentValue = NewValue
        SliderApi.Value = NewValue
        local RelativePosition = (NewValue - MinimumValue) / (MaximumValue - MinimumValue)
        SliderFill.Size = UDim2.new(RelativePosition, 0, 1, 0)
        ValueLabel.Text = FormatValue(NewValue) .. (Suffix ~= "" and "/" .. Suffix or "")
        if Callback then
            local Success, ErrorMessage = pcall(Callback, NewValue)
            if not Success then
                warn("[Sigma] Slider callback error:", ErrorMessage)
            end
        end
    end

    function SliderApi:Get()
        return CurrentValue
    end

    Library.Flags[SliderText] = SliderApi
    return SliderApi
end

function Library:CreateTextBox(Parent, PlaceholderText, Callback, Order)
    local TextBoxFrame = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Colors.Element,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = PlaceholderText,
        PlaceholderColor3 = Colors.TextDim,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        LayoutOrder = Order or 0,
        Parent = Parent,
    })
    CreateCorner(UDim.new(0, 3), TextBoxFrame)

    local TextBoxStroke = Create("UIStroke", {
        Color = Colors.Divider,
        Thickness = 1,
        Transparency = 1,
        Parent = TextBoxFrame,
    })

    CreatePadding(0, 0, 10, 0, TextBoxFrame)

    TextBoxFrame.Focused:Connect(function()
        TweenService:Create(TextBoxStroke, Easing.Fast, {
            Transparency = 0,
        }):Play()
    end)
    TextBoxFrame.FocusLost:Connect(function()
        TweenService:Create(TextBoxStroke, Easing.Fast, {
            Transparency = 1,
        }):Play()
        if Callback then
            local Success, ErrorMessage = pcall(Callback, TextBoxFrame.Text)
            if not Success then
                warn("[Sigma] TextBox callback error:", ErrorMessage)
            end
        end
    end)

    local TextBoxApi = {}

    function TextBoxApi:Set(NewText)
        TextBoxFrame.Text = NewText
    end

    function TextBoxApi:Get()
        return TextBoxFrame.Text
    end

    Library.Flags[PlaceholderText] = TextBoxApi
    return TextBoxApi
end

function Library:CreateLabel(Parent, LabelText, Order)
    local LabelFrame = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = LabelText,
        TextColor3 = Colors.TextDim,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = Order or 0,
        Parent = Parent,
    })

    local LabelApi = {}

    function LabelApi:Set(NewText)
        LabelFrame.Text = NewText
    end

    function LabelApi:Get()
        return LabelFrame.Text
    end

    return LabelApi
end

function Library:CreateSeparator(Parent, Order)
    return Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Colors.Divider,
        BorderSizePixel = 0,
        LayoutOrder = Order or 0,
        Parent = Parent,
    })
end

function Library:Notify(NotificationText, Duration)
    Duration = Duration or 2.5

    local NotificationFrame = Create("Frame", {
        Size = UDim2.new(0, 280, 0, 40),
        Position = UDim2.new(0.5, 0, 0, -50),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Colors.Panel,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    CreateCorner(UDim.new(0, 3), NotificationFrame)
    CreateStroke(Colors.Divider, 1, NotificationFrame)

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = NotificationText,
        TextColor3 = Colors.Text,
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = NotificationFrame,
    })

    TweenService:Create(NotificationFrame, Easing.Smooth, {
        Position = UDim2.new(0.5, 0, 0, 20),
    }):Play()

    task.delay(Duration, function()
        TweenService:Create(NotificationFrame, Easing.Smooth, {
            Position = UDim2.new(0.5, 0, 0, -50),
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.3, function()
            NotificationFrame:Destroy()
        end)
    end)
end

function Library:Unload()
    for _, Connection in ipairs(Library.Connections) do
        if Connection and Connection.Disconnect then
            pcall(function()
                Connection:Disconnect()
            end)
        end
    end
    for _, ExistingWindow in ipairs(Library.Windows) do
        if ExistingWindow.Frame then
            ExistingWindow.Frame:Destroy()
        end
    end
    Library.Connections = {}
    Library.Windows = {}
    Library.Flags = {}
    Library.Tabs = {}
    Library.OpenDropdowns = {}
    ScreenGui:Destroy()
end

getgenv().Sigma = Library
getgenv().SigmaLibrary = Library

return Library
