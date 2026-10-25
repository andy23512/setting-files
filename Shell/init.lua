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

function setGridCols(cols)
    hs.grid.setGrid(tostring(cols) .. 'x2')
end

gcols = 8
setGridCols(gcols)
hs.grid.setMargins({ x = 0, y = 0 })

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

-- debug log (console + file, since the console is cleared on reload)

local debugLogPath = os.getenv("HOME") .. "/.hammerspoon/wake-debug.log"
local debugLogger = hs.logger.new('wake', 'debug')

local function debugLog(fmt, ...)
    local msg = string.format(fmt, ...)
    debugLogger.i(msg)
    local f = io.open(debugLogPath, "a")
    if f then
        f:write(os.date("%Y-%m-%d %H:%M:%S ") .. msg .. "\n")
        f:close()
    end
end

local function describeScreens()
    local parts = {}
    for _, s in ipairs(hs.screen.allScreens()) do
        table.insert(parts, string.format("[%s id=%s frame=%s]", s:name() or "?", tostring(s:id()), s:frame().string))
    end
    return table.concat(parts, " ")
end

local caffeinateEventNames = {}
for name, value in pairs(hs.caffeinate.watcher) do
    if type(value) == "number" then caffeinateEventNames[value] = name end
end

local function onWindowEvent(win, appName, event)
    debugLog("%s: %s (%s) screens=%s", event, win and win:title() or "?", appName or "?", describeScreens())
    snapGrid()
end

wf_all:subscribe(hs.window.filter.windowMoved, onWindowEvent)
wf_all:subscribe(hs.window.filter.windowCreated, onWindowEvent)

-- sleep/wake handling
-- While the display sleeps/wakes, macOS may temporarily change the screen
-- layout and move windows. Auto snap during that period would snap windows to
-- a wrong grid, so pause it, restore saved frames, and snap once after settling.

local savedFrames = {}
local resumeTimer

local function saveFrames()
    savedFrames = {}
    local count = 0
    for _, win in ipairs(hs.window.visibleWindows()) do
        if win:isStandard() then
            savedFrames[win:id()] = win:frame()
            count = count + 1
        end
    end
    debugLog("saved %d frames, screens=%s", count, describeScreens())
end

local function restoreFrames()
    local count = 0
    for id, frame in pairs(savedFrames) do
        local win = hs.window.get(id)
        if win then
            win:setFrame(frame, 0)
            count = count + 1
        end
    end
    debugLog("restored %d frames, screens=%s", count, describeScreens())
end

local function pauseSnap()
    wf_all:pause()
    if resumeTimer then resumeTimer:stop() end
end

local function resumeSnapLater()
    if resumeTimer then resumeTimer:stop() end
    resumeTimer = hs.timer.doAfter(5, function()
        debugLog("resume auto snap, screens=%s", describeScreens())
        wf_all:resume()
        snapGrid()
    end)
end

wakeWatcher = hs.caffeinate.watcher.new(function(event)
    local w = hs.caffeinate.watcher
    debugLog("caffeinate: %s, screens=%s", caffeinateEventNames[event] or tostring(event), describeScreens())
    if event == w.screensDidSleep or event == w.systemWillSleep then
        saveFrames()
        pauseSnap()
    elseif event == w.screensDidWake or event == w.systemDidWake then
        pauseSnap()
        restoreFrames()
        resumeSnapLater()
    end
end):start()

screenWatcher = hs.screen.watcher.new(function()
    debugLog("screen layout changed: %s", describeScreens())
    pauseSnap()
    resumeSnapLater()
end):start()

-- input source

InputSource = {
    ['ABC'] = 'com.apple.keylayout.ABC',
    ['ZhuYin'] = 'com.apple.inputmethod.TCIM.Zhuyin',
    ['McBopomofo'] = 'org.openvanilla.inputmethod.McBopomofo.McBopomofo.Bopomofo',
    ['Japanese'] = 'com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese',
}


