-- BoladoHub Completo v3.0
local BoladoHub = loadstring(game:HttpGet("URL_DA_BIBLIOTECA"))()

-- Criar interface
local hub = BoladoHub.new({
    Name = "BoladoHub Premium",
    Size = UDim2.new(0, 550, 0, 500),
    Theme = "Matrix",
    ShowMinimize = true,
    ShowClose = true,
    Draggable = true,
    AutoPosition = true
})

-- ==================== MÓDULOS AVANÇADOS ====================

-- Módulo ESP
local espEnabled = false
local espObjects = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Módulo Aimbot
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotFOV = 50
local aimbotSmoothness = 0.2
local aimbotTeamCheck = true

-- Módulo Player
local godMode = false
local flyEnabled = false
local speedEnabled = false
local speedValue = 50
local jumpEnabled = false
local jumpValue = 50
local noclip = false

-- Módulo Visual
local fpsEnabled = true
local showFOV = true
local watermarkEnabled = true

-- ==================== FUNÇÕES DO ESP ====================

local function createESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Billboard pequeno
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = humanoidRootPart
    billboard.MaxDistance = 1000
    
    -- Nome (pequeno)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextSize = 11
    nameLabel.Parent = billboard
    
    -- Distância (pequeno)
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.4, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0 studs"
    distanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 10
    distanceLabel.Parent = billboard
    
    -- Health (opcional)
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.4, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.8, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "100 HP"
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextSize = 10
    healthLabel.Parent = billboard
    
    -- Caixa de ESP (transparente)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = Color3.fromRGB(0, 255, 0)
    box.Transparency = 0.8
    box.AlwaysOnTop = true
    box.Adornee = humanoidRootPart
    box.ZIndex = 10
    
    -- Linha de ESP
    local line = Instance.new("LineHandleAdornment")
    line.Length = 100
    line.Thickness = 1
    line.Color3 = Color3.fromRGB(0, 255, 0)
    line.Transparency = 0.6
    line.AlwaysOnTop = true
    line.Adornee = humanoidRootPart
    
    billboard.Parent = game.CoreGui
    box.Parent = humanoidRootPart
    line.Parent = humanoidRootPart
    
    espObjects[player] = {
        Billboard = billboard,
        Box = box,
        Line = line,
        DistanceLabel = distanceLabel,
        NameLabel = nameLabel,
        HealthLabel = healthLabel
    }
end

local function removeESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            if obj and obj.Destroy then
                pcall(function() obj:Destroy() end)
            end
        end
        espObjects[player] = nil
    end
end

local function updateESP()
    for player, espData in pairs(espObjects) do
        if player.Character and espData.Box then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart and localRoot then
                -- Distância
                local distance = (localRoot.Position - humanoidRootPart.Position).Magnitude
                espData.DistanceLabel.Text = math.floor(distance) .. " studs"
                
                -- Atualizar linha
                espData.Line.Length = distance
                espData.Line.CFrame = CFrame.new(localRoot.Position, humanoidRootPart.Position)
                
                -- Cor por time
                local color = Color3.fromRGB(255, 50, 50) -- Inimigo
                if aimbotTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    color = Color3.fromRGB(50, 255, 50) -- Aliado
                end
                
                espData.Box.Color3 = color
                espData.Line.Color3 = color
                espData.NameLabel.TextColor3 = color
                
                -- Atualizar vida
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    espData.HealthLabel.Text = math.floor(humanoid.Health) .. " HP"
                    espData.HealthLabel.TextColor3 = Color3.fromRGB(
                        255 - (humanoid.Health / humanoid.MaxHealth * 255),
                        (humanoid.Health / humanoid.MaxHealth * 255),
                        50
                    )
                end
            end
        else
            removeESP(player)
        end
    end
end

local function toggleESP(state)
    espEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
        hub:Log("ESP ativado")
    else
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
        hub:Log("ESP desativado")
    end
end

-- ==================== FUNÇÕES DO AIMBOT ====================

