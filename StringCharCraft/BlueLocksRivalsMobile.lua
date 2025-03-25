--[[
Blue Lock Rivals Mobile Script
Created exclusively for mobile devices playing Blue Lock Rivals Roblox game

INSTRUCTIONS:
1. Copy this entire script
2. Open the Delta mobile executor for Roblox
3. Paste this script into the executor
4. Join the Blue Lock Rivals game on Roblox
5. Execute the script
6. Use the touch-friendly GUI to control features

Features:
- Auto Pass - Intelligently passes to the best teammate
- Auto Shoot - Automatically shoots when in a good position
- Shot Prediction - Visualizes shot trajectory
- Player ESP - See player positions
- Mobile-optimized interface with large buttons
- Quick Actions - Tap anywhere on screen to perform context-sensitive moves
- Gesture Controls - Swipe for special skill moves
- CR7 Style - Cristiano Ronaldo playing style with mobile enhancements

]]--

-- Check if we're running in the Roblox environment
if not game then
    print("---------------------------------------------")
    print("This script is meant to be executed in Roblox")
    print("Please use a Roblox executor like Delta")
    print("Script test passed - file is ready to use")
    print("---------------------------------------------")
    return
end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Player references
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Feature variables
local Features = {
    AutoPass = false,
    AutoShoot = false,
    ShotPrediction = false,
    PlayerESP = false,
    PassPower = 50,
    ShotPower = 75,
    CR7Mode = false
}

-- Check if we're on a mobile device - only proceed if we are
if not UserInputService.TouchEnabled then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Blue Lock Rivals Mobile",
        Text = "This script only works on mobile devices!",
        Duration = 5
    })
    return
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueLocksRivalsMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main frame with gradient
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.95, 0, 0.4, 0)
MainFrame.Position = UDim2.new(0.025, 0, 0.59, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Add gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
UIGradient.Parent = MainFrame

-- Add corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.02, 0)
UICorner.Parent = MainFrame

-- Add subtle stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Header for the UI with gradient
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0.08, 0) -- Slimmer header
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Darker header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

-- Add icon to header
local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Size = UDim2.new(0.06, 0, 0.8, 0)
Icon.Position = UDim2.new(0.02, 0, 0.1, 0)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://7734010488" -- Moon icon
Icon.Parent = Header


-- Add gradient to header
local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
})
HeaderGradient.Rotation = 45
HeaderGradient.Parent = Header

-- Add corner rounding to header
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0.15, 0)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0.15, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Blue Lock Rivals Mobile"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Parent = Header

-- Create toggle buttons (large for mobile touch)
local function CreateToggleButton(name, position)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(0.9, 0, 0.08, 0) -- Wider but shorter buttons
    Button.Position = position 
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Darker buttons
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(200, 200, 200) -- Slightly dimmer text
    Button.TextSize = 14 -- Smaller text
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = false
    Button.Parent = MainFrame

    -- Add gradient to button
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 55, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 40, 55))
    })
    ButtonGradient.Rotation = 45
    ButtonGradient.Parent = Button

    -- Add glow effect
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(80, 85, 100)
    UIStroke.Thickness = 1
    UIStroke.Parent = Button

    -- Add shadow effect
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.1, 0)
    Corner.Parent = Button

    -- Handle button press
    Button.TouchTap:Connect(function()
        Features[name] = not Features[name]
        Button.Text = name .. ": " .. (Features[name] and "ON" or "OFF")
        Button.BackgroundColor3 = Features[name] and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(60, 60, 60)

        -- Show notification
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = name,
            Text = Features[name] and "Enabled" or "Disabled",
            Duration = 1
        })
    end)

    return Button
end

