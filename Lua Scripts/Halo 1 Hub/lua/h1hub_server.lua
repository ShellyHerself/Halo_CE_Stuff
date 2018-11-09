--Talking Timer Server Side Script by Michelle
api_version = "1.9.0.0"


-- Enable Training Mode in a match using: lua_call h1hub_server enable_training_mode
-- Disable Training Mode in a match using: lua_call h1hub_server enable_training_mode


-- Admin setup:
enable_timer_functions = true
	enable_talking_timer = true -- weapon countdowns are not implemented yet.
		enable_weapon_announcements = true -- Not implemented yet.
	
	enable_cutscene_title_timer = true
		tens_flash_in_a_different_color = true

-- Announcements that require a second instead of just half a second
long_announcements = { "overshield", "camo", "rocket", "sniper", "up_next", "20(twenny)_seconds"}

-- Script setup:
script_version = 2 --DO NOT EDIT!

-- You shouldn't edit these:
tick_counter = nil
sv_map_reset_tick = nil
game_in_progress = false
training_mode = false

-- Callables:
function enable_training_mode()
	training_mode = true
end

function disable_training_mode()
	training_mode = false
end

--
function OnScriptLoad()
	register_callback(cb['EVENT_GAME_START'],"OnGameStart")
	register_callback(cb['EVENT_GAME_END'],"OnGameEnd")
	register_callback(cb['EVENT_TICK'],"OnTick")
	
	register_callback(cb['EVENT_DIE'],"OnDeath")
	register_callback(cb['EVENT_KILL'],"OnKill")
	register_callback(cb['EVENT_SUICIDE'],"OnSuicide")
	
	register_callback(cb['EVENT_WEAPON_PICKUP'],"OnPickup")
	register_callback(cb['EVENT_SPAWN'],"OnSpawn")
	
	register_callback(cb['EVENT_JOIN'],"OnJoin")
	
	InitializeTimers()
	OnGameStart()
end

function OnJoin(player_id)
	rprint(player_id, "|n" ..sep.. "version" ..sep .. script_version)
	
	if training_mode then
		rprint(player_id, "|n" ..sep.. "training_mode" ..sep .. "true")
	else
		rprint(player_id, "|n" ..sep.. "training_mode" ..sep .. "false")
	end
end

function OnGameStart()
	game_in_progress = true
end
function OnGameEnd()
	game_in_progress = false
	training_mode = false
end

last_tick_training_mode = false
function OnTick()
	if game_in_progress == true then
		if enable_timer_functions == true then
			TimersOnTick()
		end
	end
	
	if training_mode == true and last_tick_training_mode == false then
		for player_id=1,16 do
			rprint(player_id, "|n" ..sep.. "training_mode" ..sep .. "true")
		end
		last_tick_training_mode = true
	elseif training_mode == false and last_tick_training_mode == true then
		for player_id=1,16 do
			rprint(player_id, "|n" ..sep.. "training_mode" ..sep .. "false")
		end
		last_tick_training_mode = false
	end
end

function OnDeath(player_id, causer) --expect second arg as string

end

function OnKill(killer, killed) --expect second arg as string

end

function OnSuicide(player_id)

end

function OnPickup(player_id, weapon_type, weapon_slot) --expect second and third arg as string

end

function OnSpawn(player_id)
	
end

--- Timer functions

ticks_passed = 0

function InitializeTimers()
	local tick_counter_sig = sig_scan("8B2D????????807D0000C644240600")
	if(tick_counter_sig == 0) then
		cprint("Failed to find tick_counter_sig.")
		return
	end
	tick_counter = read_dword(read_dword(tick_counter_sig + 2)) + 0xC
	
	local sv_map_reset_tick_sig = sig_scan("8B510C6A018915????????E8????????83C404")
	if(sv_map_reset_tick_sig == 0) then
		cprint("Failed to find sv_map_reset_tick_sig.")
		return
	end
	sv_map_reset_tick = read_dword(sv_map_reset_tick_sig + 7)
end

function TimersOnTick()
	ticks_passed = read_dword(tick_counter) - read_dword(sv_map_reset_tick)

	if (ticks_passed % 30) == 0 then
		--We only want to process stuff every second
		local time_passed = math.floor(ticks_passed / 30)
		local minutes = math.floor(time_passed / 60) % 30 --modulus 30 so it resets after 30 minutes
		local seconds = time_passed % 60
		
		if enable_talking_timer == true then
			TalkingTimerAnnounce(time_passed, minutes, seconds)
		end
		
		if enable_cutscene_title_timer == true then
			OnScreenTimerUpdate(minutes, seconds)
		end
	end
end

sep = "`" --seperator

