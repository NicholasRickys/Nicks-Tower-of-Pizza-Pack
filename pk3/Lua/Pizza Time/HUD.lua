local laptime = 0
local lapy = 0
local can_drawlap = false

PTV3_F.HUD_NewLap = function()
	laptime = 0
	lapy = 0
	can_drawlap = true
end

local function getdawidth(num)
	return (num) * 8
end

local function HUD_FAKETIMER(v,p,c)
	if not PTV3_V.pizzatime then
		hud.enable('time')
		return
	end
	hud.disable('time')
	local minutes = G_TicsToMinutes(PTV3_V.timer)
	local seconds = G_TicsToSeconds(PTV3_V.timer)
	local centiseconds = G_TicsToCentiseconds(PTV3_V.timer)
	
	local time_patch = (leveltime % 2) and v.cachePatch("STTRTIME") or v.cachePatch("STTTIME")
	v.draw(hudinfo[HUD_TIME].x, hudinfo[HUD_TIME].y, time_patch, hudinfo[HUD_TIME].f)
	
	local mindis, secdis = tostring(minutes), tostring(seconds)

		
	//padding
	if (#secdis < 2) then secdis = '0'..$ end
	
	for i = 1,#mindis do
		local iterator = max(0, i-1)
		v.draw(hudinfo[HUD_MINUTES].x - (8 * (#mindis - iterator)), hudinfo[HUD_MINUTES].y, v.cachePatch("STTNUM"..string.sub(mindis, i, i)), hudinfo[HUD_MINUTES].f)
	end
	
	v.draw(hudinfo[HUD_TIMECOLON].x, hudinfo[HUD_TIMECOLON].y, v.cachePatch("STTCOLON"), hudinfo[HUD_TIMECOLON].f)
	
	for i = 1,#secdis do
		local iterator = max(0, i-1)
		v.draw(hudinfo[HUD_SECONDS].x - (8 * (#secdis - iterator)), hudinfo[HUD_SECONDS].y, v.cachePatch("STTNUM"..string.sub(secdis, i, i)), hudinfo[HUD_SECONDS].f)
	end
end

local function THINKER_ITSPIZZATIME(p)
	if not PTV3_V.pizzatime then return end
	local hud = p.ptv3.hud
	if hud.tweentime == nil then
		p.ptv3.hud.tweentime = 0
		return
	end
	p.ptv3.hud.tweentime = $+(FU/(TICRATE*2))
end
local function HUD_ITSPIZZATIME(v,p,c)
	if not p.ptv3 and not p.ptv3.hud then return end
	local hud = p.ptv3.hud
	local time = hud.tweentime or 0
	local tween = ease.outcubic(min(time, FU), (v.height()/v.dupx())*FU, ((v.height()/v.dupx())*FU)/2)
	if time > FU then
		tween = ease.incubic(min(time-FU, FU), ((v.height()/v.dupx())*FU)/2, -8*FU)
	end
	
	v.drawString(160*FU, tween, "It's Pizza Time!", V_SNAPTOTOP, "fixed-center")
end

local function THINKER_HURRYUP(p)
	if not PTV3_V.hurryup then return end
	if not p.ptv3 then return end
	if p.ptv3.hud.hurryuptween == nil then p.ptv3.hud.hurryuptween = 0 end
	p.ptv3.hud.hurryuptween = $+(FU/(TICRATE*2))
end

local function HUD_HURRYUP(v,p,c)
	if not p.ptv3 and not p.ptv3.hud then return end
	local hud = p.ptv3.hud
	local time = hud.hurryuptween or 0
	local tween = ease.outcubic(min(time, FU), (v.height()/v.dupx())*FU, ((v.height()/v.dupx())*FU)/2)
	if time > FU then
		tween = ease.incubic(min(time-FU, FU), ((v.height()/v.dupx())*FU)/2, -8*FU)
	end
	local text = tostring(G_TicsToMinutes(PTV3_V.timer))..":"..tostring(G_TicsToSeconds(PTV3_V.timer)).." left on the clock... HURRY UP!"
	v.drawString(160*FU, tween, text, V_SNAPTOTOP|V_ALLOWLOWERCASE, "fixed-center")
end

local function HUD_LAPS(v,p,c) end
local function HUD_TIMER(v,p,c) end
local function HUD_WTSPLAYERS(v,p,c) end
local function HUD_OBJECTIVES(v,p,c)
	if not PTV3_V.pizzatime then return end
	v.drawString(160, 158, "Objective: we didnt work on them yet", V_SNAPTOBOTTOM, "thin-center")
end

PTV3_F.HudInit = function(p)
	if not p.ptv3 then return end
	
	p.ptv3.hud = {}
	local hud = p.ptv3.hud
end
local function HUD_DRAW(v,p,c)
	HUD_FAKETIMER(v,p,c)
	HUD_ITSPIZZATIME(v,p,c)
	HUD_HURRYUP(v,p,c)
	HUD_OBJECTIVES(v,p,c)
end
local function HUD_THINK(p)
	if not p.ptv3 then return end
	if not p.ptv3.hud then PTV3_F.HudInit(p) end
	
	hudinfo[HUD_TIME].x = 160 - 12
	hudinfo[HUD_TIME].y = 200 - 12
	hudinfo[HUD_TIME].f = V_SNAPTOBOTTOM
	
	hudinfo[HUD_MINUTES].x = 160 - 4
	hudinfo[HUD_MINUTES].y = (200 - 12) - 16
	hudinfo[HUD_MINUTES].f = V_SNAPTOBOTTOM
	
	hudinfo[HUD_TIMECOLON].x = 160 - 4
	hudinfo[HUD_TIMECOLON].y = (200 - 12) - 16
	hudinfo[HUD_TIMECOLON].f = V_SNAPTOBOTTOM
	
	hudinfo[HUD_SECONDS].x = (160 - 4) + 24
	hudinfo[HUD_SECONDS].y = (200 - 12) - 16
	hudinfo[HUD_SECONDS].f = V_SNAPTOBOTTOM
	
	hudinfo[HUD_RINGS].y = 26
	hudinfo[HUD_RINGSNUM].y = 26
	hudinfo[HUD_RINGSNUMTICS].y = 26
	
	THINKER_ITSPIZZATIME(p)
	THINKER_HURRYUP(p)
end

addHook('HUD', HUD_DRAW)
addHook('PlayerThink', HUD_THINK)