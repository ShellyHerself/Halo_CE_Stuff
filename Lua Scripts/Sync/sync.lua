
--- sapp api translation
if sapp_version ~= nil then

	api_version = "1.9.0.0"
	host = true

	--callbacks
	function OnScriptLoad()
		register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
		register_callback(cb['EVENT_GAME_START'], "OnGameStart")
		register_callback(cb['EVENT_OBJECT_SPAWN'], "OnObjectSpawn")
		register_callback(cb['EVENT_TICK'], "OnTick")
	end

	function OnScriptUnload()
		--nothing
		--We need this function to avoid an error
	end

	read_u8 = read_byte
	write_u8 = write_byte

	read_i8 = read_char
	write_i8 = write_char

	read_u16 = read_word
	write_u16 = write_word

	read_i16 = read_short
	write_i16 = write_short

	read_u32 = read_dword
	write_u32 = write_dword

	read_i32 = read_int
	write_i32 = write_int

	read_f32 = read_float
	write_f32 = write_float

	read_f64 = read_double
	write_f64 = write_double

	read_vec3d = read_vector3d
	write_vec3d = write_vector3d

	object_delete = destroy_object
	function object_get_address(id)
		local address = get_object_memory(id)
		if address == 0 then
			address = nil
		end
		return address
	end

	function scan_for_signature(signature)
		address = sig_scan(signature)
		if address == 0 then
			address = nil
		end
		return address
	end

	function tag_get_index_address(index)
		--return address
		-- implement this, BITCH
	end

	print = cprint

-- chimera api additions
elseif sandboxed ~= nil then

	--callbacks
	set_callback('map load', "OnMapLoad")
	set_callback('rcon message', "OnRconMessage")
	--set_callback('object spawn', "OnObjectSpawn") -- Doesn't exist in the chimera api
	set_callback('tick', "OnTick")

	function OnMapLoad()
		OnGameEnd()
		OnGameStart()
	end

	function read_vec3d(address)
		return read_f32(address), read_f32(address+4), read_f32(address+8)
	end
	function write_vec3d(address, i, j, k)
		write_f32(address  , i)
		write_f32(address+4, j)
		write_f32(address+8, k)
	end

	print = console_out

	object_delete = delete_object
	object_get_address = get_object
	tag_get_index_address = get_tag

	function scan_for_signature(signature)
		--return address
		-- implement this, BITCH
	end

end

-- used for parsing and conversion
types = {
	u8    = { read = read_u8   , write = write_u8   , int = true , value_count = 1, bounds = {0     ,2^8 -1} },
	i8    = { read = read_i8   , write = write_i8   , int = true , value_count = 1, bounds = {1-2^7 ,2^7 -1} },

	u16   = { read = read_u16  , write = write_u16  , int = true , value_count = 1, bounds = {0     ,2^16-1} },
	i16   = { read = read_i16  , write = write_i16  , int = true , value_count = 1, bounds = {1-2^15,2^15-1} },

	u32   = { read = read_u32  , write = write_u32  , int = true , value_count = 1, bounds = {0     ,2^32-1} },
	i32   = { read = read_i32  , write = write_i32  , int = true , value_count = 1, bounds = {1-2^31,2^31-1} },

	f32   = { read = read_f32  , write = write_f32  , int = false, value_count = 1, scale_to_bounds = true },
	vec3d = { read = read_vec3d, write = write_vec3d, int = false, value_count = 3, scale_to_bounds = true }

}
------------------------
-- shared functions
------------------------

-- Base255 encoding/decoding used to avoid null characters in strings

function EncodeBase255(input)
    n = math.floor(input)

	local char_table = {}
    repeat
        local d = (n % 255) + 1
        n = math.floor(n / 255)
        table.insert(char_table, 1, string.char(d))
    until n == 0
    return table.concat(char_table,"")
end

function DecodeBase255(input)
	length = string.len(input)
	n = 0
	byte_table = {}
	for i=length,1,-1 do
		table.insert(byte_table, string.byte(input, i, i))
	end
	for k,v in pairs(byte_table) do
		if k > 1 then
			n = n + (byte_table[k] - 1) * 255^(k-1)
		else
			n = n + byte_table[k] - 1
		end
	end
	return n
