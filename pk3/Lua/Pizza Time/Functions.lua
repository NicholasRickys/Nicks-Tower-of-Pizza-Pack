PTV3_F.IsGametype = function()
	return (gametype == GT_PIZZATIMEV3)
end
PTV3_F.PlayerCounter = function()
	local playerstotal = 0
	local playersdead = 0
	local playersalive = 0
	local pizzafacedplayers = 0
	for p in players.iterate do
		if not p.valid then continue end
		if not p.mo then return end
		playerstotal = $+1
		if p.playerstate ~= PST_LIVE then
			playersdead = $+1
		else
			playersalive = $+1
		end
		
		if p.ptv3 and p.ptv3.pizzaface then
			pizzafacedplayers = $+1
		end
	end
	
	return playerstotal,playersdead,playersalive,pizzafacedplayers
end
PTV3_F.RandomPlayer = function(exeception)
	local activeplayers = {}
	for p in players.iterate do
		if not p.valid then return end
		if not p.mo then return end
		if exeception and p == exeception then continue end
		
		table.insert(activeplayers, #p)
	end
	
	local index = P_RandomRange(1, #activeplayers)
	
	if activeplayers[index] ~= nil then return players[activeplayers[index]] end
	return players[activeplayers[1]]
end
PTV3_F.AdjustEscapeMusic = function(p, skin)
	if skin == 'nthe_noise' then
		p.ptv3.pizzatimemusic = 'NOISL1'
		p.ptv3.tdidomusic = 'NOISL2'
		p.ptv3.johnsrevmusic = 'NOISL3'
		return
	end
	
	p.ptv3.pizzatimemusic = "PIZTIM"
	p.ptv3.tdidomusic = "DEAOLI"
	p.ptv3.johnsrevmusic = "LAP3LO"
	p.ptv3.hurryupmusic = "HURRUP"
end
PTV3_F.Initialize_Player = function(p)
	p.ptv3 = {}
	p.ptv3.laps = 1
	p.ptv3.pizzafacemobj = nil
	
	p.ptv3.pizzatimemusic = "PIZTIM"
	p.ptv3.tdidomusic = "DEAOLI"
	p.ptv3.johnsrevmusic = "LAP3LO"
	p.ptv3.hurryupmusic = "HURRUP"
end
PTV3_F.Initialize = function()
	PTV3_V.pizzatime = false
	PTV3_V.sortedplayers = {}
	
	PTV3_V.beginningsector = nil
	PTV3_V.signpostmobj = nil
	PTV3_V.timer = 600*TICRATE
	PTV3_V.hurryup = false
	PTV3_V.maxlaps = PTV3_CV.maxnormallaps.value
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
	local playerstotal,playersdead,playersalive,pizzafacedplayers = PTV3_F.PlayerCounter()
	
	if playerstotal < 2 then
		return
	end
	
	local pfp = PTV3_F.RandomPlayer(p)
	
	if not pfp.ptv3 then PTV3_F.Initialize_Player(pfp) end
	pfp.ptv3.pizzaface = true
	print(pfp.name..' do be pizzaface')
end
PTV3_F.StartPizzaTime = function(p)
	if PTV3_V.pizzatime then return end
	
	PTV3_F.Choose_Pizzaface(p)
	PTV3_V.pizzatime = true
	for p2 in players.iterate do
		if not p2.mo then continue end
		if p == p2 then continue end
		local sec = PTV3_V.endcoords
		if sec then
			P_SetOrigin(p2.mo, sec.x, sec.y, sec.z)
			p2.mo.angle = sec.a
		end
		PTV3_F.AdjustEscapeMusic(p2, p2.mo.skin)
	end
	S_ChangeMusic("PTDECI", true)
end
PTV3_F.StartNewLap = function(p)
	if not PTV3_V.pizzatime then return end
	
	p.ptv3.laps = $+1
	p.ptv3.canlap = false
	p.exiting = 0
	local sec = PTV3_V.endcoords
	if not sec then return end
	P_SetOrigin(p.mo, sec.x, sec.y, sec.z)
	p.mo.angle = sec.a
	PTV3_F.HUD_NewLap()
	PTV3_F.AdjustEscapeMusic(p, p.mo.skin)
	S_ChangeMusic('PTDECI', true, p)
end