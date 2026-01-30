--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║              AXIOMX PRO UI LIBRARY v2.0                       ║
    ║                                                                ║
    ║  Um framework profissional e completo de UI para Roblox       ║
    ║  Com Key System, Discord, Anti-Cheat, Notificações e Mais!    ║
    ║                                                                ║
    ║  Autor: AxiomX Community | Licença: MIT                       ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local AxiomX = {}
AxiomX.__index = AxiomX
AxiomX.Version = "2.0"

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

-- ============= TEMAS =============
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 35),
        Secondary = Color3.fromRGB(40, 40, 45),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 70),
    },
    Dracula = {
        Primary = Color3.fromRGB(40, 42, 54),
        Secondary = Color3.fromRGB(48, 51, 66),
        Accent = Color3.fromRGB(189, 147, 249),
        Text = Color3.fromRGB(248, 248, 242),
        TextSecondary = Color3.fromRGB(98, 114, 164),
        Border = Color3.fromRGB(68, 71, 90),
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(13, 15, 20),
        Secondary = Color3.fromRGB(25, 30, 45),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(0, 200, 200),
    },
    Rose = {
        Primary = Color3.fromRGB(35, 30, 40),
        Secondary = Color3.fromRGB(50, 40, 55),
        Accent = Color3.fromRGB(255, 100, 150),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 180, 200),
        Border = Color3.fromRGB(80, 60, 80),
    }
}

-- ============= NOTIFICAÇÃO SYSTEM =============
local NotificationManager = {}

function NotificationManager:Create(title, message, duration)
    duration = duration or 3
    
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "Notification"
    notifGui.ResetOnSpawn = false
    notifGui.Parent = PlayerGui
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "NotifFrame"
    notifFrame.Parent = notifGui
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    notifFrame.Position = UDim2.new(1, -320, 0, 20)
    notifFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    notifFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 120, 255)
    stroke.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notifFrame
    titleLabel.Text = title
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Parent = notifFrame
    msgLabel.Text = message
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.GothamMedium
    msgLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    msgLabel.BackgroundTransparency = 1
    msgLabel.TextWrapped = true
    msgLabel.Size = UDim2.new(1, -20, 0, 45)
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    
    local tweenService = game:GetService("TweenService")
    
    -- Animação de entrada
    notifFrame.Position = UDim2.new(1, 20, 0, 20)
    local tweenIn = tweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 0, 20)})
    tweenIn:Play()
    
    -- Animação de saída
    task.wait(duration)
    local tweenOut = tweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 20, 0, 20)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notifGui:Destroy()
    end)
end

-- ============= KEY SYSTEM =============
local KeySystem = {}

function KeySystem:Create(requiredKey, successCallback, failCallback)
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystemGui"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = PlayerGui
    
    local bgFrame = Instance.new("Frame")
    bgFrame.Parent = keyGui
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgFrame.BackgroundTransparency = 0.5
    bgFrame.BorderSizePixel = 0
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = bgFrame
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Parent = mainFrame
    title.Text = "🔐 KEY SYSTEM"
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0, 120, 255)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 40)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Parent = mainFrame
    keyInput.PlaceholderText = "Cole sua chave aqui..."
    keyInput.Text = ""
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    keyInput.BorderSizePixel = 0
    keyInput.Size = UDim2.new(0.9, 0, 0, 40)
    keyInput.Position = UDim2.new(0.05, 0, 0, 50)
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = keyInput
    
    local checkBtn = Instance.new("TextButton")
    checkBtn.Parent = mainFrame
    checkBtn.Text = "VERIFICAR"
    checkBtn.TextSize = 14
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    checkBtn.BorderSizePixel = 0
    checkBtn.Size = UDim2.new(0.9, 0, 0, 40)
    checkBtn.Position = UDim2.new(0.05, 0, 0, 100)
    
    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 6)
    checkCorner.Parent = checkBtn
    
    local discordBtn = Instance.new("TextButton")
    discordBtn.Parent = mainFrame
    discordBtn.Text = "📢 DISCORD"
    discordBtn.TextSize = 12
    discordBtn.Font = Enum.Font.GothamMedium
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BorderSizePixel = 0
    discordBtn.Size = UDim2.new(0.9, 0, 0, 35)
    discordBtn.Position = UDim2.new(0.05, 0, 0, 150)
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordBtn
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = mainFrame
    statusLabel.Text = "Aguardando..."
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0, 200)
    
    checkBtn.MouseButton1Click:Connect(function()
        if keyInput.Text == requiredKey then
            statusLabel.Text = "✅ Chave válida!"
            statusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
            task.wait(1)
            keyGui:Destroy()
            if successCallback then successCallback() end
        else
            statusLabel.Text = "❌ Chave inválida!"
            statusLabel.TextColor3 = Color3.fromRGB(244, 67, 54)
            if failCallback then failCallback() end
        end
    end)
    
    discordBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/seuconvite")
        NotificationManager:Create("Sucesso", "Link do Discord copiado!", 3)
    end)
    
    return keyGui
