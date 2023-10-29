local function DecidePizzaTimeMusic()
	if p.ptv3 then
		if p.ptv3.laps == 2 then
			return "DEADOLI"
		elseif p.ptv3.laps >= 3
			return "LAP3LO"
		end
	end
	
	return "PIZTIM"
end

addHook("MusicChange", function(old, new)
	local song = "PIZTIM"
	if not PTV3_V.pizzatime then return end
	
	if new == "PTDECI" then // decide for us, mod
		song = DecidePizzaTimeMusic()
	end
	
	if new == mapmusname or "PTDECI" then return song end
end)