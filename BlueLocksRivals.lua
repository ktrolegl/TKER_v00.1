--[[
    Blue Lock Rivals Script
    
    A reliable script for enhancing gameplay in Blue Lock Rivals
    Inspired by implementation patterns from top Roblox scripters
    
    Features:
    - Auto-farming capabilities
    - Player ESP (see players through walls)
    - Auto-training features
    - Character stat enhancement
    - Platform detection (PC/Mobile support)
    - Clean, minimal UI with toggle switches
    
    Developer: Based on request requirements
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Platform Detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local Executor = identifyexecutor and identifyexecutor() or "Unknown"

-- Configuration (Saved Settings)
local SaveFileName = "BlueLocksRivals_Settings.json"
local DefaultSettings = {
    AutoTrain = false,
    AutoFarm = false,
    PlayerESP = false,
    InstantGoal = false,
    InfiniteStamina = false,
    AutoDribble = false,
    UIPosition = UDim2.new(0.8, 0, 0.5, 0),
    UIMinimized = false
}
local Settings = {}

-- UI Library Setup
local Library = {}
local GUI = {}
local Toggles = {}
local Dragging = false
local DragOffset = Vector2.new(0, 0)

-- Error Handling and Reporting
local Debug = {
    Errors = {},
    MaxErrors = 10,
    PrintErrors = true,
    LogErrors = true
}

-- Utility Functions
local function LogError(message, traceback)
    traceback = traceback or debug.traceback()
    
    local errorInfo = {
        Message = message,
        Traceback = traceback,
        Time = os.time(),
        Player = LocalPlayer.Name
    }
    
    table.insert(Debug.Errors, 1, errorInfo)
    
    -- Keep error log from growing too large
    if #Debug.Errors > Debug.MaxErrors then
        table.remove(Debug.Errors)
    end
    
    if Debug.PrintErrors then
        warn("[Blue Lock Rivals] Error: " .. message)
        warn(traceback)
    end
end

local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        LogError(result)
        return nil
    end
    return result
end

local function GetGameData()
    local gameData = {}
    
    -- Attempt to find important game locations/folders
    gameData.TrainingAreas = workspace:FindFirstChild("TrainingAreas") or workspace:FindFirstChild("Training")
    gameData.MatchAreas = workspace:FindFirstChild("MatchAreas") or workspace:FindFirstChild("Matches")
    gameData.Gameplay = ReplicatedStorage:FindFirstChild("Gameplay") or ReplicatedStorage:FindFirstChild("GameplayModules")
    gameData.Remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("RemoteEvents")
    
    return gameData
end

local function SaveSettings()
    local success, result = pcall(function()
        return HttpService:JSONEncode(Settings)
    end)
    
    if success then
        writefile(SaveFileName, result)
        return true
    else
        LogError("Failed to save settings: " .. tostring(result))
        return false
    end
end

local function LoadSettings()
    local success, result = pcall(function()
        if isfile(SaveFileName) then
            return HttpService:JSONDecode(readfile(SaveFileName))
        end
        return nil
    end)
    
    if success and result then
        -- Merge saved settings with defaults (to handle new settings)
        for key, value in pairs(DefaultSettings) do
            if result[key] == nil then
                result[key] = value
            end
        end
        return result
    else
        if success then
            LogError("Settings file not found, using defaults")
        else
            LogError("Failed to load settings: " .. tostring(result))
        end
        return DefaultSettings
    end
end

-- Create the GUI
function Library:CreateWindow()
    -- If a previous GUI exists from this script, destroy it
    if CoreGui:FindFirstChild("BlueLocksRivalsGUI") then
        CoreGui:FindFirstChild("BlueLocksRivalsGUI"):Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlueLocksRivalsGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Set correct parent based on exploit support
    local success, result = pcall(function()
        ScreenGui.Parent = CoreGui
        return true
    end)
    
    if not success then
        ScreenGui.Parent = PlayerGui
    end
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = Settings.UIPosition or UDim2.new(0.8, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = MainFrame
    
    -- Create title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 5)
    TitleCorner.Parent = TitleBar
    
    -- Fix corner radius only on top corners
    local TitleCornerFix = Instance.new("Frame")
    TitleCornerFix.Name = "CornerFix"
    TitleCornerFix.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    TitleCornerFix.BorderSizePixel = 0
    TitleCornerFix.Position = UDim2.new(0, 0, 0.5, 0)
    TitleCornerFix.Size = UDim2.new(1, 0, 0.5, 0)
    TitleCornerFix.Parent = TitleBar
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Blue Lock Rivals"
    Title.TextColor3 = Color3.fromRGB(240, 240, 245)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(240, 240, 245)
    CloseButton.TextSize = 24
    CloseButton.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(240, 240, 245)
    MinimizeButton.TextSize = 24
    MinimizeButton.Parent = TitleBar
    
    -- Status label (platform info)
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 1, -20)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.Text = IsMobile and "Mobile Mode" or "PC Mode"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 14
    StatusLabel.Parent = MainFrame
    
    -- Content Container (for toggle buttons)
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 0, 0, 30)
    ContentContainer.Size = UDim2.new(1, 0, 1, -50)
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as toggles are added
    ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentContainer.ScrollBarThickness = 4
    ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    ContentContainer.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ContentContainer
    
    -- Dragging functionality
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragOffset = input.Position - TitleBar.AbsolutePosition
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
            -- Save position
            Settings.UIPosition = MainFrame.Position
            SaveSettings()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local newPosition = UDim2.new(0, input.Position.X - DragOffset.X, 0, input.Position.Y - DragOffset.Y)
            MainFrame.Position = newPosition
        end
    end)
    
    -- Close functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        Settings.UIMinimized = not Settings.UIMinimized
        SaveSettings()
        
        if Settings.UIMinimized then
            -- Collapse to just the title bar
            MainFrame:TweenSize(UDim2.new(0, 250, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            MinimizeButton.Text = "+"
        else
            -- Expand to full size
            MainFrame:TweenSize(UDim2.new(0, 250, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            MinimizeButton.Text = "−"
        end
    end)
    
    -- Apply minimized state from settings
    if Settings.UIMinimized then
        MainFrame.Size = UDim2.new(0, 250, 0, 30)
        MinimizeButton.Text = "+"
    end
    
    GUI = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentContainer = ContentContainer
    }
    
    return GUI
end

-- Create a toggle button
function Library:CreateToggle(name, initialState, callback)
    local container = GUI.ContentContainer
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 36)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Font = Enum.Font.SourceSans
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    ToggleLabel.TextSize = 16
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(80, 80, 85)
    ToggleButton.Position = UDim2.new(1, -46, 0.5, -10)
    ToggleButton.Size = UDim2.new(0, 36, 0, 20)
    ToggleButton.Parent = ToggleFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    ToggleCircle.Position = initialState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Parent = ToggleButton
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(1, 0)
    UICorner3.Parent = ToggleCircle
    
    local ToggleClickArea = Instance.new("TextButton")
    ToggleClickArea.Name = "ClickArea"
    ToggleClickArea.BackgroundTransparency = 1
    ToggleClickArea.Size = UDim2.new(1, 0, 1, 0)
    ToggleClickArea.Text = ""
    ToggleClickArea.Parent = ToggleFrame
    
    ToggleFrame.Parent = container
    
    local toggle = {
        Frame = ToggleFrame,
        Button = ToggleButton,
        Circle = ToggleCircle,
        Value = initialState,
        Callback = callback
    }
    
    -- Click event
    ToggleClickArea.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        
        -- Update UI
        if toggle.Value then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            ToggleCircle:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        end
        
        -- Update settings
        Settings[name] = toggle.Value
        SaveSettings()
        
        -- Call callback
        SafeCall(callback, toggle.Value)
    end)
    
    Toggles[name] = toggle
    return toggle
