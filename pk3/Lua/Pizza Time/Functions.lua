// we are gonna reset the variables each time the match is over
// and what does this call for?

PTV3_F.Initialize = function()
	PTV3_V.pizzatime = false
	PTV3_V.sortedplayers = {} // for scoreboard
	// ok so, we need to add the fucking end sector too, so we can like
	// actually check if the players at spawn
	
	PTV3_V.beginningsector = nil
	// from line 52, back to here.
	// why?
	// this!
	for p in players.iterate do
		PTV3_F.Initialize_Player(p)
	end
	// thats why!
	
	
end

PTV3_F.Initialize()

// ya see what i did there? i initialized the function for initalizing variables and ran it, i am so awesome
// this means...
// - no extra lines of code whenever you wanna init
// - some other shit idfk lmfao

// we are also gonna wanna init the player table whenever is called for, what were going to do is...

PTV3_F.Initialize_Player = function(p)
	p.ptv3 = {}
	p.ptv3.laps = 1 // set it to 1, we dont change this when is pizza time
	// thats atleast how i do it, feel free to go about your own way with laps!
	p.ptv3.pizzaface = false
	p.ptv3.pizzafacemobj = nil
	// "why is there a pizzafacemobj var?"
	// we gotta give the players the iconic pizzaface look somehow, don't we?
	// fun fact actually: this first appeared publicly in jisk edition, but jisk actually added it...
	// into pizza time v2 as his own lil update before!
	
	if not PTV3_V.beginningsector and p.mo then
		PTV3_V.beginningsector = p.mo.subsector.sector
	end
	// this is so we can get the players spawn point so we can actually add laps n stuff
end

// now, let's actually get this going

// this function is to choose a pizzaface for when pizza time starts
PTV3_F.Choose_Pizzaface = function(p)
	local pizzaface_chosen = false
	local players_count = 0
	
	for player in players.iterate do
		if not player.valid then return end
		if not player.mo then return end
		
		players_count = $+1
	end
	
	if players_count < 2 then
		// new pizzaface ai shit here
		return
	end
	
	while not pizzaface_chosen do
		local pfnum = P_RandomKey(0, #players)
		// get a random player without iterating through players.iterate
		local pfp = players[pfnum]
		// and to prevent unreadable code, localize pfp as this
		
		if not pfp then continue end
		if not pfp.valid then continue end
		if pfp == p then continue end

		pizzaface_chosen = true
		// save this for whenever we actually need pizzaface to be in the game
		break
	end
end

// this function is to start pizza time, ran when the player hits pillar john.
PTV3_F.StartPizzaTime = function(p)
	if PTV3_V.pizzatime then return end
	
	PTV3_F.Choose_Pizzaface(p)
	PTV3_V.pizzatime = true
	S_ChangeMusic("PIZTIM", true)
end
// from here, head over to hooks