end

BASE255_MAX_SIZES = {}
for i=1,8 do -- Initialisation for the BASE255_MAX_SIZES list
	local base255_number_string = ""
	for j=1,i do
		base255_number_string = base255_number_string .. string.char(255)
	end
	BASE255_MAX_SIZES[i] = DecodeBase255(base255_number_string)
end

-- Round to int for when writing to numbers with types that don't support decimal points

function RoundToInt(number)
	if number % 1 < 0.5 then
		return math.floor(number)
	else
		return math.ceil(number)
	end
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

-- offsets in halo memory
offsets = {
	object = {
		tag_id = { offset = 0, type = types.u32 },
		position = { offset = 0x5C, type = types.vec3d, bounds = {-5000,5000} },
		velocity = { offset = 0x68, type = types.vec3d },
		rotation = { offset = 0x74, type = types.vec3d, bounds = {-1,1} },
		type = { offset = 0xB4, type = types.u16 },
		animation_id = { offset = 0xD0, type = types.u16},
		animation_frame = { offset = 0xD2, type = types.u16},
		health = { offset = 0xE0, type = types.f32, bounds = {0,1} },
		shield = { offset = 0xE4, type = types.f32, bounds = {0,3} },
		health_region1 = { offset = 0x178, type = types.u8, scale_to_bounds = true },
		health_region2 = { offset = 0x179, type = types.u8, scale_to_bounds = true },
		health_region3 = { offset = 0x17A, type = types.u8, scale_to_bounds = true },
		health_region4 = { offset = 0x17B, type = types.u8, scale_to_bounds = true },
		health_region5 = { offset = 0x17C, type = types.u8, scale_to_bounds = true },
		health_region6 = { offset = 0x17D, type = types.u8, scale_to_bounds = true },
		health_region7 = { offset = 0x17E, type = types.u8, scale_to_bounds = true },
		health_region8 = { offset = 0x17F, type = types.u8, scale_to_bounds = true },
		color_change_a = { offset = 0x188, type = types.vec_3d, bounds = {0,1} },
		color_change_b = { offset = 0x194, type = types.vec_3d, bounds = {0,1} },
		color_change_c = { offset = 0x1A0, type = types.vec_3d, bounds = {0,1} },
		color_change_d = { offset = 0x1AC, type = types.vec_3d, bounds = {0,1} },
		unit = { -- seperated these because these only match for units
			facing = { offset = 0x224, type = types.vec3d, bounds = {-1,1} },
			desired_aim = { offset = 0x230, type = types.vec3d, bounds = {-1,1} },
			aim = { offset = 0x23C, type = types.vec3d, bounds = {-1,1} },
			shooting = { offset = 0x284, type = types.f32, bounds = {0,1} },
			animation_unit = { offset = 0x2A0, type = types.u8 },
			weapon_slot = { offset = 0x2A1, type = types.u8, bounds = {0,3} },
			animation_state = { offset = 0x2A3, type = types.u8 },
			animation_state2 = { offset = 0x2A6, type = types.u8 },
			animation_overlay_id = { offset = 0x2AA, type = types.i16 },
			animation_overlay_frame = { offset = 0x2AC, type = types.i16 },
			weapon_1_object_id = { offset = 0x2F8, type = types.i16 },
			weapon_2_object_id = { offset = 0x2FC, type = types.i16 },
			weapon_3_object_id = { offset = 0x300, type = types.i16 },
			weapon_4_object_id = { offset = 0x304, type = types.i16 },
			bipd = {
				unique_id = { offset = 0x52A, type = types.u16 } -- some unused padding.
			}
		}
	}
}

------------------------
-- message definitions
------------------------

message_header_def = {
	message = {
		{ identifier = 0, size = 1 },
		{ object_identifier = 0, size = 1 }
	},
	size = 2
}


unit_velocity_bounds = {-2.5,2.5}
proj_velocity_bounds = {-1000/30,1000/30}


