addHook("PlayerThink", function(p)
	if leveltime%10 == 0
	and p.mo.state == S_PEPPINO_MACH4
		P_CreateRing(p)
	end
	if leveltime%10 == 0
	and p.mo.state == S_PEPPINO_SUPERJUMP
		local ring = P_SpawnMobj(p.mo.x,p.mo.y,p.mo.z,MT_THOK)
		ring.state = S_MACH4RING
		ring.fuse = 999
		ring.tics = 20
		ring.angle = p.drawangle+ANGLE_90
		ring.scale = p.mo.scale-FRACUNIT/2
		ring.destscale = p.mo.scale*2
		ring.colorized = true
		ring.color = SKINCOLOR_WHITE
		ring.renderflags = $|RF_FLOORSPRITE
		if (p.mo.eflags & MFE_VERTICALFLIP)
			ring.flags2 = $|MF2_OBJECTFLIP
			ring.eflags = $|MFE_VERTICALFLIP
		end
	end
end)

addHook("MobjDeath", function(target, inflictor, source, damagetype)
	if target and target.valid
	and inflictor and inflictor.valid
	and inflictor.player and inflictor.player.valid
	and isPTSkin(inflictor.skin)
	and inflictor.player.pvars
	and (inflictor.player.fsm and (inflictor.player.fsm.state ~= ntopp_v2.enums.TAUNT and inflictor.player.fsm.state ~= ntopp_v2.enums.PARRY))
	-- and not (inflictor.player.pvars.grabbedenemy and inflictor.player.pvars.grabbedenemy.valid)
	and (target.flags & MF_ENEMY)
		local ragdoll = P_SpawnMobj(target.x,target.y,target.z,MT_NTOPP_RAGDOLLENEMY)
		if ragdoll.valid and target.valid then
			ragdoll.scale = target.scale
			ragdoll.state = target.state
			ragdoll.sprite = target.sprite
		end
		P_SetObjectMomZ(ragdoll, 20*FRACUNIT)
		P_InstaThrust(ragdoll, inflictor.player.drawangle, inflictor.player.speed/3)
		S_StopSoundByID(target, sfx_pop)
		S_StartSound(inflictor, sfx_kenem)
		target.flags2 = $|MF2_DONTDRAW
		P_AddPlayerScore(inflictor.player, 100)
		return true
	end
end)

addHook("MobjThinker", function(ragdoll)
	if ragdoll and ragdoll.valid
		if ragdoll.redraw == nil
			ragdoll.redraw = 0
		end
		if ragdoll and ragdoll.valid
			local ghost = P_SpawnGhostMobj(ragdoll)
			ghost.fuse = 2
			ragdoll.rollangle = ragdoll.redraw
			ragdoll.redraw = $+ANG20
		end
		if (ragdoll.eflags & MFE_JUSTHITFLOOR or P_IsObjectOnGround(ragdoll) and ragdoll.momz == 0)
			P_SpawnMobj(ragdoll.x,ragdoll.y,ragdoll.z,MT_EXPLODE)
			S_StartSound(ragdoll, sfx_pop)
			P_RemoveMobj(ragdoll)
		end
	end
end,MT_NTOPP_RAGDOLLENEMY)

addHook("PlayerThink", function(p)
	if p.mo
	and p.pvars
	and p.pvars.supertauntready
	and leveltime%5 == 0
		local pp = P_SpawnMobjFromMobj(p.mo, P_RandomRange(-20, 20) * FRACUNIT, P_RandomRange(-20, 20) * FRACUNIT, P_RandomRange(0, 50) * FRACUNIT, MT_THOK)
		pp.color = p.mo.color
		pp.colorized = true
		pp.state = S_SUPERTAUNTEFFECT
	end
end)