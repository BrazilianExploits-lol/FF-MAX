--[[ 
    BRAZILIAN EXPLOITS | FREE FIRE MAX - SUPREME EDITION V3
    Owner: NILLGHOST300
    UI: WindUI
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local LocalPlayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Window = WindUI:CreateWindow({
    Title = "Brazilian Exploits | FF Max",
    Icon = "rbxassetid://4483345998",
    Author = "Owner: NILLGHOST300",
    Folder = "BrazilianExploits",
    Size = UDim2.fromOffset(620, 520),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = false,
})

-- ==========================================
-- CRIAÇÃO DAS 9 ABAS
-- ==========================================
local MainTab = Window:Tab({ Title = "Principal", Icon = "home" })
local CombatTab = Window:Tab({ Title = "Aim Kill", Icon = "crosshair" })
local VisualTab = Window:Tab({ Title = "Visual & ESP", Icon = "eye" })
local MovementTab = Window:Tab({ Title = "Movimento", Icon = "wind" })
local WeaponTab = Window:Tab({ Title = "Armas", Icon = "shield" })
local TPTab = Window:Tab({ Title = "Teleportes", Icon = "map-pin" })
local TrollTab = Window:Tab({ Title = "Troll", Icon = "alert-triangle" })
local SocialTab = Window:Tab({ Title = "Social", Icon = "message-square" })
local CreditsTab = Window:Tab({ Title = "Créditos", Icon = "info" })

-- ==========================================
-- AIM KILL (COMBATE)
-- ==========================================
local AimKillEnabled, AutoShootEnabled, FOV, MiraNaCabeca = false, false, 200, true

CombatTab:Toggle({ Title = "Aimbot (Travar Mira)", Default = false, Callback = function(v) AimKillEnabled = v end })
CombatTab:Toggle({ Title = "Auto Shoot (Atirar)", Default = false, Callback = function(v) AutoShootEnabled = v end })
CombatTab:Toggle({ Title = "Headshot", Default = true, Callback = function(v) MiraNaCabeca = v end })
CombatTab:Slider({ Title = "FOV (Raio da Mira)", Step = 10, Value = { Min = 50, Max = 1000, Default = 200 }, Callback = function(v) FOV = v end })

RunService.RenderStepped:Connect(function()
    if not AimKillEnabled then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local menorDistancia, parteParaMirar = FOV, nil
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local parteAlvo = MiraNaCabeca and player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("UpperTorso")
            if parteAlvo then
                local screenPos, onScreen = Camera:WorldToViewportPoint(parteAlvo.Position)
                if onScreen then
                    local centroX, centroY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
                    local distancia = math.sqrt((screenPos.X - centroX)^2 + (screenPos.Y - centroY)^2)
                    if distancia < menorDistancia then
                        menorDistancia = distancia
                        parteParaMirar = parteAlvo
                    end
                end
            end
        end
    end
    
    if parteParaMirar then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, parteParaMirar.Position)
        if AutoShootEnabled then
            local ferramenta = char:FindFirstChildOfClass("Tool")
            if ferramenta then ferramenta:Activate() end
        end
    end
end)

-- ==========================================
-- VISUAL: ESP REALISTA & SNAPLINES
-- ==========================================
local ESPEnabled, SkeletonEnabled, SnaplinesEnabled = false, false, false
local Highlights, Drawings, Snaplines = {}, {}, {}

-- ESP Caixa
VisualTab:Toggle({
    Title = "ESP Caixa (Ver Players)",
    Default = false,
    Callback = function(v)
        ESPEnabled = v
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if v and p.Character then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    Highlights[p] = h
                elseif not v and Highlights[p] then
                    Highlights[p]:Destroy()
                    Highlights[p] = nil
                end
            end
        end
    end
})

-- ESP Linha (Snaplines do topo da tela)
VisualTab:Toggle({
    Title = "ESP Linha (Snaplines do Topo)",
    Default = false,
    Callback = function(v) SnaplinesEnabled = v end
})

-- ESP Skeleton Realista (R15 Joints)
VisualTab:Toggle({
    Title = "ESP Skeleton Realista",
    Desc = "Desenha o esqueleto completo (igual cheat de PC)",
    Default = false,
    Callback = function(v)
        SkeletonEnabled = v
        if not v then
            for _, p in pairs(Drawings) do
                for _, line in pairs(p) do line:Remove() end
            end
            Drawings = {}
        end
    end
})

RunService.RenderStepped:Connect(function()
    -- Lógica das Snaplines
    if SnaplinesEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                if not Snaplines[p.Name] then
                    Snaplines[p.Name] = Drawing.new("Line")
                    Snaplines[p.Name].Color = Color3.fromRGB(255, 255, 255)
                    Snaplines[p.Name].Thickness = 1
                end
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                local line = Snaplines[p.Name]
                if onScreen then
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, 0) -- Topo da tela
                    line.To = Vector2.new(pos.X, pos.Y)
                else
                    line.Visible = false
                end
            end
        end
    else
        for _, line in pairs(Snaplines) do line:Remove() end
        Snaplines = {}
    end

    -- Lógica do Skeleton Realista
    if SkeletonEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local char = p.Character
                -- Verifica se as partes R15 existem no boneco
                if char:FindFirstChild("UpperTorso") then
                    if not Drawings[p.Name] then
                        -- Cria as linhas do esqueleto
                        Drawings[p.Name] = {}
                        local partes = {
                            "Head", "UpperTorso", "LowerTorso",
                            "LeftUpperArm", "LeftLowerArm", "LeftHand",
                            "RightUpperArm", "RightLowerArm", "RightHand",
                            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                            "RightUpperLeg", "RightLowerLeg", "RightFoot"
                        }
                        for _, v in pairs(partes) do
                            Drawings[p.Name][v] = Drawing.new("Line")
                        end
                    end
                    
                    local function UpdateLine(part1, part2)
                        local line = Drawings[p.Name][part1]
                        if char:FindFirstChild(part1) and char:FindFirstChild(part2) then
                            local pos1, onScreen1 = Camera:WorldToViewportPoint(char[part1].Position)
                            local pos2, onScreen2 = Camera:WorldToViewportPoint(char[part2].Position)
                            if onScreen1 and onScreen2 then
                                line.Visible = true
                                line.From = Vector2.new(pos1.X, pos1.Y)
                                line.To = Vector2.new(pos2.X, pos2.Y)
                                line.Color = Color3.fromRGB(0, 255, 0)
                                line.Thickness = 2
                            else line.Visible = false end
                        else line.Visible = false end
                    end
                    
                    -- Conectando os ossos (R15)
                    UpdateLine("Head", "UpperTorso")
                    UpdateLine("UpperTorso", "LowerTorso")
                    -- Braço Esquerdo
                    UpdateLine("UpperTorso", "LeftUpperArm") UpdateLine("LeftUpperArm", "LeftLowerArm") UpdateLine("LeftLowerArm", "LeftHand")
                    -- Braço Direito
                    UpdateLine("UpperTorso", "RightUpperArm") UpdateLine("RightUpperArm", "RightLowerArm") UpdateLine("RightLowerArm", "RightHand")
                    -- Perna Esquerda
                    UpdateLine("LowerTorso", "LeftUpperLeg") UpdateLine("LeftUpperLeg", "LeftLowerLeg") UpdateLine("LeftLowerLeg", "LeftFoot")
                    -- Perna Direita
                    UpdateLine("LowerTorso", "RightUpperLeg") UpdateLine("RightUpperLeg", "RightLowerLeg") UpdateLine("RightLowerLeg", "RightFoot")
                end
            end
        end
    end
end)

