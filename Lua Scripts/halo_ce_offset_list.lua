-- Addresses and Offsets
-- Created by Wizard, edited by aLTis
-- This version is maintained by gbMichelle


function OnScriptLoad(process, Game, persistent)

	GetGameAddresses(Game) -- declare addresses and confirm the game (pc or ce)
	game = Game
	-- gametype info

	local gametype_name = readwidestring(gametype_base, 0x2C) -- Confirmed. Real name of gametype.
	local gametype_game = read_byte(gametype_base + 0x30) -- Confirmed. (CTF = 1) (Slayer = 2) (Oddball = 3) (KOTH = 4) (Race = 5)
	local gametype_team_play = read_byte(gametype_base + 0x34) -- Confirmed. (Off = 0) (On = 1)
	--	gametype parameters
		local gametype_other_players_on_radar = read_bit(gametype_base + 0x38, 0) -- Confirmed. (On = True, Off = False)
		local gametype_friends_indicator = read_bit(gametype_base + 0x38, 1) -- Confirmed. (On = True, Off = False)
		local gametype_infinite_grenades = read_bit(gametype_base + 0x38, 2) -- Confirmed. (On = True, Off = False)
		local gametype_shields = read_bit(gametype_base + 0x38, 3) -- Confirmed. (Off = True, On = False)
		local gametype_invisible_players = read_bit(gametype_base + 0x38, 4) -- Confirmed. (On = True, Off = False)
		local gametype_starting_equipment = read_bit(gametype_base + 0x38, 5) -- Confirmed. (Generic = True, Custom = False)
		local gametype_only_friends_on_radar = read_bit(gametype_base + 0x38, 6) -- Confirmed.
	--	unkBit[7] 0. - always 0?
	local gametype_indicator = read_byte(gametype_base + 0x3C) -- Confirmed. (Motion Tracker = 0) (Nav Points = 1) (None = 2)
	local gametype_odd_man_out = read_byte(gametype_base + 0x40) -- Confirmed. (No = 0) (Yes = 1)
	local gametype_respawn_time_growth = read_dword(gametype_base + 0x44) -- Confirmed. (1 sec = 30 ticks)
	local gametype_respawn_time = read_dword(gametype_base + 0x48) -- Confirmed. (1 sec = 30 ticks)
	local gametype_suicide_penalty = read_dword(gametype_base + 0x4C) -- Confirmed. (1 sec = 30 ticks)
	local gametype_lives = read_byte(gametype_base + 0x50) -- Confirmed. (Unlimited = 0)
	local gametype_maximum_health = read_float(gametype_base + 0x54) -- Confirmed.
	local gametype_score_limit = read_byte(gametype_base + 0x58) -- Confirmed.
	local gametype_weapons = read_byte(gametype_base + 0x5C) -- Confirmed. (Normal = 0) (Pistols = 1) (Rifles = 2) (Plasma Weapons = 3) (Sniper = 4) (No Sniping = 5) (Rocket Launchers = 6) (Shotguns = 7) (Short Range = 8) (Human = 9) (Convenant = 10) (Classic = 11) (Heavy Weapons = 12)
	local gametype_red_vehicles = read_dword(gametype_base + 0x60) -- (???) Binary?
	local gametype_blue_vehicles = read_dword(gametype_base + 0x64) -- (???) Binary?
	local gametype_vehicle_respawn_time = read_dword(gametype_base + 0x68) -- Confirmed. (1 sec = 30 ticks)
	local gametype_friendly_fire = read_byte(gametype_base + 0x6C) -- Confirmed. (Off = 0) (On = 1)
	local gametype_friendly_fire_penalty = read_dword(gametype_base + 0x70) -- Confirmed. (1 sec = 30 ticks)
	local gametype_auto_team_balance = read_byte(gametype_base + 0x74) -- Confirmed. (Off = 0) (On = 1)
	local gametype_time_limit = read_dword(gametype_base + 0x78) -- Confirmed. (1 sec = 30 ticks)
	local gametype_ctf_assault = read_byte(gametype_base + 0x7C) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_koth_moving_hill = read_byte(gametype_base + 0x7C) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_oddball_random_start = read_byte(gametype_base + 0x7C) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_race_type = read_byte(gametype_base + 0x7C) -- Confirmed. (Normal = 0) (Any Order = 1) (Rally = 2)
		local gametype_slayer_death_bonus = read_byte(gametype_base + 0x7c) -- Confirmed. (Yes = 0) (No = 1)
	local gametype_slayer_kill_penalty = read_byte(gametype_base + 0x7D) -- Confirmed. (Yes = 0) (No = 1)
	local gametype_ctf_flag_must_reset = read_byte(gametype_base + 0x7E) -- Confirmed. (No = 0) (Yes = 1)
		local gametype_slayer_kill_in_order = read_byte(gametype_base + 0x7E) -- Confirmed. (No = 0) (Yes = 1)
	local gametype_ctf_flag_at_home_to_score = read_byte(gametype_base + 0x7F) -- Confirmed. (No = 0) (Yes = 1)
	local gametype_ctf_single_flag_time = read_dword(gametype_base + 0x80) -- Confirmed. (1 sec = 30 ticks)
		local gametype_oddball_speed_with_ball = read_byte(gametype_base + 0x80) -- Confirmed. (Slow = 0) (Normal = 1) (Fast = 2)
		local gametype_race_team_scoring = read_byte(gametype_base + 0x80) -- Confirmed. (Minimum = 0) (Maximum = 1) (Sum = 2)
	local gametype_oddball_trait_with_ball = read_byte(gametype_base + 0x84) -- Confirmed. (None = 0) (Invisible = 1) (Extra Damage = 2) (Damage Resistant = 3)
	local gametype_oddball_trait_without_ball = read_byte(gametype_base + 0x88) -- Confirmed. (None = 0) (Invisible = 1) (Extra Damage = 2) (Damage Resistant = 3)
	local gametype_oddball_ball_type = read_byte(gametype_base + 0x8C) -- Confirmed. (Normal = 0) (Reverse Tag = 1) (Juggernaut = 2)
	local gametype_oddball_ball_spawn_count = read_byte(gametype_base + 0x90) -- Confirmed.
	
	--mapcycle header
	mapcycle_pointer = read_dword(mapcycle_header) -- (???) index * 0xA4 + 0xC + this = something.
	mapcycle_total_indicies = read_dword(mapcycle_header + 0x4) -- From DZS. Number of options in the mapcycle.
	mapcycle_total_indicies_allocated = read_dword(mapcycle_header + 0x8) -- From Phasor.
	mapcycle_current_index = read_dword(mapcycle_header + 0xC) -- Confirmed. Current mapcycle index.
	
	--mapcycle struct
	mapcycle_something = readwidestring(mapcycle_pointer + mapcycle_current_index * 0xE4 + 0xC) -- (???) LOTS OF BAADF00D!
	mapcycle_current_map_name = read_string(read_dword(mapcycle_pointer)) -- Confirmed. Real name of the map.
	mapcycle_current_gametype_name = read_string(read_dword(mapcycle_pointer + 0x4)) -- Confirmed. Real name of the gametype. Case-sensitive.
	mapcycle_current_gametype_name2 = readwidestring(mapcycle_pointer + 0xC) -- Confirmed. Real name of gametype. Case-sensitive.
	
	--Server globals
	server_initialized = read_bit(network_server_globals, 0) -- Tested.
	server_last_display_time = read_dword(network_server_globals + 0x4) -- From OS.
	server_password = read_string(network_server_globals + 0x8, 8) -- Confirmed.
	server_single_flag_force_reset = read_bit(network_server_globals + 0x10, 0) -- Confirmed.
	server_banlist_path = read_string(network_server_globals + 0x1C) -- Confirmed. Path to the banlist file.
	server_friendly_fire_type = read_word(network_server_globals + 0x120) -- Tested. Something to do with the friendly fire.
	server_rcon_password = read_string(network_server_globals + 0x128) -- Confirmed.
	if game == "CE" then
		server_motd_filename = read_string(network_server_globals + 0x13C, 0x100) -- From OS.
		server_motd_contents = read_string(network_server_globals + 0x23C, 0x100) -- From OS.
	end

	--gameinfo header
	gameinfo_base = read_dword(gameinfo_header)
	--unkLong[1] 0x4 (???) Always 0?
	--unkFloat[2] 0x8 (???)
	--unkLong[9] 0x10 (???)
	--unkFloat[2] 0x34 (???)
	
	--gameinfo struct (someone should really help me with names lol)
	gameinfo_initialized = read_bit(gameinfo_base, 0) -- Confirmed. If the game is started or in standby. (1 if started, 0 if not)
	gameinfo_active = read_bit(gameinfo_base, 1) -- Confirmed. If the game is currently running (Active = True, Not Active = False)
	gameinfo_paused = read_bit(gameinfo_base, 2) -- From OS.
	--Padding[2]
	--unkWord[3] (???)
	gameinfo_time_passed = read_dword(gameinfo_base + 0xC) -- Confirmed (1 second = 30 ticks)
	gameinfo_elapsed_time = read_dword(gameinfo_base + 0x10) -- From OS.
	gameinfo_server_time = read_dword(gameinfo_base + 0x14) -- Confirmed. Same as gameinfo_time_passed, except it lags behind.
	gameinfo_server_speed = read_dword(gameinfo_base + 0x18) -- Confirmed. Changing this would be the same as cheatengining the server and messing with speedhack control.
	gameinfo_leftover_time = read_dword(gameinfo_base + 0x1C) -- From OS. Not sure what this is. Changes frequently.
	--unkLong[39] 0x20 don't care enough to continue.
	
	--banlist header
	banlist_size = read_dword(banlist_header)
	banlist_base = read_dword(banlist_header + 0x4)
	
	--banlist struct
	banlist_struct_size = 0x44
	for j = 1,banlist_size do
		ban_name = readwidestring(banlist_base + j * 0x44, 13) -- Confirmed. Name of banned player.
		ban_hash = read_string(banlist_base + j * 0x44 + 0x1A, 32) -- Confirmed. Hash of banned player.
		ban_some_bool = read_bit(banlist_base + j * 0x44 + 0x3A, 0) -- (???)
		ban_count = read_word(banlist_base + j * 0x44 + 0x3C) -- Confirmed. How many times the specified player has been banned.
		ban_indefinitely = read_bit(banlist_base + j * 0x44 + 0x3E, 0) -- Confirmed. 1 if permanently banned, 0 if not.
		ban_time = read_dword(banlist_base + j * 0x44 + 0x40) -- Confirmed. Ban end date.
	end
	
	--String/data addresses that aren't in a struct/header (to my knowledge).
	server_broadcast_version = read_string(broadcast_version_address) -- Confirmed. Version that the server is broadcasting on.
	version_info = read_string(version_info_address, 0x2A) -- Confirmed. Some version info for halo
	halo_broadcast_game = read_string(broadcast_game_address, 5) -- Confirmed. Basically determines whether the server will broadcast on PC/CE/Trial ("halor" = PC, "halom" = CE, "halo?" = Trial).
	server_port = read_dword(server_port_address) -- Confirmed. Port that the server is broadcasting on.
	server_path = read_string(server_path_address) -- Confirmed. Path to the server's haloded.exe
	server_computer_name = read_string(computer_name_address) -- Confirmed. Server Computer (domain) name.
	profile_path = read_string(profile_path_address) -- Confirmed. Path to the profile path.
	map_name = readwidestring(map_name_address) -- Confirmed. Halo's map name (e.g. Blood Gulch)
	computer_specs = read_string(computer_specs_address) -- Confirmed. Some address I found that stores information about the server (processor speed, brand)
	map_name2 = read_string(map_name_address2) -- Confirmed. Map file name. (e.g. bloodgulch)
	server_password = read_string(server_password_address, 8) -- Confirmed. Current server password for the server (will be nullstring if there is no password)
	banlist_path = read_string(banlist_path_address) -- Confirmed. Path to the banlist file.
	rcon_password = read_string(rcon_password_address, 8) -- Confirmed. Current rcon password for the server.
	
	-- random unuseful crap (string stuff) don't care enough to do CE
	-- don't know why I even cared enough to write these down.
	if game == "PC" then
		halo_profilepath_cmdline = read_string(0x5D45B0, 5) -- Confirmed. The -path cmdline string.
		halo_cpu_cmdline = read_string(0x5E4760, 4) -- Confirmed. The -cpu cmdline string.
		halo_broadcast_game = read_string(0x5E4768, 5) -- Confirmed. Basically determines whether the server will broadcast on PC/CE/Trial ("halor" = PC, "halom" = CE, "halo?" = Trial).
		halo_ip_cmdline = read_string(0x5E4770, 3) -- Confirmed. The -ip cmdline string.
		halo_port_cmdline = read_string(0x5E4774, 5) -- Confirmed. The -port cmdline string.
		halo_checkfpu_cmdline = read_string(0x5E477C, 9) -- Confirmed. The -checkfpu cmdline string.
		halo_windowname = read_string(0x5E4788, 4) -- "The console windowname and classname (basically windowtitle, always 'Halo Console (#)').
		--0x5E4790 - 0x5E473C is registry key stuff
		halo_dw15_exe_path = read_string(0x5E4940, 26) --Confirmed. Path to dw15.exe (.\Watson\dw15.exe -x -s %u) probably from client code.
		--other random crap/strings here
	end

end

-- All of these are confirmed, unless said otherwise.
function GetGameAddresses(game)

	if game == "PC" then
		-- Structs/Headers.
		stats_header = 0x639720
		stats_globals = 0x639898
		ctf_globals = 0x639B98
		slayer_globals = 0x63A0E8
		oddball_globals = 0x639E58
		koth_globals = 0x639BD0
		race_globals = 0x639FA0
		race_locs = 0x670F40
		map_pointer = 0x63525C
		gametype_base = 0x671340
		network_struct = 0x745BA0
		camera_base = 0x69C2F8
		player_header_pointer = 0x75ECE4
		obj_header_pointer = 0x744C18
		collideable_objects_pointer = 0x744C34
		map_header_base = 0x630E74
		banlist_header = 0x641280
		game_globals = "???" -- (???) Why do I not have this for PC?
		gameinfo_header = 0x671420
		mapcycle_header = 0x614B4C
		network_server_globals = 0x69B934
		flags_pointer = 0x6A590C
		hash_table_base = 0x6A2AE4
		
		-- String/Data Addresses.
		broadcast_version_address = 0x5DF840
		version_info_address = 0x5E02C0
		broadcast_game_address = 0x5E4768
		server_port_address = 0x625230
		server_path_address = 0x62C390
		computer_name_address = 0x62CD60
		profile_path_address = 0x635610
		map_name_address = 0x63BC78
		computer_specs_address = 0x662D04
		map_name_address2 = 0x698F21
		server_password_address = 0x69B93C
		banlist_path_address = 0x69B950
		rcon_password_address = 0x69BA5C

		--Patches
		gametype_patch = 0x481F3C -- I 'thought' this worked but haven't tested in ages.
		hashcheck_patch = 0x59c280
		servername_patch = 0x517D6B
		versioncheck_patch = 0x5152E7
	else
		-- Structs/headers.
		stats_header = 0x5BD740
		stats_globals = 0x5BD8B8
		ctf_globals = 0x5BDBB8
		slayer_globals = 0x5BE108
		oddball_globals = 0x5BDE78
		koth_globals = 0x5BDBF0
		race_globals = 0x5BDFC0
		race_locs = 0x5F5098
		map_pointer = 0x5B927C
		gametype_base = 0x5F5498
		network_struct = 0x6C7980
		camera_base = 0x62075C
		player_globals = 0x6E1478 -- From OS.
		player_header_pointer = 0x6E1480
		obj_header_pointer = 0x6C69F0
		collideable_objects_pointer = 0x6C6A14
		map_header_base = 0x6E2CA4
		banlist_header = 0x5C52A0
		game_globals = 0x61CFE0 -- (???)
		gameinfo_header = 0x5F55BC
		mapcycle_header = 0x598A8C
		network_server_globals = 0x61FB64
		hash_table_base = 0x5AFB34
		
		-- String/Data Addresses.
		broadcast_version_address = 0x564B34
		version_info_address = 0x565104
		broadcast_game_address = 0x569EAC
		server_port_address = 0x5A91A0
		server_path_address = 0x5B0670
		computer_name_address = 0x5B0D40
		profile_path_address = 0x5B9630
		map_name_address = 0x5BFC98
		computer_specs_address = 0x5E6E5C
		map_name_address2 = 0x61D151
		server_password_address = 0x61FB6C
		banlist_path_address = 0x61FB80
		rcon_password_address = 0x61FC8C
		

		--Patches
		hashcheck_patch = 0x530130
		servername_patch = 0x4CE0CD
		versioncheck_patch = 0x4CB587
	end
end

