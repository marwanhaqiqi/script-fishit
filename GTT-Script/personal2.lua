-- ============================================================
--  Forky Personal Fish Notifier
--  Hanya notifikasi ikan milik akun sendiri
-- ============================================================

print("[ForkyPersonal] 1 - script mulai")

local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local TextChatService   = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

-- ============================================================
--  CONFIGURATION
-- ============================================================

local WEBHOOK_FISH  = "https://discordapp.com/api/webhooks/1545624769381011566/QZ89-YpG0XdfKiz2DGnO9X5yvHV3SHdqVYhy4ghHLRjGlRrBeumbJvi7tKKbLdJJWvVH"
local PROXY         = "https://weyyy-proxy.gallungmarwan147.workers.dev"
local SCRIPT_ACTIVE = false

local FISH_IDENTITY = {
    name   = "ForkyHUB — Secret Fish",
    avatar = "https://www.image2url.com/r2/default/images/1777666815405-eb5a3d95-9946-4914-b8aa-985e8f672557.png",
}

-- ============================================================
--  DATABASE
-- ============================================================

local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Phantom Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armor Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale",
    "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark",
    "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark",
    "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan",
    "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale",
    "Rainbow Comet Shark", "Love Nessie", "Broken Heart Nessie",
    "Mutant Runic Koi", "Ketupat Whale", "Cosmic Mutant Shark", "Strawberry Orca",
    "Bonemaw Tyrant", "Deepsea Monster Axolotl", "Blocky Lochness Monster", "Aurelion",
    "Runic Enchant Stone", "Frogalloon", "Coral Whale", "Flame Tyrant", "Withering Core",
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane",
    "Cerulean Dragon", "Machodon", "Scorching Veinmaw", "Crystalline Behemoth",
    "Frostmoon Whale", "Crystal Goliath", "Eggy Enchant Stone", "Dark Megalodon", "Elemental Tempestray",
    "Glacial Serpent", "Caustic Maw", "Coral Reaper", "Sunken Hadalith", "Trench Warden",
    "Caeruleum Razerback", "Two-headed shark", "Ragnarex", "Colossal Shipwreck Crab",
    "Astrelle", "Moonwake Ray", "Astralune", "Starglass Guardian", "Pelagon",
    "Crimson Dreadtusk", "Riftborn Arowana", "Overlord Hydra", "Elemental Hydra", "Wintertusk Mammofin",
    "Stormhell Brute", "Pyrocoil", "Ashen Kingfish", "Tribunal Withering Core", "Everbloom", "Mr Money Bags",
    "Velobyte", "ShellShock X", "Cenobyte.EXE", "Jellybeam", "GigaByte", "Spiritborn Axolotl", "SweetTooth Gourdling", "Mawsoleum",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane", "Cerulean Dragon", "Crystalline Behemoth",
    "Trench Warden", "Ragnarex", "Astralune", "Crimson Dreadtusk",
    "Overlord Hydra", "Elemental Hydra", "Everbloom", "Cenobyte.EXE", "Mawsoleum",
}

local MutasiList = {
    "Noob", "Fairy Dust", "Holographic", "Gemstone", "Fire", "Color Burn", "Frozen",
    "Galaxy", "BloodMoon", "Binary", "Lightning", "Disco", "Festive", "Radioactive", "Moon Fragment",
    "Abyssal", "Cosmic", "Equinox", "Glitch", "Aurora", "Midnight", "Elemental", "Solar", "8-Bit", "Invasion", "Haunted",
}

local MutasiFalsePositiveSpecies = {
    "abyssal maw angler",
    "aurora grouper",
    "aurora starfish",
    "aurora narwhal",
    "aurora manatee",
    "aurora butterfly fish",
    "midnight stars squid",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo", "Blossom Jelly", "Bioluminescent Octopus",
}

