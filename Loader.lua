-- 🛡️ Passwords with expiry datetime (per user)
local Passwords = {
  khoa = {
    message = "✅ Thôi thoát script đi, chơi bẩn làm gì. Tắt script chơi công bằng đi=))",
    url = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua",
    expiry = { year = 2025, month = 8, day = 1, hour = 0, min = 0, sec = 0 }
  },
  NIKA = {
    message = "✅ Hello NIKA!",
    url = "https://raw.githubusercontent.com/DunggKR/DC-Script/main/nika.lua",
    expiry = { year = 2025, month = 7, day = 20, hour = 0, min = 0, sec = 0 }
  }
}

-- 🔐 Prompt for password
local input = gg.prompt({"Enter Password:"}, nil, {"text"})
if not input then return end
local key = input[1]
local entry = Passwords[key]
if not entry then
  gg.alert("⚠ Error Password ⚠")
  return
end

-- 🕒 Use device local time
local now = os.date("*t")
local currentTime = os.time({
  year = now.year, month = now.month, day = now.day,
  hour = now.hour, min = now.min, sec = now.sec
})

-- 🎯 Expiry time
local exp = entry.expiry
local expiryTime = os.time({
  year = exp.year, month = exp.month, day = exp.day,
  hour = exp.hour or 0, min = exp.min or 0, sec = exp.sec or 0
})

-- ⏱️ Countdown
local remaining = expiryTime - currentTime
if remaining <= 0 then
  gg.alert("❌ Script expired on " ..
    string.format("%02d/%02d/%04d %02d:%02d:%02d", exp.day, exp.month, exp.year, exp.hour, exp.min, exp.sec) ..
    "\n🕒 Device time: " .. os.date("%d/%m/%Y %H:%M:%S"))
  os.exit()
end

-- 🔢 Breakdown into D:H:M:S (force integer strings, no .0)
local days = tostring(math.floor(remaining / 86400))
local hours = tostring(math.floor((remaining % 86400) / 3600))
local mins = tostring(math.floor((remaining % 3600) / 60))
local secs = tostring(math.floor(remaining % 60))

-- ✅ Show message and countdown
gg.alert(entry.message ..
  "\n⏳ Expires on: " .. string.format("%02d/%02d/%04d %02d:%02d:%02d", exp.day, exp.month, exp.year, exp.hour, exp.min, exp.sec) ..
  "\n⏰ Time left: " .. days .. " days, " .. hours .. " hours, " .. mins .. " minutes, " .. secs .. " seconds" ..
  "\n🕒 Device time: " .. os.date("%d/%m/%Y %H:%M:%S")
)

-- 🚀 Load and run script
local L = gg.makeRequest(entry.url).content
if not L or L == '' then
  gg.alert("📡 SERVER: Allow Internet Connection...")
else
  local f = load(L)
  if f then
    pcall(f)
  else
    gg.alert("💥 SERVER: Invalid script content.")
  end
end
