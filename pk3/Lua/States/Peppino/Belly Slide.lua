local function GetRollShit(movespeed)
	if movespeed <= 18*FU then return S_PEPPINO_ROLLGETUP1 end
	if movespeed >= 40*FU then return S_PEPPINO_ROLLGETUP3 end
	
	return S_PEPPINO_ROLLGETUP2
end

fsmstates[enums.BELLYSLIDE]['npeppino'] = {
	name = "Belly Slide",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_BELLYSLIDE
		player.pvars.angle = player.mo.angle
		player.pflags = $|PF_SPINNING
		player.pvars.slidetime = 20
		player.pvars.movespeed = 42*FU
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		player.pflags = $|PF_JUMPSTASIS
		
		if (player.pvars.slidetime) then
			player.pvars.slidetime = $-1
		end
		
		player.drawangle = player.pvars.angle
		
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		P_MovePlayer(player)
		
		if not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.DIVE)
			return
		end
		
		if not (player.cmd.buttons & BT_CUSTOM2) and P_IsObjectOnGround(player.mo) and not (player.pvars.slidetime) then
			fsm.ChangeState(player, GetMachSpeedEnum(player.pvars.movespeed))
			player.mo.state = GetRollShit(player.pvars.movespeed) // LMFAO WE NEED THIS DUE TO TRANSITION SHIT RIP FREESLOT SHIT
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
		player.pflags = $ & ~PF_SPINNING
	end
}