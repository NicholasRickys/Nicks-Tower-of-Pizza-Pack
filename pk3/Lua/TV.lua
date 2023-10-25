rawset(_G, 'tv', {})

rawset(_G, "changeAnim", function(self, player, patch_name, ticsps, tics, loop, finishCallback, state_name)
	self.patch_name = patch_name
	self.tic = 1
	self.tics = tics
	self.ticsps = ticsps
	self.loop = loop
	self.finishCallback = finishCallback
	self.statename = state_name
end)

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
validtvstates['Pain'] = {
	name = 'PAIN',
	ticsps = 2,
	tics = 11
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
	anims.statename = state_name
	
	anims.finishCallback = finishCallback
	
	player.tv_animations.anims[name] = anims
end

tv.changeTVState = function(player, newstate)
	if not (player.pvars) then return end
	if not (player.tv_animations) then return end
	local statename = newstate
	if not validtvstates[statename] then statename = "Standard" end
	if 'PTV_'..validtvstates[statename].name == player.tv_animations.anims['TV'].patch_name and not player.tv_animations.anims['TRANSITION'] then return end
	if (player.tv_animations.anims['TV'].patch_name == 'TV_OPEN') then return end
	
	if (player.tv_animations.anims['TRANSITION'] or player.pvars.nextsettings) then
		local ns = player.pvars.nextsettings
		changeAnim(player.tv_animations.anims['TV'], player, 'PTV_'..ns.name, ns.tps, ns.tics, true, nil, ns.statename)
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
		changeAnim(player.tv_animations.anims['TV'], player, 'PTV_'..ns.name, ns.tps, ns.tics, true, nil, ns.statename)
		player.tv_animations.anims['TRANSITION'] = nil
		player.pvars.nextsettings = nil
	end, state)
end

// POSITION DATA FOR ME TO REMEMBER

// X = 230, Y = -5, SCALE = FU/3