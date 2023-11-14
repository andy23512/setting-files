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

-- webserver

server = hs.httpserver.new(false, true)
server:setInterface('en2')
server:setPort(11211)
server:setCallback(function(method, path, headers, body)
    blocking = true
    hs.keycodes.currentSourceID(body)
    hs.timer.doAfter(0.5, function() blocking = false end)
    return 'OK', 200, {}
end)
server:start()

bonjour = hs.bonjour.new()
remote_address = nil
remote_port = nil
hs.timer.doAfter(1, function()
    bonjour:findServices('_http._tcp', 'local.', function(b, d, a, s)
        s:resolve(0.0, function(r)
            address = r:addresses()[1]
            if address == '127.0.0.1' then
                return
            end
            remote_address = address
            remote_port = r:port()
            bonjour:stop()
        end)
    end)
end)

-- input source

local blocking = false

function syncEnableChordSettingWithInputSource()
    source_id = hs.keycodes.currentSourceID()
    is_bopomofo = source_id == "org.openvanilla.inputmethod.McBopomofo.McBopomofo.Bopomofo"
    is_abc = source_id == "com.apple.keylayout.ABC"
    if not is_bopomofo and not is_abc then return end
    local serial_object = hs.serial.newFromPath("/dev/cu.usbmodem14201")
    if not serial_object then return end
    local received_data = ''
    serial_object:baudRate(115200)
    serial_object:callback(function(spo, callbackType, message, hexdecimalString)
        if callbackType == "received" then
            if message == 'VAR' then
                received_data = message
            else
                received_data = received_data .. message
            end
            if string.sub(received_data,-2) == '\r\n' then
                if string.sub(received_data, 1, 9) == 'VAR B1 12' then
                    chord_enabled = string.sub(received_data, 11, 11) == '0'
                    if is_bopomofo and chord_enabled then
                        serial_object:sendData("VAR B2 12 1\r\n")
                    elseif is_abc and not chord_enabled then
                        serial_object:sendData("VAR B2 12 0\r\n")
                    else
                        serial_object:close()
                    end
                elseif string.sub(received_data, 1, 9) == 'VAR B2 12' then
                    serial_object:close()
                end
                received_data = ''
            end
        elseif callbackType == "opened" then
            serial_object:sendData("VAR B1 12\r\n")
        end
    end)
    serial_object:usesDTRDSRFlowControl(true)
    serial_object:usesRTSCTSFlowControl(true)
    serial_object:dtr(true)
    serial_object:rts(true)
    serial_object:open()
    hs.timer.doAfter(20, function()
        if serial_object:isOpen() then serial_object:close() end
    end)
end

local current_source_id = hs.keycodes.currentSourceID()

function onInputSourceChanged()
    next_source_id = hs.keycodes.currentSourceID()
    if not blocking and next_source_id ~= current_source_id then
        blocking = true
        current_source_id = next_source_id
        syncEnableChordSettingWithInputSource()
        hs.http.asyncPost(
            'http://' .. remote_address .. ':' .. remote_port,
            hs.keycodes.currentSourceID(),
            {},
            function() end
        )
        hs.timer.doAfter(0.5, function() blocking = false end)
    end
end

hs.keycodes.inputSourceChanged(onInputSourceChanged)
hs.serial.deviceCallback(syncEnableChordSettingWithInputSource)

-- vim:sw=4:ts=4:sts=4:et