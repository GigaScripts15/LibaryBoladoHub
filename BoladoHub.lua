-- BoladoHub Library v2.0 - Compact Version
-- Biblioteca completa com suporte a ícones

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Importar módulos (em produção, use require)
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/GigaScripts15/LibaryBoladoHub/refs/heads/main/incon.lua"))() or {
    Get = function(name) return "rbxassetid://10709721749" end
}

-- Configurações padrão
BoladoHub.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 40),
        Secondary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(255, 0, 247),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Button = Color3.fromRGB(40, 40, 50),
        ToggleOn = Color3.fromRGB(0, 200, 100),
        ToggleOff = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Secondary = Color3.fromRGB(225, 225, 230),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(30, 30, 30),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Button = Color3.fromRGB(220, 220, 225),
        ToggleOn = Color3.fromRGB(0, 180, 80),
        ToggleOff = Color3.fromRGB(180, 180, 190)
    },
    Ocean = {
        Background = Color3.fromRGB(20, 30, 50),
        Secondary = Color3.fromRGB(15, 25, 45),
        Accent = Color3.fromRGB(0, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 200, 220),
        Button = Color3.fromRGB(30, 40, 60),
        ToggleOn = Color3.fromRGB(0, 180, 220),
        ToggleOff = Color3.fromRGB(40, 50, 70)
    }
}

-- Classe principal
BoladoHub.__index = BoladoHub

function BoladoHub.new(options)
    local self = setmetatable({}, BoladoHub)

    -- Configurações com tamanhos reduzidos
    self.Config = {
        Name = options.Name or "BoladoHub",
        Size = options.Size or UDim2.new(0, 450, 0, 400), -- Tamanho reduzido
        Theme = options.Theme or "Dark",
        ShowMinimize = options.ShowMinimize ~= false,
        ShowClose = options.ShowClose ~= false,
        Draggable = options.Draggable ~= false,
        AutoPosition = options.AutoPosition ~= false,
        CompactMode = options.CompactMode or true -- Novo: modo compacto
    }

    self.Elements = {}
    self.Tabs = {}
    self.Components = {}
    self.ActiveTab = nil
    self.CompactMode = self.Config.CompactMode

    -- Criar interface
    self:CreateUI()

    -- Atalhos de teclado
    self:SetupHotkeys()

    return self
end

function BoladoHub:CreateUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Config.Name
    self.ScreenGui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Frame principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    
    -- Ajustar tamanho baseado no modo
    if self.CompactMode then
        self.MainFrame.Size = UDim2.new(0, 380, 0, 350) -- Tamanho compacto
    else
        self.MainFrame.Size = self.Config.Size
    end

    if self.Config.AutoPosition then
        self.MainFrame.Position = UDim2.new(0.5, -self.MainFrame.Size.X.Offset/2, 0.5, -self.MainFrame.Size.Y.Offset/2)
    else
        self.MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0) -- Posição mais para o canto
    end

    self.MainFrame.BackgroundColor3 = self:GetColor("Background")
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui

    -- Corner menor para ficar mais compacto
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8) -- Reduzido de 12 para 8
    corner.Parent = self.MainFrame

    -- Shadow mais sutil
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6) -- Reduzido
    shadow.Position = UDim2.new(0, -3, 0, -3) -- Reduzido
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.BackgroundTransparency = 1
    shadow.Parent = self.MainFrame
    shadow.ZIndex = -1

    -- Barra de título
    self:CreateTitleBar()

    -- Sistema de abas
    self:CreateTabSystem()

    -- Adicionar efeitos
    self:AddEffects()
end

function BoladoHub:CreateTitleBar()
    local theme = self:GetTheme()

    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 32) -- Reduzido de 40 para 32
    self.TitleBar.BackgroundColor3 = theme.Accent
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame

    -- Corner apenas no topo
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8, 0, 0) -- Reduzido
    titleCorner.Parent = self.TitleBar

    -- Ícone do título menor
    local titleIcon = Instance.new("ImageLabel")
    titleIcon.Name = "TitleIcon"
    titleIcon.Size = UDim2.new(0, 20, 0, 20) -- Reduzido
    titleIcon.Position = UDim2.new(0, 8, 0.5, -10) -- Ajustado
    titleIcon.BackgroundTransparency = 1
    titleIcon.Image = Icons:Get("bolt")
    titleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    titleIcon.Parent = self.TitleBar

    -- Título com fonte menor
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0) -- Ajustado
    self.TitleLabel.Position = UDim2.new(0, 32, 0, 0) -- Ajustado
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = "  " .. self.Config.Name
    self.TitleLabel.TextColor3 = theme.Text
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 14 -- Reduzido de 16 para 14
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar

    -- Botões da barra
    self:CreateTitleButtons()

    -- Sistema de arrasto
    if self.Config.Draggable then
        self:MakeDraggable(self.MainFrame, self.TitleBar)
    end
