local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local detectionRadius = 10
local checkInterval = 0.25

local character
local rootPart
local emitter
local elapsed = 0

local function setupCharacter(newCharacter)
	character = newCharacter
	rootPart = newCharacter:WaitForChild("HumanoidRootPart")

	local attachment = Instance.new("Attachment")
	attachment.Name = "ProximitySparkleAttachment"
	attachment.Parent = rootPart

	emitter = Instance.new("ParticleEmitter")
	emitter.Name = "ProximitySparkles"
	emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Color = ColorSequence.new(
		Color3.fromRGB(255, 120, 190),
		Color3.fromRGB(255, 235, 120)
	)
	emitter.LightEmission = 0.7
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.18),
		NumberSequenceKeypoint.new(1, 0)
	})
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1)
	})
	emitter.Lifetime = NumberRange.new(0.45, 0.8)
	emitter.Speed = NumberRange.new(1, 2)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Rate = 0
	emitter.Parent = attachment
end

local function isAnotherPlayerNearby()
	if not rootPart or not rootPart.Parent then
		return false
	end

	for _, player in Players:GetPlayers() do
		if player ~= localPlayer then
			local otherCharacter = player.Character
			local otherRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
			local humanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
			if otherRoot and humanoid and humanoid.Health > 0 then
				if (otherRoot.Position - rootPart.Position).Magnitude <= detectionRadius then
					return true
				end
			end
		end
	end

	return false
end

localPlayer.CharacterAdded:Connect(setupCharacter)
if localPlayer.Character then
	setupCharacter(localPlayer.Character)
end

RunService.Heartbeat:Connect(function(deltaTime)
	elapsed += deltaTime
	if elapsed < checkInterval then
		return
	end
	elapsed = 0

	if emitter and isAnotherPlayerNearby() then
		emitter:Emit(2)
	end
end)
