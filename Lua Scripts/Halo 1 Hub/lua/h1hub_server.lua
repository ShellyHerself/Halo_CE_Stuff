--Talking Timer Server Side Script by Michelle
api_version = "1.9.0.0"


-- Admin setup:
enable_timer_functions = true
	enable_talking_timer = true -- weapon countdowns are not implemented yet.
		enable_weapon_announcements = false -- Not implemented yet.
	
	enable_cutscene_title_timer = false -- Not properly implemented yet.

-- Announcements that require a second instead of just half a second
long_announcements = { "overshield", "camo", "rocket", "sniper", "up_next", "20(twenny)_seconds"}

-- Script setup:
script_version = 1 --DO NOT EDIT!

tick_counter = nil
sv_map_reset_tick = nil
game_in_progress = false

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
	rprint(player_id, "|n:version:" .. script_version)
end

function OnGameStart()
	game_in_progress = true
end
function OnGameEnd()
	game_in_progress = false
end


function OnTick()
	if game_in_progress == true then
		if enable_timer_functions == true then
			TimersOnTick()
		end
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


function TalkingTimerAnnounce(time_passed, minutes, seconds)
	local seconds_left = 60 - seconds

	local message_to_send = "|n:timer"
	
	-- 10 seconds into the minute there is no beep,
	-- during the last 10 seconds there is no beep because of the count down
	if seconds_left % 10 == 0 and seconds ~= 10 and seconds_left ~= 10 then
		message_to_send = message_to_send .. ":beepbeep"
	end
	-- minute announcements only happen when the minute has just started
	if seconds == 0 then
		if minutes ~= 0 then
			message_to_send = message_to_send .. ":" .. minutes .. "_minute"
			if minutes ~= 1 then
				message_to_send = message_to_send .. "s"
			end
		--30 minutes will show up as 0 due to the modulus,
		--and we need to avoid saying 30 minutes at the start of the game
		elseif ticks_passed > 0 then
			message_to_send = message_to_send .. ":30_minutes"
		end
	-- this else is because this should not be ran on the top of a minute
	else
	if seconds_left == 30 then
			message_to_send = message_to_send .. ":30_seconds_left"
		elseif seconds_left == 20 then
			message_to_send = message_to_send .. ":20(twenny)_seconds"
		elseif seconds_left <= 10 then
			message_to_send = message_to_send .. ":" .. seconds_left
		end
	end
			
	-- if the message is just "|n:timer" there is no data in it, so only send when we have data
	if message_to_send ~= "|n:timer" then
		for i=1,16 do
			rprint(i, message_to_send)
		end
	end

end

function OnScreenTimerUpdate(minutes, seconds)
	for i=1,16 do
		ClearPlayerConsole(i)
		rprint(i, "|r" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds) .. "|ncutscene_title")
	end
end

sep = "█" --seperator

function CutsceneTitlePrint(slot, text, console_alignment, cutscene_title_x, cutscene_title_y, fade_in_time, staying_time, fade_out_time, red, green, blue)
	
end

function CutsceneTitleDelete(slot)
	
end

function ClearPlayerConsole(id)
	for j=1,24 do
		rprint(id, "|ndelete")
	end
end