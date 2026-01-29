-- BoladoHub Library v3.0
-- Biblioteca completa e otimizada com suporte a ícones
-- By: Bolado Hub Team

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ==================== SISTEMA DE ÍCONES INTEGRADO ====================
local IconAssets = {
    ["settings"] = "rbxassetid://10734950309",
    ["code"] = "rbxassetid://10709810463",
    ["shield"] = "rbxassetid://10734951847",
    ["gamepad"] = "rbxassetid://10723395457",
    ["eye"] = "rbxassetid://10723346959",
    ["star"] = "rbxassetid://10734966248",
    ["bolt"] = "rbxassetid://10709721749",
    ["wand"] = "rbxassetid://10747376565",
    ["crown"] = "rbxassetid://10709818626",
    ["user"] = "rbxassetid://10747373176",
    ["home"] = "rbxassetid://10723407389",
    ["sword"] = "rbxassetid://10734975486",
    ["music"] = "rbxassetid://10734905958",
    ["zap"] = "rbxassetid://10709721749",
    ["cog"] = "rbxassetid://10709810948",
    ["key"] = "rbxassetid://10723416652",
    ["wifi"] = "rbxassetid://10747382504",
    ["cpu"] = "rbxassetid://10709813383",
    ["battery"] = "rbxassetid://10709774640",
    ["flag"] = "rbxassetid://10723375890",
    ["chevron-down"] = "rbxassetid://10734904599",
    ["check"] = "rbxassetid://10709790387",
    ["paintbrush"] = "rbxassetid://10734910187",
    ["palette"] = "rbxassetid://10734910430",
    ["image"] = "rbxassetid://10723415040",
    ["sliders"] = "rbxassetid://10734963400",
    ["bell"] = "rbxassetid://10709775704",
    ["xcircle"] = "rbxassetid://10747383819",
    ["alertcircle"] = "rbxassetid://10709752996",
    ["info"] = "rbxassetid://10723415903",
    ["helpcircle"] = "rbxassetid://10723406988",
    ["folder"] = "rbxassetid://10723387563",
    ["search"] = "rbxassetid://10734943674",
    ["download"] = "rbxassetid://10723344270",
    ["upload"] = "rbxassetid://10747366434",
    ["copy"] = "rbxassetid://10709812159",
    ["trash"] = "rbxassetid://10747362393",
    ["play"] = "rbxassetid://10734923549",
    ["stopcircle"] = "rbxassetid://10734972621",
    ["refreshcw"] = "rbxassetid://10734933222",
    ["lock"] = "rbxassetid://10723434711"
}

local function GetIcon(iconName)
    return IconAssets[iconName] or IconAssets["bolt"]
end

-- ==================== TEMAS AVANÇADOS ====================
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(20, 20, 30),
        Accent = Color3.fromRGB(155, 89, 182),
        AccentLight = Color3.fromRGB(175, 109, 202),
        Text = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(180, 180, 190),
        Button = Color3.fromRGB(45, 45, 55),
        ButtonHover = Color3.fromRGB(55, 55, 65),
        ToggleOn = Color3.fromRGB(46, 204, 113),
        ToggleOff = Color3.fromRGB(70, 70, 80),
        SliderTrack = Color3.fromRGB(60, 60, 70),
        SliderFill = Color3.fromRGB(155, 89, 182),
        Border = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Secondary = Color3.fromRGB(235, 235, 240),
        Accent = Color3.fromRGB(52, 152, 219),
        AccentLight = Color3.fromRGB(72, 172, 239),
        Text = Color3.fromRGB(40, 40, 40),
        TextSecondary = Color3.fromRGB(100, 100, 110),
        Button = Color3.fromRGB(230, 230, 235),
        ButtonHover = Color3.fromRGB(220, 220, 225),
        ToggleOn = Color3.fromRGB(39, 174, 96),
        ToggleOff = Color3.fromRGB(200, 200, 210),
        SliderTrack = Color3.fromRGB(210, 210, 220),
        SliderFill = Color3.fromRGB(52, 152, 219),
        Border = Color3.fromRGB(210, 210, 220)
    },
    Ocean = {
        Background = Color3.fromRGB(20, 30, 48),
        Secondary = Color3.fromRGB(15, 25, 43),
        Accent = Color3.fromRGB(86, 98, 246),
        AccentLight = Color3.fromRGB(106, 118, 255),
        Text = Color3.fromRGB(230, 240, 255),
        TextSecondary = Color3.fromRGB(170, 190, 220),
        Button = Color3.fromRGB(35, 45, 63),
        ButtonHover = Color3.fromRGB(45, 55, 73),
        ToggleOn = Color3.fromRGB(29, 209, 161),
        ToggleOff = Color3.fromRGB(50, 60, 80),
        SliderTrack = Color3.fromRGB(60, 70, 90),
        SliderFill = Color3.fromRGB(86, 98, 246),
        Border = Color3.fromRGB(60, 70, 90)
    },
    Matrix = {
        Background = Color3.fromRGB(10, 15, 10),
        Secondary = Color3.fromRGB(5, 10, 5),
        Accent = Color3.fromRGB(0, 255, 0),
        AccentLight = Color3.fromRGB(50, 255, 50),
        Text = Color3.fromRGB(0, 255, 0),
        TextSecondary = Color3.fromRGB(100, 255, 100),
        Button = Color3.fromRGB(20, 25, 20),
        ButtonHover = Color3.fromRGB(30, 35, 30),
        ToggleOn = Color3.fromRGB(0, 255, 0),
        ToggleOff = Color3.fromRGB(40, 45, 40),
        SliderTrack = Color3.fromRGB(50, 55, 50),
        SliderFill = Color3.fromRGB(0, 255, 0),
        Border = Color3.fromRGB(60, 65, 60)
    },
    Sunset = {
        Background = Color3.fromRGB(25, 20, 30),
        Secondary = Color3.fromRGB(20, 15, 25),
        Accent = Color3.fromRGB(255, 118, 117),
        AccentLight = Color3.fromRGB(255, 138, 137),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(45, 40, 50),
        ButtonHover = Color3.fromRGB(55, 50, 60),
        ToggleOn = Color3.fromRGB(255, 159, 67),
        ToggleOff = Color3.fromRGB(70, 65, 75),
        SliderTrack = Color3.fromRGB(80, 75, 85),
        SliderFill = Color3.fromRGB(255, 118, 117),
        Border = Color3.fromRGB(80, 75, 85)
    }
}

