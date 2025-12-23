-- SCRIPT KENMA - LOADSTRING MOBILE (FIXED)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local states = {
	InfJump = false,
	ShiftLock = false,
	Fly = false
}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KenmaGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão abrir
local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,120,0,40)
open.Position = UDim2.new(0,10,0.5,-20)
open.Text = "Kenma"
open.BackgroundColor3 = Color3.fromRGB(150,0,0)
open.TextColor3 = Color3.new(1,1,1)
open.TextScaled = true

-- Painel
local panel = Instance.new("Frame", gui)
panel.Size = UDim2.new(0,260,0,260)
panel.Position = UDim2.new(0.5,-130,0.5,-130)
panel.BackgroundColor3 = Color3.fromRGB(120,0,0)
panel.Visible = false

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1,0,0,40)
title.Text = "SCRIPT KENMA"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local function btn(text,y)
	local b = Instance.new("TextButton", panel)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text.." : OFF"
	b.BackgroundColor3 = Color3.fromRGB(170,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	return b
end

local infJump = btn("Infinite Jump",50)
local shift = btn("Shift Lock",90)
local fly = btn("Fly",130)

open.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if states.InfJump then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

infJump.MouseButton1Click:Connect(function()
	states.InfJump = not states.InfJump
	infJump.Text = "Infinite Jump : "..(states.InfJump and "ON" or "OFF")
end)

-- Shift Lock
shift.MouseButton1Click:Connect(function()
	states.ShiftLock = not states.ShiftLock
	UIS.MouseBehavior = states.ShiftLock and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
	shift.Text = "Shift Lock : "..(states.ShiftLock and "ON" or "OFF")
end)

-- Fly
local bv, bg
fly.MouseButton1Click:Connect(function()
	states.Fly = not states.Fly
	fly.Text = "Fly : "..(states.Fly and "ON" or "OFF")

	if states.Fly then
		bv = Instance.new("BodyVelocity", character.HumanoidRootPart)
		bg = Instance.new("BodyGyro", character.HumanoidRootPart)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

		RunService.RenderStepped:Connect(function()
			if states.Fly then
				bv.Velocity = camera.CFrame.LookVector * 50
				bg.CFrame = camera.CFrame
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)
