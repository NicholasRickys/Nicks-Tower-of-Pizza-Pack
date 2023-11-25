rawset(_G, 'isPTSkin', function(skin)
	return (skin == "npeppino" or skin == "nthe_noise")
end)

rawset(_G, 'L_ZLaunch', function(mo,thrust,relative)
	if mo.eflags&MFE_UNDERWATER
		thrust = $*3/5
	end
	P_SetObjectMomZ(mo,thrust,relative)
end)

rawset(_G, "IncreaseSuperTauntCount", function(player)
	if not player.pvars.supertauntcount then
		player.pvars.supertauntcount = 0
	end
	
	player.pvars.supertauntcount = $+1
	
	if player.pvars.supertauntcount >= 10 and not player.pvars.supertauntready then
		player.pvars.supertauntready = true
		S_StartSound(player.mo, sfx_strea)
	end
end)

rawset(_G, "WallCheckHelper", function(player, l) //unused for the most part, damn.
	if not (player and player.valid and player.mo and player.mo.valid) then return end
	if l and l.valid then
		player.pvars.savedline = l
	end
	local line = player.pvars.savedline
	local atwall = 0
	
	local sector = line.frontsector
	if line.backsector and player.mo.subsector.sector == sector then
		sector = line.backsector
	end

	local climbing = (player.mo.z < sector.floorheight)
	if not line.backsector then
		climbing = true
	end
	if climbing then
		return true
	end
	
	for _,sec in pairs({line.frontsector, line.backsector}) do
		if not sec then continue end
		for wall in sec.ffloors() do
			if (player.mo.z <= wall.topheight) and (player.mo.height+player.mo.z > wall.bottomheight)
				and(wall.flags & FF_EXISTS)
				and(wall.flags & FF_SOLID or wall.flags & FF_BLOCKPLAYER) then //Don't want the player to cling to water. That would be stupid
				return true
			end
		end
	end
	
	if player.pvars.mobjblocked then
		if player.mo.z < player.pvars.mobjblocked.z+player.pvars.mobjblocked.height and player.mo.z+player.mo.height > player.pvars.mobjblocked.z then
			return true
		else
			player.pvars.mobjblocked = nil
		end
	end
	return false
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