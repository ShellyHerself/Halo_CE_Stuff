-- Biped Sync Script by Michelle
clua_version = 2.042



--- Runtime structs and vars:
tick_count = 0
---


set_callback("rcon message", "OnRconMessage")
set_callback("map load", "OnMapLoad")
set_callback("tick", "OnTick")

object_array = read_u32(0x7FB710)

hide_client_objects = false

function OnMapLoad()
	synced_biped_count = 0
	
end

function OnTick()
	if hide_client_objects == true then
		local object_count = read_word(object_array + 0x2E)
		for i=0, object_count-1 do
			local object = get_object(i)
			if object ~= nil then
				if read_float(object+0xE0) > 0 then -- check if health is over 0, because 0 or below health bipeds should not be deleted.
					local continue = true
					for player=0,16 do
						if object == get_dynamic_player(player) then
							continue = false
						end
					end
					if(read_word(object+0x52A) == 0 and continue == true) then -- object type 0 is for bipeds
						write_bit(object + 0x10, 0, 1)
						--[[write_bit(object + 0x10, 2, 1)
						write_bit(object + 0x10, 7, 1)
						write_bit(object + 0x10, 18, 1)
						write_bit(object + 0x10, 24, 1)--]]
					end
				end
			end
		end
	end
end

function OnRconMessage(message)
	if string.find(message, "bi", 1) ~= nil then
		HandleClientBaselineUpdate(message)
		return false
		
	elseif string.find(message, "bs", 1) ~= nil then
		HandleClientActionUpdate(message)
		return false
		
	elseif string.find(message, "bo", 1) ~= nil then
		HandleClientOrientationUpdate(message)
		return false
	
	elseif message == "mich_sync_update" then
		execute_script("ai false")
		--execute_script("object_destroy_all")
		hide_client_objects = true
		local object_count = read_word(object_array + 0x2E)
		local deleted_count = 0
		for i=0, object_count-1 do
			local object = get_object(i-deleted_count)
			if object ~= nil then
				if read_word(object+0xB4) == 0 then --check if object is biped
					if read_float(object+0xE0) > 0 then -- check if health is over 0, because 0 or below health bipeds should not be deleted.
						local continue = true
						for player=0,16 do
							if object == get_dynamic_player(player) then
								continue = false
							end
						end
						if(read_word(object+0x52A) == 0 and continue == true) then
							delete_object(i-deleted_count)
							deleted_count = deleted_count - 1
							write_bit(object + 0x10, 0, 1)
							write_bit(object + 0x10, 2, 1)
							write_bit(object + 0x10, 7, 1)
							write_bit(object + 0x10, 18, 1)
							write_bit(object + 0x10, 24, 1)
						end
					end
				end
			end
		end
		return false
	end
end


function HandleClientBaselineUpdate(message)
		local unique_id = tonumber(string.sub(message, 3, 6), 16)
		local tag_id = tonumber(string.sub(message, 7, 10), 16)
		
		local x = DecodePosition(tonumber(string.sub(message, 11, 16), 16))
		local y = DecodePosition(tonumber(string.sub(message, 17, 22), 16))
		local z = DecodePosition(tonumber(string.sub(message, 23, 28), 16))
		
		local rx = DecodeVector(tonumber(string.sub(message, 29, 30), 16))
		local ry = DecodeVector(tonumber(string.sub(message, 31, 32), 16))
		local rz = DecodeVector(tonumber(string.sub(message, 33, 34), 16))

		local lx = DecodeVector(tonumber(string.sub(message, 35, 36), 16))
		local ly = DecodeVector(tonumber(string.sub(message, 37, 38), 16))
		local lz = DecodeVector(tonumber(string.sub(message, 39, 40), 16))
		
		local vx = DecodeVelocity(tonumber(string.sub(message, 41, 44), 16))
		local vy = DecodeVelocity(tonumber(string.sub(message, 45, 48), 16))
		local vz = DecodeVelocity(tonumber(string.sub(message, 49, 52), 16))
		
		local anim_id = tonumber(string.sub(message, 53, 54), 16)
		local anim_frame = tonumber(string.sub(message, 55, 56), 16)
		local overlay_anim_id = tonumber(string.sub(message, 57, 58), 16)
		local overlay_anim_frame = tonumber(string.sub(message, 59, 60), 16)
		
		local weapon_tag_id = tonumber(string.sub(message, 61, 64), 16)
		
		local health = tonumber(string.sub(message, 65, 65), 16) /8
		local shield = tonumber(string.sub(message, 66, 66), 16) /8
		local shooting = tonumber(string.sub(message, 67, 67), 16)
		local unit_state = tonumber(string.sub(message, 68, 69), 16)
		
		local object = nil
		local object_to_edit = nil
		
		local object_count = read_word(object_array + 0x2E)
		for i=0, object_count-1 do
			object = get_object(i)
			if object ~= nil then
				local continue = true
				for player=0,16 do
					if object == get_dynamic_player(player) then
						continue = false
					end
				end
				
				if continue == true then
					if unique_id == read_u16(object+0x52A) then
						object_to_edit = object
						
					end
				end
			end
		end
		
		if object_to_edit == nil then
			local object_id = spawn_object("biped", GetTagPathById(tag_id), x, y, z)
			object_to_edit = get_object(object_id)
			write_u16(object_to_edit+0x52A, unique_id)
			console_out("spawn:baseline update")
		else
			console_out("found:baseline update")
			write_vec3d(object_to_edit+0x5C, x, y, z)
		end
		
		write_vec3d(object_to_edit+0x74, rx, ry, rz)
		write_vec3d(object_to_edit+0x230, lx, ly, lz)

		write_vec3d(object_to_edit+0x68, vx, vy, vz)
		
		write_u8(object_to_edit+0xD0, anim_id)
		write_u8(object_to_edit+0xD2, anim_frame)
		--write_u8(object_to_edit+0x2A3, overlay_anim_id)
		--write_u8(object_to_edit+, overlay_anim_frame)
		
		--- weapon stuff
		
		write_float(object_to_edit+0xE0, health)
		write_float(object_to_edit+0xE4, shield)
		write_float(object_to_edit+0x284, shooting)
		write_u8(object_to_edit+0x2A0, unit_state)
		write_u16(object_to_edit+0x52A, unique_id)
		
		write_bit(object_to_edit+0x106, 11, 1) --make the biped invincible
		
