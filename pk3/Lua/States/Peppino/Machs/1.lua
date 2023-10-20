fsmstates[enums.MACH1]['npeppino'] = {
	name = "Mach 1",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACH1
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		if (P_IsObjectOnGround(player.mo)) then
			player.pvars.movespeed = $+(FU/3)
			if (not player.pvars.forcedstate)
				player.pvars.forcedstate = S_PEPPINO_MACH1
			end
		elseif (player.pvars.forcedstate)
			player.pvars.forcedstate = nil
			player.mo.state = S_PEPPINO_SECONDJUMPTRNS
		end
		
		if P_IsObjectOnGround(player.mo) and not (leveltime%2) then
			local p = player
			local me = p.mo //luigi budd is lazy
			
			local dist = -20
			local d1 = P_SpawnMobjFromMobj(me, dist*cos(p.drawangle + ANGLE_45), dist*sin(p.drawangle + ANGLE_45), 0, MT_LINEPARTICLE)
			local d2 = P_SpawnMobjFromMobj(me, dist*cos(p.drawangle - ANGLE_45), dist*sin(p.drawangle - ANGLE_45), 0, MT_LINEPARTICLE)
			
			d1.state = S_INVISIBLE
			d2.state = S_INVISIBLE
			
			d1.angle = p.drawangle
			d2.angle = p.drawangle
		end
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		P_MovePlayer(player)
		
		if (not (player.keysHandler[BT_SPIN].pressed) and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, enums.BASE)
		end
		
		if (player.pvars.movespeed >= (18*FU)) then
			fsm.ChangeState(player, enums.MACH2)
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
	end
}