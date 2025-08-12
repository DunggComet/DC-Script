-- Combined Dragon City Ultimate Mod with Test Skill Integration & Revert Paste Feature
gg.setVisible(false)

local path = "/storage/emulated/0/Download/1.9.txt"
local oldPath = "/storage/emulated/0/Download/1.8.txt"
local file = io.open(path, "r")

if file then
    file:close()
else
    gg.alert("🚀 A new update (Version 1.9) is available! Please install it now!\n✨ What's New:\n-New Category: 🏁 Event Race \n-New Feature: Speedup Hatching & Breeding Terra\n+ Moved Accelerated Event Battles to Event Race\nNote: Please install Dragon City to version 25.10.1 before using!", "Update")

    gg.toast("Installing update...")
    gg.searchNumber(":updateversion", gg.TYPE_AUTO)
    gg.sleep(2000)

    -- Remove old version file
    os.remove(oldPath)

    local newFile = io.open(path, "w")
    if newFile then
        newFile:write("Version 1.9")
        newFile:close()
        gg.alert("Update installed successfully!")
    else
        gg.alert("An error occurred during the update process.")
    end
end

gg.clearResults()
gg.setVisible(false)
-------------------------------------------------------------------------
-------------------------------------------------------------------------
local MD5 = gg.makeRequest('').content
function Main()
    menu = gg.choice({
        '🗡️ Mod Quest ( Cày Rank Rồng )',
        '➡️ Test & Train Skill Rồng',
        '⚡ Speedhack",
        '💬 Tham Gia Server Discord'
    }, nil, '✨Dragon City Script\n💫Script Tạo Bởi Comet 💗')
    if menu == 1 then Questv1() end
    if menu == 2 then TrainSkill() end
    if menu == 3 then Speedhack() end
    if menu == 4 then Discord() end
    if menu == nil then NoSelect() end
end

function Questv1()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/VN/Khanh/Questv1.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function TrainSkill()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/VN/Khanh/TrainSkill.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function Discord()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/Help.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function Speedhack()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/VN/Khanh/SpeedHack.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function NoSelect()
    gg.sleep(100)
    gg.toast('Script Made By Comet 💫💗')
end

-------------------------------------------------------------------------
        gg.setVisible(true)
        while true do
        if gg.isVisible() then
        gg.setVisible(false)
        Main()
    end
end
-------------------------------------------------------------------------
