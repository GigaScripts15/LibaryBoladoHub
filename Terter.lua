--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║                  AXIOMX UI LIBRARY v1.0                       ║
    ║                                                                ║
    ║  Clone profissional do Rayfield para Roblox em Lua            ║
    ║  Com todas as funcionalidades e visual profissional           ║
    ║                                                                ║
    ║  Autor: AxiomX Community | Licença: MIT                       ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local AxiomX = {}
AxiomX.__index = AxiomX
AxiomX.Version = "1.0.0"

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

if not RunService:IsClient() then
    warn("[AxiomX] Esta library deve ser executada no Cliente")
    return
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

-- ============= NOTIFICAÇÃO =============
local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.ResetOnSpawn = false
NotificationHolder.ZIndex = 999
NotificationHolder.Parent = PlayerGui

local function CreateNotification(title, content, duration)
    duration = duration or 5
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = NotificationHolder
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notification.BorderSizePixel = 0
    notification.Size = UDim2.new(0, 300, 0, 100)
    notification.Position = UDim2.new(1, 10, 1, -120)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 180, 255)
    stroke.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.Text = title
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Parent = notification
    contentLabel.Text = content
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    contentLabel.BackgroundTransparency = 1
    contentLabel.TextWrapped = true
    contentLabel.Size = UDim2.new(1, -20, 0, 60)
    contentLabel.Position = UDim2.new(0, 10, 0, 30)
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local tweenService = game:GetService("TweenService")
    local tweenOut = tweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 310, 1, -120)})
    
    task.wait(duration)
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- ============= TEMAS =============
local Themes = {
    Dark = {
        SchemeColor = Color3.fromRGB(0, 180, 255),
        Background = Color3.fromRGB(20, 20, 30),
        Header = Color3.fromRGB(25, 25, 35),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBackground = Color3.fromRGB(30, 30, 40),
        TextDisabled = Color3.fromRGB(120, 120, 120),
        Stroke = Color3.fromRGB(50, 50, 70),
    },
    Light = {
        SchemeColor = Color3.fromRGB(0, 150, 255),
        Background = Color3.fromRGB(250, 250, 250),
        Header = Color3.fromRGB(240, 240, 240),
        TextColor = Color3.fromRGB(0, 0, 0),
        ElementBackground = Color3.fromRGB(245, 245, 245),
        TextDisabled = Color3.fromRGB(150, 150, 150),
        Stroke = Color3.fromRGB(200, 200, 200),
    },
}

-- ============= UI HELPERS =============
local function CreateFrame(parent, name, props)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Parent = parent
    frame.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = props.BackgroundTransparency or 0
    frame.BorderSizePixel = 0
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    
    if props.CornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, props.CornerRadius)
        corner.Parent = frame
    end
    
    if props.Stroke then
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = props.StrokeThickness or 1
        stroke.Color = props.StrokeColor or Color3.fromRGB(50, 50, 70)
        stroke.Parent = frame
    end
    
    return frame
end

local function CreateLabel(parent, text, props)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = parent
    label.Text = text
    label.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
    label.TextSize = props.TextSize or 13
    label.Font = props.Font or Enum.Font.Gotham
    label.BackgroundTransparency = 1
    label.BorderSizePixel = 0
    label.Size = props.Size or UDim2.new(1, 0, 0, 20)
    label.Position = props.Position or UDim2.new(0, 0, 0, 0)
    label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    label.TextWrapped = props.TextWrapped or false
    
    return label
end

local function CreateButton(parent, text, props)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Parent = parent
    button.Text = text
    button.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
    button.TextSize = props.TextSize or 13
    button.Font = props.Font or Enum.Font.GothamMedium
    button.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(0, 180, 255)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 0
    button.Size = props.Size or UDim2.new(1, 0, 0, 35)
    button.Position = props.Position or UDim2.new(0, 0, 0, 0)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    return button
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.InOut
    )
    local tween = game:GetService("TweenService"):Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ============= WINDOW CLASS =============
local Window = {}
Window.__index = Window

function AxiomX:CreateWindow(windowSettings)
    windowSettings = windowSettings or {}
    local self = setmetatable({}, Window)
    
    self.Title = windowSettings.Title or "AxiomX"
    self.Size = windowSettings.Size or UDim2.new(0, 600, 0, 500)
    self.Transparent = windowSettings.Transparent or false
    self.Theme = windowSettings.Theme or "Dark"
    self.ThemeObject = Themes[self.Theme] or Themes.Dark
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:_CreateUI()
    self:_SetupDragging()
    
    return self
end

