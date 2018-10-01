---------------------------------------------
-- Sniper tick remover                     --
-- Removes the sniper ticks in most maps   --
-- Lua script written by Michelle          --
-- Feed her by donating to paypal address: --
-- gbmichelle.halo@gmail.com               --
-- Thank you and enjoy                     --
---------------------------------------------

clua_version = 2.042

set_callback("map load", "OnMapLoad")

-- you can extend this list by adding a comma 
-- followed by another tag path in quotation marks.
sniper_tick_bitmaps = {
	"weapons\\sniper rifle\\bitmaps\\angle_ticks_black"
}

function OnMapLoad()
	-- Convert all tag paths that are found in the current map to ids
	sniper_tick_bitmap_ids = {}
	for k, v in pairs(sniper_tick_bitmaps) do
		tag = get_tag("bitmap", sniper_tick_bitmaps[k])
		if tag ~= nil then
			table.insert(sniper_tick_bitmap_ids, read_u32(tag + 12))
		end
	end
	
	-- count the number of tags found
	bitmap_count = 0
	for k, v in pairs(sniper_tick_bitmap_ids) do
		bitmap_count = bitmap_count + 1
	end
	if bitmap_count > 0 then
		-- Find all weapon hud interface tags
		weapon_hud_interfaces = {}
		tag_count = read_u32(0x40440000 + 12)
		for i=0,tag_count do
			cur_tag = 0x40440028 + 0x20 * i
			if read_u32(cur_tag) == 0x77706869 then --if cur_tag.primary_4cc == wphi
				table.insert(weapon_hud_interfaces, read_u32(cur_tag+0x14))
			end
		end
		
		-- Go through all weapon_hud_interfaces
		for k, v in pairs(weapon_hud_interfaces) do
			static_element_count = read_i32(weapon_hud_interfaces[k] + 96)
			static_element_ptr = read_u32(weapon_hud_interfaces[k] + 96 + 4)
			
			if static_element_count > 0 then
				for i=0,(static_element_count+1) do
					cur_stat_element = static_element_ptr + 180 * i
					cur_stat_element_tag_id = read_u32(cur_stat_element + 72 + 12)
					
					for w, v in pairs(sniper_tick_bitmap_ids) do
						if cur_stat_element_tag_id == sniper_tick_bitmap_ids[w] then
							write_float(cur_stat_element + 40, 0)
							write_float(cur_stat_element + 44, 0)
							write_u16(cur_stat_element + 48, 0)
						end
					end
				end
			end
		end
	end
end
