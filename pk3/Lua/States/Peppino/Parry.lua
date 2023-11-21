fsmstates[ntopp_v2.enums.PARRY]['npeppino'] = {
	name = "Parry",
	enter = function(self, player)
		player.pvars.forcedstate = L_Choose(S_PEPPINO_PARRY1, S_PEPPINO_PARRY2)
		player.pvars.landanim = false
		if (player.mo) then
			player.mo.state = S_PLAY_STND // will default to what state it should be
		end
		P_InstaThrust(player.mo, player.drawangle, FixedMul(-8*FU, player.mo.scale))
		P_MovePlayer(player)
		player.pvars.time = 12*2
		S_StartSound(player.mo, sfx_parry)
	end,
	think = function(self, player)
		if not (player.mo) then return end
		
		player.pflags = $|PF_FULLSTASIS
		
		if player.pvars.time then 
			player.pvars.time = $-1 
			return 
		end
		fsm.ChangeState(player, ntopp_v2.enums.BASE)
	end
}