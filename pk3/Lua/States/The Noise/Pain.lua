fsmstates[enums.PAIN]['nthe_noise'] = {
	name = "Pain",
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
		end
		
		if not (P_PlayerInPain(player) or player.playerstate == PST_DEAD) then fsm.ChangeState(player, enums.BASE) end
	end
}