local FishChanceData = {
    ["Crystal Crab"]              = "1 in 750K",
    ["Orca"]                      = "1 in 1.5M",
    ["Zombie Shark"]              = "1 in 250K",
    ["Zombie Megalodon"]          = "1 in 4M",
    ["Phantom Dead Zombie Shark"] = "1 in 500K",
    ["Blob Shark"]                = "1 in 250K",
    ["Ghost Shark"]               = "1 in 500K",
    ["Skeleton Narwhal"]          = "1 in 600K",
    ["Ghost Worm Fish"]           = "1 in 1M",
    ["Worm Fish"]                 = "1 in 3M",
    ["Megalodon"]                 = "1 in 4M",
    ["1x1x1x1 Comet Shark"]       = "1 in 4M",
    ["Bloodmoon Whale"]           = "1 in 5M",
    ["Lochness Monster"]          = "1 in 3M",
    ["Monster Shark"]             = "1 in 2.5M",
    ["Eerie Shark"]               = "1 in 250K",
    ["Great Whale"]               = "1 in 900K",
    ["Frostborn Shark"]           = "1 in 500K",
    ["Thin Armor Shark"]          = "1 in 300K",
    ["Scare"]                     = "1 in 3M",
    ["Queen Crab"]                = "1 in 800K",
    ["King Crab"]                 = "1 in 1.2M",
    ["Cryoshade Glider"]          = "1 in 450K",
    ["Panther Eel"]               = "1 in 750K",
    ["Giant Squid"]               = "1 in 800K",
    ["Depthseeker Ray"]           = "1 in 1.2M",
    ["Robot Kraken"]              = "1 in 3.5M",
    ["Mosasaur Shark"]            = "1 in 800K",
    ["King Jelly"]                = "1 in 1.5M",
    ["Bone Whale"]                = "1 in 2M",
    ["Elshark Gran Maja"]         = "1 in 4M",
    ["Elpirate Gran Maja"]        = "1 in 4M",
    ["ElRetro Gran Maja"]         = "1 in 4M",
    ["Ancient Whale"]             = "1 in 2.75M",
    ["Gladiator Shark"]           = "1 in 1M",
    ["Ancient Lochness Monster"]  = "1 in 3M",
    ["Talon Serpent"]             = "1 in 3M",
    ["Hacker Shark"]              = "1 in 2M",
    ["Strawberry Choc Megalodon"] = "1 in 4M",
    ["Krampus Shark"]             = "1 in 1M",
    ["Emerald Winter Whale"]      = "1 in 1.5M",
    ["Winter Frost Shark"]        = "1 in 3M",
    ["Icebreaker Whale"]          = "1 in 4M",
    ["Cursed Kraken"]             = "1 in 3M",
    ["Pirate Megalodon"]          = "1 in 4M",
    ["Leviathan"]                 = "1 in 5M",
    ["Viridis Lurker"]            = "1 in 1.4M",
    ["Ancient Magma Whale"]       = "1 in 5M",
    ["Mutant Runic Koi"]          = "1 in ??",
    ["Cosmic Mutant Shark"]       = "1 in 2M",
    ["Strawberry Orca"]           = "1 in 3M",
    ["Bonemaw Tyrant"]            = "1 in 2.5M",
    ["Rainbow Comet Shark"]       = "1 in ??",
    ["Love Nessie"]               = "1 in ??",
    ["Broken Heart Nessie"]       = "1 in ??",
    ["Sea Eater"]                 = "1 in 25M",
    ["Thunderzilla"]              = "1 in 30M",
    ["Iridesca"]                  = "1 in 25M",
    ["Eggy Enchant Stone"]        = "1 in 100K",
    ["Deepsea Monster Axolotl"]   = "1 in 2M",
    ["Blocky Lochness Monster"]   = "1 in 3M",
    ["Frostbite Leviathan"]       = "1 in 12M",
    ["Aurelion"]                  = "1 in 3M",
    ["Runic Enchant Stone"]       = "1 in 700K",
    ["Frogalloon"]                = "1 in 1.5M",
    ["Fluorivane"]                = "1 in 15M",
    ["Coral Whale"]               = "1 in 2M",
    ["Flame Tyrant"]              = "1 in 5M",
    ["Cerulean Dragon"]           = "1 in 25M",
    ["Withering Core"]            = "1 in 3M",
    ["Machodon"]                  = "1 in 10M",
    ["Crystalline Behemoth"]      = "1 in 20M",
    ["Frostmoon Whale"]           = "1 in 5M",
    ["Crystal Goliath"]           = "1 in 3M",
    ["Ketupat Whale"]             = "1 in ??",
    ["Scorching Veinmaw"]         = "1 in 5M",
    ["Elemental Tempestray"]      = "1 in 1M",
    ["Dark Megalodon"]            = "1 in 8M",
    ["Glacial Serpent"]           = "1 in 6M",
    ["Caustic Maw"]               = "1 in 4M",
    ["Coral Reaper"]              = "1 in 6M",
    ["Sunken Hadalith"]           = "1 in ??",
    ["Trench Warden"]             = "1 in 15M",
    ["Caeruleum Razerback"]       = "1 in 3M",
    ["Two-headed shark"]          = "1 in 3M",
    ["Ragnarex"]                  = "1 in 35M",
    ["Colossal Shipwreck Crab"]   = "1 in 5M",
    ["Astrelle"]                  = "1 in 6M",
    ["Moonwake Ray"]              = "1 in 5M",
    ["Astralune"]                 = "1 in 20M",
    ["Starglass Guardian"]        = "1 in 3M",
    ["Pelagon"]                   = "1 in 4.5M",
    ["Riftborn Arowana"]          = "1 in 4.5M",
    ["Crimson Dreadtusk"]         = "1 in 20M",
    ["Overlord Hydra"]            = "1 in 45M",
    ["Elemental Hydra"]           = "1 in 40M",
    ["Wintertusk Mammofin"]       = "1 in 4M",
    ["Stormhell Brute"]           = "1 in 4M",
    ["Pyrocoil"]                  = "1 in 4M",
    ["Ashen Kingfish"]            = "1 in 3.5M",
    ["Tribunal Withering Core"]   = "1 in 5M",
    ["Mr Money Bags"]             = "1 in 4M",
    ["Everbloom"]                 = "1 in 20M",
    ["Velobyte"]                  = "1 in 5M",
    ["ShellShock X"]              = "1 in 3.5M",
    ["Cenobyte.EXE"]              = "1 in 25M",
    ["Jellybeam"]                 = "1 in 4M",
    ["GigaByte"]                  = "1 in 4.5M",
    ["Spiritborn Axolotl"]        = "1 in 4M",
    ["SweetTooth Gourdling"]      = "1 in 3M",
    ["Mawsoleum"]                 = "1 in 20M",
}

local NP = "https://raw.githubusercontent.com/marwanhaqiqi/gtt-script/main/image-fish/"