end


function HandleClientActionUpdate(message)
		local unique_id = tonumber(string.sub(message, 3, 6), 16)

		local x = DecodePosition(tonumber(string.sub(message, 11-4, 16-4), 16))
		local y = DecodePosition(tonumber(string.sub(message, 17-4, 22-4), 16))
		local z = DecodePosition(tonumber(string.sub(message, 23-4, 28-4), 16))
		
		local rx = DecodeVector(tonumber(string.sub(message, 29-4, 30-4), 16))
		
		local lx = DecodeVector(tonumber(string.sub(message, 35-8, 36-8), 16))
		local ly = DecodeVector(tonumber(string.sub(message, 37-8, 38-8), 16))

		
		local anim_id = tonumber(string.sub(message, 31, 32), 16)
		local overlay_anim_id = tonumber(string.sub(message, 33, 34), 16)
		
		local vx = DecodeVelocity(tonumber(string.sub(message, 35, 38), 16))
		local vy = DecodeVelocity(tonumber(string.sub(message, 39, 42), 16))
		local vz = DecodeVelocity(tonumber(string.sub(message, 43, 46), 16))
		
		local object = nil
		local object_to_edit = nil
		
		local object_count = read_word(object_array + 0x2E)
		for i=0, object_count-1 do
			object = get_object(i)
			if object ~= nil then
				local continue = true
				for player=0,16 do
					if object == get_dynamic_player(player) then
						continue = false
					end
				end
				
				if continue == true then
					if unique_id == read_u16(object+0x52A) then
						object_to_edit = object
						console_out("found:action update")
					end
				end
			end
		end
		
		if object_to_edit == nil then
			return nil
		end
		
		write_vec3d(object_to_edit+0x5C, x, y, z)
		
		write_float(object_to_edit+0x74, rx)
		write_float(object_to_edit+0x230, lx)
		write_float(object_to_edit+0x230+4, lx)
		
		write_u8(object_to_edit+0xD0, anim_id)
		--write_u8(object_to_edit+0x2A3, overlay_anim_id)
		
		--write_vec3d(object_to_edit+0x68, vx, vy, vz)
		
		write_u16(object_to_edit+0x52A, unique_id)
end


function HandleClientOrientationUpdate(message)
		local unique_id = tonumber(string.sub(message, 3, 6), 16)


		local rx = DecodeVector(tonumber(string.sub(message, 7, 8), 16))
		local ry = DecodeVector(tonumber(string.sub(message, 9, 10), 16))
		local rz = DecodeVector(tonumber(string.sub(message, 11, 12), 16))
		
		local lx = DecodeVector(tonumber(string.sub(message, 13, 14), 16))
		local ly = DecodeVector(tonumber(string.sub(message, 15, 16), 16))
		local lz = DecodeVector(tonumber(string.sub(message, 17, 18), 16))
		
		local shooting = tonumber(string.sub(message, 19, 19), 16)
		
		local object = nil
		local object_to_edit = nil
		
		local object_count = read_word(object_array + 0x2E)
		for i=0, object_count-1 do
			object = get_object(i)
			if object ~= nil then
				local continue = true
				for player=0,16 do
					if object == get_dynamic_player(player) then
						continue = false
					end
				end
				
				if continue == true then
					if unique_id == read_u16(object+0x52A) then
						object_to_edit = object
						console_out("found:orientation update")
					end
				end
			end
		end
		
		if object_to_edit == nil then
			return nil
		end
		
		
		write_vec3d(object_to_edit+0x74, rx, ry, rz)
		write_vec3d(object_to_edit+0x230, lx, ly, lz)

		
		write_float(object_to_edit+0x284, shooting)
		
		write_u16(object_to_edit+0x52A, unique_id)
end

function DecodePosition(input)
	return input/(2^24)*10000 -5000
end

function DecodeVector(input)
	return (input/127 -1)
end

function DecodeVelocity(input)
	return input/((2^16-1)/5) -2.5
end

function write_vec3d(dest, i, j, k)
	write_f32(dest, i)
	write_f32(dest+4, j)
	write_f32(dest+8, k)
end


function GetTagPathById(id)
	return read_string8(read_u32(0x40440028 + 0x20*id + 0x10))
end

