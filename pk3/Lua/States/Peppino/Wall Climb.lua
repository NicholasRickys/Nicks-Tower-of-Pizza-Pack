fsmstates[enums.WALLCLIMB]['npeppino'] = {
	name = "Wall Climb",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_WALLCLIMB
		local height,angle,fofz,fofheight = WallCheckHelper(player.mo, player.pvars.savedline)
		
		player.pvars.drawangle = angle
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		local atwall = 0
		
		//Finding walls (not FOFs)
		//code from ssnmighty by man553, shoutouts to my bro
		local wall = R_PointInSubsector(player.mo.x+FixedMul(26*FRACUNIT, cos(player.mo.angle)), player.mo.y+FixedMul(26*FRACUNIT, sin(player.mo.angle))).sector
		local fheight = wall.floorheight
		local cheight = wall.ceilingheight

		if wall.f_slope then
			fheight = P_GetZAt(wall.f_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
		end
		if wall.c_slope then
			cheight = P_GetZAt(wall.c_slope, player.mo.x + player.mo.momx, player.mo.y + player.mo.momy)
		end
		
		if (fheight > player.mo.z) or ((cheight <= player.mo.height+player.mo.z) and not (fheight == cheight)/* and (wall.ceilingpic == "F_SKY1")*/) //This last bit seems to be broken...
			atwall = 1
		end
		//FOFs can be walls too, so lets check for those
		for wall in wall.ffloors()
			if (player.mo.z <= wall.topheight) and (player.mo.height+player.mo.z > wall.bottomheight)
				and(wall.flags & FF_BLOCKPLAYER) //Don't want the player to cling to water. That would be stupid
				atwall = $ + 1
			end		
		end
		if(atwall <= 0)
			fsm.ChangeState(player, GetMachSpeedEnum(player.pvars.movespeed))
			player.mo.momz = 0
			return
		end	
		player.drawangle = player.pvars.drawangle
		
		player.pvars.movespeed = $+(FU/3)
		player.mo.momx = 0
		player.mo.momy = 0
		L_ZLaunch(player.mo, player.pvars.movespeed/2)
		P_MovePlayer(player)
		
		if (not (player.cmd.buttons & BT_SPIN)) then
			if not (player.cmd.buttons & BT_JUMP) then
				player.mo.momz = 0
			end
			fsm.ChangeState(player, enums.BASE)
			return
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