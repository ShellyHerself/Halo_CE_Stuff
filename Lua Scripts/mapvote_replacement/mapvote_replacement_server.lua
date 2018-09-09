--Better Map Voting by Michelle
api_version = "1.9.0.0"


--- User Settings:
voting_time = 15 --seconds that you get for voting
voteds_reset_threshold = 10 --Depricated
vote_options_to_display = 5 --the amount of options to display
mapvote_file = "config\\mapvotes.txt"
maps_location = "maps\\"
maps_file_extension = ".map"
gametypes_location = "config\\savegames\\"
gametypes_file_name = "blam.lst"
path_seperator = "\\"

---


--- Runtime vars:

total_vote_options = 0
map_names = {}
vote_names = {}
vote_gametypes = {}
vote_mins = {}
vote_maxs = {}
voteds = {}
---

game_ended = false

function OnScriptLoad()
	execute_command("mapvote 0")
	register_callback(cb['EVENT_GAME_END'], "StartVotingRoutine")
	register_callback(cb['EVENT_GAME_START'], "EndVotingRoutine")
	register_callback(cb['EVENT_TICK'], "TickStuff")
	register_callback(cb['EVENT_CHAT'], "PlayerVote")
	open_mapvote_file = io.open(mapvote_file, "r")
	local j = 1
	local i = 0
	for _ in io.lines(mapvote_file) do
		i = i + 1
		current_line_text = open_mapvote_file:read("*l")
		if current_line_text ~= "" then
			local line = SplitLine(current_line_text, ":")
			local map_name = nil
			local gametype = nil
			local name = nil
			local vmin = nil
			local vmax = nil
			
			--- check if map exists
			if line[1] ~= nil then
				map_exists = io.open(maps_location .. line[1] .. maps_file_extension, "r")
				if map_exists ~= nil then
					map_name = line[1]
					io.close(map_exists)
				end
				
				
				--- check if gametype exists
				if line[2] ~= nil then
					gametype_exists = io.open(gametypes_location .. line[2] .. path_seperator .. gametypes_file_name, "r")
					if gametype_exists ~= nil then
						gametype = line[2]
						io.close(gametype_exists)
					end
					
					
					--- check if a name is specified for the voting options
					if line[3] ~= nil then
						name = line[3]
						
						--- check if min and max numbers exist for the gametype and set default ones if not
						if line[4] ~= nil then
							vmin = tonumber(line[4])
							
							if line[5] ~= nil then
								vmax = tonumber(line[5])
							end
						end
						
					end

				end
			end
			
			if map_name ~= nil and gametype ~= nil then
				total_vote_options = total_vote_options + 1
				map_names[j] = map_name
				vote_gametypes[j] = gametype
				vote_names[j] = name
				vote_mins[j] = vmin
				vote_maxs[j] = vmax
				if vote_names[j] == nil then
					vote_names[j] = map_name .. " - " .. gametype
				end
				if vote_mins[j] == nil then
					vote_mins[j] = 0
				end
				if vote_maxs[j] == nil then
					vote_maxs[j] = 16
				end

				voteds[j] = false
				
				cprint(total_vote_options .. ":" .. map_names[j] .. ":" .. vote_gametypes[j] .. ":" .. vote_names[j] .. ":" .. vote_mins[j] .. ":" .. vote_maxs[j])
				j = j + 1
			else
				cprint("Failed to add line: [" .. current_line_text .. "] map or gametype not found.")
			end
		end
		
	end
	io.close(open_mapvote_file)
end


number_of_possible_voting_options = 0
possible_voting_options = {}
possible_voting_chosen_bool = {}
possible_voting_options_score = {}
possible_voting_options_first_vote = {}

left_over_options = 0

selected_voting_options = {}
number_of_valid_voting_options = vote_options_to_display
player_voted_bool = {}

voting_options_ticks = 0
voting_options_ticks2 = 0


function StartVotingRoutine()

	voting_options_ticks = 0
	voting_options_ticks2 = 0
	
	for i=0,15 do
		player_voted_bool[i] = false
	end
	
	game_ended = true
	cprint("game_ended")
	GetPossibleVoteOptions()
	if number_of_possible_voting_options <= voteds_reset_threshold then
		GetPossibleVoteOptions()
	end

	
	for i=1,vote_options_to_display do
		math.randomseed(os.time()+i)
		local random_pick = 0
		if left_over_options > 1 then
			random_pick = math.random(1,left_over_options)
			local player_count = tonumber(get_var(1, "$pn"))
			if player_count == 0 then
				possible_voting_options_score[random_pick] = 1
				--cprint("player_count == 0, skipping voting routine and picking a random")
				return
			end
		else
			random_pick = 1
		end
		local current_left_over_id = 0
		for j=1,number_of_possible_voting_options+1 do
			if possible_voting_chosen_bool[j] == false then
				current_left_over_id = current_left_over_id + 1
			end
			if current_left_over_id == random_pick then
				possible_voting_chosen_bool[j] = true
				left_over_options = left_over_options - 1
			end
		end
	end
	
	local voting_options_filled = 0
	for i=1,number_of_possible_voting_options+1 do
		if possible_voting_chosen_bool[i] == true then
			voting_options_filled = voting_options_filled + 1
			selected_voting_options[voting_options_filled] = i
			possible_voting_options_score[i] = 0
		end
	end

