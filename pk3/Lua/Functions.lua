rawset(_G, 'L_ZLaunch', function(mo,thrust,relative)
	if mo.eflags&MFE_UNDERWATER
		thrust = $*3/5
	end
	P_SetObjectMomZ(mo,thrust,relative)
end)

rawset(_G, "WallCheckHelper", function(mo, line) //unused for the most part, damn.
	if not (mo and line) then return end
	// return values should be: height, angle, fofz, fofheight, climbable
	
	local fofz = nil
	local fofheight = nil
	local side = 0
	
	// first we will check the sector shit
	local sector = line.frontsector
	if (mo.sector == line.frontsector and line.backsector) then
		sector = line.backsector
	end
	
	local diff = sector.ceilingheight - sector.floorheight
	local height = sector.ceilingheight - diff
	
	// then fof shit
	if (mo.z >= height) then
		for fof in sector.ffloors() do
			if mo.z >= fof.bottomheight and mo.z < fof.topheight then
				fofz = fof.bottomheight
				fofheight = fof.topheight
				break
			end
		end
	end
	
	// then angle shit
	
	if line.frontsector == mo.subsector.sector -- front facing
		side = 1
	elseif line.backsector and line.backsector == mo.subsector.sector -- back facing
		side = -1
	end
	
	local angle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y) + (ANGLE_90 * side)
	
	return height, angle, fofz, fofheight
end)

rawset(_G, "Init", function()
	local t = {}
	
	t.movespeed = 8*FU
	t.forcedstate = nil
	
	return t
end)

rawset(_G, "GetMachSpeedEnum", function(movespeed)
	if movespeed <= 18*FU then return enums.MACH1 end
	if movespeed >= 40*FU then return enums.MACH3 end
	
	return enums.MACH2
end)

//code by luigi
//LUIGI BUDD WAS HERE!!
//fix whatever nick was doing
rawset(_G, "SpawnGrabbedObject",function(tm,source)
	if not (tm and tm.valid and source and source.valid) then return end
	local ragdoll = P_SpawnMobjFromMobj(tm,0,0,tm.height,MT_GRABBEDMOBJ)
	tm.tics = -1
	ragdoll.sprite = tm.sprite
	ragdoll.color = tm.color
	ragdoll.angle = source.angle
	ragdoll.frame = tm.frame
	ragdoll.height = tm.height
	ragdoll.radius = tm.radius
	ragdoll.scale = tm.scale
	ragdoll.timealive = 1
	ragdoll.target = source
	ragdoll.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOCLIPTHING
	ragdoll.ragdoll = true
	ragdoll.tics = -1
	P_RemoveMobj(tm)

	return ragdoll
end)

rawset(_G, 'stepframes', function(p)
	if (p.mo.frame == D or p.mo.frame == I)
		return true
	else
		return false
	end
end)