end

-- Game Feature Functions
local GameFeatures = {}

-- Auto Training Feature
function GameFeatures.SetupAutoTrain(enabled)
    if enabled then
        if GameFeatures.AutoTrainConnection then
            GameFeatures.AutoTrainConnection:Disconnect()
        end
        
        GameFeatures.AutoTrainConnection = RunService.Heartbeat:Connect(function()
            SafeCall(function()
                local gameData = GetGameData()
                if not gameData.TrainingAreas then return end
                
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                -- Look for training interaction parts
                for _, area in pairs(gameData.TrainingAreas:GetChildren()) do
                    local interactPart = area:FindFirstChild("Interact") or area:FindFirstChild("InteractPart")
                    if interactPart and interactPart:IsA("BasePart") then
                        -- Find training remotes
                        local remotes = gameData.Remotes
                        if remotes then
                            local trainRemote = remotes:FindFirstChild("Train") or remotes:FindFirstChild("StartTraining")
                            if trainRemote and trainRemote:IsA("RemoteEvent") then
                                trainRemote:FireServer(area.Name)
                            end
                        end
                    end
                end
                
                -- Complete training automatically if already in training
                local trainUI = PlayerGui:FindFirstChild("TrainingUI") or PlayerGui:FindFirstChild("Training")
                if trainUI and trainUI.Enabled then
                    -- Look for any complete training button or remote
                    local completeButton = trainUI:FindFirstChild("CompleteButton", true)
                    if completeButton and completeButton:IsA("GuiButton") then
                        -- Simulate clicking the button
                        for _, event in pairs(getconnections(completeButton.MouseButton1Click)) do
                            event:Fire()
                        end
                    end
                    
                    -- Try to fire training completion remote
                    local remotes = gameData.Remotes
                    if remotes then
                        local completeRemote = remotes:FindFirstChild("CompleteTraining") or remotes:FindFirstChild("FinishTraining")
                        if completeRemote and completeRemote:IsA("RemoteEvent") then
                            completeRemote:FireServer()
                        end
                    end
                end
            end)
        end)
    else
        if GameFeatures.AutoTrainConnection then
            GameFeatures.AutoTrainConnection:Disconnect()
            GameFeatures.AutoTrainConnection = nil
        end
    end
