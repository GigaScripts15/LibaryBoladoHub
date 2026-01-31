--[[
    BOLADO HUB V3.0 - ULTIMATE UNIFIED VERSION
    Sistemas: Key System, Auto-Save, Discord Copy, Themes, Mobile Drag & Minimize.
]]

local BoladoHub = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- ==================== CONFIGURAÇÃO DE TEMAS ====================
local Themes = {
    Dark = { Main = Color3.fromRGB(25, 25, 30), Sidebar = Color3.fromRGB(20, 20, 25), Accent = Color3.fromRGB(0, 150, 255), Content = Color3.fromRGB(28, 28, 33), Text = Color3.fromRGB(240, 240, 240), Border = Color3.fromRGB(45, 45, 50) },
    Darker = { Main = Color3.fromRGB(10, 10, 12), Sidebar = Color3.fromRGB(5, 5, 7), Accent = Color3.fromRGB(200, 200, 200), Content = Color3.fromRGB(15, 15, 18), Text = Color3.fromRGB(220, 220, 220), Border = Color3.fromRGB(30, 30, 35) },
    Ocean = { Main = Color3.fromRGB(15, 32, 39), Sidebar = Color3.fromRGB(10, 25, 32), Accent = Color3.fromRGB(0, 210, 255), Content = Color3.fromRGB(20, 40, 50), Text = Color3.fromRGB(230, 250, 255), Border = Color3.fromRGB(30, 60, 75) },
    Red = { Main = Color3.fromRGB(30, 10, 10), Sidebar = Color3.fromRGB(25, 5, 5), Accent = Color3.fromRGB(255, 50, 50), Content = Color3.fromRGB(35, 15, 15), Text = Color3.fromRGB(255, 230, 230), Border = Color3.fromRGB(60, 20, 20) },
    Green = { Main = Color3.fromRGB(10, 30, 15), Sidebar = Color3.fromRGB(5, 25, 10), Accent = Color3.fromRGB(50, 255, 100), Content = Color3.fromRGB(15, 35, 20), Text = Color3.fromRGB(220, 255, 220), Border = Color3.fromRGB(25, 60, 35) },
    Cyberpunk = { Main = Color3.fromRGB(20, 0, 40), Sidebar = Color3.fromRGB(15, 0, 30), Accent = Color3.fromRGB(255, 0, 255), Content = Color3.fromRGB(30, 0, 60), Text = Color3.fromRGB(0, 255, 255), Border = Color3.fromRGB(255, 0, 255) }
}

-- ==================== UTILITÁRIOS ====================
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do instance[k] = v end
    return instance
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==================== KEY SYSTEM ====================
function BoladoHub:VerifyKey(settings, callback)
    local Key = settings.Key or "123"
    local DiscordLink = settings.Discord or "discord.gg/boladohub"
    local targetParent = gethui and gethui() or CoreGui
    
    local KeyGui = Create("ScreenGui", {Parent = targetParent})
    local Frame = Create("Frame", {Size = UDim2.new(0, 350, 0, 180), Position = UDim2.new(0.5, -175, 0.5, -90), BackgroundColor3 = Color3.fromRGB(20, 20, 25), Parent = KeyGui})
    Create("UICorner", {Parent = Frame})
    Create("UIStroke", {Color = Color3.fromRGB(0, 150, 255), Thickness = 2, Parent = Frame})

    local Title = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 40), Text = "KEY SYSTEM", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 18, BackgroundTransparency = 1, Parent = Frame})
    local Box = Create("TextBox", {Size = UDim2.new(0, 250, 0, 35), Position = UDim2.new(0.5, -125, 0.4, 0), PlaceholderText = "Enter Key Here...", Text = "", BackgroundColor3 = Color3.fromRGB(30, 30, 35), TextColor3 = Color3.new(1,1,1), Parent = Frame})
    Create("UICorner", {Parent = Box})

    local VerifyBtn = Create("TextButton", {Size = UDim2.new(0, 120, 0, 35), Position = UDim2.new(0.2, -30, 0.7, 0), Text = "Verify Key", BackgroundColor3 = Color3.fromRGB(0, 150, 255), TextColor3 = Color3.new(1,1,1), Parent = Frame})
    local DiscordBtn = Create("TextButton", {Size = UDim2.new(0, 120, 0, 35), Position = UDim2.new(0.6, 30, 0.7, 0), Text = "Get Key", BackgroundColor3 = Color3.fromRGB(40, 40, 45), TextColor3 = Color3.new(1,1,1), Parent = Frame})
    
    DiscordBtn.MouseButton1Click:Connect(function() setclipboard(DiscordLink) end)
    VerifyBtn.MouseButton1Click:Connect(function()
        if Box.Text == Key then KeyGui:Destroy() callback() else Box.Text = ""; Box.PlaceholderText = "INVALID KEY!" end
    end)
end