end

function BoladoHub:CreateTitleButtons()
    local buttonSize = UDim2.new(0, 26, 0, 26) -- Reduzido
    local buttonSpacing = 4 -- Reduzido

    -- Botão minimizar
    if self.Config.ShowMinimize then
        self.MinimizeBtn = Instance.new("ImageButton")
        self.MinimizeBtn.Name = "MinimizeBtn"
        self.MinimizeBtn.Size = buttonSize
        self.MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -13) -- Ajustado
        self.MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        self.MinimizeBtn.BackgroundTransparency = 0.9
        self.MinimizeBtn.Image = Icons:Get("chevron-down")
        self.MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        self.MinimizeBtn.Parent = self.TitleBar

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5) -- Reduzido
        corner.Parent = self.MinimizeBtn

        -- Efeitos
        self:AddHoverEffect(self.MinimizeBtn, 0.9, 0.8)

        -- Ação
        self.MinimizeBtn.MouseButton1Click:Connect(function()
            self:ToggleMinimize()
        end)
    end

    -- Botão fechar
    if self.Config.ShowClose then
        self.CloseBtn = Instance.new("ImageButton")
        self.CloseBtn.Name = "CloseBtn"
        self.CloseBtn.Size = buttonSize
        self.CloseBtn.Position = UDim2.new(1, -30, 0.5, -13) -- Ajustado
        self.CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        self.CloseBtn.Image = Icons:Get("xcircle")
        self.CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
        self.CloseBtn.Parent = self.TitleBar

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5) -- Reduzido
        corner.Parent = self.CloseBtn

        -- Efeitos
        self:AddHoverEffect(self.CloseBtn, 0, 0.2)

        -- Ação
        self.CloseBtn.MouseButton1Click:Connect(function()
            self:Destroy()
        end)
    end
end

function BoladoHub:CreateTabSystem()
    local theme = self:GetTheme()

    -- Frame das abas mais estreito
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0, 130, 1, -32) -- Reduzido largura e altura
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 32) -- Ajustado
    self.TabsFrame.BackgroundColor3 = theme.Secondary
    self.TabsFrame.BorderSizePixel = 0
    self.TabsFrame.Parent = self.MainFrame

    -- Frame de conteúdo maior
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -130, 1, -32) -- Ajustado
    self.ContentFrame.Position = UDim2.new(0, 130, 0, 32) -- Ajustado
    self.ContentFrame.BackgroundColor3 = theme.Background
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame

    -- Scroll para as abas
    local tabsScroll = Instance.new("ScrollingFrame")
    tabsScroll.Name = "TabsScroll"
    tabsScroll.Size = UDim2.new(1, 0, 1, 0)
    tabsScroll.BackgroundTransparency = 1
    tabsScroll.BorderSizePixel = 0
    tabsScroll.ScrollBarThickness = 2 -- Reduzido
    tabsScroll.ScrollBarImageColor3 = theme.Accent
    tabsScroll.Parent = self.TabsFrame

    local tabsList = Instance.new("UIListLayout")
    tabsList.Padding = UDim.new(0, 4) -- Reduzido
    tabsList.Parent = tabsScroll

    local tabsPadding = Instance.new("UIPadding")
    tabsPadding.PaddingTop = UDim.new(0, 8) -- Reduzido
    tabsPadding.PaddingLeft = UDim.new(0, 8) -- Reduzido
    tabsPadding.PaddingRight = UDim.new(0, 8) -- Reduzido
    tabsPadding.Parent = tabsScroll

    self.TabsScroll = tabsScroll
end