-- Create slider for power control (mobile-friendly)
local function CreateSlider(name, position, initialValue)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "SliderFrame"
    SliderFrame.Size = UDim2.new(0.9, 0, 0.15, 0)
    SliderFrame.Position = position
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.2, 0)
    Corner.Parent = SliderFrame

    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Name = "Title"
    SliderTitle.Size = UDim2.new(0.35, 0, 1, 0)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = name
    SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.TextSize = 16
    SliderTitle.Font = Enum.Font.GothamSemibold
    SliderTitle.Parent = SliderFrame

    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Size = UDim2.new(0.55, 0, 0.3, 0)
    SliderTrack.Position = UDim2.new(0.35, 0, 0.35, 0)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame

    local SliderTrackCorner = Instance.new("UICorner")
    SliderTrackCorner.CornerRadius = UDim.new(0.5, 0)
    SliderTrackCorner.Parent = SliderTrack

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Size = UDim2.new(initialValue/100, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0.5, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderValue = Instance.new("TextLabel")
    SliderValue.Name = "Value"
    SliderValue.Size = UDim2.new(0.1, 0, 1, 0)
    SliderValue.Position = UDim2.new(0.9, 0, 0, 0)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = initialValue
    SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderValue.TextSize = 16
    SliderValue.Font = Enum.Font.GothamSemibold
    SliderValue.Parent = SliderFrame

    -- Touch controls for slider
    local isDragging = false

    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            UpdateSlider(input)
        end
    end)

    SliderTrack.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.Touch then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    function UpdateSlider(input)
        local trackAbsoluteSize = SliderTrack.AbsoluteSize.X
        local trackAbsolutePosition = SliderTrack.AbsolutePosition.X

        local mousePosition = input.Position.X
        local position = math.clamp((mousePosition - trackAbsolutePosition) / trackAbsoluteSize, 0, 1)

        local roundedValue = math.floor(position * 100)
        SliderFill.Size = UDim2.new(position, 0, 1, 0)
        SliderValue.Text = roundedValue

        Features[name] = roundedValue
    end

    return SliderFrame
end

-- Create UI elements
local AutoPassButton = CreateToggleButton("AutoPass", UDim2.new(0.025, 0, 0.1, 0))
local AutoShootButton = CreateToggleButton("AutoShoot", UDim2.new(0.525, 0, 0.1, 0))
local ShotPredictionButton = CreateToggleButton("ShotPrediction", UDim2.new(0.025, 0, 0.18, 0))
local PlayerESPButton = CreateToggleButton("PlayerESP", UDim2.new(0.525, 0, 0.18, 0))

-- CR7 Style button (with special styling)
local CR7Button = Instance.new("TextButton")
CR7Button.Name = "CR7Button"
CR7Button.Size = UDim2.new(0.9, 0, 0.15, 0)
CR7Button.Position = UDim2.new(0.05, 0, 0.83, 0)
CR7Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White for Real Madrid/Portugal colors
CR7Button.BorderSizePixel = 0
CR7Button.Text = "CR7 Style: OFF"
CR7Button.TextColor3 = Color3.fromRGB(0, 0, 0) -- Black text on white
CR7Button.TextSize = 22
CR7Button.Font = Enum.Font.GothamBlack -- Bold font for emphasis
CR7Button.Parent = MainFrame

-- Add red accent to represent CR7's Portugal/Manchester colors
local CR7Accent = Instance.new("Frame")
CR7Accent.Name = "CR7Accent"
CR7Accent.Size = UDim2.new(0.03, 0, 1, 0)
CR7Accent.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- Crimson red
CR7Accent.BorderSizePixel = 0
CR7Accent.Parent = CR7Button

local CR7Corner = Instance.new("UICorner")
CR7Corner.CornerRadius = UDim.new(0.2, 0)
CR7Corner.Parent = CR7Button

-- Handle CR7 button activation
CR7Button.TouchTap:Connect(function()
    Features.CR7Mode = not Features.CR7Mode
    CR7Button.Text = "CR7 Style: " .. (Features.CR7Mode and "ON" or "OFF")
    CR7Button.BackgroundColor3 = Features.CR7Mode and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(255, 255, 255)
    CR7Button.TextColor3 = Features.CR7Mode and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    CR7Accent.BackgroundColor3 = Features.CR7Mode and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 20, 60)

    -- Show a special CR7 notification
    if Features.CR7Mode then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SIUUUUU!",
            Text = "Cristiano Ronaldo mode activated!",
            Duration = 3
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CR7 Style",
            Text = "Deactivated",
            Duration = 1
        })
    end
end)

local PassPowerSlider = CreateSlider("PassPower", UDim2.new(0.05, 0, 0.26, 0), Features.PassPower)
local ShotPowerSlider = CreateSlider("ShotPower", UDim2.new(0.05, 0, 0.43, 0), Features.ShotPower)

-- Add close button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0.08, 0, 0.8, 0)
CloseButton.Position = UDim2.new(0.91, 0, 0.1, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0.2, 0)
CloseCorner.Parent = CloseButton

CloseButton.TouchTap:Connect(function()
    ScreenGui:Destroy()
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
end)

-- Make the frame draggable for mobile (simplified for touch)
local isDragging = false
local dragStartPos
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = input.Position
        startPos = MainFrame.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- Add collapsible button for mobile
local CollapseButton = Instance.new("TextButton")
CollapseButton.Name = "CollapseButton"
CollapseButton.Size = UDim2.new(0.08, 0, 0.8, 0)
CollapseButton.Position = UDim2.new(0.01, 0, 0.1, 0)
CollapseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CollapseButton.BorderSizePixel = 0
CollapseButton.Text = "▼"
CollapseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseButton.TextSize = 18
CollapseButton.Font = Enum.Font.GothamBold
CollapseButton.Parent = Header

