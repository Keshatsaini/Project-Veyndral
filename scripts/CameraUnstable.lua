local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Lock camera to first person (this script is unstable kinda) (edit 3 18 august)
-- edit 1 19 august
-- edit 2 19 august
-- edit 3 19 august
-- edit 4 19 august
-- edit 1 20 august


player.CameraMode = Enum.CameraMode.LockFirstPerson

-- Camera sway/bob parameterss
local idleSwayAmplitude = 0.15
local idleSwayFrequency = 1.2
local walkBobAmplitude = 0.25
local walkBobFrequency = 8
local tiltAngle = math.rad(7)

local lastMoveDirection = Vector3.new()
local bobTime = 0

local function getMoveDirection()
    local moveDir = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDir = moveDir + Vector3.new(0, 0, -1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDir = moveDir + Vector3.new(0, 0, 1)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDir = moveDir + Vector3.new(-1, 0, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDir = moveDir + Vector3.new(1, 0, 0)
    end
    return moveDir
end

RunService.RenderStepped:Connect(function(dt)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local moveDir = getMoveDirection()
    local isMoving = moveDir.Magnitude > 0

    local baseCFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + humanoidRootPart.CFrame.LookVector)

    -- Idle breathing sway
    local swayOffset = Vector3.new(
        math.sin(tick() * idleSwayFrequency) * idleSwayAmplitude,
        math.cos(tick() * idleSwayFrequency) * idleSwayAmplitude,
        0
    )

    -- Walking bobbing and tiltt
    local bobOffset = Vector3.new()
    local tiltCFrame = CFrame.new()
    if isMoving then
        bobTime = bobTime + dt
        bobOffset = Vector3.new(
            0,
            math.abs(math.sin(bobTime * walkBobFrequency)) * walkBobAmplitude,
            0
        )
        -- Sideways tilt
        if moveDir.X ~= 0 then
            tiltCFrame = CFrame.Angles(0, 0, -tiltAngle * moveDir.X)
        end
    else
        bobTime = 0
        tiltCFrame = CFrame.new()
    end

    local finalCFrame = baseCFrame
        * CFrame.new(swayOffset + bobOffset)
        * tiltCFrame

    camera.CFrame = finalCFrame
end)