function BoladoHub:AddTab(name, icon)
    local theme = self:GetTheme()

    -- Botão da aba menor
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 38) -- Reduzido
    tabButton.BackgroundColor3 = theme.Button
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabsScroll

    -- Corner menor
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6) -- Reduzido
    corner.Parent = tabButton

    -- Ícone menor
    if icon then
        local iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.Size = UDim2.new(0, 20, 0, 20) -- Reduzido
        iconImage.Position = UDim2.new(0, 10, 0.5, -10) -- Ajustado
        iconImage.BackgroundTransparency = 1
        iconImage.Image = Icons:Get(icon)
        iconImage.ImageColor3 = theme.TextSecondary
        iconImage.Parent = tabButton
    end

    -- Texto menor
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, -40, 1, 0) -- Ajustado
    textLabel.Position = UDim2.new(0, 35, 0, 0) -- Ajustado
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = theme.TextSecondary
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12 -- Reduzido
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton

    -- Frame de conteúdo
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4 -- Reduzido
    contentFrame.ScrollBarImageColor3 = theme.Accent
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentFrame

    -- List layout
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8) -- Reduzido
    listLayout.Parent = contentFrame

    -- Padding menor
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12) -- Reduzido
    padding.PaddingLeft = UDim.new(0, 12) -- Reduzido
    padding.PaddingRight = UDim.new(0, 12) -- Reduzido
    padding.Parent = contentFrame

    -- Efeito hover
    self:AddHoverEffect(tabButton, 0, -0.1, theme.Button, theme.Accent)

    -- Selecionar aba
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)

    -- Armazenar
    self.Tabs[name] = {
        Button = tabButton,
        Content = contentFrame,
        Icon = icon
    }

    -- Selecionar primeira aba
    if not self.ActiveTab then
        self:SelectTab(name)
    end

    return contentFrame
end

function BoladoHub:SelectTab(name)
    local theme = self:GetTheme()

    -- Deselecionar aba atual
    if self.ActiveTab then
        local oldTab = self.Tabs[self.ActiveTab]
        if oldTab then
            oldTab.Content.Visible = false

            -- Resetar botão
            TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = theme.Button
            }):Play()

            -- Resetar ícone
            local icon = oldTab.Button:FindFirstChild("Icon")
            if icon then
                TweenService:Create(icon, TweenInfo.new(0.2), {
                    ImageColor3 = theme.TextSecondary
                }):Play()
            end

            -- Resetar texto
            local label = oldTab.Button:FindFirstChild("Label")
            if label then
                TweenService:Create(label, TweenInfo.new(0.2), {
                    TextColor3 = theme.TextSecondary
                }):Play()
            end
        end
    end

    -- Selecionar nova aba
    local newTab = self.Tabs[name]
    if newTab then
        newTab.Content.Visible = true

        -- Destacar botão
        TweenService:Create(newTab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.Accent
        }):Play()

        -- Destacar ícone
        local icon = newTab.Button:FindFirstChild("Icon")
        if icon then
            TweenService:Create(icon, TweenInfo.new(0.2), {
                ImageColor3 = theme.Text
            }):Play()
        end

        -- Destacar texto
        local label = newTab.Button:FindFirstChild("Label")
        if label then
            TweenService:Create(label, TweenInfo.new(0.2), {
                TextColor3 = theme.Text
            }):Play()
        end

        self.ActiveTab = name
    end
end

-- Componentes com tamanhos reduzidos
function BoladoHub:Button(options)
    local parent = options.Parent or self.Tabs[self.ActiveTab].Content
    local text = options.Text or "Button"
    local icon = options.Icon
    local callback = options.Callback or function() end
    local color = options.Color or self:GetColor("Button")

    -- Container menor
    local buttonContainer = Instance.new("TextButton")
    buttonContainer.Name = text .. "Button"
    buttonContainer.Size = UDim2.new(1, 0, 0, 42) -- Reduzido
    buttonContainer.BackgroundColor3 = color
    buttonContainer.AutoButtonColor = false
    buttonContainer.Text = ""
    buttonContainer.Parent = parent

    -- Corner menor
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8) -- Reduzido
    corner.Parent = buttonContainer

    -- Ícone menor
    local iconLabel
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 24, 0, 24) -- Reduzido
        iconLabel.Position = UDim2.new(0, 12, 0.5, -12) -- Ajustado
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = Icons:Get(icon)
        iconLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        iconLabel.Parent = buttonContainer
    end

    -- Texto menor
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, icon and -50 or -25, 1, 0) -- Ajustado
    textLabel.Position = UDim2.new(0, icon and 45 or 12, 0, 0) -- Ajustado
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = self:GetColor("Text")
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14 -- Reduzido
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = buttonContainer

    -- Efeito hover
    self:AddHoverEffect(buttonContainer, 0, -0.1, color, self:GetColor("Accent"))

    -- Clique
    buttonContainer.MouseButton1Click:Connect(function()
        -- Animação de clique
        TweenService:Create(buttonContainer, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -5, 0, 38) -- Ajustado
        }):Play()

        task.wait(0.1)

        TweenService:Create(buttonContainer, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 42) -- Ajustado
        }):Play()

        -- Executar callback
        callback()
    end)

    return buttonContainer
