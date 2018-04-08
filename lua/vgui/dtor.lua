
local PANEL = {}

DEFINE_BASECLASS( "DPanel" )

local quad = {}
local a = 0

local function drawTor( x, y, r, r2, seg, a1, a2 )
	for i = 1, seg do

		a = math.rad( (i / seg) * -a1 ) + math.rad( a2 )
		table.insert( quad, {x = x + math.sin( a ) * r, y = y + math.cos( a ) * r} )
		table.insert( quad, {x = x + math.sin( a ) * r2, y = y + math.cos( a ) * r2} )

		a = math.rad( ((i-1) / seg) * -a1 ) + math.rad( a2 )
		table.insert( quad, {x = x + math.sin( a ) * r2, y = y + math.cos( a ) * r2} )
		table.insert( quad, {x = x + math.sin( a ) * r, y = y + math.cos( a ) * r} )

		surface.DrawPoly(quad)
		
		quad = {}

	end
end

function PANEL:Init()
	
	self.depth = 50
	self.smoothing = 90
	self.array = {}
	self.return_ = nil

	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

end

function PANEL:SetSmoothing( smoothing )

	self.smoothing = smoothing

end

function PANEL:SetDepth( depth )

	self.depth = depth

end

function PANEL:SetArray( array )

	self.array = array

end

function PANEL:GetReturn()
	
	return self.return_
	
end

surface.CreateFont("title_", {
	font = "CloseCaption_Normal",
	size = 32,
	weight = 700,
	antialias = true,
	additive = false,
})

local xp = 0
local yp =  0
local r = 0
local r2 = 0
local MouseAng = 0
local Count = 0
local Sector = 0
local Ang = 0
local rad = 0
local ret = nil
local SegmentPos = 1

function PANEL:Paint( w, h )

	self.radius = w > h and h/2 or w/2
	self.radius2 = self.radius - self.depth

	xp = w/2
	yp = h/2

	r = self.radius2
	r2 = self.radius

	MouseAng = Vector( gui.MouseX() - xp, gui.MouseY() - yp ):Angle().y
	Count = table.Count( self.array )
	Sector = 360/Count

	draw.NoTexture()
	surface.SetDrawColor( 255, 255, 255, 255 )
	drawTor( xp, yp, r2, r, self.smoothing, 360, 0 )

	if self.array ~= {} then
		
		for i = 0, Count - 1 do
			if Sector * i < MouseAng and Sector * (i + 1) > MouseAng then
				Ang = Sector * i
				SegmentPos = i + 1
				self.return_ = self.array[i + 1].ret
				break
			end
		end

		surface.SetDrawColor( 0, 0, 255, 255 )
		drawTor( xp, yp, r2 + 2, r - 2, 25, Sector, Sector/2 - Ang + 90 - Sector/2 )

		for i = 0, Count - 1 do
			rad = math.rad( Sector/2 - i * Sector + 90 - Sector )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( self.array[i + 1].ico )
			surface.DrawTexturedRect( xp +math.sin( rad ) * (r + (r2 - r)/2) - 128/2, yp + math.cos( rad ) * (r + (r2 - r)/2) - 64/2, 128, 64 )
		end

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.array[SegmentPos].ico )
		surface.DrawTexturedRect( xp - 256/2, yp - 128/2, 256, 128 )

		draw.Text( {
			text = self.array[SegmentPos].title,
			font = "title_",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			color = Color(255, 255, 255),
			pos = {xp, yp + r2/2.5}
		} )

	end

end

function PANEL:Rebuild()
end

function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "DTor", "nil", PANEL, "DPanel" )