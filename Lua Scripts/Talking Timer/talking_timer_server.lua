--Talking Timer Server Side Script by Michelle
api_version = "1.9.0.0"


tick_counter = nil
sv_map_reset_tick = nil
game_in_progress = false

-- Announcements that require a second instead of just half a second
long_announcements = { "camo", "rocket", "sniper", "up_next", "20(twenny)_seconds"}


function OnScriptLoad()
	register_callback(cb['EVENT_GAME_START'],"OnStart")
	register_callback(cb['EVENT_GAME_END'],"OnEnd")
	register_callback(cb['EVENT_TICK'],"OnTick")
	
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
	
	OnStart()
end

function OnStart()
	game_in_progress = true
end
function OnEnd()
	game_in_progress = false
end


function OnTick()
	if game_in_progress == true then
		local ticks_passed = read_dword(tick_counter) - read_dword(sv_map_reset_tick)
		
		if (ticks_passed % 30) == 0 then
			--We only want to process stuff every second
			local time_passed = math.floor(ticks_passed / 30)
			local minutes = math.floor(time_passed / 60) % 30 --modulus 30 so it resets after 30 minutes
			local seconds = time_passed % 60
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
					message_to_send = message_to_send .. ":30_seconds"
				elseif seconds_left == 20 then
					message_to_send = message_to_send .. ":20(twenny)_seconds"
				elseif seconds_left <= 10 then
					message_to_send = message_to_send .. ":" .. seconds_left
				end
			end
			
			-- if the message is just |n there is no data in it, so only send when we have data
			if message_to_send ~= "|n:timer" then
				for i=1,16 do
					rprint(i, message_to_send)
				end
			end
		end
	end
end

