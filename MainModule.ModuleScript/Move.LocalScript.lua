local PlayerScripts = game:GetService( "Players" ).LocalPlayer:WaitForChild( "PlayerScripts" )

if script.Name == "Move" then
	
	local Folder = PlayerScripts:FindFirstChild( script.Parent.Name:sub( 1, -5 ) )
	
	if Folder then
		
		for _, Obj in ipairs( script.Parent:GetChildren( ) ) do
			
			if Obj ~= script and not Folder:FindFirstChild( Obj.Name ) then
				
				local Clone = script.Parent:Clone( )
				
				if Clone:IsA( "Script" ) or Clone:IsA( "LocalScript" ) then
					
					Clone.Disabled = false
					
				end
				
				Clone.Parent = Folder
				
			end
			
		end
		
	else
		
		local Clone = script.Parent:Clone( )
		
		Clone.Name = Clone.Name:sub( 1, -5 )
		
		for _, Obj in ipairs( Clone:GetChildren( ) ) do
			
			if Obj:IsA( "Script" ) or Obj:IsA( "LocalScript" ) then
				
				Obj.Disabled = false
				
			end
			
		end
		
		Clone.Parent = game:GetService( "Players" ).LocalPlayer.PlayerScripts
		
	end
	
elseif not PlayerScripts:FindFirstChild( script.Parent.Name ) then
	
	local Clone = script.Parent:Clone( )
	
	Clone.Parent = PlayerScripts
	
	if Clone:IsA( "Script" ) or Clone:IsA( "LocalScript" ) then
		
		Clone.Disabled = false
		
	end
	
end

wait( )

script.Parent:Destroy( )