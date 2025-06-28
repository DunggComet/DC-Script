
-------------------------------------------------------------------------
-------------------------------------------------------------------------
function inputs()
local input = {}
local configFile = gg.EXT_CACHE_DIR .. '/' .. 
gg.getFile():match('') .. 'Rescue.txt'
local data = loadfile(configFile)
if data ~= nil then
data = data()
end
input = gg.prompt({'⬇️Dragons Make⬇️','Dragons Make','⬇️Level⬇️','🔵Level🔵: [1;100]','●Close●'},data,{'checkbox','number','checkbox','number','checkbox','checkbox'})
if input ==nil then
else
gg.saveVariable(input, configFile)
if input[1] then
input[2] = input[2] 
gg.searchNumber('1000~3300;-1;1~100::17', gg.TYPE_DWORD , false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber('1000~3300', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(3000)
gg.editAll(input[2], gg.TYPE_DWORD)
gg.clearResults()
end
if input[3] then
input[4] = input[4] 
gg.searchNumber('1000~3300;-1;1~100::17', gg.TYPE_DWORD , false, gg.SIGN_EQUAL, 0, -1)
gg.refineNumber('1~70', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.getResults(3000)
gg.editAll(input[4], gg.TYPE_DWORD)
gg.clearResults()
end
if input[5] then
L = gg.makeRequest('https://dunggkr.github.io/DC-Script/DC.lua').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
  end
  end
  end

-------------------------------------------------------------------------
gg.setVisible(true)
while true do
if gg.isVisible() then
gg.setVisible(false)
inputs() end end
-------------------------------------------------------------------------
