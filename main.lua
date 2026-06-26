local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CẤU HÌNH CÁC BIẾN TRẠNG THÁI (CHUNG)
local AimbotActive = false
local FOVActive = false
local FlyActive = false
local ESPActive = false

local FOVRadius = 120 
local CustomSpeed = 16 
local FlySpeed = 50

-- BIẾN TRẠNG THÁI TÍNH NĂNG MM2
local MM2ESPActive = false
local AutoPickGun = false

-- 1. VÒNG TRÒN FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = FOVRadius
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 1
FOVCircle.Filled = false

-- Xóa menu cũ nếu có trùng lặp
if PlayerGui:FindFirstChild("TrungNghiEvadeStyleMenu") then
    PlayerGui.TrungNghiEvadeStyleMenu:Destroy()
end

-- 2. TẠO GIAO DIỆN PHÂN TAB CHUYÊN NGHIỆP (EVADE STYLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = "TrungNghiEvadeStyleMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 240) 
MainFrame.Position = UDim2.new(0.5, -210, 0.4, -120) 
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 0, 0)
MainStroke.Thickness = 1.2

-- [SIDEBAR] CỘT BÊN TRÁI
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 130, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(13, 13, 13) 
SideBar.BorderSizePixel = 0
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

local LogoLabel = Instance.new("TextLabel", SideBar)
LogoLabel.Size = UDim2.new(1, 0, 0, 45)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "☠️ trungnghi ☠️"
LogoLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
LogoLabel.Font = Enum.Font.FredokaOne
LogoLabel.TextSize = 16

-- DANH SÁCH LỰA CHỌN TAB
local SideBarList = Instance.new("UIListLayout", SideBar)
SideBarList.SortOrder = Enum.SortOrder.LayoutOrder
SideBarList.Padding = UDim.new(0, 4)
SideBarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local TabSpacer = Instance.new("Frame", SideBar)
TabSpacer.Size = UDim2.new(1, 0, 0, 40)
TabSpacer.BackgroundTransparency = 1
TabSpacer.LayoutOrder = 0

local TabBtnShooter = Instance.new("TextButton", SideBar)
TabBtnShooter.Size = UDim2.new(1, -16, 0, 32)
TabBtnShooter.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabBtnShooter.Text = "🔫 Shooter Main"
TabBtnShooter.TextColor3 = Color3.fromRGB(255, 255, 255)
TabBtnShooter.Font = Enum.Font.SourceSansBold
TabBtnShooter.TextSize = 13
TabBtnShooter.LayoutOrder = 1
Instance.new("UICorner", TabBtnShooter).CornerRadius = UDim.new(0, 6)

local TabBtnMM2 = Instance.new("TextButton", SideBar)
TabBtnMM2.Size = UDim2.new(1, -16, 0, 32)
TabBtnMM2.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabBtnMM2.Text = "🕵️ MM2 Main"
TabBtnMM2.TextColor3 = Color3.fromRGB(180, 180, 180)
TabBtnMM2.Font = Enum.Font.SourceSansBold
TabBtnMM2.TextSize = 13
TabBtnMM2.LayoutOrder = 2
Instance.new("UICorner", TabBtnMM2).CornerRadius = UDim.new(0, 6)

-- [CANVASES Nội Dung Phân Tách]
local ShooterCanvas = Instance.new("ScrollingFrame", MainFrame)
ShooterCanvas.Size = UDim2.new(1, -145, 1, -20)
ShooterCanvas.Position = UDim2.new(0, 140, 0, 10)
ShooterCanvas.BackgroundTransparency = 1
ShooterCanvas.BorderSizePixel = 0
ShooterCanvas.CanvasSize = UDim2.new(0, 0, 1.4, 0) 
ShooterCanvas.ScrollBarThickness = 2
local UIList1 = Instance.new("UIListLayout", ShooterCanvas)
UIList1.SortOrder = Enum.SortOrder.LayoutOrder
UIList1.Padding = UDim.new(0, 8)

local MM2Canvas = Instance.new("ScrollingFrame", MainFrame)
MM2Canvas.Size = UDim2.new(1, -145, 1, -20)
MM2Canvas.Position = UDim2.new(0, 140, 0, 10)
MM2Canvas.BackgroundTransparency = 1
MM2Canvas.BorderSizePixel = 0
MM2Canvas.CanvasSize = UDim2.new(0, 0, 1.4, 0) 
MM2Canvas.ScrollBarThickness = 2
MM2Canvas.Visible = false
local UIList2 = Instance.new("UIListLayout", MM2Canvas)
UIList2.SortOrder = Enum.SortOrder.LayoutOrder
UIList2.Padding = UDim.new(0, 8)

