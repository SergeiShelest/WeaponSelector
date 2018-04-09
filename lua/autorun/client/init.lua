local PANEL = {}

local lp = LocalPlayer()

local function OpenWS()

	local slot = {}

	slot[1] = {ret = {}, title = "Melee Weapon", ico = Material("weapons/1.png")}
	slot[2] = {ret = {}, title = "Pistols", ico = Material("weapons/2.png")}
	slot[3] = {ret = {}, title = "Assault Rifles/Submachine Guns", ico = Material("weapons/3.png")}
	slot[4] = {ret = {}, title = "Sniper Rifles/Shotguns", ico = Material("weapons/4.png")}
	slot[5] = {ret = {}, title = "Explosive", ico = Material("weapons/5.png")}
	slot[6] = {ret = {}, title = "Tools", ico = Material("weapons/6.png")}

	local Mat = nil

	for k, v in pairs( lp:GetWeapons() ) do
			
		Mat = Material("vgui/hud/"..v:GetClass())

		if Mat:IsError() then
			Mat = Material( "vgui/"..v:GetClass() )
		end


		if Mat:IsError() then
			Mat = Material( "vgui/"..v:GetClass()..".png" )
		end

		if Mat:IsError() then
			Mat = Material( "weapons/swep" )
		end

		table.insert( slot[v:GetSlot() +1].ret, {ret = v, title = v:GetPrintName(), ico = Mat} )

	end

	PANEL.Fr = vgui.Create( "DFrame" )
	PANEL.Fr:SetPos( 0, 0 )
	PANEL.Fr:SetSize( ScrW(), ScrH() )
	PANEL.Fr:SetTitle( "" )
	PANEL.Fr:SetDraggable( true )
	PANEL.Fr:SetSizable( true )
	PANEL.Fr:MakePopup()
	PANEL.Fr.Paint = function(self, w, h) end

	PANEL.Tor = vgui.Create( "DTor", PANEL.Fr )
	PANEL.Tor:SetArray( slot )
	PANEL.Tor:SetDepth( 90 )
	PANEL.Tor:SetPos( 0, 0 )
	PANEL.Tor:Dock( FILL )

	local delay = 0
	local Return = nil

	local ReturnCh = nil

	function PANEL.Tor:Think()

		Return = PANEL.Tor:GetReturn()

		if Return ~= ReturnCh then
			
			sound.Play( "items/flashlight1.wav", lp:GetPos(), 75, 110, 1 )
		
		end

		if input.IsMouseDown( MOUSE_LEFT ) and CurTime() > delay then

			delay = CurTime() + 0.3

			if TypeID( Return ) == TYPE_TABLE and table.Count( Return ) > 0  then
				
				sound.Play( "items/ammo_pickup.wav", lp:GetPos(), 75, 100, 1 )
				PANEL.Tor:SetArray( Return )

			end

			if TypeID( Return ) ~= TYPE_TABLE then
				
				sound.Play( "items/gift_pickup.wav", lp:GetPos(), 75, 100, 1 )
				input.SelectWeapon( Return )
				PANEL.Fr:Remove()

			end

		end

		if input.IsMouseDown( MOUSE_RIGHT ) and CurTime() > delay  then

			delay = CurTime() + 0.3

			if TypeID( Return ) == TYPE_TABLE then
			
				PANEL.Fr:Remove()	
			
			else
			
				PANEL.Tor:SetArray( slot )
			
			end
		end

		ReturnCh = PANEL.Tor:GetReturn()

	end
end

hook.Add( "Think", "OpenWS", function()
	if input.IsMouseDown( MOUSE_MIDDLE ) and not IsValid( PANEL.Fr ) then

		OpenWS()

	end
end )