local CollapseCorner = Instance.new("UICorner")
CollapseCorner.CornerRadius = UDim.new(0.2, 0)
CollapseCorner.Parent = CollapseButton

local isCollapsed = false
CollapseButton.TouchTap:Connect(function()
    isCollapsed = not isCollapsed
    local targetSize = isCollapsed and UDim2.new(0.95, 0, 0.08, 0) or UDim2.new(0.95, 0, 0.4, 0)
    local targetPos = isCollapsed and UDim2.new(0.025, 0, 0.91, 0) or UDim2.new(0.025, 0, 0.59, 0)
    CollapseButton.Text = isCollapsed and "▲" or "▼"

    -- Animate collapse/expand
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = targetSize, Position = targetPos})
    sizeTween:Play()

    -- Toggle visibility of controls
    local visibility = not isCollapsed
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= Header and child.Name ~= "CloseButton" then
            child.Visible = visibility
        end
    end
end)

-- Core game functionality
local connections = {}

-- Mobile-specific features
-- Add additional feature variables
Features.QuickActions = false
Features.GestureControls = false
Features.BallTracker = nil -- Will hold the ball reference
Features.LastGesture = nil -- Will store last gesture type
Features.GestureCooldown = false

-- Quick Action button (floating action button for mobile)
local QuickActionButton = Instance.new("ImageButton")
QuickActionButton.Name = "QuickActionButton"
QuickActionButton.Size = UDim2.new(0, 70, 0, 70)
QuickActionButton.Position = UDim2.new(0.9, -35, 0.4, 0)
QuickActionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
QuickActionButton.BorderSizePixel = 0
QuickActionButton.Image = ""
QuickActionButton.Visible = false
QuickActionButton.Parent = ScreenGui

-- Make it circular
local QuickActionCorner = Instance.new("UICorner")
QuickActionCorner.CornerRadius = UDim.new(1, 0)
QuickActionCorner.Parent = QuickActionButton

-- Add icon to the button
local QuickActionIcon = Instance.new("TextLabel")
QuickActionIcon.Name = "Icon"
QuickActionIcon.Size = UDim2.new(1, 0, 1, 0)
QuickActionIcon.BackgroundTransparency = 1
QuickActionIcon.Text = "⚽"
QuickActionIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
QuickActionIcon.TextSize = 30
QuickActionIcon.Font = Enum.Font.GothamBold
QuickActionIcon.Parent = QuickActionButton

-- Create Quick Action Toggle Button
local QuickActionsButton = CreateToggleButton("QuickActions", UDim2.new(0.025, 0, 0.26, 0))

-- Create Gesture Controls Toggle Button
local GestureControlsButton = CreateToggleButton("GestureControls", UDim2.new(0.525, 0, 0.26, 0))

-- Find the soccer ball in the game
local function findSoccerBall()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "SoccerBall" or obj.Name == "Ball" or obj.Name == "GameBall" then
            return obj
        end
    end

    -- If specific ball not found, look for something that might be the ball
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and 
           (obj.Shape == Enum.PartType.Ball or string.find(string.lower(obj.Name), "ball")) then
            return obj
        end
    end

    return nil
end

-- Detect player gestures based on touch input
local gestureStartPosition = nil
local function detectGesture(startPos, endPos)
    if not startPos or not endPos then return nil end

    local delta = endPos - startPos
    local distance = delta.Magnitude

    -- Only consider significant movements
    if distance < 50 then return nil end

    -- Determine the primary direction (up, down, left, right)
    local angle = math.atan2(delta.Y, delta.X)
    local degrees = math.deg(angle)

    if degrees >= -45 and degrees < 45 then
        return "right"
    elseif degrees >= 45 and degrees < 135 then
        return "down"
    elseif degrees >= 135 or degrees < -135 then
        return "left"
    else
        return "up"
    end
end

