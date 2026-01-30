--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║              AXIOMX PRO UI LIBRARY v2.1                       ║
    ║                                                                ║
    ║  Framework profissional e otimizado para Roblox               ║
    ║  Com Key System, Temas, Animações e Sistema Modular          ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local AxiomX = {}
AxiomX.__index = AxiomX
AxiomX.Version = "2.1"

-- Serviços
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

if not RunService:IsClient() then
    error("[AxiomX] Esta library deve ser executada no Cliente!")
    return
end

-- Referências
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cache de objetos
local ThemeObjects = {}
local Components = {}

-- ============= CONSTANTES E CONFIGURAÇÕES =============
local CONFIG = {
    DEFAULT_SIZE = UDim2.new(0, 560, 0, 500),
    DEFAULT_POSITION = UDim2.new(0.5, -280, 0.5, -250),
    ANIMATION_SPEED = 0.2,
    NOTIFICATION_LIMIT = 5,
    SCROLLBAR_THICKNESS = 6,
    EASING_STYLE = Enum.EasingStyle.Quad,
    EASING_DIRECTION = Enum.EasingDirection.InOut
}

-- ============= TEMAS OTIMIZADOS =============
AxiomX.Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 35),
        Secondary = Color3.fromRGB(40, 40, 45),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(60, 60, 70),
        Success = Color3.fromRGB(76, 175, 80),
        Warning = Color3.fromRGB(255, 152, 0),
        Error = Color3.fromRGB(244, 67, 54)
    },
    Dracula = {
        Primary = Color3.fromRGB(40, 42, 54),
        Secondary = Color3.fromRGB(48, 51, 66),
        Accent = Color3.fromRGB(189, 147, 249),
        Text = Color3.fromRGB(248, 248, 242),
        TextSecondary = Color3.fromRGB(98, 114, 164),
        Border = Color3.fromRGB(68, 71, 90),
        Success = Color3.fromRGB(80, 250, 123),
        Warning = Color3.fromRGB(255, 184, 108),
        Error = Color3.fromRGB(255, 85, 85)
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(13, 15, 20),
        Secondary = Color3.fromRGB(25, 30, 45),
        Accent = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(0, 200, 200),
        Success = Color3.fromRGB(0, 255, 153),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 102)
    },
    Rose = {
        Primary = Color3.fromRGB(35, 30, 40),
        Secondary = Color3.fromRGB(50, 40, 55),
        Accent = Color3.fromRGB(255, 100, 150),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 180, 200),
        Border = Color3.fromRGB(80, 60, 80),
        Success = Color3.fromRGB(123, 237, 159),
        Warning = Color3.fromRGB(255, 203, 107),
        Error = Color3.fromRGB(255, 107, 107)
    }
}

-- ============= UTILITÁRIOS =============
local Utils = {}

function Utils.CreateClass(base)
    local class = {}
    class.__index = class
    
    if base then
        setmetatable(class, {__index = base})
    end
    
    function class:new(...)
        local instance = setmetatable({}, class)
        if instance.constructor then
            instance:constructor(...)
        end
        return instance
    end
    
    return class
end

