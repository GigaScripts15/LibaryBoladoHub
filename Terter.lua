-- BoladoHub Library v3.0
-- Biblioteca completa com Drag, Touch e Minimizar

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==================== SISTEMA DE ÍCONES ====================
local Icons = {
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
    ["paintbrush"] = "rbxassetid://10734910187",
    ["palette"] = "rbxassetid://10734910430",
    ["image"] = "rbxassetid://10723415040",
    ["sliders"] = "rbxassetid://10734963400",
    ["bell"] = "rbxassetid://10709775704",
    ["checkcircle"] = "rbxassetid://10709790387",
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
    ["lock"] = "rbxassetid://10723434711",
    ["sword"] = "rbxassetid://10734975486",
    ["music"] = "rbxassetid://10734905958",
    ["zap"] = "rbxassetid://10709721749",
    ["cog"] = "rbxassetid://10709810948",
    ["key"] = "rbxassetid://10723416652",
    ["wifi"] = "rbxassetid://10747382504",
    ["cpu"] = "rbxassetid://10709813383",
    ["battery"] = "rbxassetid://10709774640",
    ["home"] = "rbxassetid://10723407389",
    ["flag"] = "rbxassetid://10723375890",
    ["chevron-down"] = "rbxassetid://10734904599",
    ["chevron-up"] = "rbxassetid://10734904599"
}

local function GetIcon(name)
    return Icons[name] or Icons["bolt"]
end

-- ==================== SISTEMA DE TEMAS ====================
local Themes = {
    Midnight = {
        Background = Color3.fromRGB(20, 25, 45),
        TabBackground = Color3.fromRGB(30, 35, 55),
        TabActive = Color3.fromRGB(100, 150, 255),
        Button = Color3.fromRGB(40, 45, 65),
        ButtonHover = Color3.fromRGB(120, 170, 255),
        Text = Color3.fromRGB(220, 230, 255),
        TextSecondary = Color3.fromRGB(160, 170, 200),
        Border = Color3.fromRGB(50, 60, 90)
    },
    
    Cyberpunk = {
        Background = Color3.fromRGB(25, 10, 45),
        TabBackground = Color3.fromRGB(35, 20, 55),
        TabActive = Color3.fromRGB(255, 0, 200),
        Button = Color3.fromRGB(45, 30, 65),
        ButtonHover = Color3.fromRGB(255, 50, 220),
        Text = Color3.fromRGB(255, 200, 255),
        TextSecondary = Color3.fromRGB(200, 150, 200),
        Border = Color3.fromRGB(70, 30, 90)
    },
    
    Forest = {
        Background = Color3.fromRGB(25, 45, 30),
        TabBackground = Color3.fromRGB(35, 55, 40),
        TabActive = Color3.fromRGB(0, 200, 100),
        Button = Color3.fromRGB(45, 65, 50),
        ButtonHover = Color3.fromRGB(50, 220, 120),
        Text = Color3.fromRGB(220, 255, 230),
        TextSecondary = Color3.fromRGB(170, 200, 180),
        Border = Color3.fromRGB(60, 80, 70)
    },
    
    Lava = {
        Background = Color3.fromRGB(50, 20, 15),
        TabBackground = Color3.fromRGB(60, 30, 25),
        TabActive = Color3.fromRGB(255, 100, 0),
        Button = Color3.fromRGB(70, 40, 35),
        ButtonHover = Color3.fromRGB(255, 130, 50),
        Text = Color3.fromRGB(255, 230, 220),
        TextSecondary = Color3.fromRGB(200, 170, 160),
        Border = Color3.fromRGB(90, 50, 45)
    },
    
    CottonCandy = {
        Background = Color3.fromRGB(240, 190, 240),
        TabBackground = Color3.fromRGB(250, 200, 250),
        TabActive = Color3.fromRGB(255, 100, 200),
        Button = Color3.fromRGB(255, 210, 255),
        ButtonHover = Color3.fromRGB(255, 130, 220),
        Text = Color3.fromRGB(80, 60, 100),
        TextSecondary = Color3.fromRGB(120, 100, 140),
        Border = Color3.fromRGB(220, 170, 220)
    }
}