-- Sự kiện Đổi Tab
TabBtnShooter.MouseButton1Click:Connect(function()
    ShooterCanvas.Visible = true; MM2Canvas.Visible = false
    TabBtnShooter.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TabBtnShooter.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtnMM2.BackgroundColor3 = Color3.fromRGB(22, 22, 22); TabBtnMM2.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

TabBtnMM2.MouseButton1Click:Connect(function()
    ShooterCanvas.Visible = false; MM2Canvas.Visible = true
    TabBtnMM2.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TabBtnMM2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtnShooter.BackgroundColor3 = Color3.fromRGB(22, 22, 22); TabBtnShooter.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- Hàm tạo Nút Bật/Tắt (Toggle)
local function CreateEvadeToggle(parentCanvas, text, callback)
    local ToggleFrame = Instance.new("Frame", parentCanvas)
    ToggleFrame.Size = UDim2.new(1, -10, 0, 30)
    ToggleFrame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton", ToggleFrame)
    Switch.Size = UDim2.new(0, 40, 0, 18)
    Switch.Position = UDim2.new(1, -40, 0.5, -9)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Switch.Text = ""
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Indicator = Instance.new("Frame", Switch)
    Indicator.Size = UDim2.new(0, 12, 0, 12)
    Indicator.Position = UDim2.new(0, 3, 0.5, -6)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local Active = false
    Switch.MouseButton1Click:Connect(function()
        Active = not Active
        callback(Active)
        Switch.BackgroundColor3 = Active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        Indicator.Position = Active and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    end)
end

-- Hàm tạo Thanh Trượt Kéo (Slider)
local function CreateEvadeSlider(parentCanvas, titleText, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parentCanvas)
    SliderFrame.Size = UDim2.new(1, -10, 0, 40)
    SliderFrame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.Text = titleText .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local SliderBackground = Instance.new("TextButton", SliderFrame) 
    SliderBackground.Size = UDim2.new(1, 0, 0, 6)
    SliderBackground.Position = UDim2.new(0, 0, 0, 20)
    SliderBackground.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderBackground.Text = ""
    Instance.new("UICorner", SliderBackground).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame", SliderBackground)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local SliderButton = Instance.new("Frame", SliderBackground)
    SliderButton.Size = UDim2.new(0, 10, 0, 10)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)

    local IsDragging = false
    SliderBackground.MouseButton1Down:Connect(function() IsDragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then IsDragging = false end
    end)

    RunService.Heartbeat:Connect(function()
        if IsDragging then
            local MousePos = UserInputService:GetMouseLocation()
            local RelativeX = MousePos.X - SliderBackground.AbsolutePosition.X
            local Percentage = math.clamp(RelativeX / SliderBackground.AbsoluteSize.X, 0, 1)
            SliderFill.Size = UDim2.new(Percentage, 0, 1, 0)
            SliderButton.Position = UDim2.new(Percentage, -5, 0.5, -5)
            local Value = math.floor(min + (max - min) * Percentage)
            Label.Text = titleText .. ": " .. Value
            callback(Value)
        end
    end)
end

-- KHỞI TẠO TÍNH NĂNG TAB 1: SHOOTER MAIN
CreateEvadeToggle(ShooterCanvas, "💀 Kích Hoạt Aimbot (Khóa Mục Tiêu)", function(state) AimbotActive = state end)
CreateEvadeToggle(ShooterCanvas, "👁️ Hiển Thị Vòng FOV", function(state) FOVActive = state; FOVCircle.Visible = state end)
CreateEvadeToggle(ShooterCanvas, "✨ ESP Chams (Nhìn Xuyên Tường)", function(state) ESPActive = state end)
CreateEvadeToggle(ShooterCanvas, "🚀 Kích Hoạt Fly Hack (Bay Cần Gạt)", function(state) FlyActive = state end)
CreateEvadeSlider(ShooterCanvas, "🔴 Bán Kính Vòng FOV", 10, 400, FOVRadius, function(v) FOVRadius = v; FOVCircle.Radius = v end)
CreateEvadeSlider(ShooterCanvas, "⚡ Tốc Độ Chạy (Speed)", 16, 250, CustomSpeed, function(v) CustomSpeed = v end)
CreateEvadeSlider(ShooterCanvas, "✈️ Tốc Độ Bay (Fly Speed)", 20, 200, FlySpeed, function(v) FlySpeed = v end)

-- KHỞI TẠO TÍNH NĂNG TAB 2: MM2 MAIN (MỚI THÊM)
CreateEvadeToggle(MM2Canvas, "👁️ Bật MM2 ESP (Hiện Rõ Vai Trò)", function(state) MM2ESPActive = state end)
CreateEvadeToggle(MM2Canvas, "🎯 Auto Pick Up Gun (Tự Nhặt Súng)", function(state) AutoPickGun = state end)

-- NÚT ĐÓNG / MỞ MENU
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -26, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

local OpenMenuBtn = Instance.new("TextButton", ScreenGui)
OpenMenuBtn.Size = UDim2.new(0, 45, 0, 45)
OpenMenuBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenMenuBtn.Text = "☠️"
OpenMenuBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
OpenMenuBtn.Font = Enum.Font.FredokaOne
OpenMenuBtn.TextSize = 22
OpenMenuBtn.Visible = false
OpenMenuBtn.Draggable = true
OpenMenuBtn.Active = true
Instance.new("UICorner", OpenMenuBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenMenuBtn).Color = Color3.fromRGB(255, 0, 0)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenMenuBtn.Visible = true end)
OpenMenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenMenuBtn.Visible = false end)

