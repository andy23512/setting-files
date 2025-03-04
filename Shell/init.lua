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

-- fix bug for animation duration and grid

local function axHotfix(win)
    if not win then win = hs.window.frontmostWindow() end

    local axApp = hs.axuielement.applicationElement(win:application())
    local wasEnhanced = axApp.AXEnhancedUserInterface
    axApp.AXEnhancedUserInterface = false

    return function()
        hs.timer.doAfter(hs.window.animationDuration * 2, function()
            axApp.AXEnhancedUserInterface = wasEnhanced
        end)
    end
end

local function withAxHotfix(fn, position)
    if not position then position = 1 end
    return function(...)
        local revert = axHotfix(select(position, ...))
        fn(...)
        revert()
    end
end

local windowMT = hs.getObjectMetatable("hs.window")
windowMT._setFrameInScreenBounds = windowMT._setFrameInScreenBounds or windowMT.setFrameInScreenBounds -- Keep the original, if needed
windowMT.setFrameInScreenBounds = withAxHotfix(windowMT.setFrameInScreenBounds)

-- global setting part

hs.window.animationDuration = 0

-- global function

function callbackFactory(callback)
    return function()
        wf_all:pause()
        local win = hs.window.focusedWindow()
        if win ~= nil then
            local f = win:frame()
            local screen = win:screen()
            local max = screen:frame()
            callback(win, f, max)
            win:setFrame(f, 0)
        end
        hs.timer.doAfter(1, function() wf_all:resume() end)
    end
end

-- grid cols setting

grid_hints = {
    [2] = {
        {'1', '2'},
        {'1', '2'},
        {'k', 'f'},
        {'c', 'd'},
        {'1', '2'},
    },
    [3] = {
        {'1', '2', '3'},
        {'1', '2', '3'},
        {'k', 'f', 'a'},
        {'c', 'd', 't'},
        {'1', '2', '3'},
    },
    [4] = {
        {'1', '2', '3', '4'},
        {'1', '2', '3', '4'},
        {'r', 'k', 'f', 'a'},
        {'e', 'c', 'd', 't'},
        {'1', '2', '3', '4'},
    },
    [5] = {
        {'1', '2', '3', '4', '5'},
        {'1', '2', '3', '4', '5'},
        {'r', 'k', 'f', 'a', 'l'},
        {'e', 'c', 'd', 't', 'n'},
        {'1', '2', '3', '4', '5'},
    },
    [6] = {
        {'1', '2', '3', '4', '5', '6'},
        {'1', '2', '3', '4', '5', '6'},
        {'i', 'r', 'k', 'f', 'a', 'l'},
        {'o', 'e', 'c', 'd', 't', 'n'},
        {'1', '2', '3', '4', '5', '6'},
    },
    [7] = {
        {'1', '2', '3', '4', '5', '6', '7'},
        {'1', '2', '3', '4', '5', '6', '7'},
        {'i', 'r', 'k', 'f', 'a', 'l', 'y'},
        {'o', 'e', 'c', 'd', 't', 'n', 's'},
        {'1', '2', '3', '4', '5', '6', '7'},
    },
    [8] = {
        {'1', '2', '3', '4', '5', '6', '7', '8'},
        {'1', '2', '3', '4', '5', '6', '7', '8'},
        {'\'', 'i', 'r', 'k', 'f', 'a', 'l', 'y'},
        {'u', 'o', 'e', 'c', 'd', 't', 'n', 's'},
        {'1', '2', '3', '4', '5', '6', '7', '8'},
    },
}

function setGridCols(cols)
    hs.grid.setGrid(tostring(cols) .. 'x2')
    hs.grid.HINTS = grid_hints[cols]
end

gcols = hs.settings.get('cols') or 4
setGridCols(gcols)
hs.grid.setMargins({ x = 0, y = 0 })

function setColsCallbackFactory(cols)
  return function()
        hs.settings.set('cols', cols)
        setGridCols(cols)
        hs.alert.show(tostring(cols) .. 'x2')
        gcols = cols
    end
end

for i = 2, 8 do
    setColsCallback = setColsCallbackFactory(i)
    hs.hotkey.bind({'cmd', 'alt'}, tostring(i), setColsCallback)
end

-- show grid

function showGrid()
    hs.grid.show(true)
end

hs.hotkey.bind({'cmd', 'alt'}, 'g', showGrid)

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

-- left right split window

