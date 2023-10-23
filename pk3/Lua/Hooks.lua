addHook('PlayerThink', function(player)
	if not (player.mo) then player.tv_animations = nil return end
	if not (player.fsm) then player.tv_animations = nil return end
	if not (player.pvars) then player.tv_animations = nil return end
	if (player.mo.skin ~= "npeppino") then player.tv_animations = nil return end
	if (not player.tv_animations) then
		if (leveltime > TICRATE/2) then
			tv.AddAnimation(player, 'TV', 'TV_OPEN', 2, 16, false,
				function(self, player, index)
					changeAnim(self, player, 'PTV_IDLE', 2, 81, true, nil, 'Standard')
				end, 'Standard')
		else return end
	end
	for _,self in pairs(player.tv_animations.anims)
		if (leveltime % self.ticsps) then continue end
		if (self.tic < self.tics)
			self.tic = $+1
		elseif (self.loop)
			self.tic = 1
		elseif (self.finishCallback)
			self:finishCallback(player, _)
		end
	end
end)

addHook('MapChange', function()
	for player in players.iterate
		player.tv_animations = nil
	end
end)

addHook('HUD', function(v, player, camera)
	if (not player.tv_animations) then return end
	if (player.tv_animations.anims['TV']) then
		v.drawScaled(230*FU, -10*FU, FU/3, v.cachePatch('TV_BG'), V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
		local patch = v.cachePatch(player.tv_animations.anims['TV'].patch_name..player.tv_animations.anims['TV'].tic)
		v.drawScaled(230*FU, -10*FU, FU/3, patch,V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
	end
	
	if (player.tv_animations.anims['TRANSITION']) then
		local patch = v.cachePatch(player.tv_animations.anims['TRANSITION'].patch_name..player.tv_animations.anims['TRANSITION'].tic)
		v.drawScaled(230*FU, -10*FU, FU/3, patch, V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER|V_HUDTRANS)
	end
end)

addHook('PlayerThink', function(player)
	if not (player.mo and player.mo.skin == "npeppino") then
		player.fsm = nil
		player.pvars = nil
		player.laststate = nil
		player.curstate = nil
		return
	end
	if (player.fsm == nil) then
		fsm.Init(player)
	end

	if (player.curstate ~= player.mo.state) then
		player.laststate = player.curstate
		player.curstate = player.mo.state
	end

	if (fsmstates[player.fsm.state]
	and fsmstates[player.fsm.state][player.mo.skin]
	and not fsmstates[player.fsm.state][player.mo.skin].no_code
	and fsmstates[player.fsm.state][player.mo.skin].think) then
		fsmstates[player.fsm.state][player.mo.skin]:think(player)
	end
end)

addHook('PlayerThink', function(player)
	if not (player.mo) then return end
	if not (player.pvars) then return end
	
	if (player.pvars.forcedstate 
	and player.mo.state ~= player.pvars.forcedstate
	and states[player.mo.state].nextstate ~= player.pvars.forcedstate) then
			//phew, thats alotta checks
		player.mo.state = player.pvars.forcedstate // useful to force animations
	end
end)

addHook('PlayerCanEnterSpinGaps', function(player)
	return true
end)

// MAKING SPRINGS AT AS BOOSTER PADS

local horizontal_springs = {
	MT_YELLOWDIAG,
	MT_REDDIAG,
	MT_BLUEDIAG,
	MT_YELLOWHORIZ,
	MT_REDHORIZ,
	MT_BLUEHORIZ,
	MT_YELLOWBOOSTER,
	MT_REDBOOSTER
}


addHook('MobjMoveCollide', function(mo, mobj)
	local player = mo.player
	if (not player.mo) then return end
	if not (mobj) then return end
	if (player.mo.skin ~= 'npeppino') then return end
	if (not player.fsm) then return end
	if (not player.pvars) then return end
	if (not mobj.valid) then return end
	
	if (mo.z > mobj.z+mobj.height) then return end
	if (mobj.z > mo.z+mo.height) then return end
	
	local is_spring = false
	
	for _,i in pairs(horizontal_springs) do
		if mobj.type == i then
			is_spring = true
			break
		end
	end
	
	if (is_spring) then
		if (player.pvars.drawangle ~= nil)
			player.pvars.drawangle = mobj.angle
			player.drawangle = mobj.angle
		end
		if (player.pvars.movespeed < 40*FU) then
			player.pvars.movespeed = 40*FU
			if (player.fsm.state ~= enums.MACH3) then
				fsm.ChangeState(player, enums.MACH3)
			end
		else
			player.pvars.movespeed = $+(2*FU)
		end
		
		player.mo.state = S_PEPPINO_DASHPAD
	end
end, MT_PLAYER)

addHook('MobjMoveCollide', function(mo, mobj)
	if (not mo.player) then return end
	local player = mo.player
	if (not player.mo) then return end
	if not (mobj.valid) then return end
	if (player.mo.skin ~= 'npeppino') then return end
	if (not player.fsm) then return end
	if (not player.pvars) then return end
	
	if (mo.z > mobj.z+mobj.height) then return end
	if (mobj.z > mo.z+mo.height) then return end
	
	if (player.fsm.state ~= enums.GRAB) then return end
	if not (mobj.flags & MF_ENEMY) then return end

	if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid and not player.pvars.grabbedenemy.killed) then
		player.pvars.grabbedenemy = SpawnGrabbedObject(mobj,player.mo)
		return false
	end
end, MT_PLAYER)

addHook('MobjMoveCollide', function(mo, mobj)
	if not (mo.valid) then return end
	if not (mobj.valid) then return end
	if not (mobj.flags & MF_ENEMY) then return end
	if not (mo.killed) then return end
	if (mo.hashitenemy) then return end
	
	if (mo.z > mobj.z+mobj.height) then return end
	if (mobj.z > mo.z+mo.height) then return end
	
	if (mo.target == mobj) then return end
	
	P_KillMobj(mobj, mo.target, mo.target)
	if (mobj.target and mobj.target.valid and mobj.target.player) then
		P_AddPlayerScore(mobj.target.player, 100)
	end
	mo.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP
	mo.momz = 8*FU
	mo.hashitenemy = true
end, MT_GRABBEDMOBJ)

addHook('MobjMoveBlocked', function(mo, mobj)
	if not mo.valid then return end
	if mobj then return end
	P_KillMobj(mo)
end, MT_GRABBEDMOBJ)
// FOR DRIFTING

addHook('PreThinkFrame', do
	for player in players.iterate do
		if not (player.mo) then continue end
		if not (player.cmd) then continue end
		if (player.mo.skin ~= 'npeppino') then continue end
		if not (player.fsm) then continue end
		if not (player.pvars) then continue end
		if (player.fsm.state == enums.MACH3 or player.fsm.state == enums.MACH2) then
			if (P_GetPlayerControlDirection(player) == 2 and P_IsObjectOnGround(player.mo)) then
				fsm.ChangeState(player, enums.DRIFT)
				continue
			end
		end
		
		if (player.fsm.state == enums.GRAB) then
			if (P_GetPlayerControlDirection(player) == 2) then
				player.pvars.cancelledgrab = true
				fsm.ChangeState(player, enums.BASE)
				continue
			end
		end
	end
end)

addHook('MobjDamage', function(target, inflictor, source)
	if not target.player then return end
	if not target.player.mo then return end // check to see if the players mo isnt invalid
	local player = target.player
	
	if player.mo.skin ~= 'npeppino' then return end
	if player.fsm and player.fsm.state == enums.GRAB then
		return true
	end
end)

addHook('MobjThinker', function(mobj)
	if not mobj.valid then return end
	if not mobj.target then return end
	local mo = mobj.target
	if not mo.player then return end
	local angle = mo.player.drawangle
	local player = mo.player
	
	if not mobj.killed then
		local newangle = angle
		if player.pvars.killed == nil then
			P_MoveOrigin(mobj, mo.x, mo.y, mo.z+mo.height+(4*FU))
		else
			//readable now
			newangle = angle + ANGLE_180
			P_MoveOrigin(mobj,
				mo.x+((mo.radius/FU)*cos(angle)),
				mo.y+((mo.radius/FU)*sin(angle)),
				mo.z+(mo.height/2)
			)
		end
		mobj.momx = 0
		mobj.momy = 0
		mobj.momz = 0
		mobj.angle = newangle
	else
		if not (mobj.hashitenemy) then
			mobj.momx = -32*cos(mobj.angle)
			mobj.momy = -32*sin(mobj.angle)
		else
			mobj.momx = -16*cos(mobj.angle)
			mobj.momy = -16*sin(mobj.angle)
		end
		
		mobj.timealive = $+1
		if (mobj.timealive > 10*TICRATE) then
			if (mobj.target and mobj.target.valid and mobj.target.player and not mobj.hashitenemy) then
				P_AddPlayerScore(mobj.target.player, 100)
			end
			P_RemoveMobj(mobj)
		end
	end
end, MT_GRABBEDMOBJ)

addHook('PlayerCanDamage', function(player, mobj)
	if (not player.mo) then return end
	if (not mobj.valid) then return end
	if (player.mo.skin ~= 'npeppino') then return end
	if (not player.fsm) then return end
	if (not player.pvars) then return end
	if (mobj.z > player.mo.z+player.mo.height) then return end
	if (player.mo.z > mobj.z+mobj.height) then return end
	
	if (player.fsm.state == enums.MACH3 and (mobj.flags & MF_ENEMY or mobj.flags & MF_MONITOR)) then
		player.mo.state = S_PEPPINO_MACH3HIT
		return true
	end
	
	if (player.fsm.state == enums.DRIFT and mobj.flags & MF_ENEMY or mobj.flags & MF_MONITOR) then return true end
	if (player.fsm.state == enums.GRAB and mobj.flags & MF_ENEMY and (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) or player.pvars.grabbedenemy == mobj)) then
		return false
	end
	if (player.fsm.state == enums.BASE_GRABBEDENEMY and (not player.pvars.killtime and (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) and player.pvars.grabbedenemy == mobj))) then
		return false
	end
