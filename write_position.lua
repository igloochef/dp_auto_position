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


if get_window_type() ~= 'WINDOW_TYPE_NORMAL' then
	return
end

local xid = get_window_xid()
local wlist = io.open(WINDOWS_FILE, 'r')
if wlist == nil then
	debug_print('C10: Cannot open ' .. WINDOWS_FILE)
	return
end

local rxid = 0
local lines = ''
while rxid ~= xid do
	if rxid ~= 0 then
		local line = wlist:read("*line")
		lines = lines .. rxid .. line .. '\n'
	end
	rxid = wlist:read("*number")
end

local wid = wlist:read("*line")
wid = string.gsub(wid, '\t', '')
lines = lines .. wlist:read("*all")
wlist:close()

wlist = io.open(WINDOWS_FILE, 'w')
if wlist == nil then
	debug_print('C20: Cannot open ' .. WINDOWS_FILE)
	return
end
wlist:write(lines)
wlist:close()

local xp, yp, w, h = get_window_geometry()
local max = tostring(get_window_is_maximized())
local full = tostring(get_window_fullscreen())

local pfile = io.open(POSITIONS_FILE, 'r')
local postxt = ''
if pfile ~= nil then
	postxt = pfile:read("*all")
	pfile:close()
end

local s, t = string.find(postxt, wid, 1, true)
if s == nil then
	-- write a new entry at the end of the config
	postxt = postxt .. wid .. '\t' .. xp .. ',' .. yp .. ',' .. w .. ',' .. h .. ',' ..
		max .. ',' .. full .. ',false,false,false\n'
else
	-- change the config
	local u, v = string.find(postxt, "\n", t + 1)
	if u == nil then
		debug_print('O40: End of line does not exist for entry "' .. wid .. '"')
		return
	end

	local proptxt = string.sub(postxt, t + 2, u)
	local props = {}
	for prop in string.gmatch(proptxt, '([^,]+)') do
		table.insert(props, prop)
	end

	if max == 'false' then
		props[1] = xp
		props[2] = yp
		props[3] = w
		props[4] = h
	end
	props[5] = max
	props[6] = full

	local begin = string.sub(postxt, 1, t + 1)
	local after = string.sub(postxt, v + 1, -1)
	postxt = begin
	for i,j in ipairs(props) do
		if i > 1 then
			postxt = postxt .. ','
		end
		postxt = postxt .. j
	end
	postxt = postxt .. after
end

pfile = io.open(POSITIONS_FILE, 'w')
if pfile == nil then
	debug_print('C40: Cannot open ' .. POSITIONS_FILE)
	return
end
pfile:write(postxt)
pfile:close()
