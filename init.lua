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

-- split and move window

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

-- enlarge window

enlarge_keys = {
	['s'] = 2,
	['d'] = 3,
	['f'] = 4,
	['g'] = 5,
}

for key, n in pairs(enlarge_keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, callbackFactory(function(win, f, max)
		local width = f.w * n
		if f.x + width > max.w then
			f.x = max.w - width
		end
		f.w = f.w * n
	end))
end

-- set window size

for i = 1, 6 do
	hs.hotkey.bind({'cmd', 'alt'}, tostring(i), callbackFactory(function(win, f, max)
		local width = max.w / i
		if f.x + width > max.w then
			f.x = max.w - width
		end
		f.w = width
		f.y = 0
		f.h = max.h
	end))
end

-- set window position

set_window_position_keys = {'q', 'w', 'e', 'r', 't', 'y'}

for index, key in pairs(set_window_position_keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, callbackFactory(function(win, f, max)
		local x = f.w * (index - 1)
		if x + f.w > max.w then
			f.x = max.w - f.w
		else
			f.x = x
		end
	end))
end

y_keys = {
	['z'] = { split = 1, index = 0 },
	['x'] = { split = 2, index = 0 },
	['c'] = { split = 2, index = 1 },
}

for key, val in pairs(y_keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, callbackFactory(function(win, f, max)
		f.y = max.y + max.h * val.index / val.split
		f.h = max.h / val.split
	end))
end
