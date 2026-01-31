--[[
    BOLADO HUB LIBRARY V3.0 (PREMIUM EDITION)
    Otimizada, Moderna e Completa.
    
    Melhorias:
    - Sistema de Dropdowns, Keybinds e TextBox
    - Notificações (Toasts)
    - Animações fluídas em 60fps
    - Design Glassmorphism Dark
]]

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- ==================== UTILITÁRIOS E ASSETS ====================

local Icons = {
    settings = "rbxassetid://10734950309", code = "rbxassetid://10709810463",
    shield = "rbxassetid://10734951847", gamepad = "rbxassetid://10723395457",
    home = "rbxassetid://10723407389", sword = "rbxassetid://10734975486",
    user = "rbxassetid://10747373176", list = "rbxassetid://10709791437",
    search = "rbxassetid://10734943674", info = "rbxassetid://10723415903",
    warning = "rbxassetid://10709752996", check = "rbxassetid://10709790387",
    close = "rbxassetid://10747384394", chevronUp = "rbxassetid://10709790948",
    chevronDown = "rbxassetid://10709790882"
}

local Themes = {
    Default = {
        Main = Color3.fromRGB(25, 25, 30),
        Sidebar = Color3.fromRGB(20, 20, 25),
        Content = Color3.fromRGB(28, 28, 33),
        Accent = Color3.fromRGB(0, 150, 255), -- Azul Vibrante
        AccentGradient = Color3.fromRGB(0, 100, 200),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(45, 45, 50),
        Hover = Color3.fromRGB(35, 35, 40)
    }
}

-- Função auxiliar para criar objetos rapidamente
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

-- Função de Tween facilitada
local function Tween(obj, props, time, style, dir)
    time = time or 0.2
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(time, style, dir)
    local anim = TweenService:Create(obj, info, props)
    anim:Play()
    return anim
end

-- ==================== NÚCLEO DA LIBRARY ====================

