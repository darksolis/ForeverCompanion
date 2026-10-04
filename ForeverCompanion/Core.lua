local ADDON_NAME, FC = ...
_G.ForeverCompanion = FC

FC.version = "0.9.48-rc43"
FC.schema = 33
FC.addonName = ADDON_NAME or "ForeverCompanion"
FC.startTime = GetTime()

FC.state = {
    xpEvents = {},
    combatSamples = {},
    queue = {},
    questSnapshot = {},
    cooldowns = {},
    capabilities = {},
    zoneSession = {},
    lastAction = GetTime(),
    lastThought = 0,
    inCombat = false,
    combat = {},
    journalSession = {},
    ready = false,
    categoryLastSpeak = {},
    mood = { name = "neutral", score = 0, untilTime = 0 },
    runtime = {},
    contextMode = "unknown",
    sessionZones = {},
}

local memoryDefaults = {
    sessions = 0,
    lifetimeDeaths = 0,
    lifetimeCombatXP = 0,
    questTurnins = 0,
    firstSeen = time(),
    profile = {},
    completedQuestIDs = {},
    zones = {},
    levels = {},
    deathsByMob = {},
    npcEncounters = {},
    questHistory = {},
    milestones = {},
    journal = {},
}

local defaults = {
    schema = 33,
    enabled = true,
    chatty = 0.55,
    tips = true,
    xp = true,
    quests = true,
    combat = true,
    world = true,
    memory = true,
    bubble = true,
    miniStats = false,
    companion = "Vexa",
    scale = 1,
    x = 360,
    y = 180,
    debug = false,
    onboarded = false,

    personality = {
        helpful = 0.65,
        smartass = 0.78,
        flirty = 0.45,
        chaotic = 0.30,
        roast = 0.55,
    },

    commentary = {
        xp = 0.85,
        quests = 0.90,
        combat = 0.65,
        world = 0.55,
        loot = 0.65,
        tips = 0.65,
        jokes = 0.70,
    },
    conversation = {
        enabled = true,
        frequency = 0.90,
        walking = true,
        jokes = true,
        facts = true,
        quotes = true,
        riddles = true,
        questions = true,
        strangeFacts = true,
        challenges = true,
        deepThoughts = true,
        classBanter = true,
        memoryBanter = true,
        vocabulary = true,
        vocabQuizzes = true,
        wordRoots = true,
        trivia = true,
        languagePlay = true,
        expandedFacts = true,
        creativePrompts = true,
        metaBanter = true,
        compliments = true,
        roasts = true,
    },
    mutedCategories = {},

    goldFarming = {
        useAuctionator = true,
        commentary = true,
        valuableGold = 1.0,
        paceMinutes = 5,
    },

    procAlerts = {
        enabled = true,
        screenEffect = true,
        vexaShout = true,
        sound = true,
        voiceEnabled = true,
        voiceID = nil,
        voiceRate = 0,
        voiceVolume = 100,
        respectGameSound = true,
        customVoicePack = true,
        ttsFallback = false,
        hdArt = false,
        artSize = 300,
        anyOverlay = true,
        fallbackDetection = true,
        strictClientDetection = true,
        onlyInCombat = false,
        showSource = false,
        scale = 1.0,
        x = 0,
        y = 140,
        iconSize = 52,
        textSize = 28,
        duration = 1.45,
        cooldown = 1.25,
        pollInterval = 0.20,
    },

    voicePack = {
        enabled = true,
        eventVoices = true,
        globalCooldown = 3.0,
    },

    dungeon = {
        enabled = true,
        suppressQuestReminders = true,
        lootWatch = true,
        bossChatter = true,
        chatter = true,
        lootCount = 3,
    },

    appearance = {
        mode = "desktop",
        renderer = "sprite",
        displayID = nil,
        animationScale = 1,
        camera = "body",
        rotation = 0,
        modelScale = 1,
        motion = 0.18,
        bubbleScale = 1.0,
        fontScale = 1.0,
    },

    ui = {
        locked = false,
        lastTab = "Companion",
    },

    minimap = {
        hide = false,
        angle = 225,
    },

    -- Legacy/current-character alias. RC11 migrates this into characters[key].memory.
    memory = memoryDefaults,
    characters = {},
    sharedMemory = {
        sessions = 0,
        firstSeen = time(),
        lastCharacterKey = nil,
        characters = {},
        dialogueHistory = {},
        preferences = {},
        blockedLines = {},
        favoriteLines = {},
        goldFarming = { sessions = {}, items = {}, totalMarket = 0, totalVendor = 0, totalCash = 0 },
    },
}

local function mergeDefaults(destination, source)
    for key, value in pairs(source) do
        if type(value) == "table" then
            if type(destination[key]) ~= "table" then destination[key] = {} end
            mergeDefaults(destination[key], value)
        elseif destination[key] == nil then
            destination[key] = value
        end
    end
end

local function freshMemory()
    local memory = {}
    mergeDefaults(memory, memoryDefaults)
    return memory
end

local function earlyCanAccess(value)
    if value == nil then return false end
    if type(canaccessvalue) == "function" then
        local ok, accessible = pcall(canaccessvalue, value)
        if ok then return accessible and true or false end
    end
    if type(issecretvalue) == "function" then
        local ok, secret = pcall(issecretvalue, value)
        if ok then return not secret end
    end
    return true
end

local function earlyString(value, fallback)
    if earlyCanAccess(value) and type(value) == "string" and value ~= "" then return value end
    return fallback
end

local function earlyNumber(value, fallback)
    if earlyCanAccess(value) and type(value) == "number" then return value end
    return fallback
end

function FC:GetCharacterIdentity()
    local rawName, rawRealm
    if type(UnitName) == "function" then
        local ok, value = pcall(UnitName, "player")
        if ok then rawName = value end
    end
    if type(GetRealmName) == "function" then
        local ok, value = pcall(GetRealmName)
        if ok then rawRealm = value end
    end
    local name = earlyString(rawName, "Unknown")
    local realm = earlyString(rawRealm, "UnknownRealm")
    return name, realm, name ~= "Unknown"