local FishImageURL = {
    ["Frostborn Shark"]          = NP .. "frosbon.png",
    ["Crystalline Behemoth"]     = NP .. "crystalinebehemoth.png",
    ["Crystal Goliath"]          = NP .. "crystalgozila.png",
    ["Elemental Tempestray"]     = NP .. "elementaltempestray.png",
    ["Dark Megalodon"]           = NP .. "darkmegalodon.png",
    ["Withering Core"]           = NP .. "wtr.png",
    ["Flame Tyrant"]             = NP .. "flametyrant.png",
    ["Scorching Veinmaw"]        = NP .. "scorching.png",
    ["King Crab"]                = NP .. "kingcrab.png",
    ["Queen Crab"]               = NP .. "queencrab.png",
    ["Panther Eel"]              = NP .. "panthereel.png",
    ["Cryoshade Glider"]         = NP .. "cryoshade.png",
    ["Giant Squid"]              = NP .. "giantsquid.png",
    ["Depthseeker Ray"]          = NP .. "depthseekerray.png",
    ["Ghost Shark"]              = NP .. "ghostshark.png",
    ["Skeleton Narwhal"]         = NP .. "skeletonnarwhale.png",
    ["Blob Shark"]               = NP .. "blobshark.png",
    ["Worm Fish"]                = NP .. "wormfish.png",
    ["Cosmic Mutant Shark"]      = NP .. "cosmicmutanshark.png",
    ["Megalodon"]                = NP .. "megalodon.png",
    ["Bloodmoon Whale"]          = NP .. "bloodmoonwhale.png",
    ["Frostmoon Whale"]          = NP .. "frostmoonwhale.png",
    ["Thunderzilla"]             = NP .. "thunderzilla.png",
    ["Thin Armor Shark"]         = NP .. "armorshark.png",
    ["Scare"]                    = NP .. "scare.png",
    ["Lochness Monster"]         = NP .. "lochneskohana.png",
    ["Ancient Magma Whale"]      = NP .. "magmawhale.png",
    ["Crystal Crab"]             = NP .. "crystalcrab.png",
    ["Orca"]                     = NP .. "orca.png",
    ["Eerie Shark"]              = NP .. "eirishark.png",
    ["Monster Shark"]            = NP .. "monstershark.png",
    ["Runic Enchant Stone"]      = NP .. "runic.png",
    ["Bonemaw Tyrant"]           = NP .. "bonemawtyrant.png",
    ["Mutant Runic Koi"]         = NP .. "koiunderwater.png",
    ["Deepsea Monster Axolotl"]  = NP .. "deepseamonster.png",
    ["Fluorivane"]               = NP .. "fluorivane.png",
    ["Sea Eater"]                = NP .. "seaeater.png",
    ["Pirate Megalodon"]         = NP .. "megapirate.png",
    ["Elpirate Gran Maja"]       = NP .. "majapirate.png",
    ["Cursed Kraken"]            = NP .. "cursedkraken.png",
    ["Mosasaur Shark"]           = NP .. "mosasaur.png",
    ["King Jelly"]               = NP .. "kingjelly.png",
    ["Gladiator Shark"]          = NP .. "gladiatorshark.png",
    ["Ancient Lochness Monster"] = NP .. "dinoruin.png",
    ["Elshark Gran Maja"]        = NP .. "elmaja.png",
    ["Viridis Lurker"]           = NP .. "viridislurker.png",
    ["Bone Whale"]               = NP .. "bonewhale.png",
    ["Ancient Whale"]            = NP .. "ancientwhale.png",
    ["Great Whale"]              = NP .. "greatwhale.png",
    ["Coral Whale"]              = NP .. "coralwhale.png",
    ["Leviathan"]                = NP .. "leviathan.png",
    ["Ruby"]                     = NP .. "ruby.png",
    ["Glacial Serpent"]          = NP .. "glacial.png",
    ["Caustic Maw"]              = NP .. "causticmaw.png",
    ["Coral Reaper"]             = NP .. "coralreaper.png",
    ["Trench Warden"]            = NP .. "trenchwarden.png",
    ["Caeruleum Razerback"]      = NP .. "caeruleum.png",
    ["Two-headed shark"]         = NP .. "twoheadshark.png",
    ["Ragnarex"]                 = NP .. "ragnarex.png",
    ["Colossal Shipwreck Crab"]  = NP .. "colossal.png",
    ["Pelagon"]                  = NP .. "pelagon.png",
    ["Riftborn Arowana"]         = NP .. "riftborn.png",
    ["Crimson Dreadtusk"]        = NP .. "cyrmsondread.png",
    ["Wintertusk Mammofin"]      = NP .. "blizzar.png",
    ["Stormhell Brute"]          = NP .. "stormhell.png",
    ["Pyrocoil"]                 = NP .. "pyrocoil.png",
    ["Elemental Hydra"]          = NP .. "elementalhydra.png",
    ["Overlord Hydra"]           = NP .. "overlordhydra.png",
    ["Ashen Kingfish"]           = NP .. "ashenkingfish.png",
    ["Tribunal Withering Core"]  = NP .. "twc.png",
    ["Mr Money Bags"]            = NP .. "mrmoney.png",
    ["Everbloom"]                = NP .. "everbloom.png",
    ["Velobyte"]                 = NP .. "velobyte.png",
    ["ShellShock X"]             = NP .. "shellshockx.png",
    ["Cenobyte.EXE"]             = NP .. "cenobyte.png",
    ["Jellybeam"]                = NP .. "jellybeam.png",
    ["GigaByte"]                 = NP .. "gigabyte.png",
    ["Spiritborn Axolotl"]       = NP .. "spiritborn.png",
    ["Phantom Dead Zombie Shark"]= NP .. "phantomdead.png",
    ["SweetTooth Gourdling"]     = NP .. "sweet.png",
    ["Mawsoleum"]                = NP .. "mawsoleum.png",
}

