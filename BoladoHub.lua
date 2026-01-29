-- BoladoHub Compact v1.0
-- Biblioteca minimalista e eficiente

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Ícones compactos (apenas essenciais)
local Icons = {
    home = "rbxassetid://10723407389",
    eye = "rbxassetid://10723346959",
    settings = "rbxassetid://10734950309",
    bolt = "rbxassetid://10709721749",
    user = "rbxassetid://10747373176",
    sword = "rbxassetid://10734975486",
    chevron = "rbxassetid://10734904599",
    x = "rbxassetid://10747383819",
    check = "rbxassetid://10709790387",
    sliders = "rbxassetid://10734963400"
}

local function GetIcon(name)
    return Icons[name] or Icons.bolt
end

-- Tema único (reduzido)
local Theme = {
    Background = Color3.fromRGB(28, 28, 38),
    Secondary = Color3.fromRGB(22, 22, 32),
    Accent = Color3.fromRGB(155, 89, 182),
    Text = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(170, 170, 180),
    Button = Color3.fromRGB(40, 40, 50),
    ToggleOn = Color3.fromRGB(46, 204, 113),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    Border = Color3.fromRGB(50, 50, 60)
}

-- Classe principal
BoladoHub.__index = BoladoHub

function BoladoHub.new(options)
    local self = setmetatable({}, BoladoHub)
    
    -- Configurações mínimas
    self.Config = {
        Name = options.Name or "BoladoHub",
        Size = options.Size or UDim2.new(0, 450, 0, 350), -- Tamanho reduzido
        Draggable = options.Draggable ~= false
    }
    
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Criar interface
    self:CreateUI()
    self:SetupHotkeys()
    
    return self
end

function BoladoHub:CreateUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BoladoHub_" .. self.Config.Name
    self.ScreenGui.Parent = game:GetService("CoreGui")
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Frame principal (compacto)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Config.Size.X.Offset/2, 0.5, -self.Config.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = self.MainFrame
    
    -- Borda sutil
    local border = Instance.new("UIStroke")
    border.Color = Theme.Border
    border.Thickness = 1
    border.Transparency = 0.6
    border.Parent = self.MainFrame
    
    -- Barra de título compacta
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 32) -- Altura reduzida
    self.TitleBar.BackgroundColor3 = Theme.Accent
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Corner apenas no topo
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10, 0, 0)
    titleCorner.Parent = self.TitleBar
    
    -- Título
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -70, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Config.Name
    self.TitleLabel.TextColor3 = Theme.Text
    self.TitleLabel.Font = Enum.Font.GothamSemibold
    self.TitleLabel.TextSize = 14 -- Fonte menor
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Botão fechar
    self.CloseBtn = Instance.new("ImageButton")
    self.CloseBtn.Name = "CloseBtn"
    self.CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    self.CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
    self.CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    self.CloseBtn.Image = GetIcon("x")
    self.CloseBtn.ImageColor3 = Theme.Text
    self.CloseBtn.Parent = self.TitleBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = self.CloseBtn
    
    -- Efeitos hover no botão
    self.CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(self.CloseBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2
        }):Play()
    end)
    
    self.CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(self.CloseBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0
        }):Play()
    end)
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Sistema de abas compacto
    self:CreateTabSystem()
    
    -- Sistema de arrasto
    if self.Config.Draggable then
        self:MakeDraggable()
    end
end

function BoladoHub:CreateTabSystem()
    -- Frame das abas (compacto)
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.Name = "TabsFrame"
    self.TabsFrame.Size = UDim2.new(0, 100, 1, -32) -- Largura reduzida
    self.TabsFrame.Position = UDim2.new(0, 0, 0, 32)
    self.TabsFrame.BackgroundColor3 = Theme.Secondary
    self.TabsFrame.BorderSizePixel = 0
    self.TabsFrame.Parent = self.MainFrame
    
    -- Frame de conteúdo
    self.ContentFrame = Instance.new("ScrollingFrame") -- Diretamente um ScrollingFrame
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -100, 1, -32)
    self.ContentFrame.Position = UDim2.new(0, 100, 0, 32)
    self.ContentFrame.BackgroundColor3 = Theme.Background
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = Theme.Accent
    self.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.ContentFrame.Parent = self.MainFrame
    
    -- Layout do conteúdo
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = self.ContentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = self.ContentFrame
end