-- ==================== CLASSE PRINCIPAL ====================
BoladoHub.__index = BoladoHub

-- Cache para melhor performance
local ComponentCache = {}

function BoladoHub.new(options)
    local self = setmetatable({}, BoladoHub)
    
    -- Configurações com valores padrão
    self.Config = {
        Name = options.Name or "BoladoHub",
        Size = options.Size or UDim2.new(0, 550, 0, 450),
        Theme = options.Theme or "Dark",
        ShowMinimize = options.ShowMinimize ~= false,
        ShowClose = options.ShowClose ~= false,
        Draggable = options.Draggable ~= false,
        AutoPosition = options.AutoPosition ~= false,
        AnimationSpeed = options.AnimationSpeed or 0.2,
        ShowShadow = options.ShowShadow ~= false,
        BlurBackground = options.BlurBackground or false,
        DefaultIcon = options.DefaultIcon or "bolt"
    }
    
    -- Estado
    self.Elements = {}
    self.Tabs = {}
    self.Components = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Visible = true
    
    -- Inicializar
    self:Initialize()
    
    return self
end

function BoladoHub:Initialize()
    -- Criar interface principal
    self:CreateScreenGui()
    self:CreateMainFrame()
    self:CreateTitleBar()
    self:CreateTabSystem()
    
    -- Aplicar efeitos iniciais
    self:ApplyEffects()
    
    -- Configurar controles
    self:SetupControls()
    
    -- Log de inicialização
    self:Log("Interface inicializada com sucesso!")
end

function BoladoHub:CreateScreenGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BoladoHub_" .. self.Config.Name
    self.ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Blur background (opcional)
    if self.Config.BlurBackground then
        local blur = Instance.new("BlurEffect")
        blur.Name = "HubBlur"
        blur.Size = 8
        blur.Parent = game:GetService("Lighting")
    end
end

function BoladoHub:CreateMainFrame()
    local theme = self:GetTheme()
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.BackgroundColor3 = theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Posicionamento
    if self.Config.AutoPosition then
        self.MainFrame.Position = UDim2.new(0.5, -self.Config.Size.X.Offset/2, 0.5, -self.Config.Size.Y.Offset/2)
    else
        self.MainFrame.Position = UDim2.new(0.03, 0, 0.03, 0)
    end
    
    -- Corner sofisticado
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = self.MainFrame
    
    -- Borda gradiente
    local border = Instance.new("UIStroke")
    border.Name = "Border"
    border.Color = theme.Border
    border.Thickness = 1.5
    border.Transparency = 0.7
    border.Parent = self.MainFrame
    
    -- Sombra (se habilitado)
    if self.Config.ShowShadow then
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.Image = "rbxassetid://5554236805"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = 0.85
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.BackgroundTransparency = 1
        shadow.Parent = self.MainFrame
        shadow.ZIndex = -1
    end
end

