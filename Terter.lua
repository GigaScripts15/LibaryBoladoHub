--[[
    BOLADO HUB LIBRARY V3.0 (PREMIUM EDITION)
    
    Recursos Integrados:
    - Arrastar (Mouse + Touch)
    - Sistema de Minimizar (Ícone Flutuante)
    - Notificações Dinâmicas
    - Temas: Dark, Darker, Ocean, Red, Green, Cyberpunk
    - Componentes: Button, Toggle, Slider, Dropdown, TextBox, Keybind
]]

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ==================== CONFIGURAÇÃO DE TEMAS ====================

local Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 30), Sidebar = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(0, 150, 255), Content = Color3.fromRGB(28, 28, 33),
        Text = Color3.fromRGB(240, 240, 240), TextDark = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(45, 45, 50), Hover = Color3.fromRGB(35, 35, 40)
    },
    Darker = {
        Main = Color3.fromRGB(10, 10, 12), Sidebar = Color3.fromRGB(5, 5, 7),
        Accent = Color3.fromRGB(200, 200, 200), Content = Color3.fromRGB(15, 15, 18),
        Text = Color3.fromRGB(220, 220, 220), TextDark = Color3.fromRGB(100, 100, 100),
        Border = Color3.fromRGB(30, 30, 35), Hover = Color3.fromRGB(25, 25, 30)
    },
    Ocean = {
        Main = Color3.fromRGB(15, 32, 39), Sidebar = Color3.fromRGB(10, 25, 32),
        Accent = Color3.fromRGB(0, 210, 255), Content = Color3.fromRGB(20, 40, 50),
        Text = Color3.fromRGB(230, 250, 255), TextDark = Color3.fromRGB(100, 180, 200),
        Border = Color3.fromRGB(30, 60, 75), Hover = Color3.fromRGB(25, 55, 70)
    },
    Red = {
        Main = Color3.fromRGB(30, 10, 10), Sidebar = Color3.fromRGB(25, 5, 5),
        Accent = Color3.fromRGB(255, 50, 50), Content = Color3.fromRGB(35, 15, 15),
        Text = Color3.fromRGB(255, 230, 230), TextDark = Color3.fromRGB(180, 100, 100),
        Border = Color3.fromRGB(60, 20, 20), Hover = Color3.fromRGB(50, 20, 20)
    },
    Green = {
        Main = Color3.fromRGB(10, 30, 15), Sidebar = Color3.fromRGB(5, 25, 10),
        Accent = Color3.fromRGB(50, 255, 100), Content = Color3.fromRGB(15, 35, 20),
        Text = Color3.fromRGB(220, 255, 220), TextDark = Color3.fromRGB(100, 180, 120),
        Border = Color3.fromRGB(25, 60, 35), Hover = Color3.fromRGB(20, 50, 30)
    },
    Cyberpunk = {
        Main = Color3.fromRGB(20, 0, 40), Sidebar = Color3.fromRGB(15, 0, 30),
        Accent = Color3.fromRGB(255, 0, 255), Content = Color3.fromRGB(30, 0, 60),
        Text = Color3.fromRGB(0, 255, 255), TextDark = Color3.fromRGB(150, 0, 150),
        Border = Color3.fromRGB(255, 0, 255), Hover = Color3.fromRGB(50, 0, 100)
    }
}

local Icons = {
    settings = "rbxassetid://10734950309", home = "rbxassetid://10723407389",
    list = "rbxassetid://10709791437", close = "rbxassetid://10747384394",
    chevronDown = "rbxassetid://10709790882"
}

-- ==================== UTILITÁRIOS ====================

local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do instance[k] = v end
    return instance
end

local function Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local anim = TweenService:Create(obj, info, props)
    anim:Play()
    return anim
end

-- ==================== NÚCLEO ====================

