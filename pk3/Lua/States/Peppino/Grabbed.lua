fsmstates[ntopp_v2.enums.GRABBED]['npeppino'] = {
	name = "Grabbed",
	enter = function(self, player)
		P_InstaThrust(player.mo, player.drawangle, -16*FU)
		player.pvars.forcedstate = L_Choose(S_PEPPINO_KUNGFU_1, S_PEPPINO_KUNGFU_2, S_PEPPINO_KUNGFU_3)
		player.pvars.time = 20
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		player.pflags = $|PF_FULLSTASIS
		
		if not (leveltime % 4) then TGTLSGhost(player) end
		
		if player.pvars.time then player.pvars.time = $-1 return end
		
		fsm.ChangeState(player, ntopp_v2.enums.BASE)
	end
}