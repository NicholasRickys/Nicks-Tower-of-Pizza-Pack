fsmstates[ntopp_v2.enums.UPPERCUT]['npeppino'] = {
	name = "Belly Slide",
	enter = function(self, player)
		player.mo.momx = $/2
		player.mo.momy = $/2
		if not P_IsObjectOnGround(player.mo) then
			L_ZLaunch(player.mo, 13*FU)
		else
			L_ZLaunch(player.mo, 16*FU)
		end
		
		player.pvars.forcedstate = S_PEPPINO_UPPERCUTEND
		player.pflags = $|PF_JUMPED & ~PF_STARTJUMP
		S_StartSound(player.mo, sfx_upcut)
		S_StartSound(player.mo, sfx_upcu2)
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		if player.mo.momz*P_MobjFlip(player.mo) > 0 and not (leveltime % 4) then
			TGTLSAfterImage(player)
		end
		
		if P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
		end
	end
}