end

local function normalizeIdentityPart(value)
    value = earlyString(value, "") or ""
    value = string.lower(value)
    value = value:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
    value = value:gsub("[^%w]", "")
    return value
end

local function unknownIdentityPart(value)
    local normalized = normalizeIdentityPart(value)
    return normalized == "" or normalized == "unknown" or normalized == "unknownrealm" or normalized == "hero"
end

local function mergeCharacterData(destination, source)
    if type(destination) ~= "table" or type(source) ~= "table" or destination == source then return destination end

    for key, value in pairs(source) do
        local existing = destination[key]
        if existing == nil then
            destination[key] = value
        elseif type(existing) == "table" and type(value) == "table" then
            mergeCharacterData(existing, value)
        elseif type(existing) == "number" and type(value) == "number" then
            -- Duplicate character records are usually snapshots of the same history.
            -- Keep the strongest/highest observation instead of double-counting it.
            destination[key] = math.max(existing, value)
        elseif type(existing) == "boolean" and type(value) == "boolean" then
            destination[key] = existing or value
        elseif (existing == "" or existing == "Unknown" or existing == "UNKNOWN") and value ~= "" then
            destination[key] = value
        end
    end

    return destination
end

function FC:CanonicalCharacterKey(name, realm)
    local normalizedName = normalizeIdentityPart(name)
    local normalizedRealm = normalizeIdentityPart(realm)
    if normalizedName == "" then normalizedName = "unknown" end
    if normalizedRealm == "" then normalizedRealm = "unknownrealm" end
    return "char:" .. normalizedRealm .. "::" .. normalizedName
end

function FC:GetCharacterKey()
    local name, realm = self:GetCharacterIdentity()
    return self:CanonicalCharacterKey(name, realm)
end

function FC:GetStoredCharacterIdentity(key, character)
    local info = self.db and self.db.sharedMemory and self.db.sharedMemory.characters and self.db.sharedMemory.characters[key] or nil
    local profile = character and character.memory and character.memory.profile or nil

    local name = (info and info.name) or (profile and profile.name)
    local realm = (info and info.realm) or (profile and profile.realm)
    local classToken = (info and info.classToken) or (profile and profile.classToken)

    -- Old pre-canonical keys were stored as "Realm::Name". Use them only as a fallback.
    if (not name or name == "") and type(key) == "string" and not key:find("^char:") then
        name = key:match("::(.+)$")
    end
    if (not realm or realm == "") and type(key) == "string" and not key:find("^char:") then
        realm = key:match("^(.-)::")
    end

    return name, realm, classToken
end

