freeslot("SKINCOLOR_AFTERIMAGERED","SKINCOLOR_AFTERIMAGEGREEN")

skincolors[SKINCOLOR_AFTERIMAGERED] = {
    name = "After Image Red",
    ramp = {35,35,35,35,35,35,35,35,35,35,35,41,41,41,41,41},
    invcolor = SKINCOLOR_RED,
    invshade = 9,
    chatcolor = V_REDMAP,
    accessible = true
}

skincolors[SKINCOLOR_AFTERIMAGEGREEN] = {
    name = "After Image Green",
    ramp = {100,100,100,100,100,100,100,100,100,100,100,191,191,191,191,191},
    invcolor = SKINCOLOR_GREEN,
    invshade = 9,
    chatcolor = V_GREENMAP,
    accessible = true
}

rawset(_G, "TGTLSGhost", function(p)
	local afti = P_SpawnGhostMobj(p.mo)
	// afti.colorized = true
	afti.fuse = 8
	afti.tics = 8
	afti.color = p.mo.color
	afti.frame = TR_TRANS30|p.mo.frame
	if p.mo.frame & FF_PAPERSPRITE then
		afti.frame = $|FF_PAPERSPRITE
	end
	afti.angle = p.drawangle
	afti.scale = p.mo.scale
	return afti
end)

rawset(_G, "TGTLSAfterImage", function(p)
	local afti = P_SpawnGhostMobj(p.mo)
	afti.colorized = true
	afti.fuse = 999
	afti.tics = 5
	afti.color = leveltime % 16 < 8 and SKINCOLOR_AFTERIMAGERED or SKINCOLOR_AFTERIMAGEGREEN
	afti.frame = TR_TRANS10|p.mo.frame|FF_FULLBRIGHT
	if p.mo.frame & FF_PAPERSPRITE then
		afti.frame = $|FF_PAPERSPRITE
	end
	afti.angle = p.drawangle
	afti.scale = p.mo.scale
	return afti
end)