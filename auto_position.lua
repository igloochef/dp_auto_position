-- Positions file parameters are in the format:
-- Class name [tab] x pos, y pos, width, height, maximized, full screen, pinned, skip task bar, ignore
--  *string*        *int*  *int*  *int*  *int*   *boolean*  *boolean*  *boolean*  *boolean*     *bool*


-- CONFIGURE THE FOLLOWING 3 PATHS TO MATCH YOUR SYSTEM

-- Path to the DevilsPie2 directory
CONFIG_PATH    = os.getenv( "HOME" ) .. '/.config/devilspie2'

-- Stored in a subdirectory of the DevilsPie2 directory to avoid extra processing by DevilsPie2
DP_SUBDIR      = CONFIG_PATH .. '/auto_position'
WINDOWS_FILE   = DP_SUBDIR .. '/windows'
POSITIONS_FILE = DP_SUBDIR .. '/positions'

-- CONFIGURATION NOT NEEDED PAST THIS POINT


function get_unique_window_id()
	-- Attempt to create a unique window identifier for the type of window
	local window_id = ''
	local class = get_window_class()
	local iname = get_class_instance_name()
	if class == '' or class == nil then
		window_id = get_window_name()
	else
		window_id = class .. '::' .. iname
		if get_window_role() ~= '' and string.len(get_window_role()) <= 20 then
			window_id = window_id .. '::' .. get_window_role()
		end
	end

	return window_id
end

-- Make sure DP_SUBDIR exists
os.execute('mkdir ' .. DP_SUBDIR .. ' 2> /dev/null')


if get_window_type() == 'WINDOW_TYPE_NORMAL' then
	local xid = get_window_xid()
	local wid = get_unique_window_id()

	local wlist = io.open(WINDOWS_FILE, 'a')
	if wlist == nil then
		debug_print('O10: Cannot open ' .. WINDOWS_FILE)
		return
	end
	wlist:write(xid .. '\t' .. wid .. '\n')
	wlist:close()

	local pfile = io.open(POSITIONS_FILE, 'r')
	if pfile == nil then
		debug_print('O20: Cannot open ' .. POSITIONS_FILE)
		return
	end
	local postxt = pfile:read("*all")
	pfile:close()

	local s, t = string.find(postxt, wid, 1, true)
	if s == nil then
		debug_print('O30: Cannot find "' .. wid .. '" in ' .. POSITIONS_FILE)
		return
	end

	local u, v = string.find(postxt, "\n", t + 1)
	if u == nil then
		debug_print('O40: End of line does not exist for entry "' .. wid .. '"')
		return
	end

	local proptxt = string.sub(postxt, t + 2, u - 1)
	local props = {}
	for prop in string.gmatch(proptxt, '([^,]+)') do
		table.insert(props, prop)
	end
	
	if props[9] == 'false' then
		set_window_position2(props[1], props[2])
		if props[5] == 'true' then
			maximize()
		end
		if props[6] == 'true' then
			set_window_fullscreen(true)
		end
		if props[7] == 'true' then
			pin_window()
		end
		if props[8] == 'true' then
			set_skip_tasklist(true)
		end
	end
end
