local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/UI-Libraries/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
	Name = "Mount Daun Utility",
	FullScreen = false,
	ResetOnClose = true
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local function getLastCheckpointPosition()
    
    local checkpointPart = workspace:FindFirstChild("LastCheckpoint") -- Contoh sederhana
    if checkpointPart and checkpointPart:IsA("BasePart") then
        return checkpointPart.Position
    end

    local lastCheckpoint = nil
    local highestCheckpointNum = -math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and string.find(obj.Name, "Checkpoint") then
            local num = tonumber(string.match(obj.Name, "%d+"))
            if num and num > highestCheckpointNum then
                highestCheckpointNum = num
                lastCheckpoint = obj
            end
        end
    end
    if lastCheckpoint then
        return lastCheckpoint.Position
    end

    
    local checkpointNumberValue = nil
    if LocalPlayer:FindFirstChild("leaderstats") then
        checkpointNumberValue = LocalPlayer.leaderstats:FindFirstChild("CheckpointNumber")
    elseif LocalPlayer:FindFirstChild("Data") then
        checkpointNumberValue = LocalPlayer.Data:FindFirstChild("CheckpointNumber")
    end
    if checkpointNumberValue and checkpointNumberValue:IsA("IntValue") then
        local num = checkpointNumberValue.Value
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and string.find(obj.Name, "Checkpoint") then
                local objNum = tonumber(string.match(obj.Name, "%d+"))
                if objNum and objNum == num then
                    return obj.Position
                end
            end
        end
    end

    
    warn("Tidak dapat menemukan posisi checkpoint terakhir. Menggunakan posisi dummy.")
    return Vector3.new(0, 100, 0) -- Ganti dengan posisi yang lebih masuk akal jika diperlukan
end

local function getSummitPosition()
    -- Contoh posisi puncak dummy. Ganti dengan koordinat puncak Mt. Daun sebenarnya.
    return Vector3.new(-1000, 5000, 1000) -- Ganti ini dengan koordinat puncak. Anda bisa menemukannya dengan terbang di game.
end

local MainTab = Window:CreateTab("Teleport Utilities")

local TeleportSection = MainTab:CreateSection("Teleport Options")

TeleportSection:CreateButton({
	Name = "Teleport ke Checkpoint Terakhir",
	Callback = function()
		local targetPosition = getLastCheckpointPosition()
		if targetPosition then
			HumanoidRootPart.CFrame = CFrame.new(targetPosition)
			Rayfield:Notify({
				Title = "Teleport Berhasil",
				Content = "Anda telah diteleport ke checkpoint terakhir.",
				Duration = 5, -- Durasi notifikasi dalam detik
				Image = 4483362458, -- ID asset gambar untuk ikon (opsional)
			})
		else
			Rayfield:Notify({
				Title = "Teleport Gagal",
				Content = "Tidak dapat menemukan posisi checkpoint terakhir.",
				Duration = 5,
				Image = 4483362458,
			})
		end
	end,
})

TeleportSection:CreateButton({
	Name = "Teleport ke Puncak (Summit)",
	Callback = function()
		local targetPosition = getSummitPosition()
		if targetPosition then
			HumanoidRootPart.CFrame = CFrame.new(targetPosition)
			Rayfield:Notify({
				Title = "Teleport Berhasil",
				Content = "Anda telah diteleport ke puncak gunung!",
				Duration = 5,
				Image = 4483362458,
			})
		else
			Rayfield:Notify({
				Title = "Teleport Gagal",				
				Content = "Tidak dapat menemukan posisi puncak.",
				Duration = 5,
				Image = 4483362458,
			})
		end
	end,
})

print("Mount Daun Utility UI Loaded!")