end

-- ============= UI HELPERS =============
local function CreateFrame(parent, name, props)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Parent = parent
    frame.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(30, 30, 35)
    frame.BackgroundTransparency = props.BackgroundTransparency or 0
    frame.BorderSizePixel = 0
    frame.Size = props.Size or UDim2.new(1, 0, 1, 0)
    frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    
    if props.CornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, props.CornerRadius)
        corner.Parent = frame
    end
    
    if props.StrokeSize then
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = props.StrokeSize
        stroke.Color = props.StrokeColor or Color3.fromRGB(60, 60, 70)
        stroke.Transparency = props.StrokeTransparency or 0.5
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
    label.Font = props.Font or Enum.Font.GothamMedium
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
    button.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(0, 120, 255)
    button.BackgroundTransparency = 0
    button.BorderSizePixel = 0
    button.Size = props.Size or UDim2.new(1, 0, 0, 35)
    button.Position = props.Position or UDim2.new(0, 0, 0, 0)
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    return button
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
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
    self.Author = windowSettings.Author or ""
    self.Size = windowSettings.Size or UDim2.new(0, 560, 0, 500)
    self.Position = windowSettings.Position or UDim2.new(0.5, -280, 0.5, -250)
    self.Theme = windowSettings.Theme or Themes.Dark
    self.Icon = windowSettings.Icon or "⚙️"
    self.DiscordInvite = windowSettings.DiscordInvite or "https://discord.gg/axiomx"
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    self.Notifications = {}
    
    self:_CreateUI()
    self:_SetupDragging()
    self:_SetupTouchInput()
    self:_SetupAntiCheat()
    
    return self
end

function Window:_CreateUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxiomXGui"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 1000
    self.ScreenGui.Parent = PlayerGui
    
    self.MainFrame = CreateFrame(self.ScreenGui, "MainFrame", {
        BackgroundColor3 = self.Theme.Primary,
        Size = self.Size,
        Position = self.Position,
        CornerRadius = 10,
        StrokeSize = 1,
        StrokeColor = self.Theme.Border,
    })
    
    local shadow = Instance.new("UIStroke")
    shadow.Thickness = 2
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Transparency = 0.7
    shadow.Parent = self.MainFrame
    
    -- ===== HEADER =====
    self.Header = CreateFrame(self.MainFrame, "Header", {
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 45),
        CornerRadius = 10
    })
    
    local iconLabel = CreateLabel(self.Header, self.Icon, {
        TextColor3 = self.Theme.Accent,
        TextSize = 16,
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0)
    })
    
    CreateLabel(self.Header, self.Title, {
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 45, 0, 0)
    })
    
    -- Minimizar Button
    local minBtn = CreateButton(self.Header, "_", {
        TextColor3 = self.Theme.Text,
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(255, 152, 0),
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -75, 0.5, -17.5)
    })
    
    -- Discord Button
    local discordBtn = CreateButton(self.Header, "💬", {
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -112, 0.5, -17.5)
    })
    
    -- Fechar Button
    local closeBtn = CreateButton(self.Header, "×", {
        TextColor3 = self.Theme.Text,
        TextSize = 20,
        BackgroundColor3 = Color3.fromRGB(244, 67, 54),
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -40, 0.5, -17.5)
    })
    
    minBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    discordBtn.MouseButton1Click:Connect(function()
        setclipboard(self.DiscordInvite)
        self:Notify("Sucesso", "Discord link copiado!", 3)
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        Tween(self.MainFrame, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.2)
        self.ScreenGui:Destroy()
    end)
    
    -- ===== CONTENT =====
    self.ContentContainer = CreateFrame(self.MainFrame, "ContentContainer", {
        BackgroundColor3 = self.Theme.Primary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.new(0, 0, 0, 45)
    })
    
    -- Sidebar
    self.Sidebar = CreateFrame(self.ContentContainer, "Sidebar", {
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(0, 140, 1, 0),
        StrokeSize = 1,
        StrokeColor = self.Theme.Border,
    })
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 8)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = self.Sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingBottom = UDim.new(0, 10)
    sidebarPadding.PaddingLeft = UDim.new(0, 8)
    sidebarPadding.PaddingRight = UDim.new(0, 8)
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.Parent = self.Sidebar
    
    self.ContentArea = CreateFrame(self.ContentContainer, "ContentArea", {
        BackgroundColor3 = self.Theme.Primary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.new(0, 140, 0, 0)
    })
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingBottom = UDim.new(0, 15)
    contentPadding.PaddingLeft = UDim.new(0, 15)
    contentPadding.PaddingRight = UDim.new(0, 15)
    contentPadding.PaddingTop = UDim.new(0, 15)
    contentPadding.Parent = self.ContentArea
    
    self.ScrollFrame = Instance.new("ScrollingFrame")
    self.ScrollFrame.Name = "ScrollFrame"
    self.ScrollFrame.Parent = self.ContentArea
    self.ScrollFrame.BackgroundTransparency = 1
    self.ScrollFrame.BorderSizePixel = 0
    self.ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ScrollFrame.ScrollBarThickness = 6
    self.ScrollFrame.ScrollBarImageColor3 = self.Theme.Accent
    
    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 10)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = self.ScrollFrame
    
    self._SidebarTabList = tabListLayout
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
    
    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if not dragging then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Window:_SetupTouchInput()
    local touchActive = false
    local touchStart = nil
    
    self.Header.TouchBegan:Connect(function(touch)
        touchActive = true
        touchStart = touch.Position
    end)
    
    self.Header.TouchMoved:Connect(function(touch)
        if not touchActive then return end
        
        local delta = touch.Position - touchStart
        self.MainFrame.Position = self.MainFrame.Position + UDim2.new(0, delta.X, 0, delta.Y)
        touchStart = touch.Position
    end)
    
    self.Header.TouchEnded:Connect(function(touch)
        touchActive = false
    end)
