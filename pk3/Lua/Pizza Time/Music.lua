local function DecidePizzaTimeMusic()
	if not PTV3_V.hurryup then
		if consoleplayer.ptv3.laps == 2 then
			return consoleplayer.ptv3.tdidomusic
		elseif consoleplayer.ptv3.laps >= 3
			return consoleplayer.ptv3.johnsrevmusic
		end
	else
		return consoleplayer.ptv3.hurryupmusic
	end
	
	return consoleplayer.ptv3.pizzatimemusic
end

addHook("MusicChange", function(old, new)
	local song = "PIZTIM"
	local ispizzatimesong = (new == "PIZTIM"
	or new == "DEAOLI"
	or new == "LAP3LOL"
	or new == "HURRUP"
	or new == "NOISL1"
	or new == "NOISL2"
	or new == "NOISL3")
	
	local waspizzatimesong = (old == "PIZTIM"
	or old == "DEAOLI"
	or old == "LAP3LOL"
	or old == "HURRUP"
	or old == "NOISL1"
	or old == "NOISL2"
	or old == "NOISL3")
	
	if not leveltime then return end
	if not PTV3_V.pizzatime then return end
	
	if new == "PTDECI" and consoleplayer.ptv3 then // decide for us, mod
		return DecidePizzaTimeMusic()
	end
	
	if old == song then return true end
	if new == mapmusname and not waspizzatimesong then return song end
	if not ispizzatimesong and new ~= "_inter" then return true end
end)