function FC:ConsolidateCurrentCharacterRecords(currentName, currentRealm, currentClassToken)
    if not self.db then return self:CanonicalCharacterKey(currentName, currentRealm) end
    self.db.characters = self.db.characters or {}
    self.db.sharedMemory = self.db.sharedMemory or { characters = {} }
    self.db.sharedMemory.characters = self.db.sharedMemory.characters or {}

    local canonicalKey = self:CanonicalCharacterKey(currentName, currentRealm)
    local normalizedName = normalizeIdentityPart(currentName)
    local normalizedRealm = normalizeIdentityPart(currentRealm)
    local candidates = {}
    local seen = {}

    local function consider(key, character)
        if seen[key] then return end
        local name, realm, classToken = self:GetStoredCharacterIdentity(key, character)
        if normalizeIdentityPart(name) ~= normalizedName then return end

        local storedRealm = normalizeIdentityPart(realm)
        local realmMatches = storedRealm == normalizedRealm
            or unknownIdentityPart(realm)
            or unknownIdentityPart(currentRealm)

        -- Legacy records sometimes lost/changed the realm string. If there is a matching
        -- name AND class and the stored realm is clearly provisional, treat it as the same character.
        local classMatches = currentClassToken and classToken and tostring(currentClassToken) == tostring(classToken)
        if realmMatches or (classMatches and unknownIdentityPart(realm)) then
            seen[key] = true
            candidates[#candidates + 1] = key
        end
    end

    for key, character in pairs(self.db.characters) do consider(key, character) end
    for key in pairs(self.db.sharedMemory.characters) do consider(key, self.db.characters[key]) end

    -- Prefer the record with the highest known level / newest seen time as the base.
    local bestKey = canonicalKey
    local bestScore = -1
    for _, key in ipairs(candidates) do
        local character = self.db.characters[key]
        local info = self.db.sharedMemory.characters[key] or {}
        local profile = character and character.memory and character.memory.profile or {}
        local level = tonumber(info.level or profile.level) or 0
        local lastSeen = tonumber(info.lastSeen or profile.lastScan) or 0
        local score = level * 10000000000 + lastSeen
        if score > bestScore then
            bestScore = score
            bestKey = key
        end
    end

    local target = self.db.characters[canonicalKey]
    if not target and self.db.characters[bestKey] then
        target = self.db.characters[bestKey]
        self.db.characters[canonicalKey] = target
    end
    if not target then
        target = { memory = freshMemory(), onboarded = false }
        self.db.characters[canonicalKey] = target
    end
    target.memory = target.memory or freshMemory()
    mergeDefaults(target.memory, memoryDefaults)

    local targetInfo = self.db.sharedMemory.characters[canonicalKey] or {}
    if bestKey ~= canonicalKey and self.db.sharedMemory.characters[bestKey] then
        mergeCharacterData(targetInfo, self.db.sharedMemory.characters[bestKey])
    end

    for _, key in ipairs(candidates) do
        if key ~= canonicalKey then
            local record = self.db.characters[key]
            if record and record ~= target then
                target.onboarded = target.onboarded or record.onboarded
                target.memory = mergeCharacterData(target.memory, record.memory or {})
            end
            local info = self.db.sharedMemory.characters[key]
            if info then mergeCharacterData(targetInfo, info) end

            if self.db.sharedMemory.lastCharacterKey == key then
                self.db.sharedMemory.lastCharacterKey = canonicalKey
            end

            self.db.characters[key] = nil
            self.db.sharedMemory.characters[key] = nil
        end
    end

    -- Live identity is authoritative. Level is updated again immediately after this call.
    targetInfo.name = currentName
    targetInfo.realm = currentRealm
    targetInfo.classToken = currentClassToken or targetInfo.classToken
    self.db.sharedMemory.characters[canonicalKey] = targetInfo

    local profile = target.memory.profile or {}
    target.memory.profile = profile
    profile.name = currentName
    profile.realm = currentRealm
    if currentClassToken then profile.classToken = currentClassToken end

    return canonicalKey
end

function FC:ActivateCharacterMemory()
    self.db.characters = self.db.characters or {}
    self.db.sharedMemory = self.db.sharedMemory or { sessions = 0, characters = {} }
    self.db.sharedMemory.characters = self.db.sharedMemory.characters or {}

    local currentName, currentRealm, identityReady = self:GetCharacterIdentity()
    local key = self:CanonicalCharacterKey(currentName, currentRealm)

    local currentClass, currentClassToken = "Unknown", "UNKNOWN"
    if type(UnitClass) == "function" then
        local rawClass, rawToken = UnitClass("player")
        currentClass = earlyString(rawClass, nil) or earlyString(rawToken, "Unknown")
        currentClassToken = earlyString(rawToken, nil) or currentClass or "UNKNOWN"
    end

    -- One-time migration: put the old global memory under the character it actually belonged to.
    if not self.db.characterMemoryMigrated and type(self.db.memory) == "table" then
        local legacyProfile = self.db.memory.profile or {}
        local legacyName = legacyProfile.name
        if legacyName and legacyName ~= "" then
            local legacyRealm = legacyProfile.realm or currentRealm
            local legacyKey = self:CanonicalCharacterKey(legacyName, legacyRealm)
            self.db.characters[legacyKey] = self.db.characters[legacyKey] or {
                memory = self.db.memory,
                onboarded = self.db.onboarded and true or false,
            }
            local legacyInfo = self.db.sharedMemory.characters[legacyKey] or {}
            legacyInfo.name = legacyProfile.name
            legacyInfo.realm = legacyRealm
            legacyInfo.class = legacyProfile.class or legacyProfile.classToken or "Unknown"
            legacyInfo.classToken = legacyProfile.classToken
            legacyInfo.level = legacyProfile.level or 0
            legacyInfo.lastSeen = legacyProfile.lastScan or time()
            self.db.sharedMemory.characters[legacyKey] = legacyInfo
        end
        self.db.characterMemoryMigrated = true
    end

    -- ADDON_LOADED can fire before UnitName is ready on Forever. Keep this bucket temporary.
    if not identityReady then
        local character = self.db.characters[key]
        if not character then
            character = { memory = freshMemory(), onboarded = false, provisional = true }
            self.db.characters[key] = character
        end
        character.memory = character.memory or freshMemory()
        mergeDefaults(character.memory, memoryDefaults)
        self.characterKey = key
        self.character = character
        self.db.memory = character.memory
        self.db.onboarded = character.onboarded and true or false
        return false
    end

    -- Fold all legacy/raw/case-variant records for this name back into one canonical identity.
    key = self:ConsolidateCurrentCharacterRecords(currentName, currentRealm, currentClassToken)

    -- If startup used an Unknown bucket, merge its transient data into the resolved character.
    local provisionalKeys = {
        self:CanonicalCharacterKey("Unknown", currentRealm),
        self:CanonicalCharacterKey("Unknown", "UnknownRealm"),
        tostring(currentRealm) .. "::Unknown",
        "UnknownRealm::Unknown",
    }
    for _, provisionalKey in ipairs(provisionalKeys) do
        if provisionalKey ~= key then
            local provisional = self.db.characters[provisionalKey]
            if provisional then
                local resolved = self.db.characters[key]
                if resolved then
                    resolved.memory = mergeCharacterData(resolved.memory or freshMemory(), provisional.memory or {})
                    resolved.onboarded = resolved.onboarded or provisional.onboarded
                else
                    self.db.characters[key] = provisional
                    provisional.provisional = nil
                end
                self.db.characters[provisionalKey] = nil
                self.db.sharedMemory.characters[provisionalKey] = nil
                if self.db.sharedMemory.lastCharacterKey == provisionalKey then
                    self.db.sharedMemory.lastCharacterKey = key
                end
            end
        end
    end

    local previousKey = self.db.sharedMemory.lastCharacterKey
    local previousInfo = previousKey and self.db.sharedMemory.characters[previousKey] or nil

    local character = self.db.characters[key]
    if not character then
        character = { memory = freshMemory(), onboarded = false }
        self.db.characters[key] = character
    end
    character.memory = character.memory or freshMemory()
    mergeDefaults(character.memory, memoryDefaults)

    local alreadyActive = self.characterKey == key and self.state.identityActivated == true

    self.characterKey = key
    self.character = character
    self.db.memory = character.memory
    self.db.onboarded = character.onboarded and true or false

    local info = self.db.sharedMemory.characters[key] or {}
    info.name = currentName
    info.realm = currentRealm
    info.class = currentClass
    info.classToken = currentClassToken
    local rawLevel = type(UnitLevel) == "function" and UnitLevel("player") or nil
    info.level = earlyNumber(rawLevel, info.level or 0)
    info.lastSeen = time()
    if not alreadyActive then info.sessions = (info.sessions or 0) + 1 end
    self.db.sharedMemory.characters[key] = info

    local profile = character.memory.profile or {}
    character.memory.profile = profile
    profile.name = currentName
    profile.realm = currentRealm
    profile.class = currentClass
    profile.classToken = currentClassToken
    profile.level = info.level

    self.state.characterSwitchFrom = nil
    if not alreadyActive and previousKey and previousKey ~= key and previousInfo then
        self.state.characterSwitchFrom = previousInfo
    end

    self.db.sharedMemory.lastCharacterKey = key
    if not alreadyActive then
        self.db.sharedMemory.sessions = (self.db.sharedMemory.sessions or 0) + 1
        self.db.memory.sessions = (self.db.memory.sessions or 0) + 1
    end
    self.state.identityActivated = true

    -- All transient progression state belongs to the active character only.
    self.state.xpMilestones = {}
    self.state.xpProgressKey = nil
    self.state.lastXPProgress = nil
    self.state.questSnapshot = {}
    return true
end

function FC:InitDB()
    ForeverCompanionDB = ForeverCompanionDB or {}
    mergeDefaults(ForeverCompanionDB, defaults)
    self.db = ForeverCompanionDB
    self:Migrate()
    self:ActivateCharacterMemory()
end

function FC:Migrate()
    local oldSchema = tonumber(self.db.schema) or 0
    self.db.schema = self.schema
    self.db.miniStats = false
    self.db.companion = "Vexa"
    self.db.ui = self.db.ui or { locked = false, lastTab = "Companion" }
    self.db.personality = self.db.personality or {}
    self.db.commentary = self.db.commentary or {}
    self.db.conversation = self.db.conversation or {}
    if self.db.conversation.quotes == nil then self.db.conversation.quotes = true end
    if self.db.conversation.riddles == nil then self.db.conversation.riddles = true end
    if self.db.conversation.questions == nil then self.db.conversation.questions = true end
    if self.db.conversation.strangeFacts == nil then self.db.conversation.strangeFacts = true end
    if self.db.conversation.challenges == nil then self.db.conversation.challenges = true end
    if self.db.conversation.deepThoughts == nil then self.db.conversation.deepThoughts = true end
    if self.db.conversation.vocabulary == nil then self.db.conversation.vocabulary = true end
    if self.db.conversation.vocabQuizzes == nil then self.db.conversation.vocabQuizzes = true end
    if self.db.conversation.wordRoots == nil then self.db.conversation.wordRoots = true end
    if self.db.conversation.trivia == nil then self.db.conversation.trivia = true end
    if self.db.conversation.languagePlay == nil then self.db.conversation.languagePlay = true end
    if self.db.conversation.expandedFacts == nil then self.db.conversation.expandedFacts = true end
    if self.db.conversation.creativePrompts == nil then self.db.conversation.creativePrompts = true end
    if self.db.conversation.metaBanter == nil then self.db.conversation.metaBanter = true end
    if self.db.conversation.compliments == nil then self.db.conversation.compliments = true end
    if self.db.conversation.roasts == nil then self.db.conversation.roasts = true end
    if oldSchema < 25 then
        if (tonumber(self.db.conversation.frequency) or 0) <= 0.70 then self.db.conversation.frequency = 0.90 end
        if (tonumber(self.db.chatty) or 0) <= 0.65 then self.db.chatty = 0.80 end
    end
    self.db.mutedCategories = self.db.mutedCategories or {}
    self.db.appearance = self.db.appearance or {}
    self.db.appearance.motion = math.min(0.35, tonumber(self.db.appearance.motion) or 0.18)
    self.db.appearance.bubbleScale = math.max(0.70, math.min(1.30, tonumber(self.db.appearance.bubbleScale) or 1.0))
    self.db.appearance.fontScale = math.max(0.80, math.min(1.25, tonumber(self.db.appearance.fontScale) or 1.0))
    self.db.minimap = self.db.minimap or { hide = false, angle = 225 }
    if oldSchema < 22 then
        -- Recovery migration: earlier UI startup failures could leave the launcher hidden.
        self.db.minimap.hide = false
        self.db.minimap.angle = tonumber(self.db.minimap.angle) or 225
    end
    self.db.characters = self.db.characters or {}
    self.db.sharedMemory = self.db.sharedMemory or { sessions = 0, characters = {} }
    self.db.sharedMemory.characters = self.db.sharedMemory.characters or {}
    self.db.sharedMemory.dialogueHistory = self.db.sharedMemory.dialogueHistory or {}
    self.db.sharedMemory.preferences = self.db.sharedMemory.preferences or {}
    self.db.sharedMemory.blockedLines = self.db.sharedMemory.blockedLines or {}
    self.db.sharedMemory.favoriteLines = self.db.sharedMemory.favoriteLines or {}
    self.db.voicePack = self.db.voicePack or { enabled = true, eventVoices = true, globalCooldown = 3.0 }
    if self.db.voicePack.enabled == nil then self.db.voicePack.enabled = true end
    if self.db.voicePack.eventVoices == nil then self.db.voicePack.eventVoices = true end
    self.db.voicePack.globalCooldown = tonumber(self.db.voicePack.globalCooldown) or 3.0

    self.db.goldFarming = self.db.goldFarming or { useAuctionator = true, commentary = true, valuableGold = 1.0, paceMinutes = 5 }
    self.db.dungeon = self.db.dungeon or { enabled = true, suppressQuestReminders = true, lootWatch = true, bossChatter = true, chatter = true, lootCount = 3 }
    self.db.procAlerts = self.db.procAlerts or {}
    if self.db.procAlerts.enabled == nil then self.db.procAlerts.enabled = true end
    if self.db.procAlerts.screenEffect == nil then self.db.procAlerts.screenEffect = true end
    if self.db.procAlerts.vexaShout == nil then self.db.procAlerts.vexaShout = true end
    if self.db.procAlerts.sound == nil then self.db.procAlerts.sound = true end
    if self.db.procAlerts.voiceEnabled == nil then self.db.procAlerts.voiceEnabled = true end
    if self.db.procAlerts.respectGameSound == nil then self.db.procAlerts.respectGameSound = true end
    if self.db.procAlerts.customVoicePack == nil then self.db.procAlerts.customVoicePack = true end
    if self.db.procAlerts.ttsFallback == nil then self.db.procAlerts.ttsFallback = false end
    if oldSchema < 31 then self.db.procAlerts.customVoicePack = true end
    if self.db.procAlerts.hdArt == nil then self.db.procAlerts.hdArt = false end
    if self.db.procAlerts.anyOverlay == nil then self.db.procAlerts.anyOverlay = true end
    if self.db.procAlerts.fallbackDetection == nil then self.db.procAlerts.fallbackDetection = true end
    if self.db.procAlerts.strictClientDetection == nil then self.db.procAlerts.strictClientDetection = true end
    if self.db.procAlerts.onlyInCombat == nil then self.db.procAlerts.onlyInCombat = false end
    if self.db.procAlerts.showSource == nil then self.db.procAlerts.showSource = false end
    self.db.procAlerts.scale = tonumber(self.db.procAlerts.scale) or 1.0
    self.db.procAlerts.x = tonumber(self.db.procAlerts.x) or 0
    self.db.procAlerts.y = tonumber(self.db.procAlerts.y) or 140
    self.db.procAlerts.iconSize = tonumber(self.db.procAlerts.iconSize) or 52
    self.db.procAlerts.textSize = tonumber(self.db.procAlerts.textSize) or 28
    self.db.procAlerts.voiceRate = tonumber(self.db.procAlerts.voiceRate) or 0
    self.db.procAlerts.voiceVolume = tonumber(self.db.procAlerts.voiceVolume) or 100
    self.db.procAlerts.artSize = tonumber(self.db.procAlerts.artSize) or 300
    self.db.procAlerts.duration = tonumber(self.db.procAlerts.duration) or 1.45
    self.db.procAlerts.cooldown = tonumber(self.db.procAlerts.cooldown) or 1.25
    self.db.procAlerts.pollInterval = tonumber(self.db.procAlerts.pollInterval) or 0.20
    if self.db.goldFarming.useAuctionator == nil then
        if self.db.goldFarming.useAuctioneer ~= nil then
            self.db.goldFarming.useAuctionator = self.db.goldFarming.useAuctioneer and true or false
        else
            self.db.goldFarming.useAuctionator = true
        end
    end
    self.db.goldFarming.useAuctioneer = nil
    self.db.sharedMemory.goldFarming = self.db.sharedMemory.goldFarming or { sessions = {}, items = {}, totalMarket = 0, totalVendor = 0, totalCash = 0 }

    if self.db.locked_dummy ~= nil then
        self.db.ui.locked = self.db.locked_dummy
        self.db.locked_dummy = nil
    end
end

function FC:Debug(message)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cffbd7cffForever Companion|r " .. tostring(message))
    end
end

function FC:Safe(fn, ...)
    if type(fn) ~= "function" then return nil end

    local ok, a, b, c, d, e = pcall(fn, ...)
    if ok then
        return a, b, c, d, e
    end

    if self.db and self.db.debug then
        self:Debug(a)
    end
    return nil
end


function FC:CanAccessValue(value)
    if value == nil then return false end

    if type(canaccessvalue) == "function" then
        local ok, accessible = pcall(canaccessvalue, value)
        if ok then return accessible and true or false end
    end

    if type(issecretvalue) == "function" then
        local ok, secret = pcall(issecretvalue, value)
        if ok then return not secret end
    end

    return true
end

function FC:ReadableNumber(value)
    if not self:CanAccessValue(value) then return nil end
    if type(value) ~= "number" then return nil end
    return value
end

function FC:ReadableString(value)
    if not self:CanAccessValue(value) then return nil end
    if type(value) ~= "string" then return nil end
    return value
end

function FC:ReadableBoolean(value)
    if not self:CanAccessValue(value) then return nil end
    if type(value) ~= "boolean" then return nil end
    return value
end

-- Final safety net for WoW/Forever secret values. Even if a client API reports a
-- value as readable, protected arithmetic can still throw when execution is tainted.
-- All math involving live unit values should go through these helpers.
function FC:SafeRatio(numerator, denominator)
    numerator = self:ReadableNumber(numerator)
    denominator = self:ReadableNumber(denominator)
    if numerator == nil or denominator == nil then return nil end
    local ok, result = pcall(function()
        if denominator <= 0 then return nil end
        return numerator / denominator
    end)
    if not ok or type(result) ~= "number" then return nil end
    return result
end

function FC:SafeSubtract(a, b)
    a = self:ReadableNumber(a)
    b = self:ReadableNumber(b)
    if a == nil or b == nil then return nil end
    local ok, result = pcall(function() return a - b end)
    if not ok or type(result) ~= "number" then return nil end
    return result
end

function FC:SafeMultiply(a, b)
    a = self:ReadableNumber(a)
    b = self:ReadableNumber(b)
    if a == nil or b == nil then return nil end
    local ok, result = pcall(function() return a * b end)
    if not ok or type(result) ~= "number" then return nil end
    return result
end

function FC:SafeUnitNumber(fn, unit, ...)
    if type(fn) ~= "function" then return nil end
    local ok, value = pcall(fn, unit, ...)
    if not ok then return nil end
    return self:ReadableNumber(value)
end

function FC:Call(methodName, ...)
    local method = self[methodName]
    if type(method) ~= "function" then
        self:Debug("Missing required method: " .. tostring(methodName))
        return false
    end

    local ok, resultA, resultB, resultC = pcall(method, self, ...)
    if not ok then
        self:Debug(methodName .. " failed: " .. tostring(resultA))
        return false
    end

    return true, resultA, resultB, resultC
end

function FC:ValidateModules()
    local required = {
        "DetectCapabilities",
        "IsDungeonContext",
        "ScanDungeonLoot",
        "TouchZone",
        "ZoneHistoricalRate",
        "ScanQuests",
        "RunCatchup",
        "CombatStart",
        "CombatEnd",
        "OnDeath",
        "OnZoneChanged",
        "CheckWorldState",
        "QueueTopic",
        "PumpQueue",
        "CreateRenderer",
        "CreateUI",
        "CreateSettings",
        "CreateMinimapButton",
        "CaptureFacts",
        "HandleContextEvent",
        "InitializeProcAlerts",
        "HandleProcOverlay",
        "HandleProcCombatLog",
        "CheckActionBarProcs",
        "RebuildProcActionMap",
        "ProcTick",
        "PlayVexaVoiceCue",
        "MaybePlayVexaVoiceForTopic",
        "RefreshIntegrations",
        "RunTestSuite",
        "RunDoctor",
        "FinalizeSession",
        "InitializeGoldTracking",
        "TrackLootValue",
        "ShowGoldFarmStats",
        "MaybeConversation",
        "ForceConversation",
        "ConversationTick",
        "StartRiddle",
        "AnswerRiddle",
        "StartTrivia",
        "AnswerTrivia",
        "TellVocabularyWord",
        "StartVocabularyQuiz",
        "AnswerVocabularyQuiz",
        "VocabularyTick",
        "TellWordRoot",
        "RefreshVocabularyStats",
    }

    local missing = {}
    for _, name in ipairs(required) do
        if type(self[name]) ~= "function" then
            missing[#missing + 1] = name
        end
    end

    if #missing > 0 then
        self.state.ready = false
        self:Debug("Startup halted. Missing module methods: " .. table.concat(missing, ", "))
        return false
    end

    return true
end

function FC:FormatNumber(number)
    local value = math.floor(tonumber(number) or 0)
    local text = tostring(value)

    while true do
        local replaced, count = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        text = replaced
        if count == 0 then break end
    end

    return text
end

function FC:FormatDuration(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    if seconds < 60 then
        return seconds .. "s"
    end

    local minutes = math.floor(seconds / 60)
    if minutes < 60 then
        return minutes .. "m"
    end

    return string.format("%dh %02dm", math.floor(minutes / 60), minutes % 60)
end

function FC:XPRemaining()
    if type(UnitXPMax) ~= "function" or type(UnitXP) ~= "function" then return 0 end
    local maximum = self:ReadableNumber(UnitXPMax("player"))
    local current = self:ReadableNumber(UnitXP("player"))
    local remaining = self:SafeSubtract(maximum, current)
    if remaining == nil then return 0 end
    return math.max(0, remaining)
end

function FC:SessionSeconds()
    return math.max(1, GetTime() - self.startTime)
end

function FC:XPPerHour()
    return ((self.state.sessionXP or 0) / self:SessionSeconds()) * 3600
end

function FC:TouchAction()
    self.state.lastAction = GetTime()
    if self.state.wasIdle then
        self.state.wasIdle = false
        self:QueueTopic("comeback", {}, 20, 90)
    end
end

function FC:RegisterIntegration(name, callback)
    if type(callback) ~= "function" then return end
    self.integrations = self.integrations or {}
    self.integrations[name] = callback
end

function FC:Fire(topic, payload)
    for _, callback in pairs(self.integrations or {}) do
        self:Safe(callback, topic, payload)
    end
end

function FC:SetMode(mode)
    if mode ~= "full" and mode ~= "desktop" and mode ~= "portrait" then
        return
    end

    self.db.appearance.mode = mode
    if self.ApplyPresentationMode then
        self:ApplyPresentationMode()
    end
end

function FC:PrintVersion()
    self:Debug(
        "version=" .. tostring(self.version) ..
        "  schema=" .. tostring(self.schema) ..
        "  addon=" .. tostring(self.addonName)
    )
end

SLASH_FOREVERCOMPANION1 = "/fc"
SLASH_FOREVERCOMPANION2 = "/companion"

SlashCmdList.FOREVERCOMPANION = function(message)
    local command, rest = (message or ""):match("^(%S*)%s*(.-)$")
    command = (command or ""):lower()
    rest = rest or ""

    if command == "stats" then
        FC:ShowStats()
    elseif command == "scan" then
        FC:RunCatchup(true)
    elseif command == "settings" or command == "options" then
        FC:ToggleSettings()
    elseif command == "journal" then
        FC:OpenSettings("Memory")
    elseif command == "history" then
        FC:OpenSettings("Conversation")
    elseif command == "talk" then
        FC:ForceConversation()
    elseif command == "quote" then
        FC:TellQuote()
    elseif command == "riddle" then
        FC:TellRiddle()
    elseif command == "answer" then
        FC:AnswerRiddle(true)
    elseif command == "question" then
        FC:TellQuestion()
    elseif command == "strangefact" then
        FC:TellStrangeFact()
    elseif command == "vocab" then
        if rest and rest ~= "" then FC:TellVocabularyWord(rest) else FC:PrintVocabularyStats() end
    elseif command == "word" or command == "define" or command == "dictionary" then
        FC:TellVocabularyWord(rest)
    elseif command == "vocabquiz" then
        FC:StartVocabularyQuiz(true)
    elseif command == "vocabanswer" then
        FC:AnswerVocabularyQuiz(rest, false)
    elseif command == "root" or command == "wordroot" then
        FC:TellWordRoot()
    elseif command == "trivia" then
        FC:TellTrivia()
    elseif command == "triviaanswer" then
        FC:AnswerTrivia(true)
    elseif command == "proverb" then
        FC:QueueTopic("proverb", {}, 100, 0, true)
    elseif command == "idiom" then
        FC:QueueTopic("idiom", {}, 100, 0, true)
    elseif command == "story" then
        FC:QueueTopic("microstory", {}, 100, 0, true)
    elseif command == "tonguetwister" or command == "twister" then
        FC:QueueTopic("tonguetwister", {}, 100, 0, true)
    elseif command == "learn" then
        FC:TellLearning()
    elseif command == "fact" then
        FC:TellWowFact()
    elseif command == "joke" then
        FC:TellJoke()
    elseif command == "classbanter" then
        FC:TellClassBanter()
    elseif command == "arrival" or command == "hello" then
        local sub = (rest or ""):lower()
        if sub == "zone" then
            local zone = (GetRealZoneText and GetRealZoneText()) or (GetZoneText and GetZoneText()) or FC.state.zone or "Azeroth"
            local text = FC.GetZoneArrivalLine and FC:GetZoneArrivalLine(zone, nil) or nil
            if text then FC:Say(text, "talk", 100, true, { topic = "zonearrival", category = "world", reason = "manual arrival test" }) end
        else
            local text = FC.GetLoginArrivalLine and FC:GetLoginArrivalLine() or nil
            if text then FC:Say(text, "talk", 100, true, { topic = "loginarrival", category = "memory", reason = "manual login greeting test" }) end
        end
    elseif command == "characters" then
        FC:OpenSettings("Characters")
    elseif command == "memoryfix" then
        local name, realm, ready = FC:GetCharacterIdentity()
        if ready then
            local key = FC:ConsolidateCurrentCharacterRecords(name, realm, select(2, UnitClass("player")))
            FC:ActivateCharacterMemory()
            FC:RefreshLiveProfile()
            FC:Debug("Character memory consolidated under " .. tostring(key) .. ".")
        else
            FC:Debug("Character identity is not ready yet. Try /fc memoryfix again in a moment.")
        end
    elseif command == "test" then
        FC:TestScenario(rest ~= "" and rest or "all")
    elseif command == "doctor" then
        FC:RunDoctor()
    elseif command == "why" then
        FC:WhyLastStatement()
    elseif command == "timing" or command == "queue" then
        if FC.TimingDiagnostics then FC:TimingDiagnostics() else FC:Debug("Timing diagnostics unavailable.") end
    elseif command == "variety" then
        if FC.VarietyDiagnostics then FC:VarietyDiagnostics() else FC:Debug("Variety diagnostics unavailable.") end
    elseif command == "repeat" then
        FC:RepeatLastStatement()
    elseif command == "blocklast" then
        FC:BlockLastStatement()
    elseif command == "favlast" then
        FC:FavoriteLastStatement()
    elseif command == "lastsession" then
        FC:ShowLastSession()
    elseif command == "export" then
        FC:OpenMemoryTransfer("export")
    elseif command == "import" then
        FC:OpenMemoryTransfer("import")
    elseif command == "farm" then
        local sub, label = rest:match("^(%S*)%s*(.-)$")
        sub = (sub or ""):lower()
        if sub == "start" then FC:StartGoldFarm(label ~= "" and label or nil, false)
        elseif sub == "stop" then FC:StopGoldFarm(false)
        elseif sub == "reset" then FC:ResetGoldFarm(); FC:Debug("Gold farm session reset.")
        elseif sub == "stats" or sub == "" then FC:ShowGoldFarmStats()
        else FC:Debug("/fc farm start [label] • stop • stats • reset") end
    elseif command == "value" then
        FC:ShowGoldValue(rest)
    elseif command == "questdebug" then
        if FC.QuestDiagnostics then FC:QuestDiagnostics() else FC:Debug("Quest diagnostics are unavailable.") end
    elseif command == "minimap" then
        if FC.ResetMinimapButton then
            FC:ResetMinimapButton()
            FC:Debug("Minimap launcher restored and reset.")
        else
            FC:Debug("Minimap launcher reset is unavailable.")
        end
    elseif command == "proc" then
        local sub, arg = rest:match("^(%S*)%s*(.-)$")
        sub = (sub or ""):lower()
        if sub == "off" then
            FC.db.procAlerts.enabled = false
            FC:Debug("Combat proc callouts disabled.")
        elseif sub == "on" then
            FC.db.procAlerts.enabled = true
            FC:Debug("Combat proc callouts enabled.")
        elseif sub == "list" or sub == "supported" then
            if FC.ScanProcSupport then FC:ScanProcSupport() end
            FC:Debug("Detected proc callouts for " .. tostring(select(2, UnitClass("player")) or "current class") .. ":")
            for line in string.gmatch(FC:GetProcCatalogText(), "[^\n]+") do FC:Debug(line) end
        elseif sub == "scan" then
            local count = FC.ScanProcSupport and FC:ScanProcSupport() or 0
            FC:Debug("Forever client scan complete. Detected " .. tostring(count) .. " supported proc entries for this character:")
            for line in string.gmatch(FC:GetProcCatalogText(), "[^\n]+") do FC:Debug(line) end
        elseif sub == "all" or sub == "catalog" then
            FC:Debug("Full compatibility catalog (not proof these exist on WoW Forever or your character):")
            for line in string.gmatch(FC:GetProcCatalogText(nil, true), "[^\n]+") do FC:Debug(line) end
        elseif sub == "doctor" or sub == "debug" then
            FC:ProcDoctor()
        elseif sub == "reset" then
            FC.db.procAlerts.enabled = true
            FC.db.procAlerts.screenEffect = true
            FC.db.procAlerts.vexaShout = true
            FC.db.procAlerts.sound = true
            FC.db.procAlerts.voiceEnabled = true
            FC.db.procAlerts.respectGameSound = true
            FC.db.procAlerts.customVoicePack = true
            FC.db.procAlerts.ttsFallback = false
            FC.db.procAlerts.hdArt = false
            FC.db.procAlerts.artSize = 300
            FC.db.procAlerts.anyOverlay = true
            FC.db.procAlerts.fallbackDetection = true
            FC.db.procAlerts.strictClientDetection = true
            FC.db.procAlerts.onlyInCombat = false
            FC.db.procAlerts.showSource = false
            FC.db.procAlerts.scale = 1.0
            FC.db.procAlerts.x = 0
            FC.db.procAlerts.y = 140
            FC.db.procAlerts.iconSize = 52
            FC.db.procAlerts.textSize = 28
            FC.db.procAlerts.voiceRate = 0
            FC.db.procAlerts.voiceVolume = 100
            FC.db.procAlerts.duration = 1.45
            FC.state.procAlerts = { lastByKey = {}, active = {}, usable = {}, auras = {}, actions = {} }
            FC:InitializeProcAlerts()
            FC:Debug("Combat Calls reset to defaults.")
        elseif sub == "move" or sub == "unlock" then
            FC:SetProcAlertMoveMode(true)
        elseif sub == "lock" then
            FC:SetProcAlertMoveMode(false)
        elseif sub == "resetpos" then
            FC:ResetProcAlertPosition()
        elseif sub == "voice" then
            local vcmd = (arg or ""):lower()
            if vcmd == "off" then
                FC.db.procAlerts.voiceEnabled = false
                FC:Debug("Spoken combat callouts disabled.")
            elseif vcmd == "on" then
                FC.db.procAlerts.voiceEnabled = true
                FC:Debug("Spoken combat callouts enabled.")
                FC:TestProcVoice()
            elseif vcmd == "next" then
                FC:CycleProcVoice(1); FC:TestProcVoice()
            elseif vcmd == "prev" or vcmd == "previous" then
                FC:CycleProcVoice(-1); FC:TestProcVoice()
            else
                FC:TestProcVoice()
            end
        elseif sub == "voicepack" then
            local vcmd = (arg or ""):lower()
            if vcmd == "on" then
                FC.db.procAlerts.customVoicePack = true
                FC:Debug("Custom Vexa proc voice pack enabled. Media files will be preferred over TTS.")
            elseif vcmd == "off" then
                FC.db.procAlerts.customVoicePack = false
                FC:Debug("Custom Vexa proc voice pack disabled; client TTS will be used when enabled.")
            else
                FC:Debug("Custom Vexa proc voice pack: " .. tostring(FC.db.procAlerts.customVoicePack == true and "ON" or "OFF") .. ". Use /fc proc voicepack on|off")
            end
        elseif sub == "voices" then
            local _, selected, voices = FC:GetProcVoice()
            FC:Debug("Installed combat TTS voices (selected: " .. tostring(selected or "none") .. "):")
            for _, voice in ipairs(voices or {}) do FC:Debug("  " .. tostring(voice.voiceID) .. " — " .. tostring(voice.name)) end
        elseif sub == "test" or sub == "" then
            FC:TestProcAlert(arg ~= "" and arg or nil)
        else
            FC:Debug("/fc proc test [spell] • scan • list • all • move • lock • resetpos • voice [next|prev|on|off] • voicepack [on|off] • voices • doctor • reset • on • off")
        end
    elseif command == "voicepack" then
        local sub, arg = rest:match("^(%S*)%s*(.-)$")
        sub = (sub or ""):lower()
        if sub == "on" then
            FC.db.voicePack.enabled = true
            FC.db.voicePack.eventVoices = true
            FC:Debug("Vexa event voice pack enabled.")
        elseif sub == "off" then
            FC.db.voicePack.enabled = false
            if FC.StopVexaEventVoice then FC:StopVexaEventVoice() end
            FC:Debug("Vexa event voice pack disabled.")
        elseif sub == "events" then
            local v = (arg or ""):lower()
            if v == "off" then FC.db.voicePack.eventVoices = false; FC:Debug("Vexa event voices disabled.")
            elseif v == "on" then FC.db.voicePack.eventVoices = true; FC:Debug("Vexa event voices enabled.")
            else FC:Debug("Event voices: " .. tostring(FC.db.voicePack.eventVoices ~= false and "ON" or "OFF")) end
        elseif sub == "test" then
            FC:TestVexaVoiceCue(arg ~= "" and arg or "interrupt")
        elseif sub == "list" then
            FC:Debug("Vexa event voice cues:")
            for _, cue in ipairs(FC:GetVexaVoiceCueList()) do FC:Debug("  " .. cue .. ".ogg") end
        elseif sub == "doctor" then
            FC:VoicePackDoctor()
        else
            FC:Debug("/fc voicepack on|off • events on|off • test [cue] • list • doctor")
        end
    elseif command == "procs" then
        FC:OpenSettings("Combat Calls")
    elseif command == "dungeon" then
        FC:ShowDungeonIntel()
    elseif command == "dungeonloot" or command == "lootwatch" then
        FC:ShowDungeonLootWatch()
    elseif command == "dungeondebug" then
        FC:DungeonDiagnostics()
    elseif command == "model" then
        FC:OpenSettings("Appearance")
    elseif command == "quiet" then
        FC.db.chatty = 0.15
        FC:QueueTopic("quiet", {}, 100, 0, true)
    elseif command == "chatty" then
        FC.db.chatty = 0.9
        FC:QueueTopic("chatty", {}, 100, 0, true)
    elseif command == "mute" and rest ~= "" then
        FC.db.mutedCategories[rest:lower()] = true
        FC:Debug("Muted commentary category: " .. rest:lower())
    elseif command == "unmute" and rest ~= "" then
        FC.db.mutedCategories[rest:lower()] = nil
        FC:Debug("Unmuted commentary category: " .. rest:lower())
    elseif command == "hide" then
        if FC.frame then FC.frame:Hide() end
    elseif command == "show" then
        if FC.frame then FC.frame:Show() end
    elseif command == "resetpos" then
        FC.db.x = 360
        FC.db.y = 180
        FC:ApplyPosition()
    elseif command == "debug" then
        FC.db.debug = not FC.db.debug
        FC:Debug("debug=" .. tostring(FC.db.debug))
    elseif command == "cap" then
        FC:PrintCapabilities()
    elseif command == "profile" then
        FC:ShowProfile()
    elseif command == "version" then
        FC:PrintVersion()
    else
        FC:ShowHelp()
    end
end