function Window:_CreateUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxiomXGui"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 2147483647
    self.ScreenGui.Parent = PlayerGui
    
    -- Main Frame
    self.MainFrame = CreateFrame(self.ScreenGui, "MainFrame", {
        BackgroundColor3 = self.ThemeObject.Background,
        Size = self.Size,
        Position = UDim2.new(0.5, -(self.Size.X.Offset/2), 0.5, -(self.Size.Y.Offset/2)),
        CornerRadius = 12,
        Stroke = true,
        StrokeColor = self.ThemeObject.Stroke,
    })
    
    -- Header
    self.Header = CreateFrame(self.MainFrame, "Header", {
        BackgroundColor3 = self.ThemeObject.Header,
        Size = UDim2.new(1, 0, 0, 50),
        CornerRadius = 12,
        Stroke = true,
        StrokeColor = self.ThemeObject.Stroke,
    })
    
    CreateLabel(self.Header, self.Title, {
        TextColor3 = self.ThemeObject.SchemeColor,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
    })
    
    -- Close Button
    local closeBtn = CreateButton(self.Header, "×", {
        TextColor3 = self.ThemeObject.TextColor,
        TextSize = 18,
        BackgroundColor3 = self.ThemeObject.SchemeColor,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0.5, -20),
    })
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    -- Sidebar
    self.Sidebar = CreateFrame(self.MainFrame, "Sidebar", {
        BackgroundColor3 = self.ThemeObject.Header,
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        Stroke = true,
        StrokeColor = self.ThemeObject.Stroke,
    })
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 10)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = self.Sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingBottom = UDim.new(0, 10)
    sidebarPadding.PaddingLeft = UDim.new(0, 10)
    sidebarPadding.PaddingRight = UDim.new(0, 10)
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.Parent = self.Sidebar
    
    -- Content Area
    self.ContentArea = CreateFrame(self.MainFrame, "ContentArea", {
        BackgroundColor3 = self.ThemeObject.Background,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -150, 1, -50),
        Position = UDim2.new(0, 150, 0, 50),
    })
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingBottom = UDim.new(0, 15)
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 15)
    contentPadding.PaddingTop = UDim.new(0, 15)
    contentPadding.Parent = self.ContentArea
    
    -- Scroll Frame
    self.ScrollFrame = Instance.new("ScrollingFrame")
    self.ScrollFrame.Name = "ScrollFrame"
    self.ScrollFrame.Parent = self.ContentArea
    self.ScrollFrame.BackgroundTransparency = 1
    self.ScrollFrame.BorderSizePixel = 0
    self.ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ScrollFrame.ScrollBarThickness = 5
    self.ScrollFrame.ScrollBarImageColor3 = self.ThemeObject.SchemeColor
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 10)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = self.ScrollFrame
    
    self._SidebarLayout = sidebarLayout
    self._ScrollLayout = scrollLayout
end

function Window:_SetupDragging()
    local dragging = false
    local dragStart = nil
    local frameStart = nil
    
    self.Header.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Window:CreateTab(tabName)
    local tab = {
        Name = tabName,
        Sections = {},
        TabButton = nil,
        TabContent = nil
    }
    
    tab.__index = tab
    setmetatable(tab, {__index = function(_, k) return Window[k] end})
    
    -- Tab Button
    local tabButton = CreateButton(self.Sidebar, tabName, {
        TextColor3 = self.ThemeObject.TextColor,
        TextSize = 12,
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        Size = UDim2.new(1, 0, 0, 35),
    })
    
    -- Tab Content
    local tabContent = CreateFrame(self.ScrollFrame, tabName .. "Content", {
        BackgroundColor3 = self.ThemeObject.Background,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 1),
    })
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.Parent = tabContent
    
    tab.TabButton = tabButton
    tab.TabContent = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        self:_SwitchTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if self.CurrentTab == nil then
        self:_SwitchTab(tab)
    end
    
    return tab
end

function Window:_SwitchTab(tab)
    for _, t in ipairs(self.Tabs) do
        if t.TabContent then
            t.TabContent.Visible = false
            t.TabButton.BackgroundColor3 = self.ThemeObject.ElementBackground
            t.TabButton.TextColor3 = self.ThemeObject.TextColor
        end
    end
    
    self.CurrentTab = tab
    tab.TabContent.Visible = true
    tab.TabButton.BackgroundColor3 = self.ThemeObject.SchemeColor
    tab.TabButton.TextColor3 = self.ThemeObject.Background
end