function BoladoHub:CreateTitleBar()
    local theme = self:GetTheme()
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 42)
    self.TitleBar.BackgroundColor3 = theme.Accent
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Corner apenas no topo
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 14, 0, 0)
    titleCorner.Parent = self.TitleBar
    
    -- Gradiente na barra de título
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.Accent),
        ColorSequenceKeypoint.new(1, theme.AccentLight)
    })
    gradient.Rotation = 45
    gradient.Parent = self.TitleBar
    
    -- Ícone do título
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 26, 0, 26)
    titleIcon.Position = UDim2.new(0, 12, 0.5, -13)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = GetIcon(self.Config.DefaultIcon)
    titleIcon.ImageColor3 = theme.Text
    titleIcon.ImageTransparency = 0
    titleIcon.Parent = self.TitleBar
    
    -- Título
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -130, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 46, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = "  " .. self.Config.Name
    self.TitleLabel.TextColor3 = theme.Text
    self.TitleLabel.Font = Enum.Font.GothamSemibold
    self.TitleLabel.TextSize = 17
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.TextTransparency = 0
    self.TitleLabel.Parent = self.TitleBar
    
    -- Versão
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "VersionLabel"
    versionLabel.Size = UDim2.new(0, 80, 0, 20)
    versionLabel.Position = UDim2.new(0, 46, 1, -22)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v3.0"
    versionLabel.TextColor3 = theme.TextSecondary
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 11
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.TextTransparency = 0.5
    versionLabel.Parent = self.TitleBar
    
    -- Botões da barra
    self:CreateTitleButtons()
    
    -- Sistema de arrasto
    if self.Config.Draggable then
        self:MakeDraggable()
    end
end

function BoladoHub:CreateTitleButtons()
    local theme = self:GetTheme()
    local buttonSize = UDim2.new(0, 32, 0, 32)
    
    -- Container de botões
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "TitleButtons"
    buttonsContainer.Size = UDim2.new(0, 110, 1, 0)
    buttonsContainer.Position = UDim2.new(1, -115, 0, 0)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = self.TitleBar
    
    -- Botão minimizar
    if self.Config.ShowMinimize then
        self.MinimizeBtn = self:CreateIconButton({
            Name = "MinimizeBtn",
            Icon = "chevron-down",
            Size = buttonSize,
            Position = UDim2.new(0, 5, 0.5, -16),
            Parent = buttonsContainer,
            Color = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9
        })
        
        self.MinimizeBtn.MouseButton1Click:Connect(function()
            self:ToggleMinimize()
        end)
    end
    
    -- Botão fechar
    if self.Config.ShowClose then
        self.CloseBtn = self:CreateIconButton({
            Name = "CloseBtn",
            Icon = "xcircle",
            Size = buttonSize,
            Position = UDim2.new(1, -37, 0.5, -16),
            Parent = buttonsContainer,
            Color = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(231, 76, 60),
            BackgroundTransparency = 0
        })
        
        self.CloseBtn.MouseButton1Click:Connect(function()
            self:Destroy()
        end)
    end
end

function BoladoHub:CreateTabSystem()
    local theme = self:GetTheme()
    
    -- Frame das abas (sidebar)
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0, 170, 1, -42)
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 42)
    self.TabsFrame.BackgroundColor3 = theme.Secondary
    self.TabsFrame.BorderSizePixel = 0
    self.TabsFrame.Parent = self.MainFrame
    
    -- Corner no sidebar
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 0, 0, 14)
    sidebarCorner.Parent = self.TabsFrame
    
    -- Frame de conteúdo
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -170, 1, -42)
    self.ContentFrame.Position = UDim2.new(0, 170, 0, 42)
    self.ContentFrame.BackgroundColor3 = theme.Background
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ClipsDescendants = true
    self.ContentFrame.Parent = self.MainFrame
    
    -- Scroll para as abas
    local tabsScroll = Instance.new("ScrollingFrame")
    tabsScroll.Name = "TabsScroll"
    tabsScroll.Size = UDim2.new(1, 0, 1, -10)
    tabsScroll.Position = UDim2.new(0, 0, 0, 10)
    tabsScroll.BackgroundTransparency = 1
    tabsScroll.BorderSizePixel = 0
    tabsScroll.ScrollBarThickness = 3
    tabsScroll.ScrollBarImageColor3 = theme.Accent
    tabsScroll.ScrollBarImageTransparency = 0.7
    tabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabsScroll.Parent = self.TabsFrame
    
    local tabsList = Instance.new("UIListLayout")
    tabsList.Padding = UDim.new(0, 8)
    tabsList.Parent = tabsScroll
    
    local tabsPadding = Instance.new("UIPadding")
    tabsPadding.PaddingTop = UDim.new(0, 5)
    tabsPadding.PaddingLeft = UDim.new(0, 12)
    tabsPadding.PaddingRight = UDim.new(0, 12)
    tabsPadding.Parent = tabsScroll
    
    self.TabsScroll = tabsScroll
    
    -- Divisor
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(0, 1, 1, -84)
    divider.Position = UDim2.new(1, 0, 0, 42)
    divider.BackgroundColor3 = theme.Border
    divider.BackgroundTransparency = 0.8
    divider.BorderSizePixel = 0
    divider.Parent = self.MainFrame
