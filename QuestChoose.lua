function Main()
    menu = gg.choice({
        '🗡️ Quest ( v2 )',
        '🗡️ Quest ( v1 )',
        '❌ Exit Quest'
    }, nil, '✨Quest Script Made By Comet 💗\nChoose Your Version:')
    if menu == 1 then QuestNew() end
    if menu == 2 then QuestOld() end
    if menu == 3 then Exit() end
    if menu == nil then NoSelect() end
end

function QuestNew()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/Quest.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function QuestOld()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/QuestOLD.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function Exit()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua').content
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
