gg.setVisible(true)
fin_busc = 1
exitScript = false -- Flag to control script exit
gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
gg.refineNumber("9288798", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
while true do 
    if gg.isVisible(true) then 
        menuk = 1
        menuk2 = 2  
        gg.setVisible(false) 
    end 
    START = 1 
    function START() 
        menu = gg.choice({
            '🏆 Set Victories',
            '🥀 Set Defeats'
        }, nil, '🌟 Arena Feature by Comet💫💗')
        if menu == 1 then 
            lvl = 1 
            idt = 1011 
            find_ones() 
            exitScript = true
        end
        if menu == 2 then 
            lvl = 999 
            idt = 3011 
            find_ones() 
            exitScript = true
        end
        if menu == nil then 
            noselect() 
        end 
        menuk = -1
    end

    function find_ones()
        if fin_busc == 0 then 
            menuk = -1 
            change_yisus()
        else
            local input1 = gg.prompt({
                "🔎 Dragon 1 Level",
                "🔎 Dragon 2 Level",
                "🌟 Dragon 1 Stars",
                "🌟 Dragon 2 Stars"
            }, {nil, nil, nil, nil}, {'number', 'number', 'number', 'number'})
            if input1 == nil then 
                menuk = -1 
                START()
            elseif input1 ~= nil then
                gg.clearResults()
                gg.searchNumber("1000~5600;"..input1[1]..";"..input1[3]..";1000~5600;"..input1[2]..";"..input1[4].."::133", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
                gg.refineNumber("1000~5600;"..input1[1]..";"..input1[3]..";1000~5600;"..input1[2].."::101", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
                gg.refineNumber("1000~5600;"..input1[1]..";"..input1[3]..";1000~5600::97", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
                gg.refineNumber("1000~5600;"..input1[1]..";"..input1[3].."::37", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
                gg.refineNumber("1000~5600;"..input1[1].."::5", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
                point = gg.getResults(10)
                gg.addListItems(point)
                gg.clearResults()
                fin_busc = 0
                change_yisus()
            end
        end
    end

    function change_yisus()
        local valuesToFreeze = {}
        gg.setValues({
            {address = point[1].address + 0, flags = gg.TYPE_DWORD, value = 1011},
            {address = point[1].address + 0x4, flags = gg.TYPE_DWORD, value = 1},
            {address = point[1].address + 0x60, flags = gg.TYPE_DWORD, value = 1011},
            {address = point[1].address + 0x64, flags = gg.TYPE_DWORD, value = 1},
            {address = point[1].address + 0xC0, flags = gg.TYPE_DWORD, value = idt},
            {address = point[1].address + 0xC4, flags = gg.TYPE_DWORD, value = lvl}
        })
        table.insert(valuesToFreeze, {address = point[1].address + 0, flags = gg.TYPE_DWORD, value = 1011, freeze = true})
        table.insert(valuesToFreeze, {address = point[1].address + 0x4, flags = gg.TYPE_DWORD, value = 1, freeze = true})
        table.insert(valuesToFreeze, {address = point[1].address + 0x60, flags = gg.TYPE_DWORD, value = 1011, freeze = true})
        table.insert(valuesToFreeze, {address = point[1].address + 0x64, flags = gg.TYPE_DWORD, value = 1, freeze = true})
        table.insert(valuesToFreeze, {address = point[1].address + 0xC0, flags = gg.TYPE_DWORD, value = idt, freeze = true})
        table.insert(valuesToFreeze, {address = point[1].address + 0xC4, flags = gg.TYPE_DWORD, value = lvl, freeze = true})

        if #valuesToFreeze > 0 then
            gg.addListItems(valuesToFreeze)
            gg.toast(string.format('✅ Saved %d values to freeze list!', #valuesToFreeze), true)
        else
            gg.alert('⚠️ No values found to freeze!')
        end

        gg.toast('🎉 Battle Arena modification completed!', true)
        gg.sleep(1500)
        gg.toast('💖 Thanks for using my script!', true)
    end

    function noselect()     
        gg.setVisible(false)
    end
    if menuk == 1 then 
        START() 
    end
    if exitScript then 
        break -- Exit the main loop to return control to the calling script
    end
end
