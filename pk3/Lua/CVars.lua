ntopp_v2.NERFED_PEPPINO_IN_COOP = CV_RegisterVar({
	name = "ntoppv2_nerfed_coop",
	defaultvalue = "No",
	flags = CV_NETVAR|CV_SHOWMODIF,
	PossibleValue = CV_YesNo
})

ntopp_v2.NERFED_PEPPINO_IN_OTHER = CV_RegisterVar({
	name = "ntoppv2_nerfed_other",
	defaultvalue = "Yes",
	flags = CV_NETVAR|CV_SHOWMODIF,
	PossibleValue = CV_YesNo
})

local function OnNotPizzaTime()
	for sector in sectors.iterate do
		if sector.special == 7585 then
			sector.special = 8192
		end
	end
end

local function OnPizzaTimeChange(val)
	if not (val.value) then
		OnNotPizzaTime()
		return
	end

	for sector in sectors.iterate do
		if sector.special == 8192 then
			print('mureka')
			sector.special = 0
		end
	end
end

ntopp_v2.PIZZA_TIME_ONLINE = CV_RegisterVar({
	name = "ntoppv2_pizza_time_online",
	defaultvalue = "No",
	flags = CV_NETVAR|CV_SHOWMODIF|CV_CALL,
	PossibleValue = CV_YesNo,
	func = OnPizzaTimeChange
})

ntopp_v2.HOLD_TO_WALK = CV_RegisterVar({
	name = "ntoppv2_hold_to_walk",
	defaultvalue = "No",
	flags = CV_SHOWMODIF|CV_SAVE,
	PossibleValue = CV_YesNo
})

ntopp_v2.COMMAND_GRABME = COM_AddCommand('ntoppv2_grab_me', function(player, yesorno)
	if player.ntoppv2_grabable == nil then player.ntoppv2_grabable = false end
	if not yesorno then
		player.ntoppv2_grabable = not player.ntoppv2_grabable
		CONS_Printf(player, player.ntoppv2_grabable 
			and 'You are now grabbable by other Pizza Tower characters.' 
			or 'You are no longer grabbable by other Pizza Tower characters.')
	else
		local option = string.lower(yesorno)
		if option == 'yes' or option == 'true' or option == 'on' or option == '1' then
			player.ntoppv2_grabable = true
			CONS_Printf(player, 'You are now grabbable by other Pizza Tower characters.')
			return
		end
		if option == 'no' or option == 'false' or option == 'off' or option == '-1' then
			player.ntoppv2_grabable = false
			CONS_Printf(player, 'You are no longer grabbable by other Pizza Tower characters.')
			return
		end
		if option == 'decide' or option == 'nil' or option == '0' then
			player.ntoppv2_grabable = nil
			CONS_Printf(player, 'The friendlyfire command decides whether if you are grabbable by other Pizza Tower chars.')
			return
		end
		player.ntoppv2_grabable = not player.ntoppv2_grabable
		CONS_Printf(player, player.ntoppv2_grabable 
			and 'You are now grabbable by other Pizza Tower characters.' 
			or 'You are no longer grabbable by other Pizza Tower characters.')
	end
end)

ntopp_v2.COMMAND_3DISH = COM_AddCommand('ntoppv2_3dish', function(player, yesorno)
	if not (player.mo and isPTSkin(player.mo.skin)) then CONS_Printf(player, 'You must be a Pizza Tower character for this to work.') return end
	if player.ntoppv2_3dish == nil then player.ntoppv2_3dish = false end
	
	local yestext = 'You are now 3D...Ish.'
	local notext = "You are no longer 3D...Ish."
	
	if not yesorno then
		player.ntoppv2_3dish = not player.ntoppv2_3dish
		CONS_Printf(player, player.ntoppv2_3dish
			and yestext
			or notext)
	else
		local option = string.lower(yesorno)
		if option == 'yes' or option == 'true' or option == 'on' or option == '1' then
			player.ntoppv2_3dish = true
			CONS_Printf(player, yestext)
			return
		end
		if option == 'no' or option == 'false' or option == 'off' or option == '0' then
			player.ntoppv2_3dish = false
			CONS_Printf(player, notext)
			return
		end
		player.ntoppv2_3dish = not player.ntoppv2_3dish
		CONS_Printf(player, player.ntoppv2_3dish
			and yestext
			or notext)
	end
end)

ntopp_v2.COMMAND_3DISH = COM_AddCommand('ntoppv2_sagedrift', function(player, yesorno)
	if not (player.mo and isPTSkin(player.mo.skin)) then CONS_Printf(player, 'You must be a Pizza Tower character for this to work.') return end
	if player.ntoppv2_sagedrift == nil then player.ntoppv2_sagedrift = false end
	
	local yestext = 'Your drifts are now in style of the SAGE demo.'
	local notext = "Your drifts are now in style of the final game."
	
	if not yesorno then
		player.ntoppv2_sagedrift = not player.ntoppv2_sagedrift
		CONS_Printf(player, player.ntoppv2_sagedrift
			and yestext
			or notext)
	else
		local option = string.lower(yesorno)
		if option == 'yes' or option == 'true' or option == 'on' or option == '1' then
			player.ntoppv2_sagedrift = true
			CONS_Printf(player, yestext)
			return
		end
		if option == 'no' or option == 'false' or option == 'off' or option == '0' then
			player.ntoppv2_sagedrift = false
			CONS_Printf(player, notext)
			return
		end
		player.ntoppv2_sagedrift = not player.ntoppv2_sagedrift
		CONS_Printf(player, player.ntoppv2_sagedrift
			and yestext
			or notext)
	end
end)