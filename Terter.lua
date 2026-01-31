--[[
    BOLADO HUB V4.0 - ULTIMATE UNIFIED
    Features: Key System, Auto-Save, Discord Integration, Theme System, Save Settings
    Melhorias: Performance otimizada, UI melhorada, Código modular, Mais funcionalidades
]]

local BoladoHub = {}
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- ==================== CONFIGURAÇÕES ====================
local DEFAULT_CONFIG = {
    HubName = "Bolado Hub",
    DefaultTheme = "Dark",
    KeySystemEnabled = true,
    DiscordURL = "",
    SaveSettings = true,
    NotificationsEnabled = true
}

-- ==================== GESTÃO DE ARQUIVOS ====================
local FolderName = "BoladoHub_Configs"
if not isfolder(FolderName) then makefolder(FolderName) end

local FileManager = {
    Save = function(file, data)
        local success, result = pcall(function()
            writefile(FolderName.."/"..file..".json", HttpService:JSONEncode(data))
        end)
        return success
    end,
    
    Load = function(file)
        local path = FolderName.."/"..file..".json"
        if isfile(path) then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            return success and data or nil
        end
        return nil
    end,
    
    Clear = function(file)
        if isfile(FolderName.."/"..file..".json") then
            delfile(FolderName.."/"..file..".json")
        end
    end
}

-- ==================== SISTEMA DE TEMAS ====================
local Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 30),
        Sidebar = Color3.fromRGB(20, 20, 25),
        Accent = Color3.fromRGB(0, 150, 255),
        Content = Color3.fromRGB(28, 28, 33),
        Text = Color3.fromRGB(240, 240, 240),
        Border = Color3.fromRGB(45, 45, 50),
        ButtonHover = Color3.fromRGB(40, 40, 45),
        Success = Color3.fromRGB(0, 200, 100),
        Error = Color3.fromRGB(255, 60, 60),
        Warning = Color3.fromRGB(255, 180, 0)
    },
    Darker = {
        Main = Color3.fromRGB(10, 10, 12),
        Sidebar = Color3.fromRGB(5, 5, 7),
        Accent = Color3.fromRGB(200, 200, 200),
        Content = Color3.fromRGB(15, 15, 18),
        Text = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(30, 30, 35),
        ButtonHover = Color3.fromRGB(25, 25, 28),
        Success = Color3.fromRGB(0, 180, 80),
        Error = Color3.fromRGB(220, 50, 50),
        Warning = Color3.fromRGB(235, 160, 0)
    },
    Ocean = {
        Main = Color3.fromRGB(15, 32, 39),
        Sidebar = Color3.fromRGB(10, 25, 32),
        Accent = Color3.fromRGB(0, 210, 255),
        Content = Color3.fromRGB(20, 40, 50),
        Text = Color3.fromRGB(230, 250, 255),
        Border = Color3.fromRGB(30, 60, 75),
        ButtonHover = Color3.fromRGB(25, 50, 62),
        Success = Color3.fromRGB(0, 220, 150),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 200, 50)
    },
    Red = {
        Main = Color3.fromRGB(30, 10, 10),
        Sidebar = Color3.fromRGB(25, 5, 5),
        Accent = Color3.fromRGB(255, 50, 50),
        Content = Color3.fromRGB(35, 15, 15),
        Text = Color3.fromRGB(255, 230, 230),
        Border = Color3.fromRGB(60, 20, 20),
        ButtonHover = Color3.fromRGB(45, 20, 20),
        Success = Color3.fromRGB(100, 255, 100),
        Error = Color3.fromRGB(255, 80, 80),
        Warning = Color3.fromRGB(255, 150, 50)
    },
    Green = {
        Main = Color3.fromRGB(10, 30, 15),
        Sidebar = Color3.fromRGB(5, 25, 10),
        Accent = Color3.fromRGB(50, 255, 100),
        Content = Color3.fromRGB(15, 35, 20),
        Text = Color3.fromRGB(220, 255, 220),
        Border = Color3.fromRGB(25, 60, 35),
        ButtonHover = Color3.fromRGB(20, 45, 25),
        Success = Color3.fromRGB(0, 230, 100),
        Error = Color3.fromRGB(255, 70, 70),
        Warning = Color3.fromRGB(255, 170, 0)
    },
    Cyberpunk = {
        Main = Color3.fromRGB(20, 0, 40),
        Sidebar = Color3.fromRGB(15, 0, 30),
        Accent = Color3.fromRGB(255, 0, 255),
        Content = Color3.fromRGB(30, 0, 60),
        Text = Color3.fromRGB(0, 255, 255),
        Border = Color3.fromRGB(255, 0, 255),
        ButtonHover = Color3.fromRGB(40, 0, 80),
        Success = Color3.fromRGB(0, 255, 200),
        Error = Color3.fromRGB(255, 50, 150),
        Warning = Color3.fromRGB(255, 255, 0)
    },
    Purple = {
        Main = Color3.fromRGB(35, 15, 55),
        Sidebar = Color3.fromRGB(25, 10, 40),
        Accent = Color3.fromRGB(180, 80, 255),
        Content = Color3.fromRGB(40, 20, 65),
        Text = Color3.fromRGB(240, 220, 255),
        Border = Color3.fromRGB(80, 40, 120),
        ButtonHover = Color3.fromRGB(50, 25, 80),
        Success = Color3.fromRGB(120, 255, 180),
        Error = Color3.fromRGB(255, 90, 90),
        Warning = Color3.fromRGB(255, 200, 50)
    }
}

