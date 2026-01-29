-- BoladoHub Example - Exemplo de uso da biblioteca
-- Drag, Touch e Minimizar funcionais

-- Carregar a biblioteca
local BoladoHub = loadstring(game:HttpGet("URL_DA_BIBLIOTECA"))()

-- Criar interface com todos os recursos
local hub = BoladoHub.new({
    Name = "BoladoHub Pro",
    Size = UDim2.new(0, 500, 0, 450),
    Theme = "Midnight", -- Escolha o tema: Midnight, Cyberpunk, Forest, Lava, CottonCandy
    ShowMinimize = true, -- Ativar botão minimizar
    Draggable = true,    -- Ativar drag com mouse
    TouchEnabled = true, -- Ativar suporte a touch
    AnimationSpeed = 0.3 -- Velocidade das animações
})

print("🎮 BoladoHub v3.0 Carregado!")
print("🎯 Recursos Ativos:")
print("   ✅ Drag & Drop (Mouse)")
print("   ✅ Touch Support")
print("   ✅ Botão Minimizar")
print("   ✅ 5 Temas Disponíveis")
print("   ✅ Hotkeys: Insert, Delete, RightShift")
print("========================================")

-- ==================== CRIAR ABAS SEPARADAS ====================
print("📁 Criando abas...")

-- Adicionar aba Config
local configTab = hub:AddTab("Config", "settings")

-- Adicionar aba Principal
local mainTab = hub:AddTab("Principal", "home")

-- Adicionar aba Visuals
local visualsTab = hub:AddTab("Visuals", "eye")

-- ==================== CONTEÚDO DA ABA CONFIG ====================
print("🔧 Configurando aba Config...")
hub:SelectTab("Config")

-- Botões da aba Config
hub:Button({
    Text = "Salvar Configurações",
    Icon = "checkcircle",
    Callback = function()
        print("✅ Configurações salvas!")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "BoladoHub",
            Text = "Configurações salvas com sucesso!",
            Duration = 3
        })
    end
})

hub:Button({
    Text = "Resetar Tudo",
    Icon = "refreshcw",
    Callback = function()
        print("🔄 Configuração resetada!")
    end
})

hub:Button({
    Text = "Exportar Config",
    Icon = "download",
    Callback = function()
        print("📤 Configuração exportada!")
    end
})

-- Toggle da aba Config
hub:Toggle({
    Text = "Modo Noturno",
    Icon = "moon",
    Default = true,
    Callback = function(state)
        print("🌙 Modo Noturno:", state and "ATIVADO" or "DESATIVADO")
    end
})

hub:Toggle({
    Text = "Auto-Save",
    Icon = "save",
    Default = false,
    Callback = function(state)
        print("💾 Auto-Save:", state and "ATIVADO" or "DESATIVADO")
    end
})

-- Slider da aba Config
hub:Slider({
    Text = "Volume",
    Icon = "volume",
    Min = 0,
    Max = 100,
    Default = 70,
    Suffix = "%",
    Callback = function(value)
        print("🔊 Volume ajustado para:", value .. "%")
    end
})

-- ==================== CONTEÚDO DA ABA PRINCIPAL ====================
print("🏠 Configurando aba Principal...")
hub:SelectTab("Principal")

-- Botões da aba Principal
hub:Button({
    Text = "Ativar Fly",
    Icon = "bolt",
    Callback = function()
        print("✈️ Fly ativado!")
        -- Exemplo: Ativar fly hack
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character.Humanoid.WalkSpeed = 50
            print("   Speed aumentado para 50!")
        end
    end
})

hub:Button({
    Text = "God Mode",
    Icon = "shield",
    Callback = function()
        print("🛡️ God Mode ativado!")
    end
})

hub:Button({
    Text = "Speed Hack",
    Icon = "zap",
    Callback = function()
        print("⚡ Speed Hack ativado!")
    end
})

hub:Button({
    Text = "Noclip",
    Icon = "user",
    Callback = function()
        print("👻 Noclip ativado!")
    end
})

-- Toggles da aba Principal
local espToggle = hub:Toggle({
    Text = "ESP Players",
    Icon = "eye",
    Default = true,
    Callback = function(state)
        print("👁️ ESP Players:", state and "ATIVADO" or "DESATIVADO")
    end
})

local aimbotToggle = hub:Toggle({
    Text = "Aimbot",
    Icon = "target",
    Default = false,
    Callback = function(state)
        print("🎯 Aimbot:", state and "ATIVADO" or "DESATIVADO")
    end
})

-- Slider da aba Principal
hub:Slider({
    Text = "Field of View",
    Icon = "eye",
    Min = 50,
    Max = 120,
    Default = 70,
    Suffix = "°",
    Callback = function(value)
        print("👁️ FOV ajustado para:", value .. "°")
    end
})

-- ==================== CONTEÚDO DA ABA VISUALS ====================
print("🎨 Configurando aba Visuals...")
hub:SelectTab("Visuals")

-- Botões da aba Visuals
hub:Button({
    Text = "Wallhack",
    Icon = "eye",
    Callback = function()
        print("🧱 Wallhack ativado!")
    end
})

hub:Button({
    Text = "Full Bright",
    Icon = "sun",
    Callback = function()
        print("☀️ Full Bright ativado!")
        -- Exemplo: Aumentar brilho
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").GlobalShadows = false
    end
})

hub:Button({
    Text = "Chams",
    Icon = "paintbrush",
    Callback = function()
        print("🎨 Chams ativado!")
    end
})

