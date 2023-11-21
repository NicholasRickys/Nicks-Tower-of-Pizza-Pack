

fsmstates[ntopp_v2.enums.BODYSLAM]['npeppino'] = {
	name = "Body Slam",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_BODYSLAM
		player.mo.state = S_PEPPINO_BODYSLAMSTART
		L_ZLaunch(player.mo, 12*FU)
		player.pvars.hitfloor = false
		player.pvars.hitfloor_time = 8
		player.pvars.savedmomz = player.mo.momz
		player.powers[pw_strong] = $|STR_SPRING
		S_StartSound(player.mo, sfx_gpstar)
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		local grounded = false
		local height = player.mo.eflags & MFE_VERTICALFLIP and player.mo.ceilingz-player.mo.height or player.mo.floorz
		local grounded = player.mo.z == height
		if not grounded then L_ZLaunch(player.mo, -FU, true) end
		if not (leveltime % 4) then
			if player.mo.momz*P_MobjFlip(player.mo) < 0 then
				TGTLSAfterImage(player)
			else
				TGTLSGhost(player)
			end
		end
		
		if grounded then
			player.pflags = $|PF_FULLSTASIS
			player.cmd.forwardmove = 0
			player.cmd.sidemove = 0
			
			player.mo.momx = 0
			player.mo.momy = 0
			if not player.pvars.hitfloor then
				player.pvars.hitfloor = true
				
				if player.pvars.forcedstate == S_PEPPINO_BODYSLAM
					player.pvars.forcedstate = S_PEPPINO_BODYSLAMLAND
				else
					player.pvars.forcedstate = S_PEPPINO_DIVEBOMBEND
				end
				
				if player.mo.standingslope then
					
					player.pvars.movespeed = 10*FU
					if player.pvars.savedmomz <= -35*FU then
						player.pvars.movespeed = 40*FU
					end
					
					local ang = 0
					if player.mo.standingslope.zdelta < 0
						ang = ANGLE_180
					end
					
					local drawangle = player.mo.standingslope.xydirection + ang
					player.drawangle = drawangle
					fsm.ChangeState(player, ntopp_v2.enums.ROLL)
				else
					if player.pvars.savedmomz <= -35*FU then
						P_Earthquake(player.mo, player.mo, (400*FU)+(abs(player.pvars.savedmomz)*2))
					end
					S_StartSound(player.mo, sfx_grpo)
				end
			end
			if player.pvars.hitfloor_time then
				player.pvars.hitfloor_time = $-1
			else
				fsm.ChangeState(player, ntopp_v2.enums.BASE)
			end
		else
			player.pvars.savedmomz = player.mo.momz
		end
	end,
	exit = function(self, player)
		if not player.pvars.hassprung then
			player.powers[pw_strong] = $ & ~STR_SPRING
		end
	end
}