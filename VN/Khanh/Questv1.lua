--------------------------------------------------
-- Các Hàm Chung và Quản Lý Dữ Liệu Rồng 🐉
--------------------------------------------------
local function waitForResume()
  gg.toast("⏸️ Tạm dừng kịch bản. Nhấn vào biểu tượng GG để tiếp tục!", true)
  while not gg.isVisible() do
    gg.sleep(100)
  end
  gg.setVisible(false)
end

-- Đối với các bước tìm kiếm: nếu hủy, quay lại menu chính.
local function safePromptSearch(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  if input == nil then
    gg.toast("↩️ Quay lại menu chính...", true)
    waitForResume()
    return nil
  end
  return input
end

local function safeChoiceSearch(items, default, title)
  local choice = gg.choice(items, default, title)
  if choice == nil then
    gg.toast("↩️ Quay lại menu chính...", true)
    waitForResume()
    return nil
  end
  return choice
end

-- Đối với các bước nhập số: lặp lại cho đến khi có đầu vào hợp lệ.
local function safePromptLoop(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  while input == nil do
    gg.toast("⏸️ Tạm dừng kịch bản. Nhấn vào biểu tượng GG để tiếp tục!", true)
    waitForResume()
    input = gg.prompt(prompts, defaults, types)
  end
  return input
end

local function fetchDragonData()
  local response = gg.makeRequest("https://dunggcomet.github.io/DC-Script/Website/Dragon")
  if not response or not response.content then
    gg.alert("⚠️ Không thể tải dữ liệu rồng từ máy chủ!")
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
  if not globalDragonData then return "Rồng Không Xác Định" end
  for _, dragon in ipairs(globalDragonData) do
    if dragon.code == tostring(code) then
      return dragon.name
    end
  end
  return "Rồng Không Xác Định"
end

local function searchDragonCode()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptSearch({"🔍 Nhập tên rồng để tìm kiếm:"}, {""}, {"text"})
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
    gg.alert("⚠️ Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end
  
  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng Của Bạn:")
    if choice == nil then
      gg.toast("⏸️ Tạm dừng lựa chọn. Nhấn vào biểu tượng GG để tiếp tục!", true)
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

  local input = safePromptLoop({"🔍 Nhập tên rồng thứ nhất:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()
  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("⚠️ Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end

  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng Thứ Nhất:")
    if choice == nil then
      gg.toast("⏸️ Tạm dừng lựa chọn. Nhấn vào biểu tượng GG để tiếp tục!", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

local function searchDragonCodeLooop()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptLoop({"🔍 Nhập tên rồng thứ hai:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()

  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("⚠️ Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end

  local choice
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng Thứ Hai:")
    if choice == nil then
      gg.toast("⏸️ Tạm dừng lựa chọn. Nhấn vào biểu tượng GG để tiếp tục!", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

local function searchDragonCodeLoooop()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptLoop({"🔍 Nhập tên rồng thứ ba:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()

  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("⚠️ Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end

  local choice
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng Thứ Ba:")
    if choice == nil then
      gg.toast("⏸️ Tạm dừng lựa chọn. Nhấn vào biểu tượng GG để tiếp tục!", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

local function searchDragonCodeLooooop()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then return nil end
  end

  local input = safePromptSearch({"🔍 Nhập tên rồng cuối cùng:"}, {""}, {"text"})
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
    gg.alert("⚠️ Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end
  
  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng Cuối Cùng:")
    if choice == nil then
      gg.toast("⏸️ Tạm dừng lựa chọn. Nhấn vào biểu tượng GG để tiếp tục!", true)
      waitForResume()
    end
  until choice ~= nil
  
  return codes[choice]
end

local backupRankUpValues = {}       -- { [address] = {value = originalValue, flags = TYPE} }
local rankUpBaseAddresses = {}      -- danh sách các địa chỉ cơ bản được sửa đổi bởi doRankUp

local function revertAllRankUp()
  if next(backupRankUpValues) == nil then
    gg.alert("ℹ️ Không có sửa đổi trước đó để khôi phục.")
    return
  end

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

  gg.toast(string.format("✅ Đã khôi phục %d giá trị ban đầu!", restoredCount), true)
  rankUpBaseAddresses = {}
end

local function featureChangeFinalDragon()
  if #rankUpBaseAddresses == 0 then
    gg.alert("⚠️ Mod Nhiệm Vụ (RankUp) chưa được thực thi. Hãy chạy nó trước!")
    return
  end

  local newCodeStr = searchDragonCode()
  if not newCodeStr then
    gg.alert("⚠️ Không có rồng nào được chọn. Thao tác bị hủy.")
    return
  end
  local newCode = tonumber(newCodeStr)
  if not newCode then
    gg.alert("⚠️ Mã rồng ­rồng không hợp lệ được chọn.")
    return
  end

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
    gg.toast(string.format("✅ Đã cập nhật %d mã rồng thành công!", savedCount), true)
  else
    gg.alert("⚠️ Không thể cập nhật mã rồng.")
  end
end

local function doRankUp()
  gg.setVisible(false)
  gg.clearResults()
  rankUpBaseAddresses = {}

  local selectedCode = searchDragonCodeLoop()
  if not selectedCode then return end
  local extraCode = searchDragonCodeLooop()
  if not extraCode then return end
  local bonusCode = searchDragonCodeLoooop()
  if not bonusCode then return end

  local IDRong  = safePromptLoop({'🔎 Cấp độ rồng thứ nhất', '🌟 Hạng rồng thứ nhất'}, {nil, nil}, {'number', 'number'})
  local IDRong2 = safePromptLoop({'🔎 Cấp độ rồng thứ hai', '🌟 Hạng rồng thứ hai'}, {nil, nil}, {'number', 'number'})
  local IDRong3 = safePromptLoop({'🔎 Cấp độ rồng thứ ba', '🌟 Hạng rồng thứ ba'}, {nil, nil}, {'number', 'number'})

  local finalDragonCode = nil
  while finalDragonCode == nil do
    gg.toast("🐲 Chọn rồng cuối cùng để tiếp tục.", true)
    finalDragonCode = searchDragonCodeLooooop()
    if not finalDragonCode then
      gg.toast("⏸️ Tạm dừng kịch bản. Nhấn vào biểu tượng GG để tiếp tục!", true)
      gg.setVisible(true)
      while not gg.isVisible() do
        gg.sleep(100)
      end
      gg.setVisible(false)
    end
  end
  finalDragonCode = tonumber(finalDragonCode)
  if not finalDragonCode then
    gg.alert("⚠️ Mã rồng cuối cùng không hợp lệ được chọn.")
    return
  end

  ---- Giai đoạn 1: Tìm kiếm & Thu thập sửa đổi ----
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
    gg.alert("⚠️ Không tìm thấy mục nào phù hợp cho Mod Nhiệm Vụ.")
    return
  end

  local hasPositiveValue = false
  for _, v in ipairs(gat) do
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local offsetValue1 = gg.getValues({{address = v.address + 0x4, flags = gg.TYPE_DWORD}})
    if offsetValue1 and offsetValue1[1] and offsetValue1[1].value > 0 then
      hasPositiveValue = true
      break
    end
  end

  local modifications = {}
  for _, v in ipairs(gat) do
    local baseAddr = v.address

    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local off1_tbl = gg.getValues({{address = baseAddr + 0x4, flags = gg.TYPE_DWORD}})
    gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
    local off2_tbl = gg.getValues({{address = baseAddr + 0x8, flags = gg.TYPE_DWORD}})

    if not off1_tbl or not off1_tbl[1] or not off2_tbl or not off2_four[1] then
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
    gg.alert("⚠️ Không tìm thấy mục nào hợp lệ cho Mod Nhiệm Vụ.")
    return
  end

  ---- Giai đoạn 1b: Sao lưu các giá trị gốc (tất cả các mục) ----
  local backupCount = 0
  for _, mod in ipairs(modifications) do
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
    gg.alert("⚠️ Không thể sao lưu các giá trị gốc. Mod Nhiệm Vụ bị hủy.")
    return
  end
  gg.toast(string.format("✅ Đã sao lưu %d giá trị thành công!", backupCount), true)

  ---- Giai đoạn 2: Áp dụng các thay đổi & lưu giá trị mới (không đóng băng) ----
  local savedCount = 0
  for _, mod in ipairs(modifications) do
    local baseAddr = mod.baseAddr

    for _, inst in ipairs(mod.writeInstructions) do
      gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
      gg.setValues({{address = baseAddr + inst[1], flags = gg.TYPE_DWORD, value = inst[2]}})
    end

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

  gg.toast(string.format("🎉 Mod Nhiệm Vụ hoàn tất! Đã lưu %d giá trị.", savedCount), true)
  gg.sleep(1500)
end

local function featureRankUpMenu()
  while true do
    local choice = gg.choice(
      {'🚀 Chạy Tool Quest (RankUp)',
       '🔄 Khôi phục Tất Cả Thay Đổi Mod Quest',
       '🐉 Cập Nhật Mã Rồng Cuối Cùng',
       '↩️ Quay Lại Menu Chính'},
      nil,
      'Script Quest v1 Được Tạo Bởi Comet💫💗\n🔧 Tùy Chọn Mod Quest (RankUp):'
    )
    if choice == nil then
      gg.toast('⏸️ Tiếp tục menu Mod Nhiệm Vụ...', true)
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
  end
end
----------------
featureRankUpMenu()