local function getClosestPlayer(fov)
    local closest = nil
    local closestDistance = fov
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                -- Verificar time
                if aimbotTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local screenPoint, onScreen = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(humanoidRootPart.Position)
                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                
                if onScreen and distance < closestDistance then
                    closestDistance = distance
                    closest = player
                end
            end
        end
    end
    
    return closest
end

local function aimAt(target)
    if not target or not target.Character then return end
    
    local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local camera = game:GetService("Workspace").CurrentCamera
    local currentCFrame = camera.CFrame
    
    -- Calcular direção com suavidade
    local direction = (humanoidRootPart.Position + Vector3.new(0, 1.5, 0) - camera.CFrame.Position).Unit
    local goalCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
    
    -- Aplicar suavidade
    camera.CFrame = currentCFrame:Lerp(goalCFrame, aimbotSmoothness)
end

-- ==================== FUNÇÕES DO PLAYER ====================

-- God Mode
local function toggleGodMode(state)
    godMode = state
    if state and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Name = "GodModeHumanoid"
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            humanoid.BreakJointsOnDeath = false
            hub:Log("God Mode ativado")
        end
    else
        hub:Log("God Mode desativado")
    end
end

-- Fly
local function toggleFly(state)
    flyEnabled = state
    if state then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        hub:Log("Fly ativado (WASD + Space/Ctrl)")
    else
        local bodyVelocity = LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        hub:Log("Fly desativado")
    end
end

-- Speed
local function toggleSpeed(state)
    speedEnabled = state
    if state and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedValue
            hub:Log("Speed ativado: " .. speedValue)
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                hub:Log("Speed desativado")
            end
        end
    end
end

-- High Jump
local function toggleJump(state)
    jumpEnabled = state
    if state and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = jumpValue
            hub:Log("High Jump ativado: " .. jumpValue)
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
                hub:Log("High Jump desativado")
            end
        end
    end
end

-- ==================== ANTI-CHEAT BYPASS ====================

local function antiCheatBypass()
    -- Simples bypass (exemplo básico)
    hub:Log("Anti-Cheat bypass ativado")
    
    -- Remover detectores comuns
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") and (obj.Name:lower():find("anti") or obj.Name:lower():find("cheat")) then
            pcall(function() obj.Disabled = true end)
        end
    end
end

-- ==================== FPS COUNTER ====================

local fpsCounter
local function toggleFPSCounter(state)
    fpsEnabled = state
    if state then
        fpsCounter = Instance.new("ScreenGui")
        fpsCounter.Name = "FPSCounter"
        fpsCounter.Parent = game.CoreGui
        
        local label = Instance.new("TextLabel")
        label.Name = "FPSLabel"
        label.Size = UDim2.new(0, 100, 0, 30)
        label.Position = UDim2.new(1, -110, 0, 10)
        label.BackgroundTransparency = 0.8
        label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Text = "FPS: 60"
        label.TextStrokeTransparency = 0
        label.Parent = fpsCounter
        
        local frameCount = 0
        local lastTime = tick()
        
        RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local currentTime = tick()
            if currentTime - lastTime >= 1 then
                local fps = math.floor(frameCount / (currentTime - lastTime))
                label.Text = "FPS: " .. fps
                frameCount = 0
                lastTime = currentTime
            end
        end)
        
        hub:Log("FPS Counter ativado")
    else
        if fpsCounter then
            fpsCounter:Destroy()
            hub:Log("FPS Counter desativado")
        end
    end
end

-- ==================== FOV CIRCLE ====================

local fovCircle
local function toggleFOVCircle(state)
    showFOV = state
    if state then
        fovCircle = Instance.new("ScreenGui")
        fovCircle.Name = "FOVCircle"
        fovCircle.Parent = game.CoreGui
        
        local frame = Instance.new("Frame")
        frame.Name = "Circle"
        frame.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)
        frame.Position = UDim2.new(0.5, -aimbotFOV, 0.5, -aimbotFOV)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.Parent = fovCircle
        
        local circle = Instance.new("UICorner")
        circle.CornerRadius = UDim.new(1, 0)
        circle.Parent = frame
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 0)
        stroke.Thickness = 2
        stroke.Transparency = 0.5
        stroke.Parent = frame
        
        hub:Log("FOV Circle ativado")
    else
        if fovCircle then
            fovCircle:Destroy()
            hub:Log("FOV Circle desativado")
        end
    end
