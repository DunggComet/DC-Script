-- Combined Dragon City Ultimate Mod with Test Skill Integration & Revert Paste Feature
gg.setVisible(false)
gg.clearResults()

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
  local response = gg.makeRequest("https://dragoncitytips.com/thien")
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
    return nil  -- Exit immediately if cancelled.
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
  
  local choice = safeChoiceSearch(matches, nil, "Select Dragon")
  if choice == nil then
    return nil
  end
  
  return codes[choice]
end

--------------------------------------------------
-- Original Mod Feature Implementations
--------------------------------------------------
  gg.setVisible(false)
  gg.clearResults()
  local selectedCode = searchDragonCode()
  if not selectedCode then return end

  gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
  gg.searchNumber(selectedCode..";0;-1::150", gg.TYPE_DWORD)
  gg.refineNumber(selectedCode..";0::15", gg.TYPE_DWORD)
  gg.refineNumber(selectedCode, gg.TYPE_DWORD)
  local results = gg.getResults(100)
  local validResultsLocal = {}
  for i, v in ipairs(results) do
    local offsetValues = {}
    for j = 0, 15 do
      offsetValues[j] = gg.getValues({{address = v.address + (j * 4), flags = gg.TYPE_DWORD}})[1].value
    end
    if offsetValues[1] ~= -1 and offsetValues[1] ~= 0 then
      table.insert(validResultsLocal, v)
    end
  end

  if #validResultsLocal > 0 then
    gg.editAll("1011", gg.TYPE_DWORD)
    gg.toast("Recall modified "..#validResultsLocal.." values", true)
  else
    gg.alert("No valid values found")
  end
  gg.sleep(1500)