function Utils.Tween(object, properties, duration)
    duration = duration or CONFIG.ANIMATION_SPEED
    
    local tweenInfo = TweenInfo.new(
        duration,
        CONFIG.EASING_STYLE,
        CONFIG.EASING_DIRECTION
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utils.RoundCorners(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

function Utils.AddStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end

function Utils.AddShadow(object)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 14, 1, 14)
    shadow.Position = UDim2.new(0, -7, 0, -7)
    shadow.Parent = object
    shadow.ZIndex = object.ZIndex - 1
    return shadow
end

-- ============= NOTIFICATION MANAGER =============
local NotificationManager = Utils.CreateClass()

function NotificationManager:constructor()
    self.ActiveNotifications = {}
    self.Queue = {}
    self.Container = nil
    self:Initialize()
end

function NotificationManager:Initialize()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AxiomXNotifications"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 9999
    screenGui.Parent = PlayerGui
    
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.BackgroundTransparency = 1
    self.Container.Size = UDim2.new(0, 320, 1, -40)
    self.Container.Position = UDim2.new(1, -340, 0, 20)
    self.Container.Parent = screenGui
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.Parent = self.Container
end

function NotificationManager:Show(title, message, options)
    options = options or {}
    local duration = options.Duration or 3
    local theme = options.Theme or AxiomX.Themes.Dark
    
    -- Limitar notificações ativas
    if #self.ActiveNotifications >= CONFIG.NOTIFICATION_LIMIT then
        table.insert(self.Queue, {title, message, options})
        return
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.BackgroundColor3 = theme.Secondary
    notification.BorderSizePixel = 0
    notification.Size = UDim2.new(0, 300, 0, 0)
    notification.ClipsDescendants = true
    
    Utils.RoundCorners(notification, 8)
    Utils.AddStroke(notification, theme.Border)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Accent
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Text = message
    messageLabel.TextColor3 = theme.Text
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextWrapped = true
    messageLabel.BackgroundTransparency = 1
    messageLabel.Size = UDim2.new(1, -20, 0, 0)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Parent = notification
    
    -- Calcular altura do texto
    local textSize = TextService:GetTextSize(message, 12, Enum.Font.GothamMedium, Vector2.new(280, math.huge))
    local messageHeight = math.clamp(textSize.Y, 20, 100)
    local totalHeight = 45 + messageHeight
    
    notification.Size = UDim2.new(0, 300, 0, totalHeight)
    messageLabel.Size = UDim2.new(1, -20, 0, messageHeight)
    
    -- Barra de progresso
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.BackgroundColor3 = theme.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.Parent = notification
    
    Utils.RoundCorners(progressBar, 2)
    
    notification.Parent = self.Container
    table.insert(self.ActiveNotifications, notification)
    
    -- Animação de entrada
    notification.Position = UDim2.new(1, 320, 0, 0)
    Utils.Tween(notification, {
        Position = UDim2.new(1, 0, 0, 0)
    }, 0.3)
    
    -- Animação da barra de progresso
    local progressTween = Utils.Tween(progressBar, {
        Size = UDim2.new(0, 0, 0, 3)
    }, duration)
    
    -- Fechar após duração
    task.delay(duration, function()
        Utils.Tween(notification, {
            Position = UDim2.new(1, 320, 0, 0)
        }, 0.3).Completed:Connect(function()
            notification:Destroy()
            
            for i, notif in ipairs(self.ActiveNotifications) do
                if notif == notification then
                    table.remove(self.ActiveNotifications, i)
                    break
                end
            end
            
            -- Processar fila
            if #self.Queue > 0 then
                local nextNotif = table.remove(self.Queue, 1)
                task.wait(0.5)
                self:Show(unpack(nextNotif))
            end
        end)
    end)
    
    return notification
end

-- ============= KEY SYSTEM =============
AxiomX.KeySystem = {}

function AxiomX.KeySystem:Create(options)
    options = options or {}
    
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "AxiomXKeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.DisplayOrder = 10000
    keyGui.Parent = PlayerGui
    
    local container = Instance.new("Frame")
    container.BackgroundColor3 = Color3.new(0, 0, 0)
    container.BackgroundTransparency = 0.4
    container.Size = UDim2.new(1, 0, 1, 0)
    container.Parent = keyGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    mainFrame.BackgroundColor3 = AxiomX.Themes.Dark.Primary
    mainFrame.Parent = container
    
    Utils.RoundCorners(mainFrame, 12)
    Utils.AddShadow(mainFrame)
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Text = "🔐 KEY VERIFICATION"
    title.TextColor3 = AxiomX.Themes.Dark.Accent
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Parent = mainFrame
    
    -- Input
    local inputFrame = Instance.new("Frame")
    inputFrame.BackgroundColor3 = AxiomX.Themes.Dark.Secondary
    inputFrame.Size = UDim2.new(0.9, 0, 0, 40)
    inputFrame.Position = UDim2.new(0.05, 0, 0, 60)
    inputFrame.Parent = mainFrame
    
    Utils.RoundCorners(inputFrame, 8)
    
    local keyInput = Instance.new("TextBox")
    keyInput.PlaceholderText = "Enter your key..."
    keyInput.Text = ""
    keyInput.TextColor3 = AxiomX.Themes.Dark.Text
    keyInput.PlaceholderColor3 = AxiomX.Themes.Dark.TextSecondary
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.BackgroundTransparency = 1
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.Parent = inputFrame
    
    -- Botões
    local buttonFrame = Instance.new("Frame")
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Size = UDim2.new(0.9, 0, 0, 40)
    buttonFrame.Position = UDim2.new(0.05, 0, 0, 110)
    buttonFrame.Parent = mainFrame
    
    local function createButton(text, color, position)
        local button = Instance.new("TextButton")
        button.Text = text
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 14
        button.Font = Enum.Font.GothamBold
        button.BackgroundColor3 = color
        button.Size = UDim2.new(0.48, 0, 1, 0)
        button.Position = position
        button.Parent = buttonFrame
        
        Utils.RoundCorners(button, 6)
        
        return button
    end
    
    local verifyBtn = createButton("VERIFY", AxiomX.Themes.Dark.Accent, UDim2.new(0, 0, 0, 0))
    local discordBtn = createButton("DISCORD", Color3.fromRGB(88, 101, 242), UDim2.new(0.52, 0, 0, 0))
    
    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Waiting for key..."
    statusLabel.TextColor3 = AxiomX.Themes.Dark.TextSecondary
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.BackgroundTransparency = 1
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0, 160)
    statusLabel.Parent = mainFrame
    
    -- Eventos
    verifyBtn.MouseButton1Click:Connect(function()
        local inputKey = keyInput.Text:gsub("%s+", "")
        
        if inputKey == options.RequiredKey then
            statusLabel.Text = "✅ Key verified!"
            statusLabel.TextColor3 = AxiomX.Themes.Dark.Success
            
            task.wait(1)
            Utils.Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
                keyGui:Destroy()
                if options.OnSuccess then
                    options.OnSuccess()
                end
            end)
        else
            statusLabel.Text = "❌ Invalid key!"
            statusLabel.TextColor3 = AxiomX.Themes.Dark.Error
            
            if options.OnFail then
                options.OnFail()
            end
        end
    end)
    
    discordBtn.MouseButton1Click:Connect(function()
        if options.DiscordInvite then
            setclipboard(options.DiscordInvite)
            statusLabel.Text = "Discord link copied!"
            statusLabel.TextColor3 = AxiomX.Themes.Dark.Accent
        end
    end)
    
    return keyGui
