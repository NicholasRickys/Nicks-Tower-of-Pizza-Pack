rawset(_G, "Init", function()
	local t = {}
	
	t.movespeed = 8*FU
	t.forcedstate = nil
	
	return t
end)

//code by luigi
//LUIGI BUDD WAS HERE!!
//fix whatever nick was doing
rawset(_G, "SpawnGrabbedObject",function(tm,source)
	if not (tm and tm.valid and source and source.valid) then return end
	local ragdoll = P_SpawnMobjFromMobj(tm,0,0,tm.height,MT_GRABBEDMOBJ)
	tm.tics = -1
	ragdoll.sprite = tm.sprite
	ragdoll.color = tm.color
	ragdoll.angle = source.angle
	ragdoll.frame = tm.frame
	ragdoll.height = tm.height
	ragdoll.radius = tm.radius
	ragdoll.scale = tm.scale
	ragdoll.timealive = 1
	ragdoll.target = source
	ragdoll.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOCLIPTHING
	ragdoll.ragdoll = true
	ragdoll.tics = -1
	P_RemoveMobj(tm)

	return ragdoll
end)

rawset(_G, 'stepframes', function(p)
	if (p.mo.frame == D or p.mo.frame == I)
		return true
	else
		return false
	end
end)