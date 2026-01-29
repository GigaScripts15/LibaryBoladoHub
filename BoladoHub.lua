--[[
    BoladoHub Library v4.0 (Remastered)
    Refatorado por: Gemini AI
    Original por: Bolado Hub Team
    
    Features:
    - Design Moderno (Dark Theme Otimizado)
    - Sistema de Ícones Lucide/RBX
    - Animações Suaves (TweenService)
    - Dropdowns, Sliders, Toggles, TextBoxes
    - Sistema de Notificação
]]

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== UTILITÁRIOS ==================== --

local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPos
    
    local function Update(input)
        local delta = input.Position - DragStart
        local targetPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15), {Position = targetPos}):Play()
    end
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- ==================== ÍCONES & TEMAS ==================== --

local Icons = {
    settings = "rbxassetid://10734950309", code = "rbxassetid://10709810463",
    home = "rbxassetid://10723407389", user = "rbxassetid://10747373176",
    list = "rbxassetid://10723424505", search = "rbxassetid://10734943674",
    bug = "rbxassetid://10709751939", check = "rbxassetid://10709790387",
    chevronUp = "rbxassetid://10709790948", chevronDown = "rbxassetid://10709790644"
}

local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Element = Color3.fromRGB(30, 30, 35),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(0, 120, 215), -- Azul Padrão
    Stroke = Color3.fromRGB(50, 50, 60),
    Red = Color3.fromRGB(235, 75, 75),
    Green = Color3.fromRGB(75, 235, 100)
}

-- ==================== CONSTRUTOR DA LIB ==================== --

