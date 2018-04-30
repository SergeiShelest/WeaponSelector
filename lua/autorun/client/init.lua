
local PANEL = {}

local function OpenWS(DMC)

	local slot = {}

	slot[1] = {ret = {}, title = "Melee Weapon", ico = Material("weapons/1.png")}
	slot[2] = {ret = {}, title = "Pistols", ico = Material("weapons/2.png")}
	slot[3] = {ret = {}, title = "Assault Rifles/Submachine Guns", ico = Material("weapons/3.png")}
	slot[4] = {ret = {}, title = "Sniper Rifles/Shotguns", ico = Material("weapons/4.png")}
	slot[5] = {ret = {}, title = "Explosive", ico = Material("weapons/5.png")}
	slot[6] = {ret = {}, title = "Tools", ico = Material("weapons/6.png")}

	local Ply = LocalPlayer()

	for k, v in pairs( LocalPlayer():GetWeapons() ) do
			
		table.insert( slot[v:GetSlot() +1].ret, {ret = v, title = v:GetPrintName(), ico = v.WepSelectIcon} )

	end

	PANEL.Fr = vgui.Create( "DFrame" )
	PANEL.Fr:SetPos( 0, 0 )
	PANEL.Fr:SetSize( ScrW(), ScrH() )
	PANEL.Fr:SetTitle( "" )
	PANEL.Fr:SetDraggable( false )
	PANEL.Fr:SetSizable( false )
	PANEL.Fr:ShowCloseButton( false )
	PANEL.Fr.Paint = function(self, w, h) end

	if not DMC then
		PANEL.Fr:MakePopup()
	end

	PANEL.Tor = vgui.Create( "DTor", PANEL.Fr )
	PANEL.Tor:SetArray( slot )
	PANEL.Tor:SetDepth( 90 )
	PANEL.Tor:SetPos( 0, 0 )
	PANEL.Tor:Dock( FILL )

	PANEL.Tor.DisableMouseControl = DMC

	function PANEL.Tor:Return( Return )
		
		sound.Play( "items/gift_pickup.wav", Ply:GetPos(), 75, 100, 1 )
		input.SelectWeapon( Return )

	end

	function PANEL.Tor:Chandge( Return )
		
		sound.Play( "items/flashlight1.wav", Ply:GetPos(), 75, 110, 1 )

	end

	function PANEL.Tor:Next( Return )
		
		sound.Play( "items/ammo_pickup.wav", Ply:GetPos(), 75, 100, 1 )

	end

	function PANEL.Tor:Del()

		PANEL.Fr:Remove()

	end

end

hook.Add("PlayerBindPress", "MouseWheel", function(ply, bind, pressed)
	
	if (bind == "invprev" or bind == "invnext") and not IsValid( PANEL.Fr ) and not vgui.CursorVisible() then

		OpenWS(true)

	end

	if bind == "invprev" then
	
		PANEL.Tor:PosGoBack()
	
	end

	if bind == "invnext" then

		PANEL.Tor:PosGoNext()
	
	end
	
	if bind == "+attack" and IsValid( PANEL.Fr ) then
		print( 1 )
		return true
	
	end

end)

hook.Add( "Think", "OpenWS", function()
	
	if input.IsMouseDown( MOUSE_MIDDLE ) and not IsValid( PANEL.Fr ) and not vgui.CursorVisible() then

		OpenWS(false)

	end

end )

hook.Add( "HUDShouldDraw", "HideStandartHud", function( name )
    
    if name == "CHudWeaponSelection" then 
        
        return false 
        
    end    
    
end )