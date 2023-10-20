local keys = {BT_SPIN, BT_JUMP, BT_CUSTOM1, BT_CUSTOM2}

addHook("PlayerThink", function(p)
	if not p.keysHandler then
		p.keysHandler = {}
		for _,key in pairs(keys)
			p.keysHandler[key] = {pressed = false, justpressed = false, justreleased = false, time = 0}
		end
	end

	for key,table in pairs(p.keysHandler)
		local pressed = p.cmd.buttons & key
		if p.pflags & PF_STASIS
			pressed = false
		end
		if p.exiting or p.pflags & PF_FINISHED
			pressed = false
		end
		if pressed and table.pressed then
			table.time = $+1
		end
		if not pressed and not table.pressed then
			table.time = $+1
		end
		if pressed and table.justpressed
			if table.time >= 1
				table.justpressed = false
			end
		end
		if not pressed and table.justreleased
			if table.time >= 1
				table.justreleased = false
			end
		end
		if pressed and not table.pressed
			table.pressed = true
			table.justpressed = true
			table.time = 0
		end
		if not pressed and table.pressed then
			table.pressed = false
			table.justreleased = true
			table.time = 0
		end
	end
end)