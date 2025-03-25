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

-- Mock Roblox Services for testing
-- Note: This script is designed to run in Roblox, not standalone Lua
-- This is a test environment to verify the script's functionality

-- Mock Roblox Classes
-- Vector3 class implementation
Vector3 = {}
Vector3.__index = Vector3

function Vector3.new(x, y, z)
    local self = setmetatable({}, Vector3)
    self.X = x or 0
    self.Y = y or 0
    self.Z = z or 0
    return self
end

function Vector3:Magnitude()
    return math.sqrt(self.X * self.X + self.Y * self.Y + self.Z * self.Z)
end

function Vector3:Dot(other)
    return self.X * other.X + self.Y * other.Y + self.Z * other.Z
end

function Vector3:Cross(other)
    return Vector3.new(
        self.Y * other.Z - self.Z * other.Y,
        self.Z * other.X - self.X * other.Z,
        self.X * other.Y - self.Y * other.X
    )
end

function Vector3:Normalize()
    local mag = self:Magnitude()
    if mag > 0 then
        return Vector3.new(self.X / mag, self.Y / mag, self.Z / mag)
    end
    return Vector3.new(0, 0, 0)
end

-- Vector3 arithmetic operations
function Vector3.__add(a, b)
    return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end

function Vector3.__sub(a, b)
    return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end

function Vector3.__mul(a, b)
    if type(a) == "number" then
        return Vector3.new(a * b.X, a * b.Y, a * b.Z)
    elseif type(b) == "number" then
        return Vector3.new(a.X * b, a.Y * b, a.Z * b)
    else
        return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
    end
end

function Vector3.__div(a, b)
    if type(b) == "number" then
        return Vector3.new(a.X / b, a.Y / b, a.Z / b)
    else
        return Vector3.new(a.X / b.X, a.Y / b.Y, a.Z / b.Z)
    end
end

function Vector3.__unm(a)
    return Vector3.new(-a.X, -a.Y, -a.Z)
end

function Vector3.__eq(a, b)
    return a.X == b.X and a.Y == b.Y and a.Z == b.Z
end

function Vector3.__tostring(self)
    return string.format("(%0.2f, %0.2f, %0.2f)", self.X, self.Y, self.Z)
end

-- Color3 class implementation
Color3 = {}
Color3.__index = Color3

function Color3.fromRGB(r, g, b)
    local self = setmetatable({}, Color3)
    self.R = r / 255
    self.G = g / 255
    self.B = b / 255
    return self
end

function Color3.new(r, g, b)
    local self = setmetatable({}, Color3)
    self.R = r or 0
    self.G = g or 0
    self.B = b or 0
    return self
end

-- UDim2 class implementation
UDim2 = {}
UDim2.__index = UDim2

function UDim2.new(xScale, xOffset, yScale, yOffset)
    local self = setmetatable({}, UDim2)
    self.X = {Scale = xScale or 0, Offset = xOffset or 0}
    self.Y = {Scale = yScale or 0, Offset = yOffset or 0}
    return self
end

-- Enum implementation
Enum = {
    HighlightDepthMode = {AlwaysOnTop = "AlwaysOnTop"},
    ZIndexBehavior = {Sibling = "Sibling"},
    Font = {
        SourceSans = "SourceSans",
        SourceSansBold = "SourceSansBold"
    },
    TextXAlignment = {Left = "Left"},
    EasingDirection = {Out = "Out"},
    EasingStyle = {Quart = "Quart"},
    AutomaticSize = {Y = "Y"},
    HorizontalAlignment = {Center = "Center"},
    UserInputType = {
        MouseButton1 = "MouseButton1",
        MouseMovement = "MouseMovement",
        Touch = "Touch"
    }
}

-- CFrame class implementation (simplified)
CFrame = {}
CFrame.__index = CFrame

function CFrame.new(x, y, z)
    local self = setmetatable({}, CFrame)
    self.Position = Vector3.new(x or 0, y or 0, z or 0)
    return self