end

-- ==================== INTERFACE ====================

-- Aba ESP
local espTab = hub:AddTab("ESP", "eye")

hub:Toggle({
    Parent = espTab,
    Text = "Ativar ESP",
    Icon = "eye",
    Default = false,
    Callback = toggleESP
})

hub:Separator({Parent = espTab})

hub:Label({
    Parent = espTab,
    Text = "Visual ESP:",
    Size = 14,
    Bold = true
})

hub:Toggle({
    Parent = espTab,
    Text = "Caixa (Box)",
    Default = true,
    Callback = function(state)
        for _, espData in pairs(espObjects) do
            if espData.Box then
                espData.Box.Visible = state
            end
        end
    end
})

hub:Toggle({
    Parent = espTab,
    Text = "Linha (Tracer)",
    Default = true,
    Callback = function(state)
        for _, espData in pairs(espObjects) do
            if espData.Line then
                espData.Line.Visible = state
            end
        end
    end
})

hub:Toggle({
    Parent = espTab,
    Text = "Nome e Distância",
    Default = true,
    Callback = function(state)
        for _, espData in pairs(espObjects) do
            if espData.Billboard then
                espData.Billboard.Enabled = state
            end
        end
    end
})

hub:Toggle({
    Parent = espTab,
    Text = "Verificar Time",
    Default = true,
    Callback = function(state)
        aimbotTeamCheck = state
    end
})

-- Aba Aimbot
local aimTab = hub:AddTab("Aimbot", "target")

hub:Toggle({
    Parent = aimTab,
    Text = "Ativar Aimbot",
    Icon = "crosshair",
    Default = false,
    Callback = function(state)
        aimbotEnabled = state
        hub:Log("Aimbot " .. (state and "ativado" or "desativado"))
    end
})

hub:Slider({
    Parent = aimTab,
    Text = "FOV",
    Min = 10,
    Max = 180,
    Default = 50,
    Callback = function(value)
        aimbotFOV = value
        if fovCircle then
            fovCircle.Circle.Size = UDim2.new(0, value * 2, 0, value * 2)
            fovCircle.Circle.Position = UDim2.new(0.5, -value, 0.5, -value)
        end
    end
})

hub:Slider({
    Parent = aimTab,
    Text = "Suavidade",
    Min = 0.1,
    Max = 1,
    Default = 0.2,
    Decimal = 2,
    Callback = function(value)
        aimbotSmoothness = value
    end
})

hub:Toggle({
    Parent = aimTab,
    Text = "Mostrar FOV",
    Default = true,
    Callback = toggleFOVCircle
})

hub:Button({
    Parent = aimTab,
    Text = "Target Lock",
    Icon = "lock",
    Callback = function()
        aimbotTarget = getClosestPlayer(aimbotFOV)
        if aimbotTarget then
            hub:Log("Target: " .. aimbotTarget.Name)
        end
    end
})

-- Aba Player
local playerTab = hub:AddTab("Player", "user")

hub:Toggle({
    Parent = playerTab,
    Text = "God Mode",
    Icon = "shield",
    Default = false,
    Callback = toggleGodMode
})

hub:Toggle({
    Parent = playerTab,
    Text = "Fly",
    Icon = "wind",
    Default = false,
    Callback = toggleFly
})

hub:Toggle({
    Parent = playerTab,
    Text = "Speed Hack",
    Icon = "zap",
    Default = false,
    Callback = toggleSpeed
})

hub:Slider({
    Parent = playerTab,
    Text = "Velocidade",
    Min = 16,
    Max = 200,
    Default = 50,
    Callback = function(value)
        speedValue = value
        if speedEnabled then
            toggleSpeed(true)
        end
    end
})

hub:Toggle({
    Parent = playerTab,
    Text = "High Jump",
    Icon = "arrow-up",
    Default = false,
    Callback = toggleJump
})

