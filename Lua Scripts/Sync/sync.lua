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
	
end

-- used for parsing and conversion
types = {
	u8    = { r = read_u8   , w = write_u8   , round = true  },
	u16   = { r = read_u16  , w = write_u16  , round = true  },
	u32   = { r = read_u32  , w = write_u32  , round = true  },
	f32   = { r = read_f32  , w = write_f32  , round = false },
	vec3d = { r = read_vec32, w = write_vec32, round = false }
}
-- shared functions

function GetSumOfSizeList(list)
	local sum = 0
	for k,v in pairs(list) do
		sum = sum + list[k]
	end
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

-- structures

bipd_baseline_sizes = {
	1,       -- id
	1,       -- uid
	4, 4, 4, -- pos_x,y,z 28 bit ints that use a range of -5000 to 5000 wo
	1, 1, 1, -- rotation i,j,k
	1, 1, 1, -- look i,j,k
	3, 3, 3, -- velocity (Bound by 2.5 wo)
	1,       -- anim frame
	1,       -- anim id
	1,       -- unit state
	1        -- shooting
} -- 33
bipd_baseline_msg_size = GetSumOfSizeList(bipd_baseline_sizes)


bipd_action_sizes = {
	1,       -- id
	1,       -- uid
	4, 4, 4, -- pos_x,y,z 28 bit ints that use a range of -5000 to 5000 wo
	1, 1, 1, -- rotation i,j,k
	1, 1, 1, -- look i,j,k
	1        -- shooting
} -- 21
bipd_action_msg_size = GetSumOfSizeList(bipd_action_sizes)


bipd_rot_sizes = {
	1,       -- id
	1,       -- uid
	1, 1, 1, -- rotation i,j,k
	1, 1, 1, -- look i,j,k
	1        -- shooting
} -- 9
bipd_rot_msg_size = GetSumOfSizeList(bipd_rot_sizes)


bipd_spawn_sizes = {
	1,       -- id
	1,       -- uid
	1, 1, 1, -- real color
	3        -- weapon tag id
} -- 8
bipd_spawn_msg_size = GetSumOfSizeList(bipd_spawn_sizes)


proj_spawn_sizes = {
	1,       -- id
	1,       -- uid
	4, 4, 4, -- pos_x,y,z
}
proj_spawn_msg_size = GetSumOfSizeList(proj_spawn_sizes)



print("bip_baseline_msg_size " .. bipd_baseline_msg_size)
print("bip_action_msg_size " .. bipd_action_msg_size)
print("bip_rot_msg_size " .. bipd_rot_msg_size)
print("bip_spawn_msg_size " .. bipd_spawn_msg_size)


