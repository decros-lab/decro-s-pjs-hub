local Library = {
    LogsEnabled = true,
    CurrentScale = 1,
    Connections = {},
    Instances = {},
    Settings = {Theme = {
        Background = Color3.fromRGB(12, 12, 12),
        Section = Color3.fromRGB(18, 18, 18),
        Outline = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(0, 168, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(150, 150, 150)
    }}
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local DefaultTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function Make(class, props, parent)
    local instance = Instance.new(class)
    for k, v in pairs(props) do
        instance[k] = v
    end
    if parent then instance.Parent = parent end
    table.insert(Library.Instances, instance)
    return instance
end

local function PlayTween(instance, goal)
    local tween = TweenService:Create(instance, DefaultTween, goal)
    tween:Play()
    return tween
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        object.Position = pos
    end
    
    table.insert(Library.Connections, topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    local screenSize = object.Parent.AbsoluteSize
                    local objCenter = object.AbsolutePosition + (object.AbsoluteSize / 2)
                    local screenCenter = screenSize / 2
                    if (objCenter - screenCenter).Magnitude < 30 then
                        PlayTween(object, {Position = UDim2.new(0.5, 0, 0.5, 0)})
                    end
                end
            end)
        end
    end))
    
    table.insert(Library.Connections, topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end))
    
    table.insert(Library.Connections, UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end))
end

function Library:Unload()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    for _, inst in ipairs(self.Instances) do
        if inst and inst.Parent then
            inst:Destroy()
        end
    end
    self.Connections = {}
    self.Instances = {}
end