-- Hitbox & Fullbright
local HitboxEnabled = false
local HitboxSize = 5
VisualTab:Toggle({
    Title = "Hitbox Expander (Cabeça)",
    Default = false,
    Callback = function(v) HitboxEnabled = v end
})
VisualTab:Slider({
    Title = "Tamanho da Hitbox",
    Step = 1, Value = { Min = 2, Max = 20, Default = 5 },
    Callback = function(v) HitboxSize = v end
})
task.spawn(function()
    while task.wait(0.5) do
        if HitboxEnabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    p.Character.Head.Transparency = 0.5
                end
            end
        end
    end
end)

VisualTab:Toggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(v)
        Lighting.Ambient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(128, 128, 128)
    end
})

-- ==========================================
-- MOVIMENTO
-- ==========================================
MovementTab:Slider({ Title = "Velocidade", Step = 1, Value = { Min = 16, Max = 150, Default = 16 }, Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end })
MovementTab:Slider({ Title = "Pulo", Step = 1, Value = { Min = 50, Max = 300, Default = 50 }, Callback = function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end })

local InfJump = false
UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)
MovementTab:Toggle({ Title = "Pulo Infinito", Default = false, Callback = function(v) InfJump = v end })

local Noclip = false
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
MovementTab:Toggle({ Title = "Noclip", Default = false, Callback = function(v) Noclip = v end })

