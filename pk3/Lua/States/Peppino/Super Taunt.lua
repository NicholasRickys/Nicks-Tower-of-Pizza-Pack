fsmstates[ntopp_v2.enums.SUPERTAUNT]['npeppino'] = {
	name = "Super Taunt",
	enter = function(self, player, state)
		if (player.pvars) then
			player.pvars.forcedstate = nil
			player.pvars.landanim = false
			player.pvars.forcedstate = L_Choose(S_PEPPINO_SUPERTAUNT1, S_PEPPINO_SUPERTAUNT2, S_PEPPINO_SUPERTAUNT3, S_PEPPINO_SUPERTAUNT4)
			player.pvars.time = states[player.pvars.forcedstate].tics
			
			player.pvars.savedmoms = {}
			player.pvars.savedmoms.x = player.mo.momx
			player.pvars.savedmoms.y = player.mo.momy
			player.pvars.savedmoms.z = player.mo.momz
			player.pvars.savedpflags = player.pflags
			player.pvars.savedstate = player.mo.state
			player.pvars.last_state = state
			S_StartSound(player.mo, sfx_taunt)
		end
		player.pvars.supertauntcount = 0
		player.pvars.supertauntready = false
		P_Earthquake(player.mo, player.mo,1500*FU)
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		player.pflags = $|PF_FULLSTASIS
		
		if player.pvars.time then player.pvars.time = $-1 end
		if not player.pvars.time then
			fsm.ChangeState(player, player.pvars.last_state)
		end
	end,
	exit = function(self, player)
		player.mo.momx = player.pvars.savedmoms.x
		player.mo.momy = player.pvars.savedmoms.y
		player.mo.momz = player.pvars.savedmoms.z
		player.pflags = player.pvars.savedpflags
		player.mo.state = player.pvars.savedstate
		P_MovePlayer(player)
	end
}