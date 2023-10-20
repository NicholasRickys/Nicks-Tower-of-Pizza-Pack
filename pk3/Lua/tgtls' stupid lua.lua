//where tgtls does the shit idk
freeslot("S_DASHCLOUD","SPR_DSHC","S_SMALLDASHCLOUD","S_CLOUDEFFECT","SPR_CLEF","sfx_pstep")
sfxinfo[sfx_pstep].caption = "Step"

states[S_DASHCLOUD] = {
	sprite = SPR_DSHC,
	frame = A|FF_ANIMATE|FF_PAPERSPRITE,
	tics = 16,
	var1 = 8,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

states[S_SMALLDASHCLOUD] = {
	sprite = SPR_SDSC,
	frame = A|FF_PAPERSPRITE|FF_ANIMATE,
	tics = 10,
	var1 = 5,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

states[S_CLOUDEFFECT] = {
	sprite = SPR_CLEF,
	frame = A|FF_ANIMATE,
	tics = 28,
	var1 = 14,
	var2 = 2,
	nextstate = S_DEATHSTATE
}

--junio sonic moment
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

local function stepframes(p)
	if (p.mo.frame == D or p.mo.frame == I)
		return true
	else
		return false
	end
end

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
	if consoleplayer ~= server then return end
	// attempt to not make resync issues
	
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
					print('stopped '..sound[1])
				end
			end
		end
	end
end)