local obj = {}
obj.__index = obj

obj.active = false
obj.toClipboard = false

local canvas = nil
local cellsByLabel = {}
local orderedCells = {}
local selectionStart = nil
local selectionEnd = nil
local selectionCornerFocus = "end"
local selectionStartBackState = nil
local selectionEndBackState = nil
local activeTile = nil
local subgridVisible = false
local typed = ""
local activeScreen = nil
local activeFrame = nil
local lastCrossPoint = nil
local nudgedPoint = nil
local previewCanvas = nil
local previewTimer = nil
local keysBound = false

obj.mode = hs.hotkey.modal.new()

obj.level1Columns = 10
obj.level1Rows = 3
obj.level2Columns = 5
obj.level2Rows = 6
obj.subgridColumns = 5
obj.subgridRows = 6
obj.padding = 2
obj.labelFont = "Menlo"
obj.labelSize = 14
obj.subgridLabelSize = 10
obj.topMargin = 48
obj.sideMargin = 8
obj.bottomMargin = 8
obj.previewWidth = 260
obj.previewMargin = 20
obj.previewDuration = 6

obj.gridKeys = {
    "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
    "A", "S", "D", "F", "G", "H", "J", "K", "L", "'",
    "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/",
}

local function shellQuote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function playScreenshotSound()
    local sound = hs.sound.getByName("Screen Capture")
        or hs.sound.getByFile("/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/Screen Capture.aiff")

    if sound then
        sound:play()
    end
end

local function hideFloatingPreview()
    if previewTimer then
        previewTimer:stop()
        previewTimer = nil
    end

    if previewCanvas then
        previewCanvas:delete()
        previewCanvas = nil
    end
end

local function showFloatingPreview(path, screen)
    local image = hs.image.imageFromPath(path)
    if not image then return end

    hideFloatingPreview()

    local imageSize = image:size()
    local width = obj.previewWidth
    local height = width * (imageSize.h / imageSize.w)
    local screenFrame = (screen or hs.screen.mainScreen()):fullFrame()
    local frame = {
        x = screenFrame.x + screenFrame.w - width - obj.previewMargin,
        y = screenFrame.y + screenFrame.h - height - obj.previewMargin,
        w = width,
        h = height,
    }

    previewCanvas = hs.canvas.new(frame)
    previewCanvas:level(hs.canvas.windowLevels.overlay)
    previewCanvas:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.fullScreenAuxiliary })
    previewCanvas:appendElements({
        type = "rectangle",
        action = "strokeAndFill",
        roundedRectRadii = { xRadius = 10, yRadius = 10 },
        strokeColor = { white = 1, alpha = 0.8 },
        fillColor = { white = 0, alpha = 0.28 },
        strokeWidth = 1,
        frame = { x = 0, y = 0, w = width, h = height },
    }, {
        type = "image",
        image = image,
        imageScaling = "scaleProportionallyUpOrDown",
        frame = { x = 4, y = 4, w = width - 8, h = height - 8 },
    })
    previewCanvas:mouseCallback(function(_, message)
        if message == "mouseUp" then
            hs.execute("/usr/bin/open " .. shellQuote(path), false)
            hideFloatingPreview()
        end
    end)
    previewCanvas:canvasMouseEvents(true, true, false, false)
    previewCanvas:show()

    previewTimer = hs.timer.doAfter(obj.previewDuration, hideFloatingPreview)
end

local function exitScreenshotTile()
    if not obj.active then return end

    if canvas then
        canvas:delete()
        canvas = nil
    end

    obj.mode:exit()
    obj.active = false
    obj.toClipboard = false
    cellsByLabel = {}
    orderedCells = {}
    selectionStart = nil
    selectionEnd = nil
    selectionCornerFocus = "end"
    selectionStartBackState = nil
    selectionEndBackState = nil
    activeTile = nil
    subgridVisible = false
    typed = ""
    activeScreen = nil
    activeFrame = nil
    lastCrossPoint = nil
    nudgedPoint = nil
end

