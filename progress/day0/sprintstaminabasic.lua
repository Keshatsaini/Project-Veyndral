local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Movement speeds
local walkSpeed = 16
local sprintSpeed = 32

-- Stamina settings
local maxStamina = 7 -- seconds
local stamina = maxStamina
local staminaDrainRate = 1 / maxStamina
local staminaRegenRate = 1 / maxStamina

-- UI elements
local staminaBar = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui"):WaitForChild("StaminaBG"):WaitForChild("StaminaFill")

local humanoid
local rootPart
local sprinting = false

-- Set humanoid and root
local function setHumanoid()
	if player.Character then
		humanoid = player.Character:WaitForChild("Humanoid")
		rootPart = player.Character:WaitForChild("HumanoidRootPart")
	end
end

player.CharacterAdded:Connect(setHumanoid)
setHumanoid()

-- Shift pressed
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		if stamina > 0 and humanoid then
			sprinting = true
			humanoid.WalkSpeed = sprintSpeed
		end
	end
end)

-- Shift released
userInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		if humanoid then
			sprinting = false
			humanoid.WalkSpeed = walkSpeed
		end
	end
end)

-- Update loop
runService.RenderStepped:Connect(function(deltaTime)
	if humanoid and rootPart then
		local moving = rootPart.Velocity.Magnitude > 2
		local grounded = humanoid.FloorMaterial ~= Enum.Material.Air

		-- Drain stamina
		if sprinting and stamina > 0 and moving and grounded then
			stamina = stamina - staminaDrainRate * deltaTime * maxStamina
			if stamina <= 0 then
				stamina = 0
				sprinting = false
				humanoid.WalkSpeed = walkSpeed
			end
			-- Regen stamina (only when grounded)
		elseif stamina < maxStamina and grounded then
			stamina = stamina + staminaRegenRate * deltaTime * maxStamina
			if stamina > maxStamina then
				stamina = maxStamina
			end
		end

		-- Update stamina bar
		local staminaPercent = stamina / maxStamina
		staminaBar.Size = UDim2.new(staminaPercent, 0, 1, 0)
	end
end)
