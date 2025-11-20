--[[
    LumaBestHub Key System Script
    Purpose: Provides a Key UI for access control via pandadevelopment.net or a custom API.
    
    NOTE: All exploit/duplication code has been removed. 
    This script provides the key system functionality only.
]]--

-- Roblox Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Key System Configuration
local Identifier = "lumabesthub" -- Your new service identifier
local KeyServiceBaseURL = "https://pandadevelopment.net" -- The Key System Provider
local UserID = LocalPlayer.UserId
local ConfigFolder = "LumaBestHubConfig"
local ConfigFile = ConfigFolder .. "/saved_key.txt"
local FreeAccess = false -- Set to true to allow access without a valid key

-- Local Script State
local KeyValidated = false

-- Rayfield UI Placeholder (Replace with the actual script you want to run)
local Rayfield = nil
local function RunSafeScript()
    -- !!! REPLACE THIS FUNCTION WITH YOUR ACTUAL, SAFE SCRIPT CODE !!!
    -- This code will run AFTER the key is successfully validated.
    print("[LumaBestHub] Key validated. Loading Main Script/UI...")

    -- Example: Load Rayfield and create a simple window
    if not Rayfield then
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
        Rayfield:CreateWindow({
            Name = "LumaBestHub - Main Menu",
            LoadingTitle = "LumaBestHub",
            LoadingSubtitle = "Key Access Granted",
            ConfigurationSaving = { Enabled = false },
            KeySystem = false
        })

        local MainTab = Rayfield:CreateTab("Utility")
        MainTab:CreateLabel("Welcome! Your key was successfully validated.")
        
        -- Remove the Key UI after loading the main script
        ScreenGui:Destroy()
    end
end


-- --- UI CREATION ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LumaBestHubKeyUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- [TITLE BAR]
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LumaBest Hub Key System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = TitleBar

-- [CLOSE BUTTON]
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- [INPUTS]
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.9, 0, 0, 40)
KeyInput.Position = UDim2.new(0.05, 0, 0, 80)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.TextColor3 = Color3.fromRGB(200, 200, 200)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.Gotham
KeyInput.PlaceholderText = "Enter your key"
KeyInput.Text = ""
KeyInput.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 60)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Enter a valid key to access LumaBest Hub."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextWrapped = true
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
StatusLabel.Parent = MainFrame

-- [NOTIFICATION FRAME (KEEPING IT SIMPLE)]
local NotificationFrame = Instance.new("Frame")
-- ... (Notification Frame UI setup as in your original script) ...
NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
NotificationFrame.Position = UDim2.new(1, -320, 0, 20)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotificationFrame.Parent = ScreenGui
NotificationFrame.Visible = false

local NotificationLabel = Instance.new("TextLabel")
NotificationLabel.Size = UDim2.new(1, -20, 1, -20)
NotificationLabel.Position = UDim2.new(0, 10, 0, 10)
NotificationLabel.BackgroundTransparency = 1
NotificationLabel.Text = ""
NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationLabel.TextSize = 14
NotificationLabel.Font = Enum.Font.Gotham
NotificationLabel.Parent = NotificationFrame

-- Notification Function (Keep simple)
local function ShowNotification(message, color, duration)
    NotificationLabel.Text = message
    NotificationLabel.TextColor3 = color
    NotificationFrame.Visible = true
    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -320, 0, 20)})
    tweenIn:Play()
    task.spawn(function()
        task.wait(duration or 3)
        local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 20)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        NotificationFrame.Visible = false
    end)
end


-- --- KEY LOGIC FUNCTIONS ---

-- GetKey Function (Uses Panda URL)
local function GetKey()
    return KeyServiceBaseURL .. "/getkey?service=" .. Identifier .. "&hwid=" .. UserID
end

-- Save/Load Key Functions (assuming your executor supports these functions)
local function SaveKey(key)
    -- Check if isfolder/writefile/makefolder exist (executor support)
    if isfolder and writefile and makefolder then
        if isfolder(ConfigFolder) then
            writefile(ConfigFile, key)
        else
            makefolder(ConfigFolder)
            writefile(ConfigFile, key)
        end
    else
        print("Warning: SaveKey functions not supported by executor.")
    end
end