-- ==================== UTILITÁRIOS ====================
local UIUtils = {}

function UIUtils.Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

function UIUtils.MakeDraggable(frame, dragHandle)
    dragHandle = dragHandle or frame
    local dragging = false
    local dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function UIUtils.CreateButtonEffect(button, theme)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        if theme and theme.ButtonHover then
            button.BackgroundColor3 = theme.ButtonHover
        else
            button.BackgroundColor3 = originalColor:lerp(Color3.new(1, 1, 1), 0.1)
        end
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
    
    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = originalColor:lerp(Color3.new(0, 0, 0), 0.2)
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
end

function UIUtils.Notify(title, message, color, duration)
    duration = duration or 3
    local ScreenGui = UIUtils.Create("ScreenGui", {
        Parent = CoreGui,
        ResetOnSpawn = false
    })
    
    local Notification = UIUtils.Create("Frame", {
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -320, 1, -100),
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        Parent = ScreenGui
    })
    
    UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notification})
    UIUtils.Create("UIStroke", {Color = Color3.fromRGB(60, 60, 70), Parent = Notification})
    
    local Title = UIUtils.Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 10),
        Text = title,
        TextColor3 = color or Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        BackgroundTransparency = 1,
        Parent = Notification
    })
    
    local Message = UIUtils.Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, -45),
        Position = UDim2.new(0, 10, 0, 35),
        Text = message,
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextWrapped = true,
        BackgroundTransparency = 1,
        Parent = Notification
    })
    
    -- Animar entrada
    Notification.Position = UDim2.new(1, 320, 1, -100)
    TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 1, -100)}):Play()
    
    -- Animar saída
    task.delay(duration, function()
        TweenService:Create(Notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 320, 1, -100)}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
end

