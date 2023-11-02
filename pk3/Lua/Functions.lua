rawset(_G, 'L_ZLaunch', function(mo,thrust,relative)
	if mo.eflags&MFE_UNDERWATER
		thrust = $*3/5
	end
	P_SetObjectMomZ(mo,thrust,relative)
end)

rawset(_G, "WallCheckHelper", function(player) //unused for the most part, damn.
	if not player.mo then return end
	// return values should be: height, angle, fofz, fofheight, climbable
	
	local atwall = 0
		
	//Finding walls (not FOFs)
	//code from ssnmighty by man553, shoutouts to my bro
	local wall = R_PointInSubsector(player.mo.x+FixedMul(26*FRACUNIT, cos(player.mo.angle)), player.mo.y+FixedMul(26*FRACUNIT, sin(player.mo.angle))).sector
	local fheight = wall.floorheight
	local cheight = wall.ceilingheight

	if wall.f_slope then
		fheight = P_GetZAt(wall.f_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
	end
	if wall.c_slope then
		cheight = P_GetZAt(wall.c_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
	end
	
	if wall and (fheight > player.mo.z) or ((cheight <= player.mo.height+player.mo.z) and not (fheight == cheight)/* and (wall.ceilingpic == "F_SKY1")*/) //This last bit seems to be broken...
		atwall = 1
	end
	//FOFs can be walls too, so lets check for those
	for wall in wall.ffloors()
		if (player.mo.z <= wall.topheight) and (player.mo.height+player.mo.z > wall.bottomheight)
			and(wall.flags & FF_EXISTS)
			and not (wall.flags & FF_CUTSPRITES)
			and(wall.flags & FF_SOLID or wall.flags & FF_BLOCKPLAYER) //Don't want the player to cling to water. That would be stupid
			atwall = $ + 1
		end		
	end
	if wall.f_slope and f_slope == player.mo.standingslope then
		atwall = 0
	end
	return atwall
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