-- =========================================================
-- HỆ THỐNG XỬ LÝ CORE HACK CHẠY NGẦM
-- =========================================================
local BodyVelocityInstance = nil

local function GetClosestPlayer()
    local MaxDist = FOVActive and FOVRadius or math.huge
    local Target = nil
    local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health > 0 then
            local Point, OnScreen = Camera:WorldToScreenPoint(v.Character.Head.Position)
            if OnScreen then
                local Dist = (Vector2.new(Point.X, Point.Y) - Center).Magnitude
                if Dist < MaxDist then Target = v; MaxDist = Dist end
            end
        end
    end
    return Target
end

-- Hàm xác định vai trò của người chơi trong MM2
local function GetMM2Role(player)
    if not player then return "Innocent" end
    local backpack = player:FindFirstChild("Backpack")
    local char = player.Character
    
    -- Kiểm tra Dao (Sát thủ)
    if (backpack and backpack:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
        return "Murderer"
    -- Kiểm tra Súng (Cảnh sát)
    elseif (backpack and backpack:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

RunService.Heartbeat:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local Char = LocalPlayer.Character
    if not Char then return end
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    local HRP = Char:FindFirstChild("HumanoidRootPart")
    
    -- 1. Tốc độ chạy thông thường
    if Hum and not FlyActive then 
        Hum.WalkSpeed = CustomSpeed 
    end
    
    -- 2. Hệ thống Fly Hack
    if FlyActive and HRP and Hum then
        Hum.WalkSpeed = 0 
        if not BodyVelocityInstance or BodyVelocityInstance.Parent ~= HRP then
            if HRP:FindFirstChild("FlyBV") then HRP.FlyBV:Destroy() end
            BodyVelocityInstance = Instance.new("BodyVelocity")
            BodyVelocityInstance.Name = "FlyBV"
            BodyVelocityInstance.MaxForce = Vector3.new(1, 1, 1) * 900000 
            BodyVelocityInstance.Parent = HRP
        end
        local MoveDir = Hum.MoveDirection
        BodyVelocityInstance.Velocity = MoveDir.Magnitude > 0 and MoveDir * FlySpeed or Vector3.new(0, 0, 0)
    else
        if HRP and HRP:FindFirstChild("FlyBV") then HRP.FlyBV:Destroy() end
        BodyVelocityInstance = nil
    end
    
    -- 3. Aimbot khóa tâm
    if AimbotActive and Char:FindFirstChild("Head") then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.Head.Position)
        end
    end
    
    -- 4. ESP Chams (Bình thường & MM2 Phân loại màu)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local Highlight = p.Character:FindFirstChild("ESPHighlight")
            
            if ESPActive or MM2ESPActive then
                if not Highlight then
                    Highlight = Instance.new("Highlight")
                    Highlight.Name = "ESPHighlight"
                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Highlight.OutlineTransparency = 0
                    Highlight.FillTransparency = 0.5
                    Highlight.Parent = p.Character
                end
                
                -- Phân màu nâng cao nếu bật chế độ MM2 ESP
                if MM2ESPActive then
                    local role = GetMM2Role(p)
                    if role == "Murderer" then
                        Highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Màu Đỏ cho Sát thủ
                    elseif role == "Sheriff" then
                        Highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Màu Xanh Dương cho Cảnh sát
                    else
                        Highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Màu Xanh Lá cho Dân thường
                    end
                else
                    Highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Mặc định đỏ khi chạy map thường
                end
            else
                if Highlight then Highlight:Destroy() end
            end
        end
    end

    -- 5. TÍNH NĂNG TỰ ĐỘNG NHẶT SÚNG MM2 (AUTO PICK UP GUN)
    if AutoPickGun and HRP then
        -- Khẩu súng rơi ra khi Cảnh sát chết trong MM2 thường nằm trực tiếp ở Workspace dưới dạng Model hoặc Part tên "GunDrop"
        local DroppedGun = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
        if DroppedGun and DroppedGun:IsA("BasePart") then
            HRP.CFrame = DroppedGun.CFrame
        elseif DroppedGun and DroppedGun:IsA("Model") and DroppedGun.PrimaryPart then
            HRP.CFrame = DroppedGun:GetPrimaryPartCFrame()
        end
    end
end)
