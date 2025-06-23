-- Dragon City Mod Menu Script
-- Made by Dungg
gg.setVisible(false)

-- Update Checker
local pth, opth = "/storage/emulated/0/Download/1.8.0.txt", "/storage/emulated/0/Download/1.7.0.txt"
local fl = io.open(pth, "r")
if not fl then
  gg.alert("A new update V1.8.0 is available! Please update now!\nNew: 🔵Expand🔵\nCách sử dụng: bật chức năng 🔵Expand all Unlocked🔵 sau đó vào Ancient Portal rồi về để hiệu lực\nRemoved 📙Goals📙 🔵Server Hack🔵", "Update Now")
  gg.toast("Updating...")
  gg.searchNumber(":updateversion", gg.TYPE_AUTO)
  gg.sleep(2000)
  os.remove(opth)
  local nF = io.open(pth, "w")
  if nF then
    nF:write("Dungg V1.8.0")
    nF:close()
    gg.alert("Update successful!")
  else
    gg.alert("Error during update!")
  end
else
  fl:close()
end

gg.setVisible(false)

-- Main menu handler
local MD5 = gg.makeRequest('').content
function Main()
  local opt = gg.choice({
    '⚔Battle Arena Mod⚔',
    '🏟Unmod Battle Arena🏟',
    '🏟Quest Mod🏟',
    '🏟Recall Dragon🏟',
    '⚔Rescue⚔',
    '🕹Test/Train Skill Mod🕹',
    '🔵Event Battle Speed🔵',
    '🔵Exit🔵'
  }, nil, 'Dragon City Tools\ncoded by Dungg DC')

  if opt == 1 then DragonCityHack1()
  elseif opt == 2 then DragonCityHack2()
  elseif opt == 3 then DragonCityHack3()
  elseif opt == 4 then DragonCityHack4()
  elseif opt == 5 then DragonCityHack5()
  elseif opt == 6 then DragonCityHack6()
  elseif opt == 7 then DragonCityHack7()
  elseif opt == 8 then DragonCityHack8()
  elseif opt == nil then NoSelect()
  end
end

-- Feature handlers
function DragonCityHack1()
  local L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Arena').content
  if not L then gg.alert('SERVER: Allow Internet Connection...') else pcall(load(L)) end
end

function DragonCityHack2()
  gg.setVisible(false)
  local frz = gg.getListItems()
  if #frz > 0 then
    gg.removeListItems(frz)
    gg.toast('All values have been unfrozen!')
  else
    gg.toast('No frozen values found!')
  end
end

function DragonCityHack3()
  local L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Quest').content
  if not L then gg.alert('SERVER: Allow Internet Connection...') else pcall(load(L)) end
end

function DragonCityHack4()
  local L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Recall').content
  if not L then gg.alert('SERVER: Allow Internet Connection...') else pcall(load(L)) end
end

function DragonCityHack5()
  local L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Rescue').content
  if not L then gg.alert('SERVER: Allow Internet Connection...') else pcall(load(L)) end
end

function DragonCityHack6()
  local L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Train%20Skill').content
  if not L then gg.alert('SERVER: Allow Internet Connection...') else pcall(load(L)) end
end

function DragonCityHack7()
  local L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Event%20Battle%20Skip').content
  if not L then gg.alert('SERVER: Allow Internet Connection...') else pcall(load(L)) end
end

function DragonCityHack8()
  os.exit()
end

function NoSelect()
  gg.sleep(100)
  gg.toast('coded by Dungg DC')
end

-- Loop main
gg.setVisible(true)
while true do
  if gg.isVisible() then
    gg.setVisible(false)
    Main()
  end
end
