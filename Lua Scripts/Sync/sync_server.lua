-- Biped Sync Script by Michelle
api_version = "1.9.0.0"


--- Settings:
ticks_per_update = 15 --determines the baseline update rate
ticks_per_small_update = 4


---


--- Runtime structs and vars:
tick_count = 0
synced_biped_count = 0
last_added_biped_id = 0
synced_bipeds = {}

--- synced biped struct
synced_bipeds_found = {}
synced_bipeds_unique_id = {}
synced_bipeds_object_id = {}
synced_bipeds_tag_id = {}

synced_bipeds_pos = {}
synced_bipeds_pos_x = {}
synced_bipeds_pos_y = {}
synced_bipeds_pos_z = {}
synced_bipeds_rot_x = {}
synced_bipeds_rot_y = {}
synced_bipeds_rot_z = {}
synced_bipeds_look_x = {}
synced_bipeds_look_y = {}
synced_bipeds_look_z = {}
synced_bipeds_vel_x = {}
synced_bipeds_vel_y = {}
synced_bipeds_vel_z = {}

synced_bipeds_animation_id = {}
synced_bipeds_animation_frame = {}
synced_bipeds_overlay_animation_id = {}
synced_bipeds_overlay_animation_frame = {}

synced_bipeds_weapon_tag_id = {}
synced_bipeds_team = {}
synced_bipeds_red = {}
synced_bipeds_green = {}
synced_bipeds_blue = {}
synced_bipeds_health = {}
synced_bipeds_shield = {}
synced_bipeds_shooting = {}
synced_bipeds_unit_state = {}
synced_bipeds_perm1 = {}
synced_bipeds_perm2 = {}
synced_bipeds_perm3 = {}
synced_bipeds_perm4 = {}
synced_bipeds_perm5 = {}
synced_bipeds_perm6 = {}
synced_bipeds_perm7 = {}
synced_bipeds_perm8 = {}
synced_bipeds_needs_update = {}
synced_bipeds_tag_id_stuff = {}
---
syncing_enabled = true
object_array = nil

function OnError(Message)
    print(debug.traceback())
end


function OnScriptLoad()
	register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
	register_callback(cb['EVENT_GAME_START'], "OnGameStart")
	register_callback(cb['EVENT_TICK'], "OnTick")
	syncing_enabled = true
	object_array = get_object_array()
	cprint("test1")
end


function OnGameEnd()
	synced_biped_count = 0
	last_added_biped_id = 0
	syncing_enabled = false
end


function OnGameStart()
	synced_biped_count = 0
	last_added_biped_id = 0
	syncing_enabled = true
	tick_count = 0
end


function OnTick()
	tick_count = tick_count + 1 -- fuck off lua, why the fuck would you not support += or ++
		--- Set found values from last update to false
	for i=1,synced_biped_count do
		if synced_bipeds_found[i] == true then
			synced_bipeds_found[i] = false
			synced_bipeds_needs_update[i] = false
		end
	end
	
	--- Iterate through the object_array
	for i=0, get_object_count()-1 do
		local object = get_object(i)
		if(object ~= nil) then
			if(read_word(object+0xB4) == 0) then -- object type 0 is for bipeds
				UpdateBipedInfo(object, i)
			end
		end -- turn into else if chain for other object types, because we can't have switch cases
	end
		
	if (math.mod(tick_count,ticks_per_update) == 0) then
		for player=1,16 do
			rprint(player, "mich_sync_update")
		end
	end
	
	SendBipedInfo()
	CleanUpBipedInfo()
	
end


