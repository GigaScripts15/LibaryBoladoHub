-- BoladoHub Premium v2.1 - Corrigido
-- Botões visíveis e funcionais

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
    ["flag"] = "rbxassetid://10723375890"
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
        Draggable = options.Draggable ~= false
    }
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Minimized = false
    self.Components = {} -- Para armazenar componentes
    
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
    
    -- Sistema de arrasto
    if self.Config.Draggable then
        self:SetupDragSystem()
    end
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
end

function BoladoHub:SetupDragSystem()
    local dragging = false
    local dragStart, startPos
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            TweenService:Create(self.TitleBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.2
            }):Play()
        end
    end
    
    local function updateDrag(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            
            TweenService:Create(self.TitleBar, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
        end
    end
    
    self.TitleBar.InputBegan:Connect(startDrag)
    self.TitleBar.InputChanged:Connect(updateDrag)
    self.TitleBar.InputEnded:Connect(endDrag)
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
    
    -- Frame de conteúdo (FIXO - SEM SCROLLINGFRAME)
    self.ContentFrame = Instance.new("Frame")  -- Mudado para Frame regular
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ClipsDescendants = true
    self.ContentFrame.Parent = self.MainFrame
    
    -- Layout do conteúdo (agora dentro de um ScrollingFrame interno)
    self.ContentScroll = Instance.new("ScrollingFrame")
    self.ContentScroll.Name = "ContentScroll"
    self.ContentScroll.Size = UDim2.new(1, 0, 1, 0)
    self.ContentScroll.BackgroundTransparency = 1
    self.ContentScroll.BorderSizePixel = 0
    self.ContentScroll.ScrollBarThickness = 4
    self.ContentScroll.ScrollBarImageColor3 = theme.TabActive
    self.ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentScroll.Parent = self.ContentFrame
    
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
    
    -- Selecionar aba
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
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
        
        -- Criar conteúdo da aba
        self:CreateTabContent(name)
    end
end

function BoladoHub:CreateTabContent(tabName)
    -- Limpar conteúdo anterior
    for _, child in ipairs(self.ContentScroll:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    -- Criar conteúdo específico da aba
    if tabName == "Config" then
        self:AddButton("Salvar Configurações", "checkcircle", function()
            print("Configurações salvas!")
        end)
        
        self:AddButton("Resetar Config", "refreshcw", function()
            print("Configuração resetada!")
        end)
        
        self:AddButton("Exportar Config", "download", function()
            print("Configuração exportada!")
        end)
        
        self:AddToggle("Modo Noturno", false, function(state)
            print("Modo Noturno:", state)
        end)
        
    elseif tabName == "Principal" then
        self:AddButton("Ativar Fly", "bolt", function()
            print("Fly ativado!")
        end)
        
        self:AddButton("God Mode", "shield", function()
            print("God Mode ativado!")
        end)
        
        self:AddButton("Speed Hack", "zap", function()
            print("Speed aumentado!")
        end)
        
        self:AddButton("Noclip", "user", function()
            print("Noclip ativado!")
        end)
        
        self:AddToggle("ESP Players", true, function(state)
            print("ESP:", state)
        end)
        
    elseif tabName == "Visuals" then
        self:AddButton("Wallhack", "eye", function()
            print("Wallhack ativado!")
        end)
        
        self:AddButton("Full Bright", "sun", function()
            print("Full Bright ativado!")
        end)
        
        self:AddButton("Chams", "paintbrush", function()
            print("Chams ativado!")
        end)
        
        self:AddToggle("Rainbow Mode", false, function(state)
            print("Rainbow Mode:", state)
        end)
    end
end

-- ==================== COMPONENTES (CORRIGIDOS) ====================

function BoladoHub:AddButton(text, icon, callback)
    local theme = self:GetTheme()
    
    local button = Instance.new("TextButton")
    button.Name = "Btn_" .. text
    button.Size = UDim2.new(1, 0, 0, 48)  -- Tamanho fixo
    button.BackgroundColor3 = theme.Button
    button.AutoButtonColor = false
    button.Text = ""
    button.Parent = self.ContentScroll  -- Agora vai direto no ContentScroll
    
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
    
    -- Texto (CORRIGIDO - usando operador ternário correto)
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
    
    -- Clique
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
    
    -- Armazenar referência
    table.insert(self.Components, button)
    return button
end

function BoladoHub:AddToggle(text, default, callback)
    local theme = self:GetTheme()
    
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "Tgl_" .. text
    toggleContainer.Size = UDim2.new(1, 0, 0, 48)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = self.ContentScroll
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0.7, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
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
    
    -- Clique
    toggleBtn.MouseButton1Click:Connect(toggleState)
    
    table.insert(self.Components, toggleContainer)
    return {
        State = function() return state end,
        Set = function(newState)
            if state ~= newState then
                toggleState()
            end
        end
    }
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
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
            Size = self.Config.Size
        }):Play()
        self.Minimized = false
        self.MinimizeBtn.Image = GetIcon("chevron-down")
    else
        -- Minimizar
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 300, 0, 40)
        }):Play()
        self.Minimized = true
        self.MinimizeBtn.Image = GetIcon("chevron-up")
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
        if component:IsA("TextButton") and not component.Name:find("ToggleBtn") then
            component.BackgroundColor3 = theme.Button
            local border = component:FindFirstChildOfClass("UIStroke")
            if border then
                border.Color = theme.Border
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
    
    TweenService:Create(self.MainFrame, TweenInfo.new(0.6), {
        Size = self.Config.Size,
        Position = self.Config.Position
    }):Play()
end

function BoladoHub:Destroy()
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.3)
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Método para criar interface completa de exemplo
function BoladoHub:CreateExample()
    -- Adicionar abas
    self:AddTab("Config", "settings")
    self:AddTab("Principal", "home")
    self:AddTab("Visuals", "eye")
    
    print("BoladoHub criado com sucesso!")
    print("Use Insert para mostrar/esconder")
    print("Use Delete para fechar")
    print("Use RightShift para minimizar")
end

return BoladoHub
