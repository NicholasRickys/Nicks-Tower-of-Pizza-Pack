fsmstates[ntopp_v2.enums.BELLYSLIDE]['npeppino'] = {
	name = "Belly Slide",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_BELLYSLIDE
		player.pvars.drawangle = player.mo.angle
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
		
		if (player.pvars.drawangle) then
			player.drawangle = player.pvars.drawangle
		end
		
		if not (leveltime % 4) then
			TGTLSGhost(player)
		end
		P_InstaThrust(player.mo, player.drawangle, FixedMul(player.pvars.movespeed, player.mo.scale))
		P_MovePlayer(player)
		
		if not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.DIVE)
			return
		end
		
		if not (player.cmd.buttons & BT_CUSTOM2) and P_IsObjectOnGround(player.mo) and not (player.pvars.slidetime) then
			fsm.ChangeState(player, GetMachSpeedEnum(player.pvars.movespeed))
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
		player.pflags = $ & ~PF_SPINNING
		player.pvars.drawangle = nil
	end
}