end

-- ============= WINDOW CLASS =============
local Window = Utils.CreateClass()

function Window:constructor(settings)
    settings = settings or {}
    
    self.Title = settings.Title or "AxiomX"
    self.Size = settings.Size or CONFIG.DEFAULT_SIZE
    self.Position = settings.Position or CONFIG.DEFAULT_POSITION
    self.Theme = settings.Theme or AxiomX.Themes.Dark
    self.Icon = settings.Icon or "⚙️"
    self.DiscordInvite = settings.DiscordInvite or "https://discord.gg/axiomx"
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    self.IsVisible = true
    
    self.Notifications = NotificationManager:new()
    self.Components = {}
    
    self:_Initialize()
    self:_SetupInput()
end

function Window:_Initialize()
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "AxiomX_" .. HttpService:GenerateGUID(false):sub(1, 8)
    self.Gui.ResetOnSpawn = false
    self.Gui.DisplayOrder = 1000
    self.Gui.Parent = PlayerGui
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = self.Theme.Primary
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.Gui
    
    Utils.RoundCorners(self.MainFrame, 12)
    Utils.AddStroke(self.MainFrame, self.Theme.Border)
    Utils.AddShadow(self.MainFrame)
    
    self:_CreateHeader()
    self:_CreateContent()
end

