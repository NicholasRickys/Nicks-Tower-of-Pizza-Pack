//// NTOPP ////

rawset(_G, 'ntopp_v2', {})

rawset(_G, 'L_Choose', function(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end)

dofile('Freeslot.lua')
dofile('Afterimages.lua')
dofile('Enums.lua')
dofile('TV.lua')
dofile('Options.lua')
dofile('CVars.lua')
dofile('FSM.lua')
dofile('HUD.lua')

dofile('Hooks.lua')
dofile('Functions.lua')
dofile("therandomluafile.lua")

for _,p in ipairs({'Peppino'}) do
	local path = "States/"..p.."/"
	dofile(path..'Base.lua')

	for i = 1,3 do
		dofile(path.."Machs/"..i..".lua")
	end

	dofile(path.."Skid.lua")
	dofile(path.."Drift.lua")

	dofile(path.."Grab.lua")
	dofile(path.."Grabbed Enemy.lua")
	dofile(path.."Kill Enemy.lua")

	dofile(path.."Crouch.lua")
	dofile(path.."Roll.lua")
	dofile(path..'Dive.lua')
	dofile(path..'Belly Slide.lua')

	dofile(path.."Super Jump.lua")

	dofile(path.."Pain.lua")

	dofile(path.."Wall Climb.lua")

	dofile(path.."Body Slam.lua")
	if p == "Peppino" then
		dofile(path.."Uppercut.lua")
		dofile(path.."Taunt.lua")
		dofile(path.."Grabbed.lua")
		dofile(path.."Parry.lua")
		dofile(path.."Stun.lua")
		dofile(path.."Piledriver.lua")
		dofile(path.."Breakdance.lua")
		dofile(path.."Super Taunt.lua")
	end
end