local FishImageURLLower = {}
for k, v in pairs(FishImageURL) do
    FishImageURLLower[string.lower(k)] = v
end

local function GetFishImageURL(baseName)
    if not baseName then return nil end
    return FishImageURL[baseName] or FishImageURLLower[string.lower(baseName)]
end

-- ============================================================
--  CACHE & UTILITY
-- ============================================================

local FishImageCache  = {}
local SpawnPointCache = {}

local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function Trim(s)
    return s:match("^%s*(.-)%s*$") or s
end

local function GetRequestFunc()
    if syn and type(syn.request) == "function" then return syn.request end
    if http and type(http.request) == "function" then return http.request end
    if type(http_request) == "function" then return http_request end
    if fluxus and type(fluxus.request) == "function" then return fluxus.request end
    if type(request) == "function" then return request end
    return nil
end

local function GetAvatarUrl()
    return PROXY .. "/avatar/" .. tostring(LocalPlayer.UserId)
end

local function IsMe(name)
    local n = string.lower(name)
    return n == string.lower(LocalPlayer.Name) or n == string.lower(LocalPlayer.DisplayName)
end

-- ============================================================
--  LOKASI PLAYER
-- ============================================================

local SPAWN_FOLDER_NAME  = "!!! SPAWN LOCATIONS"
local SPAWN_MAX_DISTANCE = 400

local function FindValueByName(container, names)
    if not container then return nil end
    for _, n in ipairs(names) do
        local child = container:FindFirstChild(n)
        if child then return child end
    end
    return nil
end

local function FindValueRecursive(instance, names)
    if not instance then return nil end
    local wanted = {}
    for _, n in ipairs(names) do wanted[string.lower(n)] = true end
    for _, desc in ipairs(instance:GetDescendants()) do
        if wanted[string.lower(desc.Name)] then
            local ok = pcall(function() return desc.Value end)
            if ok then return desc end
        end
    end
    return nil
end

local function FindPlayerValueInWorkspace(player, names)
    if not player then return nil end

    local playerFolder = Workspace:FindFirstChild(player.Name)
    if playerFolder then
        local direct = FindValueByName(playerFolder, names)
        if direct then return direct end
        local nested = FindValueRecursive(playerFolder, names)
        if nested then return nested end
    end

    local lowerPlayerName = string.lower(player.Name)
    local wanted = {}
    for _, n in ipairs(names) do wanted[string.lower(n)] = true end

    for _, desc in ipairs(Workspace:GetDescendants()) do
        if wanted[string.lower(desc.Name)] then
            local ok = pcall(function() return desc.Value end)
            if ok then
                local anc = desc.Parent
                while anc and anc ~= Workspace do
                    if string.lower(anc.Name) == lowerPlayerName then return desc end
                    anc = anc.Parent
                end
            end
        end
    end

    return nil
end

