fsmstates[enums.GRAB_KILLENEMY]['nthe_noise'] = {
	name = "Kill Enemy",
	enter = function(self, player, state)
		player.pvars.killtime = 10*2
		player.pvars.killed = false
		player.pvars.forcedstate = L_Choose(S_PEPPINO_FINISHINGBLOW1, S_PEPPINO_FINISHINGBLOW2, S_PEPPINO_FINISHINGBLOW3, S_PEPPINO_FINISHINGBLOW4, S_PEPPINO_FINISHINGBLOW5)
	end,
	think = function(self, player)
		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) then
			fsm.ChangeState(player, enums.BASE)
			return
		end
		if (player.pvars.killtime) then
			player.pvars.killtime = $-1
		else
			fsm.ChangeState(player, enums.BASE)
			return
		end
		
		if (player.pvars.killtime <= 8 and not player.pvars.killed) then
			player.pvars.grabbedenemy.killed = true
			player.pvars.grabbedenemy.flags = MF_NOCLIPHEIGHT|MF_NOGRAVITY
			player.pvars.killed = true
		end
	end,
	exit = function(self, player, state)
		player.pvars.killed = nil
	end
}