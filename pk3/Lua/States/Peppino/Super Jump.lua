fsmstates[enums.SUPERJUMPSTART]['npeppino'] = {
	name = "Super Jump Start",
	enter = function(self, player)
		if (player.pvars) then
			player.pvars.forcedstate = S_PEPPINO_SUPERJUMPSTART
			player.pvars.superjumpstarttime = 16
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
		
		if (player.pvars.superjumpstarttime) then 
			player.pvars.superjumpstarttime = $-1
			if (player.mo.state ~= S_PEPPINO_SUPERJUMPSTARTTRNS) then
				player.mo.state = S_PEPPINO_SUPERJUMPSTARTTRNS
			end
			player.pflags = $|PF_FULLSTASIS
			return
		else
			player.pflags = $|PF_STASIS
		end
			
		if not (player.cmd.buttons & BT_CUSTOM3) and P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.SUPERJUMP)
		end
	end
}

fsmstates[enums.SUPERJUMP]['npeppino'] = {
	name = "Super Jump",
	enter = function(self, player)
		if (player.pvars) then
			player.pvars.forcedstate = S_PEPPINO_SUPERJUMP
			player.pvars.landanim = false
			player.pvars.superjumpery = 0
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
			
		player.mo.momx = 0
		player.mo.momy = 0
		L_ZLaunch(player.mo, ((20*FU)+player.pvars.superjumpery))
		player.pvars.superjumpery = $+(FU/6)
		
		local spinpressed = (player.cmd.buttons & BT_SPIN) and not (player.prevkeys and player.prevkeys & BT_SPIN)
		local grabpressed = (player.cmd.buttons & BT_CUSTOM1) and not (player.prevkeys and player.prevkeys & BT_CUSTOM1)
		
		if (spinpressed or grabpressed) then
			fsm.ChangeState(player, enums.SUPERJUMPCANCEL)
		end
	end
}

fsmstates[enums.SUPERJUMPCANCEL]['npeppino'] = {
	name = "Super Jump Cancel",
	enter = function(self, player)
		player.pvars.forcedstate = nil
		player.mo.state = S_PEPPINO_SUPERJUMPCANCELTRNS
		player.mo.momz = 0
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		if player.mo.state ~= S_PEPPINO_SUPERJUMPCANCELTRNS then
			player.pvars.movespeed = 40*FU
			fsm.ChangeState(player, enums.MACH3)
			player.pvars.forcedstate = S_PEPPINO_SUPERJUMPCANCEL
			player.mo.momz = (4*FU)*P_MobjFlip(player.mo)
		end
	end,
	exit = function(self, player)
	
	end
}