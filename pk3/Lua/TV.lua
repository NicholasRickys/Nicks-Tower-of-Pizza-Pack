rawset(_G, 'tv', {})

local function changeAnim(self, player, patch_name, ticsps, tics, loop, finishCallback, state_name)
	self.patch_name = patch_name
	self.tic = 1
	self.tics = tics
	self.ticsps = ticsps
	self.loop = loop
	self.finishCallback = finishCallback
	self.statename = state_name
end

local validtvstates = {} // here bc srb2 lua shit be buggin

validtvstates['Standard'] = {
	name = 'IDLE',
	ticsps = 2,
	tics = 81
}
validtvstates['Mach 3'] = {
	name = 'MACH3',
	ticsps = 2,
	tics = 3
}
validtvstates['Mach 4'] = {
	name = 'MACH4',
	ticsps = 2,
	tics = 3
}

tv.AddAnimation = function(player, name, patch_name, ticsps, tics, loop, finishCallback, state_name)
	if (not player.tv_animations) then
		player.tv_animations = {}
		player.tv_animations.anims = {}
	end
	
	local anims = {}
	anims.patch_name = patch_name
	anims.tics = tics
	anims.tic = 1
	anims.ticsps = ticsps
	anims.loop = loop
	anims.index = name
	anims.changeAnim = changeAnim // should be called with : instead of . because of self argument
	anims.statename = state_name
	
	anims.finishCallback = finishCallback
	
	player.tv_animations.anims[name] = anims
end

tv.changeTVState = function(player, statename)
	if not (player.pvars) then return end
	if not (player.tv_animations) then return end
	if not validtvstates[statename] then return end
	if validtvstates[statename].name == player.tv_animations.anims['TV'].patch_name then return end
	if (player.tv_animations.anims['TV'].patch_name == 'TV_OPEN') then return end
	
	if (player.tv_animations.anims['TRANSITION'] or player.pvars.nextsettings) then
		local ns = player.pvars.nextsettings
		player.tv_animations.anims['TV']:changeAnim(player, 'PTV_'..ns.name, ns.tps, ns.tics, true, nil, ns.statename)
		player.tv_animations.anims['TRANSITION'] = nil
		player.pvars.nextsettings = nil
	end
	
	player.pvars.nextsettings = {
		name = validtvstates[statename].name,
		tps = validtvstates[statename].ticsps,
		tics = validtvstates[statename].tics,
		statename = statename
	}
	
	tv.AddAnimation(player, 'TRANSITION', 'TV_WHITENOISE', 2, 5, false, 
	function(self, player, index)
		local ns = player.pvars.nextsettings
		player.tv_animations.anims['TV']:changeAnim(player, 'PTV_'..ns.name, ns.tps, ns.tics, true, nil, ns.statename)
		player.tv_animations.anims['TRANSITION'] = nil
		player.pvars.nextsettings = nil
	end, state)
end


addHook('PlayerThink', function(player)
	if not (player.mo) then player.tv_animations = nil return end
	if not (player.fsm) then player.tv_animations = nil return end
	if not (player.pvars) then player.tv_animations = nil return end
	if (player.mo.skin ~= "npeppino") then player.tv_animations = nil return end
	if (not player.tv_animations) then
		if (leveltime > TICRATE/2) then
			tv.AddAnimation(player, 'TV', 'TV_OPEN', 2, 16, false,
				function(self, player, index)
					self:changeAnim(player, 'PTV_IDLE', 2, 81, true, nil, 'Standard')
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

// POSITION DATA FOR ME TO REMEMBER

// X = 230, Y = -5, SCALE = FU/3