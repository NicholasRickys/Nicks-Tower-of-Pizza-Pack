fsmstates[ntopp_v2.enums.SKID]['npeppino'] = {
	name = "Skid",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACHSKID
		S_StartSound(player.mo, sfx_pskid)
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
		
		player.pvars.movespeed = max(0, $-(FU))
		player.drawangle = player.pvars.drawangle
		P_InstaThrust(player.mo, player.pvars.drawangle, FixedMul(player.pvars.movespeed, player.mo.scale))

		if (player.pvars.movespeed <= 4*FU) then
			player.mo.momx = 0
			player.mo.momy = 0
			// i messed it up but i can care less i am not waiting that long like that time
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
			player.pvars.forcedstate = nil
		end
	end,
	exit = function(self, player, state)
		player.pvars.movespeed = 8*FU
		player.pvars.drawangle = nil
	end
}