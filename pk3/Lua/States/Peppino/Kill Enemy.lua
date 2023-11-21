fsmstates[ntopp_v2.enums.GRAB_KILLENEMY]['npeppino'] = {
	name = "Kill Enemy",
	enter = function(self, player, state)
		player.pvars.killtime = 10*2
		player.pvars.killed = false
		player.pvars.forcedstate = L_Choose(S_PEPPINO_FINISHINGBLOW1, S_PEPPINO_FINISHINGBLOW2, S_PEPPINO_FINISHINGBLOW3, S_PEPPINO_FINISHINGBLOW4, S_PEPPINO_FINISHINGBLOW5)
	end,
	think = function(self, player)
		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) then
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
			return
		end
		if (player.pvars.killtime) then
			player.pvars.killtime = $-1
		else
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
			return
		end
		
		player.drawangle = player.mo.angle
		
		if (player.pvars.grabbedenemy.type == MT_PLAYER and not player.pvars.killed) then
			local cosine = 0
			local sine = 0
			P_MoveOrigin(player.pvars.grabbedenemy, player.mo.x+cosine, player.mo.y+sine, player.mo.z)
			player.pvars.grabbedenemy.momx = 0
			player.pvars.grabbedenemy.momy = 0
			player.pvars.grabbedenemy.momz = 0
			player.pvars.grabbedenemy.player.pflags = $|PF_FULLSTASIS
			player.pvars.grabbedenemy.player.powers[pw_carry] = CR_PLAYER
			player.pvars.grabbedenemy.state = S_PLAY_PAIN
		end
		
		if (player.pvars.killtime <= 10 and not player.pvars.killed) then
			if player.pvars.grabbedenemy.type ~= MT_PLAYER then
				player.pvars.grabbedenemy.killed = true
				P_AddPlayerScore(player, 100)
				IncreaseSuperTauntCount(player)
				player.pvars.grabbedenemy.flags = MF_NOCLIPHEIGHT|MF_NOGRAVITY
			else
				P_InstaThrust(player.pvars.grabbedenemy, player.mo.angle, 64*FU)
				player.pvars.grabbedenemy.momz = (8*FU)*P_MobjFlip(player.pvars.grabbedenemy)
				if not player.pepsupertauntcount then
					player.pepsupertauntcount = 0
				end
				player.pepsupertauntcount = $+1
				player.pvars.grabbedenemy.player.powers[pw_carry] = 0
				player.pvars.grabbedenemy.player.grabbed = false
			end
			player.pvars.killed = true
			S_StartSound(player.pvars.grabbedenemy, sfx_kenem)
		end
	end,
	exit = function(self, player, state)
		player.pvars.killed = nil
	end
}