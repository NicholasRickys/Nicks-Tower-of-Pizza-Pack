fsmstates[enums.MACH3]['npeppino'] = {
	name = "Mach 3",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACH3
		player.pvars.drawangle = player.drawangle
		player.pvars.jumppressed = false
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		if (player.pvars.jumppressed and P_IsObjectOnGround(player.mo) and not (player.cmd.buttons & BT_JUMP)) then
			player.pvars.jumppressed = false
		end
		
		if (P_IsObjectOnGround(player.mo)) then
			player.pvars.mach_jump_deb = false
			if (player.cmd.forwardmove or player.cmd.sidemove) then
				player.pvars.movespeed = $+(FU/12)
			elseif (player.pvars.movespeed > 40*FU)
				player.pvars.movespeed = min(40*FU, $-(FU/12))
			end
			
			if (player.pvars.forcedstate == S_PEPPINO_SUPERJUMPCANCEL) then
				player.pvars.forcedstate = S_PEPPINO_MACH3
			end
		end
		
		if (not P_IsObjectOnGround(player.mo) and player.pflags & PF_JUMPED and player.cmd.buttons & BT_JUMP and not (player.pvars.jumppressed)) then
			player.mo.state = S_PEPPINO_MACH3JUMP
			player.pvars.jumppressed = true
		end
		
		local diff = player.pvars.drawangle - player.drawangle
		local deaccelerating = (P_GetPlayerControlDirection(player) == 2)
		
		if diff >= 4*ANG1 then
			player.drawangle = player.pvars.drawangle - 4*ANG1
		elseif diff <= -8*ANG1 then
			player.drawangle = player.pvars.drawangle + 4*ANG1
		end
		
		player.pvars.drawangle = player.drawangle
		// code for this is by luigi shoutouts to my bro lmfaooooo
		if P_IsObjectOnGround(player.mo) and not (leveltime%10) then
			local p = player
			local me = p.mo //luigi budd is lazy
			
			local dist = -40
			local d1 = P_SpawnMobjFromMobj(me, dist*cos(p.drawangle + ANGLE_45), dist*sin(p.drawangle + ANGLE_45), 0, MT_LINEPARTICLE)
			local d2 = P_SpawnMobjFromMobj(me, dist*cos(p.drawangle - ANGLE_45), dist*sin(p.drawangle - ANGLE_45), 0, MT_LINEPARTICLE)
			d1.angle = R_PointToAngle2(d1.x, d1.y, me.x+me.momx, me.y+me.momy) --- ANG5
			d2.angle = R_PointToAngle2(d2.x, d2.y, me.x+me.momx, me.y+me.momy) --- ANG5
			d1.state = S_INVISIBLE
			d2.state = S_INVISIBLE
		end
		
		P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
		P_MovePlayer(player)
		
		if (player.cmd.buttons & BT_CUSTOM2) and not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.DIVE)
		end
		
		if ((player.cmd.buttons & BT_CUSTOM1 and not (player.prevkeys and player.prevkeys & BT_CUSTOM1))) then
			fsm.ChangeState(player, enums.GRAB)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM3) and P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, enums.SUPERJUMPSTART)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2 and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, enums.ROLL)
		end
		
		if (not (player.cmd.buttons & BT_SPIN) and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, enums.SKID)
		end
		
		/*if (player.pvars.movespeed >= (19*FU)) then
			fsm.ChangeState(player, enums.MACH3)
		end*/
	end,
	exit = function(self, player, state)
		player.pvars.jumppressed = nil
		player.pvars.drawangle = nil
	end
}