function BoladoHub:AddTab(name, icon)
    -- Botão da aba (compacto)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, -10, 0, 35) -- Altura reduzida
    tabButton.Position = UDim2.new(0, 5, 0, #self.TabsFrame:GetChildren() * 40 + 5)
    tabButton.BackgroundColor3 = Theme.Button
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabsFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabButton
    
    -- Ícone (menor)
    if icon then
        local iconImage = Instance.new("ImageLabel")
        iconImage.Name = "Icon"
        iconImage.Size = UDim2.new(0, 18, 0, 18)
        iconImage.Position = UDim2.new(0.5, -9, 0.5, -9)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = GetIcon(icon)
        iconImage.ImageColor3 = Theme.TextSecondary
        iconImage.Parent = tabButton
    end
    
    -- Efeito hover
    tabButton.MouseEnter:Connect(function()
        TweenService:Create(tabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Accent
        }):Play()
        
        if icon then
            local iconImg = tabButton:FindFirstChild("Icon")
            if iconImg then
                TweenService:Create(iconImg, TweenInfo.new(0.2), {
                    ImageColor3 = Theme.Text
                }):Play()
            end
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= name then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Button
            }):Play()
            
            if icon then
                local iconImg = tabButton:FindFirstChild("Icon")
                if iconImg then
                    TweenService:Create(iconImg, TweenInfo.new(0.2), {
                        ImageColor3 = Theme.TextSecondary
                    }):Play()
                end
            end
        end
    end)
    
    -- Armazenar referência
    self.Tabs[name] = {
        Button = tabButton,
        Icon = icon
    }
    
    -- Selecionar primeira aba
    if not self.ActiveTab then
        self:SelectTab(name)
    end
    
    -- Conectar clique
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
end

function BoladoHub:SelectTab(name)
    if self.ActiveTab == name then return end
    
    -- Deselecionar aba atual
    if self.ActiveTab then
        local oldTab = self.Tabs[self.ActiveTab]
        if oldTab then
            TweenService:Create(oldTab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.Button
            }):Play()
            
            if oldTab.Icon then
                local icon = oldTab.Button:FindFirstChild("Icon")
                if icon then
                    TweenService:Create(icon, TweenInfo.new(0.2), {
                        ImageColor3 = Theme.TextSecondary
                    }):Play()
                end
            end
        end
    end
    
    -- Selecionar nova aba
    local newTab = self.Tabs[name]
    if newTab then
        TweenService:Create(newTab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Accent
        }):Play()
        
        if newTab.Icon then
            local icon = newTab.Button:FindFirstChild("Icon")
            if icon then
                TweenService:Create(icon, TweenInfo.new(0.2), {
                    ImageColor3 = Theme.Text
                }):Play()
            end
        end
        
        self.ActiveTab = name
    end
end

-- ==================== COMPONENTES COMPACTOS ====================

function BoladoHub:Button(options)
    local text = options.Text or "Button"
    local icon = options.Icon
    local callback = options.Callback or function() end
    
    -- Botão compacto
    local button = Instance.new("TextButton")
    button.Name = "Btn_" .. text
    button.Size = UDim2.new(1, 0, 0, 40) -- Altura reduzida
    button.BackgroundColor3 = Theme.Button
    button.AutoButtonColor = false
    button.Text = ""
    button.Parent = self.ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Ícone (opcional)
    if icon then
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 22, 0, 22)
        iconLabel.Position = UDim2.new(0, 10, 0.5, -11)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Image = GetIcon(icon)
        iconLabel.ImageColor3 = Theme.Text
        iconLabel.Parent = button
    end
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, icon and -40 or -20, 1, 0)
    textLabel.Position = UDim2.new(0, icon and 40 or 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Theme.Text
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 13 -- Fonte menor
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button
    
    -- Efeitos hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Accent
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Theme.Button
        }):Play()
    end)
    
    -- Clique
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -5, 0, 38)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, 0, 0, 40)
        }):Play()
        
        callback()
    end)
    
    return button
end

