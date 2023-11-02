local keys = {BT_SPIN, BT_JUMP, BT_CUSTOM1, BT_CUSTOM2}

addHook("PlayerThink", function(p)
	if not p.prevkeys then
		p.prevkeys = p.cmd.buttons
	end
	p.prevkeys = p.cmd.buttons
end)