function Window:_CreateHeader()
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.BackgroundColor3 = self.Theme.Secondary
    self.Header.Size = UDim2.new(1, 0, 0, 45)
    self.Header.Parent = self.MainFrame
    
    Utils.RoundCorners(self.Header, 12)
    
    -- Título
    local titleContainer = Instance.new("Frame")
    titleContainer.BackgroundTransparency = 1
    titleContainer.Size = UDim2.new(0.6, 0, 1, 0)
    titleContainer.Position = UDim2.new(0, 10, 0, 0)
    titleContainer.Parent = self.Header
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = self.Icon
    iconLabel.TextColor3 = self.Theme.Accent
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Parent = titleContainer
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -35, 1, 0)
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleContainer
    
    -- Botões da barra
    self:_CreateHeaderButtons()
    
    -- Drag
    self:_SetupDrag()
end

function Window:_CreateHeaderButtons()
    local buttons = {
        {"Discord", "💬", Color3.fromRGB(88, 101, 242), function()
            if self.DiscordInvite then
                setclipboard(self.DiscordInvite)
                self:Notify("Discord", "Link copied to clipboard!")
            end
        end},
        {"Minimize", "_", self.Theme.Warning, function()
            self:ToggleMinimize()
        end},
        {"Close", "×", self.Theme.Error, function()
            self:Destroy()
        end}
    }
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Size = UDim2.new(0, 120, 1, 0)
    buttonContainer.Position = UDim2.new(1, -130, 0, 0)
    buttonContainer.Parent = self.Header
    
    local buttonList = Instance.new("UIListLayout")
    buttonList.FillDirection = Enum.FillDirection.Horizontal
    buttonList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonList.Padding = UDim.new(0, 5)
    buttonList.SortOrder = Enum.SortOrder.LayoutOrder
    buttonList.Parent = buttonContainer
    
    for i, btnData in ipairs(buttons) do
        local button = Instance.new("TextButton")
        button.Name = btnData[1]
        button.Text = btnData[2]
        button.TextColor3 = Color3.new(1, 1, 1)
        button.TextSize = 16
        button.Font = Enum.Font.GothamBold
        button.BackgroundColor3 = btnData[3]
        button.Size = UDim2.new(0, 35, 0, 35)
        button.Position = UDim2.new(1, -40 * i, 0.5, -17.5)
        button.Parent = buttonContainer
        
        Utils.RoundCorners(button, 8)
        
        button.MouseButton1Click:Connect(btnData[4])
    end
end

function Window:_SetupDrag()
    local dragging = false
    local dragStart, frameStart
    
    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            frameStart = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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

function Window:_CreateContent()
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.BackgroundTransparency = 1
    self.Content.Size = UDim2.new(1, 0, 1, -45)
    self.Content.Position = UDim2.new(0, 0, 0, 45)
    self.Content.Parent = self.MainFrame
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundColor3 = self.Theme.Secondary
    self.Sidebar.Size = UDim2.new(0, 140, 1, 0)
    self.Sidebar.Parent = self.Content
    
    local sidebarList = Instance.new("UIListLayout")
    sidebarList.Padding = UDim.new(0, 8)
    sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarList.Parent = self.Sidebar
    
    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.PaddingLeft = UDim.new(0, 8)
    sidebarPadding.PaddingRight = UDim.new(0, 8)
    sidebarPadding.PaddingBottom = UDim.new(0, 10)
    sidebarPadding.Parent = self.Sidebar
    
    -- Área principal
    self.MainArea = Instance.new("Frame")
    self.MainArea.Name = "MainArea"
    self.MainArea.BackgroundTransparency = 1
    self.MainArea.Size = UDim2.new(1, -140, 1, 0)
    self.MainArea.Position = UDim2.new(0, 140, 0, 0)
    self.MainArea.Parent = self.Content
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.ScrollBarThickness = CONFIG.SCROLLBAR_THICKNESS
    scrollFrame.ScrollBarImageColor3 = self.Theme.Accent
    scrollFrame.Parent = self.MainArea
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = scrollFrame
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = scrollFrame
    
    self.ScrollFrame = scrollFrame
end

function Window:_SetupInput()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.RightControl then
            self:ToggleVisibility()
        end
    end)
end

-- ============= MÉTODOS PÚBLICOS =============

