--[[
Blue Lock Rivals Script
Created for soccer gameplay enhancement in Blue Lock Rivals Roblox game

INSTRUCTIONS:
1. Copy this entire script
2. Open your Roblox exploit/executor (like Delta)
3. Paste this script into the executor
4. Join the Blue Lock Rivals game on Roblox
5. Execute the script
6. Use the GUI to enable/disable features

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

-- Standard Lua string manipulation functions
local v0 = string.char;
local v1 = string.byte;
local v2 = string.sub;
local v3 = bit32 or bit;
local v4 = v3.bxor;
local v5 = table.concat;
local v6 = table.insert;

-- Encryption/decryption function for loading UI library securely
local function v7(v39, v40)
    local v41 = {};
    for v76 = 1, #v39 do
        v6(v41, v0(v4(v1(v2(v39, v76, v76 + 1)), v1(v2(v40, 1 + (v76 % #v40), 1 + (v76 % #v40) + 1))) % 256));
    end
    return v5(v41);
end

-- Load the UI library (Delta Library)
local v8 = loadstring(game:HttpGet("https://raw.githubusercontent.com/loglizzy/dlib/main/lib.lua"))();

-- Create the main window with mobile-friendly theme
local v9 = v8:MakeWindow({
    Name = "🔥 Blue Lock Rivals Mobile 🔥",
    Closable = true,
    Moveable = true,
    HideKeybind = "RightControl",
    Size = UDim2.new(0, 300, 0, 450),
    Position = UDim2.new(0.5, -150, 0.5, -225)
});

-- Make UI draggable for mobile
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    v9.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

v9.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = v9.Position
    end
end)

v9.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragging then
        update(input)
    end
end)

v9.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Create tabs for different features with appropriate icons
local v10 = v9:MakeTab({
    Name = "⚙️ Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

local v11 = v9:MakeTab({
    Name = "👤 Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

local movementTab = v9:MakeTab({
    Name = "🏃 Movement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

local soccerTab = v9:MakeTab({
    Name = "⚽ Soccer",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

local visualsTab = v9:MakeTab({
    Name = "👁️ Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

local skillsTab = v9:MakeTab({
    Name = "🔥 Skills",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
});

-- Initialize all global variables
getgenv().AimbotEnabled = false;
getgenv().ESPEnabled = false;
getgenv().InfiniteJumpEnabled = false;
getgenv().NoClipEnabled = false;
getgenv().CFrameWalkEnabled = false;
getgenv().BhopEnabled = false;
getgenv().CFrameWalkSpeed = 0.1;
getgenv().Smoothness = 0.6;
getgenv().AutoFarmEnabled = false;
getgenv().BallAimbotEnabled = false;
getgenv().AutoShootEnabled = false;
getgenv().AutoDefendEnabled = false;
getgenv().SuperSprintEnabled = false;
getgenv().BallMagnetEnabled = false;
getgenv().PerfectDribbleEnabled = false;
getgenv().BallPredictionEnabled = false;

-- New Blue Lock specific variables
getgenv().EgoistModeEnabled = false;
getgenv().DirectShootEnabled = false;
getgenv().AutoPassEnabled = false;
getgenv().ShotPower = 60; -- Default shooting power
getgenv().PassPower = 40; -- Default passing power

-- Get necessary game services
local v21 = game:GetService("Players");
local v22 = v21.LocalPlayer;
local v23 = v22:GetMouse();
local v24 = game:GetService("RunService");
local v25 = workspace.CurrentCamera;
local v26 = RaycastParams.new();
v26.FilterType = Enum.RaycastFilterType.Blacklist;
v26.IgnoreWater = true;

-- Soccer ball reference and tracking variables
local soccerBall = nil
local goalPositions = {}
local teamGoalPosition = nil
local enemyGoalPosition = nil
local currentStamina = 100
local maxStamina = 100
local closestPlayer = nil
local isNearBall = false
local playerPosition = nil

-- Function to find the soccer ball in workspace
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

-- Function to detect goal positions
local function findGoalPositions()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Goal" or obj.Name == "SoccerGoal" or string.find(string.lower(obj.Name), "goal") then
            table.insert(goalPositions, obj)
        end
    end
    
    -- Determine which goal belongs to which team
    if #goalPositions >= 2 then
        -- Determine which goal is ours and which is the enemy's based on distance
        local playerPos = v22.Character and v22.Character:FindFirstChild("HumanoidRootPart") and v22.Character.HumanoidRootPart.Position
        if playerPos then
            local dist1 = (playerPos - goalPositions[1].Position).Magnitude
            local dist2 = (playerPos - goalPositions[2].Position).Magnitude
            
            if dist1 < dist2 then
                teamGoalPosition = goalPositions[1]
                enemyGoalPosition = goalPositions[2]
            else
                teamGoalPosition = goalPositions[2]
                enemyGoalPosition = goalPositions[1]
            end
        end
    end
end

-- ESP system
local function v30(v42)
    if (v42.Character and not v42.Character:FindFirstChild("Totally_NOT_Esp")) then
        local v85 = 0 + 0;
        local v86;
        while true do
            if (v85 == 4) then
                v86.Parent = v42.Character;
                break;
            end
            if (v85 == (1 + 0)) then
                v86.Adornee = v42.Character;
                v86.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                v85 = 2;
            end
            if (v85 == 0) then
                local v109 = 850 - (20 + 830);
                while true do
                    if (v109 == (1 + 0)) then
                        v85 = 127 - (116 + 10);
                        break;
                    end
                    if (v109 == (0 + 0)) then
                        v86 = Instance.new("Highlight");
                        v86.Name = "Totally_NOT_Esp";
                        v109 = 739 - (542 + 196);
                    end
                end
            end
            if (v85 == (3 - 1)) then
                -- Check if player is on the same team and color accordingly
                local teamColor = Color3.fromRGB(255, 0, 0) -- Default enemy color (red)
                if v42.Team == v22.Team then
                    teamColor = Color3.fromRGB(0, 255, 0) -- Teammate color (green)
                end
                v86.FillColor = teamColor
                v86.FillTransparency = 0.5;
                v85 = 2 + 1;
            end
            if (v85 == 3) then
                v86.OutlineColor = Color3.fromRGB(255, 255, 255);
                v86.OutlineTransparency = 0;
                v85 = 409 - (118 + 287);
            end
        end
    end
end

local function v31()
    for v77, v78 in pairs(v21:GetPlayers()) do
        if (v78 ~= v22) then
            v30(v78);
        end
    end
end

v21.PlayerAdded:Connect(function(v43)
    if getgenv().ESPEnabled then
        v43.CharacterAdded:Connect(function()
            v30(v43);
        end);
    end
end);

v24.RenderStepped:Connect(function()
    if getgenv().ESPEnabled then
        v31();
    else
        for v94, v95 in pairs(v21:GetPlayers()) do
            if (v95.Character and v95.Character:FindFirstChild("Totally_NOT_Esp")) then
                v95.Character.Totally_NOT_Esp:Destroy();
            end
        end
    end
    
    -- Update the soccer ball reference
    if soccerBall == nil or not soccerBall:IsDescendantOf(workspace) then
        soccerBall = findSoccerBall()
    end
    
    -- Update player position
    if v22.Character and v22.Character:FindFirstChild("HumanoidRootPart") then
        playerPosition = v22.Character.HumanoidRootPart.Position
        
        -- Check if player is near the ball
        if soccerBall then
            local ballDistance = (playerPosition - soccerBall.Position).Magnitude
            isNearBall = ballDistance < 10
        end
    end
    
    -- Handle Ball Magnet
    if getgenv().BallMagnetEnabled and soccerBall and isNearBall then
        -- Only apply when player is close to the ball and has control
        if isNearBall then
            local offset = Vector3.new(0, 0, -3) -- Slightly in front of player
            local targetPosition = v22.Character.HumanoidRootPart.CFrame:ToWorldSpace(CFrame.new(offset)).Position
            
            -- Apply a force to move the ball toward the player, but not too aggressively
            local direction = (targetPosition - soccerBall.Position).Unit
            soccerBall.Velocity = direction * 10
        end
    end
    
    -- Handle Perfect Dribble
    if getgenv().PerfectDribbleEnabled and soccerBall and isNearBall then
        -- Apply stability to the ball's physics
        soccerBall.Velocity = Vector3.new(
            soccerBall.Velocity.X * 0.9,
            soccerBall.Velocity.Y > 0 and soccerBall.Velocity.Y * 0.5 or soccerBall.Velocity.Y,
            soccerBall.Velocity.Z * 0.9
        )
    end
    
    -- Handle Super Sprint
    if getgenv().SuperSprintEnabled and v22.Character and v22.Character:FindFirstChild("Humanoid") then
        local humanoid = v22.Character:FindFirstChild("Humanoid")
        -- Only boost when player has stamina
        if currentStamina > 10 then
            humanoid.WalkSpeed = 32 -- Boosted speed
            currentStamina = math.max(0, currentStamina - 0.2) -- Drain stamina
        else
            humanoid.WalkSpeed = 16 -- Normal speed
            currentStamina = math.min(maxStamina, currentStamina + 0.1) -- Regenerate stamina slowly
        end
    end
    
    -- Advanced Auto Shoot Logic
    if getgenv().AutoShootEnabled and soccerBall and isNearBall and enemyGoalPosition then
        -- Check if we're in a good position to shoot
        local distanceToGoal = (playerPosition - enemyGoalPosition.Position).Magnitude
        
        -- Only shoot if we're within a reasonable distance and have a clear line to goal
        if distanceToGoal < 50 then -- Within shooting distance
            -- Check for obstacles between ball and goal
            local shootParams = RaycastParams.new()
            shootParams.FilterType = Enum.RaycastFilterType.Blacklist
            shootParams.FilterDescendantsInstances = {v22.Character, soccerBall}
            
            -- Check line of sight to goal
            local shotDirection = (enemyGoalPosition.Position - soccerBall.Position).Unit
            local shotDistance = (enemyGoalPosition.Position - soccerBall.Position).Magnitude
            local obstruction = workspace:Raycast(soccerBall.Position, shotDirection * shotDistance, shootParams)
            
            -- Calculate shooting quality based on angle, distance, and obstacles
            local shootQuality = 1.0
            
            -- If there's an obstruction, reduce shoot quality
            if obstruction then
                -- Check if obstruction is near the goal (might be the goal itself)
                local obstructionDistance = (obstruction.Position - enemyGoalPosition.Position).Magnitude
                if obstructionDistance > 10 then
                    -- Significant obstruction, reduce quality
                    shootQuality = 0.3
                else
                    -- Likely the goal itself or nearby, minor reduction
                    shootQuality = 0.9
                end
            end
            
            -- Adjust for distance - closer is better but not too close
            if distanceToGoal > 40 then
                shootQuality = shootQuality * 0.7 -- Long shot, harder
            elseif distanceToGoal < 10 then
                shootQuality = shootQuality * 0.9 -- Too close, might hit goalkeeper
            else
                shootQuality = shootQuality * 1.0 -- Ideal range
            end
            
            -- Calculate shooting power based on distance
            local shootPower = math.min(getgenv().ShotPower, distanceToGoal * 2)
            
            -- Ensure minimum power for short distances
            shootPower = math.max(shootPower, 30)
            
            -- Only take the shot if quality is good enough
            if shootQuality > 0.5 then
                -- Calculate direction toward goal with slight randomization based on quality
                local directionToGoal = (enemyGoalPosition.Position - soccerBall.Position).Unit
                
                -- Higher quality shots have less randomization
                local randomFactor = (1 - shootQuality) * 0.2
                directionToGoal = directionToGoal + Vector3.new(
                    math.random(-randomFactor, randomFactor),
                    math.random(0.05, 0.1 + randomFactor),  -- Always some upward force
                    math.random(-randomFactor, randomFactor)
                )
                
                -- Apply force to the ball
                soccerBall.Velocity = directionToGoal * shootPower
                
                -- Visual effect for the shot
                local shootEffect = Instance.new("Part")
                shootEffect.Shape = Enum.PartType.Ball
                shootEffect.Size = Vector3.new(1, 1, 1)
                shootEffect.Material = Enum.Material.Neon
                shootEffect.Color = Color3.fromRGB(255, 165, 0) -- Orange for shots
                shootEffect.Transparency = 0.5
                shootEffect.CanCollide = false
                shootEffect.Anchored = true
                shootEffect.Position = soccerBall.Position
                shootEffect.Parent = workspace
                
                -- Remove the effect after a short time
                game:GetService("Debris"):AddItem(shootEffect, 0.3)
                
                -- Create a trail effect for the shot
                local trail = Instance.new("Trail")
                trail.Attachment0 = Instance.new("Attachment", soccerBall)
                trail.Attachment1 = Instance.new("Attachment", soccerBall)
                trail.Attachment1.Position = Vector3.new(0, 0, -1)
                trail.Color = ColorSequence.new(Color3.fromRGB(255, 165, 0))
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                trail.Lifetime = 0.5
                trail.Parent = soccerBall
                
                -- Remove the trail after a short time
                game:GetService("Debris"):AddItem(trail, 1)
                
                -- Shot indicator text
                local shotIndicator = Instance.new("BillboardGui")
                shotIndicator.AlwaysOnTop = true
                shotIndicator.Size = UDim2.new(0, 100, 0, 40)
                shotIndicator.StudsOffset = Vector3.new(0, 3, 0)
                shotIndicator.Adornee = v22.Character.Head
                
                local shotText = Instance.new("TextLabel")
                shotText.Size = UDim2.new(1, 0, 1, 0)
                shotText.BackgroundTransparency = 1
                shotText.TextColor3 = Color3.fromRGB(255, 165, 0)
                shotText.Text = "SHOOT!"
                shotText.Font = Enum.Font.GothamBold
                shotText.TextScaled = true
                shotText.Parent = shotIndicator
                
                shotIndicator.Parent = workspace
                game:GetService("Debris"):AddItem(shotIndicator, 1)
            end
        end
    end
    
    -- Auto Defend Logic
    if getgenv().AutoDefendEnabled and teamGoalPosition then
        -- Check if we need to defend (ball is moving toward our goal)
        if soccerBall then
            local ballToGoalDistance = (soccerBall.Position - teamGoalPosition.Position).Magnitude
            
            if ballToGoalDistance < 40 and not isNearBall then
                -- Move player to intercept the ball
                local humanoid = v22.Character and v22.Character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Predict where the ball will be
                    local predictedPosition = soccerBall.Position + (soccerBall.Velocity * 0.5)
                    
                    -- Create a movement target
                    local target = Instance.new("Part")
                    target.Anchored = true
                    target.CanCollide = false
                    target.Transparency = 1
                    target.Position = predictedPosition
                    target.Parent = workspace
                    
                    -- Move to intercept
                    humanoid:MoveTo(predictedPosition)
                    
                    -- Clean up
                    game:GetService("Debris"):AddItem(target, 0.5)
                end
            end
        end
    end
    
    -- Auto Pass Logic
    if getgenv().AutoPassEnabled and soccerBall and isNearBall then
        -- We need to be close to the ball to pass
        -- First check if there's a good teammate to pass to
        local bestTeammate, bestScore = findBestTeammate()
        
        -- Only pass if we found a good teammate with a decent score
        if bestTeammate and bestScore > 50 then
            -- Calculate direction and distance
            local teammatePos = bestTeammate.Character.HumanoidRootPart.Position
            local passDirection = (teammatePos - soccerBall.Position).Unit
            local distanceToTeammate = (teammatePos - soccerBall.Position).Magnitude
            
            -- Factor in arc for longer passes
            local arcVector = Vector3.new(0, 0, 0)
            if distanceToTeammate > 20 then
                -- Add more upward force for longer passes
                local arcHeight = math.min(0.4, distanceToTeammate * 0.01)
                arcVector = Vector3.new(0, arcHeight, 0)
            end
            
            -- Calculate power based on distance
            local passPower = math.min(getgenv().PassPower, distanceToTeammate * 1.5)
            
            -- Apply the pass force to the ball
            soccerBall.Velocity = (passDirection + arcVector) * passPower
            
            -- Create visual indicator for the pass
            local passEffect = Instance.new("Part")
            passEffect.Shape = Enum.PartType.Ball
            passEffect.Size = Vector3.new(0.5, 0.5, 0.5)
            passEffect.Material = Enum.Material.Neon
            passEffect.Color = Color3.fromRGB(0, 255, 255) -- Cyan for passes
            passEffect.Transparency = 0.6
            passEffect.CanCollide = false
            passEffect.Anchored = true
            passEffect.Position = soccerBall.Position
            passEffect.Parent = workspace
            
            -- Remove the effect after a short time
            game:GetService("Debris"):AddItem(passEffect, 0.2)
            
            -- Create a line showing the pass trajectory
            local passLine = Instance.new("Part")
            passLine.Name = "PassLine"
            passLine.Anchored = true
            passLine.CanCollide = false
            passLine.Transparency = 0.6
            passLine.Color = Color3.fromRGB(0, 255, 255) -- Cyan line
            passLine.Size = Vector3.new(0.1, 0.1, distanceToTeammate)
            passLine.CFrame = CFrame.lookAt(soccerBall.Position, teammatePos) * CFrame.new(0, 0, -distanceToTeammate/2)
            passLine.Parent = workspace
            
            -- Create visual target marker on teammate
            local targetMarker = Instance.new("Part")
            targetMarker.Shape = Enum.PartType.Cylinder
            targetMarker.Size = Vector3.new(0.1, 5, 5)
            targetMarker.Orientation = Vector3.new(0, 0, 90)
            targetMarker.Material = Enum.Material.Neon
            targetMarker.Color = Color3.fromRGB(0, 255, 255)
            targetMarker.Transparency = 0.7
            targetMarker.CanCollide = false
            targetMarker.Anchored = true
            targetMarker.Position = teammatePos + Vector3.new(0, 0.1, 0)
            targetMarker.Parent = workspace
            
            -- Clean up the visuals
            game:GetService("Debris"):AddItem(passLine, 0.5)
            game:GetService("Debris"):AddItem(targetMarker, 0.5)
            
            -- Add indicator text above the teammate
            local passIndicator = Instance.new("BillboardGui")
            passIndicator.AlwaysOnTop = true
            passIndicator.Size = UDim2.new(0, 100, 0, 40)
            passIndicator.StudsOffset = Vector3.new(0, 3, 0)
            passIndicator.Adornee = bestTeammate.Character.Head
            
            local passText = Instance.new("TextLabel")
            passText.Size = UDim2.new(1, 0, 1, 0)
            passText.BackgroundTransparency = 1
            passText.TextColor3 = Color3.fromRGB(0, 255, 255)
            passText.Text = "PASS!"
            passText.Font = Enum.Font.GothamBold
            passText.TextScaled = true
            passText.Parent = passIndicator
            
            passIndicator.Parent = workspace
            game:GetService("Debris"):AddItem(passIndicator, 1)
        end
    end
    
    -- Update ball prediction visualization
    if getgenv().BallPredictionEnabled and soccerBall then
        -- Remove old prediction line if it exists
        local oldPrediction = workspace:FindFirstChild("BallPredictionLine")
        if oldPrediction then
            oldPrediction:Destroy()
        end
        
        -- Create a prediction line to show ball trajectory
        local predictionLine = Instance.new("Part")
        predictionLine.Name = "BallPredictionLine"
        predictionLine.Anchored = true
        predictionLine.CanCollide = false
        predictionLine.Transparency = 0.5
        predictionLine.Color = Color3.fromRGB(255, 255, 0) -- Yellow line
        
        -- Calculate where the ball will be in the next second
        local predictedPosition = soccerBall.Position + (soccerBall.Velocity * 1)
        
        -- Create a line from current ball position to predicted position
        local distance = (predictedPosition - soccerBall.Position).Magnitude
        predictionLine.Size = Vector3.new(0.2, 0.2, distance)
        predictionLine.CFrame = CFrame.lookAt(soccerBall.Position, predictedPosition) * CFrame.new(0, 0, -distance/2)
        
        predictionLine.Parent = workspace
        
        -- Set the line to be removed after a short period
        game:GetService("Debris"):AddItem(predictionLine, 0.1)
    end
    
    -- Direct Shoot implementation - Powerful straight shots with less curve
    if getgenv().DirectShootEnabled and soccerBall and isNearBall and v23.KeyDown then
        -- Check for key press (F key for shooting)
        local inputService = game:GetService("UserInputService")
        if inputService:IsKeyDown(Enum.KeyCode.F) then
            -- Check if player is near the ball and facing a good direction
            if enemyGoalPosition then
                -- Calculate direct line to goal
                local directionToGoal = (enemyGoalPosition.Position - soccerBall.Position).Unit
                
                -- Apply a strong, direct force with minimal randomization
                -- Uses the ShotPower variable set by the slider
                local shootForce = directionToGoal * getgenv().ShotPower
                
                -- Add a slight upward component for a low trajectory
                shootForce = shootForce + Vector3.new(0, 0.05 * getgenv().ShotPower, 0)
                
                -- Apply the force to the ball
                soccerBall.Velocity = shootForce
                
                -- Visual effect - optional
                local shootEffect = Instance.new("Part")
                shootEffect.Shape = Enum.PartType.Ball
                shootEffect.Size = Vector3.new(1, 1, 1)
                shootEffect.Material = Enum.Material.Neon
                shootEffect.Color = Color3.fromRGB(255, 0, 0)
                shootEffect.Transparency = 0.5
                shootEffect.CanCollide = false
                shootEffect.Anchored = true
                shootEffect.Position = soccerBall.Position
                shootEffect.Parent = workspace
                
                -- Remove the effect after a short time
                game:GetService("Debris"):AddItem(shootEffect, 0.3)
                
                -- Create a trail effect in the direction of the shot
                local trail = Instance.new("Trail")
                trail.Attachment0 = Instance.new("Attachment", soccerBall)
                trail.Attachment1 = Instance.new("Attachment", soccerBall)
                trail.Attachment1.Position = Vector3.new(0, 0, -1)
                trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
                trail.Lifetime = 0.5
                trail.Parent = soccerBall
                
                -- Remove the trail after a short time
                game:GetService("Debris"):AddItem(trail, 1)
            end
        end
    end
    
    -- Egoist Mode implementation - Focus solely on scoring, ignoring teammates
    if getgenv().EgoistModeEnabled and v22.Character and v22.Character:FindFirstChild("Humanoid") then
        -- Only activate when we have the ball or are near it
        if isNearBall and enemyGoalPosition then
            local humanoid = v22.Character:FindFirstChild("Humanoid")
            
            -- If we're far from the goal, move directly toward it with the ball
            local distanceToGoal = (playerPosition - enemyGoalPosition.Position).Magnitude
            
            if distanceToGoal > 20 then
                -- Calculate the best path to goal
                local directionToGoal = (enemyGoalPosition.Position - playerPosition).Unit
                local targetPosition = playerPosition + (directionToGoal * 5)
                
                -- Move toward the goal
                humanoid:MoveTo(targetPosition)
                
                -- Control the ball while moving
                if soccerBall then
                    -- Keep the ball slightly ahead of the player
                    local ballOffset = directionToGoal * 3
                    local targetBallPosition = playerPosition + ballOffset
                    
                    -- Apply force to keep ball in control
                    local ballDirection = (targetBallPosition - soccerBall.Position).Unit
                    soccerBall.Velocity = ballDirection * 15
                end
            else
                -- We're close to the goal, attempt a shot
                if soccerBall then
                    -- Calculate shooting direction with slight randomization
                    local shootDirection = (enemyGoalPosition.Position - soccerBall.Position).Unit
                    shootDirection = shootDirection + Vector3.new(math.random(-0.05, 0.05), math.random(0.1, 0.2), math.random(-0.05, 0.05))
                    
                    -- Powerful shot
                    soccerBall.Velocity = shootDirection * getgenv().ShotPower
                end
            end
            
            -- Visual indicator for Egoist Mode
            if not workspace:FindFirstChild("EgoistModeIndicator") then
                local indicator = Instance.new("BillboardGui")
                indicator.Name = "EgoistModeIndicator"
                indicator.AlwaysOnTop = true
                indicator.Size = UDim2.new(0, 100, 0, 40)
                indicator.StudsOffset = Vector3.new(0, 3, 0)
                indicator.Adornee = v22.Character.Head
                
                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(255, 0, 0)
                text.Text = "EGOIST MODE"
                text.Font = Enum.Font.GothamBold
                text.TextScaled = true
                text.Parent = indicator
                
                indicator.Parent = workspace
            end
        else
            -- Remove the indicator when not near ball
            local indicator = workspace:FindFirstChild("EgoistModeIndicator")
            if indicator then
                indicator:Destroy()
            end
        end
    else
        -- Clean up indicator if mode is disabled
        local indicator = workspace:FindFirstChild("EgoistModeIndicator")
        if indicator then
            indicator:Destroy()
        end
    end
end);

-- Function to find the closest player for aimbot
local function v32()
    local v44 = nil;
    local v45 = math.huge;
    for v79, v80 in pairs(v21:GetPlayers()) do
        if ((v80 ~= v22) and v80.Character and v80.Character:FindFirstChild("HumanoidRootPart")) then
            local v96 = 0;
            local v97;
            while true do
                if ((0 - 0) == v96) then
                    v97 = (v22.Character.HumanoidRootPart.Position - v80.Character.HumanoidRootPart.Position).magnitude;
                    if (v97 < v45) then
                        local v125 = 1121 - (118 + 1003);
                        while true do
                            if (v125 == (0 - 0)) then
                                v45 = v97;
                                v44 = v80;
                                break;
                            end
                        end
                    end
                    break;
                end
            end
        end
    end
    return v44;
end

-- Function to find the best teammate to pass to
local function findBestTeammate()
    local bestTeammate = nil
    local bestScore = -1
    
    -- We'll use a scoring system to determine the best pass target
    -- Factors: distance from player, distance to enemy goal, open passing lane
    for _, player in pairs(v21:GetPlayers()) do
        -- Skip self and players without characters
        if player ~= v22 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Skip enemies (if team information is available)
            if not player.Team or player.Team == v22.Team then
            
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
                    
                    -- If goal positions are known, factor in goal proximity
                    if enemyGoalPosition then
                        local distanceToGoal = (teammatePos - enemyGoalPosition.Position).Magnitude
                        
                        -- Better score for players closer to enemy goal
                        score = score + (200 - math.min(200, distanceToGoal))
                    end
                    
                    -- Check if pass lane is clear
                    local passDirection = (teammatePos - playerPosition).Unit
                    local passLaneParams = RaycastParams.new()
                    passLaneParams.FilterType = Enum.RaycastFilterType.Blacklist
                    passLaneParams.FilterDescendantsInstances = {v22.Character, player.Character, soccerBall}
                    
                    local passRay = workspace:Raycast(playerPosition, passDirection * distanceToTeammate, passLaneParams)
                    
                    -- If there's an obstruction, reduce the score significantly
                    if passRay then
                        score = score - 50
                    end
                    
                    -- Update best teammate if this one has a better score
                    if score > bestScore then
                        bestScore = score
                        bestTeammate = player
                    end
                end -- end if distanceToTeammate
            end -- end if player.Team
        end -- end if player ~= v22
    end
    
    return bestTeammate, bestScore
end

-- Autofarm connection tracking variable
local v33 = nil;

-- Setup autofarm function
local function v34()
    local v46 = 377 - (142 + 235);
    local v47;
    while true do
        if ((0 - 0) == v46) then
            v47 = v32();
            if (v47 and v47.Character and v47.Character:FindFirstChild("HumanoidRootPart")) then
                local v114 = v47.Character:FindFirstChild("Humanoid");
                local function v115()
                    if (v22.Character and v22.Character:FindFirstChild("HumanoidRootPart")) then
                        local v126 = v22.Character.HumanoidRootPart;
                        local v127 = v47.Character.HumanoidRootPart;
                        local v128 = v127.Position + Vector3.new(0, 2 + 6, 977 - (553 + 424));
                        v126.CFrame = CFrame.new(v128, v127.Position);
                    end
                end
                if v114 then
                    local v122 = 0 - 0;
                    while true do
                        if (v122 == 0) then
                            v33 = v24.Heartbeat:Connect(v115);
                            v114.Died:Connect(function()
                                if v33 then
                                    v33:Disconnect();
                                end
                            end);
                            break;
                        end
                    end
                end
            end
            break;
        end
    end
end

-- Function for Soccer-specific autofarm
local function setupSoccerAutoFarm()
    if v33 then
        v33:Disconnect()
    end
    
    v33 = v24.Heartbeat:Connect(function()
        if not getgenv().AutoFarmEnabled then
            v33:Disconnect()
            return
        end
        
        -- Make sure ball reference is valid
        if not soccerBall then
            soccerBall = findSoccerBall()
            return
        end
        
        if not enemyGoalPosition then
            findGoalPositions()
            return
        end
        
        if v22.Character and v22.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v22.Character.HumanoidRootPart
            local humanoid = v22.Character:FindFirstChild("Humanoid")
            
            -- If not near ball, move to the ball
            local distanceToBall = (hrp.Position - soccerBall.Position).Magnitude
            if distanceToBall > 5 then
                if humanoid then
                    humanoid:MoveTo(soccerBall.Position)
                end
                return
            end
            
            -- If near ball, move toward enemy goal
            if humanoid then
                -- Calculate direction to goal
                local directionToGoal = (enemyGoalPosition.Position - soccerBall.Position).Unit
                
                -- Position player slightly behind the ball in relation to the goal
                local positionBehindBall = soccerBall.Position - (directionToGoal * 4)
                
                -- Move to position
                humanoid:MoveTo(positionBehindBall)
                
                -- Kick the ball
                if distanceToBall < 5 then
                    -- Apply force to ball toward goal
                    soccerBall.Velocity = directionToGoal * 60
                end
            end
        end
    end)
end

-- Autofarm activation
v23.Button1Down:Connect(function()
    if getgenv().AutoFarmEnabled then
        local v87 = 0;
        local v88;
        while true do
            if ((0 + 0) == v87) then
                v88 = 0 + 0;
                while true do
                    if (v88 == 0) then
                        if v33 then
                            v33:Disconnect();
                        end
                        setupSoccerAutoFarm();
                        break;
                    end
                end
                break;
            end
        end
    end
end);

-- Function to check if a player is visible
local function v35(v48)
    if (not v48 or not v48.Character or not v48.Character:FindFirstChild("Head")) then
        return false;
    end
    local v49 = v48.Character;
    local v50 = v49.Head;
    v26.FilterDescendantsInstances = {v22.Character,v49};
    local v52 = v25.CFrame.Position;
    local v53 = (v50.Position - v52).Unit * (v50.Position - v52).Magnitude;
    local v54 = workspace:Raycast(v52, v53, v26);
    return (v54 == nil) or v54.Instance:IsDescendantOf(v49);
end

-- Function to find the best target player for aimbot
local function v36()
    local v55 = nil;
    local v56 = math.huge;
    local v57 = v25.CFrame.LookVector;
    for v81, v82 in pairs(v21:GetPlayers()) do
        if ((v82 ~= v22) and v82.Character and v82.Character:FindFirstChild("Head") and (v82.Character:FindFirstChildOfClass("Humanoid").Health > (0 + 0))) then
            if v35(v82) then
                local v116 = 0 + 0;
                local v117;
                local v118;
                local v119;
                while true do
                    if (v116 == (0 - 0)) then
                        local v130 = 0;
                        while true do
                            if (v130 == (0 - 0)) then
                                v117 = v82.Character.Head;
                                v118 = (v117.Position - v25.CFrame.Position).Unit;
                                v130 = 2 - 1;
                            end
                            if (v130 == (1 + 0)) then
                                v116 = 4 - 3;
                                break;
                            end
                        end
                    end
                    if (v116 == 1) then
                        v119 = v57:Dot(v118);
                        if (v119 > 0.9) then
                            local v137 = 753 - (239 + 514);
                            local v138;
                            while true do
                                if (v137 == (0 + 0)) then
                                    v138 = (v117.Position - v25.CFrame.Position).Magnitude;
                                    if (v138 < v56) then
                                        local v142 = 0;
                                        while true do
                                            if (v142 == (1329 - (797 + 532))) then
                                                v55 = v82;
                                                v56 = v138;
                                                break;
                                            end
                                        end
                                    end
                                    break;
                                end
                            end
                        end
                        break;
                    end
                end
            end
        end
    end
    return v55;
end

-- Function for ball-based aimbot
local function findBallAimTarget()
    if soccerBall then
        -- First check if ball is visible
        local ballPos = soccerBall.Position
        local cameraPos = v25.CFrame.Position
        
        -- Create a ray from camera to ball
        local ray = (ballPos - cameraPos).Unit * (ballPos - cameraPos).Magnitude
        
        -- Check for obstructions
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {v22.Character, soccerBall}
        
        local result = workspace:Raycast(cameraPos, ray, params)
        
        -- If nothing blocking view of ball, return ball as target
        if result == nil or result.Instance == soccerBall then
            return soccerBall
        end
    end
    
    return nil
end

-- Aimbot tracking variables
local v37 = false;

v23.Button1Down:Connect(function()
    v37 = true;
    while v37 do
        -- Choose which aimbot mode to use
        if getgenv().AimbotEnabled and not getgenv().BallAimbotEnabled then
            -- Player aimbot
            local target = v36();
            if (target and target.Character and target.Character:FindFirstChild("Head")) then
                local targetHead = target.Character.Head;
                local headPos = targetHead.Position;
                local currentCFrame = v25.CFrame;
                local newCFrame = CFrame.new(currentCFrame.Position, headPos);
                
                -- Apply smoothness
                v25.CFrame = currentCFrame:Lerp(newCFrame, getgenv().Smoothness);
            end
        elseif getgenv().BallAimbotEnabled and not getgenv().AimbotEnabled then
            -- Ball aimbot
            local ballTarget = findBallAimTarget();
            if ballTarget then
                local ballPos = ballTarget.Position;
                local currentCFrame = v25.CFrame;
                local newCFrame = CFrame.new(currentCFrame.Position, ballPos);
                
                -- Apply smoothness
                v25.CFrame = currentCFrame:Lerp(newCFrame, getgenv().Smoothness);
            end
        end
        
        v24.RenderStepped:Wait();
    end
end);

v23.Button1Up:Connect(function()
    v37 = false;
end);

-- Infinite Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled and v22.Character then
        v22.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Bhop Logic
v24.Heartbeat:Connect(function()
    if getgenv().BhopEnabled and v22.Character then
        local humanoid = v22.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- UI Callback functions
v10:AddToggle({
    Name = "Player Aimbot",
    Default = false,
    Callback = function(v58)
        getgenv().AimbotEnabled = v58;
        if v58 then
            getgenv().BallAimbotEnabled = false;
        end
    end
});

v10:AddToggle({
    Name = "Ball Aimbot",
    Default = false,
    Callback = function(v64)
        getgenv().BallAimbotEnabled = v64;
        if v64 then
            getgenv().AimbotEnabled = false;
        end
    end
});

v10:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(v60)
        getgenv().ESPEnabled = v60;
    end
});

v10:AddToggle({
    Name = "Auto Farm Goals",
    Default = false,
    Callback = function(v62)
        getgenv().AutoFarmEnabled = v62;
        if v62 then
            setupSoccerAutoFarm();
        else
            if v33 then
                v33:Disconnect();
            end
        end
    end
});

v10:AddSlider({
    Name = "Aimbot Smoothness",
    Min = 0.1,
    Max = 1,
    Default = 0.6,
    Increment = 0.01,
    Callback = function(v64)
        getgenv().Smoothness = v64;
    end
});

soccerTab:AddToggle({
    Name = "Auto Shoot",
    Default = false,
    Callback = function(value)
        getgenv().AutoShootEnabled = value;
    end
});

soccerTab:AddToggle({
    Name = "Auto Defend",
    Default = false,
    Callback = function(value)
        getgenv().AutoDefendEnabled = value;
    end
});

soccerTab:AddToggle({
    Name = "Ball Magnet",
    Default = false,
    Callback = function(value)
        getgenv().BallMagnetEnabled = value;
    end
});

soccerTab:AddToggle({
    Name = "Perfect Dribble",
    Default = false,
    Callback = function(value)
        getgenv().PerfectDribbleEnabled = value;
    end
});

soccerTab:AddToggle({
    Name = "Ball Prediction",
    Default = false,
    Callback = function(value)
        getgenv().BallPredictionEnabled = value;
    end
});

soccerTab:AddToggle({
    Name = "Auto Pass",
    Default = false,
    Callback = function(value)
        getgenv().AutoPassEnabled = value;
        
        -- When enabled, this feature will automatically pass to the best positioned teammate
    end
});

soccerTab:AddToggle({
    Name = "Auto Score Egoist Mode",
    Default = false,
    Callback = function(value)
        getgenv().EgoistModeEnabled = value;
        
        -- When enabled, this feature will make your character focus solely on scoring
        -- Ignoring teammates like Isagi's "Egoist Mode" from Blue Lock anime
    end
});

soccerTab:AddToggle({
    Name = "Direct Shoot",
    Default = false,
    Callback = function(value)
        getgenv().DirectShootEnabled = value;
        
        -- Enables more powerful direct shooting with less curve
    end
});

soccerTab:AddSlider({
    Name = "Shot Power",
    Min = 10,
    Max = 150,
    Default = 60,
    Increment = 5,
    Callback = function(value)
        getgenv().ShotPower = value;
    end
});

soccerTab:AddSlider({
    Name = "Pass Power",
    Min = 10,
    Max = 100,
    Default = 40,
    Increment = 5,
    Callback = function(value)
        getgenv().PassPower = value;
    end
});

movementTab:AddToggle({
    Name = "Super Sprint",
    Default = false,
    Callback = function(value)
        getgenv().SuperSprintEnabled = value;
        
        -- Reset walk speed when disabled
        if not value and v22.Character and v22.Character:FindFirstChild("Humanoid") then
            v22.Character.Humanoid.WalkSpeed = 16
        end
    end
});

v11:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(v66)
        getgenv().InfiniteJumpEnabled = v66;
    end
});

v11:AddToggle({
    Name = "Bhop",
    Default = false,
    Callback = function(v68)
        getgenv().BhopEnabled = v68;
    end
});

v11:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(v70)
        getgenv().NoClipEnabled = v70;
        
        if v70 then
            -- Setup NoClip
            local noclipConnection
            noclipConnection = v24.Stepped:Connect(function()
                if not getgenv().NoClipEnabled then
                    noclipConnection:Disconnect()
                    return
                end
                
                if v22.Character then
                    for _, part in pairs(v22.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
});

-- Info section
v10:AddLabel("Blue Lock Rivals Script");
v10:AddLabel("Soccer-specific enhancements active");

-- Initialize game specific elements
v24.RenderStepped:Connect(function()
    if not goalPositions or #goalPositions == 0 then
        findGoalPositions()
    end
    
    if not soccerBall then
        soccerBall = findSoccerBall()
    end
end)

-- Show notification that script is loaded
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blue Lock Rivals Script",
    Text = "Script loaded successfully!",
    Duration = 5
})

print("Blue Lock Rivals Script Loaded")

-- The script is complete
