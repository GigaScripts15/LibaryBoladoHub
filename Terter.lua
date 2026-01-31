--[[
    BOLADO HUB V3.0 - ULTIMATE UNIFIED (RAYFIELD STYLE)
    Sistemas: Key System, Auto-Save Key, Save Settings, Discord, Themes.
]]

local BoladoHub = {}
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Gerenciamento de Pastas
local FolderName = "BoladoHub_Configs"
if not isfolder(FolderName) then makefolder(FolderName) end

-- ==================== SISTEMA DE ARQUIVOS ====================
local function SaveFile(file, data)
    writefile(FolderName.."/"..file..".json", HttpService:JSONEncode(data))
end

local function LoadFile(file)
    local path = FolderName.."/"..file..".json"
    if isfile(path) then return HttpService:JSONDecode(readfile(path)) end
    return nil
end

-- ==================== TEMAS ====================
local Themes = {
    Dark = { Main = Color3.fromRGB(25, 25, 30), Sidebar = Color3.fromRGB(20, 20, 25), Accent = Color3.fromRGB(0, 150, 255), Content = Color3.fromRGB(28, 28, 33), Text = Color3.fromRGB(240, 240, 240), Border = Color3.fromRGB(45, 45, 50) },
    Darker = { Main = Color3.fromRGB(10, 10, 12), Sidebar = Color3.fromRGB(5, 5, 7), Accent = Color3.fromRGB(200, 200, 200), Content = Color3.fromRGB(15, 15, 18), Text = Color3.fromRGB(220, 220, 220), Border = Color3.fromRGB(30, 30, 35) },
    Ocean = { Main = Color3.fromRGB(15, 32, 39), Sidebar = Color3.fromRGB(10, 25, 32), Accent = Color3.fromRGB(0, 210, 255), Content = Color3.fromRGB(20, 40, 50), Text = Color3.fromRGB(230, 250, 255), Border = Color3.fromRGB(30, 60, 75) },
    Red = { Main = Color3.fromRGB(30, 10, 10), Sidebar = Color3.fromRGB(25, 5, 5), Accent = Color3.fromRGB(255, 50, 50), Content = Color3.fromRGB(35, 15, 15), Text = Color3.fromRGB(255, 230, 230), Border = Color3.fromRGB(60, 20, 20) },
    Green = { Main = Color3.fromRGB(10, 30, 15), Sidebar = Color3.fromRGB(5, 25, 10), Accent = Color3.fromRGB(50, 255, 100), Content = Color3.fromRGB(15, 35, 20), Text = Color3.fromRGB(220, 255, 220), Border = Color3.fromRGB(25, 60, 35) },
    Cyberpunk = { Main = Color3.fromRGB(20, 0, 40), Sidebar = Color3.fromRGB(15, 0, 30), Accent = Color3.fromRGB(255, 0, 255), Content = Color3.fromRGB(30, 0, 60), Text = Color3.fromRGB(0, 255, 255), Border = Color3.fromRGB(255, 0, 255) }
}

-- ==================== UTILITÁRIOS UI ====================
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do instance[k] = v end
    return instance
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- ==================== SISTEMA DE KEY ====================
function BoladoHub:VerifyKey(config, callback)
    local Key = config.Key
    local saved = LoadFile("KeyData")
    if saved and saved.Key == Key then callback() return end

    local ScreenGui = Create("ScreenGui", {Parent = CoreGui})
    local Main = Create("Frame", {Size = UDim2.new(0, 350, 0, 200), Position = UDim2.new(0.5, -175, 0.5, -100), BackgroundColor3 = Color3.fromRGB(20, 20, 25), Parent = ScreenGui})
    Create("UICorner", {Parent = Main}); Create("UIStroke", {Color = Color3.fromRGB(0, 150, 255), Parent = Main})
    MakeDraggable(Main)

    local T = Create("TextLabel", {Size = UDim2.new(1, 0, 0, 50), Text = "KEY SYSTEM", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, BackgroundTransparency = 1, Parent = Main})
    local Input = Create("TextBox", {Size = UDim2.new(0, 280, 0, 40), Position = UDim2.new(0.5, -140, 0.4, 0), PlaceholderText = "Insira a Chave...", Text = "", BackgroundColor3 = Color3.fromRGB(30, 30, 35), TextColor3 = Color3.new(1,1,1), Parent = Main})
    Create("UICorner", {Parent = Input})

    local BtnV = Create("TextButton", {Size = UDim2.new(0, 130, 0, 40), Position = UDim2.new(0.1, 0, 0.7, 0), Text = "Verificar", BackgroundColor3 = Color3.fromRGB(0, 150, 255), TextColor3 = Color3.new(1,1,1), Parent = Main})
    Create("UICorner", {Parent = BtnV})

    BtnV.MouseButton1Click:Connect(function()
        if Input.Text == Key then
            SaveFile("KeyData", {Key = Input.Text})
            ScreenGui:Destroy(); callback()
        else
            Input.Text = ""; Input.PlaceholderText = "CHAVE INVÁLIDA!"
        end
    end)
end

