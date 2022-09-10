-- reload config part

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- global setting part

hs.window.animationDuration = 0

-- global function

function callbackFactory(callback)
	return function()
		local win = hs.window.focusedWindow()
		local f = win:frame()
		local screen = win:screen()
		local max = screen:frame()
		callback(win, f, max)
		win:setFrame(f)
	end
end

-- grid cols setting

cols = hs.settings.get('cols') or 4
hs.grid.setGrid(tostring(cols) .. 'x2')
hs.grid.setMargins({ x = 0, y = 0 })

for i = 3, 5 do
	hs.hotkey.bind({'cmd', 'alt'}, tostring(i), function()
		hs.settings.set('cols', i)
		hs.grid.setGrid(tostring(i) .. 'x2')
		hs.alert.show(tostring(i) .. 'x2')
	end)
end

-- set window to cell

set_cell_keys = {
	['q'] = '0,0 1x1',
	['a'] = '0,1 1x1',
	['w'] = '1,0 1x1',
	['s'] = '1,1 1x1',
	['e'] = '2,0 1x1',
	['d'] = '2,1 1x1',
	['r'] = '3,0 1x1',
	['f'] = '3,1 1x1',
	['t'] = '4,0 1x1',
	['g'] = '4,1 1x1',
	['z'] = '0,0 1x2',
	['x'] = '1,0 1x2',
	['c'] = '2,0 1x2',
	['v'] = '3,0 1x2',
	['b'] = '4,0 1x2',
}

for key, val in pairs(set_cell_keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, function()
		local win = hs.window.focusedWindow()
		hs.grid.set(win, val)
	end)
end

-- wider window

hs.hotkey.bind({'cmd', 'alt'}, 'Right', function()
	local win = hs.window.focusedWindow()
	hs.grid.resizeWindowWider(win)
end)

-- taller window

hs.hotkey.bind({'cmd', 'alt'}, 'Down', function()
	local win = hs.window.focusedWindow()
	hs.grid.resizeWindowTaller(win)
end)

-- left right split window

split_and_move_window_keys = {
	['['] = {index = 0, split = 2},
	[']'] = {index = 1, split = 2},
}

for key, val in pairs(split_and_move_window_keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, callbackFactory(function(win, f, max)
		f.x = max.w * val.index / val.split
		f.w = max.w / val.split
		f.y = 0
		f.h = max.h
	end))
end
