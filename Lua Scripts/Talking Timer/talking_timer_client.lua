--Talking Timer Client Side Script by Michelle
clua_version = 2.042


set_callback("rcon message", "OnRconMessage")
set_callback("tick", "OnTick")

-- Announcements that require a second instead of just half a second
long_announcements = {}
long_announcement_time = 30
short_announcement_time = 15

queue = {}
queue_timer = 0
queue_rate = short_announcement_time


function OnRconMessage(message)
	local messages = SplitLine(message)
	
	if messages[2] == "timer" then
		if messages[3] ~= nil then
			if messages[3] == "beepbeep" then
				execute_script("sound_impulse_start sound\\timer\\beeps\\timerbeep none 1")
			else
				execute_script("sound_impulse_start \"sound\\timer\\cortana\\" .. messages[3] .. "\" none 1")
			end
			
			if messages[4] ~= nil then
				for i=1,3 do
					table.remove(messages, 1)
				end
				queue = messages
				queue_timer = 0
			end
			return false
		end
	elseif messages[2] == "timr_lng_snds" then
		short_announcement_time = messages[3]
		long_announcement_time = messages[4]
		for i=1,4 do
			table.remove(messages, 1)
		end
		long_announcements = messages
	end
end


function OnTick()
	queue_timer = queue_timer + 1
	if (queue_timer % queue_rate) == 0 then
		queue_timer = 0
		if queue[1] ~= nil then
			execute_script("sound_impulse_start \"sound\\timer\\cortana\\" .. queue[1] .. "\" none 1")
			
			local long_announcement = false
			for k, v in pairs(long_announcements) do
				if queue[1] == long_announcements[k] then
					long_announcement = true
				end
			end
			
			if long_announcement == true then
				queue_rate = long_announcement_time
			else
				queue_rate = short_announcement_time
			end
			
			table.remove(queue, 1)
		end
	end
end


function SplitLine(inputstr)
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^:]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
