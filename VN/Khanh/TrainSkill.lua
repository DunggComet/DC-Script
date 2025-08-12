```lua
-- TestSkillMod.lua
-- Tệp này chỉ chứa các tính năng Test/Skill Mod và các phụ thuộc tối thiểu.
gg.setVisible(false)
--------------------------------------------------
-- Các Hàm Hỗ Trợ Chung & Quản Lý Dữ Liệu Rồng
--------------------------------------------------
local function waitForResume()
  gg.toast("Tạm dừng kịch bản. Nhấn biểu tượng GG để tiếp tục", true)
  while not gg.isVisible() do
    gg.sleep(100)
  end
  gg.setVisible(false)
end

local function safePromptSearch(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  while not input do
    gg.toast("Tạm dừng kịch bản. Nhấn biểu tượng GG để tiếp tục.", true)
    waitForResume()
    -- Đợi cho đến khi GG không còn hiển thị trước khi yêu cầu lại.
    while gg.isVisible() do
      gg.sleep(100)
    end
    gg.sleep(1000)  -- Độ trễ bổ sung có thể giúp đặt lại trạng thái yêu cầu.
    input = gg.prompt(prompts, defaults, types)
  end
  return input
end

local function safeChoiceSearch(items, default, title)
  local choice = gg.choice(items, default, title)
  if choice == nil then
    gg.toast("Quay lại menu chính...", true)
    waitForResume()
    return nil
  end
  return choice
end

local function safePromptLoop(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  while input == nil do
    gg.toast("Tạm dừng kịch bản. Nhấn biểu tượng GG để tiếp tục", true)
    waitForResume()
    input = gg.prompt(prompts, defaults, types)
  end
  return input
end

local function fetchDragonData()
  local response = gg.makeRequest("https://dunggcomet.github.io/DC-Script/Website/Dragon")
  if not response or not response.content then
    gg.alert("Không thể tải dữ liệu rồng!")
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

  local input = safePromptSearch({"Nhập tên rồng:"}, {""}, {"text"})
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
    gg.alert("Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end
  
  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng")
    if choice == nil then
      gg.toast("Tạm dừng lựa chọn. Nhấn biểu tượng GG để tiếp tục.", true)
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

  local input = safePromptLoop({"Nhập tên rồng:"}, {""}, {"text"})
  local searchTerm = input[1]:lower()
  local matches, codes = {}, {}
  for _, dragon in ipairs(globalDragonData) do
    if dragon.name:lower():find(searchTerm, 1, true) then
      table.insert(matches, "📋 " .. dragon.code .. " - " .. dragon.name)
      table.insert(codes, dragon.code)
    end
  end

  if #matches == 0 then
    gg.alert("Không tìm thấy rồng nào cho: " .. searchTerm)
    return nil
  end

  local choice = nil
  repeat
    choice = gg.choice(matches, nil, "Chọn Rồng")
    if choice == nil then
      gg.toast("Tạm dừng lựa chọn. Nhấn biểu tượng GG để tiếp tục.", true)
      waitForResume()
    end
  until choice ~= nil

  return codes[choice]
end

--------------------------------------------------
-- Các Hàm và Biến của Test/Skill Mod
--------------------------------------------------
local copiedAllValues = {}  
local copiedValues = {}
local validResultsTest = {}
local originalCodeTest = nil
local changedCodeTest  = nil
local baseAddress = nil
-- Bảng sao lưu để lưu trữ các giá trị gốc trước khi dán.
local backupPastedValuesTest = {}

local function processMemorySearchTest(selectedCode)
  gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
  gg.searchNumber(selectedCode..";0;-1::150", gg.TYPE_DWORD)
  gg.refineNumber(selectedCode..";0::15", gg.TYPE_DWORD)
  gg.refineNumber(selectedCode, gg.TYPE_DWORD)
  local results = gg.getResults(100)
  validResultsTest = {}
  for _, v in ipairs(results) do
    local offsets = {}
    for i = 1, 15 do
      offsets[i] = gg.getValues({{address = v.address + (i * 4), flags = gg.TYPE_DWORD}})[1].value
    end
    if offsets[1] ~= -1 and offsets[1] ~= 0 and
       offsets[2] ~= -1 and
       offsets[3] ~= -1 and offsets[3] ~= 0 and
       offsets[4] ~= -1 and offsets[4] ~= 0 and
       offsets[5] ~= -1 and offsets[5] ~= 0 and
       offsets[6] ~= -1 and offsets[6] ~= 0 and
       offsets[7] ~= 0 and offsets[7] ~= -1 and
       offsets[8] ~= 0 and
       offsets[9] ~= -1 and offsets[9] ~= 0 and
       offsets[10] ~= -1 and offsets[10] ~= 0 and
       offsets[11] ~= -1 and offsets[11] ~= 0 and
       offsets[12] ~= -1 and offsets[12] ~= 0 and
       offsets[13] ~= -1 and offsets[13] ~= 0 and
       offsets[14] ~= -1 and offsets[14] ~= 0 and
       offsets[15] ~= -1 and offsets[15] ~= 0 and offsets[15] ~= 8 then
      table.insert(validResultsTest, v)
    end
  end
  if #validResultsTest > 0 then
    baseAddress = validResultsTest[1].address
    if #validResultsTest == 1 then
      local single = validResultsTest[1]
      single.name = single.value .. " - " .. getDragonNameFromCode(single.value)
      gg.addListItems(validResultsTest)
    elseif #validResultsTest > 1 and #validResultsTest < 109 then
      for i, v in ipairs(validResultsTest) do
        v.value = 1038 + i
        v.name = v.value .. " - " .. getDragonNameFromCode(v.value)
      end
      gg.setValues(validResultsTest)
      gg.addListItems(validResultsTest)
    elseif #validResultsTest > 108 then
      for _, v in ipairs(validResultsTest) do
        v.value = 1011
        v.name = v.value .. " - " .. getDragonNameFromCode(v.value)
      end
      gg.setValues(validResultsTest)
      gg.addListItems(validResultsTest)
    end
    return true
  end
  return false
end

local function copyOffsetTest()
  local srcChoice = nil
  repeat
    srcChoice = gg.choice({
      'Từ kỹ năng/tấn công thứ 1 (Cơ bản)', 'Từ kỹ năng/tấn công thứ 2 (Cơ bản)',
      'Từ kỹ năng/tấn công thứ 3 (Cơ bản)', 'Từ kỹ năng/tấn công thứ 4 (Cơ bản)',
      'Từ kỹ năng/tấn công thứ 1 (Trung tâm huấn luyện)', 'Từ kỹ năng/tấn công thứ 2 (Trung tâm huấn luyện)',
      'Từ kỹ năng/tấn công thứ 3 (Trung tâm huấn luyện)', 'Từ kỹ năng/tấn công thứ 4 (Trung tâm huấn luyện)',
      'Quay lại'
    }, nil, "Sao chép 1 Kỹ năng/Tấn công từ TẤT CẢ Kết quả")
    if srcChoice == nil then
      gg.toast("Tạm dừng. Nhấn biểu tượng GG để tiếp tục.", true)
      waitForResume()
    end
  until srcChoice ~= nil
  if srcChoice > 8 then return end
  local srcOffset = ({0x20, 0x24, 0x28, 0x2C, 0x30, 0x34, 0x38, 0x3C})[srcChoice]
  copiedValues = {}
  for _, result in ipairs(validResultsTest) do
    local addr = result.address + srcOffset
    local val = gg.getValues({{address = addr, flags = gg.TYPE_DWORD}})[1].value
    copiedValues[result.address] = val
  end
end

local function copyAllOffsetTest()
  if not validResultsTest or #validResultsTest == 0 then
    gg.alert("❗ Không có kết quả hợp lệ để sao chép!")
    return
  end
  copiedAllValues = {}
  local offs = {0x30, 0x34, 0x38, 0x3C}
  for _, result in ipairs(validResultsTest) do
    local addr = result.address
    local vals = {}
    for _, off in ipairs(offs) do
      vals[off] = gg.getValues({{ address = addr + off, flags = gg.TYPE_DWORD }})[1].value
    end
    copiedAllValues[addr] = vals
  end
end

local function pasteOffsetTest()
  if not next(copiedValues) then
    gg.alert("❗ Không có giá trị đã sao chép! Hãy sao chép trước.")
    return
  end
  local targets = {0x20, 0x24, 0x28, 0x2C}
  for _, result in ipairs(validResultsTest) do
    for _, offset in ipairs(targets) do
      local addr = result.address + offset
      if backupPastedValuesTest[addr] == nil then
         local origVal = gg.getValues({{address = addr, flags = gg.TYPE_DWORD}})[1].value
         backupPastedValuesTest[addr] = origVal
      end
      gg.setValues({{address = addr, flags = gg.TYPE_DWORD, value = copiedValues[result.address]}})
    end
  end
end

local function pasteAllOffsetTest()
  if not copiedAllValues or next(copiedAllValues) == nil then
    gg.alert("❗ Không có giá trị sao chép hàng loạt để dán!")
    return
  end
  local mapping = {
    {src=0x30, dst=0x20},
    {src=0x34, dst=0x24},
    {src=0x38, dst=0x28},
    {src=0x3C, dst=0x2C},
  }
  for baseAddr, vals in pairs(copiedAllValues) do
    local ops = {}
    for _, m in ipairs(mapping) do
      table.insert(ops, {
        address = baseAddr + m.dst,
        flags   = gg.TYPE_DWORD,
        value   = vals[m.src]
      })
    end
    gg.setValues(ops)
  end
end

local function revertPastedValuesTest()
   if not next(backupPastedValuesTest) then
      gg.alert("Không có giá trị đã dán để khôi phục!")
      return
   end
   local revertItems = {}
   for addr, origVal in pairs(backupPastedValuesTest) do
       table.insert(revertItems, {address = addr, flags = gg.TYPE_DWORD, value = origVal})
   end
   gg.setValues(revertItems)
   backupPastedValuesTest = {}  -- Xóa sao lưu sau khi khôi phục
   gg.toast("Đã khôi phục các giá trị đã dán")
end

local function testSkillMenu()
  while true do
    local menuItems = {
      "🔄 Thay Đổi Mã Rồng",
      "📋 Sao Chép Một Kỹ Năng/Tấn Công",
      "📚 Sao Chép Tất Cả Kỹ Năng/Tấn Công",
      "🎨 Áp Dụng Cho Tất Cả Tấn Công (Mod: Một Thành Bốn)",
      "🌐 Áp Dụng Cho Tất Cả Tấn Công (Mod: Bốn Thành Bốn)",
      "🔄 Khôi Phục Giá Trị Đã Dán",
      "🔍 Tìm Kiếm Mới",
      "⏮ Khôi Phục Rồng Gốc",
      "⏭ Khôi Phục Rồng Đã Sửa Đổi",
      "👋 Thoát Test Skill"
    }
    local choice = safeChoiceSearch(menuItems, nil,
      string.format("Cơ bản: 0x%X | Hiện tại: %s", baseAddress, getDragonNameFromCode(originalCodeTest))
    )
    if choice == 1 then
      local newCode = searchDragonCode()
      if newCode then
        changedCodeTest = newCode
        for _, v in ipairs(validResultsTest) do
          v.value = tonumber(newCode)
          v.name = newCode.." - "..getDragonNameFromCode(newCode)
        end
        gg.setValues(validResultsTest)
        gg.addListItems(validResultsTest)
        gg.toast("Đã thay đổi thành: "..getDragonNameFromCode(newCode))
      end
    elseif choice == 2 then
      copyOffsetTest()
    elseif choice == 3 then
      copyAllOffsetTest()
    elseif choice == 4 then
      pasteOffsetTest()
    elseif choice == 5 then
      pasteAllOffsetTest()
    elseif choice == 6 then
      revertPastedValuesTest()
    elseif choice == 7 then
      gg.clearResults()
      return true  -- Tìm kiếm mới: quay lại để chạy lại tìm kiếm test skill
    elseif choice == 8 then
      for _, v in ipairs(validResultsTest) do
        v.value = tonumber(originalCodeTest)
        v.name = originalCodeTest.." - "..getDragonNameFromCode(originalCodeTest)
      end
      gg.setValues(validResultsTest)
      gg.addListItems(validResultsTest)
      gg.toast("Đã khôi phục về rồng gốc")
    elseif choice == 9 then
      if changedCodeTest then
        for _, v in ipairs(validResultsTest) do
          v.value = tonumber(changedCodeTest)
          v.name  = changedCodeTest.." - "..getDragonNameFromCode(changedCodeTest)
        end
        gg.setValues(validResultsTest)
        gg.addListItems(validResultsTest)
        gg.toast("Đã khôi phục về rồng đã sửa đổi")
      else
        gg.alert("Không có mã đã thay đổi để khôi phục!")
      end
    elseif choice == 10 then
      gg.clearResults()
      gg.toast("Quay lại menu chính...")
      return false
    end
  end
end

local function pickTestSkillResult()
  local choices = {}
  for i, v in ipairs(validResultsTest) do
    table.insert(choices, v.name)
  end

  local chosenIndex = nil
  repeat
    chosenIndex = gg.choice(choices, nil, "Chọn một mục rồng (chỉ giữ lại một mục).")
    if chosenIndex == nil then
      gg.toast("Tạm dừng lựa chọn. Nhấn biểu tượng GG để tiếp tục.", true)
      waitForResume()
    end
  until chosenIndex ~= nil

  -- Khôi phục giá trị cho tất cả các mục, bao gồm cả mục đã chọn.
  for i, v in ipairs(validResultsTest) do
    gg.setValues({{address = v.address, flags = gg.TYPE_DWORD, value = tonumber(originalCodeTest)}})
    v.value = tonumber(originalCodeTest)
  end

  local chosenItem = validResultsTest[chosenIndex]
  validResultsTest = { chosenItem }
  -- chỉ giữ các mục có giá trị là 1011 hoặc 0; xóa tất cả các mục khác
  do
    local allItems = gg.getListItems()
    local toRemove = {}
    for _, item in ipairs(allItems) do
      if item.value ~= 1011 and item.value ~= 1 and item.value ~= 0 then
        table.insert(toRemove, item)
      end
    end
    if #toRemove > 0 then
      gg.removeListItems(toRemove)
    end
  end

  gg.addListItems(validResultsTest)
  gg.toast("Đã chọn và khôi phục: " .. chosenItem.name)
  return chosenItem
end

-- Hàm testSkill đã sửa đổi tích hợp pickTestSkillResult.
local function testSkill()
  if not globalDragonData then
    globalDragonData = fetchDragonData()
    if not globalDragonData then
      gg.alert("Không thể tải dữ liệu rồng")
      return
    end
  end
  while true do
    validResultsTest = {}
    originalCodeTest = searchDragonCode()
    if not originalCodeTest then break end
    if processMemorySearchTest(originalCodeTest) then
      local chosen = pickTestSkillResult()
      if not chosen then break end  -- Nếu không chọn, thoát về menu chính.
      local needRestart = testSkillMenu()
      if not needRestart then break end
    else
      gg.alert("Không tìm thấy bộ nhớ hợp lệ")
    end
  end
  do
    local allItems = gg.getListItems()
    local toRemove = {}
    for _, item in ipairs(allItems) do
      if item.value ~= 1011 and item.value ~= 1 and item.value ~= 0 then
        table.insert(toRemove, item)
      end
    end
    if #toRemove > 0 then
      gg.removeListItems(toRemove)
    end
  end

  gg.toast("Quay lại menu chính...", true)
  gg.sleep(1500)
end
--------------------------------------------------
-- Chạy Test Skill Mod
--------------------------------------------------
testSkill()
```