local function prefixBounds(prefix)
    local bounds = nil

    for _, cell in ipairs(orderedCells) do
        if cell.label:sub(1, 1) == prefix then
            local x1 = cell.frame.x
            local y1 = cell.frame.y
            local x2 = cell.frame.x + cell.frame.w
            local y2 = cell.frame.y + cell.frame.h

            if bounds then
                bounds.x1 = math.min(bounds.x1, x1)
                bounds.y1 = math.min(bounds.y1, y1)
                bounds.x2 = math.max(bounds.x2, x2)
                bounds.y2 = math.max(bounds.y2, y2)
            else
                bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
            end
        end
    end

    return bounds
end

local function prefixMarker(prefix, role)
    local bounds = prefixBounds(prefix)
    if not bounds then return nil end

    if role == "end" then
        return {
            kind = "point",
            label = prefix,
            x = bounds.x2,
            y = bounds.y2,
        }
    end

    return {
        kind = "point",
        label = prefix,
        x = bounds.x1,
        y = bounds.y1,
    }
end

local function tileMarker(cell)
    return {
        kind = "tile",
        label = cell.label,
        frame = cell.frame,
    }
end

local function subgridMarker(tile, key)
    local keyIndex = nil
    for index, gridKey in ipairs(obj.gridKeys) do
        if gridKey == key then
            keyIndex = index
            break
        end
    end

    if not keyIndex or keyIndex > (obj.subgridColumns * obj.subgridRows) then return nil end

    local row = math.floor((keyIndex - 1) / obj.subgridColumns) + 1
    local column = ((keyIndex - 1) % obj.subgridColumns) + 1
    local cellWidth = tile.frame.w / obj.subgridColumns
    local cellHeight = tile.frame.h / obj.subgridRows

    return {
        kind = "tile",
        label = tile.label .. key,
        frame = {
            x = tile.frame.x + ((column - 1) * cellWidth) + obj.padding,
            y = tile.frame.y + ((row - 1) * cellHeight) + obj.padding,
            w = cellWidth - (obj.padding * 2),
            h = cellHeight - (obj.padding * 2),
        },
    }
end

local function markerBounds(marker)
    if marker.kind == "point" then
        return { x1 = marker.x, y1 = marker.y, x2 = marker.x, y2 = marker.y }
    end

    return {
        x1 = marker.frame.x,
        y1 = marker.frame.y,
        x2 = marker.frame.x + marker.frame.w,
        y2 = marker.frame.y + marker.frame.h,
    }
end

