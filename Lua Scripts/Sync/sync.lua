bipd_baseline_msg_size = nil
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
	-- commented out since the game might update this for us --1, 1,    -- health/shield
	1        -- shooting
} -- 33

bipd_action_msg_size = nil
bipd_action_sizes = {
	1,       -- id
	1,       -- uid
	4, 4, 4, -- pos_x,y,z 28 bit ints that use a range of -5000 to 5000 wo
	1, 1, 1, -- rotation i,j,k
	1, 1, 1, -- look i,j,k
	1        -- shooting
} -- 21

bipd_rot_msg_size = nil
bipd_rot_sizes = {
	1,       -- id
	1,       -- uid
	1, 1, 1, -- rotation i,j,k
	1, 1, 1, -- look i,j,k
	1        -- shooting
} -- 9

bipd_spawn_msg_size = nil
bipd_spawn_sizes = {
	1,       -- id
	1,       -- uid
	1, 1, 1, -- real color
	3        -- weapon tag id
} -- 8

proj_spawn_msg_size = nil
proj_spawn_sizes = {
	1,       -- id
	1,       -- uid
	4, 4, 4, -- pos_x,y,z
	
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
bip_baseline_msg_size = GetSumOfSizeList(bip_baseline_sizes)
print("bip_baseline_msg_size " .. bip_baseline_msg_size)
bip_action_msg_size = GetSumOfSizeList(bip_action_sizes)
print("bip_action_msg_size " .. bip_action_msg_size)
bip_rot_msg_size = GetSumOfSizeList(bip_rot_sizes)
print("bip_rot_msg_size " .. bip_rot_msg_size)
bip_spawn_msg_size = GetSumOfSizeList(bip_spawn_sizes)
print("bip_spawn_msg_size " .. bip_spawn_msg_size)