end

function BoladoHub:Toggle(options)
    local parent = options.Parent or self.Tabs[self.ActiveTab].Content
    local text = options.Text or "Toggle"
    local icon = options.Icon
    local default = options.Default or false
    local callback = options.Callback or function() end

    -- Container menor
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = text .. "Toggle"
    toggleContainer.Size = UDim2.new(1, 0, 0, 42) -- Reduzido
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = parent

    -- Ícone menor
    local iconLabel
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 20, 0, 20) -- Reduzido
        iconLabel.Position = UDim2.new(0, 0, 0.5, -10) -- Ajustado
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = Icons:Get(icon)
        iconLabel.ImageColor3 = self:GetColor("Text")
        iconLabel.Parent = toggleContainer
    end

    -- Texto menor
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0.7, icon and -30 or 0, 1, 0) -- Ajustado
    textLabel.Position = UDim2.new(0, icon and 25 or 0, 0, 0) -- Ajustado
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = self:GetColor("Text")
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13 -- Reduzido
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggleContainer

    -- Botão toggle menor
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 52, 0, 26) -- Reduzido
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -13) -- Ajustado
    toggleBtn.BackgroundColor3 = default and self:GetColor("ToggleOn") or self:GetColor("ToggleOff")
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = toggleBtn

    -- Indicador menor
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 20, 0, 20) -- Reduzido
    indicator.Position = default and UDim2.new(1, -21, 0.5, -10) or UDim2.new(0, 1, 0.5, -10) -- Ajustado
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.Parent = toggleBtn

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator

    -- Estado
    local state = default

    -- Função para alternar
    local function toggleState()
        state = not state

        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = self:GetColor("ToggleOn")
            }):Play()

            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -21, 0.5, -10)
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = self:GetColor("ToggleOff")
            }):Play()

            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 1, 0.5, -10)
            }):Play()
        end

        callback(state)
    end

    -- Clique
    toggleBtn.MouseButton1Click:Connect(toggleState)

    return {
        Frame = toggleContainer,
        State = function() return state end,
        Set = function(newState) 
            if state ~= newState then 
                toggleState() 
            end 
        end
    }
end

