local option_test = false

local setoptions = {
	{
		name = "Pizza Time",
		desc = "Enables the Pizza Time mechanic in singleplayer.",
		toggle_enabled = function()
			return (not multiplayer)
		end,
		toggle = function()
			ptsp.enabled = not ptsp.enabled
		end,
		enabled = function()
			return ptsp.enabled
		end
	},
	{
		name = "Sage Drift",
		desc = "Enables drifting in the style of the SAGE 2019 Demo.",
		toggle_enabled = function(p)
			return true
		end,
		toggle = function(p)
			if p.ntoppv2_sagedrift == nil then p.ntoppv2_sagedrift = false end
			p.ntoppv2_sagedrift = not p.ntoppv2_sagedrift
		end,
		enabled = function(p)
			return p.ntoppv2_sagedrift
		end
	}
}
local function drawScrollingBG(v,bgp,scale)
    local bgoffx = (leveltime/2)%bgp.width
    local bgoffy = (leveltime/2)%bgp.height
    for i = 0,(v.width()/bgp.width)+2
        for j = 0,(v.height()/bgp.height)+2
            --Complicated
            local x = 300
            local y = bgp.height*(j-1)
            local f = V_SNAPTORIGHT|V_SNAPTOTOP
            local s = FU
            v.drawScaled(((x-bgp.width*(i-1))-bgoffx)*s,(y+bgoffy)*s,s,bgp,f)
            v.drawScaled(((x-bgp.width*i)-bgoffx)*s,(y+bgoffy)*s,s,bgp,f)
            
            --v.drawScaled(((x-bgp.width*(i-1))-bgoffx)*s,((y+bgp.height)+bgoffy)*s,s,bgp,f)
            --v.drawScaled(((x-bgp.width*i)-bgoffx)*s,((y+bgp.height)+bgoffy)*s,s,bgp,f)
        end
    end
end

local function draw_option(v)
	if not consoleplayer then return end
	for i,option in pairs(setoptions) do
		local mult = i-1
		local flags = V_SNAPTOLEFT

		if (consoleplayer.curSel and consoleplayer.curSel ~= i) then
			flags = $|V_TRANSLUCENT|V_GRAYMAP
		end

		v.drawString(8, 40 + (10*mult), option.name..": "..tostring(option.enabled(consoleplayer)), flags, 'left')
	end
end

local function change_option(p, opt)
	if not p.curSel then p.curSel = 1 end
	local clampedOption = max(1, min(p.curSel+opt, #setoptions))
	
	p.curSel = clampedOption
end

local function accept_option(p)
	if not p.curSel then p.curSel = 1 end
	local option = setoptions[p.curSel]
	if not option then return end
	
	if option.toggle_enabled(p) then
		option.toggle(p)
	end
end

addHook('PlayerThink', function(player)
	if player.mo and not isPTSkin(player.mo.skin) then player.ntoppv2_optionsopen = false return end
	local sector = player.mo.subsector.sector
	if sector.special == 576 and not player.ntoppv2_optionsexit and not player.ntoppv2_optionsopen then
		player.ntoppv2_optionsopen = true
		player.ntoppv2_optionsexit = true
	elseif sector.special ~= 576 and player.ntoppv2_optionsexit then
		player.ntoppv2_optionsexit = false
	end
	
	if not player.ntoppv2_optionsopen then return end
	if not player.curSel then player.curSel = 1 end
	if not player.savedmove then player.savedmove = {side = player.cmd.sidemove, forward = player.cmd.forwardmove} end

	player.mo.momx = 0
	player.mo.momy = 0
	player.mo.momz = 0
	if (player.cmd.forwardmove > 0 and not (player.savedmove.forward > 0)) then
		change_option(player, -1)
	elseif (player.cmd.forwardmove < 0 and not (player.savedmove.forward < 0)) then
		change_option(player, 1)
	end
	
	if player.cmd.buttons & BT_JUMP and not (player.prevkeys and player.prevkeys & BT_JUMP) then
		accept_option(player)
	end
	
	if player.cmd.buttons & BT_SPIN and not (player.prevkeys and player.prevkeys & BT_SPIN) then
		player.ntoppv2_optionsopen = false
	end
	player.savedmove = {side = player.cmd.sidemove, forward = player.cmd.forwardmove}
end)

addHook('HUD', function(v,p,c)
	if not consoleplayer.ntoppv2_optionsopen then return end
	drawScrollingBG(v,v.cachePatch('OPTIONBG'),FU/3)
	v.drawString(160, 4, 'Options', V_SNAPTOTOP, 'center')
	draw_option(v)
end)