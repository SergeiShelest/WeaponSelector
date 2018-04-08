local PANEL = {}

local function OpenWS()

	local slot = {}

	slot[1] = {ret = {}, title = "Melee Weapon", ico = Material("weapons/1.png")}
	slot[2] = {ret = {}, title = "Pistols", ico = Material("weapons/2.png")}
	slot[3] = {ret = {}, title = "Assault Rifles/Submachine Guns", ico = Material("weapons/3.png")}
	slot[4] = {ret = {}, title = "Sniper Rifles/Shotguns", ico = Material("weapons/4.png")}
	slot[5] = {ret = {}, title = "Explosive", ico = Material("weapons/5.png")}
	slot[6] = {ret = {}, title = "Tools", ico = Material("weapons/6.png")}

	local Mat = nil

	for k, v in pairs( LocalPlayer():GetWeapons() ) do
			
		Mat = Material("vgui/hud/"..v:GetClass())

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

	function PANEL.Tor:Think()
		if input.IsMouseDown( MOUSE_LEFT ) and CurTime() > delay then

			delay = CurTime() + 0.3
			Return = PANEL.Tor:GetReturn()

			if TypeID( Return ) == TYPE_TABLE then
					
				PANEL.Tor:SetArray( Return )

			else
				
				input.SelectWeapon( Return )
				PANEL.Fr:Remove()

			end
		end
	end
end

hook.Add( "Think", "OpenWS", function()
	if input.IsMouseDown( MOUSE_MIDDLE ) and not IsValid( PANEL.Fr ) then

		OpenWS()

	end
end )