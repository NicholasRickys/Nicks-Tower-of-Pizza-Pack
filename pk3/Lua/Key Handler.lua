local keys = {BT_SPIN, BT_JUMP, BT_CUSTOM1, BT_CUSTOM2}

addHook("PlayerThink", function(p)
	if not p.keysHandler then
		p.keysHandler = {}
		for _,key in pairs(keys)
			p.prevkeys = p.cmd.buttons
		end
	end
end)