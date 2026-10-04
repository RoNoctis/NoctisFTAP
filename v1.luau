local BreezeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kaisorius/BreezeUI/refs/heads/main/BreezeUI.lua"))()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local settings = {
	enabled = true,
	strength = 250,
}

local function handleGrab(model)
	if not settings.enabled then return end
	if model.Name ~= "GrabParts" then return end

	local grabPart = model:WaitForChild("GrabPart", 5)
	if not grabPart then return end

	local weld = grabPart:WaitForChild("WeldConstraint", 5)
	if not weld or not weld.Part1 then return end

	local targetPart = weld.Part1
	local velocityObj = Instance.new("BodyVelocity")
	velocityObj.MaxForce = Vector3.zero
	velocityObj.Velocity = Vector3.zero
	velocityObj.Parent = targetPart

	local inputObj = nil
	local c1, c2, c3

	task.spawn(function()
		local playerGui = player:FindFirstChildOfClass("PlayerGui")
		while not inputObj and model.Parent and settings.enabled do
			if playerGui then
				local contextGui = playerGui:FindFirstChild("ContextActionGui")
				if contextGui then
					for _, descendant in ipairs(contextGui:GetDescendants()) do
						if descendant:IsA("ImageLabel") and descendant.Image == "http://www.roblox.com/asset/?id=9603678090" then
							inputObj = descendant.Parent
							break
						end
					end
				end
			end
			RunService.Heartbeat:Wait()
		end

		if inputObj and model.Parent and settings.enabled then
			local function launch()
				if not settings.enabled or not velocityObj or not velocityObj.Parent then return end
				velocityObj.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				velocityObj.Velocity = camera.CFrame.LookVector * settings.strength
			end

			c1 = inputObj.MouseButton1Down:Connect(launch)
			c2 = inputObj.MouseButton1Up:Connect(launch)
		end
	end)

	c3 = model:GetPropertyChangedSignal("Parent"):Connect(function()
		if not model.Parent then
			if c3 then c3:Disconnect() end
			if c1 then c1:Disconnect() end
			if c2 then c2:Disconnect() end
			if velocityObj then
				Debris:AddItem(velocityObj, 0.5)
			end
		end
	end)
end

Workspace.ChildAdded:Connect(handleGrab)

local Window = BreezeUI:CreateWindow({
	Name = "Noctis FTAP #1",
	Description = "Fling / Launch Utility"
})

local Tab = Window:CreateTab("Main")

Tab:Toggle({
	Name = "Enable Super Throw",
	Description = "Toggle launch boost",
	Callback = function(val)
		settings.enabled = val
	end
})

Tab:Button({
	Name = "Strength: Normal (250)",
	Description = "Set throw strength to 250",
	Callback = function()
		settings.strength = 250
	end
})

Tab:Button({
	Name = "Strength: High (750)",
	Description = "Set throw strength to 750",
	Callback = function()
		settings.strength = 750
	end
})

Tab:Button({
	Name = "Strength: Max (1500)",
	Description = "Set throw strength to 1500",
	Callback = function()
		settings.strength = 1500
	end
})
