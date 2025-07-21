L = gg.makeRequest('https://raw.githubusercontent.com/DunggComet/DC-Script/main/Loader.lua').content
if not L then gg.alert('SERVER: Allow Internet Connection...') else
pcall(load(L)) end
end
