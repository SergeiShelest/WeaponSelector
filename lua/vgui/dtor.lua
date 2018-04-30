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

local function surfaceSetMaterial( Mat, ErrMaterial )
	
	if TypeID( Mat ) == TYPE_MATERIAL then

		surface.SetMaterial( Mat )
			
	elseif TypeID( Mat ) == TYPE_NUMBER then
			
		surface.SetTexture( Mat )

	else

		surface.SetMaterial( ErrMaterial )

	end
end

function PANEL:Init()
	
	self.NoIcoMaterial = Material( "weapons/swep" )
	self.depth = 50
	self.smoothing = 90
	self.DisableMouseControl = false

	self.SegmentPos = 1
	self.array = {}
	self.return_ = nil
	self.delay = 0
	self.tc = 0
	self.step = {}
	self.pos = 0
	self.Ang = 0

	self.PosGoNext_ = false
	self.PosGoBack_ = false

end

function PANEL:PosGoNext()

	self.PosGoNext_ = true

end


function PANEL:PosGoBack()
	
	self.PosGoBack_ = true

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

function PANEL:Return( Return )
end

function PANEL:Chandge( Return )
end

function PANEL:Next( Return )
end

function PANEL:Back( Return )
end

function PANEL:Del()
end

surface.CreateFont("title_", {
	font = "CloseCaption_Normal",
	size = 32,
	weight = 700,
	antialias = true,
	additive = false,
})

function PANEL:Paint( w, h )

	self.r2 = w > h and h/2 or w/2
	self.r = self.r2 - self.depth

	self.xp = w / 2
	self.yp = h / 2

	self.Count = table.Count( self.array )
	self.Sector = 360 / self.Count

	draw.NoTexture()
	surface.SetDrawColor( 50, 50, 50, 255 )
	drawTor( self.xp, self.yp, self.r2, self.r, self.smoothing, 360, 0 )

	if self.array ~= nil then
		
		if self.DisableMouseControl then

			if self.PosGoNext_ then
				
				self.pos = self.pos + 1
				self.PosGoNext_ = false

			end

			if self.PosGoBack_ then

				self.pos = self.pos - 1
				self.PosGoBack_ = false

			end

			if self.pos > self.Count - 1 then

				self.pos = 0

			end

			if self.pos < 0 then

				self.pos = self.Count - 1

			end

			self.Ang = self.Sector * self.pos
			self.SegmentPos = self.pos + 1
			self.return_ = self.array[self.pos + 1].ret

		else
			   
			self.MouseAng = Vector( gui.MouseX() - self.xp, gui.MouseY() - self.yp ):Angle().y

			for i = 0, self.Count - 1 do
				if self.Sector * i < self.MouseAng and self.Sector * (i + 1) > self.MouseAng then
					self.Ang = self.Sector * i
					self.SegmentPos = i + 1
					self.return_ = self.array[i + 1].ret
					break
				end
			end
		end

		surface.SetDrawColor( 227, 152, 57, 255 )
		drawTor( self.xp, self.yp, self.r2 + 2, self.r - 2, self.smoothing, self.Sector, self.Sector/2 - self.Ang + 90 - self.Sector/2 )

		for i = 0, self.Count - 1 do
			self.rad = math.rad( self.Sector/2 - i * self.Sector + 90 - self.Sector )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surfaceSetMaterial( self.array[i + 1].ico, self.NoIcoMaterial )
			surface.DrawTexturedRect( self.xp +math.sin( self.rad ) * (self.r + (self.r2 - self.r)/2) - 128/2, self.yp + math.cos( self.rad ) * (self.r + (self.r2 - self.r)/2) - 64/2, 128, 64 )
		end

		surface.SetDrawColor( 255, 255, 255, 255 )
		surfaceSetMaterial( self.array[self.SegmentPos].ico, self.NoIcoMaterial )
		surface.DrawTexturedRect( self.xp - 256 / 2, self.yp - 128 / 2, 256, 128 )

		draw.Text( {
			text = self.array[self.SegmentPos].title,
			font = "title_",
			xalign = TEXT_ALIGN_CENTER,
			yalign = TEXT_ALIGN_CENTER,
			color = Color(255, 255, 255),
			pos = {self.xp, self.yp + self.r2 / 2.5}
		} )

	end


	if self.return_ ~= self.ReturnCh then

		self:Chandge( self.return_ )
		
	end

	self.ReturnCh = self.return_

	if input.IsMouseDown( MOUSE_LEFT ) and CurTime() > self.delay then

		self.delay = CurTime() + 0.3

		if TypeID( self.return_ ) == TYPE_TABLE and table.Count( self.return_ ) > 0 then
			
			self.tc = self.tc + 1
			self.step[self.tc] = self.array
			
			self.array = self.return_
			self:Next( self.return_ )

		end
		
		if TypeID( self.return_ ) ~= TYPE_TABLE then
		
			self:Return( self.return_ )
			self:Del()

		end
	end

	if input.IsMouseDown( MOUSE_RIGHT ) and CurTime() > self.delay  then

		self.delay = CurTime() + 0.3

		if self.tc > 0 then

			self.array = self.step[self.tc]
			self.tc = self.tc - 1
			self.step[self.tc] = nil

			self:Back( self.step )

		else
		    
			self:Del()
			self:Remove()

		end
	end
end

function PANEL:Rebuild()
end

function PANEL:GenerateExample( class, tabs, w, h )
end

derma.DefineControl( "DTor", "nil", PANEL, "DPanel" )