-- ==================== SISTEMA DE KEY ====================
function BoladoHub:VerifyKey(config, callback)
    local Key = config.Key
    local saved = FileManager.Load("KeyData")
    
    if saved and saved.Key == Key then
        if callback then callback() end
        return true
    end

    -- Criar interface de key
    local ScreenGui = UIUtils.Create("ScreenGui", {
        Parent = CoreGui,
        ResetOnSpawn = false,
        Name = "KeySystem"
    })

    local BlurBackground = UIUtils.Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
        Parent = ScreenGui
    })

    local Main = UIUtils.Create("Frame", {
        Size = UDim2.new(0, 400, 0, 250),
        Position = UDim2.new(0.5, -200, 0.5, -125),
        BackgroundColor3 = Color3.fromRGB(20, 20, 25),
        Parent = ScreenGui
    })

    UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    UIUtils.Create("UIStroke", {
        Color = Color3.fromRGB(0, 150, 255),
        Thickness = 2,
        Parent = Main
    })

    UIUtils.MakeDraggable(Main)

    -- Título
    local Title = UIUtils.Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Text = config.HubName or "🔐 KEY SYSTEM",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        BackgroundTransparency = 1,
        Parent = Main
    })

    -- Input
    local InputContainer = UIUtils.Create("Frame", {
        Size = UDim2.new(0, 320, 0, 45),
        Position = UDim2.new(0.5, -160, 0.4, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Parent = Main
    })

    UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = InputContainer})
    UIUtils.Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 70),
        Parent = InputContainer
    })

    local Input = UIUtils.Create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        PlaceholderText = "Enter your key here...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        Text = "",
        ClearTextOnFocus = false,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        BackgroundTransparency = 1,
        Parent = InputContainer
    })

    -- Botões
    local ButtonContainer = UIUtils.Create("Frame", {
        Size = UDim2.new(1, -40, 0, 45),
        Position = UDim2.new(0, 20, 0.75, 0),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local VerifyButton = UIUtils.Create("TextButton", {
        Size = UDim2.new(0, 140, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "✅ VERIFY",
        BackgroundColor3 = Color3.fromRGB(0, 150, 255),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = ButtonContainer
    })

    UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = VerifyButton})
    UIUtils.CreateButtonEffect(VerifyButton)

    local CloseButton = UIUtils.Create("TextButton", {
        Size = UDim2.new(0, 140, 1, 0),
        Position = UDim2.new(1, -140, 0, 0),
        Text = "❌ CLOSE",
        BackgroundColor3 = Color3.fromRGB(50, 50, 55),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = ButtonContainer
    })

    UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = CloseButton})
    UIUtils.CreateButtonEffect(CloseButton)

    -- Função de verificação
    local function verifyKey()
        local inputKey = Input.Text:gsub("%s+", "")
        
        if inputKey == Key then
            FileManager.Save("KeyData", {Key = Key, Timestamp = os.time()})
            
            -- Animar sucesso
            TweenService:Create(VerifyButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            }):Play()
            
            VerifyButton.Text = "✓ SUCCESS"
            
            task.wait(0.5)
            ScreenGui:Destroy()
            if callback then callback() end
        else
            -- Animar erro
            TweenService:Create(InputContainer, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(60, 20, 20)
            }):Play()
            
            TweenService:Create(InputContainer.UIStroke, TweenInfo.new(0.1), {
                Color = Color3.fromRGB(255, 60, 60)
            }):Play()
            
            Input.Text = ""
            Input.PlaceholderText = "Invalid Key!"
            Input.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
            
            task.wait(0.1)
            TweenService:Create(InputContainer, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            }):Play()
            
            TweenService:Create(InputContainer.UIStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(60, 60, 70)
            }):Play()
        end
    end

    -- Conexões
    VerifyButton.MouseButton1Click:Connect(verifyKey)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    Input.Focused:Connect(function()
        TweenService:Create(InputContainer.UIStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(0, 150, 255)
        }):Play()
    end)
    
    Input.FocusLost:Connect(function()
        TweenService:Create(InputContainer.UIStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(60, 60, 70)
        }):Play()
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Return then
            verifyKey()
        end
    end)

    return false
end

