local function NerfAbility()
	return (ntopp_v2.NERFED_PEPPINO_IN_OTHER.value 
	and (gametyperules & GTR_RACE or G_RingSlingerGametype()))
	or (ntopp_v2.NERFED_PEPPINO_IN_COOP.value
	and G_CoopGametype())
end

fsmstates[ntopp_v2.enums.MACH1]['npeppino'] = {
	name = "Mach 1",
	enter = function(self, player)
		player.pvars.movespeed = max(8*FU, $)
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
			local add = player.powers[pw_sneakers] and FU + (FU/2) or 0
			player.pvars.movespeed = $+(FU/3)+add
			if (not player.pvars.forcedstate)
				player.pvars.forcedstate = S_PEPPINO_MACH1
			end
		elseif (player.pvars.forcedstate)
			player.pvars.forcedstate = nil
			player.mo.state = S_PEPPINO_SECONDJUMP
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
		if not (leveltime % 4) then
			TGTLSAfterImage(player)
		end
		P_InstaThrust(player.mo, player.drawangle, FixedMul(player.pvars.movespeed, player.mo.scale))
		P_MovePlayer(player)
		
		if (not (player.cmd.buttons & BT_SPIN) and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2) and not P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.DIVE)
		end
		
		if not (player.gotflag) and ((player.cmd.buttons & BT_CUSTOM1 and not (player.prevkeys and player.prevkeys & BT_CUSTOM1))) then
			if (player.cmd.buttons & BT_CUSTOM3) then
				fsm.ChangeState(player, ntopp_v2.enums.UPPERCUT)
				return
			end
			fsm.ChangeState(player, ntopp_v2.enums.GRAB)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2 and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.ROLL)
		end
		
		if (player.pvars.movespeed >= (18*FU)) then
			fsm.ChangeState(player, ntopp_v2.enums.MACH2)
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
	end,
	exit = function(self, player, state)
		if (state == ntopp_v2.enums.BASE) then
			player.pvars.movespeed = 8*FU
			if (player.mo) then
				player.mo.momx = 0
				player.mo.momy = 0
			end
		end
	end
}