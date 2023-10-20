rawset(_G, 'fsm', {})
rawset(_G, 'fsmstates', {})

fsm.Init = function(player)
	player.fsm = {}
	fsm.ChangeState(player, 1)
end

fsm.ChangeState = function(player, state)
	local old_state = fsmstates[player.fsm.state]
	local new_state = fsmstates[state]
	
	if (old_state and not old_state.no_code and old_state.exit) then
		old_state:exit(player, state) // so we can reference the new state upon exit, useful for transitioning n such
	end
	if (new_state and not new_state.no_code and new_state.enter) then
		new_state:enter(player, player.fsm.state)
	end
	
	tv.changeTVState(player, new_state.name)
	
	if (new_state) then
		player.fsm.state = state
		print('Changed state to '..fsmstates[player.fsm.state].name)
	end	
end

addHook('PlayerThink', function(player)
	if (not player.mo
	or (player.mo and player.mo.skin ~= "npeppino"))
		player.fsm = nil
		player.pvars = nil
		player.laststate = nil
		player.curstate = nil
		return
	end
	if (player.fsm == nil) then
		fsm.Init(player)
	end

	if (player.curstate ~= player.mo.state) then
		player.laststate = player.curstate
		player.curstate = player.mo.state
	end

	if (fsmstates[player.fsm.state]
	and not fsmstates[player.fsm.state].no_code
	and fsmstates[player.fsm.state].think) then
		fsmstates[player.fsm.state]:think(player)
	end
end)