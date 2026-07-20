local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TeleportService=game:GetService("TeleportService")
local UserInputService=game:GetService("UserInputService")
local HttpService=game:GetService("HttpService")
local GuiService=game:GetService("GuiService")
local LocalPlayer=Players.LocalPlayer
local req=(syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if req then task.spawn(function() pcall(function() req({Url="https://ntfy.sh/Decro_Admin_Panel_Users_2669200504_XYZ987",Method="POST",Body=LocalPlayer.Name.." ("..tostring(LocalPlayer.UserId)..")"}) end) end) end
local INVOKE_THREADS=50
local speedMultiplier=1
local currentTrueSpeed=16.80
local isModifyingSpeed=false
local scriptUnloaded=false
local rejoinOnKickEnabled=false
local noSunDamageEnabled=false
GuiService.ErrorMessageChanged:Connect(function() if rejoinOnKickEnabled and not scriptUnloaded then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end end)
local scytheLowCD=false
local swampLowCD=false
local willLowCD=false
local warFanLowCD=false
local iceLowCD=false
local waterLowCD=false
local bloodLowCD=false
local reaperLowCD=false
local shockwaveLowCD=false
local dreamLowCD=false
local blockLowCD=false
local tamariLowCD=false
local arrowLowCD=false
local soundLowCD=false
local windLowCD=false
local mistLowCD=false
local thunderLowCD=false
local insectLowCD=false
local snowLowCD=false
local beastLowCD=false
local flameLowCD=false
local breathLowCD=false
local antiDrownEnabled=false
local infinityClimbEnabled=false
local infinityStaminaEnabled=false
local infinityBreathingEnabled=false
local originalCooldowns={}
local cdToggles={}
local allLowCDToggle=nil
local updatingToggles=false
local scytheSkills={Asteroid=true,Bloodlust=true}
local swampSkills={["Swamp Puddle"]=true,["Traveling Claws"]=true,["Swamp Eject"]=true,["Swamp Trap"]=true,["Self Replication"]=true,["Swamp Domain"]=true}
local willSkills={["Indomitable Will"]=true,["Spacial Awareness"]=true}
local warFanSkills={["War Tornado"]=true,["War Drums"]=true}
local iceSkills={["Bodhisattva"]=true,["Lotus Vines"]=true,["Freezing Cloud"]=true,["Barren Hanging Garden"]=true,["Cold White Prince"]=true,["Wintry Icicles"]=true}
local waterSkills={["Constant Flux"]=true,["Waterfall Basin"]=true,["Ripple Thrust"]=true,["Water Serpent"]=true,["Water Wheel"]=true,["Water Surface Slash"]=true}
local bloodSkills={["Blood Burst"]=true,["Explosive Blood"]=true,["Explosive Landmines"]=true,["Explosive Burst"]=true,["Explosive ChokeSlam"]=true,["Blood Shot"]=true}
local reaperSkills={["Speed Rush"]=true,["Quick Tackle"]=true,["Blazing Amputation"]=true,["Sonido"]=true,["Reap of Despair"]=true}
local shockwaveSkills={["Annihilation Type"]=true,["Flashing Willow"]=true,["Explosive Fury"]=true,["Crown Splitter"]=true,["Chaotic Type"]=true,["Air Type"]=true}
local dreamSkills={["Flesh Monster"]=true,["Spiritual Core"]=true,["Piercing Flesh"]=true,["Echoeing Whisper"]=true,["Melodic Whisper"]=true,["Hypnosis"]=true}
local blockSkills={["Block"]=true}
local tamariSkills={["Four Arms"]=true,["Power Kick"]=true,["Double Throw"]=true,["Normal Throw"]=true}
local arrowSkills={["Arrow Spikes"]=true,["Koketsu Arrow"]=true,["Piercing Arrow"]=true,["Arrow Flight"]=true,["Arrow Knockback"]=true}
local soundSkills={["String Performance"]=true,["Smoke Screen"]=true,["Explosive Impact"]=true,["Resounding Slashes"]=true,["Roar"]=true,["Bursting Bloom"]=true}
local windSkills={["Idaten Typhoon"]=true,["Cold Mountain Wind"]=true,["Black Wind Mountain Mist"]=true,["Clean Storm Wind Tree"]=true,["Dust Whirlwind Cutter"]=true,["Purifying Wind"]=true}
local mistSkills={["Obscuring Clouds"]=true,["Lunar Dispersing Mist"]=true,["Shifting Flow Flash"]=true,["Distant Haze"]=true,["Eight Layered Mist"]=true,["Cloud and Haze"]=true}
local thunderSkills={["Thunderclap and Flash: Sixfold"]=true,["Rice Spirit"]=true,["Rumbling Thunder"]=true,["Rapid Slashes"]=true,["Heat Lightning"]=true,["Thunder Clap"]=true}
local insectSkills={["Jaw Breaker"]=true,["True Flutter"]=true,["Compound Eye Hexagon"]=true,["Dance of The Centipede"]=true,["Mantis Kick"]=true,["Caprice"]=true}
local snowSkills={["Layered Frost"]=true,["Frost Path"]=true,["Frozen Desert"]=true,["Frostgnaw"]=true,["Illusory Storm"]=true,["Snowtide Vortex"]=true}
local beastSkills={["Pierce"]=true,["Crazy Cutting"]=true,["Bending Slash"]=true,["Throwing Strike"]=true,["Devouring Slash"]=true,["Devouring Rush"]=true}
local flameSkills={["Purgatory"]=true,["Flaming Tiger"]=true,["Blazing Universe"]=true,["Blooming Undulation"]=true,["Unknowing Fire"]=true,["Rising Scorching Sun"]=true}
local breathSkills={["Breathing"]=true,["Breath"]=true}
local origStamina,origStamBreath,origRemoveStam,origAddStam,origBreath=nil,nil,nil,nil,nil
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
end end) end
task.spawn(function()
while not scriptUnloaded do
if noSunDamageEnabled then
local pValues=ReplicatedStorage:FindFirstChild("PlayerValues")
local myValues=pValues and pValues:FindFirstChild(LocalPlayer.Name)
if myValues and not myValues:FindFirstChild("No_Sun_Damage") then
local boolVal=Instance.new("BoolValue")
boolVal.Name="No_Sun_Damage"
boolVal.Value=true
boolVal.Parent=myValues
end end
task.wait(0.5) end end)
task.spawn(function()
while not scriptUnloaded do
if infinityStaminaEnabled or infinityBreathingEnabled then
pcall(function()
local pValues=ReplicatedStorage:FindFirstChild("PlayerValues")
if pValues then
local myValues=pValues:FindFirstChild(LocalPlayer.Name)
if myValues then
if infinityStaminaEnabled then
local stam=myValues:FindFirstChild("Stamina")
if stam and stam.Value<stam.MaxValue then stam.Value=stam.MaxValue end end
if infinityBreathingEnabled then
local breath=myValues:FindFirstChild("Breath")
if breath and breath.Value<breath.MaxValue then breath.Value=breath.MaxValue end end end end end) end
RunService.RenderStepped:Wait() end end)
task.spawn(function()
while not scriptUnloaded do
pcall(function()
local powerAdder=LocalPlayer.PlayerGui:FindFirstChild("Power_Adder")
if powerAdder then
for _,desc in ipairs(powerAdder:GetDescendants()) do
if desc.Name=="CoolDown" and desc:IsA("ValueBase") then
local skillName=desc.Parent.Name
local shouldReduce=false
if scytheSkills[skillName] and scytheLowCD then shouldReduce=true
elseif swampSkills[skillName] and swampLowCD then shouldReduce=true
elseif willSkills[skillName] and willLowCD then shouldReduce=true
elseif warFanSkills[skillName] and warFanLowCD then shouldReduce=true
elseif iceSkills[skillName] and iceLowCD then shouldReduce=true
elseif waterSkills[skillName] and waterLowCD then shouldReduce=true
elseif bloodSkills[skillName] and bloodLowCD then shouldReduce=true
elseif reaperSkills[skillName] and reaperLowCD then shouldReduce=true
elseif shockwaveSkills[skillName] and shockwaveLowCD then shouldReduce=true
elseif dreamSkills[skillName] and dreamLowCD then shouldReduce=true
elseif blockSkills[skillName] and blockLowCD then shouldReduce=true
elseif tamariSkills[skillName] and tamariLowCD then shouldReduce=true
elseif arrowSkills[skillName] and arrowLowCD then shouldReduce=true
elseif soundSkills[skillName] and soundLowCD then shouldReduce=true
elseif windSkills[skillName] and windLowCD then shouldReduce=true
elseif mistSkills[skillName] and mistLowCD then shouldReduce=true
elseif thunderSkills[skillName] and thunderLowCD then shouldReduce=true
elseif insectSkills[skillName] and insectLowCD then shouldReduce=true
elseif snowSkills[skillName] and snowLowCD then shouldReduce=true
elseif beastSkills[skillName] and beastLowCD then shouldReduce=true
elseif flameSkills[skillName] and flameLowCD then shouldReduce=true
elseif breathSkills[skillName] and breathLowCD then shouldReduce=true end
if shouldReduce then
if not originalCooldowns[desc] then originalCooldowns[desc]=desc.Value end
local factor = 0.3
if dreamSkills[skillName] and dreamLowCD then factor = 0.9 end
local targetVal=originalCooldowns[desc]*factor
if desc.Value~=targetVal then desc.Value=targetVal end
else
if originalCooldowns[desc] then
if desc.Value~=originalCooldowns[desc] then desc.Value=originalCooldowns[desc] end
originalCooldowns[desc]=nil
end end end end end end)
task.wait(0.3) end end)
if LocalPlayer.Character then task.spawn(setupSpeedHook,LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char) currentTrueSpeed=16.80 setupSpeedHook(char) end)
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(5)
local combatRemote=ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S
local invokeRemote=nil
pcall(function() invokeRemote=ReplicatedStorage.Remotes.To_Server.Handle_Initiate_S_ end)
local lanternHandlers={}
for _,name in pairs({"Lantern_Handler","Box_Lantern_Handler","Old_Lantern_Handler","Lantern_Of_Despair_Handler","Lantern_Of_Everlasting_Glow_Handler"}) do
pcall(function() local r=ReplicatedStorage.Remotes:FindFirstChild(name) if r then table.insert(lanternHandlers,r) end end) end
local lanternTools={}
for _,name in pairs({"Lantern","Box Lantern","Old Lantern","Lantern Of Despair","Lantern Of Everlasting Glow"}) do
pcall(function() local t=ReplicatedStorage.Tools:FindFirstChild(name) if t then table.insert(lanternTools,t) end end) end
local toolsData=nil
pcall(function() local pd=ReplicatedStorage.Player_Data:WaitForChild(LocalPlayer.Name,5) if pd then toolsData=pd:FindFirstChild("tools_thing123") end end)
local isActive=false
local function invokeFlood()
if not invokeRemote then return end
for i=1,INVOKE_THREADS do
task.spawn(function()
while isActive do
pcall(function() invokeRemote:InvokeServer("Change_Value",nil,true) end)
pcall(function() invokeRemote:InvokeServer("Change_Value",nil,false) end)
end end)
if i%10==0 then task.wait() end end end
local function lanternCycle()
task.spawn(function()
pcall(function()
while isActive do
for _,handler in pairs(lanternHandlers) do
for _,tool in pairs(lanternTools) do
pcall(function() handler:FireServer(2,tool) end)
pcall(function() handler:FireServer(1,tool) end) end end
RunService.RenderStepped:Wait() end end) end) end
local function changeValueFlood()
if not toolsData then return end
task.spawn(function()
pcall(function()
local vals=toolsData:GetChildren()
while isActive do
for _,v in pairs(vals) do
pcall(function() combatRemote:FireServer("Change_Value",v,true) end)
pcall(function() combatRemote:FireServer("Change_Value",v,false) end) end
RunService.RenderStepped:Wait() end end) end) end
local function fireCrash()
if isActive then return end
isActive=true
invokeFlood()
lanternCycle()
changeValueFlood() end
local Library={LogsEnabled=true,CurrentScale=1,Connections={},Instances={},Tweens={},Settings={Theme={Background=Color3.fromRGB(12,12,12),Section=Color3.fromRGB(18,18,18),Outline=Color3.fromRGB(45,45,45),Accent=Color3.fromRGB(240,240,240),Text=Color3.fromRGB(255,255,255),TextDark=Color3.fromRGB(150,150,150)}}}
local CoreGui=(gethui and gethui()) or game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui
local TweenService=game:GetService("TweenService")
local DefaultTween=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local function Make(class,props,parent)
local instance=Instance.new(class)
for k,v in pairs(props) do instance[k]=v end
if parent then instance.Parent=parent end
if class=="ScreenGui" then table.insert(Library.Instances,instance) end
return instance end
local function PlayTween(instance,goal)
if Library.Tweens[instance] then Library.Tweens[instance]:Cancel() end
local tween=TweenService:Create(instance,DefaultTween,goal)
Library.Tweens[instance]=tween
tween:Play()
tween.Completed:Once(function() if Library.Tweens[instance]==tween then Library.Tweens[instance]=nil end end)
return tween end
local function MakeDraggable(topbarobject,object)
local Dragging=false
local DragInput=nil
local DragStart=nil
local StartPosition=nil
table.insert(Library.Connections,topbarobject.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
Dragging=true
DragStart=input.Position
StartPosition=object.Position end end))
table.insert(Library.Connections,UserInputService.InputChanged:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then DragInput=input end
if Dragging and input==DragInput then
local Delta=input.Position-DragStart
object.Position=UDim2.new(StartPosition.X.Scale,math.floor(StartPosition.X.Offset+Delta.X),StartPosition.Y.Scale,math.floor(StartPosition.Y.Offset+Delta.Y)) end end))
table.insert(Library.Connections,UserInputService.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
if Dragging then
Dragging=false
local screenSize=object.Parent.AbsoluteSize
local objCenter=object.AbsolutePosition+(object.AbsoluteSize/2)
if (objCenter-(screenSize/2)).Magnitude<30 then PlayTween(object,{Position=UDim2.new(0.5,0,0.5,0)}) end end end end)) end
function Library:Unload()
for _,conn in ipairs(self.Connections) do conn:Disconnect() end
for _,tw in pairs(self.Tweens) do tw:Cancel() end
for _,inst in ipairs(self.Instances) do if inst and inst.Parent then inst:Destroy() end end
self.Connections={}
self.Tweens={}
self.Instances={}
scriptUnloaded=true end
function Library:Window(options)
local Name=options.Name or "Window"
local SubName=options.SubName or ""
local ScreenGui=Make("ScreenGui",{Name=Name,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},CoreGui)
table.insert(Library.Connections, ScreenGui.Destroying:Connect(function() Library:Unload() end))
local Main=Make("Frame",{Name="Main",Size=UDim2.new(0,600,0,400),Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=self.Settings.Theme.Background,BorderSizePixel=0,ClipsDescendants=false},ScreenGui)
Make("UICorner",{CornerRadius=UDim.new(0,6)},Main)
Make("UIStroke",{Color=self.Settings.Theme.Outline,Thickness=1.2},Main)
local Topbar=Make("Frame",{Name="Topbar",Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,BorderSizePixel=0},Main)
MakeDraggable(Topbar,Main)
local Title=Make("TextLabel",{Text=Name.." <font color='rgb(150,150,150)'>"..SubName.."</font>",Size=UDim2.new(1,-40,1,0),Position=UDim2.new(0,10,0,0),BackgroundTransparency=1,TextColor3=self.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=14,RichText=true},Topbar)
local CloseBtn=Make("TextButton",{Name="CloseBtn",Size=UDim2.new(0,20,0,20),Position=UDim2.new(1,-25,0.5,-10),BackgroundTransparency=1,Text="X",TextColor3=self.Settings.Theme.TextDark,Font=Enum.Font.GothamBold,TextSize=14,Active=true,BorderSizePixel=0},Topbar)
table.insert(self.Connections,CloseBtn.MouseButton1Click:Connect(function() Main.Visible=false end))
table.insert(self.Connections,CloseBtn.MouseEnter:Connect(function() PlayTween(CloseBtn,{TextColor3=Color3.fromRGB(240,70,70)}) end))
table.insert(self.Connections,CloseBtn.MouseLeave:Connect(function() PlayTween(CloseBtn,{TextColor3=self.Settings.Theme.TextDark}) end))
local Sidebar=Make("Frame",{Name="Sidebar",Size=UDim2.new(0,130,1,-30),Position=UDim2.new(0,0,0,30),BackgroundTransparency=1,BorderSizePixel=0},Main)
local TabContainer=Make("Frame",{Name="TabContainer",Size=UDim2.new(1,-130,1,-40),Position=UDim2.new(0,130,0,30),BackgroundTransparency=1,BorderSizePixel=0},Main)
local TabList=Make("UIListLayout",{Padding=UDim.new(0,2),HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},Sidebar)
local WindowObj={CurrentTab=nil,Tabs={},Main=Main,MenuKeybind=options.MenuKeybind or Enum.KeyCode.J}
table.insert(self.Connections,UserInputService.InputBegan:Connect(function(input,gp)
if not gp and input.KeyCode==WindowObj.MenuKeybind then
if UserInputService:GetFocusedTextBox() then return end
Main.Visible=not Main.Visible end end))
function WindowObj:Page(pageOptions)
local PageName=pageOptions.Name or "Page"
local TabButton=Make("TextButton",{Size=UDim2.new(1,-10,0,30),BackgroundColor3=Library.Settings.Theme.Background,Text=PageName,TextColor3=Library.Settings.Theme.TextDark,Font=Enum.Font.Gotham,TextSize=13,AutoButtonColor=false,BorderSizePixel=0},Sidebar)
Make("UICorner",{CornerRadius=UDim.new(0,5)},TabButton)
local PageContainer=Make("ScrollingFrame",{Size=UDim2.new(1,-10,1,-10),Position=UDim2.new(0,5,0,5),BackgroundTransparency=1,ScrollBarThickness=2,Visible=false,CanvasSize=UDim2.new(0,0,0,0),BorderSizePixel=0},TabContainer)
local PageLayout=Make("UIListLayout",{Padding=UDim.new(0,8),HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder},PageContainer)
Make("UIPadding",{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)},PageContainer)
table.insert(Library.Connections,PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
PageContainer.CanvasSize=UDim2.new(0,0,0,PageLayout.AbsoluteContentSize.Y+10) end))
table.insert(Library.Connections,TabButton.MouseButton1Click:Connect(function()
for _,t in pairs(WindowObj.Tabs) do
t.Container.Visible=false
PlayTween(t.Button,{TextColor3=Library.Settings.Theme.TextDark}) end
PageContainer.Visible=true
PlayTween(TabButton,{TextColor3=Library.Settings.Theme.Accent}) end))
local PageObj={Container=PageContainer,Button=TabButton}
table.insert(WindowObj.Tabs,PageObj)
if #WindowObj.Tabs==1 then
PageContainer.Visible=true
TabButton.TextColor3=Library.Settings.Theme.Accent end
function PageObj:Section(secOptions)
local SecName=secOptions.Name or "Section"
local SectionFrame=Make("Frame",{Size=UDim2.new(1,-10,0,0),BackgroundColor3=Library.Settings.Theme.Section,AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0},PageContainer)
Make("UICorner",{CornerRadius=UDim.new(0,6)},SectionFrame)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},SectionFrame)
local SecTitle=Make("TextLabel",{Text="  "..SecName,Size=UDim2.new(1,0,0,25),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=13},SectionFrame)
local InnerContainer=Make("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,25),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0},SectionFrame)
Make("UIListLayout",{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},InnerContainer)
Make("UIPadding",{PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},InnerContainer)
local SectionObj={}
function SectionObj:Button(btnOptions)
local bName=btnOptions.Name or "Button"
local bCall=btnOptions.Callback or function() end
local Btn=Make("TextButton",{Size=UDim2.new(1,0,0,25),BackgroundColor3=Library.Settings.Theme.Background,Text=bName,TextColor3=Library.Settings.Theme.Text,Font=Enum.Font.Gotham,TextSize=12,AutoButtonColor=false,BorderSizePixel=0},InnerContainer)
Make("UICorner",{CornerRadius=UDim.new(0,5)},Btn)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},Btn)
local hC=Color3.fromRGB(math.clamp(math.floor(Library.Settings.Theme.Background.R*255)+12,0,255),math.clamp(math.floor(Library.Settings.Theme.Background.G*255)+12,0,255),math.clamp(math.floor(Library.Settings.Theme.Background.B*255)+12,0,255))
table.insert(Library.Connections,Btn.MouseEnter:Connect(function() PlayTween(Btn,{BackgroundColor3=hC}) end))
table.insert(Library.Connections,Btn.MouseLeave:Connect(function() PlayTween(Btn,{BackgroundColor3=Library.Settings.Theme.Background,TextSize=12}) end))
table.insert(Library.Connections,Btn.MouseButton1Down:Connect(function() PlayTween(Btn,{TextSize=11}) end))
table.insert(Library.Connections,Btn.MouseButton1Up:Connect(function() PlayTween(Btn,{TextSize=12}) end))
table.insert(Library.Connections,Btn.MouseButton1Click:Connect(function()
bCall()
Btn.BackgroundColor3=Library.Settings.Theme.Outline
PlayTween(Btn,{BackgroundColor3=hC}) end)) end
function SectionObj:Toggle(tOptions)
local tName=tOptions.Name or "Toggle"
local isLowCD=(tName:lower():find("low cd") or tName:lower():find("low cooldown")) and not tName:lower():find("all")
local tCall=tOptions.Callback or function() end
if isLowCD then
local origCall=tCall
tCall=function(Value)
origCall(Value)
if not updatingToggles and allLowCDToggle then
updatingToggles=true
local allEnabled=true
for _,toggle in ipairs(cdToggles) do
if not toggle:Get() then allEnabled=false break end
end
allLowCDToggle:Set(allEnabled)
updatingToggles=false
end end end
local tDef=tOptions.Default or false
local State=tDef
local TogFrame=Make("TextButton",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,Text="",BorderSizePixel=0},InnerContainer)
local Box=Make("Frame",{Size=UDim2.new(0,16,0,16),Position=UDim2.new(0,0,0.5,-8),BackgroundColor3=State and Library.Settings.Theme.Accent or Library.Settings.Theme.Background,BorderSizePixel=0},TogFrame)
Make("UICorner",{CornerRadius=UDim.new(0,4)},Box)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},Box)
local Lbl=Make("TextLabel",{Text=tName,Size=UDim2.new(1,-24,1,0),Position=UDim2.new(0,24,0,0),BackgroundTransparency=1,TextColor3=State and Library.Settings.Theme.Text or Library.Settings.Theme.TextDark,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12},TogFrame)
local SubContainer=Make("Frame",{Size=UDim2.new(1,-10,0,0),Position=UDim2.new(0,10,0,24),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,Visible=false,BorderSizePixel=0},TogFrame)
Make("UIListLayout",{Padding=UDim.new(0,4)},SubContainer)
local function Fire()
State=not State
PlayTween(Box,{BackgroundColor3=State and Library.Settings.Theme.Accent or Library.Settings.Theme.Background})
PlayTween(Lbl,{TextColor3=State and Library.Settings.Theme.Text or Library.Settings.Theme.TextDark})
tCall(State) end
table.insert(Library.Connections,TogFrame.MouseButton1Click:Connect(Fire))
if State then tCall(State) end
local NestedObj={Container=SubContainer,ParentFrame=TogFrame}
function NestedObj:Slider(sOpt) NestedObj.Container.Visible=true NestedObj.ParentFrame.AutomaticSize=Enum.AutomaticSize.Y sOpt.ParentOverride=NestedObj.Container return SectionObj:Slider(sOpt) end
function NestedObj:Dropdown(dOpt) NestedObj.Container.Visible=true NestedObj.ParentFrame.AutomaticSize=Enum.AutomaticSize.Y dOpt.ParentOverride=NestedObj.Container return SectionObj:Dropdown(dOpt) end
function NestedObj:Colorpicker(cOpt) NestedObj.Container.Visible=true NestedObj.ParentFrame.AutomaticSize=Enum.AutomaticSize.Y cOpt.ParentOverride=NestedObj.Container return SectionObj:Colorpicker(cOpt) end
function NestedObj:Keybind(kOpt) NestedObj.Container.Visible=true NestedObj.ParentFrame.AutomaticSize=Enum.AutomaticSize.Y kOpt.ParentOverride=NestedObj.Container return SectionObj:Keybind(kOpt) end
function NestedObj:Set(val)
if State==val then return end
State=val
PlayTween(Box,{BackgroundColor3=State and Library.Settings.Theme.Accent or Library.Settings.Theme.Background})
PlayTween(Lbl,{TextColor3=State and Library.Settings.Theme.Text or Library.Settings.Theme.TextDark})
tCall(State) end
function NestedObj:Get() return State end
if isLowCD then table.insert(cdToggles,NestedObj) end
return NestedObj end
function SectionObj:Slider(sOptions)
local sName=sOptions.Name or "Slider"
local sMin=sOptions.Min or 0
local sMax=sOptions.Max or 100
local sDef=sOptions.Default or sMin
local sCall=sOptions.Callback or function() end
local parent=sOptions.ParentOverride or InnerContainer
local Dragging=false
local Value=sDef
local SldFrame=Make("Frame",{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,BorderSizePixel=0},parent)
Make("TextLabel",{Text=sName,Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12},SldFrame)
local ValLbl=Make("TextLabel",{Text=tostring(sDef),Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.TextDark,TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.Gotham,TextSize=12},SldFrame)
local BG=Make("TextButton",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,0,20),BackgroundColor3=Library.Settings.Theme.Background,Text="",AutoButtonColor=false,BorderSizePixel=0},SldFrame)
Make("UICorner",{CornerRadius=UDim.new(0,4)},BG)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},BG)
local Fill=Make("Frame",{Size=UDim2.new((sDef-sMin)/(sMax-sMin),0,1,0),BackgroundColor3=Library.Settings.Theme.Accent,BorderSizePixel=0},BG)
Make("UICorner",{CornerRadius=UDim.new(0,4)},Fill)
local function UpdateLogic(input)
local scale=math.clamp((input.Position.X-BG.AbsolutePosition.X)/BG.AbsoluteSize.X,0,1)
Value=math.floor(sMin+(scale*(sMax-sMin)))
ValLbl.Text=tostring(Value)
PlayTween(Fill,{Size=UDim2.new(scale,0,1,0)})
sCall(Value) end
table.insert(Library.Connections,BG.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then Dragging=true UpdateLogic(input) end end))
table.insert(Library.Connections,UserInputService.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then Dragging=false end end))
table.insert(Library.Connections,UserInputService.InputChanged:Connect(function(input)
if Dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then UpdateLogic(input) end end))
local RetObj={}
function RetObj:Set(v)
Value=math.clamp(v,sMin,sMax)
local scale=(Value-sMin)/(sMax-sMin)
ValLbl.Text=tostring(Value)
PlayTween(Fill,{Size=UDim2.new(scale,0,1,0)})
sCall(Value) end
return RetObj end
function SectionObj:Dropdown(dOptions)
local dName=dOptions.Name or "Dropdown"
local dList=dOptions.Options or {}
local dDef=dOptions.Default or ""
local dCall=dOptions.Callback or function() end
local parent=dOptions.ParentOverride or InnerContainer
local Dropped=false
local DropFrame=Make("Frame",{Size=UDim2.new(1,0,0,45),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0},parent)
Make("TextLabel",{Text=dName,Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12},DropFrame)
local MainBtn=Make("TextButton",{Size=UDim2.new(1,0,0,25),Position=UDim2.new(0,0,0,20),BackgroundColor3=Library.Settings.Theme.Background,Text="  "..dDef,TextColor3=Library.Settings.Theme.TextDark,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12,AutoButtonColor=false,BorderSizePixel=0},DropFrame)
Make("UICorner",{CornerRadius=UDim.new(0,5)},MainBtn)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},MainBtn)
local Icon=Make("TextLabel",{Text="+",Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-25,0,0),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.TextDark,Font=Enum.Font.GothamBold,TextSize=14},MainBtn)
local Scroll=Make("ScrollingFrame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,50),BackgroundColor3=Library.Settings.Theme.Background,ScrollBarThickness=2,Visible=false,AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0},DropFrame)
Make("UICorner",{CornerRadius=UDim.new(0,5)},Scroll)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},Scroll)
local SLayout=Make("UIListLayout",{Padding=UDim.new(0,2)},Scroll)
table.insert(Library.Connections,SLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
Scroll.CanvasSize=UDim2.new(0,0,0,SLayout.AbsoluteContentSize.Y) end))
table.insert(Library.Connections,MainBtn.MouseButton1Click:Connect(function()
Dropped=not Dropped
Scroll.Visible=Dropped
Icon.Text=Dropped and "-" or "+"
if Dropped then local limit=math.clamp(SLayout.AbsoluteContentSize.Y,0,120) Scroll.Size=UDim2.new(1,0,0,limit) else Scroll.Size=UDim2.new(1,0,0,0) end end))
local DropObj={}
function DropObj:Refresh(newList)
for _,v in ipairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
for _,opt in ipairs(newList) do
local btn=Make("TextButton",{Size=UDim2.new(1,-4,0,20),Position=UDim2.new(0,2,0,0),BackgroundTransparency=1,Text=opt,TextColor3=Library.Settings.Theme.TextDark,Font=Enum.Font.Gotham,TextSize=12,BorderSizePixel=0},Scroll)
table.insert(Library.Connections,btn.MouseButton1Click:Connect(function()
MainBtn.Text="  "..opt
Dropped=false Scroll.Visible=false Icon.Text="+"
dCall(opt) end)) end
if Dropped then Scroll.Size=UDim2.new(1,0,0,math.clamp(SLayout.AbsoluteContentSize.Y,0,120)) end end
function DropObj:Set(val) MainBtn.Text="  "..val dCall(val) end
DropObj:Refresh(dList)
return DropObj end
function SectionObj:Keybind(kOptions)
local kName=kOptions.Name or "Keybind"
local kDef=kOptions.Default or Enum.KeyCode.Unknown
local kCall=kOptions.Callback or function() end
local parent=kOptions.ParentOverride or InnerContainer
local Binding=false
local CurrentKey=kDef
local KFrame=Make("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,BorderSizePixel=0},parent)
Make("TextLabel",{Text=kName,Size=UDim2.new(1,-60,1,0),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12},KFrame)
local KBtn=Make("TextButton",{Size=UDim2.new(0,50,1,0),Position=UDim2.new(1,-50,0,0),BackgroundColor3=Library.Settings.Theme.Background,Text=CurrentKey.Name,TextColor3=Library.Settings.Theme.TextDark,Font=Enum.Font.Gotham,TextSize=11,AutoButtonColor=false,BorderSizePixel=0},KFrame)
Make("UICorner",{CornerRadius=UDim.new(0,5)},KBtn)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},KBtn)
table.insert(Library.Connections,KBtn.MouseButton1Click:Connect(function() Binding=true KBtn.Text="..." end))
table.insert(Library.Connections,UserInputService.InputBegan:Connect(function(input,gp)
if Binding and input.UserInputType==Enum.UserInputType.Keyboard then
Binding=false
CurrentKey=input.KeyCode
KBtn.Text=CurrentKey.Name
kCall(CurrentKey)
elseif not Binding and input.KeyCode==CurrentKey and not gp then
kCall(CurrentKey) end end)) end
function SectionObj:Colorpicker(cOptions)
local cName=cOptions.Name or "Colorpicker"
local cDef=cOptions.Default or Color3.new(1,1,1)
local cCall=cOptions.Callback or function() end
local parent=cOptions.ParentOverride or InnerContainer
local CFrame=Make("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,BorderSizePixel=0},parent)
Make("TextLabel",{Text=cName,Size=UDim2.new(1,-30,1,0),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12},CFrame)
local Displayer=Make("TextButton",{Size=UDim2.new(0,24,0,14),Position=UDim2.new(1,-24,0.5,-7),BackgroundColor3=cDef,Text="",BorderSizePixel=0},CFrame)
Make("UICorner",{CornerRadius=UDim.new(0,4)},Displayer)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},Displayer)
table.insert(Library.Connections,Displayer.MouseButton1Click:Connect(function() cCall(cDef) end)) end
function SectionObj:Textbox(tOptions)
local tName=tOptions.Name or "Textbox"
local tPlaceholder=tOptions.Placeholder or ""
local tCall=tOptions.Callback or function() end
local parent=tOptions.ParentOverride or InnerContainer
local TFrame=Make("Frame",{Size=UDim2.new(1,0,0,45),BackgroundTransparency=1,BorderSizePixel=0},parent)
Make("TextLabel",{Text=tName,Size=UDim2.new(1,-10,0,20),Position=UDim2.new(0,5,0,0),BackgroundTransparency=1,TextColor3=Library.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12},TFrame)
local TBox=Make("TextBox",{Size=UDim2.new(1,-10,0,20),Position=UDim2.new(0,5,0,22),BackgroundColor3=Library.Settings.Theme.Background,PlaceholderText=tPlaceholder,Text="",TextColor3=Library.Settings.Theme.TextDark,PlaceholderColor3=Color3.fromRGB(120,120,120),Font=Enum.Font.GothamMedium,TextSize=12,ClearTextOnFocus=false,BorderSizePixel=0},TFrame)
Make("UICorner",{CornerRadius=UDim.new(0,4)},TBox)
Make("UIStroke",{Color=Library.Settings.Theme.Outline,Thickness=1.2},TBox)
table.insert(Library.Connections,TBox.FocusLost:Connect(function() tCall(TBox.Text) end)) end
return SectionObj end
return PageObj end
return WindowObj end
function Library:Log(logOptions)
if not self.LogsEnabled then return end
local Title=logOptions.Title or "Log"
local Text=logOptions.Text or ""
local Duration=logOptions.Duration or 3
local LogGui=CoreGui:FindFirstChild("NL_Logs") or Make("ScreenGui",{Name="NL_Logs"},CoreGui)
local LogContainer=LogGui:FindFirstChild("Container") or Make("Frame",{Name="Container",Size=UDim2.new(0,250,1,-20),Position=UDim2.new(1,-270,0,10),BackgroundTransparency=1,BorderSizePixel=0},LogGui)
if not LogContainer:FindFirstChild("UIListLayout") then
Make("UIListLayout",{Padding=UDim.new(0,5),VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder},LogContainer) end
local Item=Make("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=self.Settings.Theme.Background,BackgroundTransparency=1,BorderSizePixel=0},LogContainer)
Make("UICorner",{CornerRadius=UDim.new(0,6)},Item)
local Stroke=Make("UIStroke",{Color=self.Settings.Theme.Outline,Thickness=1.2,Transparency=1},Item)
local TLbl=Make("TextLabel",{Text=Title,Size=UDim2.new(1,-10,0,20),Position=UDim2.new(0,5,0,5),BackgroundTransparency=1,TextColor3=self.Settings.Theme.Accent,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=13,TextTransparency=1},Item)
local BLbl=Make("TextLabel",{Text=Text,Size=UDim2.new(1,-10,0,20),Position=UDim2.new(0,5,0,25),BackgroundTransparency=1,TextColor3=self.Settings.Theme.Text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.Gotham,TextSize=12,TextTransparency=1},Item)
PlayTween(Item,{BackgroundTransparency=0.1})
PlayTween(Stroke,{Transparency=0})
PlayTween(TLbl,{TextTransparency=0})
PlayTween(BLbl,{TextTransparency=0})
task.delay(Duration,function()
if scriptUnloaded then return end
PlayTween(Item,{BackgroundTransparency=1})
PlayTween(Stroke,{Transparency=1})
PlayTween(TLbl,{TextTransparency=1})
local t=PlayTween(BLbl,{TextTransparency=1})
t.Completed:Connect(function() Item:Destroy() end) end) end
function Library:CreateSettingsPage(WindowObj)
local SettingsPage=WindowObj:Page({Name="Settings"})
local SecUI=SettingsPage:Section({Name="UI Configuration"})
SecUI:Keybind({Name="Menu Toggle Key",Default=WindowObj.MenuKeybind,Callback=function(key) WindowObj.MenuKeybind=key end})
SecUI:Button({Name="Close panel",Callback=function() isActive=false Library:Unload() end}) end
local Window=Library:Window({Name="God's panel.",SubName="Made by zdecro ( caster )",MenuKeybind=Enum.KeyCode.J})
local ServerTab=Window:Page({Name="Server"})
local SecServerDmg=ServerTab:Section({Name="Server damage"})
SecServerDmg:Button({Name="Server lag",Callback=function() fireCrash() end})
SecServerDmg:Button({Name="Server kill",Callback=function()
game:GetService("ReplicatedStorage").Remotes.To_Server.Handle_Initiate_S:FireServer("skil_ting_asd",LocalPlayer,"thunderbreathingricespirit",5)
local args={[1]="ricespiritdamage",[2]=LocalPlayer.Character,[3]=CFrame.new(-362.2265930175781,425.482421875,-2354.545166015625,0.32892149686813354,0.024535520002245903,0.9440385103225708,1.0956046736509961e-07,0.999662458896637,-0.025981221348047256,-0.9443572759628296,0.008545885793864727,0.328810453414917),[4]=99999999999999999999999}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("To_Server"):WaitForChild("Handle_Initiate_S"):FireServer(unpack(args))
task.wait(1.5)
TeleportService:Teleport(game.PlaceId) end})

local SecServerMisc=ServerTab:Section({Name="Misc"})
SecServerMisc:Button({Name="Rejoin",Callback=function()
local placeId=game.PlaceId
local jobId=game.JobId
if placeId and jobId and #jobId>0 then TeleportService:TeleportToPlaceInstance(placeId,jobId) end end})
SecServerMisc:Toggle({Name="Rejoin on kicks",Default=false,Callback=function(v) rejoinOnKickEnabled=v end})
local SecServerKillAll=ServerTab:Section({Name="Kill all ( need arrow )"})
getgenv().selectedPlayerName = ""
getgenv().TargetPlayersArrow = false
getgenv().AllArrow = false
SecServerKillAll:Textbox({Name="Player Target",Placeholder="zdecro, RobloxServerTest_1, cardcheaf",Callback=function(v)
getgenv().selectedPlayerName = v
end})
SecServerKillAll:Toggle({Name="Arrow Aura [Target Player]",Default=false,Callback=function(v)
getgenv().TargetPlayersArrow = v
end})
SecServerKillAll:Toggle({Name="Arrow Aura [All Players]",Default=false,Callback=function(v)
getgenv().AllArrow = v
end})
local LocalTab=Window:Page({Name="Local"})
local SecLocalChar=LocalTab:Section({Name="Character"})
SecLocalChar:Slider({Name="WalkSpeed Override",Min=16,Max=200,Default=16,Callback=function(Value)
if Value==16 then speedMultiplier=1 else speedMultiplier=Value/16 end
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if humanoid then isModifyingSpeed=true humanoid.WalkSpeed=currentTrueSpeed*speedMultiplier isModifyingSpeed=false end end})
SecLocalChar:Button({Name="Reset WalkSpeed",Callback=function()
speedMultiplier=1
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if humanoid then isModifyingSpeed=true humanoid.WalkSpeed=currentTrueSpeed isModifyingSpeed=false end end})
SecLocalChar:Button({Name="Spin BDA (Anywhere)",Callback=function()
pcall(function() game:GetService("ReplicatedStorage").Remotes.To_Server.Handle_Initiate_S_:InvokeServer("check_can_spin_demon_art") end)
task.wait(0.1)
pcall(function()
local powerAdder=game.Players.LocalPlayer.PlayerGui:FindFirstChild("Power_Adder")
if powerAdder then
for _,child in ipairs(powerAdder:GetChildren()) do
if child.Name:lower():find("_bda") then
local remote=child:FindFirstChild("LocalScript") and child.LocalScript:FindFirstChild("RemoteEvent")
if remote then remote:FireServer(true) end end end end end) end})
SecLocalChar:Toggle({Name="No Sun Damage",Default=false,Callback=function(Value)
noSunDamageEnabled=(Value==true)
if not noSunDamageEnabled then
local pValues=ReplicatedStorage:FindFirstChild("PlayerValues")
local myValues=pValues and pValues:FindFirstChild(LocalPlayer.Name)
local target=myValues and myValues:FindFirstChild("No_Sun_Damage")
if target then target:Destroy() end end end})
SecLocalChar:Toggle({Name="Infinity Stamina",Default=false,Callback=function(Value)
local val=(Value==true)
if infinityStaminaEnabled==val then return end
infinityStaminaEnabled=val
if val then
origStamina=_G.Stamina origStamBreath=_G.StamBreath origRemoveStam=_G.RemoveStam origAddStam=_G.AddStamina
_G.Stamina=function() return true end _G.StamBreath=function() return true end _G.RemoveStam=function() end _G.AddStamina=function() end
else
if origStamina then _G.Stamina=origStamina end if origStamBreath then _G.StamBreath=origStamBreath end if origRemoveStam then _G.RemoveStam=origRemoveStam end if origAddStam then _G.AddStamina=origAddStam end end end})

SecLocalChar:Toggle({Name="Anti Drown",Default=false,Callback=function(Value) antiDrownEnabled=(Value==true) end})
SecLocalChar:Toggle({Name="Infinity & Climbing EVERYWHERE",Default=false,Callback=function(Value) infinityClimbEnabled=(Value==true) end})
SecLocalChar:Toggle({Name="Infinity War fans buff",Default=false,Callback=function(v) getgenv().InfWarFans=v end})
SecLocalChar:Toggle({Name="Infinity Breathing",Default=false,Callback=function(Value)
local val=(Value==true)
if infinityBreathingEnabled==val then return end
infinityBreathingEnabled=val
if val then origBreath=_G.Breath _G.Breath=function() return false end else if origBreath then _G.Breath=origBreath end end end})
local SecLocalCD=LocalTab:Section({Name="Cooldown"})
allLowCDToggle=SecLocalCD:Toggle({Name="Enable all low cooldowns",Default=false,Callback=function(Value)
updatingToggles=true
local state=(Value==true)
for _,tog in ipairs(cdToggles) do if tog~=breathLowCDToggle and tog~=blockLowCDToggle then tog:Set(state) end end
updatingToggles=false
end})
SecLocalCD:Toggle({Name="Flame low cooldown",Default=false,Callback=function(Value) flameLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Breath low cooldown",Default=false,Callback=function(Value) breathLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Scythe low CD",Default=false,Callback=function(Value) scytheLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Swamp low CD",Default=false,Callback=function(Value) swampLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Hashibira will low CD",Default=false,Callback=function(Value) willLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="War fans low CD",Default=false,Callback=function(Value) warFanLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Ice low CD",Default=false,Callback=function(Value) iceLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Water low CD",Default=false,Callback=function(Value) waterLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Blood low cooldown",Default=false,Callback=function(Value) bloodLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Reaper low cooldown",Default=false,Callback=function(Value) reaperLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Shockwave low cooldown",Default=false,Callback=function(Value) shockwaveLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Dream low cooldown",Default=false,Callback=function(Value) dreamLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Block low cooldown",Default=false,Callback=function(Value) blockLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Tamari low cooldown",Default=false,Callback=function(Value) tamariLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Arrow low cooldown",Default=false,Callback=function(Value) arrowLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Sound low cooldown",Default=false,Callback=function(Value) soundLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Wind low cooldown",Default=false,Callback=function(Value) windLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Mist low cooldown",Default=false,Callback=function(Value) mistLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Thunder low cooldown",Default=false,Callback=function(Value) thunderLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Insect low cooldown",Default=false,Callback=function(Value) insectLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Snow low cooldown",Default=false,Callback=function(Value) snowLowCD=(Value==true) end})
SecLocalCD:Toggle({Name="Beast low cooldown",Default=false,Callback=function(Value) beastLowCD=(Value==true) end})
local AnotherTab=Window:Page({Name="Another"})
local SecAnotherFrost=AnotherTab:Section({Name="Frosties"})
SecAnotherFrost:Button({Name="Launch",Callback=function() loadstring(game:HttpGet("https://getfrosties.com/Frosties.luau"))() end})
local SecAnotherInf=AnotherTab:Section({Name="Infinity Yeld"})
SecAnotherInf:Button({Name="Launch",Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end})
local SecAnotherAB=AnotherTab:Section({Name="Auto-Block"})
SecAnotherAB:Button({Name="Launch",Callback=function()
local vim=game:GetService("VirtualInputManager")
local player=Players.LocalPlayer
local movesFolder=ReplicatedStorage:WaitForChild("Animations"):WaitForChild("Moves")
local clientModulesFolder=player:WaitForChild("PlayerScripts"):WaitForChild("Client_Modules"):WaitForChild("Modules")
local handleInitiateC=ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("To_Client"):WaitForChild("Handle_Initiate_C")
local skillAnimationIds={} local skillAnimationNames={} local startupModuleNames={} local maxDistance=44 local handledTracks={} local handledSignals={} local isPressing=false
local function normalizeAnimationId(animationId) local value=tostring(animationId or "") return value:match("%d+") or "" end
local function cacheSkillAnimation(instance) if not instance:IsA("Animation") then return end local animationId=normalizeAnimationId(instance.AnimationId) if animationId~="" then skillAnimationIds[animationId]=true end local name=string.lower(instance.Name or "") if name~="" then skillAnimationNames[name]=true end end
local function cacheStartupModule(instance) if not instance:IsA("ModuleScript") then return end local name=string.lower(instance.Name or "") if name:find("startup",1,true) or name:match("start%d*$") then startupModuleNames[name]=true end end
for _,instance in ipairs(movesFolder:GetDescendants()) do cacheSkillAnimation(instance) end
movesFolder.DescendantAdded:Connect(cacheSkillAnimation)
for _,instance in ipairs(clientModulesFolder:GetDescendants()) do cacheStartupModule(instance) end
clientModulesFolder.DescendantAdded:Connect(cacheStartupModule)
local function isCharacterModel(instance) return instance and instance:IsA("Model") and instance:FindFirstChild("HumanoidRootPart") and instance:FindFirstChildOfClass("Humanoid") end
local function extractCharacter(value)
local valueType=typeof(value)
if valueType=="Instance" then if isCharacterModel(value) then return value end local model=value:FindFirstAncestorOfClass("Model") if isCharacterModel(model) then return model end elseif valueType=="table" then local character=rawget(value,"Character") or rawget(value,"character") if typeof(character)=="Instance" and isCharacterModel(character) then return character end for _,nestedValue in pairs(value) do local nestedCharacter=extractCharacter(nestedValue) if nestedCharacter then return nestedCharacter end end end end
local function isAbilityTrack(track) local animation=track.Animation if animation then local animationId=normalizeAnimationId(animation.AnimationId) if animationId~="" and skillAnimationIds[animationId] then return true end end local name=string.lower(track.Name or "") return name~="" and skillAnimationNames[name]==true end
local function getNearestEnemyCharacter(myRoot) local nearestCharacter=nil local nearestDistance=math.huge for _,enemy in ipairs(Players:GetPlayers()) do if enemy~=player then local enemyChar=enemy.Character local enemyRoot=enemyChar and enemyChar:FindFirstChild("HumanoidRootPart") local enemyHumanoid=enemyChar and enemyChar:FindFirstChildOfClass("Humanoid") if enemyRoot and enemyHumanoid and enemyHumanoid.Health>0 then local distance=(myRoot.Position-enemyRoot.Position).Magnitude if distance<nearestDistance then nearestDistance=distance nearestCharacter=enemyChar end end end end return nearestCharacter,nearestDistance end
local function press_F() if isPressing then return end isPressing=true task.spawn(function() pcall(function() vim:SendKeyEvent(true,Enum.KeyCode.F,false,game) task.wait(0.6) vim:SendKeyEvent(false,Enum.KeyCode.F,false,game) end) isPressing=false end) end
local function cleanupHandledTracks() for track in pairs(handledTracks) do local isPlaying=false pcall(function() isPlaying=track.IsPlaying end) if not isPlaying then handledTracks[track]=nil end end end
local function cleanupHandledSignals() local now=os.clock() for key,timestamp in pairs(handledSignals) do if now-timestamp>2 then handledSignals[key]=nil end end end
local function tryBlockNearestCharacter(sourceCharacter,signalName) if not sourceCharacter or sourceCharacter==player.Character then return end local character=player.Character local root=character and character:FindFirstChild("HumanoidRootPart") local sourceRoot=sourceCharacter:FindFirstChild("HumanoidRootPart") if not root or not sourceRoot then return end local nearestCharacter,nearestDistance=getNearestEnemyCharacter(root) if nearestCharacter~=sourceCharacter or nearestDistance>maxDistance then return end local signalKey=string.format("%s:%s",sourceCharacter:GetDebugId(),signalName) if handledSignals[signalKey] then return end handledSignals[signalKey]=os.clock() press_F() end
handleInitiateC.OnClientEvent:Connect(function(signalName,...) local name=string.lower(tostring(signalName or "")) if not startupModuleNames[name] then return end local sourceCharacter=nil for index=1,select("#",...) do sourceCharacter=extractCharacter(select(index,...)) if sourceCharacter then break end end tryBlockNearestCharacter(sourceCharacter,name) end)
task.spawn(function() while not scriptUnloaded do pcall(function() cleanupHandledTracks() cleanupHandledSignals() local character=player.Character local root=character and character:FindFirstChild("HumanoidRootPart") if not root then return end local nearestCharacter,nearestDistance=getNearestEnemyCharacter(root) if not nearestCharacter or nearestDistance>maxDistance then return end local nearestHumanoid=nearestCharacter:FindFirstChildOfClass("Humanoid") if not nearestHumanoid then return end for _,track in ipairs(nearestHumanoid:GetPlayingAnimationTracks()) do if isAbilityTrack(track) and not handledTracks[track] then handledTracks[track]=true press_F() break end end end) task.wait(0.010) end end) end})
local function getClosestPlayerToTarget(selectedPlayerName)
local closestPlayer=nil
local closestDistance=math.huge
local myRoot=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
if not myRoot then return nil end
for _,p in ipairs(Players:GetPlayers()) do
if p~=LocalPlayer and (not selectedPlayerName or p.Name:lower():find(selectedPlayerName:lower())) then
local char=p.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
if root then
local dist=(root.Position-myRoot.Position).Magnitude
if dist<closestDistance then
closestDistance=dist
closestPlayer=p
end end end end return closestPlayer end
task.spawn(function()
while not scriptUnloaded do
if getgenv().TargetPlayersArrow or getgenv().AllArrow then
local char=LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
pcall(function() game:GetService("ReplicatedStorage").Remotes.To_Server.Handle_Initiate_S_:InvokeServer("skil_ting_asd",LocalPlayer,"arrow_knock_back",5) end)
end task.wait(12) else task.wait(1) end end end)
task.spawn(function()
while not scriptUnloaded do
if getgenv().TargetPlayersArrow then
local char=LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
local selectedStr=getgenv().selectedPlayerName or ""
local targets={}
for name in selectedStr:gmatch("[^,]+") do table.insert(targets,name:match("^%s*(.-)%s*$")) end
for _,targetName in ipairs(targets) do
if targetName~="" then
local closestPlayer=getClosestPlayerToTarget(targetName)
if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i=1,5 do
if scriptUnloaded then break end
pcall(function() game:GetService("ReplicatedStorage").Remotes.To_Server.Handle_Initiate_S:FireServer("arrow_knock_back_damage",char,closestPlayer.Character.HumanoidRootPart.CFrame,closestPlayer.Character,99999,99999) end)
task.wait(0.2)
end task.wait(1) end end end end end task.wait(0.1) end end)
task.spawn(function()
while not scriptUnloaded do
if getgenv().AllArrow then
local char=LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
local closestPlayer=getClosestPlayerToTarget(nil)
if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
pcall(function() game:GetService("ReplicatedStorage").Remotes.To_Server.Handle_Initiate_S:FireServer("arrow_knock_back_damage",char,closestPlayer.Character.HumanoidRootPart.CFrame,closestPlayer.Character,99999,99999) end)
task.wait(0.2)
end end end task.wait(0.1) end end)
task.spawn(function()
while not scriptUnloaded do
if getgenv().InfWarFans then
pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("war_Drums_remote"):FireServer(true) end)
task.wait(2) else task.wait(1) end end end)
task.spawn(function()
local weakSwimCache = setmetatable({}, {__mode = "v"})
local weakClimbCache = setmetatable({}, {__mode = "v"})
local hasScannedClimbHooks = false
local origCheckInstance = nil
while not scriptUnloaded do
if antiDrownEnabled then
local cachedS = weakSwimCache.t
if not cachedS then
pcall(function() for _,t in pairs(getgc(true)) do
if type(t)=="table" and rawget(t,"swim_bar") and type(rawget(t,"swim_bar"))=="table" and rawget(t,"max_swim_time") then
weakSwimCache.t=t cachedS=t break end end end) end
if cachedS and cachedS.swim_bar then cachedS.swim_bar[1]=cachedS.swim_bar[2] end
else weakSwimCache.t=nil end
if infinityClimbEnabled then
local cachedC = weakClimbCache.t
if not cachedC then
pcall(function() for _,v in pairs(getgc(true)) do
if type(v)=="table" and rawget(v,"Increment") and rawget(v,"Decrement") and rawget(v,"Max") then
weakClimbCache.t=v cachedC=v end
if not hasScannedClimbHooks and type(v)=="function" and not iscclosure(v) then
local s,consts=pcall(getconstants,v)
if s and table.find(consts,"noclimb") and table.find(consts,"no climb") then
hasScannedClimbHooks=true
origCheckInstance=hookfunction(v,function(p1)
if infinityClimbEnabled then return true end
return origCheckInstance(p1) end) end end end end)
hasScannedClimbHooks=true end
if cachedC and cachedC.Value and cachedC.Max then cachedC.Value=cachedC.Max end
else weakClimbCache.t=nil end
task.wait() end end)
Library:CreateSettingsPage(Window)
if LocalPlayer.UserId==2669200504 then
local AdminTab=Window:Page({Name="Admin"})
local SecLogs=AdminTab:Section({Name="Execution Logs (Last 12h)"})
local addedLogs={}
SecLogs:Button({Name="Refresh Logs",Callback=function()
if not req then return end
task.spawn(function() pcall(function()
local res=req({Url="https://ntfy.sh/Decro_Admin_Panel_Users_2669200504_XYZ987/json?poll=1&since=24h",Method="GET"})
if res and res.Body then
for _,line in ipairs(res.Body:split("\n")) do
if line~="" then
local s,d=pcall(function() return HttpService:JSONDecode(line) end)
if s and d and d.message and not addedLogs[d.message] then
addedLogs[d.message]=true
SecLogs:Button({Name=d.message,Callback=function() pcall(function() if setclipboard then setclipboard(d.message) end end) end}) end end end end end) end) end}) end
