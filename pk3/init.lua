rawset(_G, 'NTOPP_V2', {})

rawset(_G, 'L_Choose', function(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end)

dofile('Key Handler.lua')
dofile('Freeslot.lua')
dofile('Enums.lua')
dofile('TV.lua')

dofile('FSM.lua')
dofile('State Manager.lua')
dofile("tgtls' stupid lua")