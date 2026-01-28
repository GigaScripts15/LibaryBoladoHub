-- Sistema de ícones para BoladoHub
local Icons = {}

Icons.Assets = {
    ["settings"] = "rbxassetid://10734950309",
    ["code"] = "rbxassetid://10709810463",
    ["shield"] = "rbxassetid://10734951847",
    ["gamepad"] = "rbxassetid://10723395457",
    ["eye"] = "rbxassetid://10723346959",
    ["star"] = "rbxassetid://10734966248",
    ["bolt"] = "rbxassetid://10709721749",
    ["wand"] = "rbxassetid://10747376565",
    ["crown"] = "rbxassetid://10709818626",
    ["user"] = "rbxassetid://10747373176",
    ["home"] = "rbxassetid://10723407389",
    ["sword"] = "rbxassetid://10734975486",
    ["music"] = "rbxassetid://10734905958",
    ["zap"] = "rbxassetid://10709721749",
    ["cog"] = "rbxassetid://10709810948",
    ["key"] = "rbxassetid://10723416652",
    ["wifi"] = "rbxassetid://10747382504",
    ["cpu"] = "rbxassetid://10709813383",
    ["battery"] = "rbxassetid://10709774640",
    ["flag"] = "rbxassetid://10723375890",
    ["chevron-down"] = "rbxassetid://10734904599",
    ["check"] = "rbxassetid://10709790387",
    ["paintbrush"] = "rbxassetid://10734910187",
    ["palette"] = "rbxassetid://10734910430",
    ["image"] = "rbxassetid://10723415040",
    ["sliders"] = "rbxassetid://10734963400",
    ["bell"] = "rbxassetid://10709775704",
    ["xcircle"] = "rbxassetid://10747383819",
    ["alertcircle"] = "rbxassetid://10709752996",
    ["info"] = "rbxassetid://10723415903",
    ["helpcircle"] = "rbxassetid://10723406988",
    ["folder"] = "rbxassetid://10723387563",
    ["search"] = "rbxassetid://10734943674",
    ["download"] = "rbxassetid://10723344270",
    ["upload"] = "rbxassetid://10747366434",
    ["copy"] = "rbxassetid://10709812159",
    ["trash"] = "rbxassetid://10747362393",
    ["play"] = "rbxassetid://10734923549",
    ["stopcircle"] = "rbxassetid://10734972621",
    ["refreshcw"] = "rbxassetid://10734933222",
    ["lock"] = "rbxassetid://10723434711"
}

function Icons:Get(iconName)
    return self.Assets[iconName] or "rbxassetid://10709721749" -- Default: bolt
end

function Icons:CreateImageLabel(iconName, size, color)
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = iconName .. "Icon"
    imageLabel.Size = size or UDim2.new(0, 20, 0, 20)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = self:Get(iconName)
    imageLabel.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
    return imageLabel
end

function Icons:CreateImageButton(iconName, size, color)
    local imageButton = Instance.new("ImageButton")
    imageButton.Name = iconName .. "IconBtn"
    imageButton.Size = size or UDim2.new(0, 20, 0, 20)
    imageButton.BackgroundTransparency = 1
    imageButton.Image = self:Get(iconName)
    imageButton.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
    return imageButton
end

return Icons