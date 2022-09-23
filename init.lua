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

-- modal mode for characorder

m = hs.hotkey.modal.new('cmd-alt', 'm')
function m:entered() hs.alert('Entered mode') end
function m:exited() hs.alert('Exited mode') end
m:bind('', 'escape', function() m:exit() end)

-- grid cols setting

gcols = hs.settings.get('cols') or 4
hs.grid.setGrid(tostring(gcols) .. 'x2')
hs.grid.setMargins({ x = 0, y = 0 })

function setColsCallbackFactory(cols)
  return function()
        hs.settings.set('cols', cols)
        hs.grid.setGrid(tostring(cols) .. 'x2')
        hs.alert.show(tostring(cols) .. 'x2')
        gcols = cols
    end
end

for i = 2, 6 do
    setColsCallback = setColsCallbackFactory(i)
    hs.hotkey.bind({'cmd', 'alt'}, tostring(i), setColsCallback)
    m:bind('', tostring(i), setColsCallback)
end

-- show grid

function showGrid()
    hs.grid.show(true)
end

hs.hotkey.bind({'cmd', 'alt'}, 'g', showGrid)
m:bind('', 'g', showGrid)

-- snap to grid

function snapGrid()
    windows = hs.window.visibleWindows()
    for i = 1, #windows do
        window = windows[i]
        if window:isStandard() then
            hs.grid.snap(windows[i])
        end
    end
end

hs.hotkey.bind({'cmd', 'alt'}, 's', snapGrid)
m:bind('', 's', snapGrid)

-- left right split window

split_and_move_window_keys = {
    ['['] = {index = 0, split = 2},
    [']'] = {index = 1, split = 2},
    ['\\'] = {index = 0.5, split = 2},
    ['Left'] = {index = 0, split = 2},
    ['Right'] = {index = 1, split = 2},
    ['Down'] = {index = 0.5, split = 2},
}

for key, val in pairs(split_and_move_window_keys) do
    hs.hotkey.bind({'cmd', 'alt'}, key, callbackFactory(function(win, f, max)
        f.x = max.w * val.index / val.split
        f.w = max.w / val.split
        f.y = 0
        f.h = max.h
    end))
end

-- auto grid

wf_youtube_popup = hs.window.filter.new(function(w)
    title = w:title()
    return string.find(title, '- YouTube') and not string.find(title, '- Brave')
end)

hs.hotkey.bind({'cmd', 'alt'}, 'a', function()
    windows = wf_youtube_popup:getWindows()
    if #windows == 1 then
        hs.grid.set(windows[1], (tostring(gcols - 1)) .. ',0 1x2')
    else
        for i = 1, #windows do
            ci = gcols - 1 - math.floor((i - 1) / 2)
            ri = (i - 1) % 2
            hs.grid.set(windows[i], (tostring(ci)) .. ',' .. (tostring(ri)) .. ' 1x1')
        end
    end
end)

-- vim:sw=4:ts=4:sts=4:et