split_and_move_window_keys = {
    ['['] = {index = 0, split = 2},
    [']'] = {index = 1, split = 2},
    ['\\'] = {index = 0.5, split = 2},
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

-- auto snap

wf_all = hs.window.filter.new(true)

function snapWindow(window)
    if window:isVisible() and window:isStandard() then
        hs.grid.snap(window)
    end
end

wf_all:subscribe(hs.window.filter.windowMoved, snapWindow)
wf_all:subscribe(hs.window.filter.windowCreated, snapWindow)

-- to row

hs.hotkey.bind({'cmd', 'alt'}, 'r', function()
    wf_all:pause()
    local win = hs.window.focusedWindow()
    if win ~= nil then
        cell = hs.grid.get(win)
        cell.y = 0
        cell.w = 1
        cell.h = 2
        hs.grid.set(win, cell)
    end
    hs.timer.doAfter(1, function() wf_all:resume() end)
end)

-- to top-right

hs.hotkey.bind({'cmd', 'alt'}, ';', function()
    wf_all:pause()
    local win = hs.window.focusedWindow()
    if win ~= nil then
        cell = hs.geometry(gcols - 1, 0, 1, 1)
        hs.grid.set(win, cell)
    end
    hs.timer.doAfter(1, function() wf_all:resume() end)
end)

-- input source

InputSource = {
    ['ABC'] = 'com.apple.keylayout.ABC',
    ['ZhuYin'] = 'com.apple.inputmethod.TCIM.Zhuyin',
    ['McBopomofo'] = 'org.openvanilla.inputmethod.McBopomofo.McBopomofo.Bopomofo',
    ['Japanese'] = 'com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese',
}


input_source_keys = {
    ['a'] = InputSource.ABC,
    ['b'] = InputSource.ZhuYin,
    ['m'] = InputSource.McBopomofo,
    ['j'] = InputSource.Japanese,
}

for key, source_id in pairs(input_source_keys) do
    hs.hotkey.bind({'cmd', 'alt'}, key, function()
        current_source_id = hs.keycodes.currentSourceID()
        if current_source_id == source_id then
            if current_source_id == InputSource.ABC then
                hs.keycodes.currentSourceID(InputSource.McBopomofo)
            else
                hs.keycodes.currentSourceID(InputSource.ABC)
            end
        else
            hs.keycodes.currentSourceID(source_id)
        end
    end)
end

hs.hotkey.bind({'cmd'}, 'm', function()
    current_source_id = hs.keycodes.currentSourceID()
    if current_source_id == InputSource.McBopomofo then
        hs.keycodes.currentSourceID(InputSource.ABC)
    else
        hs.keycodes.currentSourceID(InputSource.McBopomofo)
    end
end)

-- mouse teleport

function mouseTeleportCallbackFactory(i)
    return function()
        pos = hs.mouse.getRelativePosition()
        screen_frame = hs.mouse.getCurrentScreen():frame()
        pos.x = screen_frame.w * (i - 1) / 4
        if i == 5 then
            pos.x = pos.x - 5
        elseif i == 1 then
            pos.x = pos.x + 5
        end
        hs.mouse.setRelativePosition(pos)
    end
end

mouse_teleport_key_list = {'a', 't', 'space', 'l', 'n'}

for i = 1, 5 do
    hs.hotkey.bind({'shift', 'alt'}, tostring(i), mouseTeleportCallbackFactory(i))
    hs.hotkey.bind({'shift', 'alt'}, mouse_teleport_key_list[i], mouseTeleportCallbackFactory(i))
end

-- application focus

application_keys = {
    ['v'] = 'Visual Studio Code - Insiders',
    ['c'] = 'Google Chrome',
    ['i'] = 'iTerm',
}

for key, application_name in pairs(application_keys) do
    hs.hotkey.bind({'cmd', 'alt'}, key, function()
        hs.application.launchOrFocus(application_name)
    end)
end

-- volume control

volume_control_keys = {
    ['right'] = 10,
    ['left'] = -10
}

for key, delta_volume in pairs(volume_control_keys) do
    hs.hotkey.bind({'cmd', 'alt'}, key, function()
        device = hs.audiodevice.defaultOutputDevice()
        volume = device:outputVolume()
        device:setOutputVolume(volume + delta_volume)
        hs.alert.show('Volume: ' .. tostring(math.floor(device:outputVolume())))
    end)
end

-- vim:sw=4:ts=4:sts=4:et
