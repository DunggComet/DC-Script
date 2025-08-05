gg.setVisible(true)
fin_busc = 1
gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
gg.refineNumber("9288798", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)

-- Helper Function for Safe Prompt
local function waitForResume()
  gg.toast("Script paused. Click GG icon to resume", true)
  while not gg.isVisible() do
    gg.sleep(100)
  end
  gg.setVisible(false)
end

local function safePromptSearch(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  while not input do
    gg.toast("Script paused. Tap GG icon to resume.", true)
    waitForResume()
    while gg.isVisible() do
      gg.sleep(100)
    end
    gg.sleep(1000)
    input = gg.prompt(prompts, defaults, types)
  end
  return input
end

-- Dragon Data Fetching and Search Functions
local function fetchDragonData()
  local response = gg.makeRequest("https://dunggcomet.github.io/DC-Script/Website/Dragon")
  if not response or not response.content then
    gg.alert("⚠️ Failed to download dragon data!")
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
  local input = safePromptSearch({"🐉 Enter 1st Dragon name:"}, {""}, {"text"})
  if input == nil then return nil end
  local searchTerm = input[1]:lower()
  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end
  if #matches == 0 then
    gg.alert("⚠️ No dragons found for: " .. searchTerm)
    return nil
  end
  local choice = gg.choice(matches, nil, "Select Dragon")
  if choice == nil then return nil end
  return codes[choice]
end

while true do 
  if gg.isVisible(true) then 
    menuk = 1
    menuk2 = 2  
    gg.setVisible(false) 
  end 
  START = 1 
  function START() 
    menu = gg.choice({
      '🏆 Set Victories',
      '🥀 Set Defeats',
      '🔓 Unfreeze Values',
      '❌ Exit Script'
    }, nil, '🌟 Arena v1 Feature by Comet💫💗')
    if menu == 1 then lvl=1 idt=1011 what=0 rank=0 find_ones() end
    if menu == 2 then lvl=999 idt=3011 what=5 rank=500 find_ones() end
    if menu == 3 then 
      gg.setVisible(false)
      local frozenItems = gg.getListItems()
      if #frozenItems > 0 then
        gg.removeListItems(frozenItems)
        gg.toast('✅ All values unfrozen successfully!', true)
      else
        gg.toast('ℹ️ No frozen values found!', true)
      end
    end
    if menu == 4 then 
      local request = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua')
      if request.content then
        gg.toast('✅ Successfully fetched content!', true)
        local success, result = pcall(load(request.content))
        if success then
          gg.toast('🎉 Script loaded successfully!', true)
        else
          gg.alert('⚠️ Error loading script: ' .. tostring(result))
        end
      else
        gg.alert('⚠️ Failed to fetch content!')
      end
      gg.clearResults()
      os.exit()
    end
    if menu == nil then noselect() end 
    menuk = -1
  end

  function find_ones()
    if fin_busc == 0 then 
      menuk = -1 
      change_yisus()
    else
      local dragonCode = searchDragonCode()
      if dragonCode == nil then 
        menuk = -1 
        START()
      else
        local input1 = gg.prompt({
          "🔎 1st Dragon Level",
          "🔎 2nd Dragon Level",
          "🌟 1st Dragon Stars",
          "🌟 2nd Dragon Stars"
        }, {nil, nil, nil, nil}, {'number', 'number', 'number', 'number'})
        if input1 == nil or not input1[1] or not input1[2] or not input1[3] or not input1[4] then 
          gg.alert('⚠️ Invalid input provided!')
          menuk = -1 
          START()
          return
        else
          local datos = {input1[1], input1[3]}
          local data = {input1[2], input1[4]}
          gg.clearResults()
          gg.searchNumber(dragonCode .. ";" .. datos[1] .. ";" .. datos[2] .. ";" .. data[1] .. ";" .. data[2] .. "::500", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
          gg.refineNumber(dragonCode .. ";" .. datos[1] .. ";" .. datos[2] .. ";" .. data[1] .. "::250", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
          gg.refineNumber(dragonCode .. ";" .. datos[1] .. ";" .. datos[2] .. "::125", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
          gg.refineNumber(dragonCode .. ";" .. datos[1] .. "::60", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
          gg.refineNumber(dragonCode, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
          point = gg.getResults(10)
          if not point or #point == 0 then
            gg.alert('⚠️ No results found for the dragon code!')
            fin_busc = 1
            START()
            return
          end
          gg.addListItems(point)
          gg.clearResults()
          fin_busc = 0
          change_yisus()
        end
      end
    end
  end

  function change_yisus()
    if not point or #point == 0 then
      gg.alert('⚠️ No search results found to modify!')
      return
    end

    local valuesToFreeze = {}
    for _, v in ipairs(point) do
      if v.address then
        gg.setValues({
          {address = v.address + 0x0, flags = gg.TYPE_DWORD, value = 1011},
          {address = v.address + 0x4, flags = gg.TYPE_DWORD, value = 1},
          {address = v.address + 0x8, flags = gg.TYPE_DWORD, value = 0},
          {address = v.address + 0x24, flags = gg.TYPE_DWORD, value = 0},
          {address = v.address + 0x60, flags = gg.TYPE_DWORD, value = 1011},
          {address = v.address + 0x64, flags = gg.TYPE_DWORD, value = 1},
          {address = v.address + 0x68, flags = gg.TYPE_DWORD, value = 0},
          {address = v.address + 0x84, flags = gg.TYPE_DWORD, value = 0},
          {address = v.address + 0xC0, flags = gg.TYPE_DWORD, value = idt},
          {address = v.address + 0xC4, flags = gg.TYPE_DWORD, value = lvl},
          {address = v.address + 0xC8, flags = gg.TYPE_DWORD, value = rank},
          {address = v.address + 0xE4, flags = gg.TYPE_DWORD, value = what}
        })
        table.insert(valuesToFreeze, {address = v.address + 0x0, flags = gg.TYPE_DWORD, value = 1011, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x4, flags = gg.TYPE_DWORD, value = 1, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x8, flags = gg.TYPE_DWORD, value = 0, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x24, flags = gg.TYPE_DWORD, value = 0, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x60, flags = gg.TYPE_DWORD, value = 1011, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x64, flags = gg.TYPE_DWORD, value = 1, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x68, flags = gg.TYPE_DWORD, value = 0, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0x84, flags = gg.TYPE_DWORD, value = 0, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0xC0, flags = gg.TYPE_DWORD, value = idt, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0xC4, flags = gg.TYPE_DWORD, value = lvl, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0xC8, flags = gg.TYPE_DWORD, value = rank, freeze = true})
        table.insert(valuesToFreeze, {address = v.address + 0xE4, flags = gg.TYPE_DWORD, value = what, freeze = true})
      end
    end

    if #valuesToFreeze > 0 then
      gg.addListItems(valuesToFreeze)
      gg.toast(string.format('✅ Saved %d values to freeze list!', #valuesToFreeze), true)
    else
      gg.alert('⚠️ No values found to freeze!')
    end

    gg.toast('🎉 Battle Arena modification completed!', true)
    gg.sleep(1500)
    gg.toast('💖 Thanks for using my script!', true)
  end

  function noselect()     
    gg.setVisible(false)
  end
  if menuk == 1 then START() end
end
