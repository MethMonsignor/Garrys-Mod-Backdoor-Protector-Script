--[[ 
    MODULE: EmporiumRP Backdoor Scanner
    Author: Meth Monsignor
    Description: Scans a specified addon for risky patterns and syntax errors.
    Realm: Server-only
--]]

if not SERVER then return end

print("[EmporiumRP] Backdoor scan module loaded.")

local function scanAddon(addonName)
    local basePath = "addons/" .. addonName .. "/lua"
    if not file.Exists(basePath, "GAME") then
        print("[EmporiumRP Audit] Addon '" .. addonName .. "' not found or has no lua folder.")
        return
    end

    print("[EmporiumRP Audit] Scanning addon '" .. addonName .. "' for risky patterns and syntax errors...")

    local riskyFunctions = {
        "RunString", "CompileString", "http.Fetch", "http.Post",
        "net.Receive", "net.Start", "file.Write", "file.Append",
        "game.ConsoleCommand", "string.char"
    }

    local suspiciousHits = {}
    local foldersToScan = { basePath }

    while #foldersToScan > 0 do
        local current = table.remove(foldersToScan)
        local files, folders = file.Find(current .. "/*", "GAME")

        for _, fileName in ipairs(files) do
            if fileName:sub(-4) == ".lua" then
                local path = current .. "/" .. fileName
                local code = file.Read(path, "GAME")

                if code then
                    for _, func in ipairs(riskyFunctions) do
                        if string.find(code, func, 1, true) then
                            local hit = "[Suspicious] Found '" .. func .. "' in: " .. path
                            print(hit)
                            table.insert(suspiciousHits, hit)
                        end
                    end

                    if string.find(code, "string.char") or string.find(code, "[%+%%^%$%*%?%[%]%(%)%.]") then
                        local hit = "[Heuristic] Obfuscated pattern in: " .. path
                        print(hit)
                        table.insert(suspiciousHits, hit)
                    end

                    local func, err = CompileString(code, path, false)
                    if func == nil and err then
                        local hit = "[Syntax Error] " .. err
                        print(hit)
                        table.insert(suspiciousHits, hit)
                    end
                else
                    print("[Error] Could not read Lua file:", path)
                end
            end
        end

        for _, folderName in ipairs(folders) do
            table.insert(foldersToScan, current .. "/" .. folderName)
        end
    end

    if #suspiciousHits > 0 then
        local logPath = "EmporiumRP_Scan_" .. addonName .. ".txt"
        file.Write(logPath, table.concat(suspiciousHits, "\n"))
        print("[Report Saved] Suspicious patterns logged to /data/" .. logPath)
    else
        print("[Clean] No suspicious patterns or syntax errors found in '" .. addonName .. "'.")
    end
end

-- Manual command: scan a specific addon
concommand.Add("emporiumrp_scan_addon", function(ply, cmd, args)
    if IsValid(ply) then
        ply:PrintMessage(HUD_PRINTCONSOLE, "[EmporiumRP Audit] This command must be run from the server console.")
        return
    end

    local addonName = args[1]
    if not addonName or addonName == "" then
        print("[EmporiumRP Audit] Usage: emporiumrp_scan_addon <addon_name>")
        return
    end

    scanAddon(addonName)
end)

-- Manual command: scan all known addons
concommand.Add("emporiumrp_scan_all", function(ply, cmd, args)
    if IsValid(ply) then
        ply:PrintMessage(HUD_PRINTCONSOLE, "[EmporiumRP Audit] This command must be run from the server console.")
        return
    end

    local addonList = {
        "addon", "addon", "Addon""
    }

    print("[EmporiumRP Audit] Initiating full batch scan of addons...")

    for _, addonName in ipairs(addonList) do
        scanAddon(addonName)
    end

    print("[EmporiumRP Audit] Batch scan complete.")
end)

-- Dispatcher registration
_G.EmporiumRP_Tools = _G.EmporiumRP_Tools or {}
_G.EmporiumRP_Tools["scan_addon"] = {
    name = "Addon Scanner",
    command = "emporiumrp_scan_addon",
    author = "Meth Monsignor",
    description = "Scans a specified addon for risky patterns, obfuscation, and syntax errors.",
    version = "1.3",
    manualOnly = true,
    loaded = true

}