function Library:Window(options)
    local Name = options.Name or "Window"
    local SubName = options.SubName or ""
    local MenuKeybind = options.MenuKeybind or Enum.KeyCode.RightShift
    
    local ScreenGui = Make("ScreenGui", {Name = Name, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Global}, CoreGui)
    local Scale = Make("UIScale", {Scale = self.CurrentScale}, ScreenGui)
    
    local Main = Make("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Settings.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }, ScreenGui)
    
    Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Main)
    Make("UIStroke", {Color = self.Settings.Theme.Outline, Thickness = 1}, Main)
    
    local Topbar = Make("Frame", {
        Name = "Topbar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
    }, Main)
    MakeDraggable(Topbar, Main)
    
    local Title = Make("TextLabel", {
        Text = Name .. " <font color='rgb(150,150,150)'>" .. SubName .. "</font>",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = self.Settings.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        RichText = true
    }, Topbar)
    
    local Sidebar = Make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 130, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1
    }, Main)
    
    local TabContainer = Make("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -130, 1, -40),
        Position = UDim2.new(0, 130, 0, 30),
        BackgroundTransparency = 1
    }, Main)
    
    local TabList = Make("UIListLayout", {
        Padding = UDim.new(0, 2),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Sidebar)
    
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == MenuKeybind then
            Main.Visible = not Main.Visible
        end
    end))
    
    local WindowObj = {
        CurrentTab = nil,
        Tabs = {}
    }
    
    function WindowObj:Page(pageOptions)
        local PageName = pageOptions.Name or "Page"
        
        local TabButton = Make("TextButton", {
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = Library.Settings.Theme.Background,
            Text = PageName,
            TextColor3 = Library.Settings.Theme.TextDark,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            AutoButtonColor = false
        }, Sidebar)
        Make("UICorner", {CornerRadius = UDim.new(0, 4)}, TabButton)
        
        local PageContainer = Make("ScrollingFrame", {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, TabContainer)
        
        local PageLayout = Make("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, PageContainer)
        
        table.insert(Library.Connections, PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageContainer.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end))
        
        table.insert(Library.Connections, TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(WindowObj.Tabs) do
                t.Container.Visible = false
                PlayTween(t.Button, {TextColor3 = Library.Settings.Theme.TextDark})
            end
            PageContainer.Visible = true
            PlayTween(TabButton, {TextColor3 = Library.Settings.Theme.Accent})
        end))
        
        local PageObj = {Container = PageContainer, Button = TabButton}
        table.insert(WindowObj.Tabs, PageObj)
        if #WindowObj.Tabs == 1 then
            PageContainer.Visible = true
            TabButton.TextColor3 = Library.Settings.Theme.Accent
        end
        
        function PageObj:Section(secOptions)
            local SecName = secOptions.Name or "Section"
            
            local SectionFrame = Make("Frame", {
                Size = UDim2.new(1, -10, 0, 0),
                BackgroundColor3 = Library.Settings.Theme.Section,
                AutomaticSize = Enum.AutomaticSize.Y
            }, PageContainer)
            Make("UICorner", {CornerRadius = UDim.new(0, 4)}, SectionFrame)
            Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, SectionFrame)
            
            local SecTitle = Make("TextLabel", {
                Text = "  " .. SecName,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                TextColor3 = Library.Settings.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                TextSize = 13
            }, SectionFrame)
            
            local InnerContainer = Make("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y
            }, SectionFrame)
            
            Make("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, InnerContainer)
            
            Make("UIPadding", {
                PaddingBottom = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6)
            }, InnerContainer)
            
            local SectionObj = {}
            
            function SectionObj:Button(btnOptions)
                local bName = btnOptions.Name or "Button"
                local bCall = btnOptions.Callback or function() end
                
                local Btn = Make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Library.Settings.Theme.Background,
                    Text = bName,
                    TextColor3 = Library.Settings.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    AutoButtonColor = false
                }, InnerContainer)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Btn)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, Btn)
                
                table.insert(Library.Connections, Btn.MouseButton1Click:Connect(function()
                    bCall()
                    Btn.BackgroundColor3 = Library.Settings.Theme.Outline
                    PlayTween(Btn, {BackgroundColor3 = Library.Settings.Theme.Background})
                end))
            end
            
            function SectionObj:Toggle(tOptions)
                local tName = tOptions.Name or "Toggle"
                local tDef = tOptions.Default or false
                local tCall = tOptions.Callback or function() end
                
                local State = tDef
                
                local TogFrame = Make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = ""
                }, InnerContainer)
                
                local Box = Make("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 0, 0.5, -8),
                    BackgroundColor3 = State and Library.Settings.Theme.Accent or Library.Settings.Theme.Background
                }, TogFrame)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Box)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, Box)
                
                local Lbl = Make("TextLabel", {
                    Text = tName,
                    Size = UDim2.new(1, -24, 1, 0),
                    Position = UDim2.new(0, 24, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = State and Library.Settings.Theme.Text or Library.Settings.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                }, TogFrame)
                
                local SubContainer = Make("Frame", {
                    Size = UDim2.new(1, -10, 0, 0),
                    Position = UDim2.new(0, 10, 0, 24),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Visible = false
                }, TogFrame)
                Make("UIListLayout", {Padding = UDim.new(0, 4)}, SubContainer)
                
                local function Fire()
                    State = not State
                    PlayTween(Box, {BackgroundColor3 = State and Library.Settings.Theme.Accent or Library.Settings.Theme.Background})
                    PlayTween(Lbl, {TextColor3 = State and Library.Settings.Theme.Text or Library.Settings.Theme.TextDark})
                    tCall(State)
                end
                
                table.insert(Library.Connections, TogFrame.MouseButton1Click:Connect(Fire))
                if State then tCall(State) end
                
                local NestedObj = {Container = SubContainer, ParentFrame = TogFrame}
                
                function NestedObj:Slider(sOpt)
                    NestedObj.Container.Visible = true
                    NestedObj.ParentFrame.AutomaticSize = Enum.AutomaticSize.Y
                    sOpt.ParentOverride = NestedObj.Container
                    return SectionObj:Slider(sOpt)
                end
                
                function NestedObj:Dropdown(dOpt)
                    NestedObj.Container.Visible = true
                    NestedObj.ParentFrame.AutomaticSize = Enum.AutomaticSize.Y
                    dOpt.ParentOverride = NestedObj.Container
                    return SectionObj:Dropdown(dOpt)
                end
                
                function NestedObj:Colorpicker(cOpt)
                    NestedObj.Container.Visible = true
                    NestedObj.ParentFrame.AutomaticSize = Enum.AutomaticSize.Y
                    cOpt.ParentOverride = NestedObj.Container
                    return SectionObj:Colorpicker(cOpt)
                end
                
                function NestedObj:Keybind(kOpt)
                    NestedObj.Container.Visible = true
                    NestedObj.ParentFrame.AutomaticSize = Enum.AutomaticSize.Y
                    kOpt.ParentOverride = NestedObj.Container
                    return SectionObj:Keybind(kOpt)
                end
                
                return NestedObj
            end
            
            function SectionObj:Slider(sOptions)
                local sName = sOptions.Name or "Slider"
                local sMin = sOptions.Min or 0
                local sMax = sOptions.Max or 100
                local sDef = sOptions.Default or sMin
                local sCall = sOptions.Callback or function() end
                local parent = sOptions.ParentOverride or InnerContainer
                
                local Dragging = false
                local Value = sDef
                
                local SldFrame = Make("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1
                }, parent)
                
                Make("TextLabel", {
                    Text = sName,
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Settings.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                }, SldFrame)
                
                local ValLbl = Make("TextLabel", {
                    Text = tostring(sDef),
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Settings.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                }, SldFrame)
                
                local BG = Make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 10),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = Library.Settings.Theme.Background,
                    Text = "",
                    AutoButtonColor = false
                }, SldFrame)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, BG)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, BG)
                
                local Fill = Make("Frame", {
                    Size = UDim2.new((sDef - sMin) / (sMax - sMin), 0, 1, 0),
                    BackgroundColor3 = Library.Settings.Theme.Accent,
                    BorderSizePixel = 0
                }, BG)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Fill)
                
                local function UpdateLogic(input)
                    local scale = math.clamp((input.Position.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
                    Value = math.floor(sMin + (scale * (sMax - sMin)))
                    ValLbl.Text = tostring(Value)
                    PlayTween(Fill, {Size = UDim2.new(scale, 0, 1, 0)})
                    sCall(Value)
                end
                
                table.insert(Library.Connections, BG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        UpdateLogic(input)
                    end
                end))
                
                table.insert(Library.Connections, UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end))
                
                table.insert(Library.Connections, UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateLogic(input)
                    end
                end))
                
                local RetObj = {}
                function RetObj:Set(v)
                    Value = math.clamp(v, sMin, sMax)
                    local scale = (Value - sMin) / (sMax - sMin)
                    ValLbl.Text = tostring(Value)
                    PlayTween(Fill, {Size = UDim2.new(scale, 0, 1, 0)})
                    sCall(Value)
                end
                return RetObj
            end
            
            function SectionObj:Dropdown(dOptions)
                local dName = dOptions.Name or "Dropdown"
                local dList = dOptions.Options or {}
                local dDef = dOptions.Default or ""
                local dCall = dOptions.Callback or function() end
                local parent = dOptions.ParentOverride or InnerContainer
                
                local Dropped = false
                
                local DropFrame = Make("Frame", {
                    Size = UDim2.new(1, 0, 0, 45),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y
                }, parent)
                
                Make("TextLabel", {
                    Text = dName,
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Settings.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                }, DropFrame)
                
                local MainBtn = Make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundColor3 = Library.Settings.Theme.Background,
                    Text = "  " .. dDef,
                    TextColor3 = Library.Settings.Theme.TextDark,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    AutoButtonColor = false
                }, DropFrame)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, MainBtn)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, MainBtn)
                
                local Icon = Make("TextLabel", {
                    Text = "+",
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -25, 0, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Settings.Theme.TextDark,
                    Font = Enum.Font.GothamBold,
                    TextSize = 14
                }, MainBtn)
                
                local Scroll = Make("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 50),
                    BackgroundColor3 = Library.Settings.Theme.Background,
                    ScrollBarThickness = 2,
                    Visible = false,
                    AutomaticSize = Enum.AutomaticSize.Y
                }, DropFrame)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Scroll)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, Scroll)
                
                local SLayout = Make("UIListLayout", {Padding = UDim.new(0, 2)}, Scroll)
                
                table.insert(Library.Connections, SLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Scroll.CanvasSize = UDim2.new(0, 0, 0, SLayout.AbsoluteContentSize.Y)
                end))
                
                table.insert(Library.Connections, MainBtn.MouseButton1Click:Connect(function()
                    Dropped = not Dropped
                    Scroll.Visible = Dropped
                    Icon.Text = Dropped and "-" or "+"
                    if Dropped then
                        local limit = math.clamp(SLayout.AbsoluteContentSize.Y, 0, 120)
                        Scroll.Size = UDim2.new(1, 0, 0, limit)
                    else
                        Scroll.Size = UDim2.new(1, 0, 0, 0)
                    end
                end))
                
                local DropObj = {}
                
                function DropObj:Refresh(newList)
                    for _, v in ipairs(Scroll:GetChildren()) do
                        if v:IsA("TextButton") then v:Destroy() end
                    end
                    for _, opt in ipairs(newList) do
                        local btn = Make("TextButton", {
                            Size = UDim2.new(1, -4, 0, 20),
                            Position = UDim2.new(0, 2, 0, 0),
                            BackgroundTransparency = 1,
                            Text = opt,
                            TextColor3 = Library.Settings.Theme.TextDark,
                            Font = Enum.Font.Gotham,
                            TextSize = 12
                        }, Scroll)
                        table.insert(Library.Connections, btn.MouseButton1Click:Connect(function()
                            MainBtn.Text = "  " .. opt
                            Dropped = false
                            Scroll.Visible = false
                            Icon.Text = "+"
                            dCall(opt)
                        end))
                    end
                    if Dropped then Scroll.Size = UDim2.new(1, 0, 0, math.clamp(SLayout.AbsoluteContentSize.Y, 0, 120)) end
                end
                
                function DropObj:Set(val)
                    MainBtn.Text = "  " .. val
                    dCall(val)
                end
                
                DropObj:Refresh(dList)
                return DropObj
            end
            
            function SectionObj:Keybind(kOptions)
                local kName = kOptions.Name or "Keybind"
                local kDef = kOptions.Default or Enum.KeyCode.Unknown
                local kCall = kOptions.Callback or function() end
                local parent = kOptions.ParentOverride or InnerContainer
                
                local Binding = false
                local CurrentKey = kDef
                
                local KFrame = Make("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1
                }, parent)
                
                Make("TextLabel", {
                    Text = kName,
                    Size = UDim2.new(1, -60, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Settings.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                }, KFrame)
                
                local KBtn = Make("TextButton", {
                    Size = UDim2.new(0, 50, 1, 0),
                    Position = UDim2.new(1, -50, 0, 0),
                    BackgroundColor3 = Library.Settings.Theme.Background,
                    Text = CurrentKey.Name,
                    TextColor3 = Library.Settings.Theme.TextDark,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    AutoButtonColor = false
                }, KFrame)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, KBtn)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, KBtn)
                
                table.insert(Library.Connections, KBtn.MouseButton1Click:Connect(function()
                    Binding = true
                    KBtn.Text = "..."
                end))
                
                table.insert(Library.Connections, UserInputService.InputBegan:Connect(function(input, gp)
                    if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        Binding = false
                        CurrentKey = input.KeyCode
                        KBtn.Text = CurrentKey.Name
                        kCall(CurrentKey)
                    elseif not Binding and input.KeyCode == CurrentKey and not gp then
                        kCall(CurrentKey)
                    end
                end))
            end
            
            function SectionObj:Colorpicker(cOptions)
                local cName = cOptions.Name or "Colorpicker"
                local cDef = cOptions.Default or Color3.new(1,1,1)
                local cCall = cOptions.Callback or function() end
                local parent = cOptions.ParentOverride or InnerContainer
                
                local CFrame = Make("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1
                }, parent)
                
                Make("TextLabel", {
                    Text = cName,
                    Size = UDim2.new(1, -30, 1, 0),
                    BackgroundTransparency = 1,
                    TextColor3 = Library.Settings.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 12
                }, CFrame)
                
                local Displayer = Make("TextButton", {
                    Size = UDim2.new(0, 24, 0, 14),
                    Position = UDim2.new(1, -24, 0.5, -7),
                    BackgroundColor3 = cDef,
                    Text = ""
                }, CFrame)
                Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Displayer)
                Make("UIStroke", {Color = Library.Settings.Theme.Outline, Thickness = 1}, Displayer)
                
                table.insert(Library.Connections, Displayer.MouseButton1Click:Connect(function()
                    cCall(cDef)
                end))
            end
            
            return SectionObj
        end
        return PageObj
    end
    return WindowObj
