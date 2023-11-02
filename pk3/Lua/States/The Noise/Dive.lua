fsmstates[enums.DIVE]['nthe_noise'] = {
	name = "Dive",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_DIVE
		player.pvars.angle = player.drawangle
		player.mo.momz = (-11*FU)*P_MobjFlip(player.mo)
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		if (player.pvars.slidetime) then
			player.pvars.slidetime = $-1
		end
		
		player.drawangle = player.pvars.angle
		
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		P_MovePlayer(player)
		
		if P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.ROLL)
			return
		end
		
		if ((player.cmd.buttons & BT_JUMP) and not (player.prevkeys and player.prevkeys & BT_JUMP)) then
			fsm.ChangeState(player, enums.BODYSLAM)
			//player.pvars.forcedstate = S_PEPPINO_DIVEBOMB
		end
	end,
	exit = function(self, player, state)
		if (state == enums.BASE) then
			player.pvars.movespeed = 8*FU
			if (player.mo) then
				player.mo.momx = 0
				player.mo.momy = 0
			end
		end
	end
}