end)

addHook("ThinkFrame", do
	for player in players.iterate
		local mo = player.mo
		if player.playerstate ~= PST_LIVE then continue end
		if P_IsObjectOnGround(mo)
		and (mo.state == S_PEPPINO_MACH3 or mo.state == S_PEPPINO_MACH4)
		and leveltime%10 == 0
			for i = -1, 1, 2
				local ang = i * ANG10
				local factor = FixedMul(4*mo.scale, cos(ang))
				local x = P_ReturnThrustX(mo, player.drawangle + ANGLE_180 + ang, 24*mo.scale)
				local y = P_ReturnThrustY(mo, player.drawangle + ANGLE_180 + ang, 24*mo.scale)
				local dust = P_SpawnMobjFromMobj(mo, x, y, 0, MT_THOK)
				
				dust.scale = mo.scale
				dust.angle = R_PointToAngle2(dust.x, dust.y, mo.x, mo.y)
				dust.state = S_DASHCLOUD
				dust.momx = FixedMul(factor, cos(dust.angle - i*ANGLE_90))
				dust.momy = FixedMul(factor, sin(dust.angle - i*ANGLE_90))
			end
		end
	end
end)

addHook("ThinkFrame", do
	for player in players.iterate
		local mo = player.mo
		if P_IsObjectOnGround(mo)
		and (mo.state == S_PEPPINO_MACH1 or mo.state == S_PEPPINO_MACH2 or mo.state == S_PEPPINO_MACHDRIFT3 or mo.state == S_PEPPINO_MACHDRIFTTRNS3 or mo.state == S_PEPPINO_MACHDRIFT2 or mo.state == S_PEPPINO_MACHDRIFTTRNS2) --I want to die
		and leveltime%10 == 0
			for i = -1, 1, 2
				local ang = i * ANG10
				local factor = FixedMul(4*mo.scale, cos(ang))
				local x = P_ReturnThrustX(mo, player.drawangle + ANGLE_180 + ang, 24*mo.scale)
				local y = P_ReturnThrustY(mo, player.drawangle + ANGLE_180 + ang, 24*mo.scale)
				local dust = P_SpawnMobjFromMobj(mo, x, y, 0, MT_THOK)
				
				dust.scale = mo.scale
				dust.angle = R_PointToAngle2(dust.x, dust.y, mo.x, mo.y)
				dust.state = S_SMALLDASHCLOUD
				dust.momx = FixedMul(factor, cos(dust.angle - i*ANGLE_90))
				dust.momy = FixedMul(factor, sin(dust.angle - i*ANGLE_90))
			end
		end
	end
end)