end

function EndVotingRoutine()
	game_ended = false
end


function PlayerVote(index, text_string)
	if game_ended == true then
		if tonumber(text_string) ~= nil then
		execute_command("say * \"" .. get_var(index, "$name") .. ": " .. text_string .. "\"")
			if player_voted_bool[index] == false then
			
				if tonumber(text_string) > 0 and tonumber(text_string) <= number_of_valid_voting_options then
					player_voted_bool[index] = true
						possible_voting_options_first_vote[selected_voting_options[tonumber(text_string)]] = voting_options_ticks2
					possible_voting_options_score[selected_voting_options[tonumber(text_string)]] = possible_voting_options_score[selected_voting_options[tonumber(text_string)]] + 1
				end
				CheckWinningMap()
			end
			return false
		end
		
		
	end
end


function TickStuff()
	if game_ended == true then
		CheckWinningMap()
		DisplayVotingOptions()
	end
end
highest_score = -1
highest_scoring = -1
highest_scoring_time_of_vote = 99999999999999999999999


function DisplayVotingOptions()
	--cprint(highest_scoring)
	voting_options_ticks = voting_options_ticks + 1
	if voting_options_ticks >= 10 then
		voting_options_ticks = 0
		if game_ended == true then
			number_of_valid_voting_options = vote_options_to_display
			if number_of_possible_voting_options < vote_options_to_display then
				number_of_valid_voting_options = number_of_possible_voting_options
			end
			for j=0,16 do
				for banana=0,35 do
					rprint(j, " ")
				end
				rprint(j, "Type the number of the map you want to vote for in the chat.")
				for i=1,number_of_valid_voting_options do
					if selected_voting_options[i] == highest_scoring then
					rprint(j, i .. " *" .. tostring(vote_names[possible_voting_options[selected_voting_options[i]]]) .. "   Votes: " .. tostring(possible_voting_options_score[selected_voting_options[i]]))
					else
					rprint(j, i .. " " .. tostring(vote_names[possible_voting_options[selected_voting_options[i]]]) .. "   Votes: " .. tostring(possible_voting_options_score[selected_voting_options[i]]))
					end
				end
			end
		end
	end
	voting_options_ticks2 = voting_options_ticks2 + 1
	if voting_options_ticks2 >= 30*voting_time and game_ended == true then
		game_ended = false
		SelectNextMap()
		
	end
end

function CheckWinningMap()
	if game_ended == true then
		highest_score = -1
		highest_scoring = -1
		
		highest_scoring_time_of_vote = 99999999999999999999999
		for i=1,number_of_possible_voting_options do
			if possible_voting_options_score[i] >= highest_score then
				if possible_voting_options_first_vote[i] < highest_scoring_time_of_vote then
				highest_score = possible_voting_options_score[i]
				highest_scoring = i
				--cprint(highest_scoring)
				highest_scoring_time_of_vote = possible_voting_options_first_vote[i]
				end
				if possible_voting_options_score[i] > highest_score then
				highest_score = possible_voting_options_score[i]
				highest_scoring = i
				end
			end
		end
		--cprint(highest_scoring)
	end
end


function SelectNextMap()
	for i=0,16 do
		for banana=0,35 do
			rprint(i, " ")
		end
		rprint(i, tostring(vote_names[possible_voting_options[highest_scoring]]) .. " WON!")
		execute_command("say " .. i .. " \"" .. tostring(vote_names[possible_voting_options[highest_scoring]]) .. " WON!" .. "\"" )
	end
	execute_command("map " .. map_names[possible_voting_options[highest_scoring]] .. " " .. vote_gametypes[possible_voting_options[highest_scoring]])

end



function GetPossibleVoteOptions()
local player_count = tonumber(get_var(1, "$pn"))
--cprint("Player count: " .. player_count)
number_of_possible_voting_options = 0
for i=1,total_vote_options do
	--cprint(i ..","..tostring(voteds[i])..","..tostring(vote_mins[i])..","..tostring(vote_maxs[i]))
	if voteds[i] ~= nil then
		if player_count >= vote_mins[i] and player_count <= vote_maxs[i] then
		number_of_possible_voting_options = number_of_possible_voting_options + 1
		possible_voting_options[number_of_possible_voting_options] = i
		possible_voting_chosen_bool[number_of_possible_voting_options] = false
		possible_voting_options_score[number_of_possible_voting_options] = -1
		possible_voting_options_first_vote[number_of_possible_voting_options] = 9999999999999999999999
		end
	end
	left_over_options = number_of_possible_voting_options
end
--cprint("Number of available voting options: " .. number_of_possible_voting_options)
end



function SplitLine(inputstr, sep)

	if sep == nil then
		sep = "%s"
	end
	
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	
return t
end