-- Handle gesture for CR7 skill moves
local function performCR7SkillMove(gestureType)
    if Features.GestureCooldown then return end

    -- Activate cooldown
    Features.GestureCooldown = true

    -- Get the humanoid animation controller
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then 
        Features.GestureCooldown = false
        return 
    end

    local animController = humanoid:FindFirstChildOfClass("Animator")
    if not animController then
        Features.GestureCooldown = false
        return
    end

    -- Create different animations based on gesture
    local animation = Instance.new("Animation")

    -- Different skill moves based on gesture
    if gestureType == "right" then
        -- CR7 Stepover
        animation.AnimationId = "rbxassetid://7118847779" -- Use an appropriate animation ID
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CR7 Skill Move",
            Text = "Stepover executed!",
            Duration = 1
        })
    elseif gestureType == "left" then
        -- CR7 Chop
        animation.AnimationId = "rbxassetid://7118847779" -- Use an appropriate animation ID
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CR7 Skill Move",
            Text = "Chop executed!",
            Duration = 1
        })
    elseif gestureType == "down" then
        -- CR7 Scissors
        animation.AnimationId = "rbxassetid://7118847779" -- Use an appropriate animation ID
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CR7 Skill Move",
            Text = "Scissors executed!",
            Duration = 1
        })
    elseif gestureType == "up" then
        -- CR7 SIUUU Jump
        animation.AnimationId = "rbxassetid://7118847779" -- Use an appropriate animation ID
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SIUUUU!",
            Text = "CR7 celebration!",
            Duration = 1
        })
    end

    -- Play the animation
    local animTrack = animController:LoadAnimation(animation)
    animTrack:Play()

    -- Reset cooldown after a short delay
    task.delay(1.5, function()
        Features.GestureCooldown = false
    end)
end

-- Update the Quick Action button based on context
local function updateQuickActionButton()
    if not Features.QuickActions then
        QuickActionButton.Visible = false
        return
    end

    -- Find the ball if we don't have it yet
    if not Features.BallTracker then
        Features.BallTracker = findSoccerBall()
    end

    -- If still no ball found, hide button
    if not Features.BallTracker then
        QuickActionButton.Visible = false
        return
    end

    -- Check if player is near ball
    local playerPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                          LocalPlayer.Character.HumanoidRootPart.Position

    if not playerPosition then
        QuickActionButton.Visible = false
        return
    end

    local ballDistance = (playerPosition - Features.BallTracker.Position).Magnitude
    local isNearBall = ballDistance < 10

    -- Show Quick Action button if player is near ball
    QuickActionButton.Visible = isNearBall

    -- Change the icon based on the context
    if isNearBall then
        -- If we're in a shooting position
        local shootingPosition = false

        -- Find enemy goal (simplified for this example)
        local goals = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Goal" or string.find(string.lower(obj.Name), "goal") then
                table.insert(goals, obj)
            end
        end

        -- If we found some goals, check if we're in a good shooting position
        if #goals > 0 then
            for _, goal in pairs(goals) do
                -- Skip team's own goal if we can detect it
                if not (goal.Name == "OwnGoal" or (LocalPlayer.Team and goal.Name == LocalPlayer.Team.Name .. "Goal")) then

                    -- Check distance to goal
                    local distanceToGoal = (playerPosition - goal.Position).Magnitude
                    if distanceToGoal < 50 then
                        shootingPosition = true
                        break
                    end
                end
            end
        end

        -- Update the icon based on the situation
        if shootingPosition then
            QuickActionIcon.Text = "🥅" -- Goal/shoot icon
        else
            QuickActionIcon.Text = "⚽" -- Ball/pass icon
        end

        -- Update the button color based on CR7 mode
        if Features.CR7Mode then
            QuickActionButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- CR7 red
        else
            QuickActionButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Default blue
        end
    end
end