end

-- Auto Farm Feature
function GameFeatures.SetupAutoFarm(enabled)
    if enabled then
        if GameFeatures.AutoFarmConnection then
            GameFeatures.AutoFarmConnection:Disconnect()
        end
        
        GameFeatures.AutoFarmConnection = RunService.Heartbeat:Connect(function()
            SafeCall(function()
                local gameData = GetGameData()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                -- Look for match or farming areas
                local farmAreas = gameData.MatchAreas or workspace:FindFirstChild("FarmAreas")
                if not farmAreas then return end
                
                -- Look for currency/rewards
                for _, item in pairs(workspace:GetChildren()) do
                    if item:IsA("BasePart") and (item.Name:find("Coin") or item.Name:find("Currency") or item.Name:find("Reward")) then
                        if (item.Position - character.HumanoidRootPart.Position).Magnitude < 50 then
                            -- Teleport to the item
                            character.HumanoidRootPart.CFrame = CFrame.new(item.Position)
                        end
                    end
                end
                
                -- Auto-join matches
                local remotes = gameData.Remotes
                if remotes then
                    local joinMatchRemote = remotes:FindFirstChild("JoinMatch") or remotes:FindFirstChild("RequestMatch")
                    if joinMatchRemote and joinMatchRemote:IsA("RemoteEvent") then
                        joinMatchRemote:FireServer()
                    end
                end
                
                -- Auto-play in matches
                local matchUI = PlayerGui:FindFirstChild("MatchUI") or PlayerGui:FindFirstChild("GameUI")
                if matchUI and matchUI.Enabled then
                    -- Find the ball
                    local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                    if ball and ball:IsA("BasePart") then
                        -- Move towards ball
                        character.Humanoid:MoveTo(ball.Position)
                        
                        -- If near ball, try to score
                        if (ball.Position - character.HumanoidRootPart.Position).Magnitude < 10 then
                            -- Find goal
                            local goal = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("EnemyGoal")
                            if goal then
                                -- Kick towards goal
                                local kickRemote = remotes:FindFirstChild("Kick") or remotes:FindFirstChild("KickBall")
                                if kickRemote and kickRemote:IsA("RemoteEvent") then
                                    kickRemote:FireServer(goal.Position)
                                end
                            end
                        end
                    end
                end
            end)
        end)
    else
        if GameFeatures.AutoFarmConnection then
            GameFeatures.AutoFarmConnection:Disconnect()
            GameFeatures.AutoFarmConnection = nil
        end
    end