bipd_baseline_message_def = {
	message = {
		{ offsets.object.position, size = 3*3 },
		{ offsets.object.velocity, size = 3*2, bounds = unit_velocity_bounds },
		{ offsets.object.rotation, size = 3*1 },

		{ offsets.object.animation_id, size = 2 },
		{ offsets.object.animation_frame, size = 2 },
		{ offsets.object.unit.facing, size = 3*1 },
		{ offsets.object.unit.desired_aim, size = 3*1 },

		{ offsets.object.unit.animation_state, size = 1 },
		{ offsets.object.unit.shooting, size = 1 }
	},
	actions_when_recieved = {
		{ offsets.object.unit.aim, copy_from = offsets.object.unit.facing }
	}
}


bipd_action_message_def = {
	message = {
		{ offsets.object.position, size = 3*3 },
		{ offsets.object.rotation, size = 3*1 },

		{ offsets.object.animation_id, size = 2 },
		{ offsets.object.unit.desired_aim, size = 1*3},

		{ offsets.object.unit.animation_state, size = 1 },
		{ offsets.object.unit.shooting, size = 1 }
	},
	actions_when_recieved = {
		{ offsets.object.animation_frame, set_to = 0 },
		{ offsets.object.unit.facing, copy_from = offsets.object.unit.desired_aim },
		{ offsets.object.unit.aim, copy_from = offsets.object.unit.desired_aim }
	}
}


bipd_rotation_message_def = {
	message = {
		{ offsets.object.unit.facing, size = 3*1 },
		{ offsets.object.unit.desired_aim, size = 3*1 },
		{ offsets.object.unit.shooting, size = 1 }
	},
	actions_when_recieved = {
		{ offsets.object.unit.aim, copy_from = offsets.object.unit.facing }
	}
}


bipd_spawn_message_def = {
	message = {
		{ offsets.object.color_change_a, size = 3*1, copy_from_cached_value = true },
		{ offsets.object.unit.weapon_1_object_id, size = 3, convert_object_id_to_tag_id = true }
	},
	action_when_recieved = {
		{ offsets.object.unit.weapon_1_object_id, spawn_child_object_from_tag_id = true }
	}
}


proj_spawn_message_def = {
	message = {
		{ offsets.object.position, size = 3*3 },
		{ offsets.object.velocity, size = 3*3, bounds = proj_velocity_bounds }
	}
}


message_definitions = {
	{ bipd_baseline_message_def, id = 151 },
	{ bipd_action_message_def, id = 152 },
	{ bipd_rotation_message_def, id = 153 },
	--{ bipd_spawn_message_def, id = 154 },

	{ proj_spawn_message_def, id = 155 }
}


-- message definitions initialization.
-- We copy everything to the top level so I don't have to add extra logic in the time sensitive message creation and decoding functions.
for k,v in pairs(message_definitions) do
	current_message = message_definitions[k][1]
	current_message.size = 0

	for i=1,#current_message.message do
		local current_entry = current_message.message[i]

		if current_entry.size == nil then print("Error: An entry in a message definition has no size.") end
		current_message.size = current_message.size + current_entry.size

		if current_entry.offset == nil then
			if current_entry[1].offset ~= nil then current_entry.offset = current_entry[1].offset
			else print("Error: An entry in a message definition has no offset.") end
		end

		if current_entry.scale_to_bounds == nil then
			if current_entry[1].scale_to_bounds ~= nil then current_entry.scale_to_bounds = current_entry[1].scale_to_bounds
			elseif current_entry[1].type ~= nil and current_entry[1].type.scale_to_bounds ~= nil then current_entry.scale_to_bounds = current_entry[1].type.scale_to_bounds
			else current_entry.scale_to_bounds = false end
		end

		if current_entry.bounds == nil then
			if current_entry[1].bounds ~= nil then current_entry.bounds = current_entry[1].bounds
			elseif current_entry[1].type.bounds ~= nil then current_entry.bounds = current_entry[1].type.bounds end
		end

		if current_entry.value_count == nil then
			if current_entry[1].value_count ~= nil then current_entry.value_count = current_entry[1].value_count
			elseif current_entry[1].type.value_count ~= nil then current_entry.value_count = current_entry[1].type.value_count
			else current_entry.value_count = 1 end
		end

		if current_entry.int == nil then
			if current_entry[1].int ~= nil then current_entry.int = current_entry[1].int
			elseif current_entry[1].type.int ~= nil then current_entry.int = current_entry[1].type.int end
		end

		if current_entry.bounds ~= nil then
			current_entry.bounds_length = current_entry.bounds[2] - current_entry.bounds[1]
		end
	end