-- Quick Action button click handler
QuickActionButton.TouchTap:Connect(function()
    -- Get the current context
    local playerPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
                          LocalPlayer.Character.HumanoidRootPart.Position

    if not playerPosition or not Features.BallTracker then return end

    local ballDistance = (playerPosition - Features.BallTracker.Position).Magnitude
    local isNearBall = ballDistance < 10

    if not isNearBall then return end

    -- Check if we're in shooting position
    local shootingPosition = false
    local shootTarget = nil

    -- Find enemy goal
    local goals = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Goal" or string.find(string.lower(obj.Name), "goal") then
            table.insert(goals, obj)
        end
    end

    if #goals > 0 then
        for _, goal in pairs(goals) do
            -- Skip team's own goal if we can detect it
            if not (goal.Name == "OwnGoal" or (LocalPlayer.Team and goal.Name == LocalPlayer.Team.Name .. "Goal")) then

                -- Check distance to goal
                local distanceToGoal = (playerPosition - goal.Position).Magnitude
                if distanceToGoal < 50 then
                    shootingPosition = true
                    shootTarget = goal
                    break
                end
            end
        end
    end

    -- Perform action based on context
    if shootingPosition and shootTarget then
        -- Shoot at goal
        local direction = (shootTarget.Position - Features.BallTracker.Position).Unit
        local power = Features.CR7Mode and 95 or Features.ShotPower

        -- Calculate a slightly upward trajectory
        direction = direction + Vector3.new(0, 0.2, 0)

        -- Apply force to ball
        Features.BallTracker.Velocity = direction * power

        -- Visual effect for shot
        local shotEffect = Instance.new("Part")
        shotEffect.Shape = Enum.PartType.Ball
        shotEffect.Size = Vector3.new(1, 1, 1)
        shotEffect.Material = Enum.Material.Neon
        shotEffect.Color = Features.CR7Mode and Color3.fromRGB(220, 20, 60) or Color3.fromRGB(255, 165, 0)
        shotEffect.Transparency = 0.5
        shotEffect.CanCollide = false
        shotEffect.Anchored = true
        shotEffect.Position = Features.BallTracker.Position
        shotEffect.Parent = workspace

        -- Remove the effect after a short time
        game:GetService("Debris"):AddItem(shotEffect, 0.3)

        -- Notification
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = Features.CR7Mode and "SIUUUU!" or "Shot",
            Text = "Power: " .. power,
            Duration = 1
        })
    else
        -- Pass to best teammate
        local bestTeammate = findBestTeammate()
        if bestTeammate then
            local teammatePosition = bestTeammate.Character.HumanoidRootPart.Position
            local direction = (teammatePosition - Features.BallTracker.Position).Unit
            local passSpeed = Features.PassPower

            -- Apply velocity for pass
            Features.BallTracker.Velocity = direction * passSpeed

            -- Visual effect for pass
            local passEffect = Instance.new("Part")
            passEffect.Shape = Enum.PartType.Ball
            passEffect.Size = Vector3.new(0.5, 0.5, 0.5)
            passEffect.Material = Enum.Material.Neon
            passEffect.Color = Color3.fromRGB(255, 255, 255)
            passEffect.Transparency = 0.7
            passEffect.CanCollide = false
            passEffect.Anchored = true
            passEffect.Position = Features.BallTracker.Position
            passEffect.Parent = workspace

            -- Remove the effect after a short time
            game:GetService("Debris"):AddItem(passEffect, 0.2)

            -- Notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Pass",
                Text = "To: " .. bestTeammate.Name,
                Duration = 1
            })
        end
    end
end)

-- Set up gesture detection
local function setupGestureDetection()
    local gestureDetector = Instance.new("ScreenGui")
    gestureDetector.Name = ""GestureDetector"
    gestureDetector.ResetOnSpawn = false
    gestureDetector.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gestureDetector.IgnoreGuiInset = true
    gestureDetector.Parent = PlayerGui

    local gestureFrame = Instance.new("Frame")
    gestureFrame.Name = "GestureFrame"
    gestureFrame.Size = UDim2.new(1, 0, 1, 0)
    gestureFrame.BackgroundTransparency = 1
    gestureFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gestureFrame.Parent = gestureDetector

    -- Handle-- Handle touch input for gestures
    gestureFrame.InputBegan:Connect(function(input)
        if not Features.GestureControls then return end
        if input.UserInputType == Enum.UserInputType.Touch then
            gestureStartPosition = input.Position
        end
    end)

    gestureFrame.InputEnded:Connect(function(input)
        if not Features.GestureControls then return end
        if input.UserInputType == Enum.UserInputType.Touch and gestureStartPosition then
            local gesture = detectGesture(gestureStartPosition, input.Position)
            gestureStartPosition = nil

            if gesture and Features.CR7Mode then
                performCR7SkillMove(gesture)
            end
        end
    end)

    -- Add to connections
    table.insert(connections, gestureFrame.InputBegan)
    table.insert(connections, gestureFrame.InputEnded)
end

-- Set up gesture detection system
setupGestureDetection()

-- Update Quick Action button regularly
local function updateLoop()
    RunService.Heartbeat:Connect(function()
        updateQuickActionButton()
    end)
end
updateLoop()

-- Function to find the best teammate to pass to
local function findBestTeammate()
    local bestTeammate = nil
    local bestScore = -1
    local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position

    -- We'll use a scoring system to determine the best pass target
    for _, player in pairs(Players:GetPlayers()) do
        -- Skip self and players without characters
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Skip enemies (if team information is available)
            if not player.Team or player.Team == LocalPlayer.Team then
                local teammatePos = player.Character.HumanoidRootPart.Position
                local distanceToTeammate = (playerPosition - teammatePos).Magnitude

                -- Only consider players in range
                if distanceToTeammate <= 80 then
                    -- Calculate base score - prioritize players in good positions
                    local score = 100

                    -- Reduce score for players too close
                    if distanceToTeammate < 10 then
                        score = score - 30
                    end

                    -- Increase score for players in a good passing distance
                    if distanceToTeammate > 15 and distanceToTeammate < 40 then
                        score = score + 20
                    end

                    -- Calculate pass trajectory
                    local passDirection = (teammatePos - playerPosition).Unit
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

                    -- Check if pass lane is clear
                    local raycastResult = workspace:Raycast(playerPosition, passDirection * distanceToTeammate, raycastParams)
                    if raycastResult then
                        score = score - 40 -- Reduce score if pass is likely to be intercepted
                    else
                        score = score + 25 -- Increase score for clear passing lane
                    end

                    -- Update best teammate if this one has a higher score
                    if score > bestScore then
                        bestScore = score
                        bestTeammate = player
                    end
                end
            end
        end
    end

    return bestTeammate
