fsmstates[ntopp_v2.enums.DRIFT]['npeppino'] = {
	name = "Drift",
	// this code is half copied from skidding lmfao
	enter = function(self, player, last_state)
		if (last_state == ntopp_v2.enums.MACH2)
			player.pvars.forcedstate = S_PEPPINO_MACHDRIFT2
			player.mo.state = S_PEPPINO_MACHDRIFTTRNS2
			player.pvars.drifttime = 11*2
			S_StartSound(player.mo, sfx_pskid)
		else
			player.pvars.forcedstate = S_PEPPINO_MACHDRIFT3
			player.mo.state = S_PEPPINO_MACHDRIFTTRNS3
			player.pvars.drifttime = 13*2
			S_StartSound(player.mo, sfx_drift)
		end
		player.charflags = $|SF_RUNONWATER
		player.pvars.laststate = last_state // gotta use it to continue the speed where it was left off of
		// if (last_state == ntopp_v2.enums.MACH4) then player.pvars.laststate = ntopp_v2.enums.MACH3 end
		
		player.pvars.drawangle = player.drawangle // used so we can force a angle during skidding :DD
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.pflags = $|PF_JUMPSTASIS
		
		player.pvars.movespeed = max(2*FU, $-(FU))
		P_InstaThrust(player.mo, player.pvars.drawangle, FixedMul(player.pvars.movespeed, player.mo.scale))
		if (player.pvars.drifttime) then
			player.pvars.drifttime = $-1
		end

		local shouldmach = P_IsObjectOnGround(player.mo)
		if player.ntoppv2_sagedrift then
			shouldmach = true
		end

		if (not player.pvars.drifttime and shouldmach) then
			player.mo.momx = 0
			player.mo.momy = 0
			// i messed it up but i can care less i am not waiting that long like that time
			fsm.ChangeState(player, player.pvars.laststate)
		end
	end,
	exit = function(self, player, state)
		local tableofspeeds = {}
		
		tableofspeeds[ntopp_v2.enums.MACH2] = 18*FU
		tableofspeeds[ntopp_v2.enums.MACH3] = 40*FU
		
		player.pvars.movespeed = tableofspeeds[state]
		player.pvars.drawangle = nil
		player.pvars.laststate = nil
		
		player.charflags = $ & ~SF_RUNONWATER
	end
}