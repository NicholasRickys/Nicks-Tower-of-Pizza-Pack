PTV3_F.IsGametype = function()
	return (gametype == GT_PIZZATIMEV3)
end
PTV3_F.Initialize_Player = function(p)
	p.ptv3 = {}
	p.ptv3.laps = 1
	p.ptv3.pizzafacemobj = nil
end
PTV3_F.Initialize = function()
	PTV3_V.pizzatime = false
	PTV3_V.sortedplayers = {}
	
	PTV3_V.beginningsector = nil
	PTV3_V.signpostmobj = nil
	PTV3_V.timer = 300*TICRATE
	PTV3_V.hurryup = false
	for p in players.iterate do
		PTV3_F.Initialize_Player(p)
	end
	
	if PTV3_F.IsGametype() then
		hudinfo[HUD_TIME].x = 160 - 12
		hudinfo[HUD_TIME].y = 200 - 12
		hudinfo[HUD_TIME].f = V_SNAPTOBOTTOM
		
		hudinfo[HUD_MINUTES].x = 160 - 4
		hudinfo[HUD_MINUTES].y = (200 - 12) - 16
		hudinfo[HUD_MINUTES].f = V_SNAPTOTOP
		
		hudinfo[HUD_TIMECOLON].x = 160 - 4
		hudinfo[HUD_TIMECOLON].y = (200 - 12) - 16
		hudinfo[HUD_TIMECOLON].f = V_SNAPTOTOP
		
		hudinfo[HUD_SECONDS].x = (160 - 4) + 24
		hudinfo[HUD_SECONDS].y = (200 - 12) - 16
		hudinfo[HUD_SECONDS].f = V_SNAPTOTOP
		
		hudinfo[HUD_RINGS].y = 26
		hudinfo[HUD_RINGSNUM].y = 26
		hudinfo[HUD_RINGSNUMTICS].y = 26
	else
		hudinfo[HUD_TIME].x = 16
		hudinfo[HUD_TIME].y = 26
		hudinfo[HUD_TIME].f = V_SNAPTOLEFT|V_SNAPTOTOP
		
		hudinfo[HUD_MINUTES].x = 72
		hudinfo[HUD_MINUTES].f = V_SNAPTOLEFT|V_SNAPTOTOP
		
		hudinfo[HUD_TIMECOLON].x = 72
		hudinfo[HUD_TIMECOLON].f = V_SNAPTOLEFT|V_SNAPTOTOP
		
		hudinfo[HUD_SECONDS].x = 96
		hudinfo[HUD_SECONDS].f = V_SNAPTOLEFT|V_SNAPTOTOP
		
		hudinfo[HUD_RINGS].y = 42
		hudinfo[HUD_RINGSNUM].y = 42
		hudinfo[HUD_RINGSNUMTICS].y = 42
	end
end
PTV3_F.Initialize()
PTV3_F.Choose_Pizzaface = function(p)
	local pizzaface_chosen = false
	local players_count = 0
	
	for player in players.iterate do
		if not player.valid then return end
		if not player.mo then return end
		
		players_count = $+1
	end
	
	if players_count < 2 then
		return
	end
	
	while not pizzaface_chosen do
		local pfnum = P_RandomKey(0, #players)
		local pfp = players[pfnum]
		
		if not pfp then continue end
		if not pfp.valid then continue end
		if pfp == p then continue end
		if not pfp.ptv3 then PTV3_F.Initialize_Player(p) end

		pfp.ptv3.pizzaface = true
		pizzaface_chosen = true
		break
	end
end
PTV3_F.StartPizzaTime = function(p)
	if PTV3_V.pizzatime then return end
	
	PTV3_F.Choose_Pizzaface(p)
	PTV3_V.pizzatime = true
	S_ChangeMusic("PTDECI", true)
end
PTV3_F.StartNewLap = function(p)
	if not PTV3_V.pizzatime then return end
	
	p.ptv3.laps = $+1
	p.ptv3.canlap = false
	local sec = PTV3_V.endcoords
	if not sec then print('no sex :(') return end
	P_SetOrigin(p.mo, sec.x, sec.y, sec.z)
	p.mo.angle = sec.a
	PTV3_F.HUD_NewLap()
	S_ChangeMusic('PTDECI', true, p)
end