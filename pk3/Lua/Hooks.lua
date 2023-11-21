

local function CheckAndCrumble(mo, sec)
	if not mo.player.fsm then return end
	if mo.player.fsm.state ~= ntopp_v2.enums.BODYSLAM and mo.player.fsm.state ~= ntopp_v2.enums.PILEDRIVER then return end
	if mo.momz > 0 then return end
	for fof in sec.ffloors()
		if not (fof.flags & FF_EXISTS) continue end -- Does it exist?
		if not (fof.flags & FF_BUSTUP) continue end -- Is it bustable?

		if (mo.z+mo.momz) + mo.height < fof.bottomheight continue end -- Are we too low?
		if (mo.z+mo.momz) > fof.topheight continue end -- Are we too high?

		-- Check for whatever else you may want to    

		EV_CrumbleChain(fof) -- Crumble
	end
end

addHook('HUD', function(v,p,c)
	if not p.mo then return end
	if not isPTSkin(p.mo.skin) then return end
	
	v.drawString(160, 4, 'https://discord.gg/hf2wk4CCm2', V_SNAPTOTOP|V_TRANSLUCENT|V_ALLOWLOWERCASE, 'thin-center')
end)

addHook("PlayerThink", function(p)
  if not p.mo return end
  if not isPTSkin(p.mo.skin) then return end

  CheckAndCrumble(p.mo, p.mo.subsector.sector)
end)

addHook("MobjLineCollide", function(mo, line)
  if not mo.player return end
  if not isPTSkin(mo.skin) then return end

  for _, sec in ipairs({line.frontsector, line.backsector})
    CheckAndCrumble(mo, sec)
  end
end, MT_PLAYER)

addHook('MapChange', function()
	for player in players.iterate
		if player.grabbed then
			player.grabbed = false
		end
		player.tv_animations = nil
	end
end)

local savedkeys = nil
addHook('PlayerCmd', function(player, cmd)
	if not player.mo then savedkeys = nil return end
	if not isPTSkin(player.mo.skin) then savedkeys = nil return end
	if not player.fsm then savedkeys = nil return end
	
	if (player.fsm.state == ntopp_v2.enums.BASE
	or player.fsm.state == ntopp_v2.enums.MACH1
	or player.fsm.state == ntopp_v2.enums.MACH2
	or player.fsm.state == ntopp_v2.enums.MACH3
	or player.fsm.state == ntopp_v2.enums.WALLCLIMB
	or player.fsm.state == ntopp_v2.enums.GRAB
	or player.fsm.state == ntopp_v2.enums.LONGJUMP) then
		if ntopp_v2.HOLD_TO_WALK.value then
			if (cmd.sidemove or cmd.forwardmove) and not (cmd.buttons & BT_SPIN) then
				cmd.buttons = $|BT_SPIN
			elseif cmd.buttons & BT_SPIN then
				cmd.buttons = $ & ~BT_SPIN
			end
		end
	end
	
	if player.fsm.state == ntopp_v2.enums.TAUNT and not savedkeys and player.playerstate == PST_LIVE then
		savedkeys = {cmd.sidemove, cmd.forwardmove, cmd.buttons}
	elseif (player.fsm.state ~= ntopp_v2.enums.TAUNT and savedkeys) or player.playerstate ~= PST_LIVE then
		savedkeys = nil
	end
	
	if savedkeys then
		cmd.sidemove = savedkeys[1]
		cmd.forwardmove = savedkeys[2]
		cmd.buttons = savedkeys[3]
	end
end)

