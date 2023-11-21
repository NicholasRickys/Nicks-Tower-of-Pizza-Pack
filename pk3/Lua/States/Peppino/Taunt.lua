fsmstates[ntopp_v2.enums.TAUNT]['npeppino'] = {
	name = "Standard",
	enter = function(self, player, state)
		if (player.pvars) then
			player.pvars.forcedstate = nil
			player.pvars.landanim = false
			player.pvars.forcedstate = S_PEPPINO_TAUNT
			player.pvars.tauntframe = P_RandomRange(A,I)
			player.mo.frame = player.pvars.tauntframe
			player.pvars.time = states[player.pvars.forcedstate].tics
			player.pvars.last_state = state
			
			player.pvars.savedmoms = {}
			player.pvars.savedmoms.x = player.mo.momx
			player.pvars.savedmoms.y = player.mo.momy
			player.pvars.savedmoms.z = player.mo.momz
			player.pvars.savedpflags = player.pflags
			player.pvars.savedstate = player.mo.state
			S_StartSound(player.mo, sfx_taunt)
		end
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.mo.frame = player.pvars.tauntframe
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		player.pflags = $|PF_FULLSTASIS
		
		if player.pvars.time then player.pvars.time = $-1
		else
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