--- sapp api translation
if sapp_version ~= nil then

	api_version = "1.9.0.0"
	host = true

	--callbacks
	function OnScriptLoad()
		register_callback(cb['EVENT_GAME_END'], "OnGameEnd")
		register_callback(cb['EVENT_GAME_END'], "OnGameStart")
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

-- chimera api additions
elseif sandboxed ~= nil then

	--callbacks
	set_callback('map load', "OnMapLoad")
	set_callback('rcon message', "OnRconMessage")
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

	cprint = console_out

end

-- used for parsing and conversion
types = {
	u8    = { read = read_u8   , write = write_u8   , int = true , bounds = {0,255} },
	i8    = { read = read_i8   , write = write_i8   , int = true , bounds = {-127,127} },

	u16   = { read = read_u16  , write = write_u16  , int = true , bounds = {0,65535} },
	i16   = { read = read_i16  , write = write_i16  , int = true , bounds = {-32767,32767} },

	u32   = { read = read_u32  , write = write_u32  , int = true , bounds = {0,4294967295} },
	i32   = { read = read_i32  , write = write_i32  , int = true , bounds = {-2147483647,2147483647} },

	f32   = { read = read_f32  , write = write_f32  , int = false },
	vec3d = { read = read_vec3d, write = write_vec3d, int = false, value_count = 3 }

}
-- shared functions

function GetMessageSize(message_struct)
	local sum = 0
	entry = 1
	-- we do a while loop here because the k,v in pairs() method iterates over named table entries, and we don't want that.
	repeat
		sum = sum + message_struct[entry].size
		entry = entry + 1
	until message_struct[entry] == nil
	return sum
end

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

function RoundToInt(number)
	if number % 1 < 0.5 then
		return math.floor(number)
	else
		return math.ceil(number)
	end
end

-- offsets in halo memory

def_object = {
	tag_id = { offset = 0, type = types.u32 },
	position = { offset = 0x5C, type = types.vec3d, bounds = {-5000,5000} },
	velocity = { offset = 0x68, type = types.vec3d, bounds = {-2.5,2.5} },
	rotation = { offset = 0x74, type = types.vec3d, bounds = {-1,1} },
	type = { offset = 0xB4, type = types.u16 },
	animation_id = { offset = 0xD0, type = types.u16},
	animation_frame = { offset = 0xD2, type = types.u16},
	health = { offset = 0xE0, type = types.f32, bounds = {0,1} },
	shield = { offset = 0xE4, type = types.f32, bounds = {0,3} },
	health_region1 = { offset = 0x178, type = types.u8 },
	health_region2 = { offset = 0x179, type = types.u8 },
	health_region3 = { offset = 0x17A, type = types.u8 },
	health_region4 = { offset = 0x17B, type = types.u8 },
	health_region5 = { offset = 0x17C, type = types.u8 },
	health_region6 = { offset = 0x17D, type = types.u8 },
	health_region7 = { offset = 0x17E, type = types.u8 },
	health_region8 = { offset = 0x17F, type = types.u8 },
	color_change_a = { offset = 0x188, type = types.vec_3d, bounds = {0,1}},
	color_change_b = { offset = 0x194, type = types.vec_3d, bounds = {0,1}},
	color_change_c = { offset = 0x1A0, type = types.vec_3d, bounds = {0,1}},
	color_change_d = { offset = 0x1AC, type = types.vec_3d, bounds = {0,1}},
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
		weapon_4_object_id = { offset = 0x304, type = types.i16 }
	}
}

-- message definitions

bipd_baseline_message_def = {
	{ def_object.position, size = 4*3 },
	{ def_object.velocity, size = 3*3 },
	{ def_object.rotation, size = 1*3 },

	{ def_object.animation_id, size = 2 },
	{ def_object.animation_frame, size = 2 },
	{ def_object.unit.facing, size = 1*3 },
	{ def_object.unit.desired_aim, size = 1*3 },

	{ def_object.unit.animation_state, size = 1 },
	{ def_object.unit.shooting, size = 1 },

	actions_when_recieved = {
		{ def_object.unit.aim, copy_from = def_object.unit.facing }
	},
} bipd_baseline_message_def.size = GetMessageSize(bipd_baseline_message_def)


bipd_action_message_def = {
	{ def_object.position, size = 4*3 },
	{ def_object.rotation, size = 1*3 },

	{ def_object.animation_id, size = 2 },
	{ def_object.unit.desired_aim, size = 1*3},

	{ def_object.unit.animation_state, size = 1 },
	{ def_object.unit.shooting, size = 1 },

	actions_when_recieved = {
		{ def_object.animation_frame, set_to = 0 },
		{ def_object.unit.facing, copy_from = def_object.unit.desired_aim },
		{ def_object.unit.aim, copy_from = def_object.unit.desired_aim }
	},
} bipd_action_message_def.size = GetMessageSize(bipd_action_message_def)


bipd_rotation_message_def = {
	{ def_object.unit.facing, size = 1*3 },
	{ def_object.unit.desired_aim, size = 1*3 },
	{ def_object.unit.shooting, size = 1 },

	actions_when_recieved = {
		{ def_object.unit.aim, copy_from = def_object.unit.facing }
	},
} bipd_rotation_message_def.size = GetMessageSize(bipd_rotation_message_def)


bipd_spawn_message_def = {
	{ def_object.color_change_a, size = 1*3, copy_from_cached_value = true },
	{ def_object.weapon_1_object_id, size = 3, convert_object_id_to_tag_id = true },

	action_when_recieved = {
		{ def_object.weapon_1_object_id, make_child_object_from_tag_id = true } -- set_to = spawn_object and parent it to the biped
	},
} bipd_spawn_message_def.size = GetMessageSize(bipd_spawn_message_def)


proj_spawn_message_def = {
	{ def_object.position, size = 4*3 },
	{ def_object.velocity, size = 3*3 },
} proj_spawn_message_def.size = GetMessageSize(proj_spawn_message_def)
