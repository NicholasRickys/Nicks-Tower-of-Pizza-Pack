fsmstates[enums.GRAB]['npeppino'] = {
	name = "Grab",
	enter = function(self, player, state)
		if (player.pvars.movespeed < 23*FU) then
			player.pvars.movespeed = 23*FU
		end
		player.pvars.laststate = state
		if laststate == enums.MACH1 then
			player.pvars.laststate = enums.MACH2
		end
		player.pvars.grabtime = 14*2
		
		player.pvars.forcedstate = S_PEPPINO_SUPLEXDASH
		player.pvars.cancelledgrab = false
	end,
	think = function(self, player)
		if (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid)) then
			P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
			
			if (player.pvars.grabtime) then
				player.pvars.grabtime = $-1
			else
				fsm.ChangeState(player, player.pvars.laststate)
			end
		else
			fsm.ChangeState(player, enums.BASE_GRABBEDENEMY)
			player.pvars.cancelledgrab = true
		end
	end,
	exit = function(self, player, state)
		if state ~= enums.MACH2 and state ~= enums.MACH3 and not (player.cmd.buttons & BT_SPIN) and not player.pvars.cancelledgrab then player.pvars.movespeed = 8*FU end
		if (player.pvars.cancelledgrab) then
			player.pvars.movespeed = 8*FU
		end
		player.pvars.cancelledgrab = false
	end
}