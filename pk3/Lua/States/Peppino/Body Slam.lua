fsmstates[enums.BODYSLAM]['npeppino'] = {
	name = "Body Slam",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_BODYSLAM
		player.mo.state = S_PEPPINO_BODYSLAMSTART
		L_ZLaunch(player.mo, 12*FU)
		player.pvars.hitfloor = false
		player.pvars.hitfloor_time = 8
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.mo.momz = $-(FU)
		
		if P_IsObjectOnGround(player.mo) then
			player.pflags = $|PF_FULLSTASIS
			player.pvars.forcedstate = S_PEPPINO_BODYSLAMLAND
			player.mo.state = S_PEPPINO_BODYSLAMLAND
			player.mo.momx = 0
			player.mo.momy = 0
			if not player.pvars.hitfloor then
				player.pvars.hitfloor = true
			end
			if player.pvars.hitfloor_time then
				player.pvars.hitfloor_time = $-1
			else
				fsm.ChangeState(player, enums.BASE)
			end
		end
	end
}