function UpdateBipedInfo(m_object, m_object_id)
	--- Get all relevant biped info
	
	for p=1,16 do
		if get_dynamic_player(p) == m_object then
			--cprint("Ignored player biped")
			return 0
		end
	end
	
	if (read_float(m_object+0xE0) > 0) then --Check if health is valid
		local synced_biped_to_edit = nil
		
		local unique_id = read_word(m_object+0x52A)
		if (unique_id ~= 0) then
			for i=1, synced_biped_count do
				if synced_bipeds_unique_id[i] == unique_id then
					synced_bipeds_found[i] = true
					synced_biped_to_edit = i
				end
			end
		else
			synced_biped_count = synced_biped_count+1
			last_added_biped_id = last_added_biped_id + 1
			unique_id = last_added_biped_id
			write_word(m_object+0x52A, unique_id)
			
			for i=1, synced_biped_count do
				if synced_bipeds_unique_id[i] == nil then
					synced_bipeds_found[i] = true
					synced_bipeds_unique_id[i] = unique_id
					synced_biped_to_edit = i
				end
			end
		end
		
		if synced_biped_to_edit ~= nil then
			synced_bipeds_object_id[synced_biped_to_edit] = m_object_id
			synced_bipeds_tag_id[synced_biped_to_edit] = read_word(m_object)
			synced_bipeds_tag_id_stuff[synced_biped_to_edit] = read_word(m_object+2)

			synced_bipeds_pos_x[synced_biped_to_edit] = read_float(m_object + 0x5C)
			synced_bipeds_pos_y[synced_biped_to_edit] = read_float(m_object + 0x5C+4)
			synced_bipeds_pos_z[synced_biped_to_edit] = read_float(m_object + 0x5C+8)
			if synced_bipeds_rot_x[synced_biped_to_edit] ~= nil then
				local test = synced_bipeds_rot_x[synced_biped_to_edit] - read_float(m_object + 0x74)
				if test <0 then
					test = test*-1
				end
				if test > 0.20 then
					synced_bipeds_needs_update[synced_biped_to_edit] = true
				end
			end
			synced_bipeds_rot_x[synced_biped_to_edit] = read_float(m_object + 0x74)
			synced_bipeds_rot_y[synced_biped_to_edit] = read_float(m_object + 0x74+4)
			synced_bipeds_rot_z[synced_biped_to_edit] = read_float(m_object + 0x74+8)
			synced_bipeds_look_x[synced_biped_to_edit] = read_float(m_object + 0x224)
			synced_bipeds_look_y[synced_biped_to_edit] = read_float(m_object + 0x224+4)
			synced_bipeds_look_z[synced_biped_to_edit] = read_float(m_object + 0x224+8)
			synced_bipeds_vel_x[synced_biped_to_edit] = read_float(m_object + 0x68)
			synced_bipeds_vel_y[synced_biped_to_edit] = read_float(m_object + 0x68+4)
			synced_bipeds_vel_z[synced_biped_to_edit] = read_float(m_object + 0x68+8)
			
			if synced_bipeds_animation_id[synced_biped_to_edit] ~= read_word(m_object + 0xD0) then
				synced_bipeds_needs_update[synced_biped_to_edit] = true
			end
			synced_bipeds_animation_id[synced_biped_to_edit] = read_word(m_object + 0xD0)
			synced_bipeds_animation_frame[synced_biped_to_edit] = read_word(m_object + 0xD2) --might not be right
			synced_bipeds_overlay_animation_id[synced_biped_to_edit] = read_word(m_object + 0x2A3) --- actually state
			synced_bipeds_overlay_animation_frame[synced_biped_to_edit] = 0

			synced_bipeds_weapon_tag_id[synced_biped_to_edit] = 0
			synced_bipeds_team[synced_biped_to_edit] = 0

			synced_bipeds_health[synced_biped_to_edit] = read_float(m_object + 0xE0)
			synced_bipeds_shield[synced_biped_to_edit] = read_float(m_object + 0xE4)
			synced_bipeds_shooting[synced_biped_to_edit] = read_float(m_object + 0x284)
			synced_bipeds_unit_state[synced_biped_to_edit] = read_byte(m_object + 0x2A0)
			
			synced_bipeds_red[synced_biped_to_edit] = read_float(m_object + 0x188)
			synced_bipeds_green[synced_biped_to_edit] = read_float(m_object + 0x188+4)
			synced_bipeds_blue[synced_biped_to_edit] = read_float(m_object + 0x188+8)
			synced_bipeds_perm1[synced_biped_to_edit] = read_byte(m_object + 0x180)
			synced_bipeds_perm2[synced_biped_to_edit] = read_byte(m_object + 0x180+1)
			synced_bipeds_perm3[synced_biped_to_edit] = read_byte(m_object + 0x180+2)
			synced_bipeds_perm4[synced_biped_to_edit] = read_byte(m_object + 0x180+3)
			synced_bipeds_perm5[synced_biped_to_edit] = read_byte(m_object + 0x180+4)
			synced_bipeds_perm6[synced_biped_to_edit] = read_byte(m_object + 0x180+5)
			synced_bipeds_perm7[synced_biped_to_edit] = read_byte(m_object + 0x180+6)
			synced_bipeds_perm8[synced_biped_to_edit] = read_byte(m_object + 0x180+7)
		end
	end
end