end

------------------------
-- memory functions
------------------------

function ReadValuesUsingOffsetList(address, message_definition)
	local value_table = {}
	local i = 1
	repeat
		local entry = message_definition[i]
		value_table[i] = table.pack(current_entry.read(address+current_entry.offset))
		i = i + 1
	until message_definition[i] == nil
	return value_table
end


function WriteValuesUsingOffsetList(address, message_definition, value_table)
	local i = 1
	repeat
		local entry = message_definition[i]
		item.type.write(address+entry.offset, table.unpack(value_table[i]))
		i = i + 1
	until message_definition[i] == nil
end

-- Functions for packing numbers into bytes when you can't get an integer from deviding n_bytes by n_values

-- Packs multiple vars inside the bounds of 0-1 into the given number of bytes.
function PackTableIntoBytes(table, n_values, n_bytes)
	-- n_bytes should never be greater than 8, lua uses doubles which means that numbers that are over 8 bytes in size will be cut off.
	-- In any other language I would care to fix this.
	-- But in any other language I would have access to bit shifting functions that aren't limited to 32bits.
	if n_bytes > 8 then print("A number higher than 8 got passed into the var n_bytes in PackTableIntoBytes(). This will surely break.") end

	local bits = n_bytes * 8
	local least_bits_per_var = math.floor(bits/n_values)
	local leftover_bits = bits - least_bits_per_var * n_values

	local sum = 0
	for i=1,n_values do
		local bits_for_cur = least_bits_per_var
		if leftover_bits > 0 then
			bits_for_cur = bits_for_cur + 1
			leftover_bits = leftover_bits - 1
		end
		local cur = CheckValueBounds(RoundToInt(table[i] * (2^bits_for_cur-1)), 0, 2^bits_for_cur-1)
		sum = sum * (2^bits_for_cur) + cur --shift left and add current value at end
	end
	return sum
end


function UnpackBytesIntoTable(number, n_values, n_bytes)
	local bits = n_bytes * 8
	local least_bits_per_var = math.floor(bits/n_values)
	local leftover_bits = bits - least_bits_per_var * n_values

	local table = {}
	-- I could have avoided needing a var like this by packing the bits the other
	-- way around, or reversing the unpacking. But, this works, so FUCK YOU <3
	local n_vars_with_no_extra_bit = n_values - leftover_bits
	for i=1,n_values do
		local bits_for_cur = least_bits_per_var
		if i > n_vars_with_no_extra_bit then
			bits_for_cur = bits_for_cur + 1
		end
		table[n_values-i+1] = number % (2^bits_for_cur) / (2^bits_for_cur-1)
		number = RoundToInt(number / (2^bits_for_cur))
	end
	return table
end

-- Made these tables to reduce inline math
BYTESETS_MAX_SIZES = {}
for i=1,8 do -- Initialisation for the BYTESETS_MAX_SIZES list
	BYTESETS_MAX_SIZES[i] = 2^(i*8)-1
end

BYTE_TO_BASE255_CONV_SCALES = {}
for i=1,8 do -- Initialisation for the BYTE_TO_BASE255_CONV_SCALES list
	BYTE_TO_BASE255_CONV_SCALES[i] = BASE255_MAX_SIZES[i] / BYTESETS_MAX_SIZES[i]
end

------------------------
-- message functions
------------------------