end

function BoladoHub:AddTab(name, icon)
    local theme = self:GetTheme()
    
    -- Botão da aba
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 48)
    tabButton.BackgroundColor3 = theme.Button
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabsScroll
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tabButton
    
    -- Efeito de brilho
    local glow = Instance.new("UIStroke")
    glow.Name = "Glow"
    glow.Color = theme.Accent
    glow.Thickness = 0
    glow.Transparency = 1
    glow.Parent = tabButton
    
    -- Ícone
    local iconImage
    if icon then
        iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.Size = UDim2.new(0, 24, 0, 24)
        iconImage.Position = UDim2.new(0, 15, 0.5, -12)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = GetIcon(icon)
        iconImage.ImageColor3 = theme.TextSecondary
        iconImage.ImageTransparency = 0.2
        iconImage.Parent = tabButton
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, icon and -50 or -30, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 50 or 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = theme.TextSecondary
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextTransparency = 0.2
    textLabel.Parent = tabButton
    
    -- Frame de conteúdo
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 5
    contentFrame.ScrollBarImageColor3 = theme.Accent
    contentFrame.ScrollBarImageTransparency = 0.7
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentFrame
    
    -- List layout
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 14)
    listLayout.Parent = contentFrame
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Padding
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 18)
    padding.PaddingLeft = UDim.new(0, 18)
    padding.PaddingRight = UDim.new(0, 18)
    padding.PaddingBottom = UDim.new(0, 18)
    padding.Parent = contentFrame
    
    -- Efeitos hover
    self:AddButtonHoverEffect(tabButton, theme.Button, theme.Accent)
    
    -- Selecionar aba
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
        self:PlayClickSound()
    end)
    
    -- Armazenar
    self.Tabs[name] = {
        Button = tabButton,
        Content = contentFrame,
        Icon = icon,
        IconImage = iconImage,
        TextLabel = textLabel,
        Glow = glow
    }
    
    -- Selecionar primeira aba
    if not self.ActiveTab then
        self:SelectTab(name)
    end
    
    return contentFrame
end

function BoladoHub:SelectTab(name)
    if self.ActiveTab == name then return end
    
    local theme = self:GetTheme()
    local animationTime = self.Config.AnimationSpeed
    
    -- Deselecionar aba atual
    if self.ActiveTab then
        local oldTab = self.Tabs[self.ActiveTab]
        if oldTab then
            -- Animação de saída
            oldTab.Content.Visible = false
            
            -- Resetar botão
            TweenService:Create(oldTab.Button, TweenInfo.new(animationTime), {
                BackgroundColor3 = theme.Button
            }):Play()
            
            -- Resetar ícone
            if oldTab.IconImage then
                TweenService:Create(oldTab.IconImage, TweenInfo.new(animationTime), {
                    ImageColor3 = theme.TextSecondary,
                    ImageTransparency = 0.2
                }):Play()
            end
            
            -- Resetar texto
            TweenService:Create(oldTab.TextLabel, TweenInfo.new(animationTime), {
                TextColor3 = theme.TextSecondary,
                TextTransparency = 0.2
            }):Play()
            
            -- Resetar glow
            TweenService:Create(oldTab.Glow, TweenInfo.new(animationTime), {
                Thickness = 0,
                Transparency = 1
            }):Play()
        end
    end
    
    -- Selecionar nova aba
    local newTab = self.Tabs[name]
    if newTab then
        -- Animação de entrada
        newTab.Content.Visible = true
        newTab.Content.CanvasPosition = Vector2.new(0, 0)
        
        -- Destacar botão
        TweenService:Create(newTab.Button, TweenInfo.new(animationTime), {
            BackgroundColor3 = theme.Accent
        }):Play()
        
        -- Destacar ícone
        if newTab.IconImage then
            TweenService:Create(newTab.IconImage, TweenInfo.new(animationTime), {
                ImageColor3 = theme.Text,
                ImageTransparency = 0
            }):Play()
        end
        
        -- Destacar texto
        TweenService:Create(newTab.TextLabel, TweenInfo.new(animationTime), {
            TextColor3 = theme.Text,
            TextTransparency = 0
        }):Play()
        
        -- Ativar glow
        TweenService:Create(newTab.Glow, TweenInfo.new(animationTime), {
            Thickness = 1.5,
            Transparency = 0.5
        }):Play()
        
        self.ActiveTab = name
    end
end

-- ==================== COMPONENTES MELHORADOS ====================

