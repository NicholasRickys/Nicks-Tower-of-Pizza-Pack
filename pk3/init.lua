//// PIZZA TIME ////

rawset(_G, "PTV3_V", {})
rawset(_G, "PTV3_F", {})

G_AddGametype({
    name = "Pizza Time",
    identifier = "PIZZATIMEV3",
    typeoflevel = TOL_COOP|TOL_RACE,
    rules = GTR_RESPAWNDELAY|GTR_FRIENDLYFIRE,
    intermissiontype = int_race,
    headercolor = 103,
    description = "pita time vee 3 es the bet."
})

dofile "Pizza Time/Functions"
dofile "Pizza Time/Hooks"
dofile "Pizza Time/Music"
dofile "Pizza Time/HUD"

//// NTOPP ////

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
dofile(path.."Roll.lua")
dofile(path..'Dive.lua')
dofile(path..'Belly Slide.lua')

dofile(path.."Super Jump.lua")

dofile(path.."Pain.lua")

dofile(path.."Wall Climb.lua")

dofile(path.."Body Slam.lua")