end

-- Player ESP Feature
function GameFeatures.SetupPlayerESP(enabled)
    -- Remove existing ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local esp = player.Character:FindFirstChild("ESPHighlight")
            if esp then
                esp:Destroy()
            end
        end
    end
    
    if enabled then
        if GameFeatures.ESPConnection then
            GameFeatures.ESPConnection:Disconnect()
        end
        
        GameFeatures.ESPConnection = RunService.RenderStepped:Connect(function()
            SafeCall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        -- Add ESP highlight
                        local highlight = player.Character:FindFirstChild("ESPHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.FillColor = player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Parent = player.Character
                        end
                    end
                end
            end)
        end)
    else
        if GameFeatures.ESPConnection then
            GameFeatures.ESPConnection:Disconnect()
            GameFeatures.ESPConnection = nil
        end
    end
end

-- Infinite Stamina Feature
function GameFeatures.SetupInfiniteStamina(enabled)
    if enabled then
        if GameFeatures.StaminaConnection then
            GameFeatures.StaminaConnection:Disconnect()
        end
        
        GameFeatures.StaminaConnection = RunService.Heartbeat:Connect(function()
            SafeCall(function()
                -- Try different ways to find stamina value
                local character = LocalPlayer.Character
                if not character then return end
                
                -- Method 1: Check for stamina value in the character
                local stamina = character:FindFirstChild("Stamina") or character:FindFirstChild("Energy")
                if stamina and stamina:IsA("NumberValue") then
                    stamina.Value = stamina.MaxValue or 100
                end
                
                -- Method 2: Check player stats
                local stats = LocalPlayer:FindFirstChild("Stats")
                if stats then
                    local staminaStat = stats:FindFirstChild("Stamina") or stats:FindFirstChild("Energy")
                    if staminaStat and staminaStat:IsA("NumberValue") then
                        staminaStat.Value = staminaStat.MaxValue or 100
                    end
                end
                
                -- Method 3: Check player data in ReplicatedStorage
                local playerData = ReplicatedStorage:FindFirstChild("PlayerData")
                if playerData then
                    local playerStats = playerData:FindFirstChild(LocalPlayer.Name)
                    if playerStats then
                        local staminaStat = playerStats:FindFirstChild("Stamina") or playerStats:FindFirstChild("Energy")
                        if staminaStat and staminaStat:IsA("NumberValue") then
                            staminaStat.Value = staminaStat.MaxValue or 100
                        end
                    end
                end
            end)
        end)
    else
        if GameFeatures.StaminaConnection then
            GameFeatures.StaminaConnection:Disconnect()
            GameFeatures.StaminaConnection = nil
        end
    end
end