addHook("ThinkFrame", do
	for p in players.iterate
		if p.pepfootstep == nil
			p.pepfootstep = false
		end
		if p.mo.state == S_PLAY_WALK
		and stepframes(p)
		and P_IsObjectOnGround(p.mo)
		and p.mo.skin == "npeppino"
		and not p.pepfootstep
			p.pepfootstep = true
			local step = P_SpawnMobj(p.mo.x,p.mo.y,p.mo.z,MT_THOK)
			step.state = S_CLOUDEFFECT
			
			S_StartSound(p.mo, sfx_pstep)
		end
		if p.pepfootstep
		and not stepframes(p)
			p.pepfootstep = false
		end
	end
end)

--nick you are doing mach speed sounds
// i know

addHook('ThinkFrame', do
	for player in players.iterate do
		if not player.mo then continue end
		if not player.mo.skin == 'npeppino' then continue end
		if not player.fsm then continue end
		if not player.pvars then continue end
		
		local sound_checks = {}
		sound_checks[S_PEPPINO_MACH1] = {sfx_mach1, function() return (P_IsObjectOnGround(player.mo)) end}
		sound_checks[S_PEPPINO_MACH2] = {sfx_mach2, function() return (P_IsObjectOnGround(player.mo)) end}
		sound_checks[S_PEPPINO_MACH3] = {sfx_mach3, function() return true end}
		sound_checks[S_PEPPINO_MACH4] = {sfx_mach4, function() return true end}
		
		for state,sound in pairs(sound_checks)
			if player.pvars.forcedstate and state == player.pvars.forcedstate then
				if not (S_SoundPlaying(player.mo, sound[1]) and sound[2]()) then
					S_StartSound(player.mo, sound[1])
				elseif not sound[2]() then
					S_StopSoundByID(player.mo, sound[1])
				end
			else
				if (S_SoundPlaying(player.mo, sound[1])) then
					S_StopSoundByID(player.mo, sound[1])
				end
			end
		end
	end
end)