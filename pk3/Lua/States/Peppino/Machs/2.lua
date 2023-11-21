local function NerfAbility()
	return (ntopp_v2.NERFED_PEPPINO_IN_OTHER.value 
	and (gametyperules & GTR_RACE or G_RingSlingerGametype()))
	or (ntopp_v2.NERFED_PEPPINO_IN_COOP.value
	and G_CoopGametype())
end

fsmstates[ntopp_v2.enums.MACH2]['npeppino'] = {
	name = "Mach 2",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACH2
		player.charflags = $|SF_RUNONWATER
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
			player.pvars.movespeed = $+(FU-(FU/3))+add
			if (not player.pvars.forcedstate or (player.pvars.forcedstate == S_PEPPINO_WALLJUMP or player.pvars.forcedstate == S_PEPPINO_BREAKDANCELAUNCH or player.pvars.forcedstate == S_PEPPINO_LONGJUMP or player.pvars.forcedstate == S_PEPPINO_SLOPEJUMP))
				player.pvars.forcedstate = S_PEPPINO_MACH2
			end
		elseif (player.pvars.forcedstate and player.pvars.forcedstate ~= S_PEPPINO_WALLJUMP and player.pvars.forcedstate ~= S_PEPPINO_BREAKDANCELAUNCH and player.pvars.forcedstate ~= S_PEPPINO_LONGJUMP and player.pvars.forcedstate ~= S_PEPPINO_SLOPEJUMP) then
			player.pvars.forcedstate = nil
			player.mo.state = S_PEPPINO_SECONDJUMP
		end
		
		player.pvars.drawangle = player.drawangle
		if not (leveltime % 4) then
			TGTLSAfterImage(player)
		end
		
		if player.pvars.breakdance and P_IsObjectOnGround(player.mo) then player.pvars.breakdance = nil end
		
		P_InstaThrust(player.mo, player.drawangle, FixedMul(player.pvars.movespeed, player.mo.scale))
		P_MovePlayer(player)
		
		if (not (player.cmd.buttons & BT_SPIN) and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.SKID)
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
		
		if P_IsObjectOnGround(player.mo) and (player.pvars.movespeed >= (40*FU)) then
			fsm.ChangeState(player, ntopp_v2.enums.MACH3)
		end
		
		if NerfAbility() then return end
		if player.pvars.breakdance then return end
		
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
		player.charflags = $ & ~SF_RUNONWATER
	end
}