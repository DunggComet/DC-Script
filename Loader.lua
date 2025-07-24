-- 🌐 Fetch login data remotely
local data = gg.makeRequest("https://raw.githubusercontent.com/DunggComet/DC-Script/main/login_data.lua").content
if not data or data == '' then
  gg.alert("📡 Cannot load login data. Check internet connection.")
  gg.setVisible(false)
  return
end

local f, err = load(data)
if not f then
  gg.alert("💥 Invalid login data format: " .. (err or "Unknown error"))
  gg.setVisible(false)
  return
end

-- Execute loaded function and verify result
local status, login = pcall(f)
if not status then
  gg.alert("💥 Failed to execute login data: " .. (login or "Unknown error"))
  gg.setVisible(false)
  return
end

-- Check if login is a function and call it to get the table
if type(login) == "function" then
  status, login = pcall(login)
  if not status or type(login) ~= "table" then
    gg.alert("💥 Login data function did not return a valid table: " .. (login or "Unknown error"))
    gg.setVisible(false)
    return
  end
elseif type(login) ~= "table" then
  gg.alert("💥 Login data is not a valid table")
  gg.setVisible(false)
  return
end

-- 🔐 Password prompt loop with menu
while true do
  gg.setVisible(true)
  local menu = gg.choice({"▶️ Start Script", "💬 Join Our Discord Community", "✖️ Exit Script"}, nil, "Select an option:")
  if not menu then
    gg.setVisible(false)
    goto continue
  end

  -- Handle "Exit Script" option
  if menu == 3 then
    gg.setVisible(false)
    gg.clearResults()
    os.exit()
  end

  -- Handle "Join Our Discord Community" option
  if menu == 2 then
    local discordLink = "https://discord.gg/e7UwExHAKS"
    gg.copyText(discordLink)
    gg.alert("📋 Discord link copied to clipboard: " .. discordLink)
    gg.toast("📋 Copied Discord link: " .. discordLink)
    gg.setVisible(false)
    goto continue
  end

  -- Handle "Start Script" option
  local input = gg.prompt({"Enter Password:"}, nil, {"text"})
  if not input or input[1] == nil or input[1] == "" then
    gg.setVisible(false)
    goto continue
  end
  local key = input[1]

  local entry = login[key]
  if not entry or type(entry) ~= "table" then
    gg.alert("⚠️ Invalid Password")
    gg.alert("📣 Join our Discord server to get script's subscription!")
    gg.setVisible(false)
    goto continue
  end

  -- 📆 Parse DDMMYYYY
  local function parseDate(ddmmyyyy)
    if not ddmmyyyy or #ddmmyyyy ~= 8 then
      return nil, nil
    end
    local d, m, y = tonumber(ddmmyyyy:sub(1,2)), tonumber(ddmmyyyy:sub(3,4)), tonumber(ddmmyyyy:sub(5,8))
    if not d or not m or not y then
      return nil, nil
    end
    -- Return both os.time and formatted date
    return os.time({year=y, month=m, day=d, hour=0}), string.format("%02d/%02d/%04d", d, m, y)
  end

  local expiryTime, formattedExpiry = parseDate(entry.expiry)
  if not expiryTime then
    gg.alert("💥 Invalid expiry date format")
    gg.setVisible(false)
    goto continue
  end

  local currentTime = os.time()
  if currentTime > expiryTime then
    local message = entry.expired_message or "❌ Password Expired!\n☄️Contact the Owner to Add Subscription."
    gg.alert(message .. "\n📅 Expired on: " .. formattedExpiry)
    gg.setVisible(false)
    goto continue
 end

  -- 🕒 Countdown (no .0)
  local remaining = expiryTime - currentTime
  local days = math.floor(remaining / 86400)
  local hours = math.floor((remaining % 86400) / 3600)
  local mins = math.floor((remaining % 3600) / 60)
  local secs = math.floor(remaining % 60)

  -- ✅ Show alert
  gg.alert("✅ Success!\n🔑 Key: " .. key ..
    "\n📅 Expires on: " .. formattedExpiry ..
    string.format("\n⏰ Time left: %d days, %d hours, %d minutes, %d seconds", days, hours, mins, secs) ..
    "\n🕒 Current time: " .. os.date("%d/%m/%Y %H:%M:%S")
  )

  -- 🔔 Toast countdown before script request
  gg.toast(string.format("⏳ Time left: %d days, %d hours, %d minutes, %d seconds", days, hours, mins, secs))

  -- 🚀 Load script
L = gg.makeRequest(entry.url).content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
 end
end
