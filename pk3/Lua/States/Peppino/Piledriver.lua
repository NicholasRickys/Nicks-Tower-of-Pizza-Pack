fsmstates[ntopp_v2.enums.PILEDRIVER]['npeppino'] = {
	name = "Piledriver",
	enter = function(self,player,state)
		player.pvars.forcedstate = S_PEPPINO_PILEDRIVER
		if state ~= ntopp_v2.enums.BASE_GRABBEDENEMY then
			L_ZLaunch(player.mo, 32*FU)
		end
		player.pvars.killed = false
		player.pvars.piledriver = true
		player.pvars.deb = false
		player.pvars.groundtime = states[S_PEPPINO_PILEDRIVERLAND].tics
		player.powers[pw_strong] = $|STR_SPRING
		S_StartSound(player.mo, sfx_gpstar)
	end,
	think = function(self,player)
		local height = player.mo.eflags & MFE_VERTICALFLIP and player.mo.ceilingz or player.mo.floorz
		local grounded = (player.mo.z == height)
		
		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) then
			player.pvars.grabbedenemy = nil
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
			return
		end
		
		if not grounded then
			player.mo.momz = $-(FU*P_MobjFlip(player.mo))
			if (player.pvars.grabbedenemy.type == MT_PLAYER and not player.pvars.killed) then
				P_MoveOrigin(player.pvars.grabbedenemy, player.mo.x, player.mo.y, player.mo.z)
				player.pvars.grabbedenemy.momx = 0
				player.pvars.grabbedenemy.momy = 0
				player.pvars.grabbedenemy.momz = 0
				player.pvars.grabbedenemy.player.pflags = $|PF_FULLSTASIS
				player.pvars.grabbedenemy.player.powers[pw_carry] = CR_PLAYER
				player.pvars.grabbedenemy.state = S_PLAY_PAIN
			end
			if not (leveltime % 4) then
				TGTLSGhost(player)
			end
		else
			player.pvars.forcedstate = S_PEPPINO_PILEDRIVERLAND
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
			if not player.pvars.deb then
				S_StartSound(player.mo, sfx_grpo)
				player.pvars.deb = true
			end
			if player.pvars.groundtime then player.pvars.groundtime = $-1
			else
				fsm.ChangeState(player, ntopp_v2.enums.BASE)
			end
		end
	end,
	exit = function(self,player)
		if player.pvars and player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid then
			S_StartSound(player.pvars.grabbedenemy, sfx_kenem)
			if player.pvars.grabbedenemy.type ~= MT_PLAYER then
				player.pvars.grabbedenemy.killed = true
				player.pvars.grabbedenemy.hashitenemy = true
				player.pvars.grabbedenemy.momz = 8*FU
				player.pvars.grabbedenemy.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
				P_AddPlayerScore(player, 100)
				IncreaseSuperTauntCount(player)
			else
				player.pvars.grabbedenemy.momx = 0
				player.pvars.grabbedenemy.momy = 0
				L_ZLaunch(player.pvars.grabbedenemy, 32*FU)
				player.pvars.grabbedenemy.player.pflags = $ & ~PF_THOKKED
				player.pvars.grabbedenemy.player.powers[pw_carry] = 0
				player.pvars.grabbedenemy.player.grabbed = false
			end
		end
		if not player.pvars.hassprung then
			player.powers[pw_strong] = $ & ~STR_SPRING
		end
		player.pvars.piledriver = nil
		player.pvars.killed = nil
	end
}