function SendBipedInfo()
	cprint("Synced biped count:" .. synced_biped_count)
	for sb=1,synced_biped_count-1 do
		if synced_bipeds_found[sb] == true then
			if (math.mod(tick_count,ticks_per_update) == 0) then
				synced_bipeds_needs_update[sb] = false
				local string_to_send = "bi"
				local debug_string = "bi"
				string_to_send = string_to_send .. string.format("%04X", synced_bipeds_unique_id[sb])
				string_to_send = string_to_send .. string.format("%04X", synced_bipeds_tag_id[sb])
				
				string_to_send = string_to_send .. string.format("%06X", CompressPosition(synced_bipeds_pos_x[sb]))
				string_to_send = string_to_send .. string.format("%06X", CompressPosition(synced_bipeds_pos_y[sb]))
				string_to_send = string_to_send .. string.format("%06X", CompressPosition(synced_bipeds_pos_z[sb]))
			
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_x[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_y[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_z[sb]))
			
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_x[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_y[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_z[sb]))
			
				string_to_send = string_to_send .. string.format("%04X", CompressVelocity(synced_bipeds_vel_x[sb]))
				string_to_send = string_to_send .. string.format("%04X", CompressVelocity(synced_bipeds_vel_y[sb]))
				string_to_send = string_to_send .. string.format("%04X", CompressVelocity(synced_bipeds_vel_z[sb]))
			
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_animation_id[sb])
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_animation_frame[sb])
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_overlay_animation_id[sb])
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_overlay_animation_frame[sb])
			
				string_to_send = string_to_send .. string.format("%04X", synced_bipeds_weapon_tag_id[sb])

				if synced_bipeds_health[sb] < 0 then
					string_to_send = string_to_send .. "0"
				elseif synced_bipeds_health[sb] > 1 then
					string_to_send = string_to_send .. "1"
				else
					string_to_send = string_to_send .. string.format("%01X", math.floor((synced_bipeds_health[sb])*8))
				end
			
				if synced_bipeds_shield[sb] < 0 then
					string_to_send = string_to_send .. "0"
				elseif synced_bipeds_shield[sb] > 1 then
					string_to_send = string_to_send .. "1"
				else
					string_to_send = string_to_send .. string.format("%01X", math.floor((synced_bipeds_shield[sb])*8))
				end
			
				if synced_bipeds_shooting[sb] ~= 0 then
					string_to_send = string_to_send .. "1"
				else
					string_to_send = string_to_send .. "0"
				end
				
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_unit_state[sb])
				for player=1,16 do
					rprint(player, string_to_send)
				end
				
			elseif synced_bipeds_needs_update[sb] == true then
				synced_bipeds_needs_update[sb] = false
				local string_to_send = "bs"
				
				string_to_send = string_to_send .. string.format("%04X", synced_bipeds_unique_id[sb])
				
				string_to_send = string_to_send .. string.format("%06X", CompressPosition(synced_bipeds_pos_x[sb]))
				string_to_send = string_to_send .. string.format("%06X", CompressPosition(synced_bipeds_pos_y[sb]))
				string_to_send = string_to_send .. string.format("%06X", CompressPosition(synced_bipeds_pos_z[sb]))
				
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_x[sb]))
				
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_x[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_y[sb]))
				
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_animation_id[sb])
				string_to_send = string_to_send .. string.format("%02X", synced_bipeds_overlay_animation_id[sb])
				
				string_to_send = string_to_send .. string.format("%04X", CompressVelocity(synced_bipeds_vel_x[sb]))
				string_to_send = string_to_send .. string.format("%04X", CompressVelocity(synced_bipeds_vel_y[sb]))
				string_to_send = string_to_send .. string.format("%04X", CompressVelocity(synced_bipeds_vel_z[sb]))
				
				
				for player=1,16 do
					rprint(player, string_to_send)
				end
				
			elseif (math.mod(tick_count,ticks_per_small_update) == 0) then
				local string_to_send = "bo"
				
				string_to_send = string_to_send .. string.format("%04X", synced_bipeds_unique_id[sb])
				
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_x[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_y[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_rot_z[sb]))
				
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_x[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_y[sb]))
				string_to_send = string_to_send .. string.format("%02X", CompressVector(synced_bipeds_look_z[sb]))
				
				if synced_bipeds_shooting[sb] ~= 0 then
					string_to_send = string_to_send .. "1"
				else
					string_to_send = string_to_send .. "0"
				end

				for player=1,16 do
					rprint(player, string_to_send)
				end
				
			end
			
		end
	end
	
end


function CleanUpBipedInfo()
	local deleted = 0
	for i=1,synced_biped_count do
		if synced_bipeds_found[i] == false then
			synced_bipeds_found[i] = nil
			synced_bipeds_unique_id[i] = nil
		end
	end
end


function CompressPosition(input)
	local output = math.floor((input+5000)*((2^24)/10000))
	if output < 0 then
		output = 0
	elseif output > 2^24-1 then
		output = 2^24-1
	end
	return output
end

function CompressVector(input)
	return (math.floor((input+1)*127))
end

function CompressVelocity(input)
	if input > 2.5 then
		return 2^16-1
	elseif input < -2.5 then
		return 0
	end
	return math.floor((input+2.5)*((2^16-1)/5))
end








--- This function is made to mimic the chimera api version
function get_object(object_id)
	local object_pointer = nil
	
	object_pointer = read_dword(object_array + 0x38 + object_id * 0xC + 0x8)
	if object_pointer == 0 or object_pointer == 0xFFFFFFFF then
		object_pointer = nil
	end

	return object_pointer
end

function get_object_count()
	return read_word(object_array + 0x2E)
end

function get_object_array()
	return read_dword(read_dword(sig_scan("8B0D????????8B513425FFFF00008D") + 2))
end

function read_vec3d(address)
	return read_vector3d(address)
end