-- ==================== LIBRARY CORE ====================
function BoladoHub.new(options)
    local self = {Tabs = {}}
    local settings = LoadFile("Settings") or {Theme = "Dark"}
    self.Theme = Themes[settings.Theme] or Themes.Dark

    local ScreenGui = Create("ScreenGui", {Parent = CoreGui, Name = "BoladoHub"})
    local MainFrame = Create("Frame", {Size = UDim2.new(0, 550, 0, 350), Position = UDim2.new(0.5, -275, 0.5, -175), BackgroundColor3 = self.Theme.Main, Parent = ScreenGui})
    Create("UICorner", {Parent = MainFrame})
    local MainStroke = Create("UIStroke", {Color = self.Theme.Border, Parent = MainFrame})
    MakeDraggable(MainFrame)

    local Sidebar = Create("Frame", {Size = UDim2.new(0, 150, 1, 0), BackgroundColor3 = self.Theme.Sidebar, Parent = MainFrame})
    Create("UICorner", {Parent = Sidebar})

    local TabContainer = Create("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -60), Position = UDim2.new(0, 0, 0, 60), BackgroundTransparency = 1, Parent = Sidebar, ScrollBarThickness = 0})
    Create("UIListLayout", {Parent = TabContainer, Padding = UDim.new(0, 5)})

    -- Função de Tab
    function self:Tab(name)
        local Content = Create("ScrollingFrame", {Size = UDim2.new(1, -160, 1, -20), Position = UDim2.new(0, 160, 0, 10), Visible = false, BackgroundTransparency = 1, Parent = MainFrame, ScrollBarThickness = 2})
        Create("UIListLayout", {Parent = Content, Padding = UDim.new(0, 5)})
        
        local Btn = Create("TextButton", {Size = UDim2.new(1, -10, 0, 35), Text = name, BackgroundColor3 = self.Theme.Accent, BackgroundTransparency = 0.8, TextColor3 = self.Theme.Text, Parent = TabContainer})
        Create("UICorner", {Parent = Btn})

        Btn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.Tabs) do t.Content.Visible = false end
            Content.Visible = true
        end)

        local tabObj = {Content = Content}
        table.insert(self.Tabs, tabObj)
        if #self.Tabs == 1 then Content.Visible = true end

        -- Componentes
        local Elements = {}
        function Elements:Button(config)
            local B = Create("TextButton", {Size = UDim2.new(1, -10, 0, 35), Text = config.Text, BackgroundColor3 = self.Theme.Content, TextColor3 = self.Theme.Text, Parent = Content})
            Create("UICorner", {Parent = B})
            B.MouseButton1Click:Connect(config.Callback)
        end

        function Elements:Toggle(config)
            local state = config.Default or false
            local T = Create("TextButton", {Size = UDim2.new(1, -10, 0, 35), Text = config.Text .. ": " .. tostring(state), BackgroundColor3 = self.Theme.Content, TextColor3 = self.Theme.Text, Parent = Content})
            Create("UICorner", {Parent = T})
            T.MouseButton1Click:Connect(function()
                state = not state
                T.Text = config.Text .. ": " .. tostring(state)
                config.Callback(state)
            end)
        end

        function Elements:Dropdown(config)
            local isDropped = false
            local D = Create("Frame", {Size = UDim2.new(1, -10, 0, 35), BackgroundColor3 = self.Theme.Content, Parent = Content, ClipsDescendants = true})
            Create("UICorner", {Parent = D})
            local DB = Create("TextButton", {Size = UDim2.new(1, 0, 0, 35), Text = config.Text, BackgroundTransparency = 1, TextColor3 = self.Theme.Text, Parent = D})
            
            local List = Create("Frame", {Position = UDim2.new(0,0,0,35), Size = UDim2.new(1,0,0,100), BackgroundTransparency = 1, Parent = D})
            Create("UIListLayout", {Parent = List})

            for _, opt in pairs(config.Options) do
                local OB = Create("TextButton", {Size = UDim2.new(1,0,0,25), Text = opt, BackgroundColor3 = self.Theme.Sidebar, TextColor3 = self.Theme.Text, Parent = List})
                OB.MouseButton1Click:Connect(function()
                    DB.Text = config.Text .. ": " .. opt
                    D.Size = UDim2.new(1, -10, 0, 35)
                    isDropped = false
                    config.Callback(opt)
                end)
            end

            DB.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                D.Size = isDropped and UDim2.new(1, -10, 0, 135) or UDim2.new(1, -10, 0, 35)
            end)
        end

        return Elements
    end

    -- ABA SETTINGS (AUTO-GERADA)
    local SettingsTab = self:Tab("Settings")
    
    SettingsTab:Dropdown({
        Text = "Escolher Tema",
        Options = {"Dark", "Darker", "Ocean", "Red", "Green", "Cyberpunk"},
        Callback = function(t)
            SaveFile("Settings", {Theme = t})
            -- Reinicie para aplicar ou use a lógica de UpdateTheme se preferir
        end
    })

    SettingsTab:Button({
        Text = "Copiar Discord",
        Callback = function() setclipboard(options.Discord or "") end
    })

    return self
end

return BoladoHub