function BoladoHub:NewWindow(options)
    options = options or {}
    local Title = options.Name or "BoladoHub v4"
    local AccentColor = options.Accent or Theme.Accent
    Theme.Accent = AccentColor
    
    local Library = {Tabs = {}}
    
    -- Proteção de GUI
    local ScreenGui = Create("ScreenGui", {
        Name = "BoladoHub_" .. math.random(1000,9999),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    if pcall(function() ScreenGui.Parent = CoreGui end) then
        -- Sucesso ao colocar no CoreGui
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Container Principal
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = MainFrame, Color = Theme.Stroke, Thickness = 1})
    
    -- Barra Lateral (Sidebar)
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 160, 1, 0),
        ZIndex = 2
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 8)})
    -- Fix corner radius visual glitch
    local SideCover = Create("Frame", {
        Parent = Sidebar, BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0),
        BorderSizePixel = 0, ZIndex = 2
    })
    
    -- Título
    local TitleLabel = Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 20),
        Size = UDim2.new(1, -30, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })
    
    -- Container de Abas
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 60),
        Size = UDim2.new(1, -20, 1, -70),
        ScrollBarThickness = 2,
        BorderSizePixel = 0,
        ZIndex = 3
    })
    Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Área de Conteúdo
    local ContentArea = Create("Frame", {
        Name = "ContentArea",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 10),
        Size = UDim2.new(1, -180, 1, -20)
    })
    
    MakeDraggable(Sidebar, MainFrame)
    
    -- Sistema de Notificação
    local NotifContainer = Create("Frame", {
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -220, 1, -20),
        Size = UDim2.new(0, 200, 1, 0),
        AnchorPoint = Vector2.new(0, 1)
    })
    local NotifList = Create("UIListLayout", {
        Parent = NotifContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
    
    function Library:Notify(title, text, duration)
        local card = Create("Frame", {
            Parent = NotifContainer,
            BackgroundColor3 = Theme.Element,
            Size = UDim2.new(1, 0, 0, 0), -- Starts small
            ClipsDescendants = true
        })
        Create("UICorner", {Parent = card, CornerRadius = UDim.new(0, 6)})
        Create("UIStroke", {Parent = card, Color = Theme.Stroke, Thickness = 1})
        
        local tLabel = Create("TextLabel", {
            Parent = card, BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.GothamBold, Text = title, TextColor3 = Theme.Accent,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left
        })
        
        Create("TextLabel", {
            Parent = card, BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 0, 35),
            Font = Enum.Font.Gotham, Text = text, TextColor3 = Theme.Text,
            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
        })
        
        -- Animação de Entrada
        TweenService:Create(card, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 65)}):Play()
        
        task.delay(duration or 3, function()
            local tween = TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function() card:Destroy() end)
        end)
    end
    
    -- ==================== SISTEMA DE TABS ==================== --
    
    local FirstTab = true
    
    function Library:Tab(name, iconId)
        local TabFunctions = {}
        
        -- Página de Conteúdo
        local TabPage = Create("ScrollingFrame", {
            Name = name.."_Page",
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.SubText,
            BorderSizePixel = 0,
            Visible = FirstTab,
            CanvasSize = UDim2.new(0, 0, 0, 0) -- Auto Size
        })
        local PageLayout = Create("UIListLayout", {
            Parent = TabPage,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
        Create("UIPadding", {Parent = TabPage, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
        
        -- Auto Canvas Size
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Botão da Tab
        local TabBtn = Create("TextButton", {
            Name = name.."_Btn",
            Parent = TabContainer,
            BackgroundColor3 = FirstTab and Theme.Accent or Color3.fromRGB(255,255,255),
            BackgroundTransparency = FirstTab and 0 or 1,
            Size = UDim2.new(1, 0, 0, 32),
            Font = Enum.Font.GothamMedium,
            Text = "      " .. name,
            TextColor3 = FirstTab and Color3.new(1,1,1) or Theme.SubText,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex = 4
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        
        -- Ícone da Tab
        if iconId and Icons[iconId] then
            Create("ImageLabel", {
                Parent = TabBtn, BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0.5, -8), Size = UDim2.new(0, 16, 0, 16),
                Image = Icons[iconId], ImageColor3 = TabBtn.TextColor3, ZIndex = 5
            })
        end

        -- Lógica de Seleção
        TabBtn.MouseButton1Click:Connect(function()
            -- Resetar todas as tabs
            for _, child in pairs(ContentArea:GetChildren()) do child.Visible = false end
            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Theme.SubText}):Play()
                    if btn:FindFirstChild("ImageLabel") then
                        TweenService:Create(btn.ImageLabel, TweenInfo.new(0.2), {ImageColor3 = Theme.SubText}):Play()
                    end
                end
            end
            
            -- Ativar atual
            TabPage.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
            if TabBtn:FindFirstChild("ImageLabel") then
                TweenService:Create(TabBtn.ImageLabel, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1,1,1)}):Play()
            end
        end)
        
        FirstTab = false
        
        -- ==================== COMPONENTES ==================== --
        
        function TabFunctions:Label(text)
            local LabelFunc = {}
            local Label = Create("TextLabel", {
                Parent = TabPage,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UIPadding", {Parent = Label, PaddingLeft = UDim.new(0, 5)})
            
            function LabelFunc:Set(newText)
                Label.Text = newText
            end
            return LabelFunc
        end

        function TabFunctions:Button(text, callback)
            callback = callback or function() end
            local BtnFrame = Create("TextButton", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                Font = Enum.Font.GothamMedium,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = BtnFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = BtnFrame, Color = Theme.Stroke, Thickness = 1})
            
            BtnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 32)}):Play()
                task.wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                pcall(callback)
            end)
            
            BtnFrame.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Stroke}):Play()
            end)
            BtnFrame.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play()
            end)
        end
        
        function TabFunctions:Toggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            local toggled = default
            
            local ToggleFrame = Create("TextButton", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = ToggleFrame, Color = Theme.Stroke, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Parent = ToggleFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.7, 0, 1, 0),
                Font = Enum.Font.GothamMedium, Text = text,
                TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = toggled and Theme.Accent or Color3.fromRGB(60,60,60),
                Position = UDim2.new(1, -45, 0.5, -10),
                Size = UDim2.new(0, 35, 0, 20)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            
            local Circle = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
            
            ToggleFrame.MouseButton1Click:Connect(function()
                toggled = not toggled
                local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetColor = toggled and Theme.Accent or Color3.fromRGB(60,60,60)
                
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                
                pcall(callback, toggled)
            end)
        end
        
        function TabFunctions:Slider(text, min, max, default, callback)
            local SliderFunc = {}
            local dragging = false
            local Value = default
            
            local SliderFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 45)
            })
            Create("UICorner", {Parent = SliderFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = SliderFrame, Color = Theme.Stroke, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Parent = SliderFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamMedium, Text = text,
                TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = SliderFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.Gotham, Text = tostring(default),
                TextColor3 = Theme.SubText, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local BarBG = Create("Frame", {
                Parent = SliderFrame, BackgroundColor3 = Color3.fromRGB(60,60,60),
                Position = UDim2.new(0, 10, 0, 30), Size = UDim2.new(1, -20, 0, 4)
            })
            Create("UICorner", {Parent = BarBG, CornerRadius = UDim.new(1, 0)})
            
            local BarFill = Create("Frame", {
                Parent = BarBG, BackgroundColor3 = Theme.Accent,
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", {Parent = BarFill, CornerRadius = UDim.new(1, 0)})
            
            local Trigger = Create("TextButton", {
                Parent = BarBG, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""
            })
            
            local function Update(input)
                local sizeX = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + ((max - min) * sizeX))
                
                TweenService:Create(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(newVal)
                pcall(callback, newVal)
            end
            
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    Update(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
        end
        
        function TabFunctions:Dropdown(text, list, callback)
            callback = callback or function() end
            local dropped = false
            
            local DropFrame = Create("Frame", {
                Parent = TabPage,
                BackgroundColor3 = Theme.Element,
                Size = UDim2.new(1, 0, 0, 36),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = DropFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = DropFrame, Color = Theme.Stroke, Thickness = 1})
            
            local Title = Create("TextLabel", {
                Parent = DropFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -40, 0, 36),
                Font = Enum.Font.GothamMedium, Text = text,
                TextColor3 = Theme.Text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = Create("ImageLabel", {
                Parent = DropFrame, BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 8), Size = UDim2.new(0, 20, 0, 20),
                Image = Icons.chevronDown, ImageColor3 = Theme.SubText
            })
            
            local Trigger = Create("TextButton", {
                Parent = DropFrame, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", ZIndex = 2
            })
            
            local ItemList = Create("ScrollingFrame", {
                Parent = DropFrame, BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40),
                ScrollBarThickness = 2, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0)
            })
            local ItemLayout = Create("UIListLayout", {Parent = ItemList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            Create("UIPadding", {Parent = ItemList, PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
            
            -- Popular Lista
            for _, item in pairs(list) do
                local ItemBtn = Create("TextButton", {
                    Parent = ItemList, BackgroundColor3 = Color3.fromRGB(40,40,45),
                    Size = UDim2.new(1, 0, 0, 25), Font = Enum.Font.Gotham,
                    Text = item, TextColor3 = Theme.SubText, TextSize = 12, AutoButtonColor = false
                })
                Create("UICorner", {Parent = ItemBtn, CornerRadius = UDim.new(0, 4)})
                
                ItemBtn.MouseButton1Click:Connect(function()
                    Title.Text = text .. " : " .. item
                    pcall(callback, item)
                    -- Fechar dropdown
                    dropped = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                end)
            end
            
            ItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                ItemList.CanvasSize = UDim2.new(0, 0, 0, ItemLayout.AbsoluteContentSize.Y)
            end)
            
            Trigger.MouseButton1Click:Connect(function()
                dropped = not dropped
                local targetSize = dropped and UDim2.new(1, 0, 0, math.min(150, 40 + ItemLayout.AbsoluteContentSize.Y)) or UDim2.new(1, 0, 0, 36)
                local targetRot = dropped and 180 or 0
                
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = targetRot}):Play()
            end)
        end

        return TabFunctions
    end
    
    return Library
end

return BoladoHub
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