end

function Library:Log(logOptions)
    if not self.LogsEnabled then return end
    local Title = logOptions.Title or "Log"
    local Text = logOptions.Text or ""
    local Duration = logOptions.Duration or 3
    
    local LogGui = CoreGui:FindFirstChild("NL_Logs") or Make("ScreenGui", {Name = "NL_Logs"}, CoreGui)
    local LogContainer = LogGui:FindFirstChild("Container") or Make("Frame", {
        Name = "Container",
        Size = UDim2.new(0, 250, 1, -20),
        Position = UDim2.new(1, -270, 0, 10),
        BackgroundTransparency = 1
    }, LogGui)
    
    if not LogContainer:FindFirstChild("UIListLayout") then
        Make("UIListLayout", {
            Padding = UDim.new(0, 5),
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder
        }, LogContainer)
    end
    
    local Item = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = self.Settings.Theme.Background,
        BackgroundTransparency = 1
    }, LogContainer)
    Make("UICorner", {CornerRadius = UDim.new(0, 4)}, Item)
    local Stroke = Make("UIStroke", {Color = self.Settings.Theme.Outline, Thickness = 1, Transparency = 1}, Item)
    
    local TLbl = Make("TextLabel", {
        Text = Title,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = self.Settings.Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextTransparency = 1
    }, Item)
    
    local BLbl = Make("TextLabel", {
        Text = Text,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        BackgroundTransparency = 1,
        TextColor3 = self.Settings.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextTransparency = 1
    }, Item)
    
    PlayTween(Item, {BackgroundTransparency = 0.1})
    PlayTween(Stroke, {Transparency = 0})
    PlayTween(TLbl, {TextTransparency = 0})
    PlayTween(BLbl, {TextTransparency = 0})
    
    task.delay(Duration, function()
        PlayTween(Item, {BackgroundTransparency = 1})
        PlayTween(Stroke, {Transparency = 1})
        PlayTween(TLbl, {TextTransparency = 1})
        local t = PlayTween(BLbl, {TextTransparency = 1})
        t.Completed:Connect(function() Item:Destroy() end)
    end)
end

function Library:CreateSettingsPage(WindowObj)
    local SettingsPage = WindowObj:Page({Name = "Settings"})
    local SecUI = SettingsPage:Section({Name = "UI Configuration"})
    
    SecUI:Slider({Name = "DPI Scale", Min = 50, Max = 150, Default = 100, Callback = function(v)
        Library.CurrentScale = v / 100
        for _, inst in ipairs(Library.Instances) do
            if inst:IsA("UIScale") then
                inst.Scale = Library.CurrentScale
            end
        end
    end})
    
    SecUI:Button({Name = "Unload UI", Callback = function()
        Library:Unload()
    end})
end

return Library