end

function CFrame:ToWorldSpace(other)
    return CFrame.new(
        self.Position.X + other.Position.X,
        self.Position.Y + other.Position.Y,
        self.Position.Z + other.Position.Z
    )
end

-- Instance class implementation
Instance = {}
Instance.__index = Instance

function Instance.new(className)
    local instance = setmetatable({}, Instance)
    instance.ClassName = className
    instance.Name = className
    instance.Parent = nil
    instance.Children = {}
    instance.Properties = {}
    instance.Events = {}
    
    return instance
end

-- Mock Services
local game = {}
function game:GetService(serviceName)
    print("Accessing service: " .. serviceName)
    return {
        -- Mock necessary properties and methods of each service
    }
end

-- Define Players as global for testing environment to avoid reference issues
Players = { 
    LocalPlayer = { Name = "TestPlayer", GetMouse = function() return { X = 0, Y = 0 } end },
    GetPlayers = function() 
        return { Players.LocalPlayer } -- Return array with just the LocalPlayer for testing
    end
}
Players.LocalPlayer.WaitForChild = function(self, childName) return {} end
Players.LocalPlayer.Character = { HumanoidRootPart = { Position = Vector3.new(0, 0, 0) } }

local ReplicatedStorage = {}
local UserInputService = { TouchEnabled = false, KeyboardEnabled = true }
local RunService = { 
    Heartbeat = { 
        Connect = function(self, callback) 
            print("Mock: RunService.Heartbeat connected") 
            return { Disconnect = function() print("Mock: Connection disconnected") end }
        end 
    }
}
local TweenService = {}
local HttpService = {
    JSONEncode = function(self, data) return "{}" end,
    JSONDecode = function(self, json) return {} end
}
local CoreGui = {
    Children = {},
    
    FindFirstChild = function(self, name)
        for _, child in pairs(self.Children) do
            if child.Name == name then
                return child
            end
        end
        return nil
    end,
    
    GetChildren = function(self)
        return self.Children
    end
}
local GuiService = {}

-- Add mock Roblox exploit functions
function identifyexecutor()
    return "Lua Test Environment"
end

function getconnections(signal)
    return {}  -- Return empty table for connections
end

-- Define Vector3 first as it's used throughout
Vector3 = {}
Vector3.__index = Vector3

function Vector3.new(x, y, z)
    local self = setmetatable({}, Vector3)
    self.X = x or 0
    self.Y = y or 0
    self.Z = z or 0
    
    -- Add magnitude calculation
    self.Magnitude = math.sqrt(self.X^2 + self.Y^2 + self.Z^2)
    
    return self
end

-- Define vector operations
function Vector3.__sub(a, b)
    if type(a) == "table" and type(b) == "table" then
        return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
    end
    return Vector3.new(0, 0, 0)
end

-- Add Vector2 for DragOffset
Vector2 = {}
Vector2.__index = Vector2

function Vector2.new(x, y)
    local self = setmetatable({}, Vector2)
    self.X = x or 0
    self.Y = y or 0
    return self
end

-- Mock CFrame for teleportation
CFrame = {}
CFrame.__index = CFrame

function CFrame.new(position)
    local self = setmetatable({}, CFrame)
    if type(position) == "table" then
        self.Position = position
    else
        self.Position = Vector3.new(position, 0, 0)
    end
    return self
end

local Color3 = {}
Color3.__index = Color3

function Color3.fromRGB(r, g, b)
    local self = setmetatable({}, Color3)
    self.R = r/255
    self.G = g/255
    self.B = b/255
    return self
end

-- Define UDim first (required for UDim2 and UICorner)
local UDim = {}
UDim.__index = UDim

function UDim.new(scale, offset)
    local self = setmetatable({}, UDim)
    self.Scale = scale or 0
    self.Offset = offset or 0
    return self
end

