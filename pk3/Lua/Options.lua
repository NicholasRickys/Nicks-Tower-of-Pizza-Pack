local setoptions = {
	{
		name = 'Sage Drift',
		desc = 'Drift is in the style of the SAGE 2019 Demo.',
		command = "ntoppv2_sagedrift"
	},
	{
		name = '3D-Ish',
		desc = "...Holy mother of God...",
		command = "ntoppv2_3dish"
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
            local f = V_SNAPTORIGHT|V_SNAPTOTOP|V_10TRANS
            local s = FU
            v.drawScaled(((x-bgp.width*(i-1))-bgoffx)*s,(y+bgoffy)*s,s,bgp,f)
            v.drawScaled(((x-bgp.width*i)-bgoffx)*s,(y+bgoffy)*s,s,bgp,f)
            
            --v.drawScaled(((x-bgp.width*(i-1))-bgoffx)*s,((y+bgp.height)+bgoffy)*s,s,bgp,f)
            --v.drawScaled(((x-bgp.width*i)-bgoffx)*s,((y+bgp.height)+bgoffy)*s,s,bgp,f)
        end
    end
end

addHook('MobjLineCollide', function(mo, line)
	local sector = line.frontsector
	if mo.subsector.sector == sector and line.backsector then
		sector = line.backsector
	end
	
	if sector.special ~= 576 then return end

	if not mo.player.ntoppv2_optionsopen then
		mo.player.ntoppv2_optionsopen = true
	end
end, MT_PLAYER)

addHook('PlayerThink', function(player)
	if not player.ntoppv2_optionsopen then return end
	if not player.savedmove then player.savedmove = {side = player.cmd.sidemove, forward = player.cmd.forwardmove} end
	if (player.cmd.forwardmove > 0 and not (player.savedmove.forward > 0)) then
		print('up')
	elseif (player.cmd.forwardmove < 0 and not (player.savedmove.forward < 0)) then
		print('down')
	end
	
	player.savedmove = {side = player.cmd.sidemove, forward = player.cmd.forwardmove}
end)

addHook('HUD', function(v,p,c)
	if not consoleplayer.ntoppv2_optionsopen then return end
	drawScrollingBG(v,v.cachePatch('OPTIONBG'),FU/3)
	v.drawString(160, 4, 'Options', V_SNAPTOTOP, 'center')
end)