-- macOS has a long-standing bug where switching directly into a "complex"
-- input source (Chinese/Japanese IMEs) via TISSelectInputSource (what
-- hs.keycodes.currentSourceID wraps) updates the menu bar icon but doesn't
-- actually change what gets typed. Synthetic keystrokes (hs.eventtap.keyStroke)
-- aimed at the "Select next source in Input menu" shortcut are unreliable too,
-- since macOS often ignores synthetic events for this system-reserved hotkey.
-- The one thing that reliably works is performing the same action a real
-- mouse click does: pressing the actual Input menu bar item (owned by the
-- TextInputMenuAgent process) via the Accessibility API. This goes through
-- the real NSMenu selection path, so it doesn't hit the bug. Doing this with
-- hs.axuielement directly (instead of AppleScript/System Events) also makes
-- it sub-millisecond instead of the ~0.3-0.5s AppleScript/GUI-scripting costs.
-- See https://github.com/tekezo/Karabiner/issues/308 and
-- https://github.com/Hammerspoon/hammerspoon/issues/1429
InputSourceMenuTitle = {
    [InputSource.ABC] = 'ABC',
    [InputSource.ZhuYin] = '注音 – 繁体字', -- exact system menu label, do not "correct" to 繁體字
    [InputSource.McBopomofo] = 'Bopomofo', -- the "McBopomofo" entry is only a prefs header shown while it's already active; "Bopomofo" is the actual switchable item
    [InputSource.Japanese] = '日本語',
}

local function getInputMenuStatusItem()
    local app = hs.application.find('TextInputMenuAgent')
    if not app then return nil end
    local extrasMenuBar = hs.axuielement.applicationElement(app).AXExtrasMenuBar
    return extrasMenuBar and extrasMenuBar[1]
end

local function pressMenuItemByTitle(statusItem, title, attemptsLeft)
    local menu = statusItem.AXChildren and statusItem.AXChildren[1]
    local items = menu and menu.AXChildren
    if items then
        for _, item in ipairs(items) do
            if item.AXTitle == title then
                item:performAction('AXPress')
                return true
            end
        end
    end
    if attemptsLeft > 0 then
        hs.timer.usleep(20000)
        return pressMenuItemByTitle(statusItem, title, attemptsLeft - 1)
    end
    return false
end

function setInputSource(targetSourceID)
    local menuTitle = InputSourceMenuTitle[targetSourceID]
    if not menuTitle then
        hs.keycodes.currentSourceID(targetSourceID)
        return
    end
    local statusItem = getInputMenuStatusItem()
    if not statusItem then
        hs.alert.show('Input menu extra not found')
        return
    end
    if not pressMenuItemByTitle(statusItem, menuTitle, 5) then
        hs.alert.show('Input source menu item not found: ' .. menuTitle)
    end
end

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
                setInputSource(InputSource.McBopomofo)
            else
                setInputSource(InputSource.ABC)
            end
        else
            setInputSource(source_id)
        end
    end)
end

hs.hotkey.bind({'cmd'}, 'm', function()
    current_source_id = hs.keycodes.currentSourceID()
    if current_source_id == InputSource.McBopomofo then
        setInputSource(InputSource.ABC)
    else
        setInputSource(InputSource.McBopomofo)
    end
end)

-- show current input source

-- macOS only pops up the little input-source label at the caret when the
-- source actually changes, and there's no API to ask for it on demand. So we
-- bounce through a different source and back; the second switch lands back on
-- the original source and re-triggers the same native popup as a side effect.
function showCurrentInputSource()
    local current_source_id = hs.keycodes.currentSourceID()
    local trampoline_source_id = (current_source_id == InputSource.ABC) and InputSource.McBopomofo or InputSource.ABC
    setInputSource(trampoline_source_id)
    hs.timer.doAfter(0.02, function()
        setInputSource(current_source_id)
    end)
end

hs.hotkey.bind({'cmd', 'alt'}, 'k', showCurrentInputSource)

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