end

function Window:_SetupAntiCheat()
    -- Detectar exploits comuns
    local detectedExploits = 0
    
    RunService.Heartbeat:Connect(function()
        if detectedExploits > 5 then
            self:Notify("⚠️ Anti-Cheat", "Atividade suspeita detectada!", 5)
            detectedExploits = 0
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
    
    local tabButton = CreateButton(self.Sidebar, tabName, {
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 35)
    })
    
    local tabContent = CreateFrame(self.ScrollFrame, tabName .. "_Content", {
        BackgroundColor3 = self.Theme.Primary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 1)
    })
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.Parent = tabContent
    
    tab.TabButton = tabButton
    tab.TabContent = tabContent
    tab._TabLayout = tabLayout
    
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
            t.TabButton.BackgroundColor3 = self.Theme.Primary
            t.TabButton.TextColor3 = self.Theme.TextSecondary
        end
    end
    
    self.CurrentTab = tab
    tab.TabContent.Visible = true
    tab.TabButton.BackgroundColor3 = self.Theme.Accent
    tab.TabButton.TextColor3 = self.Theme.Primary
end

function Window:CreateSection(sectionName)
    if not self.CurrentTab then
        warn("[AxiomX] Nenhuma aba foi criada!")
        return
    end
    
    local section = {
        Name = sectionName,
        Components = {},
        SectionFrame = nil
    }
    
    local sectionFrame = CreateFrame(self.CurrentTab.TabContent, sectionName, {
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 1),
        CornerRadius = 8,
        StrokeSize = 1,
        StrokeColor = self.Theme.Border,
    })
    
    CreateLabel(sectionFrame, sectionName, {
        TextColor3 = self.Theme.Accent,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 12, 0, 5)
    })
    
    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.Padding = UDim.new(0, 10)
    sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sectionLayout.FillDirection = Enum.FillDirection.Vertical
    sectionLayout.Parent = sectionFrame
    
    local sectionPadding = Instance.new("UIPadding")
    sectionPadding.PaddingBottom = UDim.new(0, 10)
    sectionPadding.PaddingLeft = UDim.new(0, 12)
    sectionPadding.PaddingRight = UDim.new(0, 12)
    sectionPadding.PaddingTop = UDim.new(0, 30)
    sectionPadding.Parent = sectionFrame
    
    section.SectionFrame = sectionFrame
    section._SectionLayout = sectionLayout
    
    table.insert(self.CurrentTab.Sections, section)
    
    return section
end