function Window:CreateTab(name)
    local tab = {
        Name = name,
        Sections = {},
        Button = nil,
        Content = nil
    }
    
    -- Botão da sidebar
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name
    tabButton.Text = name
    tabButton.TextColor3 = self.Theme.Text
    tabButton.TextSize = 13
    tabButton.Font = Enum.Font.GothamMedium
    tabButton.BackgroundColor3 = self.Theme.Primary
    tabButton.Size = UDim2.new(1, 0, 0, 35)
    tabButton.Parent = self.Sidebar
    
    Utils.RoundCorners(tabButton, 6)
    
    -- Conteúdo da tab
    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "Content"
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.Visible = false
    tabContent.Parent = self.ScrollFrame
    
    tab.Button = tabButton
    tab.Content = tabContent
    
    -- Evento de clique
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if not self.CurrentTab then
        self:SwitchTab(tab)
    end
    
    return tab
end

function Window:SwitchTab(tab)
    for _, t in ipairs(self.Tabs) do
        if t.Content then
            t.Content.Visible = false
            t.Button.BackgroundColor3 = self.Theme.Primary
        end
    end
    
    self.CurrentTab = tab
    tab.Content.Visible = true
    tab.Button.BackgroundColor3 = self.Theme.Accent
    
    -- Ajustar altura
    task.wait()
    if tab.Content:FindFirstChildWhichIsA("UIListLayout") then
        local list = tab.Content:FindFirstChildWhichIsA("UIListLayout")
        tab.Content.Size = UDim2.new(1, 0, 0, list.AbsoluteContentSize.Y)
    end
end

function Window:CreateSection(name)
    if not self.CurrentTab then
        error("No tab selected!")
        return
    end
    
    local section = {
        Name = name,
        Frame = nil
    }
    
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = name
    sectionFrame.BackgroundColor3 = self.Theme.Secondary
    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
    sectionFrame.Parent = self.CurrentTab.Content
    
    Utils.RoundCorners(sectionFrame, 8)
    Utils.AddStroke(sectionFrame, self.Theme.Border)
    
    local title = Instance.new("TextLabel")
    title.Text = string.upper(name)
    title.TextColor3 = self.Theme.Accent
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = sectionFrame
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, 30)
    content.Parent = sectionFrame
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 8)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = content
    
    section.Frame = sectionFrame
    section.Content = content
    
    -- Atualizar altura
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentHeight = contentList.AbsoluteContentSize.Y
        sectionFrame.Size = UDim2.new(1, 0, 0, 30 + contentHeight + 15)
    end)
    
    table.insert(self.CurrentTab.Sections, section)
    
    return section
end

function Window:CreateButton(name, callback, parent)
    parent = parent or self.CurrentTab
    
    local target = parent.Content or parent.Frame
    if not target then return end
    
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.BackgroundColor3 = self.Theme.Accent
    button.Size = UDim2.new(1, 0, 0, 35)
    button.Parent = target
    
    Utils.RoundCorners(button, 6)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function Window:CreateToggle(name, default, callback, parent)
    parent = parent or self.CurrentTab
    
    local target = parent.Content or parent.Frame
    if not target then return end
    
    local state = default or false
    
    local container = Instance.new("Frame")
    container.Name = name .. "Toggle"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 25)
    container.Parent = target
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.TextColor3 = self.Theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("Frame")
    toggle.BackgroundColor3 = state and self.Theme.Accent or self.Theme.Border
    toggle.Size = UDim2.new(0, 45, 0, 25)
    toggle.Position = UDim2.new(1, -50, 0, 0)
    toggle.Parent = container
    
    Utils.RoundCorners(toggle, 12)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Text = ""
    toggleButton.BackgroundTransparency = 1
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Parent = toggle
    
    local circle = Instance.new("Frame")
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    circle.Parent = toggle
    
    Utils.RoundCorners(circle, 9)
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        
        Utils.Tween(toggle, {
            BackgroundColor3 = state and self.Theme.Accent or self.Theme.Border
        })
        
        Utils.Tween(circle, {
            Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        })
        
        if callback then
            callback(state)
        end
    end)
    
    local toggleObj = {
        SetValue = function(value)
            if value ~= state then
                toggleButton:MouseButton1Click()
            end
        end,
        GetValue = function()
            return state
        end
    }
    
    return toggleObj
end