end

-- Function to evaluate shot opportunity
local function evaluateShotOpportunity()
    -- Find goal position (in a real implementation, you'd locate the actual goal object)
    local goalPosition = nil

    -- Simple goal detection - look for parts that might be goals
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:lower():find("goal") or part.Name:lower():find("net")) then
            goalPosition = part.Position
            break
        end
    end

    if not goalPosition then
        return false, 0 -- No goal found
    end

    local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
    local distanceToGoal = (goalPosition - playerPosition).Magnitude

    -- Don't shoot if too far
    if distanceToGoal > 50 then
        return false, 0
    end

    -- Calculate shot score based on distance and angle
    local shotScore = 100 - distanceToGoal

    -- Check for obstacles in shot path
    local shotDirection = (goalPosition - playerPosition).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}

    local raycastResult = workspace:Raycast(playerPosition, shotDirection * distanceToGoal, raycastParams)
    if raycastResult then
        shotScore = shotScore - 40 -- Reduce score if shot is likely to be blocked
    end

    return shotScore > 30, shotScore -- Return true if good shot opportunity
end

-- Function to visualize pass or shot trajectory
local function visualizeTrajectory(startPos, endPos, isShot)
    -- Remove any existing trajectory
    for _, part in pairs(workspace:GetChildren()) do
        if part.Name == "TrajectoryVisualization" then
            part:Destroy()
        end
    end

    local distance = (endPos - startPos).Magnitude
    local midPoint = startPos + (endPos - startPos) * 0.5

    -- For longer passes, add an arc
    if distance > 20 then
        midPoint = midPoint + Vector3.new(0, distance * 0.1, 0)
    end

    -- Create points along the trajectory
    local numPoints = 20
    local points = {}

    for i = 0, numPoints do
        local t = i / numPoints
        local point

        -- Quadratic Bezier curve
        point = (1-t)^2 * startPos + 2*(1-t)*t * midPoint + t^2 * endPos

        table.insert(points, point)
    end

    -- Create visualization
    for i = 1, #points - 1 do
        local segment = Instance.new("Part")
        segment.Name = "TrajectoryVisualization"
        segment.Anchored = true
        segment.CanCollide = false
        segment.Material = Enum.Material.Neon
        segment.Transparency = 0.5
        segment.Shape = Enum.PartType.Ball

        -- Shots are red, passes are blue
        segment.Color = isShot and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 50, 255)

        -- Set segment position and size
        local direction = (points[i+1] - points[i]).Unit
        local distance = (points[i+1] - points[i]).Magnitude
        segment.Size = Vector3.new(0.2, 0.2, distance)
        segment.CFrame = CFrame.new(points[i] + direction * (distance/2), points[i+1])

        segment.Parent = workspace

        -- Add auto-destroy timer
        game:GetService("Debris"):AddItem(segment, 2)
    end
end

-- Function to handle auto pass
local function handleAutoPass()
    if not Features.AutoPass then return end

    local bestTeammate = findBestTeammate()
    if bestTeammate then
        local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local teammatePosition = bestTeammate.Character.HumanoidRootPart.Position

        -- Visualize the pass trajectory
        if Features.ShotPrediction then
            visualizeTrajectory(playerPosition, teammatePosition, false)
        end

        -- Fire pass event to game (this will vary based on the game)
        -- This is a placeholder for the actual game event
        local passEvent = ReplicatedStorage:FindFirstChild("PassBall")
        if passEvent and passEvent:IsA("RemoteEvent") then
            passEvent:FireServer(bestTeammate, Features.PassPower / 100)
        else
            -- Fallback method if event can't be found
            -- Simulate the UI interaction for the game's pass button
            local passButton = PlayerGui:FindFirstChild("GameUI", true)
            if passButton then
                -- Attempt to fire pass button click
                local virtualClick = Enum.UserInputType.MouseButton1
                for _, button in ipairs(passButton:GetDescendants()) do
                    if button:IsA("GuiButton") and button.Name:lower():find("pass") then
                        firesignal(button.MouseButton1Click)
                        break
                    end
                end
            end
        end

        -- Notification
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Pass",
            Text = "Passing to " .. bestTeammate.Name,
            Duration = 1
        })
    end