local function CacheSpawnLocations()
    SpawnPointCache = {}
    local folder = Workspace:FindFirstChild(SPAWN_FOLDER_NAME)
    if not folder then
        warn("[ Location ] Folder '" .. SPAWN_FOLDER_NAME .. "' tidak ditemukan di Workspace!")
        return
    end

    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("spawn", 1, true) then
            local lowerName = obj.Name:lower()
            local areaName

            if lowerName == "spawnlocation" or lowerName == "spawn" then
                areaName = obj.Parent and obj.Parent.Name or nil
            else
                areaName = obj.Name:gsub("%s*[Ss]pawn[Ll]ocation%s*$", "")
            end

            areaName = areaName and Trim(areaName) or nil
            if areaName and areaName ~= "" then
                table.insert(SpawnPointCache, { name = areaName, position = obj.Position })
            end
        end
    end

    warn("[ Location ] CacheSpawnLocations: ketemu " .. #SpawnPointCache .. " spawn point.")
end

local function GetNearestSpawnArea(player)
    if #SpawnPointCache == 0 then return nil end
    local char = player and player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local charPos = root.Position
    local nearestName, nearestDist = nil, math.huge

    for _, sp in ipairs(SpawnPointCache) do
        local dist = (charPos - sp.position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearestName = sp.name
        end
    end

    if nearestName and nearestDist <= SPAWN_MAX_DISTANCE then
        return nearestName
    end
    return nil
end

local function GetPlayerLocation(player)
    if not player then return "N/A" end
    local ls = player:FindFirstChild("leaderstats")

    local locStat = FindValueByName(ls, { "Map", "map", "Location", "Zone" })
        or FindValueRecursive(player, { "Map", "map", "Location", "Zone" })
        or FindPlayerValueInWorkspace(player, { "Map", "map", "Location", "Zone" })
    if locStat then
        return tostring(locStat.Value)
    end

    local attrLoc = player:GetAttribute("Map") or player:GetAttribute("map")
        or player:GetAttribute("Location") or player:GetAttribute("Zone")
    if attrLoc ~= nil then
        return tostring(attrLoc)
    end

    local nearest = GetNearestSpawnArea(player)
    if nearest then return nearest .. " (est.)" end

    return "N/A"
end

-- ============================================================
--  FISH DETECTION
-- ============================================================

local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    for _, baseName in ipairs(SecretFishList) do
        if lower == string.lower(baseName) then return baseName, nil end
    end
    local bestBase, bestLen, bestMutasi = nil, 0, nil
    for _, baseName in ipairs(SecretFishList) do
        local s = string.find(lower, string.lower(baseName), 1, true)
        if s then
            local mutasi = nil
            if s > 1 then
                mutasi = fishName:sub(1, s - 1):match("^%s*(.-)%s*$")
                if mutasi == "" then mutasi = nil end
            end
            if #baseName > bestLen then
                bestLen    = #baseName
                bestBase   = baseName
                bestMutasi = mutasi
            end
        end
    end
    return bestBase, bestMutasi
end

local function FindMutasi(fishName)
    local lower = string.lower(fishName)

    for _, species in ipairs(MutasiFalsePositiveSpecies) do
        local s = string.find(lower, species, 1, true)
        if s then
            local beforeOk = (s == 1) or (lower:sub(s - 1, s - 1) == " ")
            local afterPos = s + #species
            local afterOk  = (afterPos > #lower) or (lower:sub(afterPos, afterPos) == " ")
            if beforeOk and afterOk then
                lower = Trim((lower:sub(1, s - 1) .. " " .. lower:sub(afterPos + 1)):gsub("%s+", " "))
                break
            end
        end
    end
    if lower == "" then return nil end

    for _, mutasiName in ipairs(MutasiList) do
        local mutasiLower = string.lower(mutasiName)
        local s = string.find(lower, mutasiLower, 1, true)
        if s then
            local beforeOk = (s == 1) or (lower:sub(s - 1, s - 1) == " ")
            local afterPos = s + #mutasiLower
            local afterOk  = (afterPos > #lower) or (lower:sub(afterPos, afterPos) == " ")
            if beforeOk and afterOk then
                return mutasiName
            end
        end
    end
    return nil
end

local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if string.find(lower, "ruby") and string.find(lower, "gemstone") then return "Ruby" end
    return nil
end

local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh")                               then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture")         then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
            return nil
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

-- ============================================================
--  WEBHOOK
-- ============================================================

local function BuildEmbed(title, color, fields, imageUrl, thumbUrl)
    local embed = {
        title     = title,
        color     = color,
        fields    = fields,
        footer    = { text = "ForkyHUB — Personal | " .. os.date("%X") },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    if imageUrl then embed.image     = { url = imageUrl } end
    if thumbUrl then embed.thumbnail = { url = thumbUrl } end
    return embed
end

local function Field(emoji, label, value, inline)
    return { name = (emoji and (emoji .. " ") or "") .. label, value = value, inline = inline or false }
end

local function SendFishWebhook(title, color, fields, imageUrl, thumbUrl)
    local requestFunc = GetRequestFunc()
    if not requestFunc then warn("[ Webhook ] no request function available"); return end
    if not WEBHOOK_FISH or WEBHOOK_FISH == "" then warn("[ Webhook ] WEBHOOK_FISH kosong"); return end

    local body = {
        username   = FISH_IDENTITY.name,
        avatar_url = FISH_IDENTITY.avatar,
        embeds     = { BuildEmbed(title, color, fields, imageUrl, thumbUrl) },
    }

    local okEncode, encoded = pcall(function() return HttpService:JSONEncode(body) end)
    if not okEncode then warn("[ Webhook ] JSONEncode failed:", encoded); return end

    task.spawn(function()
        local ok, res = pcall(function()
            return requestFunc({
                Url     = WEBHOOK_FISH,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = encoded,
            })
        end)
        if not ok then warn("[ Webhook ] request failed:", res); return end
        if type(res) == "table" and res.StatusCode and res.StatusCode >= 400 then
            warn("[ Webhook ] HTTP error:", res.StatusCode, res.Body or "")
        end
    end)
end

-- ============================================================
--  CHAT PARSING & DETECTION
-- ============================================================

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg)
    msg = string.gsub(msg, "^%[Server%]:%s*", "")
    local playerName, fishFull, weight = string.match(msg, "^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = string.match(msg, "^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end
    playerName = playerName:match("%[%a+%]:%s*(.+)") or playerName
    playerName = Trim(playerName)
    weight     = weight and Trim(weight) or "N/A"
    fishFull   = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull   = fishFull:match("^(.-)%s*[!%.]?$")     or fishFull
    fishFull   = Trim(fishFull)
    return { player = playerName, fish = fishFull, weight = weight }
end

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end

    local data = ParseChat(rawMsg)
    if not data then return end
    if not IsMe(data.player) then return end   -- hanya tangkapan akun sendiri

    local avatarUrl      = GetAvatarUrl()
    local playerName     = LocalPlayer.Name
    local playerLocation = GetPlayerLocation(LocalPlayer)

    -- 1. Crystalized Legendary
    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = GetFishImageURL(legendaryBase)
            or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook("☄️ CRYSTALIZED LEGENDARY!", 3407871, {
            Field("👤", "Player", "**" .. playerName .. "**", true),
            Field("🦐", "Item",   "**" .. data.fish .. "**",  true),
            Field("✨", "Type",   "Crystalized Legendary",    true),
            Field("⚖️", "Weight", data.weight,                true),
            Field("📍", "Lokasi", playerLocation,             true),
        }, imageUrl, avatarUrl)
        return
    end

    -- 2. Ruby Gemstone
    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = GetFishImageURL(rubyBase)
            or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook("💎 RUBY GEMSTONE!", 16753920, {
            Field("👤", "Player", "**" .. playerName .. "**", true),
            Field("💎", "Item",   "**" .. data.fish .. "**",  true),
            Field("⚖️", "Weight", data.weight,                true),
            Field("📍", "Lokasi", playerLocation,             true),
        }, imageUrl, avatarUrl)
        return
    end

    -- 3. Secret / Forgotten Fish
    local baseName, mutasi = FindSecretFish(data.fish)
    if baseName then
        local imageUrl = GetFishImageURL(baseName)
            or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))

        local isForgotten = false
        for _, name in ipairs(ForgottenList) do
            if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
        end

        local fields = {
            Field("👤", "Player",  "**" .. playerName .. "**",        true),
            Field("🎣", "Fish",    "**" .. data.fish .. "**",         true),
            Field("🌀", "Variant", mutasi and ("*" .. mutasi .. "*") or "-", true),
            Field("⚖️", "Weight",  data.weight,                       true),
            Field("🎲", "Chance",  FishChanceData[baseName] or "Unknown", true),
            Field("📍", "Lokasi",  playerLocation,                    true),
        }

        if isForgotten then
            SendFishWebhook("⚜️ FORGOTTEN TIER DETECTED!", 16777215, fields, imageUrl, avatarUrl)
        else
            SendFishWebhook("🎣 SECRET FISH DETECTED!", 1752220, fields, imageUrl, avatarUrl)
        end
        return
    end

    -- 4. Mutasi non-secret
    local mutasiDetected = FindMutasi(data.fish)
    if mutasiDetected then
        SendFishWebhook("✨ MUTASI DETECTED!", 16776960, {
            Field("👤", "Player",  "**" .. playerName .. "**", true),
            Field("🎣", "Fish",    "**" .. data.fish .. "**",  true),
            Field("🌀", "Variant", mutasiDetected,             true),
            Field("⚖️", "Weight",  data.weight,                true),
        }, nil, avatarUrl)
    end
end

-- ============================================================
--  BACKPACK MONITOR (cache gambar ikan milik sendiri)
-- ============================================================

local function WatchBackpack(bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName = FindSecretFish(item.Name)
        if baseName and not GetFishImageURL(baseName) and not FishImageCache[baseName] then
            local imgId = GetFishImageId(item)
            if imgId then FishImageCache[baseName] = imgId end
        end
    end)
end

local function WatchMyBackpack()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then WatchBackpack(bp) end
    LocalPlayer.CharacterAdded:Connect(function()
        local newBp = LocalPlayer:WaitForChild("Backpack", 15)
        if newBp then WatchBackpack(newBp) end
    end)
end

-- ============================================================
--  HOOK CHAT
-- ============================================================

local chatHooked = false

local function HookChat()
    if chatHooked then return end
    chatHooked = true

    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            if msg.TextSource == nil then
                CheckAndSend(msg.Text or "")
            end
        end)
    end

    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if not (d and d.Message) then return end
                local lowerMsg = string.lower(d.Message)
                if string.find(lowerMsg, "%[server%]") or string.find(lowerMsg, "obtained") then
                    CheckAndSend(d.Message)
                end
            end)
        end
    end