addHook('ThinkFrame', function()
	for player in players.iterate do
		if not (player.mo and isPTSkin(player.mo.skin)) then
			if (player.fsm or player.pvars or player.laststate or player.curstate or player.prevkeys) then
				player.fsm = nil
				if player.pvars and player.pvars.grabbedenemy then
					if player.pvars.grabbedenemy.valid and player.pvars.grabbedenemy.type ~= MT_PLAYER then
						P_KillMobj(player.pvars.grabbedenemy, player.mo, player.mo)
					end
					
					player.pvars.grabbedenemy = nil
				end
				if player.mo and player.ntoppv2_3dish then
					player.mo.frame = $ & ~FF_PAPERSPRITE
					player.ntoppv2_3dish = false
				end
				player.pvars = nil
				player.laststate = nil
				player.curstate = nil
				player.prevkeys = nil
			end
			continue
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
		and fsmstates[player.fsm.state][player.mo.skin].think) then
			fsmstates[player.fsm.state][player.mo.skin]:think(player)
		end
		
		player.prevkeys = player.cmd.buttons
		
		if player.ntoppv2_3dish then
			player.mo.frame = $|FF_PAPERSPRITE
		end
		
		if (player.pvars.forcedstate 
		and player.mo.state ~= player.pvars.forcedstate
		and states[player.mo.state].nextstate ~= player.pvars.forcedstate) then
				//phew, thats alotta checks
			player.mo.state = player.pvars.forcedstate // useful to force animations
		end
	end
end)

addHook('MobjDeath', function(mo)
	local player = mo.player
	if not (player.valid) then return end
	
	player.grabbed = false
	
	if not (player.fsm) then return end
	
	fsm.ChangeState(player, ntopp_v2.enums.PAIN)
	S_StartSound(player.mo, sfx_eyaow)
end, MT_PLAYER)

addHook('PlayerSpawn', function(player)
	if not (player.valid) then return end
	if not (player.fsm) then return end
	
	if player.powers[pw_carry] then
		player.powers[pw_carry] = 0
	end
	
	fsm.ChangeState(player, ntopp_v2.enums.BASE)
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
	if (not isPTSkin(player.mo.skin)) then return end
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
		player.pvars.drawangle = mobj.angle
		player.drawangle = mobj.angle
		if not (mobj.type == MT_YELLOWDIAG or mobj.type == MT_REDDIAG or mobj.type == MT_BLUEDIAG) then
			if (player.pvars.movespeed < 40*FU) then
				player.pvars.movespeed = 40*FU
				if (player.fsm.state ~= ntopp_v2.enums.MACH3) then
					fsm.ChangeState(player, ntopp_v2.enums.MACH3)
				end
			else
				player.pvars.movespeed = $+(2*FU)
			end
		else
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
		end
	elseif mobj.flags & MF_SPRING and (player.fsm.state == ntopp_v2.enums.BODYSLAM or player.fsm.state == ntopp_v2.enums.PILEDRIVER) then
		player.pvars.hassprung = true
		fsm.ChangeState(player, ntopp_v2.enums.BASE)
	end
	
	if (mobj.type == MT_SPIKE or mobj.type == MT_WALLSPIKE) and (player.fsm.state == ntopp_v2.enums.MACH2 or player.fsm.state == ntopp_v2.enums.MACH3) then
		P_KillMobj(mobj, mo, mo)
	end
end, MT_PLAYER)

local function CanGrabPlayer(player)
	if player.grabbed then return false end
	if player.pvars and player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid then return false end
	if player.ntoppv2_grabable == nil then
		return (CV_FindVar('friendlyfire').value)
	else
		return (player.ntoppv2_grabable)
	end
end

addHook('MobjMoveCollide', function(mo, mobj)
	if (not mo.player) then return end
	local player = mo.player
	if (not player.mo) then return end
	if not (mobj.valid) then return end
	if (not isPTSkin(player.mo.skin)) then return end
	if (not player.fsm) then return end
	if (not player.pvars) then return end
	
	if (mo.z > mobj.z+mobj.height) then return end
	if (mobj.z > mo.z+mo.height) then return end
	
	if (player.fsm.state ~= ntopp_v2.enums.GRAB) then return end
	if (mobj.flags & MF_ENEMY) then
		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid and not player.pvars.grabbedenemy.killed) then
			player.pvars.grabbedenemy = SpawnGrabbedObject(mobj,player.mo)
			return false
		end
	elseif (mobj.type == MT_PLAYER and CanGrabPlayer(mobj.player)) then
		if not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid and not player.pvars.grabbedenemy.killed) then
			if mobj.player.pvars and mobj.player.pvars.grabbedenemy and mobj.player.pvars.grabbedenemy.valid and mobj.player.pvars.grabbedenemy.type == MT_PLAYER then
				mobj.player.pvars.grabbedenemy.player.powers[pw_carry] = 0
				mobj.player.pvars.grabbedenemy.player.grabbed = false
			end
			mobj.player.powers[pw_carry] = CR_PLAYER
			mobj.player.grabbed = true
			player.pvars.grabbedenemy = mobj
			return false
		end
	end