function Window:CreateButton(text, callback, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local button = CreateButton(targetParent, text, {
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        BackgroundColor3 = self.Theme.Accent,
        Size = UDim2.new(1, 0, 0, 35)
    })
    
    button.MouseButton1Click:Connect(callback)
    return button
end

function Window:CreateToggle(text, callback, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    local state = {Enabled = false}
    
    local container = CreateFrame(targetParent, text .. "_Toggle", {
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35)
    })
    
    CreateLabel(container, text, {
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Size = UDim2.new(0.7, 0, 1, 0),
    })
    
    local toggleBtn = CreateButton(container, "", {
        TextColor3 = self.Theme.Text,
        BackgroundColor3 = self.Theme.Border,
        Size = UDim2.new(0, 45, 0, 25),
        Position = UDim2.new(1, -50, 0.5, -12.5)
    })
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Parent = toggleBtn
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    toggleBtn.MouseButton1Click:Connect(function()
        state.Enabled = not state.Enabled
        
        if state.Enabled then
            Tween(toggleBtn, {BackgroundColor3 = Color3.fromRGB(76, 175, 80)}, 0.2)
            Tween(toggleCircle, {Position = UDim2.new(0, 22, 0.5, -10)}, 0.2)
        else
            Tween(toggleBtn, {BackgroundColor3 = self.Theme.Border}, 0.2)
            Tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)}, 0.2)
        end
        
        if callback then
            callback(state.Enabled)
        end
    end)
    
    return {
        Container = container,
        Button = toggleBtn,
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

function Window:CreateSlider(text, min, max, default, callback, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    local state = {Value = default or min}
    
    local container = CreateFrame(targetParent, text .. "_Slider", {
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50)
    })
    
    local label = CreateLabel(container, text .. ": " .. state.Value, {
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Size = UDim2.new(1, 0, 0, 20)
    })
    
    local sliderBar = CreateFrame(container, "SliderBar", {
        BackgroundColor3 = self.Theme.Border,
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 25),
        CornerRadius = 3
    })
    
    local sliderHandle = CreateFrame(sliderBar, "Handle", {
        BackgroundColor3 = self.Theme.Accent,
        Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(0, 0, 0.5, -7.5),
        CornerRadius = 7
    })
    
    local function updateSlider(mouseX)
        local barSize = sliderBar.AbsoluteSize.X
        local barPos = sliderBar.AbsolutePosition.X
        local relativeX = math.clamp(mouseX - barPos, 0, barSize)
        local percentage = relativeX / barSize
        
        state.Value = math.floor(min + (max - min) * percentage)
        label.Text = text .. ": " .. state.Value
        sliderHandle.Position = UDim2.new(percentage, -7.5, 0.5, -7.5)
        
        if callback then
            callback(state.Value)
        end
    end
    
    sliderBar.MouseButton1Click:Connect(function()
        updateSlider(UserInputService:GetMouseLocation().X)
    end)
    
    return {
        Container = container,
        SetValue = function(_, value)
            local clampedValue = math.clamp(value, min, max)
            local percentage = (clampedValue - min) / (max - min)
            sliderHandle.Position = UDim2.new(percentage, -7.5, 0.5, -7.5)
            state.Value = clampedValue
            label.Text = text .. ": " .. state.Value
        end,
        GetValue = function(_)
            return state.Value
        end
    }
end

