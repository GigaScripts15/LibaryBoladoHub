--[[
    ╔════════════════════════════════════════════════════════════════╗
    ║                  AXIOMX UI LIBRARY v2.0 (Pro)                 ║
    ║                                                                ║
    ║  Clone aprimorado do Rayfield com Ícones, Sliders Suaves       ║
    ║  e Sistema de Keybinds.                                        ║
    ║                                                                ║
    ║  Autor: AxiomX Community | Licença: MIT                       ║
    ╚════════════════════════════════════════════════════════════════╝
]]

local AxiomX = {}
AxiomX.__index = AxiomX
AxiomX.Version = "2.0.0"

-- Serviços
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Verificação de Ambiente
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Prevenção de Múltiplas Execuções
if _G.AxiomXLoaded then
    warn("[AxiomX] A interface já está carregada!")
    return
end
_G.AxiomXLoaded = true

-- Ícones (Lucide / RBX Assets)
local Icons = {
    Home = "rbxassetid://3926305904",
    Settings = "rbxassetid://3926307971",
    User = "rbxassetid://3926307971",
    Info = "rbxassetid://3926305904",
    Search = "rbxassetid://3926305904",
    Arrow = "rbxassetid://6034818372", -- Seta para dropdown
    Close = "rbxassetid://3926305904"
}

-- ============= UI HELPERS =============

local function GetCorrectParent()
    -- Tenta colocar no CoreGui (mais seguro/protegido) se o exploit permitir, senão PlayerGui
    local success, result = pcall(function()
        return CoreGui
    end)
    if success then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.InOut
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ============= NOTIFICAÇÃO =============
local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "AxiomX_Notify"
NotificationHolder.ResetOnSpawn = false
NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationHolder.Parent = GetCorrectParent()

function AxiomX:Notify(args)
    local title = args.Title or "Notificação"
    local content = args.Content or "Mensagem vazia"
    local duration = args.Duration or 5
    local image = args.Image or Icons.Info

    local notifyFrame = Instance.new("Frame")
    notifyFrame.Name = "NotifyFrame"
    notifyFrame.Parent = NotificationHolder
    notifyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    notifyFrame.BorderSizePixel = 0
    notifyFrame.Position = UDim2.new(1, 10, 1, -150) -- Começa fora da tela
    notifyFrame.Size = UDim2.new(0, 300, 0, 80)
    notifyFrame.AnchorPoint = Vector2.new(0, 1)

    -- Layout automático para múltiplas notificações
    local listLayout = NotificationHolder:FindFirstChild("Layout")
    if not listLayout then
        listLayout = Instance.new("UIListLayout")
        listLayout.Name = "Layout"
        listLayout.Parent = NotificationHolder
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        listLayout.Padding = UDim.new(0, 10)
    end
    
    -- Estilo
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifyFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(60, 60, 80)
    stroke.Parent = notifyFrame

    -- Barra de Duração
    local timerBar = Instance.new("Frame")
    timerBar.Name = "Timer"
    timerBar.Parent = notifyFrame
    timerBar.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    timerBar.BorderSizePixel = 0
    timerBar.Size = UDim2.new(1, 0, 0, 2)
    timerBar.Position = UDim2.new(0, 0, 1, -2)
    
    local timerCorner = Instance.new("UICorner")
    timerCorner.CornerRadius = UDim.new(0, 2)
    timerCorner.Parent = timerBar

    -- Título e Texto
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notifyFrame
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Parent = notifyFrame
    msgLabel.Text = content
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 12
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Position = UDim2.new(0, 15, 0, 35)
    msgLabel.Size = UDim2.new(1, -20, 0, 35)
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top

    -- Animação de Entrada
    Tween(notifyFrame, {Position = UDim2.new(1, -20, 1, -20)}, 0.5, Enum.EasingStyle.Back)
    Tween(timerBar, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        local outTween = Tween(notifyFrame, {Position = UDim2.new(1, 350, 1, -20)}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        outTween.Completed:Connect(function()
            notifyFrame:Destroy()
        end)
    end)
end

-- ============= TEMAS =============
local Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 35),
        Secondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(0, 180, 255), -- Rayfield Blue
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 160),
        Stroke = Color3.fromRGB(50, 50, 70)
    }
}
local CurrentTheme = Themes.Dark

