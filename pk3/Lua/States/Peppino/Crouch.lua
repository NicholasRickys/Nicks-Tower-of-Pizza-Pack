//reskinned the grab state cause is easier
//TO DO FOR CODERS: make peppino fit through small gaps

fsmstates[enums.CROUCH]['npeppino'] = {
	name = "Crouch",
	enter = function(self, player)
		if (player.pvars) then
			player.pvars.forcedstate = S_PEPPINO_CROUCH
			player.mo.state = S_PEPPINO_CROUCHTRNS
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

		if (not P_IsObjectOnGround(player.mo)) then
			if (player.pvars.forcedstate ~= S_PEPPINO_CROUCHFALL) then
				player.pvars.forcedstate = S_PEPPINO_CROUCHFALL
				player.mo.state = S_PEPPINO_CROUCHFALLTRNS
				if not (player.pvars.landanim) then
					player.pvars.landanim = true
				end
			end
		else
			local supposedstate = S_PEPPINO_CROUCH
			if (player.mo.momx ~= 0 or player.mo.momy ~= 0) then supposedstate = S_PEPPINO_CROUCHWALK end
			if (player.pvars.forcedstate ~= supposedstate) then
				player.pvars.forcedstate = supposedstate
				
				if (player.pvars.landanim) then
					player.pvars.landanim = false
				end
			end
		end
		
		if not (player.cmd.buttons & BT_CUSTOM2) and P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.BASE)
		end
	end
}