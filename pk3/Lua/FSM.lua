rawset(_G, 'fsm', {})
rawset(_G, 'fsmstates', {})

fsmstates[enums.BASE] = {}
fsmstates[enums.MACH1] = {}
fsmstates[enums.MACH2] = {}
fsmstates[enums.MACH3] = {}
fsmstates[enums.SKID] = {}
fsmstates[enums.DRIFT] = {}
fsmstates[enums.GRAB] = {}
fsmstates[enums.BASE_GRABBEDENEMY] = {}
fsmstates[enums.GRAB_KILLENEMY] = {}
fsmstates[enums.LONGJUMP] = {}
fsmstates[enums.CROUCH] = {}
fsmstates[enums.ROLL] = {}
fsmstates[enums.DIVE] = {}
fsmstates[enums.BELLYSLIDE] = {}
fsmstates[enums.SUPERJUMPSTART] = {}
fsmstates[enums.SUPERJUMP] = {}
fsmstates[enums.SUPERJUMPCANCEL] = {}
fsmstates[enums.PAIN] = {}
fsmstates[enums.WALLCLIMB] = {}
fsmstates[enums.BODYSLAM] = {}

fsm.Init = function(player)
	player.fsm = {}
	player.fsm.state = 1
	fsm.ChangeState(player, 1)
end

fsm.ChangeState = function(player, state)
	if not (player.mo) then return end
	local old_state = fsmstates[player.fsm.state] and fsmstates[player.fsm.state][player.mo.skin]
	local new_state = fsmstates[state] and fsmstates[state][player.mo.skin]
	
	if (old_state and not old_state.no_code and old_state.exit) then
		old_state:exit(player, state) // so we can reference the new state upon exit, useful for transitioning n such
	end
	if (new_state and not new_state.no_code and new_state.enter) then
		new_state:enter(player, player.fsm.state)
	end
	
	if (new_state)
		tv.changeTVState(player, new_state.name)
	end
	
	if (new_state) then
		player.fsm.state = state
		// print(fsmstates[state][player.mo.skin].name)
	end	
end