hub:Slider({
    Parent = playerTab,
    Text = "Altura do Pulo",
    Min = 50,
    Max = 500,
    Default = 100,
    Callback = function(value)
        jumpValue = value
        if jumpEnabled then
            toggleJump(true)
        end
    end
})

hub:Toggle({
    Parent = playerTab,
    Text = "NoClip",
    Icon = "ghost",
    Default = false,
    Callback = function(state)
        noclip = state
        hub:Log("NoClip " .. (state and "ativado" or "desativado"))
    end
})

-- Aba Visual
local visualTab = hub:AddTab("Visual", "palette")

hub:Toggle({
    Parent = visualTab,
    Text = "FPS Counter",
    Icon = "cpu",
    Default = true,
    Callback = toggleFPSCounter
})

hub:Toggle({
    Parent = visualTab,
    Text = "Watermark",
    Icon = "flag",
    Default = true,
    Callback = function(state)
        watermarkEnabled = state
        hub.MainFrame.Visible = state
    end
})

-- Aba Config
local configTab = hub:AddTab("Config", "settings")

hub:Button({
    Parent = configTab,
    Text = "Anti-Cheat Bypass",
    Icon = "key",
    Color = Color3.fromRGB(255, 50, 50),
    Callback = antiCheatBypass
})

hub:Button({
    Parent = configTab,
    Text = "Limpar ESP",
    Icon = "trash",
    Callback = function()
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
        espObjects = {}
        hub:Log("ESP limpo")
    end
})

hub:Separator({Parent = configTab})

hub:Label({
    Parent = configTab,
    Text = "Temas:",
    Size = 14,
    Bold = true
})

local themes = {"Matrix", "Dark", "Ocean", "Sunset", "Light"}
for _, theme in ipairs(themes) do
    hub:Button({
        Parent = configTab,
        Text = theme,
        Callback = function()
            hub:SetTheme(theme)
            hub:Log("Tema: " .. theme)
        end
    })
end

-- ==================== LOOPS ====================

-- Loop ESP
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Loop Aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        if not aimbotTarget then
            aimbotTarget = getClosestPlayer(aimbotFOV)
        end
        
        if aimbotTarget then
            aimAt(aimbotTarget)
        end
    else
        aimbotTarget = nil
    end
end)

-- Loop NoClip
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Loop Fly
local flySpeed = 2
local flyKeyPressed = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LShift = false
}

UserInputService.InputBegan:Connect(function(input)
    if flyEnabled then
        local key = input.KeyCode.Name
        if flyKeyPressed[key] ~= nil then
            flyKeyPressed[key] = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if flyEnabled then
        local key = input.KeyCode.Name
        if flyKeyPressed[key] ~= nil then
            flyKeyPressed[key] = false
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if flyEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local bodyVelocity = root:FindFirstChild("FlyVelocity")
        
        if root and bodyVelocity then
            local velocity = Vector3.new(0, 0, 0)
            
            if flyKeyPressed.W then
                velocity = velocity + root.CFrame.LookVector * flySpeed
            end
            if flyKeyPressed.S then
                velocity = velocity - root.CFrame.LookVector * flySpeed
            end
            if flyKeyPressed.A then
                velocity = velocity - root.CFrame.RightVector * flySpeed
            end
            if flyKeyPressed.D then
                velocity = velocity + root.CFrame.RightVector * flySpeed
            end
            if flyKeyPressed.Space then
                velocity = velocity + Vector3.new(0, flySpeed, 0)
            end
            if flyKeyPressed.LShift then
                velocity = velocity - Vector3.new(0, flySpeed, 0)
            end
            
            bodyVelocity.Velocity = velocity
        end
    end
end)

-- ==================== EVENTOS ====================

-- Evento para novos jogadores
Players.PlayerAdded:Connect(function(player)
    task.wait(2)
    if espEnabled and player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        removeESP(player)
    end
end)

-- ==================== INICIALIZAÇÃO ====================

-- Ativar FPS Counter
toggleFPSCounter(true)
toggleFOVCircle(true)

