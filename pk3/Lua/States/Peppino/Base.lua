local function NerfAbility()
	return (ntopp_v2.NERFED_PEPPINO_IN_OTHER.value 
	and (gametyperules & GTR_RACE or G_RingSlingerGametype()))
	or (ntopp_v2.NERFED_PEPPINO_IN_COOP.value
	and G_CoopGametype())
end

fsmstates[ntopp_v2.enums.BASE]['npeppino'] = {
	name = "Standard",
	enter = function(self, player)
		if (player.pvars) then
			player.pvars.forcedstate = nil
			player.pvars.landanim = P_IsObjectOnGround(player.mo)
			if (player.mo) then
				player.mo.state = S_PLAY_STND // will default to what state it should be
			end
		end
		player.ntoppv2_boogie = false
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars) or player.playerstate == PST_DEAD then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		player.pvars.movespeed = 8*FU
		
		if player.ntoppv2_boogie and P_IsObjectOnGround(player.mo) then
			player.mo.state = S_PEPPINO_BOOGIE
			if player.speed ~= 0 then
				player.panim = PA_WALK
			else
				player.panim = PA_IDLE
			end
		end
		
		if player.pvars.hassprung then
			player.powers[pw_strong] = $ & ~STR_SPRING
			player.pvars.hassprung = nil
		end
		
		if (gametyperules & GTR_RACE and leveltime < 4*TICRATE) then return end
		if (player.pflags & PF_STASIS) then return end
		if (player.exiting) then return end
		if (player.powers[pw_carry]) then return end
		
		if not (player.gotflag) and ((player.cmd.buttons & BT_CUSTOM1 and not (player.prevkeys and player.prevkeys & BT_CUSTOM1))) then
			if (player.cmd.buttons & BT_CUSTOM3) then
				fsm.ChangeState(player, ntopp_v2.enums.UPPERCUT)
				return
			end
			fsm.ChangeState(player, ntopp_v2.enums.GRAB)
			return
		end
		
		if (player.cmd.buttons & BT_SPIN and P_IsObjectOnGround(player.mo)) then
			fsm.ChangeState(player, ntopp_v2.enums.MACH1)
			return
		end
		
		if (player.cmd.buttons & BT_CUSTOM2) and P_IsObjectOnGround(player.mo) then
			fsm.ChangeState(player, ntopp_v2.enums.CROUCH)
			return
		end
		
		if not (player.gotflag) and ((player.cmd.buttons & BT_CUSTOM2) and not (player.prevkeys and player.prevkeys & BT_CUSTOM2)) and not P_IsObjectOnGround(player.mo)
			fsm.ChangeState(player, ntopp_v2.enums.BODYSLAM)
			return
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
		
		if not (NerfAbility()) and (player.cmd.buttons & BT_FIRENORMAL) and not (player.prevkeys and player.prevkeys & BT_FIRENORMAL) then
			fsm.ChangeState(player, ntopp_v2.enums.BREAKDANCESTART)
			return
		end
	end,
	exit = function(self,player)
		local wasboogie = player.ntoppv2_boogie
		player.ntoppv2_boogie = false
		if wasboogie then
			S_ChangeMusic(mapmusname, true, player)
		end
	end
}