-- ==================== CLASSE PRINCIPAL ====================
BoladoHub.__index = BoladoHub

function BoladoHub.new(options)
    local self = setmetatable({}, BoladoHub)
    
    -- Configurações
    self.Config = {
        Name = options.Name or "BoladoHub",
        Size = options.Size or UDim2.new(0, 450, 0, 400),
        Theme = options.Theme or "Midnight",
        Position = options.Position or UDim2.new(0.5, -225, 0.5, -200),
        ShowMinimize = options.ShowMinimize ~= false,
        Draggable = options.Draggable ~= false,
        TouchEnabled = options.TouchEnabled ~= false,
        AnimationSpeed = options.AnimationSpeed or 0.3
    }
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Minimized = false
    self.Components = {}
    
    -- Inicializar
    self:Initialize()
    
    return self
end

function BoladoHub:Initialize()
    self:CreateScreenGui()
    self:CreateMainFrame()
    self:CreateTitleBar()
    self:CreateTabSystem()
    self:SetupHotkeys()
    self:PlayEnterAnimation()
end

function BoladoHub:CreateScreenGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BoladoHub_" .. self.Config.Name
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
end

function BoladoHub:CreateMainFrame()
    local theme = self:GetTheme()
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.Position = self.Config.Position
    self.MainFrame.BackgroundColor3 = theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.MainFrame
    
    -- Borda
    local border = Instance.new("UIStroke")
    border.Name = "Border"
    border.Color = theme.Border
    border.Thickness = 1.5
    border.Transparency = 0.7
    border.Parent = self.MainFrame
end

function BoladoHub:CreateTitleBar()
    local theme = self:GetTheme()
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.BackgroundColor3 = theme.TabActive
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Corner apenas no topo
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12, 0, 0)
    titleCorner.Parent = self.TitleBar
    
    -- Título
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Config.Name
    self.TitleLabel.TextColor3 = theme.Text
    self.TitleLabel.Font = Enum.Font.GothamSemibold
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Botões da barra
    self:CreateTitleButtons()
    
    -- Sistema de arrasto (Drag & Touch)
    self:SetupDragSystem()
end

function BoladoHub:CreateTitleButtons()
    local theme = self:GetTheme()
    local btnSize = UDim2.new(0, 30, 0, 30)
    
    -- Container de botões
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "TitleButtons"
    buttonsContainer.Size = UDim2.new(0, 70, 1, 0)
    buttonsContainer.Position = UDim2.new(1, -75, 0, 0)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = self.TitleBar
    
    -- Botão minimizar
    if self.Config.ShowMinimize then
        self.MinimizeBtn = Instance.new("ImageButton")
        self.MinimizeBtn.Name = "MinimizeBtn"
        self.MinimizeBtn.Size = btnSize
        self.MinimizeBtn.Position = UDim2.new(0, 5, 0.5, -15)
        self.MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        self.MinimizeBtn.BackgroundTransparency = 0.9
        self.MinimizeBtn.Image = GetIcon("chevron-down")
        self.MinimizeBtn.ImageColor3 = theme.Text
        self.MinimizeBtn.Parent = buttonsContainer
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = self.MinimizeBtn
        
        -- Efeitos hover
        self:AddHoverEffect(self.MinimizeBtn, 0.9, 0.8)
        
        -- Ação
        self.MinimizeBtn.MouseButton1Click:Connect(function()
            self:ToggleMinimize()
        end)
        
        -- Touch support
        if self.Config.TouchEnabled then
            self.MinimizeBtn.TouchTap:Connect(function()
                self:ToggleMinimize()
            end)
        end
    end
    
    -- Botão fechar
    self.CloseBtn = Instance.new("ImageButton")
    self.CloseBtn.Name = "CloseBtn"
    self.CloseBtn.Size = btnSize
    self.CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    self.CloseBtn.Image = GetIcon("xcircle")
    self.CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseBtn.Parent = buttonsContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.CloseBtn
    
    -- Efeitos hover
    self:AddHoverEffect(self.CloseBtn, 0, 0.2)
    
    -- Ação
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Touch support
    if self.Config.TouchEnabled then
        self.CloseBtn.TouchTap:Connect(function()
            self:Destroy()
        end)
    end
