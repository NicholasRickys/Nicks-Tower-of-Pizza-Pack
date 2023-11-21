rawset(_G, 'isPTSkin', function(skin)
	return (skin == "npeppino" or skin == "nthe_noise")
end)

rawset(_G, 'L_ZLaunch', function(mo,thrust,relative)
	if mo.eflags&MFE_UNDERWATER
		thrust = $*3/5
	end
	P_SetObjectMomZ(mo,thrust,relative)
end)

rawset(_G, 'L_Choose', function(...)
	local choices = {...}
	return choices[P_RandomRange(1,#choices)]
end)

rawset(_G, "IncreaseSuperTauntCount", function(player)
	if not player.pvars.supertauntcount then
		player.pvars.supertauntcount = 0
	end
	
	player.pvars.supertauntcount = $+1
	
	if player.pvars.supertauntcount >= 10 and not player.pvars.supertauntready then
		player.pvars.supertauntready = true
		S_StartSound(player.mo, sfx_strea)
		print('unleash the kraken')
	end
end)

rawset(_G, "WallCheckHelper", function(player, l) //unused for the most part, damn.
	if not (player and player.valid and player.mo and player.mo.valid) then return end
	if l and l.valid then
		player.pvars.savedline = l
	end
	local line = player.pvars.savedline
	local fheight = 0
	local cheight = 0
	local atwall = 0
	
	if line and not player.pvars.mobjblocked then
		//buggie was a major help here
		//this code is from his wall check v2, which he gave me permission to use
		local linex,liney = P_ClosestPointOnLine(player.mo.x,player.mo.y,line)
		local lineangle = R_PointToAngle2(player.mo.x,player.mo.y,linex,liney)
		local lineside = P_PointOnLineSide(player.mo.x,player.mo.y,line)
		
		local side = sides[line.sidenum[lineside]]
		local backside = sides[line.sidenum[1-lineside]]
		
		local frontsec = side and side.sector and side.sector.valid and side.sector --Shut up.
		local backsec = backside and backside.sector and backside.sector.valid and backside.sector
		
		if player.mo.subsector and player.mo.subsector.sector then
			if side and side.sector and player.mo.subsector.sector == side.sector then
				frontsec = side and side.sector and side.sector.valid and side.sector
				backsec = backside and backside.sector and backside.sector.valid and backside.sector
			else
				frontsec = backside and backside.sector and backside.sector.valid and backside.sector
				backsec = side and side.sector and side.sector.valid and side.sector
			end
		end
		
		if player.fsm and player.fsm.state == ntopp_v2.enums.WALLCLIMB then
			player.drawangle = lineangle
		end
		if backsec then
			local floorz = backsec.floorheight
			local ceilingz = backsec.ceilingheight
			
			if backsec.f_slope then
				floorz = P_GetZAt(backsec.f_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
			end
			if backsec.c_slope then
				ceilingz = P_GetZAt(backsec.c_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
			end
			
			local diff = player.drawangle - lineangle
			if (diff <= ANG1*35 and diff >= -ANG1*35) then
				for wall in backsec.ffloors() do
					if (player.mo.z <= wall.topheight) and (player.mo.height+player.mo.z > wall.bottomheight)
						and(wall.flags & FF_EXISTS)
						and(wall.flags & FF_SOLID or wall.flags & FF_BLOCKPLAYER) then //Don't want the player to cling to water. That would be stupid
						return 1
					end
				end
				
				local canclimb = player.mo.eflags & MFE_VERTICALFLIP and (player.mo.z + player.mo.height >= ceilingz) or (player.mo.z <= floorz)
				if canclimb then return 1 end
			end
		end
	end
	
	// didnt pass through? lets do a check using "raycasting"
	if not player.pvars.mobjblocked then
		//Finding walls (not FOFs)
		//second attempt at finding wall code from ssnmighty by man553, shoutouts to my bro
		local wall = R_PointInSubsector(player.mo.x+FixedMul(26*FRACUNIT, cos(player.drawangle)), player.mo.y+FixedMul(26*FRACUNIT, sin(player.drawangle))).sector
		fheight = wall.floorheight
		cheight = wall.ceilingheight
	
		if wall.f_slope then
			fheight = P_GetZAt(wall.f_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
		end
		if wall.c_slope then
			cheight = P_GetZAt(wall.c_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
		end
		
		if wall and not (wall.flags & ML_NOCLIMB) and (fheight > player.mo.z) or ((cheight <= player.mo.height+player.mo.z) and not (fheight == cheight)/* and (wall.ceilingpic == "F_SKY1")*/) then //This last bit seems to be broken...
			atwall = $+1
		end
		//FOFs can be walls too, so lets check for those
		for wall in wall.ffloors()
			if (player.mo.z <= wall.topheight) and (player.mo.height+player.mo.z > wall.bottomheight)
				and(wall.flags & FF_EXISTS)
				and(wall.flags & FF_SOLID or wall.flags & FF_BLOCKPLAYER) //Don't want the player to cling to water. That would be stupid
				atwall = $ + 1
			end		
		end
	end
	
	if player.pvars.mobjblocked then
		if player.mo.z < player.pvars.mobjblocked.z+player.pvars.mobjblocked.height and player.mo.z+player.mo.height > player.pvars.mobjblocked.z then
			atwall = $+1
		else
			player.pvars.mobjblocked = nil
		end
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
	if movespeed <= 18*FU then return ntopp_v2.enums.MACH1 end
	if movespeed >= 40*FU then return ntopp_v2.enums.MACH3 end
	
	return ntopp_v2.enums.MACH2
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
	if p.mo.state == S_PLAY_WALK
		if (p.mo.frame == D or p.mo.frame == I)
			return true
		else
			return false
		end
	else
		return (not (leveltime % 2))
	end
end)

rawset(_G, "P_CreateRing", function(p)
	local ring = P_SpawnMobj(p.mo.x,p.mo.y,p.mo.z,MT_THOK)
	ring.state = S_MACH4RING
	ring.fuse = 999
	ring.tics = 20
	ring.angle = p.drawangle+ANGLE_90
	ring.scale = p.mo.scale-FRACUNIT/2
	ring.destscale = p.mo.scale*2
	ring.colorized = true
	ring.color = SKINCOLOR_WHITE
	if (p.mo.eflags & MFE_VERTICALFLIP)
		ring.flags2 = $|MF2_OBJECTFLIP
		ring.eflags = $|MFE_VERTICALFLIP
	end
end)