local function selectionRectBounds(startMarker, endMarker)
    local startBounds = markerBounds(startMarker)
    local endBounds = markerBounds(endMarker)
    local x1 = math.min(startBounds.x1, endBounds.x2)
    local y1 = math.min(startBounds.y1, endBounds.y2)
    local x2 = math.max(startBounds.x1, endBounds.x2)
    local y2 = math.max(startBounds.y1, endBounds.y2)

    return { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

local function markerCenter(marker)
    local bounds = markerBounds(marker)
    return {
        x = bounds.x1 + ((bounds.x2 - bounds.x1) / 2),
        y = bounds.y1 + ((bounds.y2 - bounds.y1) / 2),
    }
end

local function markerAnchor(marker, role)
    local bounds = markerBounds(marker)

    if marker.kind == "point" then
        return { x = bounds.x1, y = bounds.y1 }
    end

    if role == "end" then
        return { x = bounds.x2, y = bounds.y2 }
    end

    return { x = bounds.x1, y = bounds.y1 }
end

local function focusedSelectionPoint()
    if not selectionStart or not selectionEnd then return nil end

    if selectionCornerFocus == "start" then
        return markerAnchor(selectionStart, "start")
    end

    return markerAnchor(selectionEnd, "end")
end

local function activeCrossPoint()
    local point = nil

    if nudgedPoint then
        point = nudgedPoint
    elseif activeTile then
        point = markerAnchor(tileMarker(activeTile), selectionStart and "end" or "start")
    elseif #typed == 1 then
        local marker = prefixMarker(typed, selectionStart and "end" or "start")
        point = marker and markerCenter(marker) or nil
    elseif selectionEnd then
        point = markerAnchor(selectionEnd, "end")
    elseif selectionStart then
        point = markerAnchor(selectionStart, "start")
    end

    if point then
        lastCrossPoint = point
        return point
    end

    if lastCrossPoint then return lastCrossPoint end

    if canvas then
        local frame = canvas:frame()
        return { x = frame.w / 2, y = frame.h / 2 }
    end

    return nil
end

local function pointMarker(point, label)
    return {
        kind = "point",
        label = label or "point",
        x = point.x,
        y = point.y,
    }
end

local function appendCrosshair()
    local point = activeCrossPoint()
    if not point or not canvas then return end

    local frame = canvas:frame()
    canvas:appendElements({
        type = "segments",
        action = "stroke",
        strokeColor = { red = 0.2, green = 0.55, blue = 1, alpha = 0.95 },
        strokeWidth = 1,
        strokeDashPattern = { 6, 4 },
        coordinates = {
            { x = 0, y = point.y },
            { x = frame.w, y = point.y },
        },
    }, {
        type = "segments",
        action = "stroke",
        strokeColor = { red = 0.2, green = 0.55, blue = 1, alpha = 0.95 },
        strokeWidth = 1,
        strokeDashPattern = { 6, 4 },
        coordinates = {
            { x = point.x, y = 0 },
            { x = point.x, y = frame.h },
        },
    })
end

local function isHighlighted(cell)
    if #typed == 1 and cell.label:sub(1, 1) == typed then
        return true, "prefix"
    end

    if activeTile and activeTile.label == cell.label then
        return true, "selected"
    end

    if not selectionStart then return false end

    if selectionStart.kind == "tile" and selectionStart.label == cell.label then
        return true, "selected"
    end

    if selectionEnd and selectionEnd.kind == "tile" and selectionEnd.label == cell.label then
        return true, "selected"
    end

    return false
end

local function selectedRect()
    if not selectionStart or not selectionEnd then return nil end

    local bounds = selectionRectBounds(selectionStart, selectionEnd)

    return { x = bounds.x1, y = bounds.y1, w = bounds.x2 - bounds.x1, h = bounds.y2 - bounds.y1 }
end

local function appendOutsideShade()
    local rect = selectedRect()
    if not rect then return end

    local frame = canvas:frame()
    local shade = { red = 0, green = 0, blue = 0, alpha = 0.52 }
    local rectangles = {
        { x = 0, y = 0, w = frame.w, h = rect.y },
        { x = 0, y = rect.y + rect.h, w = frame.w, h = frame.h - rect.y - rect.h },
        { x = 0, y = rect.y, w = rect.x, h = rect.h },
        { x = rect.x + rect.w, y = rect.y, w = frame.w - rect.x - rect.w, h = rect.h },
    }

    for _, shadeFrame in ipairs(rectangles) do
        if shadeFrame.w > 0 and shadeFrame.h > 0 then
            canvas:appendElements({
                type = "rectangle",
                action = "fill",
                fillColor = shade,
                frame = shadeFrame,
            })
        end
    end
end

local function appendSelectionPreview()
    local rect = selectedRect()
    if not rect then return end

    canvas:appendElements({
        type = "rectangle",
        action = "stroke",
        strokeColor = { red = 0.2, green = 0.55, blue = 1, alpha = 0.95 },
        strokeWidth = 2,
        strokeDashPattern = { 8, 5 },
        frame = rect,
    })
end

local function appendDot(point)
    if not point then return end

    canvas:appendElements({
        type = "rectangle",
        action = "strokeAndFill",
        strokeColor = { red = 1, green = 1, blue = 1, alpha = 1 },
        fillColor = { red = 0.2, green = 0.55, blue = 1, alpha = 0.95 },
        strokeWidth = 1,
        roundedRectRadii = { xRadius = 5, yRadius = 5 },
        frame = { x = point.x - 5, y = point.y - 5, w = 10, h = 10 },
    })
end

local function appendStartDot()
    if not selectionStart or selectionEnd then return end

    appendDot(markerAnchor(selectionStart, "start"))
end

local function appendMotionDot()
    appendDot(focusedSelectionPoint())
end

local function appendSubgrid()
    if not activeTile or not subgridVisible then return end

    local cellWidth = activeTile.frame.w / obj.subgridColumns
    local cellHeight = activeTile.frame.h / obj.subgridRows
    local maxKeys = obj.subgridColumns * obj.subgridRows

    for index = 1, maxKeys do
        local key = obj.gridKeys[index]
        local row = math.floor((index - 1) / obj.subgridColumns) + 1
        local column = ((index - 1) % obj.subgridColumns) + 1
        local frame = {
            x = activeTile.frame.x + ((column - 1) * cellWidth) + obj.padding,
            y = activeTile.frame.y + ((row - 1) * cellHeight) + obj.padding,
            w = cellWidth - (obj.padding * 2),
            h = cellHeight - (obj.padding * 2),
        }
        local textHeight = obj.subgridLabelSize * 1.5

        canvas:appendElements({
            type = "text",
            text = key,
            textFont = obj.labelFont,
            textSize = obj.subgridLabelSize,
            textColor = { white = 1, alpha = 1 },
            textAlignment = "center",
            frame = {
                x = frame.x,
                y = frame.y + ((frame.h - textHeight) / 2),
                w = frame.w,
                h = textHeight,
            },
        })
    end
end

local function drawGrid()
    if not canvas then return end

    canvas:replaceElements({
        {
            type = "rectangle",
            action = "fill",
            fillColor = { red = 0, green = 0, blue = 0, alpha = 0.12 },
            frame = { x = 0, y = 0, w = canvas:frame().w, h = canvas:frame().h },
        },
    })

    if selectionEnd then
        appendOutsideShade()
        appendSelectionPreview()
        appendMotionDot()
        return
    end

    for _, cell in ipairs(orderedCells) do
        local highlighted, highlightKind = isHighlighted(cell)
        local isPrefix = highlightKind == "prefix"
        local cellBackground = {
            type = "rectangle",
            action = "fill",
            fillColor = highlighted and (isPrefix and { red = 1, green = 0.72, blue = 0.18, alpha = 0.35 }
                    or { red = 0.2, green = 0.55, blue = 1, alpha = 0.45 })
                or { red = 0, green = 0, blue = 0, alpha = 0.32 },
            frame = cell.frame,
        }

        if activeTile and activeTile.label == cell.label then
            canvas:appendElements(cellBackground)
        else
            local textHeight = obj.labelSize * 1.5
            canvas:appendElements(cellBackground, {
                type = "text",
                text = cell.label,
                textFont = obj.labelFont,
                textSize = obj.labelSize,
                textColor = { white = 1, alpha = 1 },
                textAlignment = "center",
                frame = {
                    x = cell.frame.x,
                    y = cell.frame.y + ((cell.frame.h - textHeight) / 2),
                    w = cell.frame.w,
                    h = textHeight,
                },
            })
        end
    end

    appendSelectionPreview()
    appendCrosshair()
    appendStartDot()
    appendSubgrid()
end

local function captureRect(startMarker, endMarker)
    local bounds = selectionRectBounds(startMarker, endMarker)
    local x1 = activeFrame.x + bounds.x1
    local y1 = activeFrame.y + bounds.y1
    local x2 = activeFrame.x + bounds.x2
    local y2 = activeFrame.y + bounds.y2

    local rect = string.format("%d,%d,%d,%d", math.floor(x1), math.floor(y1), math.floor(x2 - x1), math.floor(y2 - y1))
    local command
    local savedPath = nil
    local previewScreen = activeScreen

    if obj.toClipboard then
        command = "/usr/sbin/screencapture -x -c -R" .. rect
    else
        local filename = os.date("Screenshot %Y-%m-%d at %H.%M.%S.png")
        savedPath = os.getenv("HOME") .. "/Desktop/" .. filename
        command = "/usr/sbin/screencapture -x -R" .. rect .. " " .. shellQuote(savedPath)
    end

    local copiedToClipboard = obj.toClipboard
    exitScreenshotTile()

    hs.timer.doAfter(0.08, function()
        local _, ok = hs.execute(command, true)
        if ok then
            playScreenshotSound()
            if savedPath then
                showFloatingPreview(savedPath, previewScreen)
            end
            hs.notify.show("ScreenshotTile", copiedToClipboard and "Copied screenshot to clipboard" or "Saved screenshot to Desktop", "")
        else
            hs.notify.show("ScreenshotTile", "Screenshot failed", rect)
        end
    end)
end

local function setMarker(marker)
    local backState = {
        activeTile = activeTile,
        subgridVisible = subgridVisible,
        typed = typed,
        nudgedPoint = nudgedPoint,
    }

    typed = ""
    activeTile = nil
    subgridVisible = false
    nudgedPoint = nil
    if not selectionStart then
        selectionStart = marker
        selectionStartBackState = backState
        drawGrid()
        return
    end

    selectionEnd = marker
    selectionEndBackState = backState
    selectionCornerFocus = "end"
    drawGrid()
end

local function nudgeCurrentPoint(dx, dy)
    local point = selectionEnd and focusedSelectionPoint() or activeCrossPoint()
    if not point then return end

    local frame = canvas:frame()
    point = {
        x = math.max(0, math.min(frame.w, point.x + dx)),
        y = math.max(0, math.min(frame.h, point.y + dy)),
    }

    if selectionEnd then
        if selectionCornerFocus == "start" then
            selectionStart = pointMarker(point, selectionStart.label)
        else
            selectionEnd = pointMarker(point, selectionEnd.label)
        end
    elseif selectionStart and not activeTile and #typed == 0 then
        selectionStart = pointMarker(point, selectionStart.label)
    else
        nudgedPoint = point
    end

    lastCrossPoint = point
    drawGrid()
end

local function toggleSelectionCornerFocus()
    if not selectionEnd then return end

    selectionCornerFocus = selectionCornerFocus == "end" and "start" or "end"
    drawGrid()
end

local function handleKey(key)
    if selectionEnd then return end

    if activeTile then
        local marker = subgridMarker(activeTile, key)
        if marker then
            setMarker(marker)
        end
        return
    end

    typed = (typed .. key):upper():sub(-2)
    nudgedPoint = nil
    if #typed < 2 then
        drawGrid()
        return
    end

    local cell = cellsByLabel[typed]
    if not cell then return end

    activeTile = cell
    subgridVisible = true
    typed = ""
    nudgedPoint = nil
    drawGrid()
end

local function handleSpace()
    if selectionEnd then
        captureRect(selectionStart, selectionEnd)
        return
    end

    if nudgedPoint then
        setMarker(pointMarker(nudgedPoint))
        return
    end

    if activeTile then
        setMarker({
            kind = "point",
            label = activeTile.label,
            x = activeTile.frame.x + (activeTile.frame.w / 2),
            y = activeTile.frame.y + (activeTile.frame.h / 2),
        })
        return
    end

    if #typed ~= 1 then return end

    local marker = prefixMarker(typed, selectionStart and "end" or "start")
    if not marker then return end

    setMarker(marker)
end

local function goBack()
    if selectionEnd then
        selectionEnd = nil
        if selectionEndBackState then
            activeTile = selectionEndBackState.activeTile
            subgridVisible = selectionEndBackState.subgridVisible
            typed = selectionEndBackState.typed or ""
            nudgedPoint = selectionEndBackState.nudgedPoint
        else
            activeTile = nil
            subgridVisible = false
            typed = ""
            nudgedPoint = nil
        end
        selectionEndBackState = nil
        selectionCornerFocus = "end"
        drawGrid()
        return
    end

    if activeTile then
        if subgridVisible then
            typed = activeTile.label:sub(1, 1)
            activeTile = nil
            subgridVisible = false
            nudgedPoint = nil
            drawGrid()
            return
        end

        typed = activeTile.label:sub(1, 1)
        activeTile = nil
        subgridVisible = false
        nudgedPoint = nil
        drawGrid()
        return
    end

    if #typed > 0 then
        typed = typed:sub(1, -2)
        nudgedPoint = nil
        drawGrid()
        return
    end

    if selectionStart then
        if selectionStartBackState then
            activeTile = selectionStartBackState.activeTile
            subgridVisible = selectionStartBackState.subgridVisible
            typed = selectionStartBackState.typed or ""
            nudgedPoint = selectionStartBackState.nudgedPoint
        else
            activeTile = nil
            subgridVisible = false
            typed = ""
            nudgedPoint = nil
            lastCrossPoint = nil
        end

        selectionStart = nil
        selectionStartBackState = nil
        drawGrid()
    end
end

local function bindKeys()
    if keysBound then return end

    obj.mode:bind({}, "escape", exitScreenshotTile)
    obj.mode:bind({}, "delete", goBack)
    obj.mode:bind({}, "forwarddelete", goBack)
    obj.mode:bind({}, "tab", toggleSelectionCornerFocus)
    obj.mode:bind({}, "space", handleSpace)
    obj.mode:bind({}, "return", handleSpace)
    obj.mode:bind({}, "left", function() nudgeCurrentPoint(-1, 0) end, nil, function() nudgeCurrentPoint(-1, 0) end)
    obj.mode:bind({}, "right", function() nudgeCurrentPoint(1, 0) end, nil, function() nudgeCurrentPoint(1, 0) end)
    obj.mode:bind({}, "up", function() nudgeCurrentPoint(0, -1) end, nil, function() nudgeCurrentPoint(0, -1) end)
    obj.mode:bind({}, "down", function() nudgeCurrentPoint(0, 1) end, nil, function() nudgeCurrentPoint(0, 1) end)
    obj.mode:bind({ "shift" }, "left", function() nudgeCurrentPoint(-10, 0) end, nil, function() nudgeCurrentPoint(-10, 0) end)
    obj.mode:bind({ "shift" }, "right", function() nudgeCurrentPoint(10, 0) end, nil, function() nudgeCurrentPoint(10, 0) end)
    obj.mode:bind({ "shift" }, "up", function() nudgeCurrentPoint(0, -10) end, nil, function() nudgeCurrentPoint(0, -10) end)
    obj.mode:bind({ "shift" }, "down", function() nudgeCurrentPoint(0, 10) end, nil, function() nudgeCurrentPoint(0, 10) end)

    for _, key in ipairs(obj.gridKeys) do
        local bindKey = key:match("%a") and key:lower() or key
        obj.mode:bind({}, bindKey, function() handleKey(key) end)
    end

    keysBound = true
end

function obj:bindHotkeys(mapping)
    local spec = {
        save = function() self:start(false) end,
        clipboard = function() self:start(true) end,
    }

    hs.spoons.bindHotkeysToSpec(spec, mapping)
end

function obj:start(toClipboard)
    if obj.active then
        exitScreenshotTile()
        return
    end

    obj.active = true
    obj.toClipboard = toClipboard == true
    typed = ""

    activeScreen = hs.mouse.getCurrentScreen() or hs.screen.mainScreen()
    local frame = activeScreen:fullFrame()
    frame.x = frame.x + obj.sideMargin
    frame.y = frame.y + obj.topMargin
    frame.w = frame.w - (obj.sideMargin * 2)
    frame.h = frame.h - obj.topMargin
    frame.h = frame.h - obj.bottomMargin
    activeFrame = frame
    lastCrossPoint = nil
    canvas = hs.canvas.new(frame)
    canvas:level(hs.canvas.windowLevels.overlay)
    canvas:behavior({ hs.canvas.windowBehaviors.canJoinAllSpaces, hs.canvas.windowBehaviors.fullScreenAuxiliary })
    canvas:show()

    local cellWidth = frame.w / (obj.level1Columns * obj.level2Columns)
    local cellHeight = frame.h / (obj.level1Rows * obj.level2Rows)

    for level1Row = 1, obj.level1Rows do
        for level1Column = 1, obj.level1Columns do
            local level1Index = ((level1Row - 1) * obj.level1Columns) + level1Column
            local level1Key = obj.gridKeys[level1Index]

            for level2Row = 1, obj.level2Rows do
                for level2Column = 1, obj.level2Columns do
                    local level2Index = ((level2Row - 1) * obj.level2Columns) + level2Column
                    local level2Key = obj.gridKeys[level2Index]
                    local column = ((level1Column - 1) * obj.level2Columns) + level2Column
                    local row = ((level1Row - 1) * obj.level2Rows) + level2Row
                    local label = level1Key .. level2Key
                    local cell = {
                        label = label,
                        frame = {
                            x = (column - 1) * cellWidth + obj.padding,
                            y = (row - 1) * cellHeight + obj.padding,
                            w = cellWidth - (obj.padding * 2),
                            h = cellHeight - (obj.padding * 2),
                        },
                    }

                    cellsByLabel[label] = cell
                    orderedCells[#orderedCells + 1] = cell
                end
            end
        end
    end

    drawGrid()
    bindKeys()
    obj.mode:enter()
end

return obj