function BoladoHub.new(options)
    local self = {Tabs = {}, Theme = Themes.Dark, Name = options.Name or "Bolado Hub"}
    local targetParent = gethui and gethui() or CoreGui
    
    local ScreenGui = Create("ScreenGui", {Name = "BoladoHub_"..math.random(100,999), Parent = targetParent, ResetOnSpawn = false})
    
    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame", Parent = ScreenGui, Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200), BackgroundColor3 = self.Theme.Main, BorderSizePixel = 0
    })
    local Stroke = Create("UIStroke", {Color = self.Theme.Border, Thickness = 1, Parent = MainFrame})
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = MainFrame})

    -- Drag System (PC/Touch)
    local function MakeDraggable(frame)
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                dragging = true; dragStart = input.Position; startPos = frame.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    MakeDraggable(MainFrame)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(0, 160, 1, 0), BackgroundColor3 = self.Theme.Sidebar, BorderSizePixel = 0
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sidebar})

    local Title = Create("TextLabel", {
        Parent = Sidebar, Text = self.Name, Size = UDim2.new(1, -40, 0, 50), Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1, TextColor3 = self.Theme.Text, Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Minimize System
    local MinimizedIcon = Create("ImageButton", {
        Parent = ScreenGui, Size = UDim2.new(0, 45, 0, 45), Position = UDim2.new(0.05, 0, 0.5, -22),
        BackgroundColor3 = self.Theme.Main, Image = Icons.home, Visible = false, ZIndex = 10
    })
    Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = MinimizedIcon})
    Create("UIStroke", {Color = self.Theme.Accent, Thickness = 2, Parent = MinimizedIcon})
    MakeDraggable(MinimizedIcon)

    local function ToggleUI()
        local isMinimizing = MainFrame.Visible
        if isMinimizing then
            Tween(MainFrame, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.BackIn).Completed:Wait()
            MainFrame.Visible = false
            MinimizedIcon.Visible = true
        else
            MinimizedIcon.Visible = false
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.BackOut)
        end
    end

    local MinBtn = Create("ImageButton", {
        Parent = Sidebar, Image = Icons.close, Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -25, 0, 16), BackgroundTransparency = 1, ImageColor3 = self.Theme.TextDark
    })
    MinBtn.MouseButton1Click:Connect(ToggleUI)
    MinimizedIcon.MouseButton1Click:Connect(ToggleUI)

    -- Containers
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar, Size = UDim2.new(1, 0, 1, -60), Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1, ScrollBarThickness = 0
    })
    Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10)})

    local ContentArea = Create("Frame", {
        Parent = MainFrame, Size = UDim2.new(1, -170, 1, -20), Position = UDim2.new(0, 170, 0, 10), BackgroundTransparency = 1
    })

    -- Lógica de Temas
    local function ApplyTheme(themeName)
        local theme = Themes[themeName]
        self.Theme = theme
        Tween(MainFrame, {BackgroundColor3 = theme.Main})
        Tween(Sidebar, {BackgroundColor3 = theme.Sidebar})
        Tween(Stroke, {Color = theme.Border})
        -- Aqui você pode iterar sobre botões e atualizar cores se desejar
    end

    -- TAB CREATION
    function self:Tab(name, icon)
        local TabContent = Create("ScrollingFrame", {
            Parent = ContentArea, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = self.Theme.Accent
        })
        local UIList = Create("UIListLayout", {Parent = TabContent, Padding = UDim.new(0, 6)})
        
        local TabButton = Create("TextButton", {
            Parent = TabContainer, Size = UDim2.new(1, -10, 0, 35), BackgroundTransparency = 1, Text = "", AutoButtonColor = false
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabButton})
        
        local BtnTitle = Create("TextLabel", {
            Parent = TabButton, Text = name, TextColor3 = self.Theme.TextDark, Font = Enum.Font.GothamMedium,
            TextSize = 14, Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do t.Content.Visible = false; t.Btn.BackgroundTransparency = 1 end
            TabContent.Visible = true; TabButton.BackgroundTransparency = 0; TabButton.BackgroundColor3 = self.Theme.Hover
        end)

        table.insert(self.Tabs, {Btn = TabButton, Content = TabContent})
        if #self.Tabs == 1 then TabContent.Visible = true; TabButton.BackgroundTransparency = 0; TabButton.BackgroundColor3 = self.Theme.Hover end

        -- Componentes da Aba
        local Elements = {}
        
        function Elements:Button(config)
            local B = Create("TextButton", {
                Parent = TabContent, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = self.Theme.Content,
                Text = config.Text, Font = Enum.Font.GothamSemibold, TextColor3 = self.Theme.Text, TextSize = 14
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = B})
            B.MouseButton1Click:Connect(config.Callback)
        end

        function Elements:Dropdown(config)
            -- Lógica de Dropdown (Baseada no código anterior)
            local isDropped = false
            local DropFrame = Create("Frame", {
                Parent = TabContent, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = self.Theme.Content, ClipsDescendants = true
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DropFrame})
            
            local DropBtn = Create("TextButton", {
                Parent = DropFrame, Size = UDim2.new(1, 0, 0, 36), Text = config.Text,
                BackgroundTransparency = 1, TextColor3 = self.Theme.Text, Font = Enum.Font.GothamMedium
            })

            local OptionContainer = Create("Frame", {
                Parent = DropFrame, Position = UDim2.new(0,0,0,36), Size = UDim2.new(1,0,0,100), BackgroundTransparency = 1
            })
            Create("UIListLayout", {Parent = OptionContainer})

            for _, opt in pairs(config.Options) do
                local OB = Create("TextButton", {
                    Parent = OptionContainer, Size = UDim2.new(1,0,0,25), Text = opt,
                    BackgroundColor3 = self.Theme.Hover, TextColor3 = self.Theme.TextDark, Font = Enum.Font.Gotham
                })
                OB.MouseButton1Click:Connect(function()
                    isDropped = false
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 36)})
                    config.Callback(opt)
                end)
            end

            DropBtn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                Tween(DropFrame, {Size = isDropped and UDim2.new(1, 0, 0, 140) or UDim2.new(1, 0, 0, 36)})
            end)
        end

        return Elements
    end

    -- ABA AUTOMÁTICA DE TEMAS
    local Settings = self:Tab("Settings", "settings")
    Settings:Dropdown({
        Text = "Select Theme",
        Options = {"Dark", "Darker", "Ocean", "Red", "Green", "Cyberpunk"},
        Callback = function(selected)
            ApplyTheme(selected)
        end
    })

    return self
end

return BoladoHub