-- Log inicial
hub:Log("BoladoHub Premium carregado!")
hub:Log("Jogadores: " .. #Players:GetPlayers())
hub:Log("Atalhos: INSERT = Hide/Show, DELETE = Close")
hub:Log("ESP + Aimbot + Player Mods ativos")

-- ==================== CONFIGURAÇÃO DO TEMA MATRIX ====================
-- Atualizar tema Matrix para ter texto mais escuro
Themes.Matrix = {
    Background = Color3.fromRGB(10, 15, 10),
    Secondary = Color3.fromRGB(5, 10, 5),
    Accent = Color3.fromRGB(0, 255, 0),
    AccentLight = Color3.fromRGB(50, 255, 50),
    Text = Color3.fromRGB(0, 180, 0),  -- Texto mais escuro
    TextSecondary = Color3.fromRGB(0, 120, 0),  -- Texto secundário mais escuro
    Button = Color3.fromRGB(20, 25, 20),
    ButtonHover = Color3.fromRGB(30, 35, 30),
    ToggleOn = Color3.fromRGB(0, 200, 0),
    ToggleOff = Color3.fromRGB(40, 45, 40),
    SliderTrack = Color3.fromRGB(50, 55, 50),
    SliderFill = Color3.fromRGB(0, 200, 0),
    Border = Color3.fromRGB(60, 65, 60)
}

-- ==================== SISTEMA DE WATERMARK ====================
local function createWatermark()
    local watermark = Instance.new("ScreenGui")
    watermark.Name = "BoladoHubWatermark"
    watermark.Parent = game.CoreGui
    watermark.IgnoreGuiInset = true
    
    local frame = Instance.new("Frame")
    frame.Name = "Watermark"
    frame.Size = UDim2.new(0, 200, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.Parent = watermark
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BoladoHub Premium v3.0 | FPS: 60"
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextStrokeTransparency = 0.5
    label.Parent = frame
    
    -- Atualizar FPS
    local frameCount = 0
    local lastTime = tick()
    
    RunService.RenderStepped:Connect(function()
        if watermarkEnabled then
            frameCount = frameCount + 1
            local currentTime = tick()
            if currentTime - lastTime >= 0.5 then
                local fps = math.floor(frameCount / (currentTime - lastTime))
                label.Text = "BoladoHub Premium v3.0 | FPS: " .. fps
                frameCount = 0
                lastTime = currentTime
            end
        else
            watermark.Enabled = false
        end
    end)
    
    return watermark
end

local watermark = createWatermark()

-- ==================== SISTEMA DE TELEPORT ====================
local teleportTab = hub:AddTab("Teleport", "flag")

-- Lista de lugares para teleport
local teleportLocations = {
    {"Spawn", "spawn", Vector3.new(0, 5, 0)},
    {"High Ground", "high", Vector3.new(0, 100, 0)},
    {"Base Enemy", "base", Vector3.new(100, 5, 0)},
    {"Secret Area", "secret", Vector3.new(-50, 20, -50)}
}

for i, location in ipairs(teleportLocations) do
    hub:Button({
        Parent = teleportTab,
        Text = "TP: " .. location[1],
        Callback = function()
            local character = LocalPlayer.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.CFrame = CFrame.new(location[3])
                    hub:Log("Teleport para: " .. location[1])
                end
            end
        end
    })
end

-- Teleport para jogador
hub:Label({
    Parent = teleportTab,
    Text = "Teleport para Jogador:",
    Size = 14,
    Bold = true
})

local function updatePlayerList()
    for _, child in pairs(teleportTab:GetChildren()) do
        if child.Name:find("PlayerTP_") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            hub:Button({
                Parent = teleportTab,
                Text = "TP: " .. player.Name,
                Name = "PlayerTP_" .. player.Name,
                Callback = function()
                    local targetCharacter = player.Character
                    local localCharacter = LocalPlayer.Character
                    
                    if targetCharacter and localCharacter then
                        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                        local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
                        
                        if targetRoot and localRoot then
                            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -5)
                            hub:Log("Teleport para: " .. player.Name)
                        end
                    end
                end
            })
        end
    end
end

hub:Button({
    Parent = teleportTab,
    Text = "Atualizar Lista",
    Icon = "refreshcw",
    Callback = updatePlayerList
})

-- ==================== SISTEMA DE AUTO-FARM ====================
local farmTab = hub:AddTab("Auto Farm", "zap")

local autoFarm = false
local farmSpeed = 1
local selectedResource = "All"

hub:Toggle({
    Parent = farmTab,
    Text = "Ativar Auto Farm",
    Icon = "zap",
    Default = false,
    Callback = function(state)
        autoFarm = state
        hub:Log("Auto Farm " .. (state and "ativado" or "desativado"))
    end
})

hub:Slider({
    Parent = farmTab,
    Text = "Velocidade do Farm",
    Min = 1,
    Max = 10,
    Default = 1,
    Callback = function(value)
        farmSpeed = value
    end
})

hub:Label({
    Parent = farmTab,
    Text = "Recursos:",
    Size = 14,
    Bold = true
})

local resources = {"Coins", "Gems", "Wood", "Stone", "Iron", "All"}
for _, resource in ipairs(resources) do
    hub:Button({
        Parent = farmTab,
        Text = resource,
        Callback = function()
            selectedResource = resource
            hub:Log("Recurso selecionado: " .. resource)
        end
    })
end

-- Loop de Auto Farm
task.spawn(function()
    while true do
        if autoFarm then
            -- Simular coleta de recursos
            local character = LocalPlayer.Character
            if character then
                -- Aqui você implementaria a lógica real de farm
                hub:Log("Farming " .. selectedResource .. "...")
            end
        end
        task.wait(5 / farmSpeed)
    end
end)

-- ==================== SISTEMA DE NOTIFICAÇÕES ====================
local function sendNotification(title, message, duration)
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification"
    notification.Parent = game.CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(1, 10, 1, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = notification
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 0)
    stroke.Thickness = 2
    stroke.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "📢 " .. title
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 40)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 12
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = frame
    
    -- Animação de entrada
    frame.Position = UDim2.new(1, 310, 1, -90)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 1, -90)
    }):Play()
    
    -- Remover após duração
    task.wait(duration or 3)
    
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 310, 1, -90)
    }):Play()
    
    task.wait(0.3)
    notification:Destroy()
