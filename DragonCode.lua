gg.setVisible(false)

-- Full list of dragons (ID - Name format)
local dragons = {
  "9900 - Autumn Dragon",
  "3381 - High Cloaked Critical",
  "3376 - Core Critical Dragon",
  "3375 - SML Dragon",
  "3374 - Chloro Critical Dragon",
  -- ... add more dragons as needed ...
  "1290 - Sensei Dragon",
  "1289 - Joseon Dragon",
  "1288 - Animation Dragon",
  "1122 - Hydra Dragon"
}

-- Ask user for search input
local input = gg.prompt({"Nhập tên hoặc ID rồng để tìm:"}, nil, {"text"})

if not input then
  gg.alert("Đã hủy.")
  os.exit()
end

local keyword = string.lower(input[1])

-- Filter matching dragons
local matches = {}
for i = 1, #dragons do
  if string.find(string.lower(dragons[i]), keyword) then
    table.insert(matches, dragons[i])
  end
end

-- Display results
if #matches == 0 then
  gg.alert("Không tìm thấy rồng nào với từ khóa '" .. keyword .. "'")
else
  local index = gg.choice(matches, nil, "Kết quả tìm kiếm:")
  if index then
    gg.alert("Bạn đã chọn:\n" .. matches[index])
  else
    gg.alert("Không có rồng nào được chọn.")
  end
end
