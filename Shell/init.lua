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

-- to cell

hs.hotkey.bind({'cmd', 'alt'}, 'c', function()
    wf_all:pause()
    local win = hs.window.focusedWindow()
    if win ~= nil then
        cell = hs.grid.get(win)
        cell.w = 1
        cell.h = 1
        hs.grid.set(win, cell)
    end
    hs.timer.doAfter(1, function() wf_all:resume() end)
end)

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
            if currentSourceID == InputSource.ABC then
                hs.keycodes.currentSourceID(InputSource.McBopomofo)
            else
                hs.keycodes.currentSourceID(InputSource.ABC)
            end
        else
            hs.keycodes.currentSourceID(source_id)
        end
    end)
end

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
    ['g'] = 'Google Chrome',
    ['i'] = 'iTerm',
}

for key, application_name in pairs(application_keys) do
    hs.hotkey.bind({'shift', 'alt'}, key, function()
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

-- launcher

function map(tbl, f)
    local t = {}
    for k,v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

function tableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

launcherData = hs.json.read('.launcher.json')

launcher = hs.chooser.new(function (choice)
    if choice.type == 'QuickLink' then
        hs.execute('open ' .. choice.data.url)
    elseif choice.type == 'Application' then
        hs.application.launchOrFocus(choice.data.name)
    end
    
end)

hs.hotkey.bind({"ctrl"}, "/", function()
    quickLinkChoices = map(
        launcherData.quickLinks,
        function(quickLink)
            return {
                text = quickLink.alias,
                type = "QuickLink",
                data = quickLink
            }
        end
    )
    applicationChoices = map(
        launcherData.applications,
        function(application)
            return {
                text = application.alias,
                type = "Application",
                data = application
            }
        end
    )
    launcher:choices(tableConcat(quickLinkChoices, applicationChoices))
    launcher:show()
end)

-- vim:sw=4:ts=4:sts=4:et
