-- Combined Dragon City Ultimate Mod with Test Skill Integration &amp; Revert Paste Feature
gg.setVisible(false)

local path = "/storage/emulated/0/Download/1.8.0.txt"
local oldPath = "/storage/emulated/0/Download/1.7.0.txt"
local file = io.open(path, "r")

if file then
    file:close()
else
    gg.alert("A new update V1.8.0 is available! Please update now!\nNew: 🔵Expand🔵\nCách sử dụng: bật chức năng 🔵Expand all Unlocked🔵 sau đó vào Ancient Portal rồi về để hiệu lực\nRemoved 📙Goals📙 🔵Server Hack🔵", "Update Now")
    
    gg.toast("Updating...")
    gg.searchNumber(":updateversion", gg.TYPE_AUTO)
    gg.sleep(2000)
    
    -- Delete old version file
    os.remove(oldPath)
    
    local newFile = io.open(path, "w")
    if newFile then
        newFile:write("Dungg V1.8.0")
        newFile:close()
        gg.alert("Update successful!")
    else
        gg.alert("Error during update!")
    end
end

gg.setVisible(false)
-------------------------------------------------------------------------
-------------------------------------------------------------------------
local MD5 = gg.makeRequest('').content
function Main()
menu = gg.choice({
'⚔Battle Arena Mod⚔',
'🏟Unmod Battle Arena🏟',
'🏟Quest Mod🏟',
'🏟Recall Dragon🏟',
'⚔Rescue⚔',
'🕹Test/Train Skill Mod🕹',
'🏃‍♂️Event Battle Speed🏃‍♂️',
'Exit'
},nil, 'Dragon City Tools\nScript made by Dungg')
if menu == 1 then DragonCityHack1() end
if menu == 2 then DragonCityHack2() end
if menu == 3 then DragonCityHack3() end
if menu == 4 then DragonCityHack4() end
if menu == 5 then DragonCityHack5() end
if menu == 6 then DragonCityHack6() end
if menu == 7 then DragonCityHack7() end
if menu == 8 then DragonCityHack8() end
if menu ==nil then NoSelect() end
end
function DragonCityHack1()
L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Arena').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end

function DragonCityHack2()
  gg.setVisible(false)
  local frozenItems = gg.getListItems()
  if #frozenItems &gt; 0 then
    gg.removeListItems(frozenItems)
    gg.toast('All values have been unfrozen!')
  else
    gg.toast('No frozen values found!')
  end
end

function DragonCityHack3()
L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Quest').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end

function DragonCityHack4()
L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Recall').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end

function DragonCityHack5()
L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Rescue').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end

function DragonCityHack6()
L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Train%20Skill').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end

function DragonCityHack7()
L = gg.makeRequest('https://raw.githubusercontent.com/DunggKR/DC-Script/main/Folder/Event%20Battle%20Skip').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end

function DragonCityHack8()
os.exit()
end

function NoSelect()
gg.sleep(100)
gg.toast('Script made by Dungg')
end

-------------------------------------------------------------------------
gg.setVisible(true)
while true do
if gg.isVisible() then
gg.setVisible(false)
Main() end end
-------------------------------------------------------------------------
