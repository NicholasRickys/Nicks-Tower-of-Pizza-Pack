fsmstates[ntopp_v2.enums.GRAB]['npeppino'] = {
	name = "Grab",
	enter = function(self, player, state)
		if (player.pvars.movespeed < 30*FU) then
			player.pvars.movespeed = 30*FU
		end
		player.pvars.laststate = state
		if laststate == ntopp_v2.enums.MACH1 then
			player.pvars.laststate = ntopp_v2.enums.MACH2
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
			P_InstaThrust(player.mo, player.mo.angle, FixedMul(player.pvars.movespeed, player.mo.scale))
			player.drawangle = player.mo.angle
			
			if not (leveltime % 4) then
				TGTLSGhost(player)
			end
			
			if player.pvars.grabbedenemy and not player.pvars.grabbedenemy.valid then
				fsm.ChangeState(player, ntopp_v2.enums.BASE)
				player.pvars.grabbedenemy = nil
			end
			
			if not P_IsObjectOnGround(player.mo) and player.pvars.groundedgrab then
				player.pvars.groundedgrab = false
			end
			
			if (player.pvars.groundedgrab) then
				if (player.pvars.grabtime) then
					player.pvars.grabtime = $-1
					if (player.cmd.buttons & BT_CUSTOM2) then
						fsm.ChangeState(player, ntopp_v2.enums.BELLYSLIDE)
						return
					end
				else
					if player.pvars.laststate == ntopp_v2.enums.BASE and player.cmd.buttons & BT_SPIN then
						player.pvars.laststate = GetMachSpeedEnum(player.pvars.movespeed)
					end
					fsm.ChangeState(player, player.pvars.laststate)
				end
			else
				if not (player.pvars.wasgrounded) then
					if player.pvars.forcedstate ~= S_PEPPINO_AIRSUPLEXDASH then
						player.pvars.forcedstate = S_PEPPINO_AIRSUPLEXDASH
					end
					
					if P_IsObjectOnGround(player.mo) then
						if (player.cmd.buttons & BT_CUSTOM2) then
							fsm.ChangeState(player, ntopp_v2.enums.BELLYSLIDE)
							return
						end
						if player.pvars.laststate == ntopp_v2.enums.BASE and player.cmd.buttons & BT_SPIN then
							player.pvars.laststate = GetMachSpeedEnum(player.pvars.movespeed)
						end
						fsm.ChangeState(player, player.pvars.laststate)
					end
				else
					if player.pflags & PF_JUMPED then
						fsm.ChangeState(player, ntopp_v2.enums.MACH2)
						player.pvars.forcedstate = S_PEPPINO_LONGJUMP
					else
						player.pvars.wasgrounded = false
					end
				end
			end
		else
			player.pvars.cancelledgrab = true
			local state = (not (player.cmd.buttons & BT_CUSTOM3)) and ntopp_v2.enums.BASE_GRABBEDENEMY or ntopp_v2.enums.PILEDRIVER
			fsm.ChangeState(player, state)
		end
	end,
	exit = function(self, player, state)
		if state ~= ntopp_v2.enums.MACH2 and state ~= ntopp_v2.enums.LONGJUMP and state ~= ntopp_v2.enums.BELLYSLIDE and state ~= ntopp_v2.enums.MACH3 and not (player.cmd.buttons & BT_SPIN) and not player.pvars.cancelledgrab then player.pvars.movespeed = 8*FU end
		if (player.pvars.cancelledgrab) then
			player.pvars.movespeed = 8*FU
			player.mo.momx = 0
			player.mo.momy = 0
		end
		player.pvars.cancelledgrab = nil
	end
}