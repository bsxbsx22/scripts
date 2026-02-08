_G.config = _G.config or {
    HeadSize = 20,
    TeamCheck = false,
    TargetPart = 'Head',          -- ou 'HumanoidRootPart'
    Enabled = true,               -- mudei pra Enabled (true = ativo)
    Transparency = 0.7,
    Color = BrickColor.new("Really blue"),
    Material = "Neon"
}

local config = _G.config
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Função pra expandir hitbox de um player
local function expandHitbox(player)
    if player == LocalPlayer then return end
    if config.TeamCheck and player.Team == LocalPlayer.Team then return end
    
    local char = player.Character
    if not char then return end
    
    local part = char:FindFirstChild(config.TargetPart)
    if not part or not part:IsA("BasePart") then return end
    
    pcall(function()
        part.Size = Vector3.new(config.HeadSize, config.HeadSize, config.HeadSize)
        part.Transparency = config.Transparency
        part.BrickColor = config.Color
        part.Material = config.Material
        
        if config.TargetPart == "Head" then
            part.Massless = true
        else
            part.Massless = false
        end
        part.CanCollide = false  -- sempre false pra não buggar física
    end)
end

-- Conexão principal
RunService.RenderStepped:Connect(function()
    if not config.Enabled then return end  -- só roda se ativado
    
    for _, player in ipairs(Players:GetPlayers()) do
        expandHitbox(player)
    end
end)

-- Opcional: reconectar quando character spawna (pra novos players)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        -- Espera um pouquinho pro character carregar
        task.wait(0.5)
        expandHitbox(player)
    end)
end)

-- Pra players que já estão no jogo
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        expandHitbox(player)
    end
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        expandHitbox(player)
    end)
end

print("Hitbox expander corrigido carregado! (Enabled = " .. tostring(config.Enabled) .. ")")