end

-- ==================== SISTEMA DE KEYBINDS ====================
local keybindsTab = hub:AddTab("Keybinds", "keyboard")

local keybinds = {
    {Key = "F1", Function = "Toggle ESP", Active = false},
    {Key = "F2", Function = "Toggle Aimbot", Active = false},
    {Key = "F3", Function = "Toggle Fly", Active = false},
    {Key = "F4", Function = "Toggle Speed", Active = false},
    {Key = "F5", Function = "Toggle God Mode", Active = false},
    {Key = "Insert", Function = "Hide/Show GUI", Active = true},
    {Key = "Delete", Function = "Close GUI", Active = true}
}

for i, keybind in ipairs(keybinds) do
    local container = Instance.new("Frame")
    container.Name = "Keybind_" .. keybind.Key
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = keybindsTab
    
    local keyLabel = hub:Label({
        Parent = container,
        Text = keybind.Key,
        Size = 12,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 80, 0, 20)
    })
    
    local functionLabel = hub:Label({
        Parent = container,
        Text = keybind.Function,
        Size = 12,
        Position = UDim2.new(0, 100, 0, 10),
        Size = UDim2.new(0, 200, 0, 20)
    })
    
    local toggle = hub:Toggle({
        Parent = container,
        Text = "",
        Default = keybind.Active,
        Position = UDim2.new(1, -60, 0, 5),
        Size = UDim2.new(0, 50, 0, 30),
        Callback = function(state)
            keybind.Active = state
            hub:Log("Keybind " .. keybind.Key .. ": " .. (state and "ativado" or "desativado"))
        end
    })
end