end

function BoladoHub:SetupDragSystem()
    local dragging = false
    local dragStart, startPos
    
    -- Função para iniciar arrasto (Mouse + Touch)
    local function startDrag(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or
           (self.Config.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            -- Feedback visual
            TweenService:Create(self.TitleBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.2
            }):Play()
        end
    end
    
    -- Função para atualizar posição (Mouse + Touch)
    local function updateDrag(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
           (self.Config.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch)) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    -- Função para parar arrasto (Mouse + Touch)
    local function endDrag(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or
           (self.Config.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            
            TweenService:Create(self.TitleBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
        end
    end
    
    -- Conectar eventos para TitleBar
    self.TitleBar.InputBegan:Connect(startDrag)
    self.TitleBar.InputChanged:Connect(updateDrag)
    self.TitleBar.InputEnded:Connect(endDrag)
    
    -- Conectar eventos para TitleLabel também
    self.TitleLabel.InputBegan:Connect(startDrag)
    self.TitleLabel.InputChanged:Connect(updateDrag)
    self.TitleLabel.InputEnded:Connect(endDrag)
end

function BoladoHub:CreateTabSystem()
    local theme = self:GetTheme()
    
    -- Container das abas (horizontal)
    self.TabsContainer = Instance.new("Frame")
    self.TabsContainer.Name = "TabsContainer"
    self.TabsContainer.Size = UDim2.new(1, -20, 0, 40)
    self.TabsContainer.Position = UDim2.new(0, 10, 0, 50)
    self.TabsContainer.BackgroundTransparency = 1
    self.TabsContainer.Parent = self.MainFrame
    
    -- Layout horizontal para abas
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 10)
    tabsLayout.Parent = self.TabsContainer
    
    -- Frame de conteúdo
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ClipsDescendants = true
    self.ContentFrame.Parent = self.MainFrame
    
    -- ScrollingFrame interno para conteúdo
    self.ContentScroll = Instance.new("ScrollingFrame")
    self.ContentScroll.Name = "ContentScroll"
    self.ContentScroll.Size = UDim2.new(1, 0, 1, 0)
    self.ContentScroll.BackgroundTransparency = 1
    self.ContentScroll.BorderSizePixel = 0
    self.ContentScroll.ScrollBarThickness = 4
    self.ContentScroll.ScrollBarImageColor3 = theme.TabActive
    self.ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentScroll.Parent = self.ContentFrame
    
    -- Layout do conteúdo
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 12)
    contentLayout.Parent = self.ContentScroll
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.PaddingLeft = UDim.new(0, 5)
    contentPadding.PaddingRight = UDim.new(0, 5)
    contentPadding.Parent = self.ContentScroll
end

function BoladoHub:AddTab(name, icon)
    local theme = self:GetTheme()
    
    -- Botão da aba (horizontal)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(0, 130, 1, 0)
    tabButton.BackgroundColor3 = theme.TabBackground
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabsContainer
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tabButton
    
    -- Ícone
    local iconImage
    if icon then
        iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.Size = UDim2.new(0, 22, 0, 22)
        iconImage.Position = UDim2.new(0, 15, 0.5, -11)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = GetIcon(icon)
        iconImage.ImageColor3 = theme.TextSecondary
        iconImage.Parent = tabButton
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, icon and -45 or -30, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 45 or 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = theme.TextSecondary
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton
    
    -- Armazenar
    self.Tabs[name] = {
        Button = tabButton,
        TextLabel = textLabel,
        Icon = iconImage,
        Name = name
    }
    
    -- Efeitos hover
    self:AddHoverEffect(tabButton, 0, -0.1, theme.TabBackground, theme.TabActive)
    
    -- Selecionar aba (Mouse)
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    -- Selecionar aba (Touch)
    if self.Config.TouchEnabled then
        tabButton.TouchTap:Connect(function()
            self:SelectTab(name)
        end)
    end
    
    -- Selecionar primeira aba
    if not self.CurrentTab then
        self:SelectTab(name)
    end
    
    return self.ContentScroll
end

function BoladoHub:SelectTab(name)
    if self.CurrentTab == name then return end
    
    local theme = self:GetTheme()
    
    -- Deselecionar aba atual
    if self.CurrentTab then
        local oldTab = self.Tabs[self.CurrentTab]
        if oldTab then
            TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = theme.TabBackground
            }):Play()
            
            if oldTab.Icon then
                TweenService:Create(oldTab.Icon, TweenInfo.new(0.2), {
                    ImageColor3 = theme.TextSecondary
                }):Play()
            end
            
            TweenService:Create(oldTab.TextLabel, TweenInfo.new(0.2), {
                TextColor3 = theme.TextSecondary
            }):Play()
        end
    end
    
    -- Selecionar nova aba
    local newTab = self.Tabs[name]
    if newTab then
        TweenService:Create(newTab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = theme.TabActive
        }):Play()
        
        if newTab.Icon then
            TweenService:Create(newTab.Icon, TweenInfo.new(0.2), {
                ImageColor3 = theme.Text
            }):Play()
        end
        
        TweenService:Create(newTab.TextLabel, TweenInfo.new(0.2), {
            TextColor3 = theme.Text
        }):Play()
        
        self.CurrentTab = name
        
        -- Limpar conteúdo anterior
        self:ClearContent()
    end
    
    return self.ContentScroll
