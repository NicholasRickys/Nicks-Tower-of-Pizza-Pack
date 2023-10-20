local PEPPINO_SKIN = 'npeppino'

rawset(_G, "Init", function()
	local t = {}
	
	t.movespeed = 8*FU
	t.forcedstate = nil
	
	return t
end)

local function SpawnParticle(mo, xmod, ymod, type, angle)
	local mobj = P_SpawnMobj(mo.x + xmod, mo.y + ymod, mo.z, type)
	mobj.angle = angle
end

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
// MACH WHEN YOU HIT A ENEMY (ANIMATION PLAYS LOL)

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
	
	if (mo.z > mobj.z+mo.height) then return end
	if (mobj.z > mobj.z+mo.height) then return end
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
		print('did')
	end
end, MT_PLAYER)

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

fsmstates[enums.SKID] = {
	name = "Skid",
	enter = function(self, player)
		player.pvars.forcedstate = S_PEPPINO_MACHSKID
		player.mo.state = S_PEPPINO_MACHSKIDTRNS
		S_StartSound(player.mo, sfx_pskid)
		player.pvars.lastsavedangle = player.drawangle // used so we can force a angle during skidding :DD
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.pflags = $|PF_JUMPSTASIS
		
		player.pvars.movespeed = max(0, $-(FU))
		player.drawangle = player.pvars.lastsavedangle
		P_InstaThrust(player.mo, player.pvars.lastsavedangle, player.pvars.movespeed)

		if (player.pvars.movespeed <= 4*FU) then
			player.mo.momx = 0
			player.mo.momy = 0
			// i messed it up but i can care less i am not waiting that long like that time
			fsm.ChangeState(player, enums.BASE)
			player.pvars.forcedstate = nil
			player.mo.state = S_PEPPINO_MACHSKIDEND
		end
	end,
	exit = function(self, player, state)
		player.pvars.movespeed = 8*FU
		player.pvars.lastsavedangle = nil
	end
}

fsmstates[enums.DRIFT] = {
	name = "Drift",
	// this code is half copied from skidding lmfao
	enter = function(self, player, last_state)
		if (last_state == enums.MACH2)
			player.pvars.forcedstate = S_PEPPINO_MACHDRIFT2
			player.mo.state = S_PEPPINO_MACHDRIFTTRNS2
			player.pvars.drifttime = 11*2
			S_StartSound(player.mo, sfx_pskid)
		else
			player.pvars.forcedstate = S_PEPPINO_MACHDRIFT3
			player.mo.state = S_PEPPINO_MACHDRIFTTRNS3
			player.pvars.drifttime = 13*2
			S_StartSound(player.mo, sfx_drift)
		end
		player.pvars.laststate = last_state // gotta use it to continue the speed where it was left off of
		// if (last_state == enums.MACH4) then player.pvars.laststate = enums.MACH3 end
		
		player.pvars.lastsavedangle = player.drawangle // used so we can force a angle during skidding :DD
	end,
	think = function(self, player)
		if not (player.mo) then return end
		if not (player.pvars or player.playerstate == PST_DEAD) then
			player.pvars = Init()
			if (player.playerstate == PST_DEAD) then
				return
			end
		end
		
		player.pflags = $|PF_JUMPSTASIS
		
		player.pvars.movespeed = max(0, $-(FU))
		P_InstaThrust(player.mo, player.pvars.lastsavedangle, player.pvars.movespeed)
		if (player.pvars.drifttime) then
			player.pvars.drifttime = $-1
		end

		if (not player.pvars.drifttime and P_IsObjectOnGround(player.mo)) then
			player.mo.momx = 0
			player.mo.momy = 0
			// i messed it up but i can care less i am not waiting that long like that time
			fsm.ChangeState(player, player.pvars.laststate)
		end
	end,
	exit = function(self, player, state)
		local tableofspeeds = {}
		
		tableofspeeds[enums.MACH2] = 18*FU
		tableofspeeds[enums.MACH3] = 40*FU
		
		player.pvars.movespeed = tableofspeeds[state]
		player.pvars.lastsavedangle = nil
		player.pvars.laststate = nil
	end
}

fsmstates[enums.GRAB] = {
	name = "Grab",
	enter = function(self, player, state)
		if (player.pvars.movespeed < 23*FU) then
			player.pvars.movespeed = 23*FU
		end
		player.pvars.laststate = state
		if laststate == enums.MACH1 then
			player.pvars.laststate = enums.MACH2
		end
		player.pvars.grabtime = 14*2
		
		player.pvars.forcedstate = S_PEPPINO_SUPLEXDASH
		player.pvars.cancelledgrab = false
	end,
	think = function(self, player)
		if (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid)) then
			P_InstaThrust(player.mo, player.drawangle, player.pvars.movespeed)
			
			if (player.pvars.grabtime) then
				player.pvars.grabtime = $-1
			else
				fsm.ChangeState(player, player.pvars.laststate)
			end
		else
			fsm.ChangeState(player, enums.BASE_GRABBEDENEMY)
			player.pvars.cancelledgrab = true
		end
	end,
	exit = function(self, player, state)
		if state ~= enums.MACH2 and state ~= enums.MACH3 and not (player.cmd.buttons & BT_SPIN) and not player.pvars.cancelledgrab then player.pvars.movespeed = 8*FU end
		if (player.pvars.cancelledgrab) then
			player.pvars.movespeed = 8*FU
		end
		player.pvars.cancelledgrab = false
	end
}

fsmstates[enums.GRAB_KILLENEMY] = {
	name = "Kill Enemy",
	enter = function(self, player, state)
		player.pvars.killtime = 10*2
		player.pvars.killed = false
		player.pvars.forcedstate = L_Choose(S_PEPPINO_FINISHINGBLOW1, S_PEPPINO_FINISHINGBLOW2, S_PEPPINO_FINISHINGBLOW3, S_PEPPINO_FINISHINGBLOW4, S_PEPPINO_FINISHINGBLOW5)
	end,
	think = function(self, player)
		if (player.pvars.killtime) then
			player.pvars.killtime = $-1
		else
			fsm.ChangeState(player, enums.BASE)
			return
		end
		
		if (player.pvars.killtime <= 10 and not player.pvars.killed) then
			P_KillMobj(player.pvars.grabbedenemy, player.mo, player.mo)
			player.pvars.killed = true
		end
	end,
	exit = function(self, player, state)
		player.pvars.killed = nil
	end
}

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
	
	if player.pvars.killed == nil then
		P_MoveOrigin(mobj, mo.x, mo.y, mo.z+mo.height+(2*FU))
	else
		//readable now
		P_MoveOrigin(mobj,
			mo.x+((mo.radius/FU)*cos(angle)),
			mo.y+((mo.radius/FU)*sin(angle)),
			mo.z+(mo.height/2)
		)
	end
	mobj.momx = 0
	mobj.momy = 0
	mobj.momz = 0
	mobj.angle = angle
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
		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) then
			player.pvars.grabbedenemy = SpawnGrabbedObject(mobj,player.mo)
			return false
		end

		return false
	end
	if (player.fsm.state == enums.BASE_GRABBEDENEMY and (not player.pvars.killtime and (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) and player.pvars.grabbedenemy == mobj))) then
		return false
	end
end)