function BoladoHub:Toggle(options)
    local text = options.Text or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end
    
    -- Container compacto
    local toggle = Instance.new("Frame")
    toggle.Name = "Tgl_" .. text
    toggle.Size = UDim2.new(1, 0, 0, 35) -- Altura reduzida
    toggle.BackgroundTransparency = 1
    toggle.Parent = self.ContentFrame
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(0.7, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Theme.Text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = toggle
    
    -- Botão toggle
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Size = UDim2.new(0, 50, 0, 24) -- Tamanho reduzido
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBtn.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    toggleBtn.AutoButtonColor = false
    toggleBtn.Text = ""
    toggleBtn.Parent = toggle
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleBtn
    
    -- Indicador
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 18, 0, 18) -- Menor
    indicator.Position = default and UDim2.new(1, -19, 0.5, -9) or UDim2.new(0, 1, 0.5, -9)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.Parent = toggleBtn
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    -- Estado
    local state = default
    
    -- Função toggle
    local function toggleState()
        state = not state
        
        if state then
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.ToggleOn
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -19, 0.5, -9)
            }):Play()
        else
            TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Theme.ToggleOff
            }):Play()
            
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 1, 0.5, -9)
            }):Play()
        end
        
        callback(state)
    end
    
    -- Efeito hover
    toggleBtn.MouseEnter:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0
        }):Play()
    end)
    
    -- Clique
    toggleBtn.MouseButton1Click:Connect(toggleState)
    
    return {
        State = function() return state end,
        Set = function(newState)
            if state ~= newState then
                toggleState()
            end
        end
    }
end

function BoladoHub:Slider(options)
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local callback = options.Callback or function() end
    
    -- Container compacto
    local slider = Instance.new("Frame")
    slider.Name = "Sld_" .. text
    slider.Size = UDim2.new(1, 0, 0, 50) -- Altura reduzida
    slider.BackgroundTransparency = 1
    slider.Parent = self.ContentFrame
    
    -- Texto
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, 0, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text .. ": " .. default
    textLabel.TextColor3 = Theme.Text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = slider
    
    -- Barra compacta
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 4) -- Mais fina
    track.Position = UDim2.new(0, 0, 1, -15)
    track.BackgroundColor3 = Theme.Button
    track.BorderSizePixel = 0
    track.Parent = slider
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    -- Fill
    local fillSize = (default - min) / (max - min)
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(fillSize, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- Handle
    local handle = Instance.new("TextButton")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, 16, 0, 16) -- Menor
    handle.Position = UDim2.new(fillSize, -8, 0.5, -8)
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
        handle.Position = UDim2.new(normalized, -8, 0.5, -8)
        textLabel.Text = text .. ": " .. math.floor(value)
        
        callback(value)
    end
    
    -- Eventos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local trackAbsPos = track.AbsolutePosition
            local trackAbsSize = track.AbsoluteSize
            
            local relativeX = (mousePos.X - trackAbsPos.X) / trackAbsSize.X
            local newValue = min + (relativeX * (max - min))
            
            updateValue(newValue)
            dragging = true
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position
            local trackAbsPos = track.AbsolutePosition
            local trackAbsSize = track.AbsoluteSize
            
            local relativeX = (mousePos.X - trackAbsPos.X) / trackAbsSize.X
            local newValue = min + (relativeX * (max - min))
            
            updateValue(newValue)
        end
    end)
    
    return {
        Value = function() return value end,
        Set = function(newValue) updateValue(newValue) end
    }
end

-- ==================== FUNÇÕES AUXILIARES ====================

function BoladoHub:MakeDraggable()
    local dragging = false
    local dragStart, startPos
    
    local function update(input)
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
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputChanged:Connect(update)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function BoladoHub:SetupHotkeys()
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            self.ScreenGui.Enabled = not self.ScreenGui.Enabled
        elseif input.KeyCode == Enum.KeyCode.Delete then
            self:Destroy()
        end
    end)
end

function BoladoHub:Destroy()
    self.ScreenGui:Destroy()
end

-- Método simples para adicionar conteúdo
function BoladoHub:AddContent(text, icon, callback)
    return self:Button({
        Text = text,
        Icon = icon,
        Callback = callback
    })
end

return BoladoHub