end, MT_PLAYER)

addHook('MobjMoveCollide', function(mo, mobj)
	if (not mo.player) then return end
	local player = mo.player
	if (not player.mo) then return end
	if not (mobj.valid) then return end
	if (not isPTSkin(player.mo.skin)) then return end
	if (not player.fsm) then return end
	if (not player.pvars) then return end
	
	if (mo.z > mobj.z+mobj.height) then return end
	if (mobj.z > mo.z+mo.height) then return end
	
	if (player.fsm.state ~= ntopp_v2.enums.GRAB) then return end
	
	if (mobj.flags & MF_ENEMY) then return end
	if not (mobj.flags & MF_BOSS or mobj.flags & MF_MONITOR) then return end
	
	player.drawangle = R_PointToAngle2(player.mo.x, player.mo.y, mobj.x, mobj.y)
	fsm.ChangeState(player, ntopp_v2.enums.GRABBED)
	P_DamageMobj(mobj, mo, mo)
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
end, MT_GRABBEDMOBJ)

addHook('MobjMoveBlocked', function(mo, mobj)
	if not (mo.valid) then return end
	if mobj and mobj.flags & MF_ENEMY then return end
	if not (mo.killed) then return end
	if (mo.hashitenemy) then return end
	
	P_KillMobj(mo, mo.target, mo.target)
end, MT_GRABBEDMOBJ)

addHook('MobjMoveBlocked', function(mo, mobj, line)
	
	local player = mo.player
	if not player.mo then return end
	
	if not player.fsm then return end
	if not player.pvars then return end
	
	if not line then return end
	
	if player.fsm.state ~= ntopp_v2.enums.MACH1 
	and player.fsm.state ~= ntopp_v2.enums.MACH2 
	and player.fsm.state ~= ntopp_v2.enums.MACH3
	and player.fsm.state ~= ntopp_v2.enums.GRAB
	and player.fsm.state ~= ntopp_v2.enums.LONGJUMP
	and player.fsm.state ~= ntopp_v2.enums.DIVE
	and player.fsm.state ~= ntopp_v2.enums.SKID
	and player.fsm.state ~= ntopp_v2.enums.ROLL
	then return end
	
	if (not P_IsObjectOnGround(mo) and not (player.fsm.state == ntopp_v2.enums.DIVE or player.fsm.state == ntopp_v2.enums.SKID))
	or (P_IsObjectOnGround(mo) and player.mo.standingslope and not (line and line.flags & ML_NOCLIMB)) 
	then return end
	
	local linex,liney = P_ClosestPointOnLine(player.mo.x,player.mo.y,line)
	local lineangle = R_PointToAngle2(player.mo.x,player.mo.y,linex,liney)
	local diff = player.mo.angle - lineangle
	
	if diff <= ANG1*35 and diff >= -ANG1*35 then
		fsm.ChangeState(player, ntopp_v2.enums.STUN)
	end
end, MT_PLAYER)

addHook('MusicChange', function(old, new)
	if new == mapmusname and consoleplayer.ntoppv2_boogie then return 'MVITBY' end
end)

addHook('PlayerMsg', function(player, type, target, msg)
	if type ~= 0 then return end
	
	if not player.mo then return end
	if not isPTSkin(player.mo.skin) then return end
	if not player.fsm then return end
	if not player.pvars then return end
	
	if msg:lower() == 'boogie' then
		S_ChangeMusic('MVITBY', true, player)
		player.ntoppv2_boogie = true
		return true
	end
end)

