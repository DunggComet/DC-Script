local json = require("json")
local id = gg.prompt({"Enter Device ID:"})[1]
local key = gg.CRYPT("cometlock-" .. id, "SHA256")
print("🔐 Key: " .. key)

-- optional: auto-copy to clipboard or save to a file
