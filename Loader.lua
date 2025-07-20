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

-- 🔐 Password prompt loop
while true do
  gg.setVisible(true)
  local input = gg.prompt({"Enter Password:"}, nil, {"text"})
  if not input or input[1] == nil or input[1] == "" then
    gg.setVisible(false)
    goto continue
  end
  local key = input[1]

  local entry = login[key]
  if not entry or type(entry) ~= "table" then
    gg.alert("⚠ Invalid Password")
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
    local message = entry.expired_message or "❌ Password expired"
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
  gg.alert(entry.message ..
    "\n📅 Expires on: " .. formattedExpiry ..
    string.format("\n⏰ Time left: %d days, %d hours, %d minutes, %d seconds", days, hours, mins, secs) ..
    "\n🕒 Device time: " .. os.date("%d/%m/%Y %H:%M:%S")
  )

  -- 🔔 Toast countdown before script request
  gg.toast(string.format("⏳ Time left: %d days, %d hours, %d minutes, %d seconds", days, hours, mins, secs))

  -- 🚀 Load script
  local content = gg.makeRequest(entry.url).content
  if content and content ~= '' then
    local chunk, err = load(content)
    if chunk then
      local status, err = pcall(chunk)
      if not status then
        gg.alert("💥 Script execution failed: " .. (err or "Unknown error"))
        gg.setVisible(false)
        goto continue
      end
      break -- Exit loop on successful script execution
    else
      gg.alert("💥 SERVER: Invalid script content: " .. (err or "Unknown error"))
      gg.setVisible(false)
      goto continue
    end
  else
    gg.alert("📡 SERVER: Allow Internet Connection...")
    gg.setVisible(false)
    goto continue
  end

  ::continue::
end
