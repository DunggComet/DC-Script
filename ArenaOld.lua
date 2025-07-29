gg.setVisible(true)
fin_busc=1
gg.setRanges(gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS)
gg.refineNumber("9288798", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
while(true) do 
if gg.isVisible(true) then 
menuk = 1
menuk2 = 2  
gg.setVisible(false) 
end 
START = 1 
function START() 
menu = gg.choice({
    '🏆 Set Victories',
    '🥀 Set Defeats',
    '🔓 Unfreeze Values',
    '❌ Exit Script'
}, nil, '🌟 Arena Feature by Comet💫💗\n Old VERSION')
if menu == 1 then lvl=1 idt=1011 find_ones() end
if menu == 2 then lvl=999 idt=3011 find_ones() end
if menu == 3 then 
    gg.setVisible(false)
    local frozenItems = gg.getListItems()
    if #frozenItems > 0 then
        gg.removeListItems(frozenItems)
        gg.toast('✅ All values unfrozen successfully!', true)
    else
        gg.toast('ℹ️ No frozen values found!', true)
    end
end
if menu == 4 then 
    local request = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua')
    if request.content then
        gg.toast('✅ Successfully fetched content!', true)
        local success, result = pcall(load(request.content))
        if success then
            gg.toast('🎉 Script loaded successfully!', true)
        else
            gg.alert('⚠️ Error loading script: ' .. tostring(result))
        end
    else
        gg.alert('⚠️ Failed to fetch content from URL!')
    end
    gg.clearResults()
    os.exit()
end
if menu == nil then noselect() end 
menuk =-1
end

function find_ones()
    if fin_busc==0 then menuk =-1 change_yisus()
    else
        local input1 = gg.prompt({
            "🔎 Dragon 1 Level",
            "🔎 Dragon 2 Level",
            "🌟 Dragon 1 Stars",
            "🌟 Dragon 2 Stars"
        }, {nil, nil, nil, nil}, {'number', 'number', 'number', 'number'})
        if input1==nil then menuk =-1 START()
        elseif input1~=nil then
            gg.clearResults()
            gg.searchNumber("1000~5600;"..input1[1]..";"..input1[3]..";1000~5600;"..input1[2]..";"..input1[4].."::133", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            gg.refineNumber("1000~5600;"..input1[1]..";"..input1[3]..";1000~5600;"..input1[2].."::101", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            gg.refineNumber("1000~5600;"..input1[1]..";"..input1[3]..";1000~5600::97", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            gg.refineNumber("1000~5600;"..input1[1]..";"..input1[3].."::37", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            gg.refineNumber("1000~5600;"..input1[1].."::5", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
            point=gg.getResults(10)
            gg.addListItems(point)
            gg.clearResults()
            fin_busc=0
            change_yisus()
        end
    end
end

function change_yisus()
local valuesToFreeze = {}
gg.setValues({
    {address=point[1].address+0, flags=gg.TYPE_DWORD, value=1011},
    {address=point[1].address+0x4, flags=gg.TYPE_DWORD, value=1},
    {address=point[1].address+0x60, flags=gg.TYPE_DWORD, value=1011},
    {address=point[1].address+0x64, flags=gg.TYPE_DWORD, value=1},
    {address=point[1].address+0xC0, flags=gg.TYPE_DWORD, value=idt},
    {address=point[1].address+0xC4, flags=gg.TYPE_DWORD, value=lvl}
})
table.insert(valuesToFreeze, {address=point[1].address+0, flags=gg.TYPE_DWORD, value=1011, freeze=true})
table.insert(valuesToFreeze, {address=point[1].address+0x4, flags=gg.TYPE_DWORD, value=1, freeze=true})
table.insert(valuesToFreeze, {address=point[1].address+0x60, flags=gg.TYPE_DWORD, value=1011, freeze=true})
table.insert(valuesToFreeze, {address=point[1].address+0x64, flags=gg.TYPE_DWORD, value=1, freeze=true})
table.insert(valuesToFreeze, {address=point[1].address+0xC0, flags=gg.TYPE_DWORD, value=idt, freeze=true})
table.insert(valuesToFreeze, {address=point[1].address+0xC4, flags=gg.TYPE_DWORD, value=lvl, freeze=true})

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
if menuk == 1 then START() end
end

-------------------------------------------------------------------------
gg.setVisible(true)
while true do
if gg.isVisible() then
gg.setVisible(false)
Main() end end
-------------------------------------------------------------------------
