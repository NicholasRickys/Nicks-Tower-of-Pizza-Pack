local function DecidePizzaTimeMusic()
	if consoleplayer.ptv3 then
		if not PTV3_V.hurryup then
			if consoleplayer.ptv3.laps == 2 then
				return "DEAOLI"
			elseif consoleplayer.ptv3.laps >= 3
				return "LAP3LO"
			end
		else
			return "HURRUP"
		end
	end
	
	return "PIZTIM"
end

addHook("MusicChange", function(old, new)
	local song = "PIZTIM"
	if not PTV3_V.pizzatime then return end
	
	if new == "PTDECI" then // decide for us, mod
		return DecidePizzaTimeMusic()
	end
	
	if old == song then return true end
	if new == mapmusname then return song end
end)