function OnClientUpdate(player, m_objectId)

	local thisHash = gethash(player)
	local team = getteam(player)

	if thisHash ~= nil then

		-- Confirmed/tested addresses and offsets
		-- teams: red = 0, blue = 1
		
		--stats header (size = 0x178 = 376 bytes)
		--This header is seriously unfinished.
		stats_header_recorded_animations_data = read_dword(stats_header + 0x0) -- Confirmed. Pointer to Recorded Animations data table.
		--unkByte[4] 0x4-0x8 (Zero's)
		stats_header_last_decal_location_x = read_float(stats_header + 0x8) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y = read_float(stats_header + 0xC) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x2 = read_float(stats_header + 0x10) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y2 = read_float(stats_header + 0x14) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x3 = read_float(stats_header + 0x18) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y3 = read_float(stats_header + 0x1C) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x4 = read_float(stats_header + 0x20) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y4 = read_float(stats_header + 0x24) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x5 = read_float(stats_header + 0x28) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y5 = read_float(stats_header + 0x2C) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_x6 = read_float(stats_header + 0x30) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location_y6 = read_float(stats_header + 0x34) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		--unkByte[48] 0x38-0x68 (Zero's)
		stats_header_last_decal_location2_x = read_float(stats_header + 0x68) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y = read_float(stats_header + 0x6C) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x2 = read_float(stats_header + 0x70) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y2 = read_float(stats_header + 0x74) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x3 = read_float(stats_header + 0x78) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y3 = read_float(stats_header + 0x7C) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x4 = read_float(stats_header + 0x80) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y4 = read_float(stats_header + 0x84) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x5 = read_float(stats_header + 0x88) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y5 = read_float(stats_header + 0x8C) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_x6 = read_float(stats_header + 0x90) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		stats_header_last_decal_location2_y6 = read_float(stats_header + 0x94) -- From Silentk. World coordinates of the last bullet/nade hit anywhere on map x,y, applies to BSP only, not objects
		--unkFloat[2] 0x98-0xA0 (???)
		--unkByte[40] 0xA0-0xC8 (Zero's)
		stats_header_decalID_table = read_dword(stats_header + 0xC8) -- From Silentk. Pointer to an array of Decal ID's (correlates with LastDecalLocation)
		--unkPointer[1] 0xCC-0xD0 (???)
		--unkByte[20] 0xD0-0xE4 (???)
		stats_header_locationID = read_dword(stats_header + 0xE4) -- From Silentk
		stats_header_locationID2 = read_dword(stats_header + 0xE8) -- From Silentk
		--unkLong[1] 0xEC-0xF0 (???)
		--unkByte[130] 0xF0-0x172 (Zero's)
		--unkPointer[2] 0x172-0x17A
		
		--stats struct (size = 0x30 = 48 bytes)
		stats_base = stats_globals + player*0x30
		stats_player_ingame = read_byte(stats_base + 0x0) -- From Silentk (1 = Ingame, 0 if not)
		--unkByte[3] 0x1-0x4 (???)
		stats_player_id = readident(stats_base, 0x4) --Confirmed. Full DWORD ID of player.
		stats_player_kills = read_word(stats_base + 0x8) -- Confirmed.
		--unkByte[6] 0xA-0x10 (???)
		stats_player_assists = read_word(stats_base + 0x10) -- From Silentk
		--unkByte[6] 0x12-0x18 (???)
		stats_player_betrays = read_word(stats_base + 0x18) -- From Silentk. Actually betrays + suicides.
		stats_player_deaths = read_word(stats_base + 0x1A) -- From Silentk Everytime you die, no matter what..
		stats_player_suicides = read_word(stats_base + 0x1C) -- Confirmed.
		stats_player_flag_steals = read_word(stats_base + 0x1E) -- From Silentk. Flag steals for CTF.
			stats_player_hill_time = read_word(stats_base + 0x1E) -- Confirmed. Time for KOTH. (1 sec = 30 ticks)
			stats_player_race_time = read_word(stats_base + 0x1E) -- Guess. Time for Race. (1 sec = 30 ticks)
		stats_player_flag_returns = read_word(stats_base + 0x20) -- From Silentk. Flag returns for CTF.
			stats_player_oddball_target_kills = read_word(stats_base + 0x20) -- Guess. Number of times you killed the Juggernaut or It.
			stats_player_race_laps = read_word(stats_base + 0x20) -- Guess. Laps for Race.
		stats_player_flag_scores = read_word(stats_base + 0x22) -- From Silentk. Flag scores for CTF.
			stats_player_oddball_kills = read_word(stats_base + 0x22) -- Guess. Number of kills you have as Juggernaut or It.
			stats_player_race_best_time = read_word(stats_base + 0x22) -- Guess. Best time for Race. (1 sec = 30 ticks)
		--unkByte[12] 0x24-0x30 (???)

		-- ctf globals (size = 0x34 = 52 bytes)
		ctf_flag_coords_pointer = read_dword(ctf_globals + team*4) -- Confirmed. Pointer to the coords where the flag respawns.
			ctf_flag_x_coord = read_float(ctf_flag_coords_pointer) -- Confirmed.
			ctf_flag_y_coord = read_float(ctf_flag_coords_pointer + 0x4) -- Confirmed.
			ctf_flag_z_coord = read_float(ctf_flag_coords_pointer + 0x8) -- Confirmed.
		ctf_flag_object_id = readident(ctf_globals + team*4 + 0x8) -- Confirmed.
		ctf_team_score = read_dword(ctf_globals + team*4 + 0x10) -- Confirmed.
		ctf_score_limit = read_dword(ctf_globals + 0x18) -- Confirmed.
		ctf_team_missing_flag_bool = read_bit(ctf_globals + 0x1C+team, 0) -- Confirmed. (True if team doesn't have flag, False if their flag is at home)
		ctf_flag_istaken_red_soundtimer = read_dword(ctf_globals + 0x20) -- Confirmed. (Announcer repeats 'Red team, has the flag' after this number gets to 600 ticks = 20 seconds)
		ctf_flag_istaken_blue_soundtimer = read_dword(ctf_globals + 0x24) -- Confirmed. (Announcer repeats 'Blue team, has the flag' after this number gets to 600 ticks = 20 seconds)
		ctf_flag_swap_timer = read_dword(ctf_globals + 0x28) -- Confirmed. Single flag only. Counts down until 0, then offense team swaps with defense team. (1 second = 30 ticks)
		ctf_failure_timer = read_dword(ctf_globals + 0x2C)-- From OS. Sound timer for failure. Counts down until 0. (1 second = 30 ticks)
		ctf_team_on_defense = read_byte(ctf_globals + 0x30) -- Confirmed. Team on defense (single flag gametypes) (Red = 0, Blue = 1)

		--koth globals (size = 0x200 = 512 bytes)
		--Reminder: There are 16 teams in FFA, one for each person.
		koth_team_score = read_dword(koth_globals + team*4) -- Confirmed. (1 second = 30 ticks)
		koth_team_last_time_in_hill = read_dword(koth_globals + player*4 + 0x40) -- Confirmed. gameinfo_current_time - this = time since team was last in the hill. (1 sec = 30 ticks)
		koth_player_in_hill = read_byte(koth_globals + player + 0x80) -- Confirmed. (1 if in hill, 0 if not)
		koth_hill_marker_count = read_dword(koth_globals + 0x90) -- Confirmed. Number of hill markers.
		--These are coordinates for each hill marker
		for i = 0,koth_hill_marker_count-1 do
			koth_hill_marker_x_coord = read_float(koth_globals + i*4 + 0x94) -- X coordinate for hill marker
			koth_hill_marker_y_coord = read_float(koth_globals + i*4 + 0x98) -- Y coordinate for hill marker
			koth_hill_marker_z_coord = read_float(koth_globals + i*4 + 0x9C) -- Z coordinate for hill marker
		end
		--wth... these are coordinates but they're 2 dimensional, no z axis. Probably just the area that determines if you are in a hill
		for i = 0,koth_hill_marker_count-1 do
			koth_hill_marker_x_coord2 = read_float(koth_globals + i*4 + 0x124) -- Tested. X coordinate for 2d hill.
			koth_hill_marker_y_coord2 = read_float(koth_globals + i*4 + 0x128) -- Tested. Y coordinate for 2d hill.
		end
		koth_center_of_hill_x_coord = read_float(koth_globals + 0x184) -- Confirmed. Center of hill X.
		koth_center_of_hill_y_coord = read_float(koth_globals + 0x188) -- Confirmed. Center of hill Y.
		koth_center_of_hill_z_coord = read_float(koth_globals + 0x18C) -- Confirmed. Center of hill Z.
		--unkLong[4] 0x190 (???)
		koth_move_timer = read_dword(koth_globals + 0x200) -- Confirmed. (1 second = 30 ticks)

		-- oddball globals
		oddball_score_to_win = read_dword(oddball_globals) -- Confirmed.
		oddball_team_score = read_dword(oddball_globals + team*4 + 0x4) -- Confirmed. There's actually 16 teams if the gametype is FFA.
		oddball_player_score = read_dword(oddball_globals + player*4 + 0x44) -- Confirmed.
		--oddball_something = read_dword(oddball_globals + player*4 + 0x64) -- (???)
		oddball_ball_indexes = read_dword(oddball_globals + 0x84) -- Tested. Idk what this is for but it holds oddball indexes that are differentiated by 0x1C2.
			oddball_it_people = read_dword(oddball_globals + 0x84) -- Tested. It's filled with stuff depending on the amount of 'it' people in jugg/tag
		oddball_player_holding_ball = readident(oddball_globals + player*4 + 0xC4) -- Confirmed.
		oddball_player_time_with_ball = read_dword(oddball_globals + player*4 + 0x104) -- Confirmed. (1 second = 30 ticks)

		--race globals
		race_checkpoint_count = read_dword(race_globals) -- Confirmed. Total number of checkpoints required for a lap. Stored very awkwardly. (0x1 = 1, 0x3 = 2, 0x7 = 3, 0xF = 4, 0x1F = 5 etc)
		race_player_current_checkpoint = read_dword(race_globals + player*4 + 0x44) -- Confirmed. Current checkpoint the player needs to go to. Stored very awkwardly. (0x1 = first checkpoint, 0x3 = second checkpoint, 0x7 = 3rd checkpoint, 0xF = 4th checkpoint, 0x1F = 5th checkpoint etc)
		race_team_score = read_dword(race_globals + team*4 + 0x88) -- Confirmed.

		--race checkpoint locations
		for i = 0,race_checkpoint_count do
			race_checkpoint_x_coord = read_float(race_locs + i*0x20) -- Confirmed.
			race_checkpoint_y_coord = read_float(race_locs + i*0x20 + 0x4) -- Confirmed.
			race_checkpoint_z_coord = read_float(race_locs + i*0x20 + 0x8) -- Confirmed.
		end

		--slayer globals
		slayer_team_score = read_dword(slayer_globals + team*4) -- Confirmed.
		slayer_player_score = read_dword(slayer_globals + player*4 + 0x40) -- Confirmed.
		slayer_game = read_byte(slayer_globals + 0x20) -- Tested. I think its always 1. I guess 1 if slayer, 0 if not? Something like that.

		-- camera struct
		camera_size = 0x30
		camera_xy = read_float(camera_base + player*camera_size)
		camera_z = read_float(camera_base + player*camera_size + 0x4)
		camera_x_aim = read_float(camera_base + player*camera_size + 0x1C)
		camera_y_aim = read_float(camera_base + player*camera_size + 0x20)
		camera_z_aim = read_float(camera_base + player*camera_size + 0x24)

		-- mp flags table (race checkpoints, hill markers, vehicle spawns, etc)
		-- REM figure out wth this is since I now know where flags really are...
		flags_table_base = read_dword(flags_pointer) -- Tested.
		flags_count = read_dword(flags_table_base + 0x378) -- Tested.
		flags_table_address = read_dword(flags_table_base + 0x37C) -- Tested.
		for i = 0,flags_count do -- i is each individual flag index
			flag_address = flags_table_address + i * 148
			flag_x_coord = read_float(flag_address) -- Confirmed.
			flag_y_coord = read_float(flag_address + 0x4) -- Confirmed.
			flag_z_coord = read_float(flag_address + 0x8) -- Confirmed.
			flag_type = read_word(flag_address + 0x10) -- Tested. (3 if race checkpoint, 6 if spawnpoint, sometimes 0 meaning something else)
			--flag_something = read_word(flag_address + 0x12) -- (???) Always 1?
			flag_tagtype = read_string(flag_address + 0x14, 4) -- Tested. It's usually ITMC or WPCL, which makes no sense...
		end

		-- player struct setup
		m_player = getplayer(player)

		-- player struct
		player_id = read_word(m_player, 0x0) -- Confirmed. WORD ID of this player. (0xEC70 etc)
		player_host = read_word(m_player + 0x2) -- Confirmed. (Host = 0) (Not host = 0xFFFFFFFF)
		player_name = readwidestring(m_player + 0x4, 12) -- Confirmed.
		--unkIdent[1] 0x1C-0x20 (???)
		player_team = read_byte(m_player + 0x20) -- Confirmed. (Red = 0) (Blue = 1)
		--Padding[3] 0x21-0x24
		player_interaction_obj_id = readident(m_player + 0x24) -- Confirmed. Returns vehi/weap id on interaction. (does not apply to weapons you're already holding)
		player_interaction_object_type = read_word(m_player + 0x28) -- Confirmed. (Vehicle = 8, Weapon = 7)
		player_interaction_vehi_seat = read_word(m_player + 0x2A) -- Confirmed. Takes seat number from vehi tag starting with 0. Warthog Seats: (0 = Driver, 1 = Gunner, 2 = Passenger)
		player_respawn_time = read_dword(m_player + 0x2C) -- Confirmed. Counts down when dead. When 0 you respawn. (1 sec = 30 ticks)
		player_respawn_time_growth = read_dword(m_player + 0x30) -- Confirmed. Current respawn time growth for player. (1 second = 30 ticks)
		player_obj_id = readident(m_player + 0x34) -- Confirmed.
		player_last_obj_id = readident(m_player + 0x38) -- Confirmed. 0xFFFFFFFF if player hasn't died/hasn't had their object destroyed yet. sv_kill or kill(player) DOES NOT AFFECT THIS AT ALL.
		player_cluster_index = read_word(m_player + 0x3C) -- Tested. Not sure what this is, but it's definitely something.
		--	bitmask16:
			player_weapon_pickup = read_bit(m_player + 0x3E, 0) -- Confirmed. (True if picking up weapon, False if not.)
		--	bitPadding[15] 1-15
		--player_auto_aim_target_objId = readident(m_player + 0x40)	-- (???) Always 0xFFFFFFFF
		player_last_bullet_time = read_dword(m_player + 0x44) -- Confirmed. gameinfo_current_time - this = time since last shot fired. (1 second = 30 ticks). Auto_aim_update_time in OS.
		
		--This stuff comes directly from the client struct:
		player_name2 = readwidestring(m_player + 0x48, 12) -- Confirmed.
		player_color = read_word(m_player + 0x60) -- Confirmed. Color of the player (FFA Gametypes Only.) (0 = white) (1 = black) (2 = red) (3 = blue) (4 = gray) (5 = yellow) (6 = green) (7 = pink) (8 = purple) (9 = cyan) (10 = cobalt) (11 = orange) (12 = teal) (13 = sage) (14 = brown) (15 = tan) (16 = maroon) (17 = salmon)
		--player_icon_index = read_word(m_player + 0x62) -- (???) Always 0xFFFF?
		player_machine_index = read_byte(m_player + 0x64) -- Confirmed with resolveplayer(player). Player Machine Index (rconId - 1).
		--player_controller_index = read_byte(m_player + 0x65) -- (???) Always 0?
		player_team2 = read_byte(m_player + 0x66) -- Confirmed. (Red = 0) (Blue = 1)
		player_index = read_byte(m_player + 0x67) -- Confirmed. Player memory id/index (0 - 15) (To clarify: this IS the 'player' argument passed to phasor functions)
		--End of client struct stuff.
		
		player_invis_time = read_word(m_player + 0x68) -- Confirmed. Time until player is no longer camouflaged. (1 sec = 30 ticks)
		--unkWord[1] 0x6A-0x6C (???) Has something to do with player_invis_time.
		player_speed = read_float(m_player + 0x6C) -- Confirmed.
		player_teleporter_flag_id = readident(m_player + 0x70) -- Tested. Index to a netgame flag in the scenario, or -1 (Always 0xFFFFFFFF?)
		player_objective_mode = read_dword(m_player + 0x74) -- From Smiley. (Hill = 0x22 = 34) (Juggernaut = It = 0x23 = 35) (Race = 0x16 = 22) (Ball = 0x29 = 41) (Others = -1)
		player_objective_player_id = readident(m_player + 0x78) -- Confirmed. Becomes the full DWORD ID of this player once they interact with the objective. (DOES NOT APPLY TO CTF) (0xFFFFFFFF / -1 if not interacting)
		player_target_player = read_dword(m_player + 0x7C) -- From OS. Values (this and below) used for rendering a target player's name. (Always 0xFFFFFFFF?)
		player_target_time = read_dword(m_player + 0x80) -- From OS. Timer used to fade in the target player name.
		player_last_death_time = read_dword(m_player + 0x84) -- Confirmed. gameinfo_current_time - this = time since last death time. (1 sec = 30 ticks)
		player_slayer_target = readident(m_player + 0x88) -- Confirmed. Slayer Target Player
		--	bitmask32:
			player_oddman_out = read_bit(m_player + 0x8C, 0) -- Confirmed. (1 if oddman out, 0 if not)
		--	bitPadding[31]
		--Padding[6] 0x90-0x96
		player_killstreak = read_word(m_player + 0x96) -- Confirmed. How many kills the player has gotten in their lifetime.
		player_multikill = read_word(m_player + 0x98) -- (???) 0 on spawn, 1 when player gets a kill, then stays 1 until death.
		player_last_kill_time = read_word(m_player + 0x9A) -- Confirmed. gameinfo_current_time - this = time since last kill time. (1 sec = 30 ticks)
		player_kills = read_word(m_player + 0x9C) -- Confirmed.
		--unkByte[6] 0x9E-0xA4 (Padding Maybe?)
		player_assists = read_word(m_player + 0xA4) -- Confirmed.
		--unkByte[6] 0xA6-0xAC (Padding Maybe?)
		player_betrays = read_word(m_player + 0xAC) -- Confirmed. Actually betrays + suicides.
		player_deaths = read_word(m_player + 0xAE) -- Confirmed.
		player_suicides = read_word(m_player + 0xB0) -- Confirmed.
		--Padding[14] 0xB2-0xC0
		player_teamkills = read_word(m_player + 0xC0) -- From OS.
		--Padding[2] 0xC2-0xC4
		
		--This is all copied from the stat struct
		player_flag_steals = read_word(m_player + 0xC4) -- Confirmed. Flag steals for CTF.
			player_hill_time = read_word(m_player + 0xC4) -- Confirmed. Time for KOTH. (1 sec = 30 ticks)
			player_race_time = read_word(m_player + 0xC4) -- Confirmed. Time for Race. (1 sec = 30 ticks)
		player_flag_returns = read_word(m_player + 0xC6) -- Confirmed. Flag returns for CTF.
			player_oddball_target_kills = read_word(m_player + 0xC6) -- Confirmed. Number of times you killed the Juggernaut or It.
			player_race_laps = read_word(m_player + 0xC6) -- Confirmed. Laps for Race.
		player_flag_scores = read_word(m_player + 0xC8) -- Confirmed. Flag scores for CTF.
			player_oddball_kills = read_word(m_player + 0xC8) -- Confirmed. Number of kills you have as Juggernaut or It.
			player_race_best_time = read_word(m_player + 0xC8) -- Confirmed. Best time for Race. (1 sec = 30 ticks)
		
		--unkByte[2] 0xCA-0xCC (Padding Maybe?)
		player_telefrag_timer = read_dword(m_player + 0xCC) -- Confirmed. Time spent blocking a tele. Counts down after other player stops trying to teleport. (1 sec = 30 ticks)
		player_quit_time = read_dword(m_player + 0xD0) -- Confirmed. gameinfo_current_time - this = time since player quit. 0xFFFFFFFF if player not quitting. (1 sec = 30 ticks)
		--	bitmask16:
		--	player_telefrag_enabled = read_bit(m_player + 0xD4, 0) -- (???) Always False?
		--	bitPadding[7] 1-7
		--	player_quit = read_bit(m_player + 0xD4, 8) -- (???) Always False?
		--	bitPadding[7] 9-15
		--Padding[6] 0xD6-0xDC
		player_ping = read_dword(m_player + 0xDC) -- Confirmed.
		player_teamkill_number = read_dword(m_player + 0xE0) -- Confirmed.
		player_teamkill_timer = read_dword(m_player + 0xE4) -- Confirmed. Time since last betrayal. (1 sec = 30 ticks)
		player_some_timer = read_word(m_player + 0xE8) -- Tested. It increases once every half second until it hits 36, then repeats.
		--unkByte[14] 0xEA-0xF8 (???)
		player_x_coord = read_float(m_player + 0xF8) -- Confirmed.
		player_y_coord = read_float(m_player + 0xFC) -- Confirmed.
		player_z_coord = read_float(m_player + 0x100) -- Confirmed.
		--unkIdent[1] 0x104-0x108 (???)
		
		
		--unkByte[8] 0x108-0x110 (???)
		--unkLong[1] 0x110-0x114 (Some timer)
		--unkByte[8] 0x114-0x11C (???)
		--	Player Action Keypresses.
			player_melee_key = read_bit(m_player + 0x11C, 0) -- Confirmed.
			player_action_key = read_bit(m_player + 0x11C, 1) -- Confirmed.
		--	unkBit[1] 2
			player_flashlight_key = read_bit(m_player + 0x11C, 3) -- Confirmed.
		--	unkBit[9] 4-12
			player_reload_key = read_bit(m_player + 0x11C, 13) -- Confirmed.
		--	unkBit[2] 14-15
		
		--unkByte[30] 0x11E-0x134 (???)
		player_xy_aim = read_float(m_player + 0x138) -- Confirmed. Lags. (0 to 2pi) In radians.
		player_z_aim = read_float(m_player + 0x13C) -- Confirmed. Lags. (-pi/2 to pi/2) In radians.
		player_forward = read_float(m_player + 0x140) -- Confirmed. Negative means backward. Lags. (-1, -sqrt(2)/2, 0, sqrt(2)/2, 1)
		player_left = read_float(m_player + 0x144) -- Confirmed. Negative means right. Lags. (-1, -sqrt(2)/2, 0, sqrt(2)/2, 1)
		player_rateoffire_speed = read_float(m_player + 0x148) -- Confirmed. As player is shooting, this will gradually increase until it hits the max (0 to 1 only)
		player_weap_type = read_word(m_player + 0x14C) -- Confirmed. Lags. (Primary = 0) (Secondary = 1) (Tertiary = 2) (Quaternary = 3)
		player_nade_type = read_word(m_player + 0x14E) -- Confirmed. Lags. (Frag = 0) (Plasma = 1)
		--unkByte[4] 0x150-0x154 (Padding Maybe?)
		player_x_aim2 = read_float(m_player + 0x154) -- Confirmed. Lags.
		player_y_aim2 = read_float(m_player + 0x158) -- Confirmed. Lags.
		player_z_aim2 = read_float(m_player + 0x15C) -- Confirmed. Lags.
		--unkByte[16] 0x160-0x170 (Padding Maybe?)
		player_x_coord2 = read_float(m_player + 0x170) -- Confirmed. Lags. (Possibly what the client reports is _its_ world coord?)
		player_y_coord2 = read_float(m_player + 0x174) -- Confirmed. Lags. (Possibly what the client reports is _its_ world coord?)
		player_z_coord2 = read_float(m_player + 0x178) -- Confirmed. Lags. (Possibly what the client reports is _its_ world coord?)
		--unkByte[132] 0x17C-0x200

		-- obj/weap struct setup
		m_object = getobject(player_obj_id) -- obj struct setup
		m_vehicle = getobject(read_dword(m_object + 0x11C)) -- vehi check setup

		-- vehi check
		if m_vehicle then
			m_object = m_vehicle
		end

		--*****************************************	OBJECTS	**************************************************************
		
		-- obj struct. This struct applies to ALL OBJECTS. 0x0 - 0x1F4
		obj_tag_id = read_dword(m_object) -- Confirmed with HMT. Tag Meta ID / MapID / TagID.
		--obj_object_role = read_dword(m_object + 0x4) -- From OS. (0 = Master, 1 = Puppet, 2 = Puppet controlled by local player, 3 = ???) Always 0?
		--	bitmask32:
		--	unkBits[8] 0-7 (???)
			obj_should_force_baseline_update = read_bit(m_object + 0x8, 8) -- From OS.
		--	unkBits[23] 9-32 (???)
		obj_existance_time = read_dword(m_object + 0xC) -- Confirmed. (1 second = 30 ticks)
		--	Physics bitmask32:
			obj_noCollision = read_bit(m_object + 0x10, 0) -- Confirmed. (Ghost mode = True)
			obj_is_on_ground = read_bit(m_object + 0x10, 1) -- Confirmed. (Object is on the ground = True, otherwise False) 
			obj_ignoreGravity = read_bit(m_object + 0x10, 2) -- From Phasor
		--	obj_is_in_water = read_bit(m_object + 0x10, 3) -- (???) Always 0?
		--	unkBits[1] 0x10 4
			obj_stationary = read_bit(m_object + 0x10, 5) -- Confirmed. This bit is set (true) when the object is stationary.
		--	unkBits[1] 0x10 6
			obj_noCollision2 = read_bit(m_object + 0x10, 7) -- From Phasor.
		--	unkBits[3] 0x10 8-10
		--	obj_connected_to_map = read_bit(m_object + 0x10, 11) -- (???) Always True?
		--	unkBits[4] 0x10 12-15
			obj_garbage_bit = read_bit(m_object + 0x10, 16) -- From OS.
		--	unkBits[1] 0x10 17
			obj_does_not_cast_shadow = read_bit(m_object + 0x10, 18) -- From OS.
		--	unkBits[2] 0x10 19-20
			obj_is_outside_of_map = read_bit(m_object + 0x10, 21) -- Confirmed. (True if outside of map, False if not)
		--	obj_beautify_bit = read_bit(m_object + 0x10, 22) -- (???) Always False?
		--	unkBits[1] 0x10 23
			obj_is_collideable = read_bit(m_object + 0x10, 24) -- Confirmed. Set this to true to allow other objects to pass through you. (doesn't apply to vehicles).
		--	unkBits[7] 0x10 25-31
		obj_marker_id = read_dword(m_object + 0x14) -- Tested. Continually counts up from like 89000...
		--Padding[0x38] 0x18-0x50
		--obj_owner_player_id = readident(m_object + 0x50) -- (???) Always 0?
		--obj_owner_id = readident(m_object + 0x54) -- (???) Always 0?
		--obj_timestamp = read_dword(m_object + 0x58) -- (???) Always 0?
		
		obj_x_coord = read_float(m_object + 0x5C) -- Confirmed.
		obj_y_coord = read_float(m_object + 0x60) -- Confirmed.
		obj_z_coord = read_float(m_object + 0x64) -- Confirmed.
		obj_x_vel = read_float(m_object + 0x68) -- Confirmed.
		obj_y_vel = read_float(m_object + 0x6C) -- Confirmed.
		obj_z_vel = read_float(m_object + 0x70) -- Confirmed.
		obj_pitch = read_float(m_object + 0x74) -- Confirmed. In Radians. (-1 to 1)
		obj_yaw = read_float(m_object + 0x78) -- Confirmed. In Radians. (-1 to 1)
		obj_roll = read_float(m_object + 0x7C) -- Confirmed. In Radians. (-1 to 1)
		obj_x_scale = read_float(m_object + 0x80) -- Tested. 0 for bipd. Changes when in vehi. Known as 'up' in OS.
		obj_y_scale = read_float(m_object + 0x84) -- Tested. 0 for bipd. Changes when in vehi. Known as 'up' in OS.
		obj_z_scale = read_float(m_object + 0x88) -- Tested. 1 for bipd. Changes when in vehi. Known as 'up' in OS.
		obj_pitch_vel = read_float(m_object + 0x8C) -- Confirmed for vehicles. Current velocity for pitch.
		obj_yaw_vel = read_float(m_object + 0x90) -- Confirmed for vehicles. Current velocity for yaw.
		obj_roll_vel = read_float(m_object + 0x94) -- Confirmed for vehicles. Current velocity for roll.
		
		obj_locId = read_dword(m_object + 0x98) -- Confirmed. Each map has dozens of location IDs, used for general location checking.
		--unkLong[1] 0x9C (Padding Maybe?)
		-- Apparently these are coordinates, used for the game code's trigger volume point testing
		obj_center_x_coord = read_float(m_object + 0xA0) -- Tested. Very close to obj_x_coord, but not quite?
		obj_center_y_coord = read_float(m_object + 0xA4) -- Tested. Very close to obj_y_coord, but not quite?
		obj_center_z_coord = read_float(m_object + 0xA8) -- Tested. Very close to obj_z_coord, but not quite?
		obj_radius = read_float(m_object + 0xAC) -- Confirmed. Radius of object. In Radians. (-1 to 1)
		obj_scale = read_float(m_object + 0xB0) -- Tested. Seems to be some random float for all objects (all same objects have same value)
		obj_type = read_word(m_object + 0xB4) -- Confirmed. (0 = Biped) (1 = Vehicle) (2 = Weapon) (3 = Equipment) (4 = Garbage) (5 = Projectile) (6 = Scenery) (7 = Machine) (8 = Control) (9 = Light Fixture) (10 = Placeholder) (11 = Sound Scenery)
		--Padding[2] 0xB6-0xB8
		obj_game_objective = read_word(m_object + 0xB8) -- Confirmed. If objective then this >= 0, -1 = is NOT game object. Otherwise: (Red = 0) (Blue = 1)
		obj_namelist_index = read_word(m_object + 0xBA) -- From OS.
		--obj_moving_time = read_word(m_object + 0xBC) -- (???) Always 0?
		--obj_region_permutation_variant_id = read_word(m_object + 0xBE) -- (???) Always 0?
		obj_player_id = readident(m_object + 0xC0) -- Confirmed. Full DWORD ID of player.
		obj_owner_obj_id = readident(m_object + 0xC4) -- Confirmed. Parent object ID of this object (DOES NOT APPLY TO BIPEDS/PLAYER OBJECTS)
		--Padding[4] 0xC8-0xCC
		--REM: figure out what this animation stuffz is.
		obj_antr_meta_id = readident(m_object + 0xCC) -- From DZS. Remind me to look at eschaton to see what this actually is (Possible Struct?)
		obj_animation_state = read_word(m_object + 0xD0) -- Confirmed. The actual animation ID from animations tag which is currently playing. (by aLTis)
		obj_time_since_animation_state_change = read_word(m_object + 0xD2) -- Confirmed (0 to 60) Time since last animation_state change. Restarts at 0 when animation_state changes (1 sec = 30 ticks)
		--unkWord[2] 0xD4-0xD8 (???)
		obj_max_health = read_float(m_object + 0xD8) -- Confirmed. Takes value from coll tag.
		obj_max_shields = read_float(m_object + 0xDC) -- Confirmed. Takes value from coll tag.
		obj_health = read_float(m_object + 0xE0) -- Confirmed. (0 to 1)
		obj_shields = read_float(m_object + 0xE4) -- Confirmed. (0 to 3) (Normal = 1) (Full overshield = 3)
		obj_current_shield_damage = read_float(m_object + 0xE8) -- Confirmed. CURRENT INSTANTANEOUS amount of shield being damaged.
		obj_current_body_damage = read_float(m_object + 0xEC) -- Confirmed. CURRENT INSTANTANEOUS amount of health being damaged.
		--obj_some_obj_id = readident(m_object + 0xF0) -- (???) Always 0xFFFFFFFF?
		obj_last_shield_damage_amount = read_float(m_object + 0xF4) -- Tested. Total shield damage taken (counts back down to 0 after 2 seconds)
		obj_last_body_damage_amount = read_float(m_object + 0xF8) -- Tested. Total health damage taken (counts back down to 0 after 2 seconds)
		obj_last_shield_damage_time = read_dword(m_object + 0xFC) -- Tested. Counts up to 75 after shield is damaged, then becomes 0xFFFFFFFF.
		obj_last_body_damage_time = read_dword(m_object + 0x100) -- Tested. Counts up to 75 after health is damaged, then becomes 0xFFFFFFFF.
		obj_shields_recharge_time = read_word(m_object + 0x104) -- Tested. Counts down when shield is damaged. When 0 your shields recharge. (1 sec = 30 ticks). based on ftol(s_shield_damage_resistance->stun_time * 30f)
		-- damageFlags bitmask16
			--obj_body_damage_effect_applied = read_bit(m_object + 0x106, 0) -- (???) Always False?
			--obj_shield_damage_effect_applied = read_bit(m_object + 0x106, 1) -- (???) Always False?
			--obj_body_health_empty = read_bit(m_object + 0x106, 2) -- (???) Always False?
			--obj_shield_empty = read_bit(m_object + 0x106, 3) -- (???) Always False?
			--obj_kill = read_bit(m_object + 0x106, 4) -- (???) Always False?
			--obj_silent_kill_bit = read_bit(m_object + 0x106, 5) -- (???) Always False?
			--obj_damage_berserk = read_bit(m_object + 0x106, 6) -- (???) Always False? (actor berserk related)
		--	unkBits[4] 0x106 7-10
			obj_cannot_take_damage = read_bit(m_object + 0x106, 11) -- Confirmed. Set this to true to make object undamageable (even from backtaps!)
			obj_shield_recharging = read_bit(m_object + 0x106, 12) -- Confirmed. (True = shield recharging, False = not recharging)
			--obj_killed_no_statistics = read_bit(m_object + 0x106, 13) -- (???) Always False?
		--	unkBits[2] 0x106 14-15
		--Padding[4] 0x108
		obj_cluster_partition_index = readident(m_object + 0x10C) -- Tested. This number continually counts up, and resumes even after object is destroyed and recreated (killed)
		--obj_some_obj_id2 = readident(m_object + 0x110) -- object_index, garbage collection related
		--obj_next_obj_id = readident(m_object + 0x114) -- (???) Always 0xFFFFFFFF?
		obj_weap_obj_id = readident(m_object + 0x118) -- Confirmed. Current weapon  id.
		obj_vehi_obj_id = readident(m_object + 0x11C) -- Confirmed. Current vehicle id. (Could also be known as the object's parent ID.)
		obj_vehi_seat = read_word(m_object + 0x120) -- Confirmed. Current seat index (actually same as player_interaction_vehi_seat once inside a vehicle)
		--	bitmask8:
			obj_force_shield_update = read_bit(m_object + 0x122, 0) -- From OS.
		--	unkBits[15] 1-15 (???)
		
		--Functions.
		obj_shields_hit = read_float(m_object + 0x124) -- Tested. Counts down from 1 after shields are hit (0 to 1)
		obj_shields_target = read_float(m_object + 0x128) -- Tested. When you have an overshield it stays at 1 which is why I think the overshield drains. (0 to 1) [2nd function]
		obj_flashlight_scale = read_float(m_object + 0x12C) -- Confirmed. Intensity of flashlight as it turns on and off. (0 to 1) (On > 0) (Off = 0) [3rd function]
		obj_assaultrifle_function = read_float(m_object + 0x130) -- The Assault rifle is the only one that uses this function.
		obj_export_function1 = read_float(m_object + 0x134) -- Tested. (Assault rifle = 1)
		obj_flashlight_scale2 = read_float(m_object + 0x138) -- Confirmed. Intensity of flashlight as it turns on and off. (0 to 1) (On > 0) (Off = 0) [2nd function]
		obj_shields_hit2 = read_float(m_object + 0x13C) -- Tested. Something to do with shields getting hit. [3rd function]
		obj_export_function4 = read_float(m_object + 0x140) -- Tested. (1 = Assault Rifle)
		--End of functions.
		
		--Regions/Attachments.
		obj_attachment_type = read_byte(m_object + 0x144) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type2 = read_byte(m_object + 0x145) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type3 = read_byte(m_object + 0x146) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type4 = read_byte(m_object + 0x147) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type5 = read_byte(m_object + 0x148) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type6 = read_byte(m_object + 0x149) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type7 = read_byte(m_object + 0x14A) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		obj_attachment_type8 = read_byte(m_object + 0x14B) -- From OS. (0 = light, 1 = looping sound, 2 = effect, 3 = contrail, 4 = particle, 5 = ???, 0xFF = invalid)
		
		-- game state identity
		-- ie, if Attachments[x]'s definition (object_attachment_block[x]) says it is a 'cont'
		-- then the identity is a contrail_data handle
		obj_attachment_id = readident(m_object + 0x14C) -- From OS.
		obj_attachment2_id = readident(m_object + 0x150) -- From OS.
		obj_attachment3_id = readident(m_object + 0x154) -- From OS.
		obj_attachment4_id = readident(m_object + 0x158) -- From OS.
		obj_attachment5_id = readident(m_object + 0x15C) -- From OS.
		obj_attachment6_id = readident(m_object + 0x160) -- From OS.
		obj_attachment7_id = readident(m_object + 0x164) -- From OS.
		obj_attachment8_id = readident(m_object + 0x168) -- From OS.
		obj_first_widget_id = readident(m_object + 0x16C) -- (???) Always 0xFFFFFFFF?
		obj_cached_render_state_index = readident(m_object + 0x170) -- (???) Always 0xFFFFFFFF?
		--unkByte[2] 0x174-0x176 (Padding Maybe?)
		obj_shader_permutation = read_word(m_object + 0x176) -- From OS. shader's bitmap block index
		obj_health_region = read_byte(m_object + 0x178) -- From OS.
		obj_health_region2 = read_byte(m_object + 0x179) -- From OS.
		obj_health_region3 = read_byte(m_object + 0x17A) -- From OS.
		obj_health_region4 = read_byte(m_object + 0x17B) -- From OS.
		obj_health_region5 = read_byte(m_object + 0x17C) -- From OS.
		obj_health_region6 = read_byte(m_object + 0x17D) -- From OS.
		obj_health_region7 = read_byte(m_object + 0x17E) -- From OS.
		obj_health_region8 = read_byte(m_object + 0x17F) -- From OS.
		obj_region_permutation_index = readchar(m_object + 0x180) -- From OS.
		obj_region_permutation2_index = readchar(m_object + 0x181) -- From OS.
		obj_region_permutation3_index = readchar(m_object + 0x182) -- From OS.
		obj_region_permutation4_index = readchar(m_object + 0x183) -- From OS.
		obj_region_permutation5_index = readchar(m_object + 0x184) -- From OS.
		obj_region_permutation6_index = readchar(m_object + 0x185) -- From OS.
		obj_region_permutation7_index = readchar(m_object + 0x186) -- From OS.
		obj_region_permutation8_index = readchar(m_object + 0x187) -- From OS.
		--End of regions/attachments
		
		obj_color_change_red = read_float(m_object + 0x188) -- From OS.
		obj_color_change_green = read_float(m_object + 0x18C) -- From OS.
		obj_color_change_blue = read_float(m_object + 0x190) -- From OS.
		obj_color_change2_red = read_float(m_object + 0x194) -- From OS.
		obj_color_change2_green = read_float(m_object + 0x198) -- From OS.
		obj_color_change2_blue = read_float(m_object + 0x19C) -- From OS.
		obj_color_change3_red = read_float(m_object + 0x1A0) -- From OS.
		obj_color_change3_green = read_float(m_object + 0x1A4) -- From OS.
		obj_color_change3_blue = read_float(m_object + 0x1A8) -- From OS.
		obj_color_change4_red = read_float(m_object + 0x1AC) -- From OS.
		obj_color_change4_green = read_float(m_object + 0x1B0) -- From OS.
		obj_color_change4_blue = read_float(m_object + 0x1B4) -- From OS.
		obj_color2_change_red = read_float(m_object + 0x1B8) -- From OS.
		obj_color2_change_green = read_float(m_object + 0x1BC) -- From OS.
		obj_color2_change_blue = read_float(m_object + 0x1C0) -- From OS.
		obj_color2_change2_red = read_float(m_object + 0x1C4) -- From OS.
		obj_color2_change2_green = read_float(m_object + 0x1C8) -- From OS.
		obj_color2_change2_blue = read_float(m_object + 0x1CC) -- From OS.
		obj_color2_change3_red = read_float(m_object + 0x1D0) -- From OS.
		obj_color2_change3_green = read_float(m_object + 0x1D4) -- From OS.
		obj_color2_change3_blue = read_float(m_object + 0x1D8) -- From OS.
		obj_color2_change4_red = read_float(m_object + 0x1DC) -- From OS.
		obj_color2_change4_green = read_float(m_object + 0x1E0) -- From OS.
		obj_color2_change4_blue = read_float(m_object + 0x1E4) -- From OS.
		
		--one of these are for interpolating:
		obj_header_block_ref_node_orientation_size = read_word(m_object + 0x1E8) -- From OS.
		obj_header_block_ref_node_orientation_offset = read_word(m_object + 0x1EA) -- From OS.
		obj_header_block_ref_node_orientation2_size = read_word(m_object + 0x1EC) -- From OS.
		obj_header_block_ref_node_orientation2_offset = read_word(m_object + 0x1EE) -- From OS.
		obj_header_block_ref_node_matrix_block_size = read_word(m_object + 0x1F0) -- From OS.
		obj_header_block_ref_node_matrix_block_offset = read_word(m_object + 0x1F2) -- From OS.
		
		--unkLong[2] 0x1E8-0x1F0 (???) Some sort of ID?
		--obj_node_matrix_block = read_dword(m_object + 0x1F0) -- From OS. (???)
		
		if obj_type == 0 or obj_type == 1 then -- check if object is biped or vehicle
			
			--unit struct (applies to bipeds (players and AI) and vehicles)
			m_unit = m_object
			
			unit_actor_index = readident(m_unit + 0x1F4) -- From OS.
			unit_swarm_actor_index = readident(m_unit + 0x1F8) -- From OS.
			unit_swarm_next_actor_index = readident(m_unit + 0x1FC) -- Guess.
			unit_swarm_prev_obj_id = readident(m_unit + 0x200) -- From OS.
			
			--	Client Non-Instantaneous bitmask32
			--	unkBit[4] 0-3 (???)
				unit_is_invisible = read_bit(m_unit + 0x204, 4) -- Confirmed. (True if currently invisible, False if not)
				unit_powerup_additional = read_bit(m_unit + 0x204, 5) -- From OS. Guessing this is set if you have multiple powerups at the same time.
				unit_is_currently_controllable_bit = read_bit(m_unit + 0x204, 6) -- From OS. I'm just going to assume this works.
			--	unkBit[9] 7-15 (???)
			--	unit_doesNotAllowPlayerEntry = read_bit(m_unit + 0x204, 16) -- From DZS. For vehicles. (True if vehicle is allowing players to enter, False if not)
			--	unkBit[2] 17-18 (???)
				unit_flashlight = read_bit(m_unit + 0x204, 19) -- Confirmed. (True = flashlight on, False = flashlight off)
				unit_doesnt_drop_items = read_bit(m_unit + 0x204, 20) -- Confirmed. (True if object doesn't drop items on death, otherwise False). (Clients will see player drop items, then immediately despawn)
			--	unkBit[1] 21 (???)
			--	unit_can_blink = read_bit(m_unit + 0x204, 22) -- (???) Always False?
			--	unkBit[1] 23 (???)
				unit_is_suspended = read_bit(m_unit + 0x204, 24) -- Confirmed. (True if frozen/suspended, False if not)
			--	unkBit[2] 25-26 (???)
			--	unit_is_possessed = read_bit(m_unit + 0x204, 27) -- (???) Always False?
			--	unit_flashlight_currently_on = read_bit(m_unit + 0x204, 28) -- (???) Always False?
			--	unit_flashlight_currently_off = read_bit(m_unit + 0x204, 29) -- (???) Always False?
			--	unkBit[2] 30-31 (???)

			--	Client Action Keypress bitmask32 (Instantaneous actions).
				unit_crouch_presshold = read_bit(m_unit + 0x208, 0) -- Confirmed. (True when holding crouch, False when not)
				unit_jump_presshold = read_bit(m_unit + 0x208, 1)	-- Confirmed. (True when holding jump key, False when not)
			--	unit_user1 = read_bit(m_unit + 0x208, 3) -- (???) Always False?
			--	unit_user2 = read_bit(m_unit + 0x208, 4) -- (???) Always False?
				unit_flashlightkey = read_bit(m_unit + 0x208, 4)-- Confirmed. (True when pressing flashlight key, False when not)
			--	unit_exact_facing = read_bit(m_unit + 0x208, 5) -- (???) Always False?
				unit_actionkey = read_bit(m_unit + 0x208, 6)	-- Confirmed. (True when pressing action key, False when not)
				unit_meleekey = read_bit(m_unit + 0x208, 7)		-- Confirmed. (True when pressing melee key, False when not)
			--	unit_look_without_turn = read_bit(m_unit + 0x208, 8) -- (???) Always False?
			--	unit_force_alert = read_bit(m_unit + 0x208, 9) -- (???) Always False?
				unit_reload_key = read_bit(m_unit + 0x208, 10)	-- Confirmed. (True when pressing action/reload key, False when not)
				unit_primaryWeaponFire_presshold = read_bit(m_unit + 0x208, 11)		-- Confirmed. (True when holding left click, False when not)
				unit_secondaryWeaponFire_presshold = read_bit(m_unit + 0x208, 12)	-- Confirmed. (True when holding right click, False when not)
				unit_grenade_presshold = read_bit(m_unit + 0x208, 13)	-- Confirmed. (True when holding right click, False when not)
				unit_actionkey_presshold = read_bit(m_unit + 0x208, 14)	-- Confirmed. (True when holding action key,  False when not)
			--	emptyBit[1] 15
			
			--unkWord[2] 0x20A-0x20E related to first two words in unit_global_data
			--unit_shield_sapping = readchar(m_unit + 0x20E) -- (???) Always 0?
			unit_base_seat_index = readchar(m_unit + 0x20F) -- From OS.
			--unit_time_remaining = read_dword(m_unit + 0x210) -- (???) Always 0?
			unit_flags = read_dword(m_unit + 0x214) -- From OS. Bitmask32 (breakdown of this coming soon)
			unit_player_id = readident(m_unit + 0x218) -- Confirmed. Full DWORD ID of the Player.
			unit_ai_effect_type = read_word(m_unit + 0x21C) -- From OS. ai_unit_effect
			unit_emotion_animation_index = read_word(m_unit + 0x21E) -- From OS.
			unit_last_bullet_time = read_dword(m_unit + 0x220) -- Confirmed. gameinfo_current_time - this = time since last shot fired. (1 second = 30 ticks) Related to unit_ai_effect_type. Lags immensely behind player_last_bullet_time.
			unit_x_facing = read_float(m_unit + 0x224) -- Confirmed. Same as unit_x_aim.
			unit_y_facing = read_float(m_unit + 0x228) -- Confirmed. Same as unit_y_aim.
			unit_z_facing = read_float(m_unit + 0x22C) -- Confirmed. Same as unit_z_aim.
			unit_desired_x_aim = read_float(m_unit + 0x230)	-- Confirmed. This is where the unit WANTS to aim.
			unit_desired_y_aim = read_float(m_unit + 0x234)	-- Confirmed. This is where the unit WANTS to aim.
			unit_desired_z_aim = read_float(m_unit + 0x238)	-- Confirmed. This is where the unit WANTS to aim.
			unit_x_aim = read_float(m_unit + 0x23C) -- Confirmed.
			unit_y_aim = read_float(m_unit + 0x240) -- Confirmed.
			unit_z_aim = read_float(m_unit + 0x244) -- Confirmed.
			unit_x_aim_vel = read_float(m_unit + 0x248) -- Confirmed. Does not apply to multiplayer bipeds
			unit_y_aim_vel = read_float(m_unit + 0x24C) -- Confirmed. Does not apply to multiplayer bipeds
			unit_z_aim_vel = read_float(m_unit + 0x250) -- Confirmed. Does not apply to multiplayer bipeds
			unit_x_aim2 = read_float(m_unit + 0x254) -- Confirmed.
			unit_y_aim2 = read_float(m_unit + 0x258) -- Confirmed.
			unit_z_aim2 = read_float(m_unit + 0x25C) -- Confirmed.
			unit_x_aim3 = read_float(m_unit + 0x260) -- Confirmed.
			unit_y_aim3 = read_float(m_unit + 0x264) -- Confirmed.
			unit_z_aim3 = read_float(m_unit + 0x268) -- Confirmed.
			--unit_x_aim_vel2 = read_float(m_unit + 0x26C) -- (???) Always 0?
			--unit_y_aim_vel2 = read_float(m_unit + 0x26C) -- (???) Always 0?
			--unit_z_aim_vel2 = read_float(m_unit + 0x26C) -- (???) Always 0?

			unit_forward = read_float(m_unit + 0x278) -- Confirmed. Negative means backward. (-1, -sqrt(2)/2, 0, sqrt(2)/2, 1)
			unit_left = read_float(m_unit + 0x27C) -- Confirmed. Negative means right. (-1, -sqrt(2)/2, 0, sqrt(2)/2, 1)
			unit_up = read_float(m_unit + 0x280) -- Confirmed. Negative means down. (-1, -sqrt(2)/2, 0, sqrt(2)/2, 1) (JUMPING/FALLING DOESNT COUNT)
			unit_shooting = read_float(m_unit + 0x284) -- Confirmed. (Shooting = 1, Not Shooting = 0)
			--unkByte[2] 0x288-0x28A melee related (state enum and counter?)
			unit_time_until_flaming_death = readchar(m_unit + 0x28A) -- From OS (1 second = 30 ticks)
			--unkByte[2] 0x28B-0x28D looks like the amount of frames left for the ping animation. Also set to the same PersistentControlTicks value when an actor dies and they fire-wildly
			unit_throwing_grenade_state = read_byte(m_unit + 0x28D) -- Confirmed. (0 = not throwing) (1 = Arm leaning back) (2 = Grenade leaving hand) (3 = Grenade Thrown, going back to normal state)
			--unkWord[2] 0x28E-0x292 (???)
			--Padding[2] 0x292-0x294
			unit_thrown_grenade_obj_id = readident(m_unit + 0x294) -- Confirmed. 0xFFFFFFFF when grenade leaves hand.
			unkBit[16] -- Something to do with states/animations. First bit is 1 when unit is in impulse state. (from aLTis)
			--unit_action = read_word(m_unit + 0x29A) -- Tested. Something to do with actions. (Crouching, throwing nade, walking) (animation index, weapon type)
			--unkWord[1] 0x29C-0x29E animation index
			--unkWord[1] 0x29E-0x2A0 appears unused except for getting initialized
			unit_crouch = read_byte(m_unit + 0x2A0) -- Confirmed. Unit from animation tag. (Standing = 4) (Crouching = 3) (W-driver = 0) (W-gunner = 1) (from aLTis)
			unit_weap_slot = read_byte(m_unit + 0x2A1) -- Confirmed. Current weapon slot. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			unit_weap_index_type = read_byte(m_unit + 0x2A2) -- Tested. (0 = Rocket Launcher) (1 = Plasma Pistol) (2 = Shotgun) (3 = Plasma Rifle) don't care to continue
			unit_animation_state = read_byte(m_unit + 0x2A3) -- Confirmed. (0 = Idle, 1 = Gesture, Turn Left = 2, Turn Right = 3, Move Front = 4, Move Back = 5, Move Left = 6, Move Right = 7, Stunned Front = 8, Stunned Back = 9, Stunned Left = 10, Stunned Right = 11, Slide Front = 12, Slide Back = 13, Slide Left = 14, Slide Right = 15, Ready = 16, Put Away = 17, Aim Still = 18, Aim Move = 19, Airborne = 20, Land Soft = 21, Land Hard = 22, ??? = 23, Airborne Dead = 24, Landing Dead = 25, Seat Enter = 26, Seat Exit = 27, Custom Animation = 28, Impulse = 29, Melee = 30, Melee Airborne = 31, Melee Continuous = 32, Grenade Toss = 33, Resurrect Front = 34, Ressurect Back = 35, Feeding = 36, Surprise Front = 37, Surprise Back = 38, Leap Start = 39, Leap Airborne = 40, Leap Melee = 41, Unused AFAICT = 42, Berserk = 43)
			unit_reloadmelee = read_byte(m_unit + 0x2A4) -- Confirmed. (Reloading = 5) (Meleeing = 7)
			unit_shooting2 = read_byte(m_unit + 0x2A5) -- Confirmed. (Shooting = 1) (No = 0)
			unit_animation_state2 = read_byte(m_unit + 0x2A6) -- Confirmed. Some kind of unit states (5 - default, 3 - berserk), could also be shield states? (from aLTis)
			unit_crouch2 = read_byte(m_unit + 0x2A7) -- Confirmed. (Standing = 2) (Crouching = 3) (Flaming? = 5)
			--unkByte[2] 0x2A8-0x2AA (???)
			--unit_ping_state_animation_index = read_word(m_unit + 0x2AA) -- (???) Always 0xFFFF?
			unit_ping_state_frame_index = read_word(m_unit + 0x2AC) -- Tested. Counts up from 0 after you perform an action (reload, melee, etc) until it hits a random final number depending on action.
			--don't care enough to test these 4, if I don't know what above 2 are then there's no point.
			unit_unknown_state_animation_index = read_word(m_unit + 0x2AE) -- From OS.
			unit_unknown_state_frame_index = read_word(m_unit + 0x2B0) -- From OS. Some kind of firing timer, when firing = 0, counts up to 5 when not (from aLTis)
			unit_fpweapon_state_animation_index = read_word(m_unit + 0x2B2) -- From OS. Unit ping ID, different depending on where the unit is hit (from aLTis)
			unit_fpweapon_state_frame_index = read_word(m_unit + 0x2B4) -- From OS. Also has something to do with pings, counts up to a random value when hit
			unit_able_to_fire = read_byte(biped_object + 0x2B6) --	1 when unit can fire, 0 otherwise (from aLTis)
			unit_able_to_fire2 = read_byte(biped_object + 0x2B7) --	same as above
			unit_aim_rectangle_top_x = read_float(m_unit + 0x2B8) -- Confirmed. Top-most aim possible.
			unit_aim_rectangle_bottom_x = read_float(m_unit + 0x2BC) -- Confirmed. Bottom-most aim possible.
			unit_aim_rectangle_left_y = read_float(m_unit + 0x2C0) -- Confirmed. Left-most aim possible.
			unit_aim_rectangle_right_y = read_float(m_unit + 0x2C4) -- Confirmed. Right-most aim possible.
			unit_look_rectangle_top_x = read_float(m_unit + 0x2C8) -- Confirmed. Top-most aim possible. Same as unit_aim_rectangle_top_x.
			unit_look_rectangle_bottom_x = read_float(m_unit + 0x2CC) -- Confirmed. Bottom-most aim possible. Same as unit_aim_rectangle_bottom_x.
			unit_look_rectangle_left_y = read_float(m_unit + 0x2D0) -- Confirmed. Left-most aim possible. Same as unit_aim_rectangle_left_y.
			unit_look_rectangle_right_y = read_float(m_unit + 0x2D4) -- Confirmed. Right-most aim possible. Same as unit_aim_rectangle_right_y.
			--Padding[8] 0x2D8-0x2E0
			--unit_ambient = read_float(m_unit + 0x2E0) -- (???) Always 0?
			--unit_illumination = read_float(m_unit + 0x2E4) -- (???)
			unit_mouth_aperture = read_float(m_unit + 0x2E8) -- From OS.
			--Padding[4] 0x2EC-0x2F0
			unit_vehi_seat = read_word(m_unit + 0x2F0) -- Confirmed. (Warthog seats: Driver = 0, Passenger = 1, Gunner = 2 Not in vehicle = 0xFFFF)
			unit_weap_slot2 = read_word(m_unit + 0x2F2) -- Confirmed. Current weapon slot. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			unit_next_weap_slot = read_word(m_unit + 0x2F4) -- Confirmed. Weapon slot the player is trying to change to. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			--unkByte[2] 0x2F6-0x2F8 (Padding Maybe?)
				unit_next_weap_obj_id = readident(m_unit + 0x2F8 + unit_next_weap_slot*4) -- Confirmed. Object ID of the weapon that the player is trying to change to.
			unit_primary_weap_obj_id = readident(m_unit + 0x2F8) -- Confirmed.
			unit_secondary_weap_obj_id = readident(m_unit + 0x2FC) -- Confirmed.
			unit_tertiary_weap_obj_id = readident(m_unit + 0x300) -- Confirmed.
			unit_quaternary_weap_obj_id = readident(m_unit + 0x304) -- Confirmed.
			unit_primaryWeaponLastUse = read_dword(m_unit + 0x308) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped to/picked up. (1 second = 30 ticks)
			unit_secondaryWeaponLastUse = read_dword(m_unit + 0x30C) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped to/picked up. (1 second = 30 ticks)
			unit_tertiaryWeaponLastUse = read_dword(m_unit + 0x310) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped to/picked up. (1 second = 30 ticks)
			unit_quaternaryWeaponLastUse = read_dword(m_unit + 0x314) -- From DZS. gameinfo_current_time - this = time since this weapon was last swapped to/picked up. (1 second = 30 ticks)
			unit_objective = read_dword(m_unit + 0x318) -- Tested. Increases every time you interact with the objective.
			unit_current_nade_type = readchar(m_unit + 0x31C) -- Confirmed. (Frag = 0) (Plasma = 1)
			unit_next_nade_type = read_byte(m_unit + 0x31D) -- Confirmed. Grenade type the player is trying to change to. (Frag = 0) (Plasma = 1)
			unit_primary_nades = read_byte(m_unit + 0x31E) -- Confirmed. Amount of frag grenades you have.
			unit_secondary_nades = read_byte(m_unit + 0x31F) -- Confirmed. Amount of plasma grenades you have.
			unit_zoom_level = read_byte(m_unit + 0x320) -- Confirmed. The level of zoom the player is at. (0xFF = not zoomed, 0 = first zoom lvl, 1 = second zoom lvl, etc...)
			unit_desired_zoom_level = read_byte(m_unit + 0x321) -- Confirmed. Where the player wants to zoom. (0xFF = not zoomed, 0 = first zoom lvl, 1 = second zoom lvl, etc...)
			unit_vehicle_speech_timer = readchar(m_unit + 0x322) -- Tested. Counts up from 0 after reloading, shooting, or throwing nade.
			unit_aiming_change = read_byte(m_unit + 0x323) -- Tested. This is 'confirmed' except I don't know what units. Does not apply to multiplayer bipeds.
			unit_master_obj_id = readident(m_unit + 0x324) -- Confirmed. Object ID controlling this unit (driver)
			unit_masterofweapons_obj_id = readident(m_unit + 0x328) -- Confirmed. Object ID controlling the weapons of this unit (gunner)
			unit_passenger_obj_id = readident(m_unit + 0x32C) -- Confirmed for vehicles. 0xFFFFFFFF for bipeds
			unit_time_abandoned_parent = read_dword(m_unit + 0x330) -- Confirmed. gameinfo_current_time - this = time since player ejected from vehicle.
			unit_some_obj_id = readident(m_unit + 0x334) -- From OS.
			unit_vehicleentry_scale = read_float(m_unit + 0x338) -- Tested. Intensity of vehicle entry as you enter a vehicle (0 to 1)
			--unit_power_of_masterofweapons = read_float(m_unit + 0x33C) -- (???) Always 0?
			unit_flashlight_scale = read_float(m_unit + 0x340) -- Confirmed. Intensity of flashlight as it turns on and off. (0 to 1) (On > 0) (Off = 0)
			unit_flashlight_energy = read_float(m_unit + 0x344) -- Confirmed. Amount of flashlight energy left. (0 to ~1)
			unit_nightvision_scale = read_float(m_unit + 0x348) -- Confirmed. Intensity of nightvision as it turns on and off. (0 to 1) (On = 1) (Off = 0)
			--unkFloat[12] 0x34C-0x37C Seat-related
			unit_invis_scale = read_float(m_unit + 0x37C) -- Confirmed. How invisible you are. (0 to 1) (Completely = 1) (None = 0)
			--unit_fullspectrumvision_scale = read_float(m_unit + 0x380) -- (???) Always 0, even when picking up a fullspectrum vision.
			unit_dialogue_definition = readident(m_unit + 0x384) -- From OS.
			
			-->>SPEECH<<--
			--AI Current Speech:
			unit_speech_priority = read_word(m_unit + 0x388) -- From OS. (0 = None) (1 = Idle) (2 = Pain) (3 = Talk) (4 = Communicate) (5 = Shout) (6 = Script) (7 = Involuntary) (8 = Exclaim) (9 = Scream) (10 = Death)
			unit_speech_scream_type = read_word(m_unit + 0x38A) -- From OS. (0 = Fear) (1 = Enemy Grenade) (2 = Pain) (3 = Maimed Limb) (4 = Maimed Head) (5 = Resurrection)
			unit_sound_definition = readident(m_unit + 0x38C) -- From OS.
			--unkWord[1] 0x390-0x392 time-related.
			--Padding[2] 0x392-0x394
			--unkLong[2] 0x394-0x39C (???)
			--unkWord[1] 0x39C-0x39E (???)
			unit_ai_current_communication_type = read_word(m_unit + 0x39E) -- From OS. (0 = Death) (1 = Killing Spree) (2 = Hurt) (3 = Damage) (4 = Sighted Enemy) (5 = Found Enemy) (6 = Unexpected Enemy) (7 = Found dead friend) (8 = Allegiance Changed) (9 = Grenade Throwing) (10 = Grenade Startle) (11 = Grenade Sighted) (12 = Grenade Danger) (13 = Lost Contact) (14 = Blocked) (15 = Alert Noncombat) (16 = Search Start) (17 = Search Query) (18 = Search Report) (19 = Search Abandon) (20 = Search Group Abandon) (21 = Uncover Start) (22 = Advance) (23 = Retreat) (24 = Cover) (25 = Sighted Friend Player) (26 = Shooting) (27 = Shooting Vehicle) (28 = Shooting Berserk) (29 = Shooting Group) (30 = Shooting Traitor) (31 = Flee) (32 = Flee Leader Died) (33 = Flee Idle) (34 = Attempted Flee) (35 = Hiding Finished) (36 = Vehicle Entry) (37 = Vehicle Exit) (38 = Vehicle Woohoo) (39 = Vehicle Scared) (40 = Vehicle Falling) (41 = Surprise) (42 = Berserk) (43 = Melee) (44 = Dive) (45 = Uncover Exclamation) (46 = Falling) (47 = Leap) (48 = Postcombat Alone) (49 = Postcombat Unscathed) (50 = Postcombat Wounded) (51 = Postcombat Massacre) (52 = Postcombat Triumph) (53 = Postcombat Check Enemy) (54 = Postcombat Check Friend) (55 = Postcombat Shoot Corpse) (56 = Postcombat Celebrate)
			--unkWord[1] 0x3A0-0x3A2 (???)
			--Padding[2] 0x3A2-0x3A4
			--unkWord[1] 0x3A4-0x3A6 (???)
			--Padding[6] 0x3A6-0x3AC
			--unkWord[1] 0x3AC-0x3AE (???)
			--Padding[2] 0x3AE-0x3B0
			--unkWord[2] 0x3B0-0x3B4 (???)
			--	bitmask8
				unit_ai_current_communication_broken = read_bit(m_unit + 0x3B4, 0) -- From OS. 1C false = reformed
			--	unkBit[7] 1-7 (???)
			--Padding[3] 0x3B5-0x3B8
			
			--AI Next Speech (I think):
			unit_speech_priority2 = read_word(m_unit + 0x3B8) -- From OS. (0 = None) (1 = Idle) (2 = Pain) (3 = Talk) (4 = Communicate) (5 = Shout) (6 = Script) (7 = Involuntary) (8 = Exclaim) (9 = Scream) (10 = Death)
			unit_speech_scream_type2 = read_word(m_unit + 0x3BA) -- From OS. (0 = Fear) (1 = Enemy Grenade) (2 = Pain) (3 = Maimed Limb) (4 = Maimed Head) (5 = Resurrection)
			unit_sound_definition2 = readident(m_unit + 0x3BC) -- From OS.
			--unkWord[1] 0x3C0-0x3C2 time-related.
			--Padding[2] 0x3C2-0x3C4
			--unkLong[2] 0x3C4-0x3CC (???)
			--unkWord[1] 0x3CC-0x3CE (???)
			--unit_ai_current_communication_type2 = read_word(m_unit + 0x3CE) -- always 0?
			--unkWord[1] 0x3D0-0x3D2 (???)
			--Padding[2] 0x3D2-0x3D4
			--unkWord[1] 0x3D4-0x3D6 (???)
			--Padding[6] 0x3D6-0x3DC
			--unkWord[1] 0x3DC-0x3DE (???)
			--Padding[2] 0x3DE-0x3E0
			--unkWord[2] 0x3E0-0x3E4 (???)
			--	bitmask8
				unit_ai_current_communication_broken2 = read_bit(m_unit + 0x3E4, 0) -- From OS. 1C false = reformed
			--	unkBit[7] 1-7 (???)
			--Padding[3] 0x3E5-0x3E8
			
			--unkWord[4] 0x3E8-0x3F0
			--unkLong[1] 0x3F0 time related
			--unkBit[32] 0x3F4-0x3F8 0-31 (???)
			--unkWord[4] 0x3F8-0x400 (???)
			--unkLong[1] 0x400-0x404 (???)
			-->>END OF SPEECH<<--
			
			unit_damage_type = read_word(m_unit + 0x404) -- Tested. (Not being damaged = 0) (Being damaged = 2) (Enum here) 10 when hit by plasma rifle
			--unit_damage2 = read_word(m_unit + 0x406) -- Tested. Changes when damaged. Changes back.
			--unit_damage3 = read_float(m_unit + 0x408) -- Tested. Changes when damaged. Changes back.
			unit_causing_objId = readident(m_unit + 0x40C) -- Confirmed. ObjId causing damage to this object.
			--unit_flamer_causer_objId = readident(m_unit + 0x410) -- (???) Always 0xFFFFFFFF?
			--Padding[8] 0x414-0x41C
			--unit_death_time = read_dword(m_unit + 0x41C) -- (???) Always 0xFFFFFFFF?
			--unit_feign_death_timer = read_word(m_unit + 0x420) -- (???) Always 0xFFFFFFFF?
			unit_camo_regrowth = read_word(m_unit + 0x422) -- Confirmed. (1 = Camo Failing due to damage/shooting)
			--unit_stun_amount = read_float(m_unit + 0x424) -- (???) Always 0?
			--unit_stun_timer = read_word(m_unit + 0x428) -- (???) Always 0?
			unit_killstreak = read_word(m_unit + 0x42A) -- Tested. Same as player_killstreak.
			unit_last_kill_time = read_dword(m_unit + 0x42C) -- Confirmed. gameinfo_current_time - this = time since last kill time. (1 sec = 30 ticks)
			
			--I realize the below are confusing, and if you really don't understand them after looking at it, I will explain it if you contact me about them:
			--I have no idea why halo stores these, only thing I can think of is because of betrayals or something.. but still..
			unit_last_damage_time_by_mostrecent_objId = read_dword(m_unit + 0x430) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_mostrecent_objId = read_float(m_unit + 0x434) -- Confirmed. Total damage done by the MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_mostrecent_causer_objId = readident(m_unit + 0x438) -- Confirmed. the MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_mostrecent_causer_playerId = readident(m_unit + 0x43C) -- Confirmed. Full DWORD ID of the MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			unit_last_damage_time_by_secondtomostrecent_obj = read_dword(m_unit + 0x440) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by the SECOND TO MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_secondtomostrecent_obj = read_float(m_unit + 0x444) -- Confirmed. Total damage done by the SECOND TO MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_secondtomostrecent_causing_objId = readident(m_unit + 0x448) -- Confirmed. the SECOND TO MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_secondtomostrecent_causing_playerId = readident(m_unit + 0x44C) -- Confirmed. Full DWORD ID of the SECOND TO MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			unit_last_damage_time_by_thirdtomostrecent_obj = read_dword(m_unit + 0x450) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by the THIRD TO MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_thirdtomostrecent_obj = read_float(m_unit + 0x454) -- Confirmed. Total damage done by the THIRD TO MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_thirdtomostrecent_causing_objId = readident(m_unit + 0x458) -- Confirmed. the THIRD TO MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_thirdtomostrecent_causing_playerId = readident(m_unit + 0x45C) -- Confirmed. Full DWORD ID of the THIRD TO MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			unit_last_damage_time_by_fourthtomostrecent_obj = read_dword(m_unit + 0x460) -- Confirmed. gameinfo_current_time - this = Time since last taken damage by the FOURTH TO MOST RECENT object. (1 second = 30 ticks)
			unit_total_damage_by_fourthtomostrecent_obj = read_float(m_unit + 0x464) -- Confirmed. Total damage done by the FOURTH TO MOST RECENT PLAYER (NOT TOTAL DAMAGE TO EVERYONE)
			unit_damage_fourthtomostrecent_causing_objId = readident(m_unit + 0x468) -- Confirmed. the FOURTH TO MOST RECENT object ID to do damage to this object (or 0xFFFFFFFF)
			unit_damage_fourthtomostrecent_causing_playerId = readident(m_unit + 0x46C) -- Confirmed. Full DWORD ID of the FOURTH TO MOST RECENT PLAYER to do damage to this object.. (AI = 0xFFFFFFFF)
			--Padding[4] 0x470-0x474
			unit_shooting3 = read_byte(m_unit + 0x474) -- Confirmed. (Shooting = 1) (No = 0) 'unused'
			--unkByte[1] 0x475-0x476 (???) 'unused'
			--Padding[2] 0x476-0x478
			unit_animation_state3 = read_byte(m_unit + 0x478) -- Same as 2 - 5 by default and 3 when berserk (from aLTis)
			--unit_aiming_speed2 = read_byte(m_unit + 0x479) -- (???) Always 0?
			--	Client Action Keypress bitmask32 (Instantaneous actions).
				unit_crouch2_presshold = read_bit(m_unit + 0x47A, 0) -- Confirmed. (True when holding crouch, False when not)
				unit_jump2_presshold = read_bit(m_unit + 0x47A, 1)	-- Confirmed. (True when holding jump key, False when not)
			--	unit_user1_2 = read_bit(m_unit + 0x47A, 3) -- (???) Always false?
			--	unit_user2_2 = read_bit(m_unit + 0x47A, 4) -- (???) Always false?
				unit_flashlightkey2 = read_bit(m_unit + 0x47A, 4)-- Confirmed. (True when pressing flashlight key, False when not)
				unit_exact_facing2 = read_bit(m_unit + 0x47A, 5) -- True when AI is walking forward (from aLTis)
				unit_actionkey2 = read_bit(m_unit + 0x47A, 6)	-- Confirmed. (True when pressing action key, False when not)
				unit_meleekey2 = read_bit(m_unit + 0x47A, 7)		-- Confirmed. (True when pressing melee key, False when not)
			--	unit_look_without_turn2 = read_bit(m_unit + 0x47A, 8) -- (???) Always false?
			--	unit_force_alert2 = read_bit(m_unit + 0x47A, 9) -- (???) Always false?
				unit_reload_key2 = read_bit(m_unit + 0x47A, 10)	-- Confirmed. (True when pressing action/reload key, False when not)
				unit_primaryWeaponFire_presshold2 = read_bit(m_unit + 0x47A, 11)	-- Confirmed. (True when holding left click, False when not)
				unit_secondaryWeaponFire_presshold2 = read_bit(m_unit + 0x47A, 12)	-- Confirmed. (True when holding right click, False when not)
				unit_grenade_presshold2 = read_bit(m_unit + 0x47A, 13)	-- Confirmed. (True when holding right click, False when not)
				unit_actionkey_presshold2 = read_bit(m_unit + 0x47A, 14)	-- Confirmed. (True when holding action key,  False when not)
			--	emptyBit[1] 15
			unit_weap_slot3 = read_byte(m_unit + 0x47C) -- Confirmed. (Primary = 0) (Secondary = 1) (Ternary = 2) (Quaternary = 3)
			unit_nade_type = read_byte(m_unit + 0x47E) -- Confirmed. (Frag = 0) (Plasma = 1)
			unit_zoom_level2 = read_word(m_unit + 0x480) -- Confirmed. The level of zoom the player is at. (0xFFFF = not zoomed, 0 = first zoom lvl, 1 = next zoom lvl, etc...)
			--Padding[2] 0x482-0x484
			unit_x_vel2 = read_float(m_unit + 0x484) -- Confirmed.
			unit_y_vel2 = read_float(m_unit + 0x488) -- Confirmed.
			unit_z_vel2 = read_float(m_unit + 0x48C) -- Confirmed.
			unit_primary_trigger = read_float(m_unit + 0x490) -- Confirmed. (1 = Holding down primaryFire button) (0 = not firing) Doesn't necessarily mean unit is shooting.
			unit_x_aim4 = read_float(m_unit + 0x494) -- Confirmed.
			unit_y_aim4 = read_float(m_unit + 0x498) -- Confirmed.
			unit_z_aim4 = read_float(m_unit + 0x49C) -- Confirmed.
			unit_x_aim5 = read_float(m_unit + 0x4A0) -- Confirmed.
			unit_y_aim5 = read_float(m_unit + 0x4A4) -- Confirmed.
			unit_z_aim5 = read_float(m_unit + 0x4A8) -- Confirmed.
			unit_x_aim6 = read_float(m_unit + 0x4AC) -- Confirmed.
			unit_y_aim6 = read_float(m_unit + 0x4B0) -- Confirmed.
			unit_z_aim6 = read_float(m_unit + 0x4B4) -- Confirmed.
			--	bitmask32:
				unit_last_completed_client_update_id_valid = read_bit(m_unit + 0x4B8, 0) -- From OS.
			--	unkBit[31] 1-31 (???)
			unit_last_completed_client_update_id = read_dword(m_unit + 0x4BC) -- From OS.
			--Padding[12] 0x4C0-0x4CC unused.
		end
		
		if obj_type == 0 then -- check if object is a biped.
		
			-- Biped Struct. Definition is a two legged creature, but applies to ALL AI and all players.
			m_biped = m_object
			
			--	bitmask32:
				bipd_is_airborne = read_bit(m_biped + 0x4CC, 0) -- Confirmed. (Airborne = True, No = False)
			--	bipd_is_slipping = read_bit(m_biped + 0x4CC, 1) -- (???) Always False?
			--	unkBit[30] 2-31
			landing_timer = read_byte(m_biped + 0x4D0) --	Counts up when biped lands, value gets higher depending on height (from aLTis)
			landing_strentgh = read_byte(m_biped + 0x4D1) --	Instantly changes to a value depenging of how hard the fall was (from aLTis)
			bipd_movement_state = read_byte(m_biped + 0x4D2) -- Confirmed. (Standing = 0) (Walking = 1) (Idle/Turning = 2) (Gesturing?? = 3)
			--unkByte[5] 0x4D3-0x4D8 (Padding Maybe?)
			bipd_action = read_byte(m_biped + 0x4D8) -- Tested. Something to do with walking and jumping.
			--unkByte[1] 0x4D9-0x4DA (Padding Maybe?)
			bipd_action2 = read_byte(m_biped + 0x4DA) -- Tested. Something to do with walking and jumping.
			--unkByte[5] 0x4DB (???)
			bipd_x_coord = read_float(m_biped + 0x4E0) -- Confirmed.
			bipd_y_coord = read_float(m_biped + 0x4E4) -- Confirmed.
			bipd_z_coord = read_float(m_biped + 0x4E8) -- Confirmed.
			bipd_walking_counter = read_long(0x4EC) --	Counts up every time biped moves, not sure what's the type of this value though (from aLTis)
			bipd_bumped_obj_id = readident(m_biped + 0x4FC) -- Confirmed. Object ID of any object you bump into (rocks, weapons, players, vehicles, ANY object)
			bipd_time_since_last_bump = readchar(m_biped + 0x500) -- Tested. Counts backwards from 0 to -15 when bumped. Glitchy. Don't rely on this.
			bipd_airborne_time = readchar(m_biped + 0x501) -- Confirmed. (1 sec = 30 ticks)
			bipd_slipping_time = readchar(m_biped + 0x502) -- Counts up when hit by a grenade (from aLTis)
			bipd_walking_direction =  read_char(m_biped + 0x503) -- 0 when not walking, 1 when walking forward etc (from aLTis)
			bipd_jump_time = readchar(m_biped + 0x504) -- Tested. Counts up from 0 after landing from a jump, and returns to 0 after you hit the ground (1 sec = 30 ticks).
			--unkChar[2] 0x505-0x507 sbyte timer, melee related.
			--Padding[1] 0x507-0x508
			--unkWord[1] 0x508-0x50A (???)
			--Padding[2] 0x50A-0x50C
			bipd_crouch_scale = read_float(m_biped + 0x50C) -- Confirmed. How crouched you are. (0 to 1) (Crouching = 1) (Standing = 0)
			--unkFloat[1] 0x510-0x514 (???)
			--unk_realPlane3d[1] 0x514-0x524 physics related (xyzd)
			--unkChar[2] 0x524-0x526 (???)
			--	bitmask8
				bipd_baseline_valid = read_bit(m_biped + 0x526, 0) -- From OS.
			--	unkBit[7] 1-7 (???)
			bipd_baseline_index = readchar(m_biped + 0x527) -- From OS.
			bipd_message_index = readchar(m_biped + 0x528) -- From OS.
			--Padding[3] 0x529-0x52C
			
			--	baseline update
			bipd_primary_nades = read_byte(m_biped + 0x52C) -- Confirmed. Number of frag grenades.
			bipd_secondary_nades = read_byte(m_biped + 0x52D) -- Confirmed. Number of plasma grenades.
			--Padding[2] 0x52E-0x530
			bipd_health = read_float(m_biped + 0x530) -- Confirmed. (0 to 1). Lags behind obj_health.
			bipd_shield = read_float(m_biped + 0x534) -- Confirmed. (0 to 1). Lags behind obj_health.
			--	bitmask8
				bipd_shield_stun_time_greater_than_zero = read_bit(m_biped + 0x538, 0) -- From OS.
			--	unkBit[7] 1-7 (???)
			--Padding[3] 0x539-0x53C
			--	bitmask8
			--	unkBit[8] 0x53C 0-7 (???)
			--Padding[3] 0x53D-0x540
			
			--	delta update
			--bipd_primary_nades2 = read_byte(m_biped + 0x540) -- (???) Always 0?
			--bipd_secondary_nades2 = read_byte(m_biped + 0x541) -- (???) Always 0?
			--Padding[2] 0x542-0x544
			--bipd_health2 = read_float(m_biped + 0x544) -- (???) Always 0? (0 to 1)
			--bipd_shield2 = read_float(m_biped + 0x548) -- (???) Always 0? (0 to 1)
			--	bitmask8
				bipd_shield_stun_time_greater_than_zero2 = read_bit(m_biped + 0x54C, 0) -- From OS.
			--	unkBit[7] 1-7 (???)
			--Padding[3] 0x54D-0x550
			
			--these are all just friggin rediculous...
			function getBodyPart(address, offset)
				address = address + (offset or 0x0)
				local bodypart = {}
				--this puts unknown floats in the table.
				--accessed by hprintf(bodypart.unkfloat1) hprintf(bodypart.unkfloat2) etc...
				for i = 0,9 do
					bodypart["unkfloat"..i+1] = read_float(address + i*4) -- (???) Probably rotations.
				end
				--accessed by hprintf(bodypart.x) hprintf(bodypart.y) etc...
				bodypart.x = read_float(address + 0x28) -- Confirmed.
				bodypart.y = read_float(address + 0x2C) -- Confirmed.
				bodypart.z = read_float(address + 0x30) -- Confirmed.
				return bodypart
			end
			
			function getBodyPartLocation(address, offset)
				address = address + (offset or 0x0)
				--unkFloats[10] (???) Probably rotations.
				bipd_bodypart_x = read_float(m_biped + 0x28)
				bipd_bodypart_y = read_float(m_biped + 0x2C)
				bipd_bodypart_z = read_float(m_biped + 0x30)
				return bipd_bodypart_x,bipd_bodypart_y,bipd_bodypart_z
			end

			--All of these are from SuperAbyll.
			--getBodyPart returns a table full of x,y,z coords + unknown floats
			--getBodyPartLocation returns 3 values (x, y, and z coordinates)
			bipd_left_thigh = getBodyPart(m_biped + 0x550)
				--if you just want the coordinates, you can do this instead for each bodypart:
				x,y,z = getBodyPartLocation(m_biped + 0x550) -- XYZ coordinates for the left thigh.
			bipd_right_thigh = getBodyPart(m_biped + 0x584)
			bipd_pelvis = getBodyPart(m_biped + 0x5B8)
			bipd_left_calf = getBodyPart(m_biped + 0x5EC)
			bipd_right_calf = getBodyPart(m_biped + 0x620)
			bipd_spine = getBodyPart(m_biped + 0x654)
			bipd_left_clavicle = getBodyPart(m_biped + 0x688)
			bipd_left_foot = getBodyPart(m_biped + 0x6BC)
			bipd_neck = getBodyPart(m_biped + 0x6F0)
			bipd_right_clavicle = getBodyPart(m_biped + 0x724)
			bipd_right_foot = getBodyPart(m_biped + 0x758)
			bipd_head = getBodyPart(m_biped + 0x78C)
			bipd_left_upper_arm = getBodyPart(m_biped + 0x7C0)
			bipd_right_upper_arm = getBodyPart(m_biped + 0x7F4)
			bipd_left_lower_arm = getBodyPart(m_biped + 0x828)
			bipd_right_lower_arm = getBodyPart(m_biped + 0x85C)
			bipd_left_hand = getBodyPart(m_biped + 0x890)
			bipd_right_hand = getBodyPart(m_biped + 0x8C4)
			
			--The coordinates from these can be accessed doing the following
			--let's say I want to tell the whole server the y coordinate of this object's right foot. I would do: say(bipd_right_foot.y)
			say(bipd_right_foot.y) -- **SERVER**: 52.7130341548629
		
		elseif obj_type == 1 then -- check if object is a vehicle
		
			-- vehi struct
			-- Thank you 002 and shaft for figuring out that there's a struct here:
			--	bitmask16:
			--	unkBit[2] 0x4CC 0-1
			vehi_crouch = read_bit(m_vehicle + 0x4CC, 2)
			vehi_jump = read_bit(m_vehicle + 0x4CC, 3)
			--	unkBit[4] 0x4CC 4-7
			--unkWord[1] 0x4CE
			--unkByte[4] 0x4D0-0x4D4
			vehi_speed = read_float(m_vehicle + 0x4D4)
			vehi_slide = read_float(m_vehicle + 0x4D8)
			vehi_turn = read_float(m_vehicle + 0x4DC)
			vehi_tireposition = read_float(m_vehicle + 0x4E0)
			vehi_treadpositionleft = read_float(m_vehicle + 0x4E4)
			vehi_treadpositionright = read_float(m_vehicle + 0x4E8)
			vehi_hover = read_float(m_vehicle + 0x4EC)
			vehi_thrust = read_float(m_vehicle + 0x4F0)
			--unkByte[4] 0x4F4-0x4F8 something to do with suspension states... enum?
			vehi_hoveringposition_x = read_float(m_vehicle + 0x4FC)
			vehi_hoveringposition_y = read_float(m_vehicle + 0x500)
			vehi_hoveringposition_z = read_float(m_vehicle + 0x504)
			--unkLong[7] 0x508-0x524
			--	bitmask16
				vehi_networkTimeValid = read_bit(m_vehicle + 0x524, 0)
			--	unkBit[7] 1-7
				vehi_baselineValid = read_bit(m_vehicle + 0x524, 8)
			--	unkBit[7] 9-15
			vehi_baselineIndex = read_byte(m_vehicle + 0x526)
			vehi_messageIndex = read_byte(m_vehicle + 0x527)
			--	bitmask32
				vehi_at_rest = read_bit(m_vehicle + 0x528, 0)
			--	unkBit[30] 1-31
			vehi_x_coord = read_float(m_vehicle + 0x52C)
			vehi_y_coord = read_float(m_vehicle + 0x530)
			vehi_z_coord = read_float(m_vehicle + 0x534)
			vehi_x_vel = read_float(m_vehicle + 0x538)
			vehi_y_vel = read_float(m_vehicle + 0x53C)
			vehi_z_vel = read_float(m_vehicle + 0x540)
			vehi_x_aim_vel = read_float(m_vehicle + 0x544)
			vehi_y_aim_vel = read_float(m_vehicle + 0x548)
			vehi_z_aim_vel = read_float(m_vehicle + 0x54C)
			vehi_pitch = read_float(m_vehicle + 0x550)
			vehi_yaw = read_float(m_vehicle + 0x554)
			vehi_roll = read_float(m_vehicle + 0x558)
			vehi_x_scale = read_float(m_vehicle + 0x55C)
			vehi_y_scale = read_float(m_vehicle + 0x560)
			vehi_z_scale = read_float(m_vehicle + 0x564)
			--Padding[4] 0x568-0x56C
			vehi_x_coord2 = read_float(m_vehicle + 0x56C)
			vehi_y_coord2 = read_float(m_vehicle + 0x570)
			vehi_z_coord2 = read_float(m_vehicle + 0x574)
			vehi_x_vel2 = read_float(m_vehicle + 0x578)
			vehi_y_vel2 = read_float(m_vehicle + 0x57C)
			vehi_z_vel2 = read_float(m_vehicle + 0x580)
			vehi_x_aim_vel2 = read_float(m_vehicle + 0x584)
			vehi_y_aim_vel2 = read_float(m_vehicle + 0x588)
			vehi_z_aim_vel2 = read_float(m_vehicle + 0x58C)
			vehi_pitch2 = read_float(m_vehicle + 0x590)
			vehi_yaw2 = read_float(m_vehicle + 0x594)
			vehi_roll2 = read_float(m_vehicle + 0x598)
			vehi_x_scale2 = read_float(m_vehicle + 0x59C)
			vehi_y_scale2 = read_float(m_vehicle + 0x5A0)
			vehi_z_scale2 = read_float(m_vehicle + 0x5A4)
			--Padding[4] 0x5A8-0x5AC
			vehi_some_timer = read_dword(m_vehicle + 0x5AC) -- Untested. 0xFFFFFFFF if vehicle not active.

			--block index of the scenario datum used for respawning
			--For all game engines besides race, this will be a scenario vehicle datum
			--For race, it's a scenario_netpoint, aka "scenario_netgame_flags_block"
			vehi_respawn_timer = read_word(m_vehicle + 0x5B0) -- Confirmed. (1 sec = 30 ticks)
			--Padding[2] 0x5B2-0x5B4
			vehi_some_x_coord = read_float(m_vehicle + 0x5B4) -- Respawn coordinates
			vehi_some_y_coord = read_float(m_vehicle + 0x5B8) -- Respawn coordinates
			vehi_some_z_coord = read_float(m_vehicle + 0x5BC) -- Respawn coordinates
		end

	--server network struct
	network_machine_pointer = read_dword(network_struct) -- Confirmed.
	network_state = read_word(network_struct + 0x4) -- Confirmed. (Inactive = 0, Game = 1, Results = 2)
	--unkWord[1] 0x6 (???)
	network_name = readwidestring(network_struct + 0x8, 0x42) -- Confirmed. Current server name.
	--unkWord[3] 0x86 (Padding Maybe?)
	network_current_map = read_string(network_struct + 0x8C, 0x80) -- Confirmed. Current map the server is currently running.
	network_current_gametype = readwidestring(network_struct + 0x10C, 0x18) -- Confirmed. Current gametype that the server is currently running.
	--	partial of Gametype need to break them down.
	--	unkByte[39] (???)
	--	unkFloat[1] 0x160 (???) Always 1.
	network_score_limit = read_byte(network_struct + 0x164) -- Confirmed. Current score limit for gametype. (1 second = 30 ticks)
	--Padding[3] 0x165
	local ce = 0x0
	if game == "CE" then
		--This exists in CE but not PC, therefore making the struct size larger in CE.
		--unkByte[64] 0x168 (???)
		ce = 0x40
	end
	--unkFloat[1] 0x1A0+ce (???) --0xBAADF00D (lol)
	network_max_players = read_byte(network_struct + (0x1A5+ce)) -- Confirmed. The maximum amount of players allowed to join the server (sv_maxplayers)
	network_difficulty_level = read_word(network_struct + (0x1A6+ce)) -- Tested. For SP only. Always 1 for server.
	network_player_count = read_word(network_struct + (0x1A8+ce)) -- Confirmed. Total number of players currently in the server.
	--	client network struct
		client_struct_size = 0x20 -- Confirmed.
		client_network_struct = network_struct + 0x1AA+ce + player * client_struct_size -- Strange. It starts in the middle of the dword.
		client_name = readwidestring(client_network_struct, 12) -- Confirmed. Name of player.
		client_color = read_word(client_network_struct + 0x18) -- Confirmed. Color of the player (ffa gametypes only.) (0 = white) (1 = black) (2 = red) (3 = blue) (4 = gray) (5 = yellow) (6 = green) (7 = pink) (8 = purple) (9 = cyan) (10 = cobalt) (11 = orange) (12 = teal) (13 = sage) (14 = brown) (15 = tan) (16 = maroon) (17 = salmon)
		client_icon_index = read_word(client_network_struct + 0x1A) -- From OS.
		client_machine_index = read_byte(client_network_struct + 0x1C) -- Confirmed. Player machine index (or rconId - 1)
		client_status = read_byte(client_network_struct + 0x1D) -- From Phasor. (1 = Genuine, 2 = Invalid hash (or auth, or w/e))
		client_team = read_byte(client_network_struct + 0x1E) -- Confirmed. (0 = red) (1 = blue)
		client_player_id = read_byte(client_network_struct + 0x1F) -- Confirmed. Player memory id/index (0 - 15) (To clarify: this IS the 'player' argument passed to phasor functions)
	--Padding[2] 0x3AA+ce
	network_game_random_seed = read_dword(network_struct + (0x3AC+ce)) -- Tested.
	network_games_played = read_dword(network_struct + (0x3B0+ce)) -- Confirmed. Total number of games played. (First game = 1, Second game = 2, etc..)
	network_local_data = read_dword(network_struct + (0x3B4+ce)) -- From OS.
	--	client_machine_info struct
		client_machineinfo_size = 0x60
		if game == "CE" then
			client_machineinfo_size = 0xEC
		end
		client_machineinfo_struct = network_struct + 0x3B8+ce + player * client_machineinfo_size
		client_connectioninfo_pointer = read_dword(client_machineinfo_struct) -- From Phasor.
	--	Padding[8] 0x4
		client_machine_index = read_word(client_machineinfo_struct + 0xC) -- Confirmed. Player machine index (or rconId - 1)
	--	unkWord[1] 0xE (Padding Maybe?)
		client_machine_unknown = read_word(client_machineinfo_struct + 0x10) -- From DZS. First is 1, then 3, then 7 and back to 0 if not in used (1 is found during the CD Hash Check, 7 if currently playing the game)
	--	unkWord[1] 0x12 (Padding Maybe?)
	--	unkLong[2] 0x14 (???)
	--	unkLong[1] 0x1C (???) most of the time 1, but sometimes changes to 2 for a moment.
	--	unkLong[1] 0x20 (???)
	--		action bitmask 16
			client_crouch = read_bit(client_machineinfo_struct + 0x24, 0) -- From DZS.
			client_jump = read_bit(client_machineinfo_struct + 0x24, 1) -- From DZS.
			client_flashlight = read_bit(client_machineinfo_struct + 0x24, 2) -- From DZS.
	--		unkBit[5] 3-7
			client_reload = read_bit(client_machineinfo_struct + 0x24, 8) -- From DZS.
			client_fire = read_bit(client_machineinfo_struct + 0x24, 9) -- From DZS.
			client_actionkey = read_bit(client_machineinfo_struct + 0x24, 10) -- From DZS.
			client_grenade = read_bit(client_machineinfo_struct + 0x24, 11) -- From DZS.
	--		unkBit[4] 12-15
	--	unkWord[1] 0x26 (Padding Maybe?)
		client_yaw = read_float(client_machineinfo_struct + 0x28) -- From DZS.
		client_pitch = read_float(client_machineinfo_struct + 0x2C) -- From DZS.
		client_roll = read_float(client_machineinfo_struct + 0x30) -- From DZS.
	--	unkByte[8] 0x34 (???)
		client_forwardVelocityMultiplier = read_float(client_machineinfo_struct + 0x3C) -- From DZS.
		client_horizontalVelocityMultiplier = read_float(client_machineinfo_struct + 0x40) -- From DZS.
		client_ROFVelocityMultiplier = read_float(client_machineinfo_struct + 0x44) -- From DZS.
		client_weap_type = read_word(client_machineinfo_struct + 0x48) -- Confirmed. (Primary = 0, Secondary = 1, Tertiary = 2, Quaternary = 3)
		client_nade_type = read_word(client_machineinfo_struct + 0x4A) -- Confirmed. (Frag Grenades = 0, Plasma Grenades = 1)
		--unkWord[1] 0x4C The index is -1 if no choices are even available.
		--unkWord[2] 0x4E
		client_machine_encryption_key = read_string(client_machineinfo_struct + 0x52, 0xA) -- From Phasor. Used for encrypting packets.
		client_machineNum = read_dword(client_machineinfo_struct + 0x5C) -- From Phasor. 0 - 0xFFFFFFFF Increased for each connection in server's life.
		if game == "CE" then
			client_last_player_name = read_string(client_machineinfo_struct + 0x60) -- Confirmed. Changes to the player name when they quit. (Could be useful for BOS if PC had this too :/)
			client_machine_ip_address = read_string(client_machineinfo_struct + 0x80, 32) -- From Phasor.
			client_machine_player_cdhash = read_string(client_machineinfo_struct + 0xA0, 32) -- From Phasor.
			--unkByte[76] 0xC0 (???) Maybe Padding? Nothing here. Possibly was going to be used for something else?
		end
		
	-- machine struct
	--I've found two methods of getting this struct :D
	local method = 1
	if method == 1 then
		machine_base = read_dword(network_machine_pointer) -- Confirmed.
		machine_table = machine_base + 0xAA0 -- Confirmed. Player machine table
		machine_struct = read_dword(machine_table + player_machine_index*4) -- Confirmed. Player machine struct
	elseif method == 2 then
		--This is the way most server apps do it (including Phasor) since it's less lines of code.
		machine_table = read_dword(client_connectioninfo_pointer)
		machine_struct = read_dword(machine_table)
		machine_network = read_dword(machine_network)
	end
	machine_player_first_ip_byte = read_byte(machine_struct) -- Confirmed. 127 if host.
	machine_player_second_ip_byte = read_byte(machine_struct + 0x1) -- Confirmed. 0 if host.
	machine_player_third_ip_byte = read_byte(machine_struct + 0x2) -- Confirmed. 0 if host.
	machine_player_fourth_ip_byte = read_byte(machine_struct + 0x3) -- Confirmed. 1 if host.
	machine_player_ip_address = string.format("%i.%i.%i.%i", machine_player_first_ip_byte, machine_player_second_ip_byte, machine_player_third_ip_byte, machine_player_fourth_ip_byte) -- Player's IP Address (127.0.0.1 if host)
	machine_player_port = read_word(machine_struct + 0x4) -- Confirmed. Usually 2303.
		
		-- address/offset checker
		--hprintf("---")

		--[[local offset = 0x0

		while offset < camera_size do

			if read_byte(camera_base, offset) ~= nil then
				hprintf(string.format("%X", offset) .. " - " .. read_byte(camera_base, offset))
			end

			offset = offset + 0x1

		end]]--
	end
end

function OnObjectCreation(m_objectId)
	local m_object = getobject(m_objectId)
	if m_object then
		local obj_type = read_word(m_object + 0xB4)
		if obj_type == 2 or obj_type == 3 or obj_type == 4 then
			-- item struct
			-- This applies to equipment, weapons, and garbage only.
			item_struct = m_object
			
			--	bitmask32:
				item_in_inventory = read_bit(item_struct + 0x1F4, 0) -- From OS.
			--	unkBit[31] 1-31 (Padding Maybe?)
			item_detonation_countdown = read_word(item_struct + 0x1F8) -- Confirmed. (1 sec = 30 ticks)
			item_collision_surface_index = read_word(item_struct + 0x1FA) -- From OS.
			item_structure_bsp_index = read_word(item_struct + 0x1FC) -- From OS.
			--Padding[2] 0x1FE-0x200
			item_unknown_obj_id = readident(item_struct + 0x200)
			item_last_update_time = read_dword(item_struct + 0x204) -- From OS.
			item_unknown_obj_id2 = readident(item_struct + 0x208)
			item_unknown_x_coord = read_float(item_struct + 0x20C)
			item_unknown_y_coord = read_float(item_struct + 0x210)
			item_unknown_z_coord = read_float(item_struct + 0x214)
			item_unknown_x_vel = read_float(item_struct + 0x218)
			item_unknown_y_vel = read_float(item_struct + 0x21C)
			item_unknown_z_vel = read_float(item_struct + 0x220)
			item_unknown_xy_angle = read_float(item_struct + 0x224)
			item_unknown_z_angle = read_float(item_struct + 0x228)
			
			if obj_type == 2 then -- weapons
			
				-- weap struct
				weap_struct = m_object
				
				weap_meta_id = read_dword(weap_struct) -- Confirmed with HMT. Tag Meta ID.
				weap_fuel = read_float(weap_struct + 0x124) -- Confirmed. Only for Flamethrower. (0 to 1)
				weap_charge = read_float(weap_struct + 0x140) -- Confirmed. Only for Plasma Pistol. (0 to 1)
				--	weapon flags bitmask32:
				--	unkBit[3] 0-2 (???)
					weap_must_be_readied = read_bit(weap_struct + 0x22C, 3) -- From OS.
				--	unkBit[28] 4-31 (???)
				--	ownerObjFlags bitmask16:
				--	unkBit[16] 0x230 0-15 (???)
				--Padding[2] 0x232-0x234
				weap_primary_trigger = read_float(weap_struct + 0x234) -- From OS.
				weap_state = read_byte(weap_struct + 0x238) -- From OS. (0 = Idle) (1 = PrimaryFire) (2 = SecondaryFire) (3 = Chamber1) (4 = Chamber2) (5 = Reload1) (6 = Reload2) (7 = Charged1) (8 = Charged2) (9 = Ready) (10 = Put Away)
				--Padding[1] 0x239-0x23A
				weap_readyWaitTime = read_word(weap_struct + 0x23A) -- From DZS.
				weap_heat = read_float(weap_struct + 0x23C) -- Confirmed. (0 to 1)
				weap_age = read_float(weap_struct + 0x240) -- Confirmed. Equal to 1 - batteries. (0 to 1)
				weap_illumination_fraction = read_float(weap_struct + 0x244) -- From OS.
				weap_light_power = read_float(weap_struct + 0x248) -- From OS.
				--Padding[4] 0x24C-0x250 Unused.
				weap_tracked_objId = readident(weap_struct + 0x250) -- From OS.
				--Padding[8] 0x254-0x25C Unused.
				weap_alt_shots_loaded = read_word(weap_struct + 0x25C) -- From OS.
				--Padding[2] 0x25E-0x260
		
				--Trigger State:
				--Padding[1] 0x260-0x261
				weap_trigger_state = read_byte(weap_struct + 0x261) -- From OS. Some counter.
				weap_trigger_time = read_word(weap_struct + 0x262) -- From OS.
				--	trigger_flags bitmask32:
				weap_trigger_currently_not_firing = read_bit(weap_struct + 0x264, 0) -- From DZS.
				--	unkBit[31] 0x264-0x268 1-31 (???)
				weap_trigger_autoReloadCounter = read_dword(weap_struct + 0x268) -- From DZS.
				--unkWord[2] 0x26C-0x26E firing effect related.
				weap_trigger_rounds_since_last_tracer = read_word(weap_struct + 0x26E) -- From OS.
				weap_trigger_rate_of_fire = read_float(weap_struct + 0x270) -- From OS.
				weap_trigger_ejection_port_recovery_time = read_float(weap_struct + 0x274) -- From OS.
				weap_trigger_illumination_recovery_time = read_float(weap_struct + 0x278) -- From OS.
				--unkFloat[1] 0x27C-0x280 used in the calculation of projectile error angle
				weap_trigger_charging_effect_id = readident(weap_struct + 0x280) -- From OS.
				--unkByte[4] 0x284-0x288 (???)
				--Padding[1] 0x288-0x289
				weap_trigger2_state = read_byte(weap_struct + 0x289) -- From OS. Some counter.
				weap_trigger2_time = read_word(weap_struct + 0x28A) -- From OS.
				--	trigger_flags bitmask32:
					weap_trigger2_currently_not_firing = read_bit(weap_struct + 0x28C, 0) -- From DZS.
				--	unkBit[31] 0x28C-0x290 1-31 (???)
				weap_trigger2_autoReloadCounter = read_dword(weap_struct + 0x290) -- From DZS.
				--unkWord[2] 0x294-0x296 firing effect related.
				weap_trigger2_rounds_since_last_tracer = read_word(weap_struct + 0x296) -- From OS.
				weap_trigger2_rate_of_fire = read_float(weap_struct + 0x298) -- From OS.
				weap_trigger2_ejection_port_recovery_time = read_float(weap_struct + 0x29C) -- From OS.
				weap_trigger2_illumination_recovery_time = read_float(weap_struct + 0x2A0) -- From OS.
				--unkFloat[1] 0x2A4-0x2A8 used in the calculation of projectile error angle
				weap_trigger2_charging_effect_id = readident(weap_struct + 0x2A8) -- From OS.
				--unkByte[4] 0x2AC-0x2B0 (???)
		
				--Primary Magazine State:
				weap_mag1_state = read_word(weap_struct + 0x2B0) -- From OS. (0 = Idle) (1 = Chambering Start) (2 = Chambering Finish) (3 = Chambering)
				weap_mag1_chambering_time = read_word(weap_struct + 0x2B2) -- From OS. Can set to 0 to finish reloading. (1 sec = 30 ticks)
				--unkWord[1] 0x2B4-0x2B6 game tick based value (animations?)
				weap_primary_ammo = read_word(weap_struct + 0x2B6) -- Confirmed. Unloaded ammo for magazine 1.
				weap_primary_clip = read_word(weap_struct + 0x2B8) -- Confirmed. Loaded clip for magazine 1.
				--unkWord[3] 0x2BA-0x2C0 game tick value,unkWord,possible enum
		
				--Secondary Magazine State:
				weap_mag2_state = read_word(weap_struct + 0x2C0) -- From OS. (0 = Idle) (1 = Chambering Start) (2 = Chambering Finish) (3 = Chambering)
				weap_mag2_chambering_time = read_word(weap_struct + 0x2C2) -- From OS. Can set to 0 to finish reloading. (1 sec = 30 ticks)
				--unkWord[1] 0x2C4-0x2C6 game tick based value (animations?)
				weap_secondary_ammo = read_word(weap_struct + 0x2C6) -- Confirmed. Unloaded ammo for magazine 1.
				weap_secondary_clip = read_word(weap_struct + 0x2C8) -- Confirmed. Loaded clip for magazine 1.
				--unkWord[3] 0x2CA-0x2D0 game tick value,unkWord,possible enum
				weap_last_fired_time = read_dword(weap_struct + 0x2D0) -- From DZS. gameinfo_current_time - this = time since this weapon was fired. (1 second = 30 ticks)
				weap_mag1_starting_total_rounds = read_word(weap_struct + 0x2D4) -- From OS. The total unloaded primary ammo the weapon has by default.
				weap_mag1_starting_loaded_rounds = read_word(weap_struct + 0x2D6) -- From OS. The total loaded primary clip the weapon has by default.
				weap_mag2_starting_total_rounds = read_word(weap_struct + 0x2D8) -- From OS. The total unloaded secondary ammo the weapon has by default.
				weap_mag2_starting_loaded_rounds = read_word(weap_struct + 0x2DA) -- From OS. The total loaded secondary clip the weapon has by default.
				--unkByte[4] 0x2DC-0x2E0 (Padding Maybe?)
				weap_baseline_valid = read_byte(weap_struct + 0x2E0) -- From OS.
				weap_baseline_index = read_byte(weap_struct + 0x2E1) -- From OS.
				weap_message_index = read_byte(weap_struct + 0x2E2) -- From OS.
				--Padding[1] 0x2E3-0x2E4
				weap_x_coord = read_float(weap_struct + 0x2E4) -- From OS.
				weap_y_coord = read_float(weap_struct + 0x2E8) -- From OS.
				weap_z_coord = read_float(weap_struct + 0x2EC) -- From OS.
				weap_x_vel = read_float(weap_struct + 0x2F0) -- From OS.
				weap_y_vel = read_float(weap_struct + 0x2F2) -- From OS.
				weap_z_vel = read_float(weap_struct + 0x2F4) -- From OS.
				--Padding[12] 0x2F8-0x300
				weap_primary_ammo2 = read_word(weap_struct + 0x300) -- From OS. Unloaded ammo for magazine 1.
				weap_secondary_ammo2 = read_word(weap_struct + 0x302) -- From OS. Unloaded ammo for magazine 2.
				weap_age2 = read_float(weap_struct + 0x304) -- From OS. Equal to 1 - batteries. (0 to 1)
				--Duplicates of above below this point, will add later.
			elseif obj_type == 3 then -- equipment
				
				-- eqip struct
				eqip_struct = item_struct
				
				--unkByte[16] 0x22C-0x23C (???) possibly unused?
				--unkByte[8] 0x23C-0x244 (???) possibly unused?
				--	bitmask8:
					eqip_baseline_valid = read_bit(eqip_struct + 0x244, 0) -- From OS.
				--	unkBit[7] 1-7 (Padding Maybe?)
				eqip_baseline_index = readchar(eqip_struct + 0x245) -- From OS.
				eqip_message_index = readchar(eqip_struct + 0x246) -- From OS.
				--Padding[1] 0x247-0x248
				-- baseline update
				eqip_x_coord = read_float(eqip_struct + 0x248) -- From OS.
				eqip_y_coord = read_float(eqip_struct + 0x24C) -- From OS.
				eqip_z_coord = read_float(eqip_struct + 0x250) -- From OS.
				eqip_x_vel = read_float(eqip_struct + 0x254) -- From OS.
				eqip_y_vel = read_float(eqip_struct + 0x258) -- From OS.
				eqip_z_vel = read_float(eqip_struct + 0x25C) -- From OS.
				eqip_pitch_vel = read_float(eqip_struct + 0x260) -- From OS.
				eqip_yaw_vel = read_float(eqip_struct + 0x264) -- From OS.
				eqip_roll_vel = read_float(eqip_struct + 0x268) -- From OS.
				
				--	delta update
				--	bitmask8:
					eqip_delta_valid = read_bit(eqip_struct + 0x26C, 0) -- Guess.
				--	unkBit[7] 1-7 (Padding Maybe?)
				--Padding[3] 0x26D-0x270
				eqip_x_coord2 = read_float(eqip_struct + 0x270) -- From OS.
				eqip_y_coord2 = read_float(eqip_struct + 0x274) -- From OS.
				eqip_z_coord2 = read_float(eqip_struct + 0x278) -- From OS.
				eqip_x_vel2 = read_float(eqip_struct + 0x27C) -- From OS.
				eqip_y_vel2 = read_float(eqip_struct + 0x280) -- From OS.
				eqip_z_vel2 = read_float(eqip_struct + 0x284) -- From OS.
				eqip_pitch_vel2 = read_float(eqip_struct + 0x288) -- From OS.
				eqip_yaw_vel2 = read_float(eqip_struct + 0x28C) -- From OS.
				eqip_roll_vel2 = read_float(eqip_struct + 0x290) -- From OS.
				
			elseif obj_type == 4 then -- garbage object
				
				-- garbage struct
				garb_struct = item_struct
				
				garb_time_until_garbage = read_word(garb_struct + 0x22C) -- From OS.
				--Padding[2] 0x22E-0x230
				--Padding[20] 0x230-0x244 unused
				
			elseif obj_type == 5 then -- projectile
				
				-- proj struct
				proj_struct = m_object
				
				--It appears Smiley didn't know how to read Open-Sauce very effectively, which explains the previous failure in this projectile structure's documentation:
				
				proj_mapId = readident(proj_struct + 0x0) -- Confirmed.
				--INSERT REST OF OBJECT STRUCT FROM 0x4 TO 0x1F4 HERE
				--Padding[52] 0x1F4-0x22C -- Item data struct not used in projectile.
				--unkBit[32] 0x22C-0x230 (???)
				proj_action = read_word(proj_struct + 0x230) -- From OS. (enum)
				--unkWord[1] 0x232-0x234 looks like some kind of index.
				proj_source_obj_id = readident(proj_struct + 0x234) -- From OS.
				proj_target_obj_id = readident(proj_struct + 0x238) -- From OS.
				proj_contrail_attachment_index = read_dword(proj_struct + 0x23C) -- From OS. index for the proj's definition's object_attachment_block, index is relative to object.attachments.attachment_indices or -1
				proj_time_remaining = read_float(proj_struct + 0x240) -- From OS. Time remaining to target.
				--unkFloat[1] 0x244-0x248 (???) related to detonation countdown timer
				--unkFloat[1] 0x248-0x24C (???)
				--unkFloat[1] 0x24C-0x250 (???) related to arming_time
				proj_range_traveled = read_word(proj_struct + 0x250) -- From OS. If the proj definition's "maximum range" is > 0, divide this value by "maximum range" to get "range remaining".
				proj_x_vel = read_float(proj_struct + 0x254) -- From OS.
				proj_y_vel = read_float(proj_struct + 0x258) -- From OS.
				proj_z_vel = read_float(proj_struct + 0x25C) -- From OS.
				--unkFloat[1] 0x260-0x264 set to water_damage_range's maximum.
				proj_pitch = read_float(proj_struct + 0x264) -- From OS.
				proj_yaw = read_float(proj_struct + 0x268) -- From OS.
				proj_roll = read_float(proj_struct + 0x26C) -- From OS.
				--unkFloat[2] 0x270-0x278 real_euler_angles2d
				--unkBit[8] 0x278-0x279 (???)
				--	bitmask8:
					proj_baseline_valid = read_bit(proj_struct + 0x279, 0) -- From OS.
				--	unkBit[7] 1-7
				proj_baseline_index = readchar(proj_struct + 0x27A) -- From OS.
				proj_message_index = readchar(proj_struct + 0x27B) -- From OS.
				
				--	baseline update
				proj_x_coord = read_float(proj_struct + 0x27C) -- From OS.
				proj_y_coord = read_float(proj_struct + 0x280) -- From OS.
				proj_z_coord = read_float(proj_struct + 0x284) -- From OS.
				proj_x_vel2 = read_float(proj_struct + 0x288) -- From OS.
				proj_y_vel2 = read_float(proj_struct + 0x28C) -- From OS.
				proj_z_vel2 = read_float(proj_struct + 0x290) -- From OS.
				--unkBit[8] 0x294-0x295 delta_valid?
				--Padding[3] 0x295-0x298
				
				--	delta update
				proj_x_coord2 = read_float(proj_struct + 0x298) -- From OS.
				proj_y_coord2 = read_float(proj_struct + 0x29C) -- From OS.
				proj_z_coord2 = read_float(proj_struct + 0x2A0) -- From OS.
				proj_x_vel3 = read_float(proj_struct + 0x2A4) -- From OS.
				proj_y_vel3 = read_float(proj_struct + 0x2A8) -- From OS.
				proj_z_vel3 = read_float(proj_struct + 0x2AC) -- From OS.
				
			elseif obj_type >= 6 and obj_type <= 9 then -- device
				
				-- device struct
				device_struct = m_object
				
				device_flags = read_dword(device_struct + 0x1F4) -- breakdown coming soon!
				device_power_group_index = read_word(device_struct + 0x1F8) -- From OS.
				--Padding[2] 0x1FA-0x1FC
				device_power_amount = read_float(device_struct + 0x1FC) -- From OS.
				device_power_change = read_float(device_struct + 0x200) -- From OS.
				device_position_group_index = read_word(device_struct + 0x204) -- From OS.
				--Padding[2] 0x206-0x208
				device_position_amount = read_float(device_struct + 0x208) -- From OS.
				device_position_change = read_float(device_struct + 0x20C) -- From OS.
				--	user interaction bitmask32:
					device_one_sided = read_bit(device_struct + 0x210, 0) -- From OS.
					device_operates_automatically = read_bit(device_struct + 0x210, 1) -- From OS.
				--	unkBit[30] 2-31 (Padding Maybe?)
				
				if obj_type == 7 then -- machine
					
					-- mach struct
					mach_struct = device_struct
					
					mach_flags = read_dword(mach_struct + 0x214) -- breakdown coming soon!
					mach_door_timer = read_dword(mach_struct + 0x218) -- Tested. looks like a timer used for door-type machines.
					mach_elevator_x_coord = read_dword(mach_struct + 0x21C) -- From OS.
					mach_elevator_y_coord = read_dword(mach_struct + 0x220) -- From OS.
					mach_elevator_z_coord = read_dword(mach_struct + 0x224) -- From OS.
					
				elseif obj_type == 8 then -- control
					
					-- ctrl struct
					ctrl_struct = device_struct
					
					ctrl_flags = read_dword(mach_struct + 0x214) -- breakdown coming soon!
					ctrl_custom_name_index = read_word(mach_struct + 0x218) -- From OS.
					--Padding[2] 0x21A-0x21C
				
				elseif obj_type == 9 then -- lightfixture
					
					--lightfixture struct
					lifi_struct = device_struct
					
					lifi_red_color = read_float(lifi_struct + 0x214) -- From OS.
					lifi_green_color = read_float(lifi_struct + 0x218) -- From OS.
					lifi_blue_color = read_float(lifi_struct + 0x21C) -- From OS.
					lifi_intensity = read_float(lifi_struct + 0x220) -- From OS.
					lifi_falloff_angle = read_float(lifi_struct + 0x224) -- From OS.
					lifi_cutoff_angle = read_float(lifi_struct + 0x228) -- From OS.
					
				end
			end
		end
	end
end

function readident(address, offset)
	address = address + (offset or 0)
	identity = read_dword(address) -- DWORD ID.
	--	Thank you WaeV for helping me wrap my head around this.
		ident_table_index = read_word(address) -- Confirmed. This is what most functions use. (player number, object index, etc)
		ident_table_flags = read_byte(address + 0x2) -- Tested. From Phasor. 0x44 by default, dunno what they're for.
		ident_type = read_byte(address + 0x3) -- Confirmed. [Object values: (Weapon = 6) (Vehicle = 8) (Others = -1) (Probably more)]
	return identity
end


function getplayer(player_number)
	player_number = tonumber(player_number) or raiseerror("bad argument #1 to getplayer (valid player required, got " .. tostring(type(player_number)) .. ")")
	-- player header setup
	local player_header = read_dword(player_header_pointer) - 0x8 -- Confirmed. (0x4029CE88)
	local player_header_size = 0x40 -- Confirmed.
	
	-- player header
	--Padding[8] 0x0-0x8
	local player_header_name = read_string(player_header + 0x8, 0xE) -- Confirmed. Always "players".
	--Padding[24] 0x10-0x20
	local player_header_maxplayers = read_word(player_header + 0x28) -- Confirmed. (0 - 16)
	local player_struct_size = read_word(player_header + 0x2A) -- Confirmed. (0x200 = 512)
	local player_header_data = read_string(player_header + 0x30, 0x4) -- Confirmed. Always "@t@d". Translates to data?
	local player_header_ingame = read_word(player_header + 0x34) -- Tested. Always seems to be 0 though... (In game = 0) (Not in game = 1)
	local player_header_current_players = read_word(player_header + 0x36) -- Confirmed.
	local player_header_next_player_id = readident(player_header + 0x38) -- Confirmed. Full DWORD ID of the next player to join.
	local player_header_first_player_struct = readident(player_header + 0x3C) -- Confirmed with getplayer(0). Player struct of the first player. (0x4029CEC8 for PC/CE)

	-- player struct setup
	local player_base = player_header + player_header_size -- Confirmed. (0x4029CEC8)
	local player_struct = player_base + (player_number * player_struct_size) -- Confirmed with getplayer(player).

	return player_struct

end

function getLowerWord16(x)
    local highervals = math.floor(x / 2 ^ 16)
    highervals = highervals * 2 ^ 16
    local lowervals = x - highervals
    return lowervals
end

function rshift(x, by)
	return math.floor(x / 2 ^ by)
end

function getobject(m_objectId)

	-- obj header setup
	local obj_header = read_dword(obj_header_pointer) -- Confirmed. (0x4005062C)
	local obj_header_size = 0x38 -- Confirmed.

	-- obj header
	local obj_header_name = read_string(obj_header, 0x6) -- Confirmed. Always "object".
	local obj_header_maxobjs = read_word(obj_header + 0x20) -- Confirmed. (0x800 = 2048 objects)
	local obj_table_size = read_word(obj_header + 0x22) -- Confirmed. (0xC = 12)
	local obj_header_data = read_string(obj_header + 0x28, 0x3) -- Confirmed. Always "@t@d". Translates to data?
	local obj_header_objs = read_word(obj_header + 0x2C) -- Needs to be tested.
	local obj_header_current_maxobjs = read_word(obj_header + 0x2E) -- Tested.
	local obj_header_current_objs = read_word(obj_header + 0x30) -- Tested.
	local obj_header_next_obj_index = read_word(obj_header + 0x32) -- Tested. Corresponds with obj_struct_obj_index.
	local obj_table_base_pointer = read_dword(obj_header + 0x34) -- Confirmed. (0x40050664)
	--local obj_header_next_obj_id = readident(obj_header + 0x34) -- Incorrect?
	--local obj_header_first_obj = readident(obj_header + 0x36) -- Incorrect?

	-- obj table setup
	local obj_table_index = getLowerWord16(m_objectId) -- grab last two bytes of objId
	local obj_table_flags = rshift(m_objectId, 4*4) - rshift(m_objectId, 6*4) * 0x100 -- part of the objId salt
	local obj_table_type = rshift(m_objectId, 6*4) -- part of the objId salt
	local obj_table_base = obj_header + obj_header_size -- Confirmed. (0x40050664)
	local obj_table_address = obj_table_base + (obj_table_index * obj_table_size) + 0x8 -- Confirmed.

	-- obj_table (needs testing)
	local obj_struct = read_dword(obj_table_address + 0x0) -- Confirmed with getobject().
	local obj_struct_obj_id = read_word(obj_table_address + 0x2) -- (???)
	local obj_struct_obj_index = read_word(obj_table_address + 0x4) -- Tested. Corresponds with obj_header_next_obj_index.
	local obj_struct_size = read_word(obj_table_address + 0x6) -- Wrong offset?

	return obj_struct

end

function gettagaddress(tagtype, tagname)

	-- map header
	local map_header_size = 0x800 -- Confirmed. (2048 bytes)
	local map_header_head = read_string(map_header_base, 4, true) -- Confirmed. "head" (head = daeh)
	local map_header_version = read_byte(map_header_base + 0x4) -- Confirmed. (Xbox = 5) (Trial = 6) (PC = 7) (CE = 0x261 = 609)
	local map_header_map_size = read_dword(map_header_base + 0x8, 0x3) -- Confirmed. (Bytes)
	local map_header_index_offset = read_dword(map_header_base + 0x10, 0x2) -- Confirmed. (Hex)
	local map_header_meta_data_size = read_dword(map_header_base + 0x14, 0x2) -- Confirmed. (Hex)
	local map_header_map_name = read_string(map_header_base + 0x20, 0x9) -- Confirmed.
	local map_header_build = read_string(map_header_base + 0x40, 12) -- Confirmed.
	local map_header_map_type = read_byte(map_header_base + 0x60) -- Confirmed. (SP = 0) (MP = 1) (UI = 2)
	-- Something from 0x64 to 0x67.
	local map_header_foot = read_string(map_header_base + 0x7FC, 4, true) -- Confirmed. "foot" (foot = toof)

	--tag table setup
	local map_base = read_dword(map_pointer) -- Confirmed. (0x40440000)
	local tag_table_base_pointer = read_dword(map_base)
	local tag_table_first_tag_id = read_dword(map_base + 0x4) -- Confirmed. Also known as the scenario tagId.
	local tag_table_tag_id = read_dword(map_base + 0x8) -- Confirmed. MapId/TagId for specified tag
	local tag_table_count = read_dword(map_base + 0xC) -- Confirmed. Number of tags in the tag table.
	local map_verticie_count = read_dword(map_base + 0x10)
	local map_verticie_offset = read_dword(map_base + 0x14)
	local map_indicie_count = read_dword(map_base + 0x18)
	local map_indicie_offset = read_dword(map_base + 0x1C)
	local map_model_data_size = read_dword(map_base + 0x20)
	local tag_table_tags = read_string(map_base + 0x24, 4, true) -- Confirmed. "tags" (tags = sgat)
	local tag_table_base = read_dword(map_base) -- Confirmed. (0x40440028)
	local tag_table_size = 0x20 -- Confirmed.
	local tag_allocation_size = 0x01700000 -- From OS.
	local tag_max_address = map_base + tag_allocation_size -- From OS. (0x41B40000)
	
	-- tag table
	-- the scenario is always the first tag located in the table.
	local scnr_tag_class1 = read_string(tag_table_base, 4, true) -- Confirmed. "weap", "obje", etc. (weap = paew). Never 0xFFFF.
	local scnr_tag_class2 = read_string(tag_table_base + 0x4, 4, true) -- Confirmed. "weap", "obje", etc. (weap = paew) 0xFFFF if not existing.
	local scnr_tag_class3 = read_string(tag_table_base + 0x8, 4, true) -- Confirmed. "weap", "obje", etc. (weap = paew) 0xFFFF if not existing.
	local scnr_tag_id = readident(tag_table_base + 0xC) -- Confirmed. TagID/MapID/MetaID
	local scnr_tag_name_address = read_dword(tag_table_base + 0x10) -- Confirmed. Pointer to the tag name.
		local scnr_tag_name = read_string(scnr_tag_name_address) -- Confirmed. Name of the tag ("weapons\\pistol\\pistol")
	local scnr_tag_data_address = read_dword(tag_table_base + 0x14) -- Confirmed. This is where map mods made with Eschaton/HMT/HHT are stored.
	--unkByte[8]
	
	local tag_address = 0
	for i=0,(tag_table_count - 1) do
	
		local tag_class = read_string(tag_table_base, (tag_table_size * i), 4)
		local tag_id = read_dword(tag_table_base + 0xC + (tag_table_size * i))
		local tag_name_address = read_dword(tag_table_base + 0x10 + tag_table_size * i)
		local tag_name = read_string(tag_name_address)
		
		--this function can accept mapId or tagtype, tagname
		if tag_id == tagtype or (tag_class == tagtype and tag_name == tagname) then
			tag_address = todec(read_dword(tag_table_base + 0x14 + (tag_table_size * i)))
			break
		end
		
	end

	return tag_address

end

function endian(address, offset, length)
	if offset and not length then
		length = offset
		offset = nil
	end
	local data_table = {}
	local data = ""

	for i=0,length do

		local hex = string.format("%X", read_byte(address, offset + i))

		if tonumber(hex, 16) < 16 then
			hex = 0 .. hex
		end

		table.insert(data_table, hex)

	end

	for k,v in pairs(data_table) do
		data = v .. data
	end

	return data

end

function tohex(number)
	return string.format("%X", number)
end

function todec(number)
	return tonumber(number, 16)
end