addHook('MobjMoveBlocked', function(mo, mobj, line)
	local player = mo.player
	if not player.mo then return end
	if not isPTSkin(player.mo.skin) then return end
	if not player.fsm then return end
	if not player.pvars then return end
	
	if line and line.flags & ML_NOCLIMB then return end
	
	if player.fsm.state ~= ntopp_v2.enums.MACH1 
	and player.fsm.state ~= ntopp_v2.enums.MACH2 
	and player.fsm.state ~= ntopp_v2.enums.MACH3
	and player.fsm.state ~= ntopp_v2.enums.GRAB
	and player.fsm.state ~= ntopp_v2.enums.LONGJUMP
	and player.fsm.state ~= ntopp_v2.enums.BREAKDANCELAUNCH
	then return end
	
	if P_IsObjectOnGround(mo) and not player.mo.standingslope then return end
	if P_PlayerInPain(player) or player.playerstate == PST_DEAD then return end
	
	local wallfound = false
	
	player.pvars.mobjblocked = mobj
	wallfound = (WallCheckHelper(player, line))
	
	if not wallfound then return end
	
	local angle = 0
	if line then
		local linex,liney = P_ClosestPointOnLine(player.mo.x,player.mo.y,line)
		angle = R_PointToAngle2(player.mo.x,player.mo.y,linex,liney)
	end
	if mobj then
		angle = R_PointToAngle2(player.mo.x, player.mo.y, mobj.x, mobj.y)
	end
	local diff = player.mo.angle - angle
	if diff <= ANG1*35 and diff >= -ANG1*35 then
		fsm.ChangeState(player, ntopp_v2.enums.WALLCLIMB)
		player.pvars.drawangle = angle
	end
end, MT_PLAYER)

addHook('JumpSpecial', function(player)
	if not player.mo then return end
	if not isPTSkin(player.mo.skin) then return end
	if not player.fsm then return end
	if not P_IsObjectOnGround(player.mo) then return end
	if player.pflags & PF_JUMPDOWN then return end
	if player.pflags & PF_JUMPSTASIS then return end
	
	local p = player
	local me = p.mo //luigi budd is lazy
	
	if player.fsm.state == ntopp_v2.enums.MACH1 
	or player.fsm.state == ntopp_v2.enums.MACH2
	or player.fsm.state == ntopp_v2.enums.MACH3
	or player.fsm.state == ntopp_v2.enums.GRAB then
		local dist = -40
		local d1 = P_SpawnMobjFromMobj(me, dist*cos(p.drawangle + ANGLE_45), dist*sin(p.drawangle + ANGLE_45), 0, MT_LINEPARTICLE)
		local d2 = P_SpawnMobjFromMobj(me, dist*cos(p.drawangle - ANGLE_45), dist*sin(p.drawangle - ANGLE_45), 0, MT_LINEPARTICLE)
		d1.angle = R_PointToAngle2(d1.x, d1.y, me.x+me.momx, me.y+me.momy) --- ANG5
		d2.angle = R_PointToAngle2(d2.x, d2.y, me.x+me.momx, me.y+me.momy) --- ANG5
		d1.state = S_PJUMPDUST
		d2.state = S_PJUMPDUST
	else
		local dust = P_SpawnMobjFromMobj(me, 0,0,0, MT_LINEPARTICLE)
		dust.state = S_PSTNDJUMPDUST
	end
end)

local function CheckHeight(player)
	if not (player.mo) then return end
	if (not isPTSkin(player.mo.skin)) then return end
	if not (player.fsm) then return end
	if not (player.pvars) then return end
	
	if player.fsm.state == ntopp_v2.enums.CROUCH then
		return P_GetPlayerSpinHeight(player)
	end
end

addHook("PlayerHeight", CheckHeight)
addHook("PlayerCanEnterSpinGaps", CheckHeight)

addHook("PlayerCanEnterSpinGaps", function(player)
	
	
	return true
end)