local flying, bodyVel, bodyGyro = false, nil, nil
MovementTab:Toggle({
    Title = "Voar (Fly)",
    Default = false,
    Callback = function(v)
        flying = v
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if flying then
            if hrp then
                bodyVel = Instance.new("BodyVelocity", hrp); bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5); bodyVel.Velocity = Vector3.zero
                bodyGyro = Instance.new("BodyGyro", hrp); bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bodyGyro.CFrame = hrp.CFrame
                task.spawn(function()
                    while flying and bodyVel do
                        task.wait()
                        local move = LocalPlayer:GetMouse().Hit
                        bodyVel.Velocity = (move.Position - hrp.Position).Unit * 60 + Vector3.new(0, 50, 0)
                    end
                end)
            end
        else
            if bodyVel then bodyVel:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end
    end
})

-- ==========================================
-- ARMAS
-- ==========================================
WeaponTab:Button({
    Title = "Puxar Armas Dropadas",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Tool") then
                    v.Handle.CFrame = char.HumanoidRootPart.CFrame
                end
            end
        end
    end
})
WeaponTab:Toggle({
    Title = "Munição Infinita (Visual)",
    Callback = function(v)
        task.spawn(function()
            while v do
                task.wait(1)
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        for _, value in pairs(tool:GetDescendants()) do
                            if value:IsA("IntValue") and (value.Name:lower():find("ammo") or value.Name:lower():find("clip")) then
                                value.Value = 999
                            end
                        end
                    end
                end
            end
        end)
    end
})

-- ==========================================
-- TELEPORTES
-- ==========================================
TPTab:Button({
    Title = "Teleportar para o Spawn",
    Callback = function()
        local char = LocalPlayer.Character
        local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
        if char and char:FindFirstChild("HumanoidRootPart") and spawn then
            char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
        end
    end
})

TPTab:Button({
    Title = "Puxar Todos os Players pra Você",
    Desc = "Só funciona se o servidor não tiver anti-cheat",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
                end
            end
        end
    end
})

-- ==========================================
-- TROLL
-- ==========================================
TrollTab:Button({
    Title = "Congelar Todos (Anchored)",
    Callback = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Anchored = true
                task.delay(5, function()
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Anchored = false
                    end
                end)
            end
        end
    end
})

TrollTab:Button({
    Title = "Atirar Fogo em Todo Mundo (Visual)",
    Callback = function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local fire = Instance.new("Fire", p.Character.HumanoidRootPart)
                fire.Size = 10
                task.delay(3, function() fire:Destroy() end)
            end
        end
    end
})

-- ==========================================
-- SOCIAL / CHAT
-- ==========================================
SocialTab:Button({
    Title = "Entrar no Discord do Brazilian Exploits",
    Callback = function()
        pcall(function() setclipboard("https://discord.gg/XSaycraHjN") end)
        WindUI:Notify({ Title = "Copiado!", Content = "Link do Discord copiado!", Icon = "check" })
    end
})

SocialTab:Button({
    Title = "Mandar Mensagem no Chat (GG)",
    Callback = function()
        local chat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chat then
            chat.SayMessageRequest:FireServer("Script do Brazilian Exploits é top! 🔥", "All")
        end
    end
})

-- ==========================================
-- PRINCIPAL & CRÉDITOS
-- ==========================================
MainTab:Button({ Title = "Resetar Personagem", Callback = function() LocalPlayer.Character:BreakJoints() end })

CreditsTab:Paragraph({
    Title = "Brazilian Exploits",
    Desc = "Owner: NILLGHOST300\nProgramação: Brazilian Exploits Team\nUI: WindUI\n\nPostem no Discord e sejam felizes! kkkk"
})

WindUI:Notify({ Title = "Brazilian Exploits", Content = "V3 SUPREMA Carregada!", Icon = "check", Duration = 5 })
