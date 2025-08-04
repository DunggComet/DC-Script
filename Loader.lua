-- Hide Game Guardian interface at the start and keep it hidden
gg.setVisible(false)

-- 🌐 Fetch login data remotely
local data = gg.makeRequest("https://raw.githubusercontent.com/DunggComet/DC-Script/main/login_data.lua").content
if not data or data == '' then
  gg.alert("📡 Cannot load login data. Check internet connection.")
  return
end

local f, err = load(data)
if not f then
  gg.alert("💥 Invalid login data format: " .. (err or "Unknown error"))
  return
end

-- Execute loaded function and verify result
local status, login = pcall(f)
if not status then
  gg.alert("💥 Failed to execute login data: " .. (login or "Unknown error"))
  return
end

-- Check if login is a function and call it to get the table
if type(login) == "function" then
  status, login = pcall(login)
  if not status or type(login) ~= "table" then
    gg.alert("💥 Login data function did not return a valid table: " .. (login or "Unknown error"))
    return
  end
elseif type(login) ~= "table" then
  gg.alert("💥 Login data is not a valid table")
  return
end

-- 🔍 ID Finder function
local function findUserId()
  gg.toast('Finding UserID...')
  gg.setRanges(gg.REGION_C_ALLOC)
  gg.searchNumber(':Comet', gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)
  gg.searchNumber(':userId', gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)

  local results = gg.getResults(500)
  if #results == 0 then
    gg.alert("No UserID Found!")
    return nil
  end

  for i, v in ipairs(results) do
    local foundText = ""
    for j = 0, 99 do
      local addr = v.address + j
      local data = gg.getValues({{address = addr, flags = gg.TYPE_BYTE}})[1].value
      if data < 0 or data > 255 or data == 0 then break end
      foundText = foundText .. string.char(data)
    end

    local userId, sessionId = foundText:match("userId=(%d+).*sessionId=(%d+)")
    if userId and sessionId then 
      gg.alert("Information Found:\n\n🆔 UserID: " .. userId .. "\n🔑 SessionID: " .. sessionId)
      gg.copyText(userId) -- Copy UserID to clipboard
      gg.toast("📋 UserID copied to clipboard: " .. userId)
      return userId
    end
  end

  gg.alert("No UserID and SessionID Found!")
  return nil
end

-- 🔐 Password prompt loop with menu
while true do
  local menu = gg.choice({
    "▶️ Start Script",
    "🔍 Find UserID",
    "💬 Join Our Discord Community",
    "✖️ Exit Script"
  }, nil, "Select an option:")
  if not menu then
    goto continue
  end

  -- Handle "Exit Script" option
  if menu == 4 then
    gg.clearResults()
    os.exit()
  end

  -- Handle "Join Our Discord Community" option
  if menu == 3 then
    local discordLink = "https://discord.gg/95EkzpEPma"
    gg.copyText(discordLink)
    gg.alert("📋 Discord link copied to clipboard: " .. discordLink)
    gg.toast("📋 Copied Discord link: " .. discordLink)
    goto continue
  end

  -- Handle "Find UserID" option
  if menu == 2 then
    findUserId()
    goto continue
  end

  -- Handle "Start Script" option
  local key
  local passwordMenu = gg.choice({
    "🔑 Manually Enter Password",
    "🤖 Automatically Enter Password"
  }, nil, "Select password entry method:")
  if not passwordMenu then
    goto continue
  end

  if passwordMenu == 1 then
    -- Manual password entry
    local input = gg.prompt({"Enter Password:"}, nil, {"text"})
    if not input or input[1] == nil or input[1] == "" then
      goto continue
    end
    key = input[1]
  else
    -- Automatic password entry (using ID Finder)
    key = findUserId()
    if not key then
      goto continue
    end
  end

  local entry = login[key]
  if not entry or type(entry) ~= "table" then
    gg.alert("⚠️ Invalid Password")
    gg.alert("📣 Please Contact the Owner to Buy!")
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
    goto continue
  end

  local currentTime = os.time()
  if currentTime > expiryTime then
    local message = "❌ Password Expired!\n☄️Contact the Owner to Add Subscription."
    gg.alert(message .. "\n📅 Expired on: " .. formattedExpiry)
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

  -- 🚀 Load script based on version
  local scriptUrl
  if entry.version == "v1" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua"
  elseif entry.version == "v2" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/blah_blah.lua"
  elseif entry.version == "v3" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/blah_blah.lua"
  else
    gg.alert("💥 Invalid version specified")
    goto continue
  end

  local content = gg.makeRequest(scriptUrl).content
  if content and content ~= '' then
    local chunk, err = load(content)
    if chunk then
      local status, err = pcall(chunk)
      if not status then
        gg.alert("💥 Script execution failed: " .. (err or "Unknown error"))
        goto continue
      end
      break -- Exit loop on successful script execution
    else
      gg.alert("💥 SERVER: Invalid script content: " .. (err or "Unknown error"))
      goto continue
    end
  else
    gg.alert("📡 SERVER: Allow Internet Connection...")
    goto continue
  end

  ::continue::
end