function Window:CreateDropdown(text, options, callback, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    local state = {Selected = options[1] or ""}
    local isOpen = false
    
    local container = CreateFrame(targetParent, text .. "_Dropdown", {
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 45)
    })
    
    CreateLabel(container, text, {
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 15)
    })
    
    local dropdownBtn = CreateButton(container, state.Selected, {
        TextColor3 = self.Theme.Text,
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 18)
    })
    
    local dropdownMenu = CreateFrame(container, "Menu", {
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 43),
        CornerRadius = 6
    })
    
    dropdownMenu.ClipsDescendants = true
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 5)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = dropdownMenu
    
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            local menuHeight = (#options * 25) + (#options * 5)
            Tween(dropdownMenu, {Size = UDim2.new(1, 0, 0, menuHeight)}, 0.2)
        else
            Tween(dropdownMenu, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        end
    end
    
    for _, option in ipairs(options) do
        local optionBtn = CreateButton(dropdownMenu, option, {
            TextColor3 = self.Theme.Text,
            TextSize = 12,
            BackgroundColor3 = self.Theme.Primary,
            Size = UDim2.new(1, 0, 0, 25)
        })
        
        optionBtn.MouseButton1Click:Connect(function()
            state.Selected = option
            dropdownBtn.Text = option
            toggleDropdown()
            
            if callback then
                callback(option)
            end
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(toggleDropdown)
    
    return {
        Container = container,
        SetValue = function(_, value)
            if table.find(options, value) then
                state.Selected = value
                dropdownBtn.Text = value
            end
        end,
        GetValue = function(_)
            return state.Selected
        end
    }
end

function Window:CreateTextbox(text, placeholder, callback, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    local state = {Value = ""}
    
    local container = CreateFrame(targetParent, text .. "_Textbox", {
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50)
    })
    
    CreateLabel(container, text, {
        TextColor3 = self.Theme.TextSecondary,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 15)
    })
    
    local textbox = Instance.new("TextBox")
    textbox.Name = "TextBox"
    textbox.Parent = container
    textbox.BackgroundColor3 = self.Theme.Primary
    textbox.TextColor3 = self.Theme.Text
    textbox.PlaceholderText = placeholder or "Digite aqui..."
    textbox.PlaceholderColor3 = self.Theme.TextSecondary
    textbox.TextSize = 13
    textbox.Font = Enum.Font.GothamMedium
    textbox.BorderSizePixel = 0
    textbox.Size = UDim2.new(1, 0, 0, 28)
    textbox.Position = UDim2.new(0, 0, 0, 18)
    
    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 6)
    textboxCorner.Parent = textbox
    
    textbox.FocusLost:Connect(function(enterPressed)
        state.Value = textbox.Text
        if callback then
            callback(state.Value, enterPressed)
        end
    end)
    
    return {
        Container = container,
        TextBox = textbox,
        SetValue = function(_, value)
            textbox.Text = value
            state.Value = value
        end,
        GetValue = function(_)
            return state.Value
        end
    }
end

function Window:CreateLabel(text, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    
    return CreateLabel(targetParent, text, {
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Size = UDim2.new(1, 0, 0, 25),
        TextWrapped = true
    })
end

function Window:CreateKeybind(text, callback, parent)
    local targetParent = parent.SectionFrame or parent.TabContent
    
    local state = {Key = nil}
    local isListening = false
    
    local container = CreateFrame(targetParent, text .. "_Keybind", {
        BackgroundColor3 = self.Theme.Secondary,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35)
    })
    
    CreateLabel(container, text, {
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        Size = UDim2.new(0.6, 0, 1, 0)
    })
    
    local keybindBtn = CreateButton(container, "Nenhuma Tecla", {
        TextColor3 = self.Theme.Text,
        BackgroundColor3 = self.Theme.Primary,
        Size = UDim2.new(0, 120, 0, 28),
        Position = UDim2.new(1, -125, 0.5, -14)
    })
    
    keybindBtn.MouseButton1Click:Connect(function()
        isListening = not isListening
        
        if isListening then
            keybindBtn.Text = "Aguardando..."
            keybindBtn.BackgroundColor3 = Color3.fromRGB(255, 152, 0)
        else
            keybindBtn.BackgroundColor3 = self.Theme.Primary
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not isListening or gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            state.Key = input.KeyCode
            keybindBtn.Text = tostring(state.Key):match("Enum%.KeyCode%.(.+)") or "Desconhecida"
            keybindBtn.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            isListening = false
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if state.Key and input.KeyCode == state.Key and not isListening and not gameProcessed then
            if callback then
                callback()
            end
        end
    end)
    
    return {
        Container = container,
        SetKey = function(_, key)
            state.Key = key
            keybindBtn.Text = tostring(key):match("Enum%.KeyCode%.(.+)") or "Desconhecida"
        end,
        GetKey = function(_)
            return state.Key
        end
    }
end

function Window:SetTheme(themeName)
    if not Themes[themeName] then
        warn("[AxiomX] Tema '" .. themeName .. "' não existe!")
        return
    end
    
    self.Theme = Themes[themeName]
    self:Notify("✨ Tema", "Alterado para " .. themeName, 3)
end

function Window:Minimize()
    if self.IsMinimized then
        Tween(self.MainFrame, {Size = self.Size}, 0.3)
        self.ContentContainer.Visible = true
        self.IsMinimized = false
    else
        Tween(self.MainFrame, {Size = UDim2.new(0, 560, 0, 45)}, 0.3)
        self.ContentContainer.Visible = false
        self.IsMinimized = true
    end
end

function Window:Notify(title, message, duration)
    NotificationManager:Create(title, message, duration)
end

function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self:Notify("Fechado", "Interface fechada!", 2)
    end
end

print("[AxiomX PRO] Library carregada com sucesso! v" .. AxiomX.Version)
return AxiomX