end

function BoladoHub:ClearContent()
    for _, child in ipairs(self.ContentScroll:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

-- ==================== COMPONENTES ====================

function BoladoHub:Button(options)
    local parent = options.Parent or self.ContentScroll
    local text = options.Text or "Button"
    local icon = options.Icon
    local callback = options.Callback or function() end
    local tooltip = options.Tooltip
    
    local theme = self:GetTheme()
    
    local button = Instance.new("TextButton")
    button.Name = "Btn_" .. text
    button.Size = UDim2.new(1, 0, 0, 48)
    button.BackgroundColor3 = theme.Button
    button.AutoButtonColor = false
    button.Text = ""
    button.Parent = parent
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    -- Borda
    local border = Instance.new("UIStroke")
    border.Color = theme.Border
    border.Thickness = 1
    border.Transparency = 0.6
    border.Parent = button
    
    -- Ícone
    if icon then
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 26, 0, 26)
        iconLabel.Position = UDim2.new(0, 15, 0.5, -13)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = GetIcon(icon)
        iconLabel.ImageColor3 = theme.Text
        iconLabel.Parent = button
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, icon and -55 or -30, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 55 or 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = theme.Text
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button
    
    -- Efeitos hover
    self:AddHoverEffect(button, 0, -0.1, theme.Button, theme.ButtonHover)
    
    -- Clique (Mouse)
    button.MouseButton1Click:Connect(function()
        -- Animação de clique
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -5, 0, 45)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 48)
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    -- Clique (Touch)
    if self.Config.TouchEnabled then
        button.TouchTap:Connect(function()
            if callback then
                callback()
            end
        end)
    end
    
    -- Armazenar referência
    table.insert(self.Components, button)
    
    return {
        Instance = button,
        SetText = function(newText)
            textLabel.Text = newText
        end,
        SetEnabled = function(enabled)
            button.Active = enabled
            button.BackgroundTransparency = enabled and 0 or 0.5
        end
    }
end