function TalkingTimerAnnounce(time_passed, minutes, seconds)
	local seconds_left = 60 - seconds

	local message_to_send = "|n"..sep.."timer"
	
	-- 10 seconds into the minute there is no beep,
	-- during the last 10 seconds there is no beep because of the count down
	if seconds_left % 10 == 0 and seconds ~= 10 and seconds_left ~= 10 then
		message_to_send = message_to_send ..sep.."beepbeep"
	end
	-- minute announcements only happen when the minute has just started
	if seconds == 0 then
		if minutes ~= 0 then
			message_to_send = message_to_send .. sep .. minutes .. "_minute"
			if minutes ~= 1 then
				message_to_send = message_to_send .. "s"
			end
		--30 minutes will show up as 0 due to the modulus,
		--and we need to avoid saying 30 minutes at the start of the game
		elseif ticks_passed > 0 then
			message_to_send = message_to_send .. sep .. "30_minutes"
		end
	-- this else is because this should not be ran on the top of a minute
	else
	if seconds_left == 30 then
			message_to_send = message_to_send .. sep .. "30_seconds_left"
		elseif seconds_left == 20 then
			message_to_send = message_to_send .. sep .. "20(twenny)_seconds"
		elseif seconds_left <= 10 then
			message_to_send = message_to_send .. sep .. seconds_left
		end
	end
			
	-- if the message is just "|n:timer" there is no data in it, so only send when we have data
	if message_to_send ~= "|n"..sep.."timer" then
		for i=1,16 do
			rprint(i, message_to_send)
		end
	end

end

function OnScreenTimerUpdate(minutes, seconds)
	for i=1,16 do
		ClearPlayerConsole(i)
		if tens_flash_in_a_different_color then
			--rprint(i, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds) .. "|ncin_tit")
			if seconds == 0 then
			CutsceneTitlePrint(i, 2+seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0, 0.25, 0.5, 200, 255, 0, 0)
			CutsceneTitlePrint(i, seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0.75, 1, 1, 160, 117, 186, 255)
			
			elseif seconds == 30 then
			CutsceneTitlePrint(i, 2+seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0, 0.25, 0.5, 200, 0, 255, 0)
			CutsceneTitlePrint(i, seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0.75, 1, 1, 160, 117, 186, 255)
			
			elseif seconds % 10 == 0 then
			CutsceneTitlePrint(i, 2+seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0, 0.25, 0.5, 200, 255, 255, 255)
			CutsceneTitlePrint(i, seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0.75, 1, 1, 160, 117, 186, 255)
			
			else
			CutsceneTitlePrint(i, seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0, 1, 1, 160, 117, 186, 255)
			end
		else
			CutsceneTitlePrint(i, seconds % 2, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds), -1, -40, 0, 1, 1, 160, 117, 186, 255)
		end
		CutsceneTitleDelete(i, (seconds+1) % 2)
	end
end

function CutsceneTitlePrint(player_id, slot, text, 
                            cutscene_title_x, cutscene_title_y,
                            fade_in_time, staying_time, fade_out_time, 
                            alpha, red, green, blue)
	
	if string.len(text) > 40 then
		text = string.sub(text, 1, 40)
	end
	
	slot = CheckValueBounds(math.floor(slot), 0, 31)
	
	cutscene_title_x = CheckValueBounds(math.floor(cutscene_title_x), -2047, 2047)
	if cutscene_title_x < 0 then
		cutscene_title_x = cutscene_title_x + 0xFFF
	end
	cutscene_title_y = CheckValueBounds(math.floor(cutscene_title_y), -2047, 2047)
	if cutscene_title_y < 0 then
		cutscene_title_y = cutscene_title_y + 0xFFF
	end
	
	fade_in_time = CheckValueBounds(math.floor(fade_in_time*30), 0, 0xFFF)
	staying_time = CheckValueBounds(math.floor(staying_time*30), 0, 0xFFF)
	fade_out_time = CheckValueBounds(math.floor(fade_out_time*30), 0, 0xFFF)
	
	red = CheckValueBounds(math.floor(red), 0, 0xFF)
	green = CheckValueBounds(math.floor(green), 0, 0xFF)
	blue = CheckValueBounds(math.floor(blue), 0, 0xFF)
	
	local text = text .. "|n"..sep.."cin_tit"
	text = text ..sep.. string.format("%02X", slot) 
	text = text .. string.format("%03X", cutscene_title_x) .. string.format("%03X", cutscene_title_y)
	text = text .. string.format("%03X", fade_in_time) .. string.format("%03X", staying_time) .. string.format("%03X", fade_out_time)
	text = text .. string.format("%02X", alpha) .. string.format("%02X", red) .. string.format("%02X", green) .. string.format("%02X", blue)
	
	rprint(player_id, text)
end

function CutsceneTitleDelete(player_id, slot)
	rprint(player_id, "|n" ..sep.. "cin_tit" ..sep.. "del" ..sep.. string.format("%02X", slot))
end

function CheckValueBounds(value, low_bound, high_bound)
	if value ~= nil then
		if value > high_bound then
			return high_bound
		elseif value < low_bound then
			return low_bound
		else
			return value
		end
	else
		return low_bound
	end
end

function ClearPlayerConsole(id)
	for j=1,24 do
		rprint(id, "|ndelete")
	end
end