local function LoadKey()
    if isfolder and isfile and readfile then
        if isfolder(ConfigFolder) and isfile(ConfigFile) then
            return readfile(ConfigFile)
        end
    end
    return ""
end

-- ValidateKey Function (Uses Panda URL)
local function ValidateKey(key)
    if key == "" then
        StatusLabel.Text = "[LumaBest Hub] No Key Entered."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        ShowNotification("Please enter a key.", Color3.fromRGB(255, 100, 100), 3)
        return false
    end

    -- Panda Development V2 API URL
    local Url = KeyServiceBaseURL .. "/v2_validation?key=" .. key .. "&service=" .. Identifier .. "&hwid=" .. UserID
    local success, DataFetch = pcall(function()
        -- Assuming 'request' is available in your execution environment
        return request({
            Url = Url,
            Method = "GET"
        })
    end)

    if success and DataFetch and DataFetch.Success then
        local JsonData = HttpService:JSONDecode(DataFetch.Body)
        if JsonData["V2_Authentication"] == "success" then
            StatusLabel.Text = "[LumaBest Hub] Key Validated! Access Granted."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            ShowNotification("Key validated successfully!", Color3.fromRGB(100, 255, 100), 3)
            SaveKey(key)
            return true
        else
            StatusLabel.Text = "[LumaBest Hub] Invalid Key."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            ShowNotification("Invalid key provided.", Color3.fromRGB(255, 100, 100), 3)
            return false
        end
    else
        StatusLabel.Text = "[LumaBest Hub] Validation Failed (Server Error)."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        ShowNotification("Failed to connect to " .. KeyServiceBaseURL .. ".", Color3.fromRGB(255, 100, 100), 3)
        return false
    end
end

-- --- BUTTON HANDLERS ---

-- Validate Button
local ValidateButton = Instance.new("TextButton")
ValidateButton.Size = UDim2.new(0.45, -10, 0, 40)
ValidateButton.Position = UDim2.new(0.05, 0, 0, 140)
ValidateButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
ValidateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ValidateButton.Text = "Validate Key"
ValidateButton.TextSize = 16
ValidateButton.Font = Enum.Font.GothamBold
ValidateButton.Parent = MainFrame

ValidateButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    local isValid = ValidateKey(key)
    if isValid then
        KeyValidated = true
        RunSafeScript()
    elseif FreeAccess then
        StatusLabel.Text = "[LumaBest Hub] No Valid Key. Free Access Granted."
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        ShowNotification("Free access granted.", Color3.fromRGB(100, 255, 100), 3)
        KeyValidated = true
        RunSafeScript()
    end
end)

-- Copy Link Button
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0.45, -10, 0, 40)
CopyButton.Position = UDim2.new(0.5, 10, 0, 140)
CopyButton.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "Copy Key Link"
CopyButton.TextSize = 16
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = MainFrame

CopyButton.MouseButton1Click:Connect(function()
    local keyLink = GetKey()
    -- Assuming 'setclipboard' is available in your execution environment
    setclipboard(keyLink)
    StatusLabel.Text = "[LumaBest Hub] Key Link Copied to Clipboard!"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    ShowNotification("Key link copied to clipboard!", Color3.fromRGB(100, 255, 100), 3)
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    if not KeyValidated then
        ScreenGui:Destroy()
    else
        ShowNotification("The UI can be closed automatically after validation.", Color3.fromRGB(255, 150, 50), 3)
    end
end)

-- --- INITIALIZATION & AUTO-VALIDATION ---

-- Load and Auto-Validate Saved Key
local savedKey = LoadKey()
if savedKey ~= "" then
    KeyInput.Text = savedKey
    StatusLabel.Text = "[LumaBest Hub] Loaded Saved Key. Validating..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    -- Use a new thread for validation to prevent UI freeze
    task.spawn(function()
        local isValid = ValidateKey(savedKey)
        if isValid then
            KeyValidated = true
            RunSafeScript()
        elseif FreeAccess then
            StatusLabel.Text = "[LumaBest Hub] Saved Key Invalid. Free Access Granted."
            KeyValidated = true
            RunSafeScript()
        else
            KeyInput.Text = ""
            SaveKey("")
        end
    end)
end

-- Initial Animation (Removed drag logic for simplicity, focusing on functionality)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -150)})
tween:Play()
