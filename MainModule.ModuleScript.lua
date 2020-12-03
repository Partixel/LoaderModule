local function HandleTemp(ModName, Config, PermPar, Allow_Force_Singular, Overrides, Objs, TempName)
	for _, Plr in ipairs(game:GetService("Players"):GetPlayers()) do
		local TempPar = TempName == "Character" and Plr.Character or Plr:FindFirstChild(TempName)
		if TempPar then
			if PermPar.Name == "StarterPlayerScripts" then
				local TempFolder = Instance.new("Folder")
				TempFolder.Name = ModName .. "TEMP"
				for _, Obj in ipairs(Objs) do
					if (not Config or not Config[Obj.Name]) and (not Obj:IsA("BaseScript") or not Obj.Disabled) then
						local Clone = Obj:Clone()
						if Clone:IsA("Script") or Clone:IsA("LocalScript") then
							Clone.Disabled = true
						end
						Clone.Parent = TempFolder
					end
				end
				
				if #TempFolder:GetChildren() ~= 0 then
					local Move = script.Move:Clone()
					if Allow_Force_Singular and #TempFolder:GetChildren() == 1 then
						TempFolder = TempFolder:GetChildren()[1]
						Move.Name = "Single"
					end
					Move.Archivable = false
					Move.Parent = TempFolder
					
					TempFolder.Parent = TempPar
				end
			elseif TempName ~= "PlayerGui" or Plr.Character then
				if Allow_Force_Singular == 2 or (Allow_Force_Singular and #Objs == 1) then
					for _, Obj in ipairs(Objs) do
						if Overrides and Overrides[Obj.Name] then
							local Old = TempPar:FindFirstChild(Obj.Name)
							while Old do
								Old:Destroy()
								Old = TempPar:FindFirstChild(Obj.Name)
							end
							
							Obj:Clone().Parent = TempPar
						elseif not TempPar:FindFirstChild(Obj.Name) then
							Obj:Clone().Parent = TempPar
						end
					end
				else
					local TempFolder = TempPar:FindFirstChild(ModName) or (TempName == "PlayerGui" and Instance.new("ScreenGui") or Instance.new("Folder"))
					
					if TempName == "PlayerGui" then
						TempFolder.ResetOnSpawn = false
					end
					TempFolder.Name = ModName
					
					for _, Obj in ipairs(Objs) do
						if Overrides and Overrides[Obj.Name] then
							local Old = TempFolder:FindFirstChild(Obj.Name)
							while Old do
								Old:Destroy()
								Old = TempFolder:FindFirstChild(Obj.Name)
							end
							
							Obj:Clone().Parent = TempFolder
						elseif not TempFolder:FindFirstChild(Obj.Name) then
							Obj:Clone().Parent = TempFolder
						end
					end
					
					TempFolder.Parent = TempPar
				end
			end
		end
	end
end

return function(ModName, Config)
	return function(Folder, PermPar, Allow_Force_Singular, Overrides)
		if not PermPar then
			if Folder.Name == "StarterPlayerScripts" or Folder.Name == "StarterCharacterScripts" then
				PermPar = game:GetService("StarterPlayer"):WaitForChild(Folder.Name)
			else
				PermPar = game:GetService(Folder.Name)
			end
		end
		
		if Allow_Force_Singular == nil and PermPar.Name ~= "ReplicatedStorage" then
			Allow_Force_Singular = 1
		end
		
		local Objs = Folder:GetChildren()
		for i, Obj in ipairs(Objs) do
			if Config and Config[Obj.Name] or (Obj:IsA("BaseScript") and Obj.Disabled) then
				table.remove(Objs, i)
			end
		end
		
		if Allow_Force_Singular == 2 or (Allow_Force_Singular and #Objs == 1) then
			for _, Obj in ipairs(Objs) do
				if Overrides and Overrides[Obj.Name] then
					local Old = PermPar:FindFirstChild(Obj.Name)
					while Old do
						Old:Destroy()
						Old = PermPar:FindFirstChild(Obj.Name)
					end
					
					Obj.Parent = PermPar
				elseif not PermPar:FindFirstChild(Obj.Name) then
					Obj.Parent = PermPar
				end
			end
		else
			local PermFolder = PermPar:FindFirstChild(ModName) or (PermPar.Name == "StarterGui" and Instance.new("ScreenGui") or Instance.new("Folder"))
			if PermPar.Name == "StarterGui" then
				PermFolder.ResetOnSpawn = false
			end
			PermFolder.Name = ModName
			
			for _, Obj in ipairs(Objs) do
				if Overrides and Overrides[Obj.Name] then
					local Old = PermFolder:FindFirstChild(Obj.Name)
					while Old do
						Old:Destroy()
						Old = PermFolder:FindFirstChild(Obj.Name)
					end
					
					Obj.Parent = PermFolder
				elseif not PermFolder:FindFirstChild(Obj.Name) then
					Obj.Parent = PermFolder
				end
			end
			
			PermFolder.Parent = PermPar
		end
		
		if PermPar.Name == "StarterPlayerScripts" then
			if game:GetService("RunService"):IsRunMode() and #game:GetService("Players"):GetPlayers() == 0 then
				game:GetService("Players").PlayerAdded:Connect(function()
					HandleTemp(ModName, Config, PermPar, Allow_Force_Singular, Overrides, Objs, "PlayerGui")
				end)
			else
				HandleTemp(ModName, Config, PermPar, Allow_Force_Singular, Overrides, Objs, "PlayerGui")
			end
		elseif PermPar.Name == "StarterGui" then
			HandleTemp(ModName, Config, PermPar, Allow_Force_Singular, Overrides, Objs, "PlayerGui")
		elseif PermPar.Name == "StarterPack" then
			HandleTemp(ModName, Config, PermPar, Allow_Force_Singular, Overrides, Objs, "Backpack")
		elseif PermPar.Name == "StarterCharacterScripts" then
			HandleTemp(ModName, Config, PermPar, Allow_Force_Singular, Overrides, Objs, "Character")
		end
		
		Folder:Destroy()
	end
end