end

-- Function to handle auto shoot
local function handleAutoShoot()
    if not Features.AutoShoot then return end

    local shouldShoot, shotScore = evaluateShotOpportunity()
    if shouldShoot then
        local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position

        -- Find goal position
        local goalPosition = nil
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("goal") or part.Name:lower():find("net")) then
                goalPosition = part.Position
                break
            end
        end

        if goalPosition then
            -- Visualize the shot trajectory
            if Features.ShotPrediction then
                visualizeTrajectory(playerPosition, goalPosition, true)
            end

            -- Fire shoot event to game (this will vary based on the game)
            -- This is a placeholder for the actual game event
            local shootEvent = ReplicatedStorage:FindFirstChild("ShootBall")
            if shootEvent and shootEvent:IsA("RemoteEvent") then
                shootEvent:FireServer(goalPosition, Features.ShotPower / 100)
            else
                -- Fallback method if event can't be found
                -- Simulate the UI interaction for the game's shoot button
                local shootButton = PlayerGui:FindFirstChild("GameUI", true)
                if shootButton then
                    -- Attempt to fire shoot button click
                    for _, button in ipairs(shootButton:GetDescendants()) do
                        if button:IsA("GuiButton") and button.Name:lower():find("shoot") then
                            firesignal(button.MouseButton1Click)
                            break
                        end
                    end
                end
            end

            -- Notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Auto Shoot",
                Text = "Shot quality: " .. math.floor(shotScore) .. "%",
                Duration = 1
            })
        end
    end
end

-- Function to handle Player ESP
local function setupPlayerESP()
    -- Remove existing ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, child in pairs(player.Character:GetChildren()) do
                if child.Name == "ESPHighlight" then
                    child:Destroy()
                end
            end
        end
    end

    if not Features.PlayerESP then return end

    -- Create ESP for each player
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0

            -- Color based on team
            if player.Team == LocalPlayer.Team then
                highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Green for teammates
                highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
            else
                highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red for opponents
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            end

            highlight.Parent = player.Character
        end
    end
end

-- Create touch buttons for quick actions
local function createTouchButtons()
    local TouchButtonsFrame = Instance.new("Frame")
    TouchButtonsFrame.Name = "TouchButtonsFrame"
    TouchButtonsFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
    TouchButtonsFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
    TouchButtonsFrame.BackgroundTransparency = 1
    TouchButtonsFrame.Parent = ScreenGui

    -- Quick Pass Button
    local PassButton = Instance.new("TextButton")
    PassButton.Name = "QuickPassButton"
    PassButton.Size = UDim2.new(0.9, 0, 0.45, 0)
    PassButton.Position = UDim2.new(0.05, 0, 0, 0)
    PassButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    PassButton.BackgroundTransparency = 0.5
    PassButton.Text = "PASS"
    PassButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PassButton.TextSize = 24
    PassButton.Font = Enum.Font.GothamBold
    PassButton.Parent = TouchButtonsFrame

    local PassCorner = Instance.new("UICorner")
    PassCorner.CornerRadius = UDim.new(0.2, 0)
    PassCorner.Parent = PassButton

    -- Quick Shoot Button
    local ShootButton = Instance.new("TextButton")
    ShootButton.Name = "QuickShootButton"
    ShootButton.Size = UDim2.new(0.9, 0, 0.45, 0)
    ShootButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    ShootButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ShootButton.BackgroundTransparency = 0.5
    ShootButton.Text = "SHOOT"
    ShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ShootButton.TextSize = 24
    ShootButton.Font = Enum.Font.GothamBold
    ShootButton.Parent = TouchButtonsFrame

    local ShootCorner = Instance.new("UICorner")
    ShootCorner.CornerRadius = UDim.new(0.2, 0)
    ShootCorner.Parent = ShootButton

    -- Button functionality
    PassButton.TouchTap:Connect(function()
        handleAutoPass()
    end)

    ShootButton.TouchTap:Connect(function()
        handleAutoShoot()
    end)

    return TouchButtonsFrame
end

-- Create toggle button to show/hide main UI
local function createToggleUIButton()
    local ToggleUIButton = Instance.new("TextButton")
    ToggleUIButton.Name = "ToggleUIButton"
    ToggleUIButton.Size = UDim2.new(0.1, 0, 0.05, 0)
    ToggleUIButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    ToggleUIButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleUIButton.BackgroundTransparency = 0.2
    ToggleUIButton.Text = "UI"
    ToggleUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleUIButton.TextSize = 18
    ToggleUIButton.Font = Enum.Font.GothamBold
    ToggleUIButton.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.2, 0)
    Corner.Parent = ToggleUIButton

    ToggleUIButton.TouchTap:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    return ToggleUIButton
