-- 🌐 Fetch login data remotely
local data = gg.makeRequest("https://raw.githubusercontent.com/DunggComet/DC-Script/main/login_data.lua").content
if not data or data == '' then
  gg.alert("📡 Cannot load login data. Check internet connection.")
  return
end

local f = load(data)
if not f then
  gg.alert("💥 Invalid login data format.")
  return
end

local login = f()  -- returns table

-- 🔐 Prompt for password
local input = gg.prompt({"Enter Password:"}, nil, {"text"})
if not input then return end
local key = input[1]

local entry = login[key]
if not entry then
  gg.alert("⚠ Error Password ⚠")
  return
end

-- 📆 Parse DDMMYYYY
local function parseDate(ddmmyyyy)
  local d, m, y = tonumber(ddmmyyyy:sub(1,2)), tonumber(ddmmyyyy:sub(3,4)), tonumber(ddmmyyyy:sub(5,8))
  return os.time({year=y, month=m, day=d, hour=0})
end

local expiryTime = parseDate(entry.expiry)
local currentTime = os.time()
if currentTime > expiryTime then
  gg.alert(entry.expired_message or ("❌ Script expired on: " .. entry.expiry))
  os.exit()
end

-- 🕒 Countdown (no .0)
local remaining = expiryTime - currentTime
local days = math.floor(remaining / 86400)
local hours = math.floor((remaining % 86400) / 3600)
local mins = math.floor((remaining % 3600) / 60)
local secs = math.floor(remaining % 60)

-- ✅ Show alert
gg.alert(entry.message ..
  "\n📅 Expires on: " .. entry.expiry ..
  string.format("\n⏰ Time left: %d days, %d hours, %d minutes, %d seconds", days, hours, mins, secs) ..
  "\n🕒 Device time: " .. os.date("%d/%m/%Y %H:%M:%S")
)

-- 🔔 Toast countdown before script request
gg.toast(string.format("⏳ Time left: %d days, %d hours, %d minutes, %d seconds", days, hours, mins, secs))

-- 🚀 Load script
local content = gg.makeRequest(entry.url).content
if content and content ~= '' then
  local chunk = load(content)
  if chunk then
    pcall(chunk)
  else
    gg.alert("💥 SERVER: Invalid script content.")
  end
else
  gg.alert("📡 SERVER: Allow Internet Connection...")
end