function BoladoHub:Button(options)
    local parent = options.Parent or (self.ActiveTab and self.Tabs[self.ActiveTab].Content)
    if not parent then error("No active tab or parent specified") end
    
    local text = options.Text or "Button"
    local icon = options.Icon
    local callback = options.Callback or function() end
    local color = options.Color or self:GetColor("Button")
    local hoverColor = options.HoverColor or self:GetColor("Accent")
    local tooltip = options.Tooltip
    
    -- Container
    local buttonContainer = Instance.new("TextButton")
    buttonContainer.Name = "Btn_" .. text:gsub("%s+", "_")
    buttonContainer.Size = UDim2.new(1, 0, 0, 52)
    buttonContainer.BackgroundColor3 = color
    buttonContainer.AutoButtonColor = false
    buttonContainer.Text = ""
    buttonContainer.Parent = parent
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = buttonContainer
    
    -- Borda
    local border = Instance.new("UIStroke")
    border.Color = self:GetColor("Border")
    border.Thickness = 1
    border.Transparency = 0.8
    border.Parent = buttonContainer
    
    -- Gradiente
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.floor(color.R * 255 * 0.9),
            math.floor(color.G * 255 * 0.9),
            math.floor(color.B * 255 * 0.9)
        ))
    })
    gradient.Rotation = 90
    gradient.Parent = buttonContainer
    
    -- Ícone
    local iconLabel
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 28, 0, 28)
        iconLabel.Position = UDim2.new(0, 18, 0.5, -14)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = GetIcon(icon)
        iconLabel.ImageColor3 = self:GetColor("Text")
        iconLabel.Parent = buttonContainer
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, icon and -65 or -35, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 60 or 18, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = self:GetColor("Text")
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 15
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = buttonContainer
    
    -- Tooltip (se fornecido)
    if tooltip then
        self:AddTooltip(buttonContainer, tooltip)
    end
    
    -- Efeitos
    self:AddButtonHoverEffect(buttonContainer, color, hoverColor)
    
    -- Clique
    buttonContainer.MouseButton1Click:Connect(function()
        -- Animação de clique
        TweenService:Create(buttonContainer, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -5, 0, 48)
        }):Play()
        
        TweenService:Create(border, TweenInfo.new(0.1), {
            Thickness = 1.5
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(buttonContainer, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 52)
        }):Play()
        
        TweenService:Create(border, TweenInfo.new(0.1), {
            Thickness = 1
        }):Play()
        
        -- Executar callback
        local success, err = pcall(callback)
        if not success then
            self:Log("Erro no botão " .. text .. ": " .. err, true)
        end
        
        self:PlayClickSound()
    end)
    
    -- Referência para fácil acesso
    local buttonRef = {
        Instance = buttonContainer,
        SetText = function(newText)
            textLabel.Text = newText
        end,
        SetEnabled = function(enabled)
            buttonContainer.Active = enabled
            buttonContainer.BackgroundTransparency = enabled and 0 or 0.5
        end,
        Destroy = function()
            buttonContainer:Destroy()
        end
    }
    
    table.insert(self.Components, buttonRef)
    return buttonRef
end

function BoladoHub:Toggle(options)
    local parent = options.Parent or (self.ActiveTab and self.Tabs[self.ActiveTab].Content)
    if not parent then error("No active tab or parent specified") end
    
    local text = options.Text or "Toggle"
    local icon = options.Icon
    local default = options.Default or false
    local callback = options.Callback or function() end
    local tooltip = options.Tooltip
    
    -- Container
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "Tgl_" .. text:gsub("%s+", "_")
    toggleContainer.Size = UDim2.new(1, 0, 0, 52)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = parent
    
    -- Ícone
    local iconLabel
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 26, 0, 26)
        iconLabel.Position = UDim2.new(0, 0, 0.5, -13)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = GetIcon(icon)
        iconLabel.ImageColor3 = self:GetColor("Text")
        iconLabel.Parent = toggleContainer
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0.7, icon and -40 or 0, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 40 or 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = self:GetColor("Text")
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggleContainer
    
    -- Botão toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 64, 0, 32)
    toggleBtn.Position = UDim2.new(1, -64, 0.5, -16)
    toggleBtn.BackgroundColor3 = default and self:GetColor("ToggleOn") or self:GetColor("ToggleOff")
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = toggleBtn
    
    -- Borda
    local border = Instance.new("UIStroke")
    border.Color = self:GetColor("Border")
    border.Thickness = 1
    border.Transparency = 0.8
    border.Parent = toggleBtn
    
    -- Indicador
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 26, 0, 26)
    indicator.Position = default and UDim2.new(1, -27, 0.5, -13) or UDim2.new(0, 1, 0.5, -13)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.Parent = toggleBtn
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    -- Sombra do indicador
    local indicatorShadow = Instance.new("ImageLabel")
    indicatorShadow.Name = "Shadow"
    indicatorShadow.Size = UDim2.new(1, 4, 1, 4)
    indicatorShadow.Position = UDim2.new(0, -2, 0, -2)
    indicatorShadow.Image = "rbxassetid://5554236805"
    indicatorShadow.ImageColor3 = Color3.new(0, 0, 0)
    indicatorShadow.ImageTransparency = 0.8
    indicatorShadow.ScaleType = Enum.ScaleType.Slice
    indicatorShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    indicatorShadow.BackgroundTransparency = 1
    indicatorShadow.Parent = indicator
    indicatorShadow.ZIndex = -1
    
    -- Tooltip
    if tooltip then
        self:AddTooltip(toggleContainer, tooltip)
    end
    
    -- Estado
    local state = default
    
    -- Função para alternar com animação
    local function toggleState()
        state = not state
        
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = self:GetColor("ToggleOn")
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -27, 0.5, -13)
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = self:GetColor("ToggleOff")
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 1, 0.5, -13)
            }):Play()
        end
        
        -- Efeito de clique
        TweenService:Create(indicator, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(indicator, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 26, 0, 26)
        }):Play()
        
        -- Executar callback
        local success, err = pcall(callback, state)
        if not success then
            self:Log("Erro no toggle " .. text .. ": " .. err, true)
        end
        
        self:PlayClickSound()
    end
    
    -- Efeitos hover
    self:AddButtonHoverEffect(toggleBtn)
    
    -- Clique
    toggleBtn.MouseButton1Click:Connect(toggleState)
    
    -- Referência
    local toggleRef = {
        Instance = toggleContainer,
        State = function() return state end,
        Set = function(newState)
            if state ~= newState then
                toggleState()
            end
        end,
        Destroy = function()
            toggleContainer:Destroy()
        end
    }
    
    table.insert(self.Components, toggleRef)
    return toggleRef
