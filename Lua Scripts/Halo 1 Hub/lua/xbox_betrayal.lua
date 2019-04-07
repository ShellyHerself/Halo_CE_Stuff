-- Halo Xbox Betrayal emulation script.
-- By gbMichelle
-- Got helped for 2 hours by Derj while we both lost all out braincells and will to live.
-- Give the boy credit.

api_version = "1.9.0.0"

betrayed_someone = {}
betrayal_penalty_time_ptr = 0
function OnScriptLoad()
	register_callback(cb['EVENT_DIE'],"OnDeath")
	register_callback(cb['EVENT_BETRAY'],"OnBetrayal")
	register_callback(cb['EVENT_JOIN'],"OnJoin")
	for i=1,16 do
		betrayed_someone[i] = 0
	end
	betrayal_penalty_time_ptr = read_dword(sig_scan("B9360000008D74240CBF") + 10) + 0x70
	cprint(read_word(betrayal_penalty_time_ptr))
end


function OnBetrayal(betrayer, victim)
	victim = tonumber(victim)
	if get_player(victim) ~= 0 then
		write_dword(get_player(victim)+0x2C, read_dword(get_player(victim)+0x2C) + read_word(betrayal_penalty_time_ptr))
		betrayed_someone[betrayer] = betrayed_someone[betrayer] + 1
	end
end

function OnDeath(betrayer)
	if get_player(betrayer) ~= 0 then
		respawn_time = read_dword(get_player(betrayer)+0x2C) - betrayed_someone[betrayer]*read_word(betrayal_penalty_time_ptr)
		if respawn_time < 3 then respawn_time = 90 end
		write_dword(get_player(betrayer)+0x2C, respawn_time)
		betrayed_someone[betrayer] = 0
	end
end

function OnJoin(player)
	betrayed_someone[player] = 0
end

