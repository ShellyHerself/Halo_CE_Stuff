-- A temp fix for the bsp changing checkpoint load crash in the current chimera unstable builds. By Michelle.
clua_version = 2.042
set_callback("tick", "OnTick")

last_bsp = 0

function OnTick()
	if last_bsp ~= read_u16(0x6397D0) then
		execute_script("game_save")
		last_bsp = read_u16(0x6397D0)
	end
end