-- Instant Goal Feature
function GameFeatures.SetupInstantGoal(enabled)
    if enabled then
        if GameFeatures.InstantGoalConnection then
            GameFeatures.InstantGoalConnection:Disconnect()
        end
        
        -- Hook into kick events
        local gameData = GetGameData()
        local remotes = gameData.Remotes
        
        if remotes then
            -- Find kick remote
            local kickRemote = remotes:FindFirstChild("Kick") or remotes:FindFirstChild("KickBall")
            
            if kickRemote and kickRemote:IsA("RemoteEvent") then
                -- Create a hook for the kick remote
                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    local args = {...}
                    local method = getnamecallmethod()
                    
                    if method == "FireServer" and self == kickRemote then
                        -- Find the enemy goal
                        local goal = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("EnemyGoal")
                        if goal then
                            -- Modify args to always aim at goal
                            args[1] = goal.Position
                            
                            -- Add more power to the kick
                            if #args >= 2 and type(args[2]) == "number" then
                                args[2] = 100 -- Max power
                            end
                        end
                    end
                    
                    return oldNamecall(self, unpack(args))
                end)
            end
        end
    end
end

-- Auto Dribble Feature
function GameFeatures.SetupAutoDribble(enabled)
    if enabled then
        if GameFeatures.AutoDribbleConnection then
            GameFeatures.AutoDribbleConnection:Disconnect()
        end
        
        GameFeatures.AutoDribbleConnection = RunService.Heartbeat:Connect(function()
            SafeCall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                -- Find the ball
                local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("SoccerBall")
                if ball and ball:IsA("BasePart") then
                    -- If the ball is nearby, automatically dribble
                    if (ball.Position - character.HumanoidRootPart.Position).Magnitude < 15 then
                        -- Find dribble remote
                        local gameData = GetGameData()
                        local remotes = gameData.Remotes
                        
                        if remotes then
                            local dribbleRemote = remotes:FindFirstChild("Dribble") or remotes:FindFirstChild("StartDribble")
                            if dribbleRemote and dribbleRemote:IsA("RemoteEvent") then
                                dribbleRemote:FireServer(ball)
                            end
                        end
                    end
                end
            end)
        end)
    else
        if GameFeatures.AutoDribbleConnection then
            GameFeatures.AutoDribbleConnection:Disconnect()
            GameFeatures.AutoDribbleConnection = nil
        end
    end
end

-- Main Script Execution
local function Initialize()
    print("Initializing Blue Lock Rivals Script...")
    
    -- Load settings
    Settings = LoadSettings()
    
    -- Create GUI
    Library:CreateWindow()
    
    -- Create toggles
    Library:CreateToggle("AutoTrain", Settings.AutoTrain, function(value)
        GameFeatures.SetupAutoTrain(value)
    end)
    
    Library:CreateToggle("AutoFarm", Settings.AutoFarm, function(value)
        GameFeatures.SetupAutoFarm(value)
    end)
    
    Library:CreateToggle("PlayerESP", Settings.PlayerESP, function(value)
        GameFeatures.SetupPlayerESP(value)
    end)
    
    Library:CreateToggle("InstantGoal", Settings.InstantGoal, function(value)
        GameFeatures.SetupInstantGoal(value)
    end)
    
    Library:CreateToggle("InfiniteStamina", Settings.InfiniteStamina, function(value)
        GameFeatures.SetupInfiniteStamina(value)
    end)
    
    Library:CreateToggle("AutoDribble", Settings.AutoDribble, function(value)
        GameFeatures.SetupAutoDribble(value)
    end)
    
    -- Initialize features based on saved settings
    for featureName, enabled in pairs(Settings) do
        if type(enabled) == "boolean" and GameFeatures["Setup" .. featureName] then
            GameFeatures["Setup" .. featureName](enabled)
        end
    end
    
    -- Setup platform-specific controls
    if IsMobile then
        print("Mobile platform detected, adjusting controls...")
        -- Adjust UI for mobile if needed
    else
        print("PC platform detected")
    end
    
    print("Blue Lock Rivals Script Loaded Successfully!")
end

-- Error handling for the entire script
local success, errorMessage = pcall(Initialize)
if not success then
    warn("Error initializing Blue Lock Rivals Script: " .. tostring(errorMessage))
end

-- Return the library to allow further customization if needed
return Library
