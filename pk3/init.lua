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

dofile('Hooks.lua')
dofile('Functions.lua')

local path = "States/Peppino/"

dofile(path..'Base.lua')

for i = 1,3 do
	dofile(path.."Machs/"..i..".lua")
end

dofile(path.."Skid.lua")
dofile(path.."Drift.lua")

dofile(path.."Grab.lua")
dofile(path.."Grabbed Enemy.lua")
dofile(path.."Kill Enemy.lua")
dofile(path.."Long Jump.lua")
dofile(path.."Crouch.lua")