end

-- ============================================================
--  START / STOP
-- ============================================================

local function StartMonitoring()
    SCRIPT_ACTIVE = true
    CacheSpawnLocations()
    WatchMyBackpack()
    HookChat()
end

local function StopMonitoring()
    SCRIPT_ACTIVE = false
end

-- ============================================================
--  UI
-- ============================================================

local function CreateUI()
    -- hapus UI lama kalau script di-execute dua kali
    pcall(function()
        for _, parent in ipairs({ (gethui and gethui()) or CoreGui, CoreGui, LocalPlayer:FindFirstChild("PlayerGui") }) do
            local old = parent and parent:FindFirstChild("ForkyPersonalUI")
            if old then old:Destroy() end
        end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name           = "ForkyPersonalUI"
    gui.ResetOnSpawn   = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local okParent = pcall(function()
        gui.Parent = (gethui and gethui()) or CoreGui
    end)
    if not okParent or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local function rgb(r,g,b) return Color3.fromRGB(r,g,b) end
    local function corner(p,r) Instance.new("UICorner",p).CornerRadius = UDim.new(0,r) end
    local function stroke(p,c,t) local s=Instance.new("UIStroke",p); s.Color=c; s.Thickness=t; return s end
    local function grad(p,c0,c1,r)
        local g=Instance.new("UIGradient",p)
        g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,c0),ColorSequenceKeypoint.new(1,c1)}
        g.Rotation=r or 90
    end

    local C = {
        bg      = rgb(8,12,18),
        panel   = rgb(13,20,30),
        surface = rgb(18,28,42),
        border  = rgb(30,50,70),
        accent  = rgb(0,200,180),
        green   = rgb(0,210,110),
        red     = rgb(220,60,60),
        text    = rgb(220,235,245),
        subtext = rgb(120,155,180),
        dim     = rgb(70,100,130),
    }

    local FULL_H = 184

    local shadow = Instance.new("Frame")
    shadow.Size                   = UDim2.new(0, 336, 0, FULL_H + 6)
    shadow.Position               = UDim2.new(0.5, -168, 0.5, -(FULL_H/2) - 3)
    shadow.BackgroundColor3       = rgb(0,180,160)
    shadow.BackgroundTransparency = 0.88
    shadow.BorderSizePixel        = 0
    shadow.ZIndex                 = 0
    shadow.Parent                 = gui
    corner(shadow, 14)

    local frame = Instance.new("Frame")
    frame.Name             = "Main"
    frame.Size             = UDim2.new(0, 330, 0, FULL_H)
    frame.Position         = UDim2.new(0.5, -165, 0.5, -(FULL_H/2))
    frame.BackgroundColor3 = C.bg
    frame.BorderSizePixel  = 0
    frame.ZIndex           = 1
    frame.Parent           = gui
    corner(frame, 12)
    stroke(frame, C.border, 1)

    local accentLine = Instance.new("Frame")
    accentLine.Size             = UDim2.new(0.6, 0, 0, 2)
    accentLine.Position         = UDim2.new(0.2, 0, 0, 0)
    accentLine.BackgroundColor3 = C.accent
    accentLine.BorderSizePixel  = 0
    accentLine.ZIndex           = 2
    accentLine.Parent           = frame
    corner(accentLine, 2)
    grad(accentLine, rgb(0,0,0), C.accent, 0)

    local topBar = Instance.new("Frame")
    topBar.Size             = UDim2.new(1, 0, 0, 42)
    topBar.BackgroundColor3 = C.panel
    topBar.BorderSizePixel  = 0
    topBar.ZIndex           = 2
    topBar.Parent           = frame
    corner(topBar, 12)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size             = UDim2.new(1, 0, 0, 12)
    topBarFix.Position         = UDim2.new(0, 0, 1, -12)
    topBarFix.BackgroundColor3 = C.panel
    topBarFix.BorderSizePixel  = 0
    topBarFix.ZIndex           = 2
    topBarFix.Parent           = topBar

    local logoDot = Instance.new("Frame")
    logoDot.Size             = UDim2.new(0, 8, 0, 8)
    logoDot.Position         = UDim2.new(0, 14, 0.5, -4)
    logoDot.BackgroundColor3 = C.accent
    logoDot.BorderSizePixel  = 0
    logoDot.ZIndex           = 3
    logoDot.Parent           = topBar
    corner(logoDot, 99)

    local title = Instance.new("TextLabel")
    title.Text                   = "ForkyHUB  ·  Personal Fish"
    title.Size                   = UDim2.new(1, -100, 1, 0)
    title.Position               = UDim2.new(0, 28, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3             = C.text
    title.Font                   = Enum.Font.GothamBold
    title.TextSize               = 11
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.ZIndex                 = 3
    title.Parent                 = topBar

    local function MakeWinBtn(sym, xOff, bg, hov)
        local b = Instance.new("TextButton")
        b.Text             = sym
        b.Size             = UDim2.new(0, 26, 0, 20)
        b.Position         = UDim2.new(1, xOff, 0.5, -10)
        b.BackgroundColor3 = bg
        b.TextColor3       = C.text
        b.Font             = Enum.Font.GothamBold
        b.TextSize         = 11
        b.BorderSizePixel  = 0
        b.ZIndex           = 3
        b.Parent           = topBar
        corner(b, 5)
        b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=hov}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=bg}):Play() end)
        return b
    end

    local minBtn   = MakeWinBtn("—", -60, rgb(28,42,58), rgb(45,65,85))
    local closeBtn = MakeWinBtn("✕", -30, rgb(28,42,58), rgb(200,55,55))

    local isMinimized = false
    local fullSize    = UDim2.new(0, 330, 0, FULL_H)
    local miniSize    = UDim2.new(0, 330, 0, 42)

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
            Size = isMinimized and miniSize or fullSize
        }):Play()
        TweenService:Create(shadow, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
            Size = isMinimized and UDim2.new(0,336,0,52) or UDim2.new(0,336,0,FULL_H + 6)
        }):Play()
        minBtn.Text = isMinimized and "□" or "—"
    end)

    -- drag (mouse + touch)
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=input.Position; startPos=frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                      or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            frame.Position  = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
            shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X-3, startPos.Y.Scale, startPos.Y.Offset+d.Y-3)
        end
    end)

    -- status pill
    local statusPill = Instance.new("Frame")
    statusPill.Size             = UDim2.new(1, -24, 0, 30)
    statusPill.Position         = UDim2.new(0, 12, 0, 50)
    statusPill.BackgroundColor3 = C.surface
    statusPill.BorderSizePixel  = 0
    statusPill.ZIndex           = 2
    statusPill.Parent           = frame
    corner(statusPill, 8)
    stroke(statusPill, C.border, 1)

    local statusDot = Instance.new("Frame")
    statusDot.Size             = UDim2.new(0, 7, 0, 7)
    statusDot.Position         = UDim2.new(0, 12, 0.5, -3)
    statusDot.BackgroundColor3 = C.red
    statusDot.BorderSizePixel  = 0
    statusDot.ZIndex           = 3
    statusDot.Parent           = statusPill
    corner(statusDot, 99)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text                   = "Tidak Aktif"
    statusLabel.Size                   = UDim2.new(1, -30, 1, 0)
    statusLabel.Position               = UDim2.new(0, 26, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3             = C.subtext
    statusLabel.Font                   = Enum.Font.Gotham
    statusLabel.TextSize               = 10
    statusLabel.TextXAlignment         = Enum.TextXAlignment.Left
    statusLabel.ZIndex                 = 3
    statusLabel.Parent                 = statusPill

    -- info row
    local infoRow = Instance.new("Frame")
    infoRow.Size             = UDim2.new(1,-24,0,28)
    infoRow.Position         = UDim2.new(0,12,0,89)
    infoRow.BackgroundColor3 = rgb(10,30,20)
    infoRow.BorderSizePixel  = 0
    infoRow.ZIndex           = 2
    infoRow.Parent           = frame
    corner(infoRow, 7)
    stroke(infoRow, rgb(0,80,50), 1)

    local infoLbl = Instance.new("TextLabel")
    infoLbl.Text                   = "✅  Mode pribadi: hanya notifikasi ikan akun kamu."
    infoLbl.Size                   = UDim2.new(1,-10,1,0)
    infoLbl.Position               = UDim2.new(0,8,0,0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.TextColor3             = rgb(80,210,140)
    infoLbl.Font                   = Enum.Font.Gotham
    infoLbl.TextSize               = 9
    infoLbl.TextXAlignment         = Enum.TextXAlignment.Left
    infoLbl.TextWrapped            = true
    infoLbl.ZIndex                 = 3
    infoLbl.Parent                 = infoRow

    -- tombol start / stop
    local startBtn = Instance.new("TextButton")
    startBtn.Text             = "▶   START MONITORING"
    startBtn.Size             = UDim2.new(1,-24,0,34)
    startBtn.Position         = UDim2.new(0,12,0,126)
    startBtn.BackgroundColor3 = rgb(0,155,90)
    startBtn.TextColor3       = rgb(240,255,250)
    startBtn.Font             = Enum.Font.GothamBold
    startBtn.TextSize         = 11
    startBtn.BorderSizePixel  = 0
    startBtn.ZIndex           = 2
    startBtn.Parent           = frame
    corner(startBtn, 8)

    local verLbl = Instance.new("TextLabel")
    verLbl.Text                   = "ForkyHUB v2  ·  Personal Edition"
    verLbl.Size                   = UDim2.new(1,-24,0,14)
    verLbl.Position               = UDim2.new(0,12,1,-18)
    verLbl.BackgroundTransparency = 1
    verLbl.TextColor3             = C.dim
    verLbl.Font                   = Enum.Font.Gotham
    verLbl.TextSize               = 8
    verLbl.TextXAlignment         = Enum.TextXAlignment.Center
    verLbl.ZIndex                 = 2
    verLbl.Parent                 = frame

    closeBtn.MouseButton1Click:Connect(function()
        StopMonitoring()
        TweenService:Create(frame, TweenInfo.new(0.18), {Size=UDim2.new(0,330,0,0), BackgroundTransparency=1}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.18), {BackgroundTransparency=1}):Play()
        task.wait(0.2); gui:Destroy()
    end)

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then
            -- STOP
            StopMonitoring()
            TweenService:Create(statusDot, TweenInfo.new(0.3), {BackgroundColor3=C.red}):Play()
            statusLabel.TextColor3    = C.subtext
            statusLabel.Text          = "Tidak Aktif"
            startBtn.Text             = "▶   START MONITORING"
            startBtn.BackgroundColor3 = rgb(0,155,90)
            startBtn.TextColor3       = rgb(240,255,250)
            return
        end

        if not WEBHOOK_FISH or not WEBHOOK_FISH:find("/api/webhooks") then
            startBtn.Text             = "❌ WEBHOOK TIDAK VALID!"
            startBtn.BackgroundColor3 = C.red
            task.wait(2)
            startBtn.Text             = "▶   START MONITORING"
            startBtn.BackgroundColor3 = rgb(0,155,90)
            return
        end

        StartMonitoring()

        TweenService:Create(statusDot, TweenInfo.new(0.3), {BackgroundColor3=C.green}):Play()
        statusLabel.TextColor3    = C.green
        statusLabel.Text          = "Aktif — memantau ikan kamu..."
        startBtn.Text             = "■   STOP"
        startBtn.BackgroundColor3 = rgb(170,55,55)

        task.spawn(function()
            while SCRIPT_ACTIVE and gui.Parent do
                TweenService:Create(accentLine,TweenInfo.new(1.2,Enum.EasingStyle.Sine),{BackgroundTransparency=0.4}):Play()
                task.wait(1.2)
                TweenService:Create(accentLine,TweenInfo.new(1.2,Enum.EasingStyle.Sine),{BackgroundTransparency=0}):Play()
                task.wait(1.2)
            end
        end)
    end)
end

-- ============================================================
--  INIT
-- ============================================================

local function Notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = "ForkyHUB",
            Text     = text,
            Duration = 8,
        })
    end)
end

print("[ForkyPersonal] 2 - mau buat UI")
local ok, err = pcall(CreateUI)
if ok then
    print("[ForkyPersonal] 3 - UI loaded")
    Notify("UI loaded")
else
    warn("[ForkyPersonal] UI error: " .. tostring(err))
    Notify("UI error: " .. tostring(err))
end