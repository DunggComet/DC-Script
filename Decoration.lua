
-------------------------------------------------------------------------
-------------------------------------------------------------------------
function inputs()
local input = {}
local configFile = gg.EXT_CACHE_DIR .. '/' .. 
gg.getFile():match('') .. 'decoration.txt'
local data = loadfile(configFile)
if data ~= nil then
  data = data()
end
input = gg.prompt({'📍Move📍','📍Buildings📍','📍Habitat📍( Fixing )','📍Ads📍( SP fixed )','📍Tree of life Move 📍','Close'},data, {'checkbox','checkbox','checkbox','checkbox','checkbox','checkbox'})
if input ==nil then
else

gg.saveVariable(input, configFile)
if input[1] then
L = gg.makeRequest('https://dragoncitytips.com/scripts/Decoration/move_free.php').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end
if input[2] then
L = gg.makeRequest('https://dragoncitytips.com/scripts/Decoration/buldings.php').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end
if input[3] then
L = gg.makeRequest('https://dragoncitytips.com/scripts/Decoration/habitat.php').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end
if input[4] then
end
if input[5] then
gg.setRanges(gg.REGION_C_ALLOC)
gg.setVisible(false)
gg.searchNumber('600;6;68::13', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.setVisible(false)
gg.refineNumber('600', gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
gg.setVisible(false)
gg.getResults(5000)
gg.editAll('390', gg.TYPE_DWORD)
gg.setVisible(false)
gg.clearResults()
end
if input[6] then
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
