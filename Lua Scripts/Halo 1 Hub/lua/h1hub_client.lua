--Talking Timer Client Side Script by Michelle
clua_version = 2.042

cprint = console_out

set_callback("map load", "OnMapLoad")
set_callback("rcon message", "OnRconMessage")
set_callback("tick", "OnTick")

script_version = 1 --DO NOT EDIT!

-- Announcements that require a second instead of just half a second
long_announcements = {}
long_announcement_time = 30
short_announcement_time = 15

queue = {}
queue_timer = 0
queue_rate = short_announcement_time

function OnMapLoad()
	InitCutsceneTitleMessages()
end


function OnRconMessage(message)
	local messages = SplitLine(message)

	if messages[2] == "timer" then
		if messages[3] == "beepbeep" then
			execute_script("sound_impulse_start sound\\timer\\beeps\\timerbeep none 1")
		elseif messages[3] ~= nil then
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
		
	elseif messages[2] == "timr_lng_snds" then
		if messages[3] ~= nil and messages[4] ~= nil then
			short_announcement_time = messages[3]
			long_announcement_time = messages[4]
			if messages[5] ~= nil then
				for i=1,4 do
					table.remove(messages, 1)
				end
				long_announcements = messages
			end
		end
		return false
		
	elseif messages[2] == "cin_tit" then
		if messages[3] == "del" then
			CutsceneTitleRemove(tonumber(messages[4], 16))
		else
			CutsceneTitleMessage(messages[1], messages[3])
		end
		return false
		
	elseif messages[2] == "version" then
		if tonumber(messages[3]) <= script_version then
			cprint("Debug: Client and server scripts are compatible.", 0, 1, 0)
			hud_message("Debug: Client and server scripts are compatible.")
		else
			cprint("Debug: Server has a newer script than the client.", 1, 0, 0)
			hud_message("Debug: Server has a newer script than the client.")
		end
		return false
		
	elseif CompareEndOfString(message, "|ndelete") == true then
		-- return false to delete
		return false
		
	elseif CompareEndOfString(message, "|nhud_text") == true then
		-- remove all special and positional data before sending it over to the hud
		message = string.gsub(message, "|nhud_text", "")
		message = string.gsub(message, "|r", "")
		message = string.gsub(message, "|c", "")
		message = string.gsub(message, "|l", "")
		
		hud_message(message)
		return false
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


--- Cutscene title stuff
cutscene_title_block_addr = nil
cutscene_title_string_block_addr = nil

function InitCutsceneTitleMessages()
	local scenario_cutscene_titles_block_reflexive_offset = 1276
	local scenario_ingame_help_text_reference_offset = 1412
	cutscene_title_block_addr = read_u32(read_u32(0x40440028+0x14)+scenario_cutscene_titles_block_reflexive_offset+4)
	local ustr_tag_id = read_u16(read_u32(0x40440028+0x14)+scenario_ingame_help_text_reference_offset+12)
	local cutscene_title_ustr_tag_addr = read_u32(get_tag(ustr_tag_id)+0x14)
	cutscene_title_string_block_addr = read_u32(cutscene_title_ustr_tag_addr+4)
end

virtual_hud_bounds_x1 = 0
virtual_hud_bounds_y1 = 0
virtual_hud_bounds_x2 = 640
virtual_hud_bounds_y2 = 480

--Amount of characters each var stored in the message take up
cutscene_msg_struct = { 2,         --slot
                        3, 3,      --cutscene_title_x/y
                        3, 3, 3,   --fade_in_time, staying_time, fade_out_time
                        2, 2, 2, 2}--argb

