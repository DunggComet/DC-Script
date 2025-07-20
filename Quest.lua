--------------------------------------------------
-- Shared Functions and Dragon Data Management
--------------------------------------------------
local function waitForResume()
  gg.toast("Script paused. Click GG icon to resume", true)
  while not gg.isVisible() do
    gg.sleep(100)
  end
  gg.setVisible(false)
end

-- For search steps: if cancelled, exit to main menu.
local function safePromptSearch(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  if input == nil then
    gg.toast("Returning to main menu...", true)
    waitForResume()
    return nil
  end
  return input
end

local function safeChoiceSearch(items, default, title)
  local choice = gg.choice(items, default, title)
  if choice == nil then
    gg.toast("Returning to main menu...", true)
    waitForResume()
    return nil
  end
  return choice
end

-- For numeric input steps: if cancelled, loop until valid input is provided.
local function safePromptLoop(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  while input == nil do
    gg.toast("Script paused. Click GG icon to resume", true)
    waitForResume()
    input = gg.prompt(prompts, defaults, types)
  end
  return input
end

local function fetchDragonData()
  local response = gg.makeRequest("https://dunggcomet.github.io/DC-Script/Website/Dragon")
  if not response or not response.content then
    gg.alert("Failed to download dragon data!")
    return nil
  end
  local data = {}
  for match in response.content:gmatch("<div class='dragon%-item'>(.-)</div>") do
    local cleaned = match:gsub("<[^>]+>", ""):gsub("-", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if cleaned:match("^%d") then
      local code, name = cleaned:match("^(%d+)%s+(.+)$")
      if code and name then
        table.insert(data, {code = code, name = name})
      end
    end
  end
  return #data > 0 and data or nil
end

local globalDragonData = fetchDragonData()

local function getDragonNameFromCode(code)
  if not globalDragonData then return "Undefined Dragon" end
  for _, dragon in ipairs(globalDragonData) do
    if dragon.code == tostring(code) then
      return dragon.name
    end
  end
  return "Undefined Dragon"
end

local function searchDragonCode()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptSearch({"Enter dragon name:"}, {""}, {"text"})
  if input == nil then
    return nil
  end
  
  local searchTerm = input[1]:lower()
  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end
  
  if #matches == 0 then
    gg.alert("No dragons found for: " .. searchTerm)
    return nil
  end
  
  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Select Dragon")
    if choice == nil then
      gg.toast("Selection paused. Tap GG icon to resume.", true)
      waitForResume()
    end
  until choice ~= nil
  
  return codes[choice]
end

local function searchDragonCodeLoop()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptLoop({"Enter 1st dragon name:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()
  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("No dragons found for: " .. searchTerm)
    return nil
  end

  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Select Dragon")
    if choice == nil then
      gg.toast("Selection paused. Tap GG icon to resume.", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

-- 2nd dragon picker (was searchDragonCodeLooop)
local function searchDragonCodeLooop()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  -- keep prompting until user gives text
  local input = safePromptLoop({"Enter 2nd dragon name:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()

  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("No dragons found for: " .. searchTerm)
    return nil
  end

  -- repeat choice until user selects one
  local choice
  repeat
    choice = gg.choice(matches, nil, "Select 2nd Dragon")
    if choice == nil then
      gg.toast("Paused. Tap GG icon to resume.", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

-- 3rd dragon picker (was searchDragonCodeLoooop)
local function searchDragonCodeLoooop()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptLoop({"Enter 3rd dragon name:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()

  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("No dragons found for: " .. searchTerm)
    return nil
  end

  local choice
  repeat
    choice = gg.choice(matches, nil, "Select 3rd Dragon")
    if choice == nil then
      gg.toast("Paused. Tap GG icon to resume.", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

local function searchDragonCodeLooooop()  -- Note the triple 'o'
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptSearch({"Enter 3rd dragon after name:"}, {""}, {"text"})
  if input == nil then
    return nil
  end
  
  local searchTerm = input[1]:lower()
  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end
  
  if #matches == 0 then
    gg.alert("No dragons found for: " .. searchTerm)
    return nil
  end
  
  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Select Dragon")
    if choice == nil then
      gg.toast("Selection paused. Tap GG icon to resume.", true)
      waitForResume()
    end
  until choice ~= nil
  
  return codes[choice]
end


--------------------------------------------------
-- Original Mod Feature Implementations
--------------------------------------------------
local function getTeamData(id)
  local url = "https://dragoncitytips.com/scripts/checkteam?id=" .. id
  local http = gg.makeRequest(url)
  if not http or not http.content then
    gg.alert("Không thể lấy dữ liệu từ API!")
    return nil
  end

  local content = http.content:gsub("<br>", "\n")
  local lines = {}
  for line in content:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end

  if #lines < 5 then
    gg.alert("Dữ liệu không hợp lệ!")
    return nil
  end

  return {
    dragonCode       = lines[1],
    firstDragonLevel = tonumber(lines[2]) or 1,
    firstDragonGrade = tonumber(lines[3]) or 1,
    secondDragonLevel= tonumber(lines[4]) or 1,
    secondDragonGrade= tonumber(lines[5]) or 1
  }
end
local backupRankUpValues = {}       -- { [address] = {value = originalValue, flags = TYPE} }
local rankUpBaseAddresses = {}      -- list of base addresses modified by doRankUp

-- Function to revert all backed-up addresses to their original values
local function revertAllRankUp()
  if next(backupRankUpValues) == nil then
    gg.alert("No backed-up values to revert.")
    return
  end

  -- Restore original values for each backed-up address
  local restoredCount = 0
  for addr, entry in pairs(backupRankUpValues) do
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    gg.setValues({{
      address = addr,
      flags   = entry.flags,
      value   = entry.value
    }})
    restoredCount = restoredCount + 1
    backupRankUpValues[addr] = nil
  end

  gg.toast(string.format("Reverted %d values to original.", restoredCount), true)
  -- Clear base addresses so user must re-run doRankUp first
  rankUpBaseAddresses = {}
end

-- New: Change Final Dragon Code                <---- Moved above featureRankUpMenu
local function featureChangeFinalDragon()
  -- 1) Ensure doRankUp has run
  if #rankUpBaseAddresses == 0 then
    gg.alert("No prior Quest Mod (RankUp) run found. Run it first.")
    return
  end

  -- 2) Prompt the user to select a dragon (reuse existing searchDragonCode mechanics)
  local newCodeStr = searchDragonCode()
  if not newCodeStr then
    gg.alert("No dragon selected. Aborting.")
    return
  end
  local newCode = tonumber(newCodeStr)
  if not newCode then
    gg.alert("Invalid code from searchDragonCode.")
    return
  end

  -- 3) Write new finalDragonCode to each stored baseAddr + 0xA0, then save values
  local savedCount = 0
  local toSave = {}
  for _, baseAddr in ipairs(rankUpBaseAddresses) do
    local targetAddr = baseAddr + 0xA0
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    gg.setValues({{address = targetAddr, flags = gg.TYPE_DWORD, value = newCode}})

    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local curr = gg.getValues({{address = targetAddr, flags = gg.TYPE_DWORD}})
    if curr and curr[1] then
      table.insert(toSave, {
        address = targetAddr,
        flags   = gg.TYPE_DWORD,
        value   = curr[1].value
      })
      savedCount = savedCount + 1
    end
  end

  if #toSave > 0 then
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    gg.addListItems(toSave)
    gg.toast(string.format("Updated and saved %d finalDragonCode entries.", savedCount), true)
  else
    gg.alert("Failed to update finalDragonCode values.")
  end
end

-- Core RankUp implementation (saves values, does not freeze)
local function doRankUp()
  gg.setVisible(false)
  gg.clearResults()
  rankUpBaseAddresses = {}        -- reset from any prior run

  local selectedCode = searchDragonCodeLoop()
  if not selectedCode then return end
  local extraCode = searchDragonCodeLooop()
  if not extraCode then return end
  local bonusCode = searchDragonCodeLoooop()
  if not bonusCode then return end

  -- Prompt for numeric inputs
  local IDRong  = safePromptLoop({'1st dragon level🔎', '1st grade🌟'}, {nil, nil}, {'number', 'number'})
  local IDRong2 = safePromptLoop({'2nd dragon level🔎', '2nd grade🌟'}, {nil, nil}, {'number', 'number'})
  local IDRong3 = safePromptLoop({'3rd dragon level🔎', '3rd grade🌟'}, {nil, nil}, {'number', 'number'})

  -- Prompt for final dragon code (string), convert to number
  local finalDragonCode = nil
  while finalDragonCode == nil do
    gg.toast("Select final dragon or leave empty for idle mode", true)
    finalDragonCode = searchDragonCodeLooooop()
    if not finalDragonCode then
      gg.toast("Script paused. Click GG icon ONCE to resume.", true)
      gg.setVisible(true)
      while not gg.isVisible() do
        gg.sleep(100)
      end
      gg.setVisible(false)
    end
  end
  finalDragonCode = tonumber(finalDragonCode)
  if not finalDragonCode then
    gg.alert("Invalid final dragon code.")
    return
  end

  ---- Phase 1: Search & Collect Modifications ----
  gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
  gg.searchNumber(
    selectedCode .. ";" ..
    IDRong[1]  .. ";" ..
    IDRong[2]  .. ";" ..
	extraCode .. ";" ..
    IDRong2[1] .. ";" ..
    IDRong2[2] .. ";" ..
	bonusCode .. ";" ..
	IDRong3[1] .. ";" ..
	IDRong3[2] .. "::221",
    gg.TYPE_DWORD
  )
  gg.refineNumber(
    selectedCode .. ";" ..
    IDRong[1]  .. ";" ..
    IDRong[2]  .. ";" ..
	extraCode .. ";" ..
    IDRong2[1] .. ";" ..
    IDRong2[2] .. "::110",
    gg.TYPE_DWORD
  )
  gg.refineNumber(
    selectedCode .. ";" ..
    IDRong[1]  .. ";" ..
    IDRong[2]  .. "::55",
    gg.TYPE_DWORD
  )
  gg.refineNumber(selectedCode, gg.TYPE_DWORD)

  local gat = gg.getResults(1000)
  if not gat or #gat == 0 then
    gg.alert("No matching entries found for Quest Mod.")
    return
  end

  -- Determine if any offset+4 > 0
  local hasPositiveValue = false
  for _, v in ipairs(gat) do
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local offsetValue1 = gg.getValues({{address = v.address + 0x4, flags = gg.TYPE_DWORD}})
    if offsetValue1 and offsetValue1[1] and offsetValue1[1].value > 0 then
      hasPositiveValue = true
      break
    end
  end

  -- Gather instructions per entry
  local modifications = {}
  for _, v in ipairs(gat) do
    local baseAddr = v.address

    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local off1_tbl = gg.getValues({{address = baseAddr + 0x4, flags = gg.TYPE_DWORD}})
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local off2_tbl = gg.getValues({{address = baseAddr + 0x8, flags = gg.TYPE_DWORD}})

    if not off1_tbl or not off1_tbl[1] or not off2_tbl or not off2_tbl[1] then
      goto skip_entry
    end

    local off1 = off1_tbl[1].value
    local off2 = off2_tbl[1].value

    local offsetsToBackup, writeInstructions

    if not hasPositiveValue and off1 == -1 then
      offsetsToBackup = {0x0, 0x8, 0x10, 0x50, 0x58, 0x60, 0xA0, 0xA8, 0xB0, 0xB8}
      writeInstructions = {
        {0x0,  1011}, {0x8,  1},   {0x10, 0},
        {0x50, 1011}, {0x58, 1},   {0x60, 0},
        {0xA0, finalDragonCode}, {0xA8, 999},
        {0xB0, 5},   {0xB8, 500}
      }

    elseif off1 > 0 and off2 ~= IDRong[1] then
      offsetsToBackup = {0x0, 0x4, 0x10, 0x50, 0x54, 0x60, 0xA0, 0xA4, 0xB0, 0xB8}
      writeInstructions = {
        {0x0,  1011}, {0x4, 1},   {0x10, 0},
        {0x50, 1011}, {0x54, 1},  {0x60, 0},
        {0xA0, finalDragonCode}, {0xA4, 999},
        {0xB0, 5},   {0xB8, 500}
      }

    elseif off1 > 0 and off2 == IDRong[1] then
      offsetsToBackup = {0x0, 0x8, 0x10, 0x50, 0x58, 0x60, 0xA0, 0xA8, 0xB0, 0xB8}
      writeInstructions = {
        {0x0,  1011}, {0x8, 1},   {0x10, 0},
        {0x50, 1011}, {0x58, 1},  {0x60, 0},
        {0xA0, finalDragonCode}, {0xA8, 999},
        {0xB0, 5},   {0xB8, 500}
      }

    elseif off2 == 0 then
      offsetsToBackup = {0x0, 0x4, 0x10, 0x50, 0x54, 0x60, 0xA0, 0xA4, 0xB0, 0xB8}
      writeInstructions = {
        {0x0,  1011}, {0x4, 1},   {0x10, 0},
        {0x50, 1011}, {0x54, 1},  {0x60, 0},
        {0xA0, finalDragonCode}, {0xA4, 999},
        {0xB0, 5},   {0xB8, 500}
      }

    else
      goto skip_entry
    end

    table.insert(modifications, {
      baseAddr = baseAddr,
      offsetsToBackup = offsetsToBackup,
      writeInstructions = writeInstructions
    })

    ::skip_entry::
  end

  if #modifications == 0 then
    gg.alert("No valid Quest Mod entries to modify.")
    return
  end

  ---- Phase 1b: Backup originals (all entries) ----
  local backupCount = 0
  for _, mod in ipairs(modifications) do
    -- Record baseAddr so we can later change finalDragonCode
    table.insert(rankUpBaseAddresses, mod.baseAddr)

    for _, off in ipairs(mod.offsetsToBackup) do
      local addrToBackup = mod.baseAddr + off
      gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
      local orig = gg.getValues({{address = addrToBackup, flags = gg.TYPE_DWORD}})
      if orig and orig[1] then
        if not backupRankUpValues[addrToBackup] then
          backupRankUpValues[addrToBackup] = { value = orig[1].value, flags = gg.TYPE_DWORD }
          backupCount = backupCount + 1
        end
      end
    end
  end

  if backupCount == 0 then
    gg.alert("Failed to back up any original values. Aborting Quest Mod.")
    return
  end
  gg.toast(string.format("Backed up %d original values.", backupCount), true)

  ---- Phase 2: Apply writes & save new values (no freeze) ----
  local savedCount = 0
  for _, mod in ipairs(modifications) do
    local baseAddr = mod.baseAddr

    -- Perform all writes for this entry
    for _, inst in ipairs(mod.writeInstructions) do
      gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
      gg.setValues({{address = baseAddr + inst[1], flags = gg.TYPE_DWORD, value = inst[2]}})
    end

    -- Immediately read back each written value and add to Saved List
    local valuesToSave = {}
    for _, inst in ipairs(mod.writeInstructions) do
      local addrToSave = baseAddr + inst[1]
      gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
      local current = gg.getValues({{address = addrToSave, flags = gg.TYPE_DWORD}})
      if current and current[1] then
        table.insert(valuesToSave, {
          address = addrToSave,
          flags   = gg.TYPE_DWORD,
          value   = current[1].value
        })
        savedCount = savedCount + 1
      end
    end

    if #valuesToSave > 0 then
      gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
      gg.addListItems(valuesToSave)
    end
  end

  gg.toast(string.format("Quest Mod complete, saved %d values.", savedCount), true)
  gg.sleep(1500)
end

-- Menu wrapper for RankUp: Proceed, Revert, or Change Final Dragon Code
local function featureRankUpMenu()
  while true do
    local choice = gg.choice(
      {'1. Proceed with Quest Mod (RankUp)',
       '2. Revert all Quest Mod changes',
       '3. Change Final Dragon Code',
       '4. Return to main menu'},
      nil,
      'Choose an action for Quest Mod (RankUp)'
    )
    if choice == nil then
      gg.toast('Resuming Quest Mod menu...', true)
      waitForResume()
    elseif choice == 1 then
      doRankUp()
    elseif choice == 2 then
      revertAllRankUp()
    elseif choice == 3 then
      featureChangeFinalDragon()
    elseif choice == 4 then
      return
    end
    -- After action, loop again
  end
end
----------------
featureRankUpMenu()
