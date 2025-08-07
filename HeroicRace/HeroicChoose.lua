function Main()
    menu = gg.choice({
        '🏁 Accelerated Event Battles',
        '⚡ Speedup Hatching & Breeding Terra',
        '❌ Return To Main Menu'
    }, nil, '✨ Heroic Script Made By Comet 💗\nChoose Feature:')
    if menu == 1 then Skip() end
    if menu == 2 then Speed() end
    if menu == 3 then Exit() end
    if menu == nil then NoSelect() end
end

function Skip()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/HeroicRace/EventBattleSkip.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function Speed()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/HeroicRace/Breed_Hatch_Terra.lua').content
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