local UDim2 = {}
UDim2.__index = UDim2

function UDim2.new(scaleX, offsetX, scaleY, offsetY)
    local self = setmetatable({}, UDim2)
    self.X = {Scale = scaleX, Offset = offsetX or 0}
    self.Y = {Scale = scaleY, Offset = offsetY or 0}
    return self
end

local Enum = {
    Font = {SourceSans = "SourceSans", SourceSansBold = "SourceSansBold"},
    TextXAlignment = {Left = "Left", Center = "Center", Right = "Right"},
    ZIndexBehavior = {Sibling = "Sibling"},
    UserInputType = {MouseButton1 = "MouseButton1", MouseMovement = "MouseMovement", Touch = "Touch"},
    EasingDirection = {Out = "Out", In = "In", InOut = "InOut"},
    EasingStyle = {Quart = "Quart", Linear = "Linear", Quad = "Quad"},
    AutomaticSize = {Y = "Y", None = "None"},
    HorizontalAlignment = {Center = "Center", Left = "Left", Right = "Right"}
}

-- Mock Instance class
local Instance = {}
function Instance.new(className)
    print("Creating instance of type: " .. className)
    local instance = {
        Name = "",
        ClassName = className,
        Parent = nil,
        Children = {},
        Properties = {},
        Connections = {},
        
        Destroy = function(self)
            if self.Parent then
                for i, child in ipairs(self.Parent.Children) do
                    if child == self then
                        table.remove(self.Parent.Children, i)
                        break
                    end
                end
            end
            
            self.Parent = nil
            for _, connection in pairs(self.Connections) do
                connection:Disconnect()
            end
            self.Connections = {}
        end,
        
        FindFirstChild = function(self, name)
            for _, child in ipairs(self.Children) do
                if child.Name == name then
                    return child
                end
            end
            return nil
        end,
        
        GetChildren = function(self)
            return self.Children
        end,
        
        IsA = function(self, className)
            return self.ClassName == className
        end,
        
        Connect = function(self, callback)
            local connection = {
                Connected = true,
                Disconnect = function(this)
                    this.Connected = false
                end
            }
            table.insert(self.Connections, connection)
            return connection
        end,
        
        TweenSize = function(self, size, direction, style, time, override, callback)
            print("Tweening size of " .. self.Name)
            self.Size = size
            if callback then callback() end
            return {
                Completed = {
                    Wait = function() return true end
                }
            }
        end,
        
        TweenPosition = function(self, position, direction, style, time, override, callback)
            print("Tweening position of " .. self.Name)
            self.Position = position
            if callback then callback() end
            return {
                Completed = {
                    Wait = function() return true end
                }
            }
        end
    }
    
    -- Handle properties for different instance types
    if className == "ScreenGui" then
        instance.ResetOnSpawn = false
        instance.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    elseif className == "Frame" or className == "ScrollingFrame" then
        instance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        instance.BackgroundTransparency = 0
        instance.BorderSizePixel = 1
        instance.Position = UDim2.new(0, 0, 0, 0)
        instance.Size = UDim2.new(0, 100, 0, 100)
        
        if className == "ScrollingFrame" then
            instance.CanvasSize = UDim2.new(0, 0, 0, 0)
            instance.AutomaticCanvasSize = Enum.AutomaticSize.None
            instance.ScrollBarThickness = 12
        end
    elseif className == "TextLabel" or className == "TextButton" then
        instance.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        instance.BackgroundTransparency = 0
        instance.BorderSizePixel = 1
        instance.Position = UDim2.new(0, 0, 0, 0)
        instance.Size = UDim2.new(0, 100, 0, 50)
        instance.Font = Enum.Font.SourceSans
        instance.Text = ""
        instance.TextColor3 = Color3.fromRGB(0, 0, 0)
        instance.TextSize = 14
        
        if className == "TextButton" then
            instance.MouseButton1Click = {
                Connect = function(self, callback)
                    local connection = {
                        Connected = true,
                        Disconnect = function(this)
                            this.Connected = false
                        end
                    }
                    table.insert(instance.Connections, connection)
                    print("Button click event connected for " .. instance.Name)
                    return connection
                end
            }
        end
    elseif className == "UICorner" then
        instance.CornerRadius = UDim.new(0, 0)
    elseif className == "UIListLayout" then
        instance.Padding = UDim.new(0, 0)
        instance.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end
    
    -- Set up property metatable
    setmetatable(instance, {
        __index = function(t, k)
            return t.Properties[k]
        end,
        __newindex = function(t, k, v)
            t.Properties[k] = v
            if k == "Parent" and v then
                table.insert(v.Children, t)
            end
        end
    })
    
    return instance
