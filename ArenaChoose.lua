function Main()
    menu = gg.choice({
        '⚔️ Arena ( New )',
        '⚔️ Arena ( Old )',
        '❌ Exit Arena'
    }, nil, '✨Arena Script Made By Comet 💗\nChoose Your Version:')
    if menu == 1 then ArenaNew() end
    if menu == 2 then ArenaOld() end
    if menu == 3 then Exit() end
    if menu == nil then NoSelect() end
end

function ArenaNew()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/Arena.lua').content
    if not L then gg.alert('SERVER: Allow Internet Connection...') else
        pcall(load(L)) end
end

function ArenaOld()
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/ArenaOld.lua').content
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
