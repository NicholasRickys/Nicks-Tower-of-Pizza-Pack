fsmstates[enums.MACH2]['npeppino'] = {
	name = "Mach 2",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACH2
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		if WallCheckHelper(player) and not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.WALLCLIMB)
			return
		end
		
		if (P_IsObjectOnGround(player.mo)) then
			player.pvars.movespeed = $+(FU/3)
			if (not player.pvars.forcedstate)
				player.pvars.forcedstate = S_PEPPINO_MACH2
			end
		elseif (player.pvars.forcedstate)
			player.pvars.forcedstate = nil
			player.mo.state = S_PEPPINO_SECONDJUMPTRNS
		end
		
		player.pvars.drawangle = player.drawangle
		
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		P_MovePlayer(player)
		
		if (not (player.cmd.buttons & BT_SPIN) and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, enums.SKID)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2) and not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.DIVE)
		end
		
		if ((player.cmd.buttons & BT_CUSTOM1 and not (player.prevkeys and player.prevkeys & BT_CUSTOM1))) then
			fsm.ChangeState(player, enums.GRAB)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2 and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, enums.ROLL)
		end
		
		if (player.pvars.movespeed >= (40*FU)) then
			fsm.ChangeState(player, enums.MACH3)
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