addHook('PreThinkFrame', do
	for player in players.iterate do
		if not (player.mo) then continue end
		if not (player.cmd) then continue end
		if (not isPTSkin(player.mo.skin)) then continue end
		if not (player.fsm) then continue end
		if not (player.pvars) then continue end
		if (player.fsm.state == ntopp_v2.enums.MACH3 
		or player.fsm.state == ntopp_v2.enums.MACH2) then
			if (P_GetPlayerControlDirection(player) == 2 
			and P_IsObjectOnGround(player.mo)) then
				fsm.ChangeState(player, ntopp_v2.enums.DRIFT)
				continue
			end
		end
		
		if (player.fsm.state == ntopp_v2.enums.GRAB) then
			if (P_GetPlayerControlDirection(player) == 2) then
				player.pvars.cancelledgrab = true
				fsm.ChangeState(player, ntopp_v2.enums.BASE)
				continue
			end
		end
		
		if player.pvars.grabbedenemy
		and not (player.pvars.grabbedenemy.valid and player.pvars.grabbedenemy.killed)
		and (player.fsm.state ~= ntopp_v2.enums.BASE_GRABBEDENEMY 
		and player.fsm.state ~= ntopp_v2.enums.GRAB_KILLENEMY 
		and player.fsm.state ~= ntopp_v2.enums.PILEDRIVER) then
			if player.pvars.grabbedenemy.valid and player.pvars.grabbedenemy.type ~= MT_PLAYER then
				P_KillMobj(player.pvars.grabbedenemy, player.mo, player.mo)
			end
			player.pvars.grabbedenemy = nil
		end
		if (player.powers[pw_carry] and player.fsm.state ~= ntopp_v2.enums.BASE) then
			fsm.ChangeState(player, ntopp_v2.enums.BASE)
		end
	end
end)

addHook('MobjDeath', function(target, inf, source)
    if not (target.flags & MF_ENEMY) return end
    if not (target and target.valid and inf and inf.valid and inf.health and inf.player and isPTSkin(inf.skin) and inf.player.fsm and inf.player.pvars) return end
    local player = inf.player
	
	IncreaseSuperTauntCount(player)
end)

local function doPain(player)
	fsm.ChangeState(player, ntopp_v2.enums.PAIN)
	S_StartSound(player.mo, L_Choose(sfx_pain1, sfx_pain2))
end

addHook('MobjDamage', function(target, inflictor, source)
	if not target.player then return end
	local player = target.player
	
	if not isPTSkin(player.mo.skin) then return end
	if not inflictor then doPain(player) return end
	if player.fsm and player.fsm.state == ntopp_v2.enums.GRAB then
		return true
	end
	if inflictor then
		if inflictor and inflictor.valid and player.fsm and player.fsm.state == ntopp_v2.enums.TAUNT then
			local mobj = inflictor
			local speed = FixedHypot(mobj.momx, mobj.momy)/FU
			local downwardsspeed = mobj.momz
			if not (mobj.flags & MF_ENEMY or mobj.flags & MF_BOSS) then
				if mobj.flags & MF_MISSILE then
					mobj.target = player.mo
				else
					mobj.tracer = player.mo
					mobj.target = source
				end
				mobj.momx = -$
				mobj.momy = -$
				mobj.momz = -$
			else
				P_DamageMobj(inflictor, target, target)
			end
			fsm.ChangeState(player, ntopp_v2.enums.PARRY)
			return true
		end
		if player.fsm and (player.fsm.state == ntopp_v2.enums.TAUNT or player.fsm.state == ntopp_v2.enums.PARRY) then
			return true
		end
	end
	doPain(player)
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
			if not player.pvars.piledriver then
				//readable now
				newangle = angle + ANGLE_180
				P_MoveOrigin(mobj,
					mo.x+((mo.radius/FU)*cos(angle)),
					mo.y+((mo.radius/FU)*sin(angle)),
					mo.z+(mo.height/2)
				)
			else
				P_MoveOrigin(mobj,
					mo.x,
					mo.y,
					mo.z
				)
			end
		end
		mobj.momx = 0
		mobj.momy = 0
		mobj.momz = 0
		mobj.angle = newangle
	else
		if not (mobj.hashitenemy) then
			mobj.momx = -64*cos(mobj.angle)
			mobj.momy = -64*sin(mobj.angle)
		else
			mobj.momx = -32*cos(mobj.angle)
			mobj.momy = -32*sin(mobj.angle)
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
	if (not isPTSkin(player.mo.skin)) then return end
	if (not player.fsm) then return end
	if (not player.pvars) then return end
	if (mobj.z > player.mo.z+player.mo.height) then return end
	if (player.mo.z > mobj.z+mobj.height) then return end
	
	if (player.fsm.state == ntopp_v2.enums.MACH3 and (mobj.flags & MF_ENEMY or mobj.flags & MF_MONITOR)) then
		return true
	end
	
	if (player.fsm.state == ntopp_v2.enums.UPPERCUT and (mobj.flags & MF_ENEMY or mobj.flags & MF_MONITOR or mobj.flags & MF_BOSS)) then
		return true
	end
	
	if (player.fsm.state == ntopp_v2.enums.DRIFT and (mobj.flags & MF_ENEMY or mobj.flags & MF_MONITOR)) then return true end
	if (player.fsm.state == ntopp_v2.enums.BREAKDANCELAUNCH and (mobj.flags & MF_ENEMY or mobj.flags & MF_MONITOR)) then return true end
	if (player.fsm.state == ntopp_v2.enums.GRAB and mobj.flags & MF_ENEMY and (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) or player.pvars.grabbedenemy == mobj)) then
		return false
	end
	if (player.fsm.state == ntopp_v2.enums.BASE_GRABBEDENEMY and (not player.pvars.killtime and (not (player.pvars.grabbedenemy and player.pvars.grabbedenemy.valid) and player.pvars.grabbedenemy == mobj))) then
		return false
	end