function Window:CreateSection(sectionName)
    if not self.CurrentTab then
        warn("[AxiomX] Nenhuma aba criada!")
        return
    end
    
    local section = {
        Name = sectionName,
        Components = {},
        SectionFrame = nil
    }
    
    local sectionFrame = CreateFrame(self.CurrentTab.TabContent, sectionName, {
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        Size = UDim2.new(1, 0, 0, 1),
        CornerRadius = 8,
        Stroke = true,
        StrokeColor = self.ThemeObject.Stroke,
    })
    
    CreateLabel(sectionFrame, sectionName, {
        TextColor3 = self.ThemeObject.SchemeColor,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
    })
    
    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Padding = UDim.new(0, 8)
    sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionLayout.FillDirection = Enum.FillDirection.Vertical
    sectionLayout.Parent = sectionFrame
    
    local sectionPadding = Instance.new("UIPadding")
    sectionPadding.PaddingBottom = UDim.new(0, 10)
    sectionPadding.PaddingLeft = UDim.new(0, 10)
    sectionPadding.PaddingRight = UDim.new(0, 10)
    sectionPadding.PaddingTop = UDim.new(0, 25)
    sectionPadding.Parent = sectionFrame
    
    section.SectionFrame = sectionFrame
    
    table.insert(self.CurrentTab.Sections, section)
    
    return section
end

function Window:CreateButton(args)
    local parent = args.Section or self.CurrentTab.TabContent
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local button = CreateButton(targetParent, args.Name, {
        TextColor3 = self.ThemeObject.TextColor,
        TextSize = 13,
        BackgroundColor3 = self.ThemeObject.SchemeColor,
        Size = UDim2.new(1, 0, 0, 35),
    })
    
    button.MouseButton1Click:Connect(function()
        if args.Callback then
            args.Callback()
        end
    end)
    
    return button
end

function Window:CreateToggle(args)
    local parent = args.Section or self.CurrentTab.TabContent
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local state = {Enabled = args.Default or false}
    
    local container = CreateFrame(targetParent, args.Name .. "Toggle", {
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
    })
    
    CreateLabel(container, args.Name, {
        TextColor3 = self.ThemeObject.TextColor,
        TextSize = 13,
        Size = UDim2.new(0.7, 0, 1, 0),
    })
    
    local toggleBtn = CreateButton(container, "", {
        TextColor3 = self.ThemeObject.TextColor,
        BackgroundColor3 = self.ThemeObject.Stroke,
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -45, 0.5, -11),
    })
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Parent = toggleBtn
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    toggleBtn.MouseButton1Click:Connect(function()
        state.Enabled = not state.Enabled
        
        if state.Enabled then
            Tween(toggleBtn, {BackgroundColor3 = self.ThemeObject.SchemeColor}, 0.2)
            Tween(toggleCircle, {Position = UDim2.new(0, 20, 0.5, -9)}, 0.2)
        else
            Tween(toggleBtn, {BackgroundColor3 = self.ThemeObject.Stroke}, 0.2)
            Tween(toggleCircle, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.2)
        end
        
        if args.Callback then
            args.Callback(state.Enabled)
        end
    end)
    
    if args.Default then
        toggleBtn:MouseButton1Click()
    end
    
    return {
        Container = container,
        SetValue = function(_, value)
            if value ~= state.Enabled then
                toggleBtn:MouseButton1Click()
            end
        end,
        GetValue = function(_)
            return state.Enabled
        end
    }
end

function Window:CreateSlider(args)
    local parent = args.Section or self.CurrentTab.TabContent
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local state = {Value = args.Default or args.Min}
    
    local container = CreateFrame(targetParent, args.Name .. "Slider", {
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
    })
    
    local label = CreateLabel(container, args.Name .. ": " .. state.Value, {
        TextColor3 = self.ThemeObject.TextColor,
        TextSize = 13,
        Size = UDim2.new(1, 0, 0, 20),
    })
    
    local sliderBar = CreateFrame(container, "SliderBar", {
        BackgroundColor3 = self.ThemeObject.Stroke,
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 25),
        CornerRadius = 3,
    })
    
    local sliderHandle = CreateFrame(sliderBar, "Handle", {
        BackgroundColor3 = self.ThemeObject.SchemeColor,
        Size = UDim2.new(0, 13, 0, 13),
        Position = UDim2.new(0, 0, 0.5, -6.5),
        CornerRadius = 7,
    })
    
    local function updateSlider(mouseX)
        local barSize = sliderBar.AbsoluteSize.X
        local barPos = sliderBar.AbsolutePosition.X
        local relativeX = math.clamp(mouseX - barPos, 0, barSize)
        local percentage = relativeX / barSize
        
        state.Value = math.floor(args.Min + (args.Max - args.Min) * percentage)
        label.Text = args.Name .. ": " .. state.Value
        sliderHandle.Position = UDim2.new(percentage, -6.5, 0.5, -6.5)
        
        if args.Callback then
            args.Callback(state.Value)
        end
    end
    
    sliderBar.MouseButton1Click:Connect(function()
        updateSlider(Mouse.X)
    end)
    
    return {
        Container = container,
        SetValue = function(_, value)
            local clampedValue = math.clamp(value, args.Min, args.Max)
            local percentage = (clampedValue - args.Min) / (args.Max - args.Min)
            sliderHandle.Position = UDim2.new(percentage, -6.5, 0.5, -6.5)
            state.Value = clampedValue
            label.Text = args.Name .. ": " .. state.Value
        end,
        GetValue = function(_)
            return state.Value
        end
    }
