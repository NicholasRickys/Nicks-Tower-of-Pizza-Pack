fsmstates[ntopp_v2.enums.BASE_GRABBEDENEMY]['npeppino'] = {
	name = "Grabbed Enemy",
	enter = function(self, player)
		player.mo.momx = 0
		player.mo.momy = 0
		if (player.pvars) then
			player.pvars.forcedstate = S_PEPPINO_HAULINGIDLE
			player.pvars.landanim = false
			player.pvars.killtime = false
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

		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) then
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
		end

		if (player.pvars.grabbedenemy.type == MT_PLAYER) then
			P_MoveOrigin(player.pvars.grabbedenemy, player.mo.x, player.mo.y, player.mo.z+player.mo.height)
			player.pvars.grabbedenemy.momx = 0
			player.pvars.grabbedenemy.momy = 0
			player.pvars.grabbedenemy.momz = 0
			player.pvars.grabbedenemy.player.pflags = $|PF_FULLSTASIS
			player.pvars.grabbedenemy.player.powers[pw_carry] = CR_PLAYER
			player.pvars.grabbedenemy.state = S_PLAY_PAIN
		end

		if (not P_IsObjectOnGround(player.mo)) then
			if (player.pvars.forcedstate ~= S_PEPPINO_HAULINGFALL) then
				player.pvars.forcedstate = S_PEPPINO_HAULINGFALL
				if not (player.pvars.landanim) then
					player.pvars.landanim = true
				end
			end
		else
			local supposedstate = S_PEPPINO_HAULINGIDLE
			if (player.mo.momx ~= 0 or player.mo.momy ~= 0) then supposedstate = S_PEPPINO_HAULINGWALK end
			if (player.pvars.forcedstate ~= supposedstate) then
				player.pvars.forcedstate = supposedstate
				
				if (player.pvars.landanim) then
					if (not (player.cmd.sidemove or player.cmd.forwardmove) and supposedstate == S_PEPPINO_HAULINGIDLE) then
						player.mo.momx,player.mo.momy = 0,0
					end
					player.pvars.landanim = false
				end
			end
		end
		
		local spinpressed = (player.cmd.buttons & BT_SPIN) and not (player.prevkeys and player.prevkeys & BT_SPIN)
		local grabpressed = (player.cmd.buttons & BT_CUSTOM1) and not (player.prevkeys and player.prevkeys & BT_CUSTOM1)
		
		if (player.cmd.buttons & BT_CUSTOM2 and not P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.PILEDRIVER)
		end
		
		if (spinpressed or grabpressed) then
			fsm.ChangeState(player, ntopp_v2.enums.GRAB_KILLENEMY)
		end
	end
}