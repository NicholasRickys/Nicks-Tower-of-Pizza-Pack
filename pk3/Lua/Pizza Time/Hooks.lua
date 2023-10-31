addHook('MapChange', function()
	PTV3_F.Initialize()
end)

addHook('MapLoad', function()
	if not PTV3_F.IsGametype() then return end
	local inited = 0
	for t in mapthings.iterate do
		if t.type == 501 then
			PTV3_V.endcoords = {x = t.x*FU, y = t.y*FU, z = t.z*FU, a = t.angle*ANG1}
			print('end')
		end
		if t.type == 1 then
			if PTV3_V.beginningsector then continue end
			local subsector = R_PointInSubsector(t.x*FU, t.y*FU)
			
			PTV3_V.beginningsector = subsector.sector
		end
	end
end)

local function Timer()
	if not PTV3_V.pizzatime then return end
	if PTV3_V.pizzatime and PTV3_V.timer then
		PTV3_V.timer = $-1
		return
	end
	
	
	
	if not PTV3_V.timer then
		G_ExitLevel()
		return
	end
end

addHook('ThinkFrame', do
	if not PTV3_F.IsGametype() then return end
	
	for p in players.iterate do
		if not p.valid then continue end
		if not p.ptv3 then PTV3_F.Initialize_Player(p) end
		
		if p.mo and P_MobjTouchingSectorSpecial(p.mo, 4, 2) then
			PTV3_F.StartPizzaTime(p)
		end
		
		if p.ptv3.canlap and p.cmd.buttons & BT_ATTACK then
			PTV3_F.StartNewLap(p)
		end
	end
	
	if (PTV3_V.timer <= 219*TICRATE) and not PTV3_V.hurryup and PTV3_V.pizzatime then
		PTV3_V.hurryup = true
		print('hurry up')
		S_ChangeMusic('HURRUP', true)
	end
	
	Timer()
end)

addHook('MobjLineCollide', function(mobj, line)
	if not PTV3_F.IsGametype() then return end
	if not PTV3_V.pizzatime then return end
	
	local sector = line.frontsector
	if mobj.subsector.sector == line.frontsector then
		sector = line.backsector
	end
	
	if sector == PTV3_V.beginningsector then
		P_DoPlayerExit(mobj.player)
		mobj.player.ptv3.canlap = true
	end
end, MT_PLAYER)

addHook('NetVars', function(net)
	PTV3_V = net($)
end)