end

function Window:CreateDropdown(args)
    local parent = args.Section or self.CurrentTab.TabContent
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local state = {Selected = args.Default or args.Options[1] or ""}
    local isOpen = false
    
    local container = CreateFrame(targetParent, args.Name .. "Dropdown", {
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 45),
    })
    
    CreateLabel(container, args.Name, {
        TextColor3 = self.ThemeObject.TextDisabled,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 15),
    })
    
    local dropdownBtn = CreateButton(container, state.Selected, {
        TextColor3 = self.ThemeObject.TextColor,
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 18),
    })
    
    local dropdownMenu = CreateFrame(container, "Menu", {
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 43),
        CornerRadius = 6,
    })
    
    dropdownMenu.ClipsDescendants = true
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 5)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = dropdownMenu
    
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            local menuHeight = (#args.Options * 25) + (#args.Options * 5)
            Tween(dropdownMenu, {Size = UDim2.new(1, 0, 0, menuHeight)}, 0.2)
        else
            Tween(dropdownMenu, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        end
    end
    
    for _, option in ipairs(args.Options) do
        local optionBtn = CreateButton(dropdownMenu, option, {
            TextColor3 = self.ThemeObject.TextColor,
            TextSize = 12,
            BackgroundColor3 = self.ThemeObject.ElementBackground,
            Size = UDim2.new(1, 0, 0, 25),
        })
        
        optionBtn.MouseButton1Click:Connect(function()
            state.Selected = option
            dropdownBtn.Text = option
            toggleDropdown()
            
            if args.Callback then
                args.Callback(option)
            end
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(toggleDropdown)
    
    return {
        Container = container,
        SetValue = function(_, value)
            if table.find(args.Options, value) then
                state.Selected = value
                dropdownBtn.Text = value
            end
        end,
        GetValue = function(_)
            return state.Selected
        end
    }
end

function Window:CreateInput(args)
    local parent = args.Section or self.CurrentTab.TabContent
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local state = {Value = ""}
    
    local container = CreateFrame(targetParent, args.Name .. "Input", {
        BackgroundColor3 = self.ThemeObject.ElementBackground,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
    })
    
    CreateLabel(container, args.Name, {
        TextColor3 = self.ThemeObject.TextDisabled,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 15),
    })
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "TextBox"
    textbox.Parent = container
    textbox.BackgroundColor3 = self.ThemeObject.ElementBackground
    textbox.TextColor3 = self.ThemeObject.TextColor
    textbox.PlaceholderText = args.PlaceholderText or ""
    textbox.PlaceholderColor3 = self.ThemeObject.TextDisabled
    textbox.TextSize = 13
    textbox.Font = Enum.Font.Gotham
    textbox.BorderSizePixel = 0
    textbox.Size = UDim2.new(1, 0, 0, 28)
    textbox.Position = UDim2.new(0, 0, 0, 18)
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 5)
    textboxCorner.Parent = textbox
    
    local textboxStroke = Instance.new("UIStroke")
    textboxStroke.Thickness = 1
    textboxStroke.Color = self.ThemeObject.Stroke
    textboxStroke.Parent = textbox
    
    textbox.FocusLost:Connect(function(enterPressed)
        state.Value = textbox.Text
        if args.Callback then
            args.Callback(state.Value)
        end
    end)
    
    return {
        Container = container,
        SetValue = function(_, value)
            textbox.Text = value
            state.Value = value
        end,
        GetValue = function(_)
            return state.Value
        end
    }
end

function Window:CreateLabel(args)
    local parent = args.Section or self.CurrentTab.TabContent
    local targetParent = parent.SectionFrame or parent.TabContent
    
    return CreateLabel(targetParent, args.Name, {
        TextColor3 = args.TextColor or self.ThemeObject.TextColor,
        TextSize = args.TextSize or 13,
        Size = UDim2.new(1, 0, 0, 25),
        TextWrapped = true,
    })
end

function Window:Notify(args)
    CreateNotification(args.Title, args.Content, args.Duration)
end

function Window:SetTheme(theme)
    if Themes[theme] then
        self.Theme = theme
        self.ThemeObject = Themes[theme]
    end
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

print("[AxiomX] Library carregada com sucesso! v" .. AxiomX.Version)
return AxiomX