-- Used to make sure that each part of each message is the right size
function AddLeadingCharacters(text, target_length)
	local leading_zeros = target_length - string.len(text)
	if leading_zeros > 0 then
		for i=1,leading_zeros do
			text = string.char(1) .. text
		end
	end
	return text
end

-- Encodes a table into a Base255 string using the given message definition.
function ConvertValuesToMessage(message_definition, value_table)
	local message = ""
	local i = 1
	repeat
		local current_def = message_definition.message[i]
		local current_values = value_table[i]
		local size = current_def.size / current_def.value_count

		if current_def.size % current_def.value_count == 0 then
			for k,v in pairs(current_values) do
				local value = current_values[k]

				if current_def.scale_to_bounds then
					value = CheckValueBounds(value, table.unpack(current_def.bounds))
					value = (value - current_def.bounds[1]) / current_def.bounds_length
					value = CheckValueBounds(RoundToInt(value*BASE255_MAX_SIZES[size]),0, BASE255_MAX_SIZES[size])

					message = message .. AddLeadingCharacters(EncodeBase255(value), size)
				else
					value = RoundToInt(value)
					value = CheckValueBounds(value, 0, BASE255_MAX_SIZES[size])

					message = message .. AddLeadingCharacters(EncodeBase255(value), size)
				end
			end

		else
			if current_def.size > 8 then print("Error: A part of a message has a size that when modulo by the number of values is performed onto it the output is != 0. And the size is over 8. Shit's gonna break.") end

			for k,v in pairs(current_values) do
				current_values[k] = (current_values[k] - current_def.bounds[1]) / current_def.bounds_length
				current_values[k] = CheckValueBounds(current_values[k], table.unpack(current_def.bounds))
			end
			local packed_numbers = PackTableIntoBytes(current_values, current_def.value_count, current_def.size)
			      packed_numbers = RoundToInt(packed_numbers * BYTE_TO_BASE255_CONV_SCALES[current_def.size])
			      packed_numbers = CheckValueBounds(packed_numbers, 0, BASE255_MAX_SIZES[current_def.size])

			message = message .. AddLeadingCharacters(EncodeBase255(packed_numbers), current_def.size)
		end
		i = i + 1
	until message_definition.message[i] == nil

	return message
end

-- Decodes a Base255 string into a table using the given message definition.
function ConvertMessageToValues(message_definition, message)
	local value_table = {}
	local i = 1
	local sum_of_prev_sizes = 0
	repeat
		local current_def = message_definition.message[i]
		local current_values = {}
		local size = current_def.size / current_def.value_count

		if current_def.size % current_def.value_count == 0 then
			for k=0,current_def.value_count-1 do
				local piece = string.sub(message, sum_of_prev_sizes + k*size + 1, sum_of_prev_sizes + k*size + size)
				local value = 0
				
				if current_def.scale_to_bounds then
					value = DecodeBase255(piece) / BASE255_MAX_SIZES[size]
					value = value * current_def.bounds_length + current_def.bounds[1]
				else
					value = DecodeBase255(piece)
				end
				if current_def.int then
					value = CheckValueBounds(RoundToInt(value), current_def.bounds[1], current_def.bounds[2])
				end
				table.insert(current_values, value)
			end

		else
			if current_def.size > 8 then print("Error: A part of a message has a size that when modulo by the number of values is performed onto it the output is != 0. And the size is over 8. Shit's gonna break.") end

			local piece = string.sub(message, sum_of_prev_sizes + 1, sum_of_prev_sizes + current_def.size)

			local packed_numbers = RoundToInt( DecodeBase255(piece) / BYTE_TO_BASE255_CONV_SCALES[current_def.size] )

			current_values = UnpackBytesIntoTable(packed_numbers, current_def.value_count, current_def.size)

			for k,v in pairs(current_values) do
				current_values[k] = current_values[k] * current_def.bounds_length + current_def.bounds[1]
			end
		end
		sum_of_prev_sizes = sum_of_prev_sizes + current_def.size
		table.insert(value_table, current_values)
		i = i + 1
	until message_definition.message[i] == nil

	return value_table
end