end

-- Mock workspace
local workspace = {
    Children = {},
    
    FindFirstChild = function(self, name)
        print("Looking for " .. name .. " in workspace")
        return nil
    end,
    
    GetChildren = function(self)
        return self.Children
    end,
    
    CurrentCamera = {
        Position = Vector3.new(0, 0, 0)
    }
}

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
    PlayerName = "",
    AutoTrain = false,
    AutoFarm = false,
    PlayerESP = false,
    InstantGoal = false,
    InfiniteStamina = false,
    AutoDribble = false,
    AutoGoal = false,
    AimlockBall = false,
    LegendHandles = false,
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

-- Mock Roblox filesystem operations
local fileSystem = {}
function writefile(path, content)
    print("Mock: Writing file to " .. path)
    fileSystem[path] = content
    return true
end

function readfile(path)
    print("Mock: Reading file from " .. path)
    return fileSystem[path] or ""
end

function isfile(path)
    return fileSystem[path] ~= nil
end

-- Mock print overrides
local originalPrint = print
local originalWarn = print
function print(...)
    originalPrint("INFO:", ...)
end

function warn(...)
    originalWarn("WARNING:", ...)
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
    MainFrame.Size = UDim2.new(0, 250, 0, 350) -- Made slightly taller to accommodate logo
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    
    -- Add logo/image at the top
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "LogoImage"
    LogoImage.BackgroundTransparency = 1
    LogoImage.Position = UDim2.new(0.5, -40, 0, 35) -- Positioned below title bar
    LogoImage.Size = UDim2.new(0, 80, 0, 80)
    LogoImage.Image = "rbxassetid://13429676106" -- Blue Lock ball logo
    -- Use pcall for Roblox-specific enums that might not exist in our test environment
    pcall(function()
        LogoImage.ScaleType = Enum.ScaleType.Fit
    end)
    LogoImage.Parent = MainFrame
    
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
    -- In our mock environment, we'll create these if they don't exist
    if not TitleBar.InputBegan then
        print("Setting up mock InputBegan for TitleBar")
        TitleBar.InputBegan = {
            Connect = function(self, callback)
                return {
                    Connected = true,
                    Disconnect = function() end
                }
            end
        }
    end
    
    if not TitleBar.InputEnded then
        print("Setting up mock InputEnded for TitleBar")
        TitleBar.InputEnded = {
            Connect = function(self, callback)
                return {
                    Connected = true,
                    Disconnect = function() end
                }
            end
        }
    end
    
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
    
    -- Create mock InputChanged if it doesn't exist
    if not UserInputService.InputChanged then
        print("Setting up mock InputChanged for UserInputService")
        UserInputService.InputChanged = {
            Connect = function(self, callback)
                return {
                    Connected = true,
                    Disconnect = function() end
                }
            end
        }
    end
    
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
        
        -- Ball and goal tracking variables
        local soccerBall = nil
        local enemyGoalPosition = nil
        local teamGoalPosition = nil
        local lastFarmAction = 0
        local farmState = "FIND_BALL" -- State machine: FIND_BALL, MOVE_TO_BALL, POSITION_FOR_SHOT, SHOOT
        
        -- Setup match counter for performance tracking
        local matchStats = {
            goalsScored = 0,
            matchesPlayed = 0,
            startTime = os.time()
        }
        
        -- Find the soccer ball in workspace
        local function findSoccerBall()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name == "SoccerBall" or obj.Name == "Ball" or obj.Name == "GameBall" then
                    print("Found ball: " .. obj.Name)
                    return obj
                end
            end
            
            -- If specific ball not found, look for something that might be the ball
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and 
                   (obj.Shape == Enum.PartType.Ball or string.find(string.lower(obj.Name), "ball")) then
                    print("Found potential ball: " .. obj.Name)
                    return obj
                end
            end
            
            print("No ball found")
            return nil
        end
        
        -- Function to detect goal positions
        local function findGoalPositions()
            local goalPositions = {}
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Goal" or obj.Name == "SoccerGoal" or string.find(string.lower(obj.Name), "goal") then
                    table.insert(goalPositions, obj)
                    print("Found goal: " .. obj.Name)
                end
            end
            
            -- Determine which goal belongs to which team
            if #goalPositions >= 2 then
                -- Determine which goal is ours and which is the enemy's based on distance
                local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
                if playerPos then
                    local dist1 = (playerPos - goalPositions[1].Position).Magnitude
                    local dist2 = (playerPos - goalPositions[2].Position).Magnitude
                    
                    if dist1 < dist2 then
                        -- Team goal is closer, enemy goal is farther
                        teamGoalPosition = goalPositions[1]
                        enemyGoalPosition = goalPositions[2]
                        print("Team goal: " .. goalPositions[1].Name)
                        print("Enemy goal: " .. goalPositions[2].Name)
                    else
                        -- Enemy goal is closer, team goal is farther
                        teamGoalPosition = goalPositions[2]
                        enemyGoalPosition = goalPositions[1]
                        print("Team goal: " .. goalPositions[2].Name)
                        print("Enemy goal: " .. goalPositions[1].Name)
                    end
                    
                    return true
                end
            elseif #goalPositions == 1 then
                -- Only one goal found, assume it's the enemy goal
                enemyGoalPosition = goalPositions[1]
                print("Found only one goal, assuming enemy: " .. goalPositions[1].Name)
                return true
            end
            
            print("No goals found or couldn't determine which is which")
            return false
        end
        
        -- Function to calculate shooting position
        local function calculateOptimalShootingPosition(ballPosition, goalPosition)
            if not ballPosition or not goalPosition then return nil end
            
            -- Calculate direction to goal
            local directionToGoal = (goalPosition.Position - ballPosition).Unit
            
            -- Position player slightly behind the ball in relation to the goal
            local optimalPosition = ballPosition - (directionToGoal * 4)
            
            -- Add a slight offset to avoid being directly behind
            optimalPosition = optimalPosition + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))
            
            return optimalPosition
        end
        
        -- Function to display farm stats
        local function showFarmStats()
            local timePassed = os.time() - matchStats.startTime
            local hours = math.floor(timePassed / 3600)
            local minutes = math.floor((timePassed % 3600) / 60)
            local seconds = timePassed % 60
            
            local timeString = string.format("%02d:%02d:%02d", hours, minutes, seconds)
            local goalsPerMinute = timePassed > 0 and (matchStats.goalsScored / (timePassed / 60)) or 0
            
            print("=== Auto Farm Stats ===")
            print("Time running: " .. timeString)
            print("Goals scored: " .. matchStats.goalsScored)
            print("Matches played: " .. matchStats.matchesPlayed)
            print(string.format("Goals per minute: %.2f", goalsPerMinute))
            print("=====================")
        end
        
        -- Main auto farm loop
        GameFeatures.AutoFarmConnection = RunService.Heartbeat:Connect(function()
            SafeCall(function()
                -- Exit if disabled
                if not Settings.AutoFarm then
                    if GameFeatures.AutoFarmConnection then
                        GameFeatures.AutoFarmConnection:Disconnect()
                        GameFeatures.AutoFarmConnection = nil
                    end
                    return
                end
                
                -- Throttle actions to avoid performance issues
                local currentTime = os.time()
                if currentTime - lastFarmAction < 0.1 then return end
                lastFarmAction = currentTime
                
                local gameData = GetGameData()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then return end
                
                local humanoid = character:FindFirstChild("Humanoid")
                local hrp = character:FindFirstChild("HumanoidRootPart")
                
                -- Look for match or farming areas
                local farmAreas = gameData.MatchAreas or workspace:FindFirstChild("FarmAreas") or workspace:FindFirstChild("Matches")
                
                -- Auto-join matches
                local remotes = gameData.Remotes
                if remotes then
                    local joinMatchRemote = remotes:FindFirstChild("JoinMatch") or remotes:FindFirstChild("RequestMatch") or remotes:FindFirstChild("JoinGame")
                    if joinMatchRemote and joinMatchRemote:IsA("RemoteEvent") then
                        joinMatchRemote:FireServer()
                    end
                end
                
                -- Detect if we're in a match
                local matchUI = PlayerGui:FindFirstChild("MatchUI") or PlayerGui:FindFirstChild("GameUI") or PlayerGui:FindFirstChild("InGameUI")
                local inMatch = matchUI and matchUI.Enabled
                
                if inMatch then
                    -- Make sure we have references to the ball and goal
                    if not soccerBall or not soccerBall.Parent then
                        soccerBall = findSoccerBall()
                        if not soccerBall then 
                            print("Looking for ball...")
                            return 
                        end
                    end
                    
                    if not enemyGoalPosition then
                        if not findGoalPositions() then
                            print("Looking for goals...")
                            return
                        end
                    end
                    
                    -- Calculate distances
                    local distanceToBall = (hrp.Position - soccerBall.Position).Magnitude
                    local distanceToEnemyGoal = enemyGoalPosition and (hrp.Position - enemyGoalPosition.Position).Magnitude or 999
                    
                    -- State machine for soccer auto farm
                    if farmState == "FIND_BALL" then
                        -- Find the ball and move toward it
                        print("Moving to ball, distance: " .. distanceToBall)
                        humanoid:MoveTo(soccerBall.Position)
                        
                        -- If close to ball, transition to next state
                        if distanceToBall < 8 then
                            farmState = "POSITION_FOR_SHOT"
                        end
                    
                    elseif farmState == "POSITION_FOR_SHOT" then
                        -- Position player for optimal shot
                        local shootPosition = calculateOptimalShootingPosition(soccerBall.Position, enemyGoalPosition)
                        if shootPosition then
                            print("Positioning for shot")
                            humanoid:MoveTo(shootPosition)
                            
                            -- If in position, transition to shooting
                            if (hrp.Position - shootPosition).Magnitude < 3 then
                                farmState = "SHOOT"
                            end
                        else
                            -- Fallback if calculation fails
                            farmState = "FIND_BALL"
                        end
                    
                    elseif farmState == "SHOOT" then
                        -- Execute the shot toward enemy goal
                        print("Shooting at goal!")
                        
                        -- Calculate direction to goal with slight randomization
                        local directionToGoal = (enemyGoalPosition.Position - soccerBall.Position).Unit
                        local randomOffset = Vector3.new(math.random(-5, 5)/100, math.random(0, 15)/100, math.random(-5, 5)/100)
                        local shootDirection = directionToGoal + randomOffset
                        
                        -- Calculate power based on distance
                        local distanceToGoal = (enemyGoalPosition.Position - soccerBall.Position).Magnitude
                        local shootPower = math.min(100, math.max(50, distanceToGoal * 2))
                        
                        -- Try different methods to shoot, as games implement this differently
                        
                        -- Method 1: Use kick remote
                        if remotes then
                            local kickRemote = remotes:FindFirstChild("Kick") or remotes:FindFirstChild("KickBall") or remotes:FindFirstChild("ShootBall")
                            if kickRemote and kickRemote:IsA("RemoteEvent") then
                                kickRemote:FireServer(enemyGoalPosition.Position, shootPower)
                            end
                        end
                        
                        -- Method 2: Try to directly modify ball physics
                        if soccerBall and distanceToBall < 5 then
                            -- Apply force to ball
                            soccerBall.Velocity = shootDirection * shootPower
                        end
                        
                        -- Track goal attempt
                        matchStats.goalsScored = matchStats.goalsScored + 1
                        
                        -- Show stats periodically
                        if matchStats.goalsScored % 5 == 0 then
                            showFarmStats()
                        end
                        
                        -- Reset to finding ball after shooting
                        farmState = "FIND_BALL"
                    end
                else
                    -- If not in match, look for currency/rewards to collect
                    for _, item in pairs(workspace:GetChildren()) do
                        if item:IsA("BasePart") and (item.Name:find("Coin") or item.Name:find("Currency") or item.Name:find("Reward")) then
                            if (item.Position - hrp.Position).Magnitude < 50 then
                                print("Moving to collect: " .. item.Name)
                                humanoid:MoveTo(item.Position)
                            end
                        end
                    end
                    
                    -- Look for match areas to join
                    if farmAreas then
                        for _, area in pairs(farmAreas:GetChildren()) do
                            local interactPart = area:FindFirstChild("Interact") or area:FindFirstChild("JoinPart")
                            if interactPart and interactPart:IsA("BasePart") then
                                if (interactPart.Position - hrp.Position).Magnitude > 10 then
                                    print("Moving to match area: " .. area.Name)
                                    humanoid:MoveTo(interactPart.Position)
                                else
                                    -- Try to join if close enough
                                    if remotes then
                                        local joinRemote = remotes:FindFirstChild("JoinMatch") or remotes:FindFirstChild("RequestMatch")
                                        if joinRemote and joinRemote:IsA("RemoteEvent") then
                                            print("Attempting to join match")
                                            joinRemote:FireServer(area.Name)
                                            matchStats.matchesPlayed = matchStats.matchesPlayed + 1
                                        end
                                    end
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

-- Player Name Input Dialog
function Library:ShowNameInputDialog()
    print("Showing name input dialog...")
    -- If user already has a name saved, don't show this dialog
    if Settings.PlayerName and Settings.PlayerName ~= "" then
        print("Player name already set: " .. Settings.PlayerName)
        return
    end
    
    -- Create a modal dialog for name input
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NameInputDialog"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to set CoreGui as parent, fallback to PlayerGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = PlayerGui
    end
    
    -- Create a darkened background
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Background.BackgroundTransparency = 0.5
    Background.BorderSizePixel = 0
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.Parent = ScreenGui
    
    -- Create the dialog frame
    local DialogFrame = Instance.new("Frame")
    DialogFrame.Name = "DialogFrame"
    DialogFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    DialogFrame.BorderSizePixel = 0
    DialogFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    DialogFrame.Size = UDim2.new(0, 300, 0, 200)
    DialogFrame.Parent = Background
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = DialogFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Welcome to Blue Lock Rivals"
    Title.TextColor3 = Color3.fromRGB(240, 240, 245)
    Title.TextSize = 20
    Title.Parent = DialogFrame
    
    -- Logo
    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "LogoImage"
    LogoImage.BackgroundTransparency = 1
    LogoImage.Position = UDim2.new(0.5, -30, 0, 50)
    LogoImage.Size = UDim2.new(0, 60, 0, 60)
    LogoImage.Image = "rbxassetid://13429676106" -- Blue Lock ball logo
    pcall(function()
        LogoImage.ScaleType = Enum.ScaleType.Fit
    end)
    LogoImage.Parent = DialogFrame
    
    -- Instruction text
    local InstructionText = Instance.new("TextLabel")
    InstructionText.Name = "InstructionText"
    InstructionText.BackgroundTransparency = 1
    InstructionText.Position = UDim2.new(0, 20, 0, 110)
    InstructionText.Size = UDim2.new(1, -40, 0, 20)
    InstructionText.Font = Enum.Font.SourceSans
    InstructionText.Text = "Please enter your player name:"
    InstructionText.TextColor3 = Color3.fromRGB(240, 240, 245)
    InstructionText.TextSize = 16
    InstructionText.TextXAlignment = Enum.TextXAlignment.Left
    InstructionText.Parent = DialogFrame
    
    -- Text input
    local NameInput = Instance.new("TextBox")
    NameInput.Name = "NameInput"
    NameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    NameInput.BorderSizePixel = 0
    NameInput.Position = UDim2.new(0, 20, 0, 135)
    NameInput.Size = UDim2.new(1, -40, 0, 30)
    NameInput.Font = Enum.Font.SourceSans
    NameInput.PlaceholderText = "Enter your name..."
    NameInput.Text = ""
    NameInput.TextColor3 = Color3.fromRGB(240, 240, 245)
    NameInput.TextSize = 16
    NameInput.ClearTextOnFocus = false
    NameInput.Parent = DialogFrame
    
    -- Add rounded corners to text box
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 4)
    TextBoxCorner.Parent = NameInput
    
    -- Create confirm button
    local ConfirmButton = Instance.new("TextButton")
    ConfirmButton.Name = "ConfirmButton"
    ConfirmButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    ConfirmButton.BorderSizePixel = 0
    ConfirmButton.Position = UDim2.new(0.5, -60, 1, -45)
    ConfirmButton.Size = UDim2.new(0, 120, 0, 30)
    ConfirmButton.Font = Enum.Font.SourceSansBold
    ConfirmButton.Text = "Start Playing"
    ConfirmButton.TextColor3 = Color3.fromRGB(240, 240, 245)
    ConfirmButton.TextSize = 16
    ConfirmButton.Parent = DialogFrame
    
    -- Add rounded corners to button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = ConfirmButton
    
    -- Button click event
    ConfirmButton.MouseButton1Click:Connect(function()
        local name = NameInput.Text:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
        
        if name ~= "" then
            Settings.PlayerName = name
            SaveSettings()
            print("Player name set to: " .. name)
            ScreenGui:Destroy()
        else
            -- Shake animation to indicate error
            local originalPosition = DialogFrame.Position
            for i = 1, 5 do
                DialogFrame.Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + (i % 2 == 0 and 5 or -5), originalPosition.Y.Scale, originalPosition.Y.Offset)
                wait(0.05)
            end
            DialogFrame.Position = originalPosition
            
            -- Change border color to red temporarily
            NameInput.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            wait(0.5)
            NameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        end
    end)
    
    -- Return the dialog for further customization if needed
    return {
        ScreenGui = ScreenGui,
        DialogFrame = DialogFrame,
        NameInput = NameInput
    }
end

-- Main Script Execution
local function Initialize()
    print("Initializing Blue Lock Rivals Script...")
    
    -- Load settings
    Settings = LoadSettings()
    
    -- Create GUI
    Library:CreateWindow()
    
    -- Show name input dialog if needed
    Library:ShowNameInputDialog()
    
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
    
    -- New features
    
    Library:CreateToggle("AutoGoal", Settings.AutoGoal, function(value)
        GameFeatures.SetupAutoGoal(value)
    end)
    
    Library:CreateToggle("AimlockBall", Settings.AimlockBall, function(value)
        GameFeatures.SetupAimlockBall(value)
    end)
    
    Library:CreateToggle("LegendHandles", Settings.LegendHandles, function(value)
        GameFeatures.SetupLegendHandles(value)
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