function BoladoHub:Toggle(options)
    local parent = options.Parent or self.ContentScroll
    local text = options.Text or "Toggle"
    local icon = options.Icon
    local default = options.Default or false
    local callback = options.Callback or function() end
    
    local theme = self:GetTheme()
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "Tgl_" .. text
    toggleContainer.Size = UDim2.new(1, 0, 0, 48)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = parent
    
    -- Ícone
    local iconLabel
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 24, 0, 24)
        iconLabel.Position = UDim2.new(0, 0, 0.5, -12)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = GetIcon(icon)
        iconLabel.ImageColor3 = theme.Text
        iconLabel.Parent = toggleContainer
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0.7, icon and -40 or 0, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 40 or 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = theme.Text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggleContainer
    
    -- Botão toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 58, 0, 28)
    toggleBtn.Position = UDim2.new(1, -58, 0.5, -14)
    toggleBtn.BackgroundColor3 = default and theme.TabActive or theme.Button
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = ""
    toggleBtn.Parent = toggleContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = toggleBtn
    
    -- Indicador
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 22, 0, 22)
    indicator.Position = default and UDim2.new(1, -23, 0.5, -11) or UDim2.new(0, 1, 0.5, -11)
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
                BackgroundColor3 = theme.TabActive
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -11)
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = theme.Button
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 1, 0.5, -11)
            }):Play()
        end
        
        if callback then
            callback(state)
        end
    end
    
    -- Efeitos hover
    self:AddHoverEffect(toggleBtn)
    
    -- Clique (Mouse)
    toggleBtn.MouseButton1Click:Connect(toggleState)
    
    -- Clique (Touch)
    if self.Config.TouchEnabled then
        toggleBtn.TouchTap:Connect(toggleState)
    end
    
    table.insert(self.Components, toggleContainer)
    
    return {
        Instance = toggleContainer,
        State = function() return state end,
        Set = function(newState)
            if state ~= newState then
                toggleState()
            end
        end
    }
end

function BoladoHub:Slider(options)
    local parent = options.Parent or self.ContentScroll
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local callback = options.Callback or function() end
    local suffix = options.Suffix or ""
    
    local theme = self:GetTheme()
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = "Sld_" .. text
    sliderContainer.Size = UDim2.new(1, 0, 0, 65)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, 0, 0, 25)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text .. ": " .. default .. suffix
    textLabel.TextColor3 = theme.Text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = sliderContainer
    
    -- Barra
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0, 35)
    track.BackgroundColor3 = theme.Button
    track.BorderSizePixel = 0
    track.Parent = sliderContainer
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- Fill
    local fillSize = (default - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(fillSize, 0, 1, 0)
    fill.BackgroundColor3 = theme.TabActive
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- Handle
    local handle = Instance.new("TextButton")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new(fillSize, -10, 0.5, -10)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.AutoButtonColor = false
    handle.Text = ""
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    -- Estado
    local dragging = false
    local value = default
    
    -- Atualizar valor
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local normalized = (value - min) / (max - min)
        
        fill.Size = UDim2.new(normalized, 0, 1, 0)
        handle.Position = UDim2.new(normalized, -10, 0.5, -10)
        textLabel.Text = text .. ": " .. math.floor(value) .. suffix
        
        if callback then
            callback(value)
        end
    end
    
    -- Funções de input (Mouse + Touch)
    local function onInputBegan(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or
           (self.Config.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            
            -- Feedback visual
            TweenService:Create(handle, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 24, 0, 24)
            }):Play()
        end
    end
    
    local function onInputEnded(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1) or
           (self.Config.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            
            TweenService:Create(handle, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 20, 0, 20)
            }):Play()
        end
    end
    
    local function updateFromInput(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
           (self.Config.TouchEnabled and input.UserInputType == Enum.UserInputType.Touch)) then
            local mousePos = input.Position
            local trackAbsPos = track.AbsolutePosition
            local trackAbsSize = track.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - trackAbsPos.X) / trackAbsSize.X, 0, 1)
            local newValue = min + (relativeX * (max - min))
            
            updateValue(newValue)
        end
    end
    
    -- Conectar eventos
    handle.InputBegan:Connect(onInputBegan)
    handle.InputEnded:Connect(onInputEnded)
    track.InputBegan:Connect(onInputBegan)
    track.InputEnded:Connect(onInputEnded)
    
    UserInputService.InputChanged:Connect(updateFromInput)
    
    table.insert(self.Components, sliderContainer)
    
    return {
        Instance = sliderContainer,
        Value = function() return value end,
        Set = function(newValue) updateValue(newValue) end
    }
end

function BoladoHub:Label(options)
    local parent = options.Parent or self.ContentScroll
    local text = options.Text or "Label"
    local color = options.Color or self:GetTheme().Text
    local size = options.Size or 14
    local align = options.Align or Enum.TextXAlignment.Left
    local bold = options.Bold or false
    
    local label = Instance.new("TextLabel")
    label.Name = "Lbl_" .. text
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextSize = size
    label.TextXAlignment = align
    label.TextWrapped = true
    label.Parent = parent
    
    return label