end)

addHook('ShieldSpecial', function(player)
	if not player.mo then return end
	if not player.fsm then return end
	if not player.pvars then return end
	if player.pflags & PF_THOKKED then return end
	if not isPTSkin(player.mo.skin) then return end
	
	if (player.powers[pw_shield] == SH_WHIRLWIND or player.powers[pw_shield] == SH_ELEMENTAL) then
		fsm.ChangeState(player, ntopp_v2.enums.BASE)
	end
end)

addHook("ThinkFrame", do
	for player in players.iterate
		local mo = player.mo
		if not player.mo then continue end
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
		if not player.mo then continue end
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
		if not p.mo then continue end
		if p.pepfootstep == nil
			p.pepfootstep = false
		end
		if (p.mo.state == S_PLAY_WALK
		or p.mo.state == S_PEPPINO_WALLCLIMB)
		and stepframes(p)
		and P_IsObjectOnGround(p.mo)
		and isPTSkin(p.mo.skin)
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
		if not isPTSkin(player.mo.skin) then continue end
		if not player.fsm then continue end
		if not player.pvars then continue end
		
		local sound_checks = {}
		sound_checks[S_PEPPINO_MACH1] = {sfx_mach1, function() return (P_IsObjectOnGround(player.mo)) end}
		sound_checks[S_PEPPINO_MACH2] = {sfx_mach2, function() return (P_IsObjectOnGround(player.mo)) end}
		sound_checks[S_PEPPINO_WALLCLIMB] = {sfx_mach2, function() return true end}
		sound_checks[S_PEPPINO_MACH3] = {sfx_mach3, function() return true end}
		sound_checks[S_PEPPINO_SUPERJUMPCANCEL] = {sfx_mach3, function() return true end}
		sound_checks[S_PEPPINO_MACH4] = {sfx_mach4, function() return true end}
		sound_checks[S_PEPPINO_BODYSLAM] = {sfx_gploop, function() return not S_SoundPlaying(player.mo, sfx_gpstar) end}
		sound_checks[S_PEPPINO_DIVEBOMB] = {sfx_gploop, function() return not S_SoundPlaying(player.mo, sfx_gpstar) end}
		sound_checks[S_PEPPINO_PILEDRIVER] = {sfx_gploop, function() return not S_SoundPlaying(player.mo, sfx_gpstar) end}
		
		local sound = player.pvars.forcedstate and sound_checks[player.pvars.forcedstate] and sound_checks[player.pvars.forcedstate][1]
		local can = player.pvars.forcedstate and sound_checks[player.pvars.forcedstate] and sound_checks[player.pvars.forcedstate][2]()
		
		if sound and can then
			if not S_SoundPlaying(player.mo, sound) then
				S_StartSound(player.mo, sound)
			end
		elseif not can and sound
			if S_SoundPlaying(player.mo, sound) then
				S_StopSoundByID(player.mo, sound)
			end
		end
		for _,i in pairs(sound_checks)
			if player.pvars.forcedstate == _ then continue end
			if i[1] == sound then continue end
			
			if S_SoundPlaying(player.mo, i[1]) then
				S_StopSoundByID(player.mo, i[1])
			end
		end
	end
end)