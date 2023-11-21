fsmstates[ntopp_v2.enums.DIVE]['npeppino'] = {
	name = "Dive",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_DIVE
		player.pvars.drawangle = player.drawangle
		L_ZLaunch(player.mo, -16*FU)
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
		
		player.drawangle = player.pvars.drawangle
		if not (leveltime % 4) then
			TGTLSGhost(player)
		end
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		P_MovePlayer(player)
		
		if P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.ROLL)
			return
		end
		
		if not (player.gotflag) and ((player.cmd.buttons & BT_JUMP) and not (player.prevkeys and player.prevkeys & BT_JUMP)) and not P_IsObjectOnGround(player.mo)
			fsm.ChangeState(player, ntopp_v2.enums.BODYSLAM)
			player.pvars.forcedstate = S_PEPPINO_DIVEBOMB
			return
		end
	end,
	exit = function(self, player, state)
		if (state == ntopp_v2.enums.BASE) then
			player.pvars.movespeed = 8*FU
			if (player.mo) then
				player.mo.momx = 0
				player.mo.momy = 0
			end
		end
	end
}