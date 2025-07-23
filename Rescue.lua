-------------------------------------------------------------------------
-------------------------------------------------------------------------
  gg.setVisible(true)
  local menu = gg.choice(
    {"🐉 Change Dragon to Terra", "📊 Change Level to 1", "✖️ Close"},
    nil,
    "Select an option:"
  )

  if menu == nil then
    gg.setVisible(false)
    return
  end

  gg.saveVariable({[1]=menu==1, [2]=menu==2, [3]=menu==3}, configFile)

  if menu == 1 then
    gg.searchNumber('1000~3300;-1;1~100::17', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber('1000~3300', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(3000)
    gg.editAll('1011', gg.TYPE_DWORD)
    gg.clearResults()
  elseif menu == 2 then
    gg.searchNumber('1000~3300;-1;1~100::17', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber('1~70', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    gg.getResults(3000)
    gg.editAll('1', gg.TYPE_DWORD)
    gg.clearResults()
  elseif menu == 3 then
    L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/DC.lua').content
    if not L then
      gg.alert('SERVER: Allow Internet Connection...')
    else
      pcall(load(L))
    end
  end
end

-------------------------------------------------------------------------
gg.setVisible(true)
while true do
  if gg.isVisible() then
    gg.setVisible(false)
    inputs()
  end
end
-------------------------------------------------------------------------