end

function BoladoHub:Slider(options)
    local parent = options.Parent or (self.ActiveTab and self.Tabs[self.ActiveTab].Content)
    if not parent then error("No active tab or parent specified") end
    
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or math.floor((min + max) / 2)
    local callback = options.Callback or function() end
    local decimal = options.Decimal or 0
    local suffix = options.Suffix or ""
    local tooltip = options.Tooltip
    
    -- Container
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = "Sld_" .. text:gsub("%s+", "_")
    sliderContainer.Size = UDim2.new(1, 0, 0, 75)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent
    
    -- Cabeçalho
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 25)
    header.BackgroundTransparency = 1
    header.Parent = sliderContainer
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0.7, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = self:GetColor("Text")
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = header
    
    -- Valor
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = string.format("%." .. decimal .. "f", default) .. suffix
    valueLabel.TextColor3 = self:GetColor("TextSecondary")
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = header
    
    -- Barra do slider
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, 0, 0, 8)
    sliderTrack.Position = UDim2.new(0, 0, 0, 40)
    sliderTrack.BackgroundColor3 = self:GetColor("SliderTrack")
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderContainer
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack
    
    -- Fill
    local fillSize = (default - min) / (max - min)
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
    sliderFill.BackgroundColor3 = self:GetColor("SliderFill")
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    -- Gradiente no fill
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self:GetColor("SliderFill")),
        ColorSequenceKeypoint.new(1, self:GetColor("AccentLight"))
    })
    fillGradient.Rotation = 90
    fillGradient.Parent = sliderFill
    
    -- Handle
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 22, 0, 22)
    sliderHandle.Position = UDim2.new(fillSize, -11, 0.5, -11)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.AutoButtonColor = false
    sliderHandle.Text = ""
    sliderHandle.ZIndex = 2
    sliderHandle.Parent = sliderTrack
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = sliderHandle
    
    -- Sombra no handle
    local handleShadow = Instance.new("ImageLabel")
    handleShadow.Name = "Shadow"
    handleShadow.Size = UDim2.new(1, 6, 1, 6)
    handleShadow.Position = UDim2.new(0, -3, 0, -3)
    handleShadow.Image = "rbxassetid://5554236805"
    handleShadow.ImageColor3 = Color3.new(0, 0, 0)
    handleShadow.ImageTransparency = 0.7
    handleShadow.ScaleType = Enum.ScaleType.Slice
    handleShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    handleShadow.BackgroundTransparency = 1
    handleShadow.Parent = sliderHandle
    handleShadow.ZIndex = 1
    
    -- Tooltip
    if tooltip then
        self:AddTooltip(sliderContainer, tooltip)
    end
    
    -- Estado
    local dragging = false
    local value = default
    
    -- Atualizar valor
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local normalized = (value - min) / (max - min)
        
        -- Animar
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {
            Size = UDim2.new(normalized, 0, 1, 0)
        }):Play()
        
        TweenService:Create(sliderHandle, TweenInfo.new(0.1), {
            Position = UDim2.new(normalized, -11, 0.5, -11)
        }):Play()
        
        -- Atualizar texto
        valueLabel.Text = string.format("%." .. decimal .. "f", value) .. suffix
        
        -- Executar callback
        local success, err = pcall(callback, value)
        if not success then
            self:Log("Erro no slider " .. text .. ": " .. err, true)
        end
    end
    
    -- Eventos do slider
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            
            -- Feedback visual
            TweenService:Create(sliderHandle, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 26, 0, 26)
            }):Play()
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            
            TweenService:Create(sliderHandle, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 22, 0, 22)
            }):Play()
        end
    end
    
    local function updateFromInput(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = input.Position
            local trackAbsPos = sliderTrack.AbsolutePosition
            local trackAbsSize = sliderTrack.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - trackAbsPos.X) / trackAbsSize.X, 0, 1)
            local newValue = min + (relativeX * (max - min))
            
            updateValue(newValue)
        end
    end
    
    sliderHandle.InputBegan:Connect(onInputBegan)
    sliderHandle.InputEnded:Connect(onInputEnded)
    sliderTrack.InputBegan:Connect(onInputBegan)
    sliderTrack.InputEnded:Connect(onInputEnded)
    
    UserInputService.InputChanged:Connect(updateFromInput)
    
    -- Referência
    local sliderRef = {
        Instance = sliderContainer,
        Value = function() return value end,
        Set = function(newValue) updateValue(newValue) end,
        Destroy = function()
            sliderContainer:Destroy()
        end
    }
    
    table.insert(self.Components, sliderRef)
    return sliderRef