-- ============= JANELA PRINCIPAL =============
local Window = {}
Window.__index = Window

function AxiomX:CreateWindow(settings)
    local self = setmetatable({}, Window)
    
    self.Name = settings.Name or "AxiomX Hub"
    self.LoadingTitle = settings.LoadingTitle or "AxiomX"
    self.Parent = GetCorrectParent()
    self.Tabs = {}
    
    -- GUI Container Principal
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = "AxiomX_Main"
    self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.Gui.ResetOnSpawn = false
    self.Gui.Parent = self.Parent
    
    -- Toggle Key (Padrão: RightControl)
    self.ToggleKey = Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == self.ToggleKey then
            self.Gui.Enabled = not self.Gui.Enabled
        end
    end)

    -- Frame Principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.BackgroundColor3 = CurrentTheme.Main
    self.MainFrame.Size = UDim2.new(0, 650, 0, 450) -- Tamanho Rayfield Padrão
    self.MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    self.MainFrame.Parent = self.Gui
    self.MainFrame.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = self.MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = CurrentTheme.Stroke
    mainStroke.Thickness = 1
    mainStroke.Parent = self.MainFrame

    -- Sistema de Dragging (Arrastar Janela)
    local dragging, dragInput, dragStart, startPos
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(self.MainFrame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)

    -- Barra Lateral (Sidebar)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.BackgroundColor3 = CurrentTheme.Secondary
    self.Sidebar.Size = UDim2.new(0, 180, 1, 0)
    self.Sidebar.Parent = self.MainFrame
    
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 10)
    sideCorner.Parent = self.Sidebar
    
    -- Correção visual para o canto direito da sidebar não ser redondo
    local hideCorner = Instance.new("Frame")
    hideCorner.BackgroundColor3 = CurrentTheme.Secondary
    hideCorner.BorderSizePixel = 0
    hideCorner.Size = UDim2.new(0, 10, 1, 0)
    hideCorner.Position = UDim2.new(1, -10, 0, 0)
    hideCorner.Parent = self.Sidebar

    -- Título do Hub
    local hubTitle = Instance.new("TextLabel")
    hubTitle.Text = self.Name
    hubTitle.Font = Enum.Font.GothamBold
    hubTitle.TextSize = 18
    hubTitle.TextColor3 = CurrentTheme.Accent
    hubTitle.BackgroundTransparency = 1
    hubTitle.Size = UDim2.new(1, -20, 0, 50)
    hubTitle.Position = UDim2.new(0, 10, 0, 10)
    hubTitle.TextXAlignment = Enum.TextXAlignment.Left
    hubTitle.Parent = self.Sidebar

    -- Container de Botões das Abas
    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Size = UDim2.new(1, 0, 1, -70)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 60)
    self.TabContainer.ScrollBarThickness = 2
    self.TabContainer.Parent = self.Sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = self.TabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.Parent = self.TabContainer

    -- Área de Conteúdo (Páginas)
    self.PageContainer = Instance.new("Frame")
    self.PageContainer.Name = "PageContainer"
    self.PageContainer.BackgroundTransparency = 1
    self.PageContainer.Size = UDim2.new(1, -190, 1, -20)
    self.PageContainer.Position = UDim2.new(0, 190, 0, 10)
    self.PageContainer.Parent = self.MainFrame
    
    -- Botão de Fechar/Minimizar (Estético)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = CurrentTheme.TextDark
    closeBtn.BackgroundTransparency = 1
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Parent = self.MainFrame
    closeBtn.MouseButton1Click:Connect(function()
        -- Animação de saída antes de destruir
        Tween(self.MainFrame, {Size = UDim2.new(0, 650, 0, 0)}, 0.3)
        wait(0.3)
        self.Gui:Destroy()
        _G.AxiomXLoaded = false
    end)

    return self