-- ==================== CORE LIBRARY ====================
function BoladoHub.new(options)
    local self = {Tabs = {}, ThemeName = "Dark", Name = options.Name or "Bolado Hub"}
    
    -- Load Auto-Save
    if isfile and isfile("BoladoHub_Theme.json") then
        local saved = HttpService:JSONDecode(readfile("BoladoHub_Theme.json"))
        self.ThemeName = saved.Theme or "Dark"
    end
    self.Theme = Themes[self.ThemeName]

    local ScreenGui = Create("ScreenGui", {Parent = gethui and gethui() or CoreGui})
    local MainFrame = Create("Frame", {Size = UDim2.new(0, 550, 0, 350), Position = UDim2.new(0.5, -275, 0.5, -175), BackgroundColor3 = self.Theme.Main, Parent = ScreenGui})
    Create("UICorner", {Parent = MainFrame})
    local MainStroke = Create("UIStroke", {Color = self.Theme.Border, Parent = MainFrame})
    MakeDraggable(MainFrame)

    local Sidebar = Create("Frame", {Size = UDim2.new(0, 150, 1, 0), BackgroundColor3 = self.Theme.Sidebar, Parent = MainFrame})
    Create("UICorner", {Parent = Sidebar})
    
    local TabContainer = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -100), Position = UDim2.new(0, 0, 0, 50), BackgroundTransparency = 1, Parent = Sidebar, ScrollBarThickness = 0})
    Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0, 5)})

    -- [ FUNÇÃO DE TROCA DE TEMA ]
    local function ApplyTheme(name)
        local t = Themes[name]
        self.Theme = t
        MainFrame.BackgroundColor3 = t.Main
        Sidebar.BackgroundColor3 = t.Sidebar
        MainStroke.Color = t.Border
        if writefile then writefile("BoladoHub_Theme.json", HttpService:JSONEncode({Theme = name})) end
    end

    function self:Tab(name, icon)
        local Content = Create("ScrollingFrame", {Size = UDim2.new(1, -160, 1, -20), Position = UDim2.new(0, 160, 0, 10), Visible = false, BackgroundTransparency = 1, Parent = MainFrame})
        Create("UIListLayout", {Parent = Content, Padding = UDim.new(0, 6)})
        
        local Btn = Create("TextButton", {Size = UDim2.new(1, -10, 0, 30), Text = name, BackgroundColor3 = self.Theme.Accent, BackgroundTransparency = 0.8, TextColor3 = self.Theme.Text, Parent = TabContainer})
        Create("UICorner", {Parent = Btn})

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do t.Content.Visible = false end
            Content.Visible = true
        end)

        table.insert(self.Tabs, {Content = Content})
        if #self.Tabs == 1 then Content.Visible = true end

        local Elements = {}
        function Elements:Button(config)
            local B = Create("TextButton", {Size = UDim2.new(1, -10, 0, 35), Text = config.Text, BackgroundColor3 = self.Theme.Content, TextColor3 = self.Theme.Text, Parent = Content})
            Create("UICorner", {Parent = B})
            B.MouseButton1Click:Connect(config.Callback)
        end
        return Elements
    end

    -- ABA DE CONFIGS AUTOMÁTICA
    local ConfigTab = self:Tab("Settings", "settings")
    for tName, _ in pairs(Themes) do
        ConfigTab:Button({Text = "Theme: "..tName, Callback = function() ApplyTheme(tName) end})
    end
    ConfigTab:Button({Text = "Copy Discord Invite", Callback = function() setclipboard(options.Discord or "discord.gg/boladohub") end})

    return self
end

return BoladoHub

    -- Função de Tab
    function self:Tab(name)
        local Content = Create("ScrollingFrame", {
            Parent = MainFrame, Size = UDim2.new(1, -170, 1, -20), Position = UDim2.new(0, 170, 0, 10),
            Visible = false, BackgroundTransparency = 1
        })
        local List = Create("UIListLayout", {Parent = Content, Padding = UDim.new(0, 5)})
        
        local TabBtn = Create("TextButton", {
            Parent = TabContainer, Size = UDim2.new(1, -10, 0, 30), Text = name,
            BackgroundColor3 = self.Theme.Accent, BackgroundTransparency = 0.8, TextColor3 = self.Theme.Text
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do t.Content.Visible = false end
            Content.Visible = true
        end)

        table.insert(self.Tabs, {Content = Content, Btn = TabBtn})
        if #self.Tabs == 1 then Content.Visible = true end
        
        local Elements = {}
        function Elements:Button(txt, cb)
            local B = Create("TextButton", {Parent = Content, Size = UDim2.new(1, -10, 0, 35), Text = txt, BackgroundColor3 = self.Theme.Content, TextColor3 = self.Theme.Text})
            B.MouseButton1Click:Connect(cb)
        end
        return Elements
    end

    -- [ ABA DE CONFIGURAÇÕES ]
    local Settings = self:Tab("Settings")
    
    -- Dropdown de Temas com Save
    local themeList = {"Dark", "Darker", "Ocean", "Red", "Green", "Cyberpunk"}
    for _, tName in pairs(themeList) do
        Settings:Button("Theme: "..tName, function()
            self.Theme = Themes[tName]
            Tween(MainFrame, {BackgroundColor3 = self.Theme.Main})
            Tween(Sidebar, {BackgroundColor3 = self.Theme.Sidebar})
            Tween(Stroke, {Color = self.Theme.Border})
            SaveConfig({Theme = tName})
        end)
    end

    -- [ DISCORD INVITE ]
    Settings:Button("Copy Discord Invite", function()
        if setclipboard then
            setclipboard(options.Discord or "https://discord.gg/boladohub")
            print("Link copiado!")
        end
    end)

    return self
end

return BoladoHub