end

-- ==================== FUNÇÕES AUXILIARES ====================

function BoladoHub:AddHoverEffect(button, defaultTransparency, hoverTransparency, defaultColor, hoverColor)
    local theme = self:GetTheme()
    local originalColor = defaultColor or button.BackgroundColor3
    local originalTransparency = defaultTransparency or button.BackgroundTransparency
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor or theme.ButtonHover,
            BackgroundTransparency = hoverTransparency or math.max(originalTransparency - 0.1, 0)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        }):Play()
    end)
end

function BoladoHub:ToggleMinimize()
    if self.Minimized then
        -- Restaurar
        TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed), {
            Size = self.Config.Size
        }):Play()
        self.Minimized = false
        if self.MinimizeBtn then
            self.MinimizeBtn.Image = GetIcon("chevron-down")
        end
    else
        -- Minimizar
        TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed), {
            Size = UDim2.new(0, 300, 0, 40)
        }):Play()
        self.Minimized = true
        if self.MinimizeBtn then
            self.MinimizeBtn.Image = GetIcon("chevron-up")
        end
    end
end

function BoladoHub:SetTheme(themeName)
    if Themes[themeName] then
        self.Config.Theme = themeName
        self:UpdateTheme()
        return true
    end
    return false
end

function BoladoHub:UpdateTheme()
    local theme = self:GetTheme()
    
    -- Atualizar cores principais
    self.MainFrame.BackgroundColor3 = theme.Background
    
    if self.TitleBar then
        self.TitleBar.BackgroundColor3 = theme.TabActive
    end
    
    if self.TitleLabel then
        self.TitleLabel.TextColor3 = theme.Text
    end
    
    local border = self.MainFrame:FindFirstChild("Border")
    if border then
        border.Color = theme.Border
    end
    
    if self.ContentScroll then
        self.ContentScroll.ScrollBarImageColor3 = theme.TabActive
    end
    
    -- Atualizar abas
    for name, tab in pairs(self.Tabs) do
        if name == self.CurrentTab then
            tab.Button.BackgroundColor3 = theme.TabActive
            if tab.Icon then tab.Icon.ImageColor3 = theme.Text end
            if tab.TextLabel then tab.TextLabel.TextColor3 = theme.Text end
        else
            tab.Button.BackgroundColor3 = theme.TabBackground
            if tab.Icon then tab.Icon.ImageColor3 = theme.TextSecondary end
            if tab.TextLabel then tab.TextLabel.TextColor3 = theme.TextSecondary end
        end
    end
    
    -- Atualizar componentes
    for _, component in ipairs(self.Components) do
        if component:IsA("TextButton") then
            if component.Name:find("ToggleBtn") then
                -- É um toggle
            else
                -- É um botão normal
                component.BackgroundColor3 = theme.Button
                local compBorder = component:FindFirstChildOfClass("UIStroke")
                if compBorder then
                    compBorder.Color = theme.Border
                end
                
                local icon = component:FindFirstChild("Icon")
                if icon then
                    icon.ImageColor3 = theme.Text
                end
                
                local label = component:FindFirstChild("Label")
                if label then
                    label.TextColor3 = theme.Text
                end
            end
        end
    end
end

function BoladoHub:GetTheme()
    return Themes[self.Config.Theme] or Themes["Midnight"]
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

function BoladoHub:PlayEnterAnimation()
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = self.Config.Size,
        Position = self.Config.Position
    }):Play()
end

function BoladoHub:Destroy()
    TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(self.Config.AnimationSpeed)
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Métodos utilitários
function BoladoHub:GetCurrentTab()
    return self.CurrentTab
end

function BoladoHub:GetAvailableThemes()
    local themeNames = {}
    for name, _ in pairs(Themes) do
        table.insert(themeNames, name)
    end
    return themeNames
end

function BoladoHub:Show()
    self.ScreenGui.Enabled = true
end

function BoladoHub:Hide()
    self.ScreenGui.Enabled = false
end

function BoladoHub:IsVisible()
    return self.ScreenGui.Enabled
end

return BoladoHub
