addHook('MapChange', function()
	PTV3_F.Initialize()
end)

addHook('ThinkFrame', do
	if gametype != GT_PIZZATIMEV3 then return end
	for p in players.iterate do
		if not p.valid then continue end
		if not p.ptv3 then PTV3_F.Initialize_Player(p) end
		
		if p.mo and P_MobjTouchingSectorSpecial(p.mo, 4, 2) then
			PTV3_F.StartPizzaTime(p)
		end
	end
end)