function Window:CreateSlider(name, min, max, default, callback, parent)
    parent = parent or self.CurrentTab
    
    local target = parent.Content or parent.Frame
    if not target then return end
    
    local value = default or min
    
    local container = Instance.new("Frame")
    container.Name = name .. "Slider"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 50)
    container.Parent = target
    
    local topRow = Instance.new("Frame")
    topRow.BackgroundTransparency = 1
    topRow.Size = UDim2.new(1, 0, 0, 20)
    topRow.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.TextColor3 = self.Theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = topRow
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = self.Theme.TextSecondary
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = topRow
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.BackgroundColor3 = self.Theme.Border
    sliderTrack.Size = UDim2.new(1, 0, 0, 5)
    sliderTrack.Position = UDim2.new(0, 0, 0, 30)
    sliderTrack.Parent = container
    
    Utils.RoundCorners(sliderTrack, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.BackgroundColor3 = self.Theme.Accent
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Parent = sliderTrack
    
    Utils.RoundCorners(sliderFill, 3)
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderHandle.Size = UDim2.new(0, 15, 0, 15)
    sliderHandle.Position = UDim2.new(0, -7, 0.5, -7)
    sliderHandle.Parent = sliderTrack
    
    Utils.RoundCorners(sliderHandle, 7)
    
    local function updateSlider(input)
        local absolutePos = input.Position.X
        local trackPos = sliderTrack.AbsolutePosition.X
        local trackSize = sliderTrack.AbsoluteSize.X
        
        local relativePos = math.clamp(absolutePos - trackPos, 0, trackSize)
        local percentage = relativePos / trackSize
        
        value = math.floor(min + (max - min) * percentage)
        valueLabel.Text = tostring(value)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percentage, -7, 0.5, -7)
        
        if callback then
            callback(value)
        end
    end
    
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input)
            
            local connection
            connection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(moveInput)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end
    end
    
    sliderTrack.InputBegan:Connect(beginDrag)
    
    -- Inicializar
    local initialPercentage = (value - min) / (max - min)
    sliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
    sliderHandle.Position = UDim2.new(initialPercentage, -7, 0.5, -7)
    
    local sliderObj = {
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            valueLabel.Text = tostring(value)
            
            local percentage = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percentage, -7, 0.5, -7)
        end,
        GetValue = function()
            return value
        end
    }
    
    return sliderObj
end

function Window:CreateLabel(text, parent)
    parent = parent or self.CurrentTab
    
    local target = parent.Content or parent.Frame
    if not target then return end
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = self.Theme.TextSecondary
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextWrapped = true
    label.Parent = target
    
    return label
end

function Window:Notify(title, message, options)
    options = options or {}
    options.Theme = options.Theme or self.Theme
    
    return self.Notifications:Show(title, message, options)
end

function Window:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    if self.IsMinimized then
        Utils.Tween(self.MainFrame, {
            Size = UDim2.new(0, self.Size.X.Offset, 0, 45)
        })
    else
        Utils.Tween(self.MainFrame, {
            Size = self.Size
        })
    end
end

function Window:ToggleVisibility()
    self.IsVisible = not self.IsVisible
    self.Gui.Enabled = self.IsVisible
end

function Window:SetTheme(themeName)
    if AxiomX.Themes[themeName] then
        self.Theme = AxiomX.Themes[themeName]
        self:Notify("Theme", "Changed to " .. themeName)
    else
        warn("Theme '" .. themeName .. "' not found!")
    end
end

function Window:Destroy()
    if self.Gui then
        self.Gui:Destroy()
    end
end

-- ============= API PÚBLICA =============
function AxiomX:CreateWindow(options)
    return Window:new(options)
end

function AxiomX:Notify(title, message, options)
    local notificationManager = NotificationManager:new()
    return notificationManager:Show(title, message, options)
end

function AxiomX:GetTheme(name)
    return AxiomX.Themes[name] or AxiomX.Themes.Dark
end

-- Mensagem de inicialização
print("╔════════════════════════════════════════════════════════════════╗")
print("║                    AXIOMX PRO UI v2.1                         ║")
print("║                 Successfully loaded!                          ║")
print("╚════════════════════════════════════════════════════════════════╝")

return AxiomX