function BoladoHub.new(options)
    local self = {}
    self.Options = options or {}
    self.Name = self.Options.Name or "Bolado Hub"
    self.Theme = Themes.Default
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Proteção contra detecção simples (Parenting no CoreGui se possível)
    local targetParent = gethui and gethui() or CoreGui
    
    -- ScreenGui Principal
    local ScreenGui = Create("ScreenGui", {
        Name = "BoladoHub_" .. math.random(1000,9999),
        Parent = targetParent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Container de Notificações
    local NotificationHolder = Create("Frame", {
        Name = "NotificationHolder",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -320, 1, -20),
        Size = UDim2.new(0, 300, 1, 0),
        AnchorPoint = Vector2.new(1, 1)
    })
    
    local NotifList = Create("UIListLayout", {
        Parent = NotificationHolder,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 10)
    })

    -- Main Frame (Janela)
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = self.Theme.Main,
        BorderSizePixel = 0,
        ClipsDescendants = false -- Importante para sombras
    })
    
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MainFrame })
    Create("UIStroke", { Color = self.Theme.Border, Thickness = 1, Parent = MainFrame })
    
    -- Sombra (Glow)
    local Shadow = Create("ImageLabel", {
        Parent = MainFrame,
        Image = "rbxassetid://5554236805",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ZIndex = -1
    })

    -- Barra Lateral (Sidebar)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        Size = UDim2.new(0, 160, 1, 0),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Sidebar })
    
    -- Correção visual para o canto direito da sidebar não ser arredondado
    local SidebarFix = Create("Frame", {
        Parent = Sidebar,
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -10, 0, 0),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0
    })

    -- Título e Logo
    local Title = Create("TextLabel", {
        Parent = Sidebar,
        Text = self.Name,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Container das Abas
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0
    })
    Create("UIListLayout", { Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
    Create("UIPadding", { Parent = TabContainer, PaddingLeft = UDim.new(0, 10) })

    -- Área de Conteúdo
    local ContentArea = Create("Frame", {
        Parent = MainFrame,
        Size = UDim2.new(1, -170, 1, -20),
        Position = UDim2.new(0, 170, 0, 10),
        BackgroundTransparency = 1
    })

    -- Dragging System (Arrastar Janela)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- ==================== FUNÇÃO DE NOTIFICAÇÃO ====================
    function self:Notification(config)
        local title = config.Title or "Notificação"
        local content = config.Content or "Texto aqui..."
        local duration = config.Duration or 3
        
        local NotifFrame = Create("Frame", {
            Parent = NotificationHolder,
            Size = UDim2.new(1, 0, 0, 0), -- Começa fechado
            BackgroundColor3 = self.Theme.Content,
            BorderSizePixel = 0,
            ClipsDescendants = true
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = NotifFrame })
        Create("UIStroke", { Color = self.Theme.Border, Thickness = 1, Parent = NotifFrame })
        
        local NTitle = Create("TextLabel", {
            Parent = NotifFrame, Text = title, Font = Enum.Font.GothamBold, TextSize = 14,
            TextColor3 = self.Theme.Accent, Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NContent = Create("TextLabel", {
            Parent = NotifFrame, Text = content, Font = Enum.Font.Gotham, TextSize = 13,
            TextColor3 = self.Theme.Text, Size = UDim2.new(1, -10, 0, 30), Position = UDim2.new(0, 10, 0, 25),
            BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })

        -- Barra de tempo
        local TimeBar = Create("Frame", {
            Parent = NotifFrame, BackgroundColor3 = self.Theme.Accent, Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0
        })

        -- Animação de Entrada
        Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 65)}, 0.3)
        Tween(TimeBar, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)

        task.delay(duration, function()
            local closeAnim = Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            closeAnim.Completed:Wait()
            NotifFrame:Destroy()
        end)
    end

    -- ==================== FUNÇÃO DE ABAS ====================
    function self:Tab(name, icon)
        local TabContent = Create("ScrollingFrame", {
            Name = name .. "_Content",
            Parent = ContentArea,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = self.Theme.Accent,
            Visible = false
        })
        
        local TabList = Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
        
        Create("UIPadding", {Parent = TabContent, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })

        -- Ajuste automático do Canvas
        TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
        end)

        -- Botão da Aba
        local TabButton = Create("TextButton", {
            Parent = TabContainer,
            Size = UDim2.new(1, -10, 0, 35),
            BackgroundColor3 = self.Theme.Sidebar, -- Transparente inicial
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabButton })

        local BtnTitle = Create("TextLabel", {
            Parent = TabButton,
            Text = name,
            TextColor3 = self.Theme.TextDark,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local BtnIcon = Create("ImageLabel", {
            Parent = TabButton,
            Image = Icons[icon] or Icons.list,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, -10),
            BackgroundTransparency = 1,
            ImageColor3 = self.Theme.TextDark
        })

        -- Lógica de Seleção de Aba
        TabButton.MouseButton1Click:Connect(function()
            -- Resetar todas as abas
            for _, t in pairs(self.Tabs) do
                Tween(t.Btn, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Title, {TextColor3 = self.Theme.TextDark}, 0.2)
                Tween(t.Icon, {ImageColor3 = self.Theme.TextDark}, 0.2)
                t.Content.Visible = false
            end
            
            -- Ativar a atual
            Tween(TabButton, {BackgroundTransparency = 0, BackgroundColor3 = self.Theme.Hover}, 0.2)
            Tween(BtnTitle, {TextColor3 = self.Theme.Text}, 0.2)
            Tween(BtnIcon, {ImageColor3 = self.Theme.Text}, 0.2)
            TabContent.Visible = true
        end)

        -- Registrar aba
        local tabData = {Btn = TabButton, Title = BtnTitle, Icon = BtnIcon, Content = TabContent}
        table.insert(self.Tabs, tabData)

        -- Selecionar se for a primeira
        if #self.Tabs == 1 then
            TabButton.BackgroundColor3 = self.Theme.Hover
            TabButton.BackgroundTransparency = 0
            BtnTitle.TextColor3 = self.Theme.Text
            BtnIcon.ImageColor3 = self.Theme.Text
            TabContent.Visible = true
        end
        
        -- Retornar objeto para adicionar elementos
        local TabFuncs = {}

        -- ==================== COMPONENTES ====================

        function TabFuncs:Section(text)
            local SectionTitle = Create("TextLabel", {
                Parent = TabContent,
                Text = text,
                Font = Enum.Font.GothamBold,
                TextColor3 = self.Theme.TextDark,
                TextSize = 12,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UIPadding", {Parent = SectionTitle, PaddingLeft = UDim.new(0, 5)})
        end

        function TabFuncs:Button(config)
            local text = config.Text or "Button"
            local callback = config.Callback or function() end
            
            local Btn = Create("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = self.Theme.Content,
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Btn})
            Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = Btn})
            
            local BtnText = Create("TextLabel", {
                Parent = Btn,
                Text = text,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1
            })

            -- Hover Effect
            Btn.MouseEnter:Connect(function() 
                Tween(Btn, {BackgroundColor3 = self.Theme.Hover}) 
                Tween(BtnText, {TextSize = 15})
            end)
            Btn.MouseLeave:Connect(function() 
                Tween(Btn, {BackgroundColor3 = self.Theme.Content}) 
                Tween(BtnText, {TextSize = 14})
            end)

            Btn.MouseButton1Click:Connect(function()
                -- Efeito de clique
                local originalSize = Btn.Size
                Tween(Btn, {Size = UDim2.new(1, -4, 0, 32)}, 0.05).Completed:Wait()
                Tween(Btn, {Size = originalSize}, 0.05)
                pcall(callback)
            end)
        end

        function TabFuncs:Toggle(config)
            local text = config.Text or "Toggle"
            local state = config.Default or false
            local callback = config.Callback or function() end

            local ToggleFrame = Create("TextButton", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = self.Theme.Content,
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ToggleFrame})
            Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = ToggleFrame})

            local ToggleText = Create("TextLabel", {
                Parent = ToggleFrame,
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBg = Create("Frame", {
                Parent = ToggleFrame,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = state and self.Theme.Accent or self.Theme.Border,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchBg})

            local SwitchCircle = Create("Frame", {
                Parent = SwitchBg,
                Size = UDim2.new(0, 16, 0, 16),
                Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = self.Theme.Text,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchCircle})

            local function UpdateToggle()
                state = not state
                local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetColor = state and self.Theme.Accent or self.Theme.Border
                
                Tween(SwitchCircle, {Position = targetPos}, 0.2)
                Tween(SwitchBg, {BackgroundColor3 = targetColor}, 0.2)
                pcall(callback, state)
            end

            ToggleFrame.MouseButton1Click:Connect(UpdateToggle)
            
            -- Retornar funções para controle externo
            return {
                Set = function(bool) 
                    if bool ~= state then UpdateToggle() end 
                end
            }
        end

        function TabFuncs:Slider(config)
            local text = config.Text or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end

            local SliderFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = self.Theme.Content,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SliderFrame})
            Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = SliderFrame})

            local SliderText = Create("TextLabel", {
                Parent = SliderFrame,
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local ValueText = Create("TextLabel", {
                Parent = SliderFrame,
                Text = tostring(default),
                Font = Enum.Font.GothamBold,
                TextColor3 = self.Theme.TextDark,
                TextSize = 14,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local SliderBar = Create("Frame", {
                Parent = SliderFrame,
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 0, 30),
                BackgroundColor3 = self.Theme.Border,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBar})

            local SliderFill = Create("Frame", {
                Parent = SliderBar,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = self.Theme.Accent,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})

            -- Lógica de arrastar
            local isDragging = false
            
            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                Tween(SliderFill, {Size = pos}, 0.1)
                
                local value = math.floor(min + ((max - min) * pos.X.Scale))
                ValueText.Text = tostring(value)
                pcall(callback, value)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    UpdateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
        end

        function TabFuncs:Dropdown(config)
            local text = config.Text or "Dropdown"
            local options = config.Options or {}
            local callback = config.Callback or function() end

            local isDropped = false
            local DropdownFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 36), -- Altura inicial
                BackgroundColor3 = self.Theme.Content,
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropdownFrame})
            local Stroke = Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = DropdownFrame})

            local DropBtn = Create("TextButton", {
                Parent = DropdownFrame,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 2
            })

            local DropText = Create("TextLabel", {
                Parent = DropdownFrame,
                Text = text .. "...",
                Font = Enum.Font.GothamMedium,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                Size = UDim2.new(1, -40, 0, 36),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local DropIcon = Create("ImageLabel", {
                Parent = DropdownFrame,
                Image = Icons.chevronDown,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0, 8),
                BackgroundTransparency = 1,
                ImageColor3 = self.Theme.TextDark
            })

            -- Lista de opções
            local OptionList = Create("ScrollingFrame", {
                Parent = DropdownFrame,
                Size = UDim2.new(1, -10, 0, 100),
                Position = UDim2.new(0, 5, 0, 40),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 2,
                CanvasSize = UDim2.new(0,0,0,0)
            })
            local UIList = Create("UIListLayout", {Parent = OptionList, Padding = UDim.new(0, 5)})
            
            -- Popular opções
            local function RefreshOptions()
                for _, child in pairs(OptionList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                
                for _, opt in ipairs(options) do
                    local OptBtn = Create("TextButton", {
                        Parent = OptionList,
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundColor3 = self.Theme.Hover,
                        Text = opt,
                        Font = Enum.Font.Gotham,
                        TextColor3 = self.Theme.TextDark,
                        TextSize = 13
                    })
                    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = OptBtn})
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        DropText.Text = text .. ": " .. opt
                        isDropped = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
                        Tween(DropIcon, {Rotation = 0}, 0.2)
                        pcall(callback, opt)
                    end)
                end
                OptionList.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
            end
            RefreshOptions()

            DropBtn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                local targetHeight = isDropped and 150 or 36
                Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
                Tween(DropIcon, {Rotation = isDropped and 180 or 0}, 0.2)
                Stroke.Color = isDropped and self.Theme.Accent or self.Theme.Border
            end)
            
            return {
                Refresh = function(newOptions)
                    options = newOptions
                    RefreshOptions()
                end
            }
        end

        function TabFuncs:TextBox(config)
            local text = config.Text or "TextBox"
            local placeholder = config.Placeholder or "Digite aqui..."
            local callback = config.Callback or function() end

            local BoxFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = self.Theme.Content,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = BoxFrame})
            local Stroke = Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = BoxFrame})

            local BoxLabel = Create("TextLabel", {
                Parent = BoxFrame, Text = text, Font = Enum.Font.GothamMedium,
                TextColor3 = self.Theme.Text, TextSize = 14, Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })

            local Input = Create("TextBox", {
                Parent = BoxFrame, PlaceholderText = placeholder, Text = "",
                Font = Enum.Font.Gotham, TextColor3 = self.Theme.Text, PlaceholderColor3 = self.Theme.TextDark,
                TextSize = 13, Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 25),
                BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false
            })

            Input.Focused:Connect(function() Stroke.Color = self.Theme.Accent end)
            Input.FocusLost:Connect(function()
                Stroke.Color = self.Theme.Border
                pcall(callback, Input.Text)
            end)
        end

        function TabFuncs:Keybind(config)
            local text = config.Text or "Keybind"
            local default = config.Default or Enum.KeyCode.RightControl
            local callback = config.Callback or function() end
            
            local currentKey = default
            local binding = false

            local KeyFrame = Create("Frame", {
                Parent = TabContent,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = self.Theme.Content,
                BorderSizePixel = 0
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeyFrame})
            Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = KeyFrame})

            local KeyLabel = Create("TextLabel", {
                Parent = KeyFrame, Text = text, Font = Enum.Font.GothamMedium,
                TextColor3 = self.Theme.Text, TextSize = 14, Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })

            local KeyBtn = Create("TextButton", {
                Parent = KeyFrame, Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(1, -90, 0.5, -12),
                BackgroundColor3 = self.Theme.Hover, Text = currentKey.Name, Font = Enum.Font.GothamBold,
                TextColor3 = self.Theme.TextDark, TextSize = 12, AutoButtonColor = false
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = KeyBtn})

            KeyBtn.MouseButton1Click:Connect(function()
                binding = true
                KeyBtn.Text = "..."
                KeyBtn.TextColor3 = self.Theme.Accent
            end)

            UserInputService.InputBegan:Connect(function(input)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    binding = false
                    KeyBtn.Text = currentKey.Name
                    KeyBtn.TextColor3 = self.Theme.TextDark
                    pcall(callback, currentKey)
                elseif input.KeyCode == currentKey and not binding then
                    pcall(callback, currentKey)
                end
            end)
        end

        return TabFuncs
    end

    return self
end

return BoladoHub
