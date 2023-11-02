fsmstates[enums.BODYSLAM]['nthe_noise'] = {
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
		
		local grounded = false
		if P_MobjFlip(player.mo) == 1 then
			grounded = (player.mo.z <= player.mo.floorz)
		else
			grounded = P_IsObjectOnGround(player.mo)
		end
		if not grounded then L_ZLaunch(player.mo, -FU, true) end
		
		if grounded then
			player.pflags = $|PF_FULLSTASIS
			player.cmd.forwardmove = 0
			player.cmd.sidemove = 0
			player.pvars.forcedstate = S_PEPPINO_BODYSLAMLAND
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