end

function BoladoHub:Label(options)
    local parent = options.Parent or (self.ActiveTab and self.Tabs[self.ActiveTab].Content)
    if not parent then error("No active tab or parent specified") end
    
    local text = options.Text or "Label"
    local color = options.Color or self:GetColor("Text")
    local size = options.Size or 14
    local align = options.Align or Enum.TextXAlignment.Left
    local font = options.Font or Enum.Font.Gotham
    local bold = options.Bold or false
    local transparency = options.Transparency or 0
    
    local label = Instance.new("TextLabel")
    label.Name = "Lbl_" .. text:gsub("%s+", "_"):sub(1, 20)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = bold and Enum.Font.GothamBold or font
    label.TextSize = size
    label.TextXAlignment = align
    label.TextTransparency = transparency
    label.TextWrapped = options.Wrapped or false
    label.TextYAlignment = options.YAlign or Enum.TextYAlignment.Center
    label.Parent = parent
    
    return label
end

function BoladoHub:Separator(options)
    local parent = options.Parent or (self.ActiveTab and self.Tabs[self.ActiveTab].Content)
    if not parent then error("No active tab or parent specified") end
    
    local height = options.Height or 1
    local color = options.Color or self:GetColor("Border")
    local transparency = options.Transparency or 0.8
    local margin = options.Margin or 10
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, -margin * 2, 0, height)
    separator.Position = UDim2.new(0, margin, 0, 0)
    separator.BackgroundColor3 = color
    separator.BackgroundTransparency = transparency
    separator.BorderSizePixel = 0
    separator.Parent = parent
    
    return separator
end

-- ==================== FUNÇÕES AUXILIARES ====================

function BoladoHub:CreateIconButton(options)
    local button = Instance.new("ImageButton")
    button.Name = options.Name
    button.Size = options.Size or UDim2.new(0, 30, 0, 30)
    button.Position = options.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = options.BackgroundColor3 or Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = options.BackgroundTransparency or 0.9
    button.Image = GetIcon(options.Icon or "helpcircle")
    button.ImageColor3 = options.Color or Color3.fromRGB(255, 255, 255)
    button.Parent = options.Parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Efeitos
    self:AddButtonHoverEffect(button)
    
    return button
end

function BoladoHub:AddButtonHoverEffect(button, defaultColor, hoverColor)
    local theme = self:GetTheme()
    local originalColor = defaultColor or button.BackgroundColor3
    local originalTransparency = button.BackgroundTransparency
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor or theme.Accent,
            BackgroundTransparency = math.max(originalTransparency - 0.2, 0)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        }):Play()
    end)
end

function BoladoHub:AddTooltip(element, text)
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 40)
    tooltip.Position = UDim2.new(0.5, -100, 1, 5)
    tooltip.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tooltip.BackgroundTransparency = 0.2
    tooltip.Text = text
    tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
    tooltip.Font = Enum.Font.Gotham
    tooltip.TextSize = 12
    tooltip.TextWrapped = true
    tooltip.Visible = false
    tooltip.ZIndex = 100
    tooltip.Parent = element
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tooltip
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.Parent = tooltip
    
    element.MouseEnter:Connect(function()
        tooltip.Visible = true
    end)
    
    element.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
end

