--// SCRIPT KENMA - LOADSTRING MOBILE

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Estados
local states = {
	InfJump = false,
	ShiftLock = false,
	Aimbot = false,
	ESP = false,
	Fly = false
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KenmaGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão abrir
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,120,0,40)
openBtn.Position = UDim2.new(0,10,0.5,-20)
openBtn.Text = "Kenma"
openBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0

-- Painel
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,260,0,320)
panel.Position = UDim2.new(0.5,-130,0.5,-160)
panel.BackgroundColor3 = Color3.fromRGB(120,0,0)
panel.Visible = false
panel.BorderSizePixel = 0

-- Título
local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,40)
title.Text = "SCRIPT KENMA"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

-- Criar botões
local function createButton(text, y)
	local b = Instance.new("TextButton", panel)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text.." : OFF"
	b.BackgroundColor3 = Color3.fromRGB(170,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.BorderSizePixel = 0
	return b
end

local infJumpBtn = createButton("Infinite Jump", 50)
local shiftBtn   = createButton("Shift Lock", 90)
local aimbotBtn  = createButton("Aimbot", 130)
local espBtn     = createButton("ESP", 170)
local flyBtn     = createButton("Fly GUI", 210)

-- Speed
local speedBox = Instance.new("TextBox", panel)
speedBox.Size = UDim2.new(1,-20,0,30)
speedBox.Position = UDim2.new(0,10,0,255)
speedBox.PlaceholderText = "Speed (16 - 200)"
speedBox.TextScaled = true

-- Abrir painel
openBtn.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if states.InfJump then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

infJumpBtn.MouseButton1Click:Connect(function()
	states.InfJump = not states.InfJump
	infJumpBtn.Text = "Infinite Jump : "..(states.InfJump and "ON" or "OFF")
end)

-- Shift Lock
shiftBtn.MouseButton1Click:Connect(function()
	states.ShiftLock = not states.ShiftLock
	UIS.MouseBehavior = states.ShiftLock and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
	shiftBtn.Text = "Shift Lock : "..(states.ShiftLock and "ON" or "OFF")
end)

-- Speed
speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v then
		humanoid.WalkSpeed = math.clamp(v,16,200)
	end
end)

-- Fly
local bv, bg
flyBtn.MouseButton1Click:Connect(function()
	states.Fly = not states.Fly
	flyBtn.Text = "Fly GUI : "..(states.Fly and "ON" or "OFF")

	if states.Fly then
		bv = Instance.new("BodyVelocity", character.HumanoidRootPart)
		bg = Instance.new("BodyGyro", character.HumanoidRootPart)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

		RunService.RenderStepped:Connect(function()
			if states.Fly then
				bv.Velocity = camera.CFrame.LookVector * 60
				bg.CFrame = camera.CFrame
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- ESP simples
local function espPlayer(plr)
	if plr ~= player and plr.Character then
		local box = Instance.new("BoxHandleAdornment")
		box.Adornee = plr.Character
		box.Size = plr.Character:GetExtentsSize()
		box.AlwaysOnTop = true
		box.Color3 = Color3.new(1,0,0)
		box.ZIndex = 10
		box.Parent = gui
	end
end

espBtn.MouseButton1Click:Connect(function()
	states.ESP = not states.ESP
	espBtn.Text = "ESP : "..(states.ESP and "ON" or "OFF")
	gui:ClearAllChildren()
	gui.Parent = player.PlayerGui

	if states.ESP then
		for _,p in pairs(Players:GetPlayers()) do
			espPlayer(p)
		end
	end
end)

-- Aimbot simples
RunService.RenderStepped:Connect(function()
	if states.Aimbot then
		local target, dist = nil, math.huge
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
				local d = (p.Character.Head.Position - camera.CFrame.Position).Magnitude
				if d < dist then
					dist = d
					target = p
				end
			end
		end
		if target then
			camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

aimbotBtn.MouseButton1Click:Connect(function()
	states.Aimbot = not states.Aimbot
	aimbotBtn.Text = "Aimbot : "..(states.Aimbot and "ON" or "OFF")
end)