end

function Window:CreateTab(name, icon)
    local tab = {}
    local tabIndex = #self.Tabs + 1
    
    -- Botão da Aba
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.TextColor3 = CurrentTheme.TextDark
    tabBtn.TextSize = 13
    tabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.BackgroundTransparency = 1 -- Começa invisível
    tabBtn.Size = UDim2.new(1, -20, 0, 35)
    tabBtn.Parent = self.TabContainer
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Padding para texto não colar na borda
    local btnPadding = Instance.new("UIPadding")
    btnPadding.PaddingLeft = UDim.new(0, 10)
    btnPadding.Parent = tabBtn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    -- Ícone (Opcional)
    if icon and Icons[icon] then
        local iconImg = Instance.new("ImageLabel")
        iconImg.BackgroundTransparency = 1
        iconImg.Image = Icons[icon]
        iconImg.ImageColor3 = CurrentTheme.TextDark
        iconImg.Size = UDim2.new(0, 20, 0, 20)
        iconImg.Position = UDim2.new(1, -30, 0.5, -10)
        iconImg.Parent = tabBtn
        tabBtn.Text = " " .. name -- Espaço extra
    end

    -- Página de Conteúdo
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "_Page"
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.Visible = false
    page.Parent = self.PageContainer
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = page

    -- Função de Ativação da Aba
    local function Activate()
        -- Reseta todas as abas
        for _, t in pairs(self.Tabs) do
            Tween(t.Btn, {BackgroundTransparency = 1, TextColor3 = CurrentTheme.TextDark}, 0.2)
            t.Page.Visible = false
        end
        -- Ativa a atual
        Tween(tabBtn, {BackgroundTransparency = 0.9, TextColor3 = CurrentTheme.Accent, BackgroundColor3 = CurrentTheme.Accent}, 0.2)
        page.Visible = true
    end

    tabBtn.MouseButton1Click:Connect(Activate)

    -- Se for a primeira aba, ativa automaticamente
    if tabIndex == 1 then
        Activate()
    end

    table.insert(self.Tabs, {Btn = tabBtn, Page = page})

    -- Funções da Aba (Componentes)
    
    function tab:CreateSection(text)
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Text = text
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextSize = 14
        sectionTitle.TextColor3 = CurrentTheme.TextDark
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Size = UDim2.new(1, 0, 0, 30)
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = page
        
        local p = Instance.new("UIPadding")
        p.PaddingLeft = UDim.new(0, 5)
        p.Parent = sectionTitle
    end

    function tab:CreateButton(settings)
        local btnSettings = settings or {}
        local text = btnSettings.Name or "Button"
        local callback = btnSettings.Callback or function() end

        local btnFrame = Instance.new("TextButton")
        btnFrame.BackgroundColor3 = CurrentTheme.Secondary
        btnFrame.Size = UDim2.new(1, -10, 0, 40)
        btnFrame.Text = ""
        btnFrame.AutoButtonColor = false
        btnFrame.Parent = page

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btnFrame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = CurrentTheme.Stroke
        stroke.Thickness = 1
        stroke.Parent = btnFrame
        
        local btnLabel = Instance.new("TextLabel")
        btnLabel.Text = text
        btnLabel.Font = Enum.Font.GothamMedium
        btnLabel.TextColor3 = CurrentTheme.Text
        btnLabel.TextSize = 14
        btnLabel.BackgroundTransparency = 1
        btnLabel.Size = UDim2.new(1, -40, 1, 0)
        btnLabel.Position = UDim2.new(0, 15, 0, 0)
        btnLabel.TextXAlignment = Enum.TextXAlignment.Left
        btnLabel.Parent = btnFrame
        
        -- Ícone interativo
        local icon = Instance.new("ImageLabel")
        icon.Image = "rbxassetid://3926305904" -- Mouse Click Icon
        icon.ImageColor3 = CurrentTheme.TextDark
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(1, -30, 0.5, -10)
        icon.Parent = btnFrame

        btnFrame.MouseEnter:Connect(function()
            Tween(btnFrame, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.2)
            Tween(stroke, {Color = CurrentTheme.Accent}, 0.2)
        end)
        btnFrame.MouseLeave:Connect(function()
            Tween(btnFrame, {BackgroundColor3 = CurrentTheme.Secondary}, 0.2)
            Tween(stroke, {Color = CurrentTheme.Stroke}, 0.2)
        end)

        btnFrame.MouseButton1Click:Connect(function()
            -- Efeito de clique simples
            Tween(btnFrame, {Size = UDim2.new(1, -15, 0, 38)}, 0.05)
            wait(0.05)
            Tween(btnFrame, {Size = UDim2.new(1, -10, 0, 40)}, 0.05)
            callback()
        end)
    end

    function tab:CreateToggle(settings)
        local tglSettings = settings or {}
        local text = tglSettings.Name or "Toggle"
        local state = tglSettings.CurrentValue or false
        local callback = tglSettings.Callback or function() end

        local tglFrame = Instance.new("TextButton")
        tglFrame.BackgroundColor3 = CurrentTheme.Secondary
        tglFrame.Size = UDim2.new(1, -10, 0, 40)
        tglFrame.Text = ""
        tglFrame.AutoButtonColor = false
        tglFrame.Parent = page
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tglFrame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = CurrentTheme.Stroke
        stroke.Thickness = 1
        stroke.Parent = tglFrame

        local label = Instance.new("TextLabel")
        label.Text = text
        label.Font = Enum.Font.GothamMedium
        label.TextColor3 = CurrentTheme.Text
        label.TextSize = 14
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = tglFrame

        -- O Switch (Botão)
        local switchBg = Instance.new("Frame")
        switchBg.BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(50, 50, 60)
        switchBg.Size = UDim2.new(0, 40, 0, 20)
        switchBg.Position = UDim2.new(1, -50, 0.5, -10)
        switchBg.Parent = tglFrame
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = switchBg
        
        local switchCircle = Instance.new("Frame")
        switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        switchCircle.Size = UDim2.new(0, 16, 0, 16)
        switchCircle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        switchCircle.Parent = switchBg
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = switchCircle

        local function UpdateToggle()
            state = not state
            if state then
                Tween(switchBg, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                Tween(switchCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
            else
                Tween(switchBg, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.2)
                Tween(switchCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
            end
            callback(state)
        end

        tglFrame.MouseButton1Click:Connect(UpdateToggle)
        
        -- Retornar objeto para controle externo
        return {
            Set = function(val)
                if val ~= state then UpdateToggle() end
            end
        }
    end

    function tab:CreateSlider(settings)
        local sldSettings = settings or {}
        local text = sldSettings.Name or "Slider"
        local min = sldSettings.Range[1] or 0
        local max = sldSettings.Range[2] or 100
        local value = sldSettings.Increment or 1
        local defValue = sldSettings.CurrentValue or min
        local suffix = sldSettings.Suffix or ""
        local callback = sldSettings.Callback or function() end

        local sldFrame = Instance.new("Frame")
        sldFrame.BackgroundColor3 = CurrentTheme.Secondary
        sldFrame.Size = UDim2.new(1, -10, 0, 55)
        sldFrame.Parent = page
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = sldFrame

        local label = Instance.new("TextLabel")
        label.Text = text
        label.Font = Enum.Font.GothamMedium
        label.TextColor3 = CurrentTheme.Text
        label.TextSize = 14
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 10)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sldFrame

        local valLabel = Instance.new("TextLabel")
        valLabel.Text = tostring(defValue) .. suffix
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextColor3 = CurrentTheme.TextDark
        valLabel.TextSize = 13
        valLabel.BackgroundTransparency = 1
        valLabel.Size = UDim2.new(1, -30, 0, 20)
        valLabel.Position = UDim2.new(0, 0, 0, 10)
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Parent = sldFrame

        -- Barra do Slider
        local sliderBarBg = Instance.new("Frame")
        sliderBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        sliderBarBg.Size = UDim2.new(1, -30, 0, 6)
        sliderBarBg.Position = UDim2.new(0, 15, 0, 35)
        sliderBarBg.Parent = sldFrame
        
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(1, 0)
        barCorner.Parent = sliderBarBg

        local sliderFill = Instance.new("Frame")
        sliderFill.BackgroundColor3 = CurrentTheme.Accent
        sliderFill.Size = UDim2.new((defValue - min) / (max - min), 0, 1, 0)
        sliderFill.Parent = sliderBarBg
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = sliderFill

        -- Lógica de Arrastar (Drag)
        local isDragging = false
        local sliderTrigger = Instance.new("TextButton") -- Botão invisível para capturar input em toda a barra
        sliderTrigger.BackgroundTransparency = 1
        sliderTrigger.Size = UDim2.new(1, 0, 1, 0)
        sliderTrigger.Parent = sliderBarBg
        sliderTrigger.Text = ""

        local function UpdateVal(input)
            local pos = UDim2.new(math.clamp((input.Position.X - sliderBarBg.AbsolutePosition.X) / sliderBarBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
            Tween(sliderFill, {Size = pos}, 0.05)
            
            local newVal = math.floor(((pos.X.Scale * (max - min)) + min) / value) * value
            valLabel.Text = tostring(newVal) .. suffix
            callback(newVal)
        end

        sliderTrigger.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = true
                UpdateVal(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                UpdateVal(input)
            end
        end)
    end
    
    function tab:CreateKeybind(settings)
        -- Implementação básica de keybind para o usuário
        local kbSettings = settings or {}
        local text = kbSettings.Name or "Keybind"
        local currentKey = kbSettings.Default or Enum.KeyCode.RightControl
        local callback = kbSettings.Callback or function() end
        local binding = false

        local kbFrame = Instance.new("Frame")
        kbFrame.BackgroundColor3 = CurrentTheme.Secondary
        kbFrame.Size = UDim2.new(1, -10, 0, 40)
        kbFrame.Parent = page
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = kbFrame
        
        local label = Instance.new("TextLabel")
        label.Text = text
        label.Font = Enum.Font.GothamMedium
        label.TextColor3 = CurrentTheme.Text
        label.TextSize = 14
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -100, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = kbFrame
        
        local bindBtn = Instance.new("TextButton")
        bindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        bindBtn.Size = UDim2.new(0, 80, 0, 25)
        bindBtn.Position = UDim2.new(1, -95, 0.5, -12.5)
        bindBtn.Text = currentKey.Name
        bindBtn.TextColor3 = CurrentTheme.TextDark
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextSize = 12
        bindBtn.Parent = kbFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = bindBtn
        
        bindBtn.MouseButton1Click:Connect(function()
            binding = true
            bindBtn.Text = "..."
            bindBtn.TextColor3 = CurrentTheme.Accent
        end)
        
        UserInputService.InputBegan:Connect(function(input)
            if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                binding = false
                currentKey = input.KeyCode
                bindBtn.Text = currentKey.Name
                bindBtn.TextColor3 = CurrentTheme.TextDark
                callback(currentKey)
            elseif not binding and input.KeyCode == currentKey then
                callback(currentKey)
            end
        end)
    end

    return tab
end

return AxiomX