function BoladoHub:MakeDraggable()
    local dragging = false
    local dragStart, startPos
    
    local function update(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            TweenService:Create(self.TitleBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.2
            }):Play()
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            
            TweenService:Create(self.TitleBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
        end
    end
    
    self.TitleBar.InputBegan:Connect(startDrag)
    self.TitleBar.InputChanged:Connect(update)
    self.TitleBar.InputEnded:Connect(endDrag)
    self.TitleLabel.InputBegan:Connect(startDrag)
    self.TitleLabel.InputChanged:Connect(update)
    self.TitleLabel.InputEnded:Connect(endDrag)
end

function BoladoHub:ApplyEffects()
    -- Efeito de entrada
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundTransparency = 1
    
    TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = self.Config.Size,
        Position = self.Config.AutoPosition and 
            UDim2.new(0.5, -self.Config.Size.X.Offset/2, 0.5, -self.Config.Size.Y.Offset/2) or
            UDim2.new(0.03, 0, 0.03, 0),
        BackgroundTransparency = 0
    }):Play()
end

function BoladoHub:ToggleMinimize()
    if self.Minimized then
        -- Restaurar
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = self.Config.Size
        }):Play()
        self.Minimized = false
        self.MinimizeBtn.Image = GetIcon("chevron-down")
    else
        -- Minimizar
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 300, 0, 40)
        }):Play()
        self.Minimized = true
        self.MinimizeBtn.Image = GetIcon("chevron-up")
    end
end

function BoladoHub:ToggleVisibility()
    self.Visible = not self.Visible
    self.ScreenGui.Enabled = self.Visible
end

function BoladoHub:SetTheme(themeName)
    if Themes[themeName] then
        self.Config.Theme = themeName
        self:UpdateTheme()
    else
        self:Log("Tema '" .. themeName .. "' não encontrado", true)
    end
end

function BoladoHub:UpdateTheme()
    local theme = self:GetTheme()
    
    -- Atualizar cores principais
    self.MainFrame.BackgroundColor3 = theme.Background
    self.TitleBar.BackgroundColor3 = theme.Accent
    self.TabsFrame.BackgroundColor3 = theme.Secondary
    self.ContentFrame.BackgroundColor3 = theme.Background
    self.TitleLabel.TextColor3 = theme.Text
    
    -- Atualizar gradiente do título
    local gradient = self.TitleBar:FindFirstChildOfClass("UIGradient")
    if gradient then
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Accent),
            ColorSequenceKeypoint.new(1, theme.AccentLight)
        })
    end
    
    -- Atualizar borda
    local border = self.MainFrame:FindFirstChild("Border")
    if border then
        border.Color = theme.Border
    end
    
    self:Log("Tema alterado para: " .. self.Config.Theme)
end

function BoladoHub:GetTheme()
    return Themes[self.Config.Theme] or Themes.Dark
end

function BoladoHub:GetColor(colorName)
    return self:GetTheme()[colorName] or Color3.fromRGB(255, 255, 255)
end

function BoladoHub:SetupControls()
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.Insert then
                self:ToggleVisibility()
                self:Log("Interface " .. (self.Visible and "visível" or "oculta"))
            elseif input.KeyCode == Enum.KeyCode.Delete then
                self:Destroy()
            elseif input.KeyCode == Enum.KeyCode.RightShift then
                self:ToggleMinimize()
            elseif input.KeyCode == Enum.KeyCode.F5 then
                self:SetTheme("Dark")
            elseif input.KeyCode == Enum.KeyCode.F6 then
                self:SetTheme("Light")
            elseif input.KeyCode == Enum.KeyCode.F7 then
                self:SetTheme("Ocean")
            end
        end
    end)
end

function BoladoHub:PlayClickSound()
    -- Simular som de clique (opcional)
    if self.Config.PlaySounds then
        -- Implementar som se desejado
    end
end

function BoladoHub:Log(message, isError)
    local prefix = isError and "❌ [ERRO] " or "📝 [LOG] "
    print(prefix .. "BoladoHub: " .. message)
    
    -- Adicionar à aba de logs se existir
    if self.Tabs["Logs"] then
        local logTab = self.Tabs["Logs"].Content
        local timestamp = os.date("%H:%M:%S")
        local logEntry = self:Label({
            Parent = logTab,
            Text = "[" .. timestamp .. "] " .. message,
            Color = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(200, 200, 200),
            Size = 12
        })
    end
end

function BoladoHub:Destroy()
    -- Animar saída
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.3)
    
    -- Destruir tudo
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- Limpar blur se existir
    local lighting = game:GetService("Lighting")
    local blur = lighting:FindFirstChild("HubBlur")
    if blur then
        blur:Destroy()
    end
    
    self:Log("Interface destruída")
end

-- Métodos adicionais
function BoladoHub:GetConfig()
    return self.Config
end

function BoladoHub:GetVersion()
    return "3.0"
end

function BoladoHub:GetTabNames()
    local names = {}
    for name, _ in pairs(self.Tabs) do
        table.insert(names, name)
    end
    return names
end

function BoladoHub:ClearTab(tabName)
    local tab = self.Tabs[tabName]
    if tab then
        for _, child in ipairs(tab.Content:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
    end
end

return BoladoHub