function CutsceneTitleMessage(text, settings)
	local slot, x, y, fade_in, stay_for, fade_out, a,r,g,b = DecodeMessageUsingStruct(settings, cutscene_msg_struct)
	
	local justification = 0 -- 0 is left, 1 is right, 2 is center
	if string.sub(text, 1, 2) == "|r" then
		justification = 1
	elseif string.sub(text, 1, 2) == "|c" then
		justification = 2
	end
	
	if x > 2047 then
		x = virtual_hud_bounds_x2 + x - 0xFFF
	else
		x = virtual_hud_bounds_x1 + x
	end
	if y > 2047 then
		y = virtual_hud_bounds_y2 + y - 0xFFF
	else
		y = virtual_hud_bounds_y1 + y
	end
	
	write_i16(cutscene_title_block_addr+96*slot+40, y)
	write_i16(cutscene_title_block_addr+96*slot+42, virtual_hud_bounds_y2)
	write_i16(cutscene_title_block_addr+96*slot+44, virtual_hud_bounds_x2)
	write_i16(cutscene_title_block_addr+96*slot+46, x)
	
	write_i16(cutscene_title_block_addr+96*slot+52, justification)
	
	write_argb(cutscene_title_block_addr+96*slot+60, a, r, g, b)
	
	write_f32(cutscene_title_block_addr+96*slot+68, fade_in)
	write_f32(cutscene_title_block_addr+96*slot+72, stay_for)
	write_f32(cutscene_title_block_addr+96*slot+76, fade_out)
	
	text = string.gsub(text, "|r", "")
	text = string.gsub(text, "|c", "")
	text = string.gsub(text, "|l", "")
	text = string.gsub(text, "|n", "")
	
	write_nulterminated_widestring(read_u32(cutscene_title_string_block_addr+20*slot+12), text, string.len(text))
	execute_script("cinematic_set_title \"".. string.format("%02d", slot) .."\"")
end

function CutsceneTitleRemove(slot)
	write_argb(cutscene_title_block_addr+96*slot+60, 0, 0, 0, 0)
	write_f32(cutscene_title_block_addr+96*slot+68, 0)
	write_f32(cutscene_title_block_addr+96*slot+72, 0)
	write_f32(cutscene_title_block_addr+96*slot+76, 0)
end
-- Decodes a string into a set of number variables the given list of what size each var takes up in the string.
function DecodeMessageUsingStruct(message, size_list)
	local sum_of_prev = 0
	local output = {}
	for k, v in pairs(size_list) do
		number = tonumber(string.sub(message, sum_of_prev+1, sum_of_prev+size_list[k]), 16)
		table.insert(output, number)
		sum_of_prev = sum_of_prev + size_list[k]
	end
	
	return table.unpack(output)
end


function read_argb(address)
	local a = read_u8(address+3)
	local r = read_u8(address+2)
	local g = read_u8(address+1)
	local b = read_u8(address)
	
	return a,r,g,b
end

function write_argb(address, a, r, g, b)
	write_u8(address+3, a)
	write_u8(address+2, r)
	write_u8(address+1, g)
	write_u8(address,   b)
end

function write_nulterminated_widestring(address, str, len)
	write_widestring(address, str, len)
	write_u16(address+2*len, 0)
end

function write_widestring(address, str, len)
    local length = string.len(str)
    local count = 0
    for i = 1,length do -- Sets the new string.
        local newbyte = string.byte(string.sub(str,i,i))
        write_byte(address + count, newbyte)
		--write_byte(address + count + 1, 0)
		
        count = count + 2
    end
end

function read_widestring(address, length)
    local count = 0
    local byte_table = {}
    for i = 1,length do -- Reads the string.
        if read_byte(address + count) ~= 0 then
            byte_table[i] = string.char(read_byte(address + count))
        end
        count = count + 2
    end
    return table.concat(byte_table)
end

function CompareEndOfString(str, cmp)
	local char_cmp_should_start_at = 1 + string.len(str) - string.len(cmp)
	local cmp_starts_at = string.find(str, cmp)
	if char_cmp_should_start_at == cmp_starts_at then
		return true
	end
	return false
end

sep = "`" --seperator

function SplitLine(inputstr)
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^".. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
