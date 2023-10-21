fsmstates[enums.BASE]['npeppino'] = {
	name = "Standard",
	enter = function(self, player)
		if (player.pvars) then
			player.pvars.forcedstate = nil
			player.pvars.landanim = false
			if (player.mo) then
				player.mo.state = S_PLAY_STND // will default to what state it should be
			end
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
		player.pvars.movespeed = 8*FU

		if (not P_IsObjectOnGround(player.mo)) then
			if (player.mo.momz*P_MobjFlip(player.mo) > 0 and player.pvars.forcedstate ~= S_PLAY_SPRING) then
				player.pvars.forcedstate = S_PLAY_SPRING
				player.mo.state = S_PEPPINO_JUMPTRNS
				if not (player.pvars.landanim) then
					player.pvars.landanim = true
				end
			elseif (player.mo.momz*P_MobjFlip(player.mo) <= 0 and player.pvars.forcedstate ~= S_PLAY_FALL) then
				player.pvars.forcedstate = S_PLAY_FALL
				if (player.laststate == S_PLAY_SPRING) then
					player.mo.state = S_PEPPINO_FALLTRNS
				end
			end
		elseif (player.pvars.forcedstate)
			player.pvars.forcedstate = nil
			
			if (player.pvars.landanim and not (player.cmd.sidemove or player.cmd.forwardmove)) then
				player.mo.momx,player.mo.momy = 0,0
				player.mo.state = S_PEPPINO_LAND
			end
		end
		
		if (player.keysHandler[BT_CUSTOM1].justpressed) then
			fsm.ChangeState(player, enums.GRAB)
		end
		
		if (player.keysHandler[BT_SPIN].pressed and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, enums.MACH1)
		end
	end
}