-- Main menu function
function input()
    local menu = gg.choice({'🚀 Start Speedhack', '🔄 Revert Speedhack', '❌ Return'}, nil, '🎮 Select an option:')
    if menu == nil then
        gg.toast("⏸️ Script paused! Tap GG icon to continue! 🌟", true)
        while not gg.isVisible() do
            gg.sleep(100)
        end
        gg.setVisible(false)
        input() -- Resume at input function
        return
    end
    if menu == 1 then
        start()
    elseif menu == 2 then
        revertSpeedhack()
    elseif menu == 3 then
        returnFunc()
    end
end

-- Start speedhack function
function start()
    -- Get current speed
    local validSpeeds = {1, 2, 3, 4, 10}
    local currentSpeed = getCurrentSpeed(validSpeeds)
    if currentSpeed == nil then return end -- Exit if user keeps cancelling

    -- Store original speed for reference
    originalSpeed = currentSpeed

    -- Search for the current speed
    gg.setRanges(gg.REGION_C_ALLOC)
    gg.searchNumber(tostring(currentSpeed), gg.TYPE_FLOAT)
    
    -- Get new speed
    local newSpeed = getNewSpeed(validSpeeds, currentSpeed)
    if newSpeed == nil then
        gg.clearResults()
        return -- Exit if user keeps cancelling
    end

    -- Store new speed for revert
    newSpeedGlobal = newSpeed

    -- Refine search
    gg.refineNumber(tostring(newSpeed), gg.TYPE_FLOAT)
    
    -- Check results
    local results = gg.getResultsCount()
    if results == 0 then
        gg.alert('❗ No results found! Try again. 🔍')
        gg.clearResults()
        start()
        return
    elseif results > 1 then
        gg.alert('❗ Multiple results found! Please refine your search. 🔎')
        gg.clearResults()
        start()
        return
    end

    -- Get final desired speed
    local finalSpeed = getFinalSpeed()
    if finalSpeed == nil then
        gg.clearResults()
        return -- Exit if user keeps cancelling
    end

    -- Edit and freeze value
    local results = gg.getResults(1)
    gg.editAll(tostring(finalSpeed), gg.TYPE_FLOAT)
    gg.addListItems({{address = results[1].address, value = finalSpeed, flags = gg.TYPE_FLOAT, freeze = true, name = "Speed"}})
    gg.alert('✅ Speed changed to ' .. finalSpeed .. ' and frozen! 🚀')
    gg.clearResults()
    
    -- Return to main menu
    input()
end

-- Function to get current speed with pause and resume
function getCurrentSpeed(validSpeeds)
    while true do
        local currentSpeed = gg.prompt(
            {'🚴 Enter your current speed (1, 2, 3, 4, or 10)'},
            {[1] = '1'},
            {[1] = 'number'}
        )
        
        -- Check if user cancelled prompt
        if currentSpeed == nil then
            gg.toast("⏸️ Script paused! Tap GG icon to continue! 🌟", true)
            while not gg.isVisible() do
                gg.sleep(100)
            end
            gg.setVisible(false)
            -- Resume at this prompt
        else
            currentSpeed = tonumber(currentSpeed[1])
            local isValid = false
            for _, v in ipairs(validSpeeds) do
                if currentSpeed == v then
                    isValid = true
                    break
                end
            end
            if isValid then
                return currentSpeed
            else
                gg.alert('❗ Invalid speed! Please enter 1, 2, 3, 4, or 10 🚫')
                -- Resume at this prompt
            end
        end
    end
end

-- Function to get new speed with pause and resume
function getNewSpeed(validSpeeds, currentSpeed)
    local newSpeedOptions = {}
    for _, v in ipairs(validSpeeds) do
        if v ~= currentSpeed then
            table.insert(newSpeedOptions, v)
        end
    end
    
    while true do
        local newSpeed = gg.prompt(
            {'🏎️ Enter new speed (' .. table.concat(newSpeedOptions, ', ') .. ')'},
            {[1] = newSpeedOptions[1]},
            {[1] = 'number'}
        )
        
        -- Check if user cancelled prompt
        if newSpeed == nil then
            gg.toast("⏸️ Script paused! Tap GG icon to continue! 🌟", true)
            while not gg.isVisible() do
                gg.sleep(100)
            end
            gg.setVisible(false)
            -- Resume at this prompt
        else
            newSpeed = tonumber(newSpeed[1])
            local isValid = false
            for _, v in ipairs(newSpeedOptions) do
                if newSpeed == v then
                    isValid = true
                    break
                end
            end
            if isValid then
                return newSpeed
            else
                gg.alert('❗ Invalid new speed! Please enter one of: ' .. table.concat(newSpeedOptions, ', ') .. ' 🚫')
                -- Resume at this prompt
            end
        end
    end
end

-- Function to get final speed with pause and resume
function getFinalSpeed()
    while true do
        local finalSpeed = gg.prompt(
            {'⚡ Enter the final speed you want'},
            {[1] = '1'},
            {[1] = 'number'}
        )
        
        -- Check if user cancelled prompt
        if finalSpeed == nil then
            gg.toast("⏸️ Script paused! Tap GG icon to continue! 🌟", true)
            while not gg.isVisible() do
                gg.sleep(100)
            end
            gg.setVisible(false)
            -- Resume at this prompt
        else
            return tonumber(finalSpeed[1])
        end
    end
end

-- Revert speedhack function
function revertSpeedhack()
    gg.setVisible(false)
    local frozenItems = gg.getListItems()
    local speedItems = {}
    
    -- Filter items named "Speed"
    for _, item in ipairs(frozenItems) do
        if item.name == "Speed" then
            table.insert(speedItems, item)
        end
    end
    
    if #speedItems > 0 then
        if newSpeedGlobal == nil then
            gg.alert('❗ No new speed recorded! 🚫')
            gg.toast('❗ No new speed recorded! 🚫')
            input()
            return
        end
        -- Revert to new speed and unfreeze
        for _, item in ipairs(speedItems) do
            item.value = newSpeedGlobal
            item.freeze = false
        end
        gg.setValues(speedItems)
        gg.removeListItems(speedItems)
        gg.alert('✅ Speed reverted to ' .. newSpeedGlobal .. ' and unfrozen! 🔄')
        gg.toast('✅ Speed reverted to ' .. newSpeedGlobal .. ' and unfrozen! 🔄')
    else
        gg.alert('❗ No speed value found! 🚫')
        gg.toast('❗ No speed value found! 🚫')
    end
    input()
end

-- Return function to exit script
function returnFunc()
    gg.toast('❌ Script terminated by user! 👋')
    os.exit()
end

-- No selection function
function NoSelect()
    gg.sleep(100)
    select = gg.alert('💫 Script Made By Comet 💫💗', 'OK')
    gg.toast("⏸️ Script paused! Tap GG icon to continue! 🌟", true)
    while not gg.isVisible() do
        gg.sleep(100)
    end
    gg.setVisible(false)
    input() -- Resume at input function
end

-- Global variables to store speeds
originalSpeed = nil
newSpeedGlobal = nil

-- Main loop
gg.setVisible(true)
while true do
    if gg.isVisible() then
        gg.setVisible(false)
        input()
    end
    gg.sleep(100)
end
