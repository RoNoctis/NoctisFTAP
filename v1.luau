local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

local Window = Rayfield:CreateWindow({
	Name = "Noctis FTAP #1",
	LoadingTitle = "Noctis FTAP",
	LoadingSubtitle = "by Noctis",
	ConfigurationSaving = {
		Enabled = false,
	},
	KeySystem = false,
})

local Tab = Window:CreateTab("Main", 4483362458)

Tab:CreateToggle({
	Name = "Enable Super Throw",
	CurrentValue = settings.enabled,
	Flag = "throw_toggle",
	Callback = function(val)
		settings.enabled = val
		Rayfield:Notify({
			Title = "Noctis FTAP",
			Content = val and "Throw Boost Active" or "Disabled",
			Duration = 1.5,
			Image = 4483362458,
		})
	end,
})

Tab:CreateSlider({
	Name = "Throw Strength",
	Range = {50, 1500},
	Increment = 25,
	Suffix = " power",
	CurrentValue = settings.strength,
	Flag = "throw_power",
	Callback = function(val)
		settings.strength = val
	end,
})

Tab:CreateButton({
	Name = "Max Strength (1500)",
	Callback = function()
		settings.strength = 1500
		Rayfield:Notify({
			Title = "Strength",
			Content = "Set to 1500",
			Duration = 1.5,
			Image = 4483362458,
		})
	end,
})
