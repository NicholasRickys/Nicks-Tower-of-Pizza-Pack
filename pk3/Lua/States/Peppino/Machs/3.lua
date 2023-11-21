local function IsMach4(speed)
	return (speed >= 60*FU)
end

local function NerfAbility()
	return (ntopp_v2.NERFED_PEPPINO_IN_OTHER.value 
	and (gametyperules & GTR_RACE or G_RingSlingerGametype()))
	or (ntopp_v2.NERFED_PEPPINO_IN_COOP.value
	and G_CoopGametype())
end

fsmstates[ntopp_v2.enums.MACH3]['npeppino'] = {
	name = "Mach 3",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACH3
		player.pvars.drawangle = player.drawangle
		player.pvars.jumppressed = P_IsObjectOnGround(player.mo)
		player.charflags = $|SF_RUNONWATER|SF_CANBUSTWALLS
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		if IsMach4(player.pvars.movespeed) then
			player.pvars.forcedstate = S_PEPPINO_MACH4
		elseif not (player.pvars.forcedstate == S_PEPPINO_SUPERJUMPCANCEL)
			player.pvars.forcedstate = S_PEPPINO_MACH3
		end
		
		if (player.pvars.jumppressed and P_IsObjectOnGround(player.mo) and not (player.cmd.buttons & BT_JUMP)) then
			player.pvars.jumppressed = false
		end
		
		if (P_IsObjectOnGround(player.mo)) then
			player.pvars.mach_jump_deb = false
			if (player.cmd.forwardmove or player.cmd.sidemove) then
				local add = player.powers[pw_sneakers] and FU + (FU/2) or 0
				if (NerfAbility()) then
					player.pvars.movespeed = min(46*FU, $+(FU/6))
				else
					player.pvars.movespeed = $+(FU/5)+add
				end
			else
				player.pvars.movespeed = max(40*FU, $-(FU/6))
			end
			
			if (player.pvars.forcedstate == S_PEPPINO_SUPERJUMPCANCEL) then
				player.pvars.forcedstate = IsMach4(player.pvars.movespeed) and S_PEPPINO_MACH4 or S_PEPPINO_MACH3
			end
		end
		local supposeddrawangle = player.pvars.drawangle
		if supposeddrawangle == nil then supposeddrawangle = player.drawangle end
		
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
		if not (leveltime % 4) then
			TGTLSAfterImage(player)
		end
		P_InstaThrust(player.mo, player.drawangle, FixedMul(player.pvars.movespeed, player.mo.scale))
		P_MovePlayer(player)
		
		if (player.powers[pw_justlaunched]) then
			fsm.ChangeState(player, ntopp_v2.enums.MACH2)
			player.pvars.forcedstate = S_PEPPINO_SLOPEJUMP
		end
		
		if (player.cmd.buttons & BT_CUSTOM2) and not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.DIVE)
		end
		
		if not (player.gotflag) and ((player.cmd.buttons & BT_CUSTOM1 and not (player.prevkeys and player.prevkeys & BT_CUSTOM1))) then
			if (not P_IsObjectOnGround(player.mo) and player.cmd.buttons & BT_CUSTOM3) then
				fsm.ChangeState(player, ntopp_v2.enums.UPPERCUT)
				return
			end
			fsm.ChangeState(player, ntopp_v2.enums.GRAB)
			return
		end
		
		if not (player.gotflag) and (player.cmd.buttons & BT_CUSTOM3) and P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.SUPERJUMPSTART)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2 and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.ROLL)
		end
		
		if (not (player.cmd.buttons & BT_SPIN) and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.SKID)
		end
		
		if NerfAbility() then return end
		
		if player.pvars.supertauntready and player.cmd.buttons & BT_CUSTOM3 and (player.cmd.buttons & BT_ATTACK) and not (player.prevkeys and player.prevkeys & BT_ATTACK) then
			fsm.ChangeState(player, ntopp_v2.enums.SUPERTAUNT)
			return
		end
		
		if (player.cmd.buttons & BT_ATTACK) and not (player.prevkeys and player.prevkeys & BT_ATTACK) then
			fsm.ChangeState(player, ntopp_v2.enums.TAUNT)
			return
		end
		
		if (player.cmd.buttons & BT_FIRENORMAL) and not (player.prevkeys and player.prevkeys & BT_FIRENORMAL) then
			fsm.ChangeState(player, ntopp_v2.enums.BREAKDANCESTART)
			return
		end
		
		/*if (player.pvars.movespeed >= (19*FU)) then
			fsm.ChangeState(player, ntopp_v2.enums.MACH3)
		end*/
	end,
	exit = function(self, player, state)
		player.pvars.jumppressed = nil
		player.pvars.drawangle = nil
		player.charflags = $ & ~SF_RUNONWATER
		player.charflags = $ & ~SF_CANBUSTWALLS
	end
}