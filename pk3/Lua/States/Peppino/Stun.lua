fsmstates[ntopp_v2.enums.STUN]['npeppino'] = {
	name = "Stun",
	enter = function(self, player, state)
		player.pvars.forcedstate = S_PEPPINO_MACH2STUN
		
		if state == ntopp_v2.enums.MACH3 then
			player.pvars.forcedstate = S_PEPPINO_MACH3STUN
			S_StartSound(player.mo, sfx_grpo)
			P_InstaThrust(player.mo, player.drawangle, -8*FU)
			player.mo.momz = 4*FU
		elseif state == ntopp_v2.enums.SUPERJUMP
		or state == ntopp_v2.enums.WALLCLIMB then
			player.pvars.forcedstate = S_PEPPINO_UPSTUN
			S_StartSound(player.mo, sfx_grpo)
		else
			S_StartSound(player.mo, sfx_mabmp)
		end
		
		player.pvars.time = states[player.pvars.forcedstate].tics
	end,
	think = function(self, player)
		if player.pvars.forcedstate ~= S_PEPPINO_MACH3STUN then
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
		end
		player.pflags = $|PF_FULLSTASIS
		if player.pvars.time then player.pvars.time = $-1 return end
		
		fsm.ChangeState(player, ntopp_v2.enums.BASE)
	end
}