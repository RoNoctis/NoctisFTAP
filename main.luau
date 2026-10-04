local Rayfield = loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/72msreal-pixel/MySoure@main/Rayfield-Plus.luau"))()

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
	name = "Noctis FTAP #1",
	subtitle = "Fling / Launch Utility",
	icon = 0,
	size = UDim2.fromOffset(500, 340),
})

local Tab = Window:CreateTab({
	name = "Main",
	icon = 0,
})

Tab:CreateToggle({
	name = "Enable Super Throw",
	flag = "noctis_enabled",
	value = settings.enabled,
	callback = function(val)
		settings.enabled = val
		Window:Toast({
			title = "Noctis FTAP",
			subtitle = val and "Throw Boost Active" or "Disabled",
			position = "Top",
			duration = 1.5,
		})
	end,
})

Tab:CreateSlider({
	name = "Throw Strength",
	flag = "noctis_strength",
	range = {50, 1500},
	increment = 25,
	value = settings.strength,
	suffix = " power",
	callback = function(val)
		settings.strength = val
	end,
})

Tab:CreateButton({
	name = "Max Strength (1500)",
	description = "Sets impulse power to absolute maximum",
	callback = function()
		settings.strength = 1500
		Window:Toast({
			title = "Strength",
			subtitle = "Set to 1500",
			position = "Top",
			duration = 1.5,
		})
	end,
})