-- ==================== LIBRARY CORE ====================
function BoladoHub.new(options)
    options = options or {}
    for k, v in pairs(DEFAULT_CONFIG) do
        if options[k] == nil then
            options[k] = v
        end
    end

    local self = {
        Tabs = {},
        Options = options,
        Theme = {},
        Elements = {},
        Connections = {}
    }

    -- Carregar configurações
    local savedSettings = FileManager.Load("Settings") or {}
    local currentThemeName = savedSettings.Theme or options.DefaultTheme
    self.Theme = Themes[currentThemeName] or Themes.Dark

    -- Criar interface principal
    local ScreenGui = UIUtils.Create("ScreenGui", {
        Parent = CoreGui,
        ResetOnSpawn = false,
        DisplayOrder = 999,
        Name = options.HubName or "BoladoHub"
    })

    local MainFrame = UIUtils.Create("Frame", {
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = self.Theme.Main,
        Parent = ScreenGui,
        Active = true
    })

    UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = MainFrame})
    UIUtils.Create("UIStroke", {
        Color = self.Theme.Border,
        Thickness = 2,
        Parent = MainFrame
    })

    -- Cabeçalho
    local Header = UIUtils.Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    local Title = UIUtils.Create("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Text = options.HubName or "BOLADO HUB",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        BackgroundTransparency = 1,
        Parent = Header
    })

    local CloseButton = UIUtils.Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        Text = "×",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        BackgroundTransparency = 1,
        Parent = Header
    })

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        for _, conn in pairs(self.Connections) do
            conn:Disconnect()
        end
    end)

    UIUtils.MakeDraggable(MainFrame, Header)

    -- Sidebar
    local Sidebar = UIUtils.Create("Frame", {
        Size = UDim2.new(0, 160, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = self.Theme.Sidebar,
        Parent = MainFrame
    })

    UIUtils.Create("UICorner", {
        CornerRadius = UDim.new(0, 0, 0, 12),
        Parent = Sidebar
    })

    local TabContainer = UIUtils.Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Border,
        Parent = Sidebar
    })

    local TabListLayout = UIUtils.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabContainer
    })

    -- Área de conteúdo
    local ContentArea = UIUtils.Create("Frame", {
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 170, 0, 50),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })

    -- Sistema de Tabs
    function self:Tab(name, icon)
        local ContentFrame = UIUtils.Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = self.Theme.Border,
            Parent = ContentArea
        })

        local ContentList = UIUtils.Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ContentFrame
        })

        local ContentPadding = UIUtils.Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = ContentFrame
        })

        -- Botão da tab
        local TabButton = UIUtils.Create("TextButton", {
            Size = UDim2.new(0.9, 0, 0, 40),
            Text = (icon or "›") .. "  " .. name,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = self.Theme.Content,
            BackgroundTransparency = 0.8,
            Parent = TabContainer,
            LayoutOrder = #self.Tabs + 1
        })

        UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabButton})
        UIUtils.CreateButtonEffect(TabButton, self.Theme)

        -- Selecionar tab
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                tab.Button.BackgroundTransparency = 0.8
            end
            
            ContentFrame.Visible = true
            TabButton.BackgroundTransparency = 0.5
        end)

        local tabObj = {
            Name = name,
            Content = ContentFrame,
            Button = TabButton,
            Elements = {}
        }

        table.insert(self.Tabs, tabObj)

        -- Selecionar primeira tab
        if #self.Tabs == 1 then
            ContentFrame.Visible = true
            TabButton.BackgroundTransparency = 0.5
        end

        -- Elementos da tab
        local elements = {}

        function elements:Button(config)
            local button = UIUtils.Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                Text = config.Text,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 16,
                BackgroundColor3 = self.Theme.Content,
                Parent = ContentFrame
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = button})
            UIUtils.Create("UIStroke", {
                Color = self.Theme.Border,
                Parent = button
            })
            UIUtils.CreateButtonEffect(button, self.Theme)

            if config.Callback then
                button.MouseButton1Click:Connect(function()
                    local success, err = pcall(config.Callback)
                    if not success then
                        warn("Button Error: " .. err)
                        if options.NotificationsEnabled then
                            UIUtils.Notify("Error", "Failed to execute: " .. err, self.Theme.Error)
                        end
                    end
                end)
            end

            table.insert(tabObj.Elements, button)
            return button
        end

        function elements:Toggle(config)
            config.Default = config.Default or false
            local state = config.Default
            
            local toggleFrame = UIUtils.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = self.Theme.Content,
                Parent = ContentFrame
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = toggleFrame})
            UIUtils.Create("UIStroke", {
                Color = self.Theme.Border,
                Parent = toggleFrame
            })

            local label = UIUtils.Create("TextLabel", {
                Size = UDim2.new(0.7, 0, 1, 0),
                Text = config.Text,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = toggleFrame
            })

            local padding = UIUtils.Create("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                Parent = label
            })

            local toggleButton = UIUtils.Create("TextButton", {
                Size = UDim2.new(0, 60, 0, 30),
                Position = UDim2.new(1, -70, 0.5, -15),
                Text = state and "ON" : "OFF",
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                BackgroundColor3 = state and self.Theme.Success or Color3.fromRGB(80, 80, 80),
                Parent = toggleFrame
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 15), Parent = toggleButton})
            UIUtils.CreateButtonEffect(toggleButton, self.Theme)

            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                toggleButton.Text = state and "ON" or "OFF"
                toggleButton.BackgroundColor3 = state and self.Theme.Success or Color3.fromRGB(80, 80, 80)
                
                if config.Callback then
                    local success, err = pcall(function()
                        config.Callback(state)
                    end)
                    
                    if not success then
                        warn("Toggle Error: " .. err)
                        if options.NotificationsEnabled then
                            UIUtils.Notify("Error", "Toggle failed: " .. err, self.Theme.Error)
                        end
                    end
                end
                
                -- Salvar estado se configurado
                if config.Flag and options.SaveSettings then
                    savedSettings[config.Flag] = state
                    FileManager.Save("Settings", savedSettings)
                end
            end)

            table.insert(tabObj.Elements, toggleFrame)
            return {Frame = toggleFrame, Set = function(value) 
                state = value
                toggleButton.Text = state and "ON" or "OFF"
                toggleButton.BackgroundColor3 = state and self.Theme.Success or Color3.fromRGB(80, 80, 80)
            end}
        end

        function elements:Dropdown(config)
            local isOpen = false
            local selected = config.Default or config.Options[1]
            
            local dropdownFrame = UIUtils.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = self.Theme.Content,
                Parent = ContentFrame,
                ClipsDescendants = true
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = dropdownFrame})
            UIUtils.Create("UIStroke", {
                Color = self.Theme.Border,
                Parent = dropdownFrame
            })

            local header = UIUtils.Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                Text = config.Text .. ": " .. selected,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 16,
                BackgroundTransparency = 1,
                Parent = dropdownFrame
            })

            local arrow = UIUtils.Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                Text = "▼",
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                BackgroundTransparency = 1,
                Parent = dropdownFrame
            })

            local optionsFrame = UIUtils.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 40),
                BackgroundColor3 = self.Theme.Sidebar,
                Parent = dropdownFrame
            })

            UIUtils.Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = optionsFrame
            })

            -- Criar opções
            for _, option in ipairs(config.Options) do
                local optionButton = UIUtils.Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    Text = option,
                    TextColor3 = self.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    BackgroundColor3 = self.Theme.Sidebar,
                    BackgroundTransparency = 1,
                    Parent = optionsFrame
                })

                UIUtils.CreateButtonEffect(optionButton, self.Theme)

                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    header.Text = config.Text .. ": " .. selected
                    
                    if config.Callback then
                        local success, err = pcall(function()
                            config.Callback(selected)
                        end)
                        
                        if not success then
                            warn("Dropdown Error: " .. err)
                            if options.NotificationsEnabled then
                                UIUtils.Notify("Error", "Dropdown failed: " .. err, self.Theme.Error)
                            end
                        end
                    end
                    
                    -- Fechar dropdown
                    isOpen = false
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, 40)
                    }):Play()
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                end)
            end

            header.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetSize = isOpen and UDim2.new(1, 0, 0, 40 + #config.Options * 30) or UDim2.new(1, 0, 0, 40)
                local targetRotation = isOpen and 180 or 0
                
                TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
                    Size = targetSize
                }):Play()
                
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = targetRotation
                }):Play()
            end)

            table.insert(tabObj.Elements, dropdownFrame)
            return {Frame = dropdownFrame, Value = selected}
        end

        function elements:Label(config)
            local label = UIUtils.Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                Text = config.Text,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 16,
                TextWrapped = true,
                BackgroundTransparency = 1,
                Parent = ContentFrame
            })
            
            table.insert(tabObj.Elements, label)
            return label
        end

        function elements:Slider(config)
            config.Min = config.Min or 0
            config.Max = config.Max or 100
            config.Default = config.Default or config.Min
            config.Precise = config.Precise or false
            
            local value = config.Default
            
            local sliderFrame = UIUtils.Create("Frame", {
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = self.Theme.Content,
                Parent = ContentFrame
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sliderFrame})
            UIUtils.Create("UIStroke", {
                Color = self.Theme.Border,
                Parent = sliderFrame
            })

            local label = UIUtils.Create("TextLabel", {
                Size = UDim2.new(1, -20, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                Text = config.Text .. ": " .. value,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sliderFrame
            })

            local track = UIUtils.Create("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 1, -25),
                BackgroundColor3 = self.Theme.Border,
                Parent = sliderFrame
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = track})

            local fill = UIUtils.Create("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = self.Theme.Accent,
                Parent = track
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})

            local thumb = UIUtils.Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, -8, 0.5, -8),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Parent = track
            })

            UIUtils.Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = thumb})

            -- Calcular posição inicial
            local percentage = (value - config.Min) / (config.Max - config.Min)
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            thumb.Position = UDim2.new(percentage, -8, 0.5, -8)

            local dragging = false
            
            local function updateSlider(input)
                local relativeX = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                
                value = config.Precise and 
                    math.floor((config.Min + (config.Max - config.Min) * relativeX) * 100) / 100 or
                    math.floor(config.Min + (config.Max - config.Min) * relativeX)
                
                label.Text = config.Text .. ": " .. value
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                thumb.Position = UDim2.new(relativeX, -8, 0.5, -8)
                
                if config.Callback then
                    local success, err = pcall(function()
                        config.Callback(value)
                    end)
                    
                    if not success then
                        warn("Slider Error: " .. err)
                        if options.NotificationsEnabled then
                            UIUtils.Notify("Error", "Slider failed: " .. err, self.Theme.Error)
                        end
                    end
                end
                
                -- Salvar se configurado
                if config.Flag and options.SaveSettings then
                    savedSettings[config.Flag] = value
                    FileManager.Save("Settings", savedSettings)
                end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)

            track.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            table.insert(tabObj.Elements, sliderFrame)
            return {Frame = sliderFrame, Value = value}
        end

        return elements
    end

    -- Função para atualizar tema
    function self:UpdateTheme(themeName)
        local newTheme = Themes[themeName] or Themes.Dark
        self.Theme = newTheme
        
        -- Atualizar cores principais
        MainFrame.BackgroundColor3 = newTheme.Main
        MainFrame.UIStroke.Color = newTheme.Border
        Sidebar.BackgroundColor3 = newTheme.Sidebar
        Title.TextColor3 = newTheme.Text
        TabContainer.ScrollBarImageColor3 = newTheme.Border
        ContentArea.ScrollBarImageColor3 = newTheme.Border
        
        -- Atualizar todas as tabs e elementos
        for _, tab in pairs(self.Tabs) do
            tab.Button.BackgroundColor3 = newTheme.Content
            tab.Button.TextColor3 = newTheme.Text
            
            for _, element in pairs(tab.Elements) do
                if element:IsA("Frame") then
                    if element.Name == "SliderFrame" or element:FindFirstChild("Track") then
                        -- É um slider
                        element.BackgroundColor3 = newTheme.Content
                        element.UIStroke.Color = newTheme.Border
                        
                        local label = element:FindFirstChildWhichIsA("TextLabel")
                        if label then label.TextColor3 = newTheme.Text end
                        
                        local track = element:FindFirstChild("Track")
                        if track then track.BackgroundColor3 = newTheme.Border end
                        
                        local fill = track and track:FindFirstChild("Fill")
                        if fill then fill.BackgroundColor3 = newTheme.Accent end
                    elseif element:FindFirstChild("Header") and element:FindFirstChild("OptionsFrame") then
                        -- É um dropdown
                        element.BackgroundColor3 = newTheme.Content
                        element.UIStroke.Color = newTheme.Border
                        
                        local header = element:FindFirstChild("Header")
                        if header then header.TextColor3 = newTheme.Text end
                        
                        local optionsFrame = element:FindFirstChild("OptionsFrame")
                        if optionsFrame then optionsFrame.BackgroundColor3 = newTheme.Sidebar end
                    else
                        -- Outros frames (toggle, button, etc)
                        element.BackgroundColor3 = newTheme.Content
                        if element:FindFirstChild("UIStroke") then
                            element.UIStroke.Color = newTheme.Border
                        end
                        
                        local textLabels = element:GetDescendants()
                        for _, desc in pairs(textLabels) do
                            if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                                desc.TextColor3 = newTheme.Text
                            end
                        end
                    end
                elseif element:IsA("TextButton") then
                    element.BackgroundColor3 = newTheme.Content
                    element.TextColor3 = newTheme.Text
                    if element:FindFirstChild("UIStroke") then
                        element.UIStroke.Color = newTheme.Border
                    end
                elseif element:IsA("TextLabel") then
                    element.TextColor3 = newTheme.Text
                end
            end
        end
        
        -- Salvar tema
        if options.SaveSettings then
            savedSettings.Theme = themeName
            FileManager.Save("Settings", savedSettings)
        end
        
        if options.NotificationsEnabled then
            UIUtils.Notify("Theme Changed", "Applied " .. themeName .. " theme!", newTheme.Accent)
        end
    end

    -- Criar tab de configurações automática
    if options.DiscordURL or options.SaveSettings then
        local settingsTab = self:Tab("⚙️ Settings")
        
        if options.SaveSettings then
            settingsTab:Dropdown({
                Text = "Theme",
                Options = {"Dark", "Darker", "Ocean", "Red", "Green", "Cyberpunk", "Purple"},
                Default = currentThemeName,
                Callback = function(selected)
                    self:UpdateTheme(selected)
                end
            })
            
            settingsTab:Button({
                Text = "Reset Settings",
                Callback = function()
                    FileManager.Clear("Settings")
                    if options.NotificationsEnabled then
                        UIUtils.Notify("Settings Reset", "Please reload the script", self.Theme.Warning)
                    end
                end
            })
        end
        
        if options.DiscordURL then
            settingsTab:Button({
                Text = "Copy Discord",
                Callback = function()
                    setclipboard(options.DiscordURL)
                    if options.NotificationsEnabled then
                        UIUtils.Notify("Discord", "Link copied to clipboard!", self.Theme.Accent)
                    end
                end
            })
        end
        
        settingsTab:Label({Text = "Bolado Hub v4.0"})
    end

    -- Função para destruir a interface
    function self:Destroy()
        ScreenGui:Destroy()
        for _, conn in pairs(self.Connections) do
            conn:Disconnect()
        end
        self.Tabs = {}
    end

    -- Função para mostrar/ocultar
    function self:Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end

    -- Tecla de atalho para mostrar/ocultar (RightShift por padrão)
    local toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            self:Toggle()
        end
    end)

    table.insert(self.Connections, toggleConnection)

    -- Configuração inicial da UI
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)

    local resizeConnection = TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
    end)

    table.insert(self.Connections, resizeConnection)

    return self
end

-- ==================== FUNÇÃO DE INICIALIZAÇÃO RÁPIDA ====================
function BoladoHub:QuickStart(options, keyConfig)
    if keyConfig and keyConfig.Key then
        self:VerifyKey(keyConfig, function()
            self.new(options)
            if options.NotificationsEnabled then
                UIUtils.Notify("Welcome", "Bolado Hub loaded successfully!", Color3.fromRGB(0, 200, 100))
            end
        end)
    else
        local hub = self.new(options)
        if options and options.NotificationsEnabled then
            UIUtils.Notify("Welcome", "Bolado Hub loaded successfully!", Color3.fromRGB(0, 200, 100))
        end
        return hub
    end
end

return BoladoHub