function BoladoHub:Slider(options)
    local parent = options.Parent or self.Tabs[self.ActiveTab].Content
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local callback = options.Callback or function() end
    local decimal = options.Decimal or 0

    -- Container menor
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = text .. "Slider"
    sliderContainer.Size = UDim2.new(1, 0, 0, 60) -- Reduzido
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent

    -- Texto menor
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, 0, 0, 20) -- Reduzido
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text .. ": " .. string.format("%." .. decimal .. "f", default)
    textLabel.TextColor3 = self:GetColor("Text")
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13 -- Reduzido
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = sliderContainer

    -- Barra do slider mais fina
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.Size = UDim2.new(1, 0, 0, 5) -- Reduzido
    sliderTrack.Position = UDim2.new(0, 0, 0, 30) -- Ajustado
    sliderTrack.BackgroundColor3 = self:GetColor("Button")
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
    sliderFill.BackgroundColor3 = self:GetColor("Accent")
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill

    -- Handle menor
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Name = "Handle"
    sliderHandle.Size = UDim2.new(0, 18, 0, 18) -- Reduzido
    sliderHandle.Position = UDim2.new(fillSize, -9, 0.5, -9) -- Ajustado
    sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderHandle.AutoButtonColor = false
    sliderHandle.Text = ""
    sliderHandle.Parent = sliderTrack

    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = sliderHandle

    -- Estado
    local dragging = false
    local value = default

    -- Atualizar valor
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local normalized = (value - min) / (max - min)

        TweenService:Create(sliderFill, TweenInfo.new(0.1), {
            Size = UDim2.new(normalized, 0, 1, 0)
        }):Play()

        TweenService:Create(sliderHandle, TweenInfo.new(0.1), {
            Position = UDim2.new(normalized, -9, 0.5, -9)
        }):Play()

        textLabel.Text = text .. ": " .. string.format("%." .. decimal .. "f", value)
        callback(value)
    end

    -- Eventos do slider
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local trackAbsPos = sliderTrack.AbsolutePosition
            local trackAbsSize = sliderTrack.AbsoluteSize

            local relativeX = (mousePos.X - trackAbsPos.X) / trackAbsSize.X
            local newValue = min + (relativeX * (max - min))

            updateValue(newValue)
            dragging = true
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position
            local trackAbsPos = sliderTrack.AbsolutePosition
            local trackAbsSize = sliderTrack.AbsoluteSize

            local relativeX = (mousePos.X - trackAbsPos.X) / trackAbsSize.X
            local newValue = min + (relativeX * (max - min))

            updateValue(newValue)
        end
    end)

    return {
        Frame = sliderContainer,
        Value = function() return value end,
        Set = function(newValue) updateValue(newValue) end
    }
end

function BoladoHub:Label(options)
    local parent = options.Parent or self.Tabs[self.ActiveTab].Content
    local text = options.Text or "Label"
    local color = options.Color or self:GetColor("Text")
    local size = options.Size or 13 -- Reduzido padrão
    local align = options.Align or Enum.TextXAlignment.Left

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 25) -- Reduzido
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.Gotham
    label.TextSize = size
    label.TextXAlignment = align
    label.TextWrapped = true
    label.Parent = parent

    return label
end

-- Funções auxiliares
function BoladoHub:MakeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos

    local function update(input)
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            TweenService:Create(handle, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.2
            }):Play()
        end
    end)

    handle.InputChanged:Connect(function(input)
        if dragging then
            update(input)
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TweenService:Create(handle, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
        end
    end)
end

function BoladoHub:AddHoverEffect(button, defaultTransparency, hoverTransparency, defaultColor, hoverColor)
    local theme = self:GetTheme()
    local originalColor = defaultColor or button.BackgroundColor3
    local originalTransparency = defaultTransparency or button.BackgroundTransparency

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor or theme.Accent,
            BackgroundTransparency = hoverTransparency or originalTransparency - 0.1
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        }):Play()
    end)
end

function BoladoHub:AddEffects()
    -- Efeito de entrada
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

    TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = self.MainFrame.Size,
        Position = UDim2.new(0.5, -self.MainFrame.Size.X.Offset/2, 0.5, -self.MainFrame.Size.Y.Offset/2)
    }):Play()
end

function BoladoHub:ToggleMinimize()
    if self.Minimized then
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
            Size = self.MainFrame.Size
        }):Play()
        self.Minimized = false
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 40, 0, 40) -- Mais compacto
        }):Play()
        self.Minimized = true
    end
end

function BoladoHub:SetTheme(themeName)
    if self.Themes[themeName] then
        self.Config.Theme = themeName
        self:UpdateTheme()
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
end

function BoladoHub:GetTheme()
    return self.Themes[self.Config.Theme] or self.Themes.Dark
end

function BoladoHub:GetColor(colorName)
    return self:GetTheme()[colorName] or Color3.fromRGB(255, 255, 255)
end

function BoladoHub:SetupHotkeys()
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed then
            if input.KeyCode == Enum.KeyCode.Insert then
                self.ScreenGui.Enabled = not self.ScreenGui.Enabled
            elseif input.KeyCode == Enum.KeyCode.Delete then
                self:Destroy()
            elseif input.KeyCode == Enum.KeyCode.RightShift then
                self:ToggleMinimize()
            end
        end
    end)
end

function BoladoHub:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Função auxiliar para criar UI compacta
function BoladoHub.CreateCompactUI(options)
    options = options or {}
    options.CompactMode = true
    options.Size = UDim2.new(0, 380, 0, 350)
    return BoladoHub.new(options)
end

return BoladoHub