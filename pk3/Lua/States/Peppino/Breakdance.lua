fsmstates[ntopp_v2.enums.BREAKDANCESTART]['npeppino'] = {
	name = "Breakdance Start",
	enter = function(self,player)
		player.pvars.drawangle = player.drawangle
		player.pvars.forcedstate = S_PEPPINO_BREAKDANCE1
		player.pvars.movespeed = max(20*FU, $)
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		S_StartSound(player.mo, sfx_breda)
		player.pvars.time = TICRATE
	end,
	think = function(self,player)
		if (player.cmd.buttons & BT_FIRENORMAL) and not (player.prevkeys and player.prevkeys & BT_FIRENORMAL) then
			player.pvars.movespeed = 60*FU
			player.pvars.breakdance = true
			fsm.ChangeState(player, ntopp_v2.enums.MACH2)
			player.pvars.forcedstate = S_PEPPINO_BREAKDANCELAUNCH
			L_ZLaunch(player.mo, 4*FU)
			return
		end
		player.pflags = $|PF_FULLSTASIS
		if player.pvars.time then player.pvars.time = $-1 return end
		
		local supposedstate = (player.cmd.buttons & BT_FIRENORMAL) and ntopp_v2.enums.BREAKDANCE or ntopp_v2.enums.BASE
		fsm.ChangeState(player, supposedstate)
	end,
	exit = function(self,player) end
}

fsmstates[ntopp_v2.enums.BREAKDANCE]['npeppino'] = {
	name = "Breakdance",
	enter = function(self,player)
		player.pvars.forcedstate = S_PEPPINO_BREAKDANCE1
		player.pvars.time = TICRATE
	end,
	think = function(self,player)
		if not S_SoundPlaying(player.mo, sfx_brdam) then
			S_StartSound(player.mo, sfx_brdam)
		end
	
		player.pflags = $|PF_JUMPSTASIS
	
		if player.pvars.time then
			player.pvars.time = $-1
		else
			player.pvars.forcedstate = (player.pvars.forcedstate == S_PEPPINO_BREAKDANCE1) 
			and S_PEPPINO_BREAKDANCE2 
			or S_PEPPINO_BREAKDANCE1
			player.pvars.time = 35
		end
	
		if not (player.cmd.buttons & BT_FIRENORMAL) then
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
			return
		end
	end,
	exit = function(self,player)
		S_StopSoundByID(player.mo, sfx_brdam)
	end
}