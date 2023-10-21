fsmstates[enums.BASE_GRABBEDENEMY]['npeppino'] = {
	name = "Standard",
	enter = function(self, player)
		player.mo.momx = 0
		player.mo.momy = 0
		if (player.pvars) then
			player.pvars.forcedstate = S_PEPPINO_HAULINGIDLE
			player.pvars.landanim = false
			player.pvars.killtime = false
			player.mo.state = S_PEPPINO_HAULINGSTART
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
			fsm.ChangeState(player, enums.BASE)
			return
		end

		if (not P_IsObjectOnGround(player.mo)) then
			if (player.pvars.forcedstate ~= S_PEPPINO_HAULINGFALL) then
				player.pvars.forcedstate = S_PEPPINO_HAULINGFALL
				player.mo.state = S_PEPPINO_HAULINGFALLTRNS
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
						player.mo.state = S_PEPPINO_HAULINGLAND
					end
					player.pvars.landanim = false
				end
			end
		end
		
		if (player.keysHandler[BT_CUSTOM1].justpressed or player.keysHandler[BT_SPIN].justpressed) then
			fsm.ChangeState(player, enums.GRAB_KILLENEMY)
		end
	end
}