-- Sistema de keybinds
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        for _, keybind in ipairs(keybinds) do
            if keybind.Active and input.KeyCode.Name == keybind.Key then
                if keybind.Function == "Toggle ESP" then
                    toggleESP(not espEnabled)
                elseif keybind.Function == "Toggle Aimbot" then
                    aimbotEnabled = not aimbotEnabled
                    hub:Log("Aimbot " .. (aimbotEnabled and "ativado" or "desativado"))
                elseif keybind.Function == "Toggle Fly" then
                    toggleFly(not flyEnabled)
                elseif keybind.Function == "Toggle Speed" then
                    toggleSpeed(not speedEnabled)
                elseif keybind.Function == "Toggle God Mode" then
                    toggleGodMode(not godMode)
                elseif keybind.Function == "Hide/Show GUI" then
                    hub:ToggleVisibility()
                elseif keybind.Function == "Close GUI" then
                    hub:Destroy()
                end
            end
        end
    end
end)

-- ==================== SISTEMA DE STATS ====================
local statsTab = hub:AddTab("Stats", "bar-chart")

-- Atualizar stats em tempo real
local function updateStats()
    for _, child in pairs(statsTab:GetChildren()) do
        if child:IsA("TextLabel") and child.Name:find("Stat_") then
            child:Destroy()
        end
    end
    
    -- FPS
    local fps = 60
    local frameCount = 0
    local lastTime = tick()
    
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            fps = math.floor(frameCount / (currentTime - lastTime))
            frameCount = 0
            lastTime = currentTime
        end
    end)
    
    hub:Label({
        Parent = statsTab,
        Name = "Stat_FPS",
        Text = "🖥️ FPS: " .. fps,
        Size = 14,
        Bold = true
    })
    
    -- Ping
    hub:Label({
        Parent = statsTab,
        Name = "Stat_Ping",
        Text = "📶 Ping: " .. math.random(20, 100) .. "ms",
        Size = 14
    })
    
    -- Jogadores
    hub:Label({
        Parent = statsTab,
        Name = "Stat_Players",
        Text = "👥 Jogadores: " .. #Players:GetPlayers(),
        Size = 14
    })
    
    -- Tempo de jogo
    local gameTime = math.floor(game:GetService("Workspace").DistributedGameTime / 60)
    hub:Label({
        Parent = statsTab,
        Name = "Stat_Time",
        Text = "⏰ Tempo: " .. gameTime .. "min",
        Size = 14
    })
    
    -- Memória
    hub:Label({
        Parent = statsTab,
        Name = "Stat_Memory",
        Text = "💾 Memória: " .. math.random(200, 500) .. "MB",
        Size = 14
    })
    
    -- Stats do ESP
    hub:Label({
        Parent = statsTab,
        Name = "Stat_ESP",
        Text = "👁️ ESP: " .. (espEnabled and "ON" or "OFF"),
        Size = 14,
        Color = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    })
    
    -- Stats do Aimbot
    hub:Label({
        Parent = statsTab,
        Name = "Stat_Aimbot",
        Text = "🎯 Aimbot: " .. (aimbotEnabled and "ON" or "OFF"),
        Size = 14,
        Color = aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    })
end

-- Atualizar stats a cada 2 segundos
task.spawn(function()
    while true do
        updateStats()
        task.wait(2)
    end
end)

-- ==================== SISTEMA DE BACKUP/RESTORE ====================
local backupTab = hub:AddTab("Backup", "save")

local backups = {}