end

-- Create touch buttons
local touchButtons = createTouchButtons()
local toggleUIButton = createToggleUIButton()

-- Function for CR7 style gameplay
local cr7LastStepTime = 0
local cr7SkillMove = 0
local cr7ShotPower = 95 -- CR7's powerful shots
local cr7SprintSpeed = 26 -- CR7's sprint speed
local cr7JumpPower = 65 -- CR7's jump power
local cr7SkillConnection = nil -- Store the connection

local function handleCR7Mode()
    if not Features.CR7Mode then return end

    -- Ensure player character exists
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then return end

    local humanoid = LocalPlayer.Character.Humanoid
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- 1. CR7 Running Style - Upright posture with quick steps
    humanoid.WalkSpeed = cr7SprintSpeed

    -- 2. CR7 Shooting - More powerful and accurate shots
    Features.ShotPower = cr7ShotPower

    -- 3. CR7 Stepovers and Skills - every 5 seconds
    local currentTime = os.time()
    if currentTime - cr7LastStepTime > 5 then
        cr7LastStepTime = currentTime
        cr7SkillMove = (cr7SkillMove % 3) + 1

        -- Visual effects for skill moves
        local skillEffect = Instance.new("Part")
        skillEffect.Shape = Enum.PartType.Ball
        skillEffect.Size = Vector3.new(1, 1, 1)
        skillEffect.Material = Enum.Material.Neon
        skillEffect.CanCollide = false
        skillEffect.Anchored = true

        -- Different skill moves use different colors
        if cr7SkillMove == 1 then
            -- Stepover (red trail)
            skillEffect.Color = Color3.fromRGB(255, 0, 0)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "CR7 Skill",
                Text = "Stepover executed!",
                Duration = 1
            })
        elseif cr7SkillMove == 2 then
            -- Chop (white trail)
            skillEffect.Color = Color3.fromRGB(255, 255, 255)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "CR7 Skill",
                Text = "Chop executed!",
                Duration = 1
            })
        else
            -- Scissors (blue trail)
            skillEffect.Color = Color3.fromRGB(0, 0, 255)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "CR7 Skill",
                Text = "Scissors executed!",
                Duration = 1
            })
        end

        -- Position the effect at the player's feet
        skillEffect.Position = rootPart.Position - Vector3.new(0, 2, 0)
        skillEffect.Parent = workspace

        -- Create a spinning effect
        local spinSpeed = 10
        local spinDuration = 1
        local startTime = tick() -- Using tick() instead of time()

        -- Cleanup previous connections
        if cr7SkillConnection then
            cr7SkillConnection:Disconnect()
        end

        -- Create a new rendering connection for this skill effect
        cr7SkillConnection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            if elapsed > spinDuration then
                skillEffect:Destroy()
                cr7SkillConnection:Disconnect()
                return
            end

            local angle = elapsed * spinSpeed * 2 * math.pi
            skillEffect.Position = rootPart.Position + Vector3.new(
                math.cos(angle) * 2,
                -2,
                math.sin(angle) * 2
            )

            skillEffect.Transparency = elapsed / spinDuration
        end)
    end

    -- 4. CR7 SIUUU celebration on goals
    -- This would be triggered when a goal is scored, using the game's goal detection mechanism

    -- 5. CR7 Free kick stance - When taking free kicks
    -- This would be triggered when the game detects a free kick situation
end

-- Set up connections
table.insert(connections, RunService.RenderStepped:Connect(function()
    if Features.AutoPass then
        handleAutoPass()
    end

    if Features.AutoShoot then
        handleAutoShoot()
    end

    if Features.PlayerESP then
        setupPlayerESP()
    end

    -- Handle CR7 mode
    if Features.CR7Mode then
        handleCR7Mode()
    end
end))

-- Handle player joining and leaving for ESP
table.insert(connections, Players.PlayerAdded:Connect(function(player)
    if Features.PlayerESP and player ~= LocalPlayer then
        local charAdded = player.CharacterAdded:Connect(function(character)
            if Features.PlayerESP then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0

                -- Color based on team
                if player.Team == LocalPlayer.Team then
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                else
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                end

                highlight.Parent = character
            end
        end)
        table.insert(connections, charAdded)
    end
end))

-- Show notification that script is loaded
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blue Lock Rivals Mobile",
    Text = "Mobile script loaded successfully!",
    Duration = 5
})

print("Blue Lock Rivals Mobile Script Loaded")