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
		player.pvars.groundedgrab = P_IsObjectOnGround(player.mo)
		player.pvars.wasgrounded = P_IsObjectOnGround(player.mo)
		
		player.pvars.forcedstate = (player.pvars.groundedgrab and S_PEPPINO_SUPLEXDASH)
		player.pvars.cancelledgrab = false
		
		S_StartSound(player.mo, sfx_pgrab)
	end,
	think = function(self, player)
		if (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid and not player.pvars.grabbedenemy.killed)) then
			P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
			
			if not P_IsObjectOnGround(player.mo) and player.pvars.groundedgrab then
				player.pvars.groundedgrab = false
			end
			
			if WallCheckHelper(player) and not P_IsObjectOnGround(player.mo) then
				fsm.ChangeState(player, enums.WALLCLIMB)
				player.pvars.movespeed = 12*FU
				return
			end
			
			if (player.pvars.groundedgrab) then
				if (player.pvars.grabtime) then
					player.pvars.grabtime = $-1
					if (player.cmd.buttons & BT_CUSTOM2) then
						fsm.ChangeState(player, enums.BELLYSLIDE)
						return
					end
				else
					if player.pvars.laststate == enums.BASE and player.cmd.buttons & BT_SPIN then
						player.pvars.laststate = GetMachSpeedEnum(player.pvars.movespeed)
					end
					fsm.ChangeState(player, player.pvars.laststate)
				end
			else
				if not (player.pvars.wasgrounded) then
					if player.pvars.forcedstate ~= S_PEPPINO_AIRSUPLEXDASH then
						player.pvars.forcedstate = S_PEPPINO_AIRSUPLEXDASH
						player.mo.state = S_PEPPINO_AIRSUPLEXDASHTRNS
					end
					
					if P_IsObjectOnGround(player.mo) then
						if (player.cmd.buttons & BT_CUSTOM2) then
							fsm.ChangeState(player, enums.BELLYSLIDE)
							return
						end
						if player.pvars.laststate == enums.BASE and player.cmd.buttons & BT_SPIN then
							player.pvars.laststate = GetMachSpeedEnum(player.pvars.movespeed)
						end
						fsm.ChangeState(player, player.pvars.laststate)
					end
				else
					fsm.ChangeState(player, enums.LONGJUMP)
				end
			end
		else
			player.pvars.cancelledgrab = true
			fsm.ChangeState(player, enums.BASE_GRABBEDENEMY)
		end
	end,
	exit = function(self, player, state)
		if state ~= enums.MACH2 and state ~= enums.LONGJUMP and state ~= enums.BELLYSLIDE and state ~= enums.MACH3 and not (player.cmd.buttons & BT_SPIN) and not player.pvars.cancelledgrab then player.pvars.movespeed = 8*FU end
		if (player.pvars.cancelledgrab) then
			player.pvars.movespeed = 8*FU
			player.mo.momx = 0
			player.mo.momy = 0
		end
		player.pvars.cancelledgrab = nil
	end
}