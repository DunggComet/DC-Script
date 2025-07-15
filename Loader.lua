-- 🛡️ Passwords and their matching alert & script URL
local Passwords = {
  khoa    = { message = "✅ Hé lô, test script vui vẻ nhé anh zai",    url = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua" },
  NIKA  = { message = "✅ Hello NIKA!",          url = "https://raw.githubusercontent.com/DunggKR/DC-Script/main/nika.lua" },
  TGN   = { message = "✅ TGN detected!",        url = "https://raw.githubusercontent.com/DunggKR/DC-Script/main/tgn.lua" },
  ADMIN = { message = "✅ Admin login granted.", url = "https://raw.githubusercontent.com/DunggKR/DC-Script/main/admin.lua" }
}

-- 🔐 Prompt for password
local input = gg.prompt({"Enter Password:"}, nil, {"text"})
if not input then return end

local key = input[1]
local entry = Passwords[key]

-- ❌ Invalid password
if not entry then
  gg.alert("⚠ Error Password ⚠")
  return
end

-- ✅ Show alert message first
gg.alert(entry.message)

-- 🌐 Make request and try to execute script
local L = gg.makeRequest(entry.url).content

if not L or L == '' then
  gg.alert('📡 SERVER: Allow Internet Connection...')
else
  local f = load(L)
  if f then
    pcall(f)
  else
    gg.alert('💥 SERVER: Invalid script content.')
  end
end