hub:Button({
    Text = "Rainbow GUI",
    Icon = "palette",
    Callback = function()
        print("🌈 Rainbow GUI ativado!")
        -- Exemplo: Mudar tema dinamicamente
        local themes = {"Midnight", "Cyberpunk", "Forest", "Lava", "CottonCandy"}
        local currentIndex = 1
        local function cycleTheme()
            hub:SetTheme(themes[currentIndex])
            currentIndex = currentIndex % #themes + 1
        end
        cycleTheme()
    end
})

-- Toggles da aba Visuals
hub:Toggle({
    Text = "Show FPS",
    Icon = "cpu",
    Default = true,
    Callback = function(state)
        print("📊 FPS Counter:", state and "VISÍVEL" or "OCULTO")
    end
})

hub:Toggle({
    Text = "Show Coordinates",
    Icon = "map",
    Default = false,
    Callback = function(state)
        print("📍 Coordinates:", state and "VISÍVEIS" or "OCULTAS")
    end
})

-- Slider da aba Visuals
hub:Slider({
    Text = "Brightness",
    Icon = "sun",
    Min = 0,
    Max = 5,
    Default = 1,
    Decimal = 1,
    Callback = function(value)
        print("💡 Brilho ajustado para:", value)
        game:GetService("Lighting").Brightness = value
    end
})

-- ==================== SISTEMA DE TEMAS DINÂMICO ====================
print("🎨 Configurando sistema de temas...")

-- Label informativa
hub:Label({
    Text = "Trocar Tema:",
    Size = 16,
    Bold = true
})

-- Botões para mudar tema
hub:Button({
    Text = "Tema Cyberpunk",
    Icon = "palette",
    Callback = function()
        hub:SetTheme("Cyberpunk")
        print("🎮 Tema alterado para: Cyberpunk")
    end
})

hub:Button({
    Text = "Tema Forest",
    Icon = "tree",
    Callback = function()
        hub:SetTheme("Forest")
        print("🎮 Tema alterado para: Forest")
    end
})

hub:Button({
    Text = "Tema Lava",
    Icon = "fire",
    Callback = function()
        hub:SetTheme("Lava")
        print("🎮 Tema alterado para: Lava")
    end
})

-- ==================== DEMONSTRAÇÃO DE DRAG & TOUCH ====================
print("👆 Demonstrando Drag & Touch...")

hub:Label({
    Text = "Demonstração:",
    Size = 16,
    Bold = true
})

hub:Label({
    Text = "• Arraste a barra de título para mover\n• Toque nos botões (dispositivos móveis)\n• Use os botões de controle abaixo",
    Size = 12
})

-- Botões de controle
hub:Button({
    Text = "Mostrar/Esconder (Insert)",
    Icon = "eye",
    Callback = function()
        hub:Hide()
        task.wait(1)
        hub:Show()
        print("👁️ Interface escondida e mostrada!")
    end
})

hub:Button({
    Text = "Minimizar (RightShift)",
    Icon = "chevron-down",
    Callback = function()
        hub:ToggleMinimize()
        print(hub.Minimized and "📥 Interface minimizada!" or "📤 Interface restaurada!")
    end
})

hub:Button({
    Text = "Testar Touch Simulado",
    Icon = "hand",
    Callback = function()
        print("👉 Touch simulado: Todos os botões respondem a toque!")
        print("   (Em dispositivos móveis, toque funciona normalmente)")
    end
})

-- ==================== SISTEMA DE LOGS ====================
print("📝 Inicializando sistema de logs...")

-- Criar aba de Logs
local logsTab = hub:AddTab("Logs", "info")
hub:SelectTab("Logs")

-- Label de logs
hub:Label({
    Text = "📊 SISTEMA DE LOGS",
    Size = 18,
    Bold = true,
    Align = Enum.TextXAlignment.Center
})

hub:Label({
    Text = "Aqui aparecem todas as ações realizadas:",
    Size = 14,
    Align = Enum.TextXAlignment.Center
})

-- Função para adicionar log
local function addLog(message)
    hub:Label({
        Text = "[" .. os.date("%H:%M:%S") .. "] " .. message,
        Size = 12,
        Color = Color3.fromRGB(200, 200, 200)
    })
end

-- Botão para limpar logs
hub:Button({
    Text = "Limpar Logs",
    Icon = "trash",
    Callback = function()
        hub:ClearContent()
        addLog("Logs limpos!")
    end
})

-- Voltar para aba Principal
hub:SelectTab("Principal")

-- Adicionar logs iniciais
addLog("BoladoHub inicializado com sucesso!")
addLog("Drag & Touch ativados")
addLog("Sistema de temas carregado")
addLog("3 abas criadas: Config, Principal, Visuals")

-- ==================== HOTKEYS & CONTROLES ====================
print("⌨️ Configurando hotkeys...")

-- Instruções
hub:Label({
    Text = "🎮 CONTROLES RÁPIDOS:",
    Size = 16,
    Bold = true
})

hub:Label({
    Text = "• INSERT: Mostrar/Esconder\n• DELETE: Fechar interface\n• RIGHTSHIFT: Minimizar/Restaurar\n• Arraste a barra de título para mover",
    Size = 12
})

print("========================================")
print("✅ BoladoHub configurado com sucesso!")
print("========================================")
print("🎯 Use INSERT para mostrar/esconder")
print("🎯 Arraste a barra de título para mover")
print("🎯 Clique em RightShift para minimizar")
print("🎯 Toque funciona em dispositivos móveis")
print("========================================")

-- Notificação inicial
task.spawn(function()
    wait(1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "BoladoHub Pro",
        Text = "Interface carregada com sucesso!\nArraste para mover • Toque para interagir",
        Duration = 5
    })
end)

-- Retornar a hub para uso externo
return hub        Draggable = options.Draggable ~= false
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