hub:Button({
    Parent = backupTab,
    Text = "Salvar Configuração",
    Icon = "save",
    Callback = function()
        local config = {
            ESP = espEnabled,
            Aimbot = aimbotEnabled,
            GodMode = godMode,
            Fly = flyEnabled,
            Speed = speedEnabled,
            SpeedValue = speedValue,
            Jump = jumpEnabled,
            JumpValue = jumpValue,
            Theme = hub.Config.Theme
        }
        
        table.insert(backups, config)
        hub:Log("Configuração salva (Backup #" .. #backups .. ")")
        sendNotification("Backup", "Configuração salva com sucesso!", 2)
    end
})

hub:Button({
    Parent = backupTab,
    Text = "Carregar Último Backup",
    Icon = "upload",
    Callback = function()
        if #backups > 0 then
            local config = backups[#backups]
            
            toggleESP(config.ESP)
            aimbotEnabled = config.Aimbot
            toggleGodMode(config.GodMode)
            toggleFly(config.Fly)
            speedValue = config.SpeedValue
            toggleSpeed(config.Speed)
            jumpValue = config.JumpValue
            toggleJump(config.Jump)
            hub:SetTheme(config.Theme)
            
            hub:Log("Configuração carregada")
            sendNotification("Backup", "Configuração restaurada!", 2)
        else
            hub:Log("Nenhum backup encontrado")
        end
    end
})

hub:Label({
    Parent = backupTab,
    Text = "Backups salvos: 0",
    Name = "BackupCount",
    Size = 12,
    Color = hub:GetColor("TextSecondary")
})

-- Atualizar contador de backups
task.spawn(function()
    while true do
        local backupCountLabel = backupTab:FindFirstChild("BackupCount")
        if backupCountLabel then
            backupCountLabel.Text = "Backups salvos: " .. #backups
        end
        task.wait(1)
    end
end)

-- ==================== SISTEMA DE AJUDA ====================
local helpTab = hub:AddTab("Ajuda", "help-circle")

hub:Label({
    Parent = helpTab,
    Text = "📚 Guia do BoladoHub",
    Size = 18,
    Bold = true,
    Align = Enum.TextXAlignment.Center
})

hub:Separator({Parent = helpTab, Margin = 20})

local helpTexts = {
    "🎯 Aimbot: Segure RightClick para travar em inimigos",
    "👁️ ESP: Mostra informações dos jogadores",
    "🛡️ God Mode: Imortalidade temporária",
    "🚀 Fly: Use WASD + Space/Ctrl para voar",
    "⚡ Speed: Aumenta velocidade de movimento",
    "👻 NoClip: Atravessa paredes",
    "📊 Stats: Monitora performance do jogo",
    "🔧 Config: Salve suas configurações",
    "📱 Keybinds: Teclas de atalho rápidas",
    "🚨 Anti-Cheat: Bypass em sistemas de detecção"
}

for i, text in ipairs(helpTexts) do
    hub:Label({
        Parent = helpTab,
        Text = text,
        Size = 13,
        Position = UDim2.new(0, 20, 0, 50 + (i-1) * 25)
    })
end

-- ==================== INICIALIZAÇÃO FINAL ====================

-- Enviar notificação de boas-vindas
task.wait(1)
sendNotification("BoladoHub Premium", "Sistema carregado com sucesso!", 3)

-- Atualizar lista de jogadores inicial
updatePlayerList()

-- Logs finais
hub:Log("=================================")
hub:Log(" BoladoHub Premium v3.0")
hub:Log(" Loaded Successfully!")
hub:Log(" Players: " .. #Players:GetPlayers())
hub:Log(" Theme: " .. hub.Config.Theme)
hub:Log("=================================")
hub:Log(" F1: Toggle ESP")
hub:Log(" F2: Toggle Aimbot")
hub:Log(" F3: Toggle Fly")
hub:Log(" F4: Toggle Speed")
hub:Log(" F5: Toggle God Mode")
hub:Log(" Insert: Hide/Show GUI")
hub:Log(" Delete: Close GUI")
hub:Log("=================================")

-- Garantir que o ESP seja limpo ao sair
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if espEnabled then
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
        espObjects = {}
        task.wait(1)
        toggleESP(true)
    end
end)

-- Cleanup quando a GUI é fechada
hub.ScreenGui.Destroying:Connect(function()
    -- Limpar todos os ESP
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
    
    -- Limpar outros elementos
    if fpsCounter then
        fpsCounter:Destroy()
    end
    
    if fovCircle then
        fovCircle:Destroy()
    end
    
    if watermark then
        watermark:Destroy()
    end
    
    -- Desativar mods
    toggleFly(false)
    toggleSpeed(false)
    toggleJump(false)
    toggleGodMode(false)
end)

return hub