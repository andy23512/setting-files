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

keys = {
	['1'] = {index = 0, split = 4},
	['2'] = {index = 1, split = 4},
	['3'] = {index = 2, split = 4},
	['4'] = {index = 3, split = 4},
	['5'] = {index = 0, split = 3},
	['6'] = {index = 1, split = 3},
	['7'] = {index = 2, split = 3},
	['8'] = {index = 0, split = 5},
	['9'] = {index = 1, split = 5},
	['0'] = {index = 2, split = 5},
	['-'] = {index = 3, split = 5},
	['='] = {index = 4, split = 5},
	['['] = {index = 0, split = 2},
	[']'] = {index = 1, split = 2},
}

enlarge_keys = {
	['q'] = 2,
	['w'] = 3,
	['e'] = 4,
}

hs.window.animationDuration = 0

function moveWindow(index, split)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.w * index / split
	f.y = max.y
	f.w = max.w / split
	f.h = max.h
	win:setFrame(f)
end

for key, val in pairs(keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, function()
		moveWindow(val.index, val.split)
	end)
end

function enlargeWindowWidth(n)
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	local width = f.w * n

	if f.x + width > max.w then
		f.x = max.w - width
	end

	f.w = f.w * n

	win:setFrame(f)
end

for key, val in pairs(enlarge_keys) do
	hs.hotkey.bind({'cmd', 'alt'}, key, function()
		enlargeWindowWidth(val)
	end)
end
