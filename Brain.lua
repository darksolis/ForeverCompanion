local FC = _G.ForeverCompanion

local topicCategory = {
    level = "xp", xp25 = "xp", xp50 = "xp", xp75 = "xp", xp90 = "xp", nearlevel = "xp", fastpace = "xp", slowpace = "xp", session = "xp", lastsession = "memory", charcallback = "memory", restedxp = "xp",
    questdone = "quests", questpile = "quests", questlevel = "quests", objective = "quests", queststalled = "quests",
    death = "combat", deathpattern = "combat", revive = "combat", lowhealth = "warning", combatwin = "combat", combatquick = "combat", combatlong = "combat", bosskill = "combat", pvpkill = "combat", crit = "combat", healcrit = "combat",
    bags = "warning", bagfull = "warning", repair = "warning", repaired = "world", broken = "warning", nomoney = "world",
    zone = "world", zonebetter = "world", capital = "world", mount = "world", dismount = "world", flightstart = "world", flightland = "world", swim = "world", shore = "world", traveltime = "world", night = "ambient", flightstart = "world", flightland = "world", restenter = "world", longfall = "world", jumpstreak = "ambient", jumpmilestone = "ambient",
    instanceenter = "group", instanceleavewin = "group", instanceleavefail = "group", bgenter = "group", bgwin = "group", bgloss = "group", readycheck = "group", notready = "group", invite = "group", rolechange = "group",
    lootrare = "loot", lootepic = "loot", upgrade = "loot", destroy = "loot", destroyvaluable = "warning", mail = "loot", trade = "world", auction = "world", bank = "world",
    goldstart = "gold", goldstop = "gold", goldstats = "gold", goldvalue = "gold", vendorvalue = "gold", goldpace = "gold",
    ragecap = "class", energycap = "class", manalow = "warning", stealth = "class", pet = "class", talents = "class", talentupdate = "class", skillup = "class",
    idle = "ambient", ambient = "ambient", comeback = "ambient", eat = "ambient", drink = "ambient", campfire = "ambient", barber = "ambient", afk = "ambient", afkreturn = "ambient", dnd = "ambient", dndreturn = "ambient",
    targetelite = "target", targetdanger = "warning", hearth = "world", hearthcombat = "warning", guildjoin = "social", guildleave = "social", logout = "memory",
}

local categoryMinimums = {
    warning = 1.0,
    combat = 7,
    xp = 14,
    quests = 10,
    group = 12,
    loot = 10,
    gold = 8,
    target = 20,
    class = 18,
    world = 14,
    social = 20,
    ambient = 8,
    memory = 20,
    learning = 6,
}

-- Reaction timing policy. Event-driven comments should feel immediate and then disappear
-- if the moment has passed. Ambient/reflective dialogue may live longer in the queue.
local categoryMaxAge = {
    warning = 6,
    combat = 14,
    xp = 45,
    quests = 30,
    group = 18,
    loot = 18,
    gold = 30,
    target = 7,
    class = 8,
    world = 18,
    social = 18,
    ambient = 90,
    memory = 120,
    learning = 180,
}

local topicTiming = {
    -- Immediate UI / town interactions.
    auction = { maxAge = 7, minGap = 0.8, priorityFloor = 76, preempt = true },
    bank = { maxAge = 7, minGap = 1.0, priorityFloor = 64, preempt = true },
    mail = { maxAge = 8, minGap = 1.0, priorityFloor = 60, preempt = true },
    trade = { maxAge = 7, minGap = 1.0, priorityFloor = 60, preempt = true },
    barber = { maxAge = 8, minGap = 1.0, priorityFloor = 55, preempt = true },
    repaired = { maxAge = 8, minGap = 0.8, priorityFloor = 38, preempt = true },
    nomoney = { maxAge = 6, minGap = 0.5, priorityFloor = 55, preempt = true },

    -- Combat / danger moments.
    lowhealth = { maxAge = 4, minGap = 0.25, priorityFloor = 86, preempt = true },
    manalow = { maxAge = 5, minGap = 0.4, priorityFloor = 70, preempt = true },
    ragecap = { maxAge = 5, minGap = 0.5, priorityFloor = 58, preempt = true },
    energycap = { maxAge = 5, minGap = 0.5, priorityFloor = 58, preempt = true },
    targetdanger = { maxAge = 5, minGap = 0.5, priorityFloor = 66, preempt = true },
    targetelite = { maxAge = 6, minGap = 0.8, priorityFloor = 48, preempt = true },
    broken = { maxAge = 7, minGap = 0.5, priorityFloor = 70, preempt = true },
    bagfull = { maxAge = 6, minGap = 0.6, priorityFloor = 62, preempt = true },
    hearthcombat = { maxAge = 4, minGap = 0.4, priorityFloor = 72, preempt = true },
    readycheck = { maxAge = 6, minGap = 0.5, priorityFloor = 52, preempt = true },
    notready = { maxAge = 6, minGap = 0.5, priorityFloor = 55, preempt = true },
    invite = { maxAge = 7, minGap = 0.7, priorityFloor = 46, preempt = true },

    -- Short-lived movement / activity states.
    mount = { maxAge = 8, minGap = 1.0, priorityFloor = 28 },
    dismount = { maxAge = 8, minGap = 1.0, priorityFloor = 28 },
    flightstart = { maxAge = 10, minGap = 1.0, priorityFloor = 30 },
    flightland = { maxAge = 10, minGap = 1.0, priorityFloor = 30 },
    swim = { maxAge = 10, minGap = 1.0, priorityFloor = 26 },
    shore = { maxAge = 10, minGap = 1.0, priorityFloor = 26 },
    eat = { maxAge = 10, minGap = 1.0, priorityFloor = 24 },
    drink = { maxAge = 10, minGap = 1.0, priorityFloor = 24 },
    campfire = { maxAge = 14, minGap = 1.5, priorityFloor = 22 },
    stealth = { maxAge = 10, minGap = 0.8, priorityFloor = 30 },
    restenter = { maxAge = 12, minGap = 1.2, priorityFloor = 24 },
    afk = { maxAge = 12, minGap = 1.0, priorityFloor = 24 },
    afkreturn = { maxAge = 8, minGap = 0.7, priorityFloor = 38, preempt = true },
    dnd = { maxAge = 12, minGap = 1.0, priorityFloor = 22 },
    dndreturn = { maxAge = 8, minGap = 0.8, priorityFloor = 34 },
    hearth = { maxAge = 7, minGap = 0.8, priorityFloor = 38 },

    -- Rewards/progress should be prompt but may wait a few seconds for danger to clear.
    lootepic = { maxAge = 15, minGap = 0.7, priorityFloor = 74, preempt = true },
    lootrare = { maxAge = 14, minGap = 1.0, priorityFloor = 50 },
    upgrade = { maxAge = 16, minGap = 1.0, priorityFloor = 48 },
    questdone = { maxAge = 22, minGap = 1.2, priorityFloor = 44 },
    level = { maxAge = 20, minGap = 0.5, priorityFloor = 90, preempt = true },
    revive = { maxAge = 14, minGap = 0.8, priorityFloor = 52 },
    death = { maxAge = 18, minGap = 0.5, priorityFloor = 84, preempt = true },
    deathpattern = { maxAge = 18, minGap = 0.5, priorityFloor = 88, preempt = true },
    bosskill = { maxAge = 18, minGap = 0.6, priorityFloor = 78, preempt = true },
    pvpkill = { maxAge = 10, minGap = 0.8, priorityFloor = 48 },
    bgwin = { maxAge = 25, minGap = 0.8, priorityFloor = 70 },
    bgloss = { maxAge = 25, minGap = 0.8, priorityFloor = 70 },

    -- Zone/group transitions are meaningful, but stale versions are confusing.
    zone = { maxAge = 24, minGap = 1.0, priorityFloor = 36 },
    capital = { maxAge = 20, minGap = 1.0, priorityFloor = 30 },
    instanceenter = { maxAge = 20, minGap = 0.8, priorityFloor = 62 },
    instanceleavewin = { maxAge = 20, minGap = 0.8, priorityFloor = 58 },
    instanceleavefail = { maxAge = 20, minGap = 0.8, priorityFloor = 58 },
    bgenter = { maxAge = 18, minGap = 0.8, priorityFloor = 54 },
    rolechange = { maxAge = 15, minGap = 1.0, priorityFloor = 36 },

    -- Tiny moments should either land quickly or not at all.
    crit = { maxAge = 3, minGap = 0.7, priorityFloor = 24 },
    healcrit = { maxAge = 3, minGap = 0.7, priorityFloor = 24 },
    combatwin = { maxAge = 10, minGap = 0.8, priorityFloor = 34 },
    combatquick = { maxAge = 10, minGap = 0.8, priorityFloor = 36 },
    combatlong = { maxAge = 12, minGap = 0.8, priorityFloor = 38 },
    destroy = { maxAge = 6, minGap = 0.8, priorityFloor = 30 },
    destroyvaluable = { maxAge = 6, minGap = 0.5, priorityFloor = 68, preempt = true },
    pet = { maxAge = 10, minGap = 1.0, priorityFloor = 28 },
    talents = { maxAge = 15, minGap = 1.0, priorityFloor = 32 },
    talentupdate = { maxAge = 12, minGap = 1.0, priorityFloor = 34 },
    skillup = { maxAge = 15, minGap = 1.0, priorityFloor = 30 },
    longfall = { maxAge = 6, minGap = 0.7, priorityFloor = 30 },
    jumpstreak = { maxAge = 6, minGap = 1.0, priorityFloor = 24 },
    jumpmilestone = { maxAge = 14, minGap = 0.8, priorityFloor = 40 },
    zonebetter = { maxAge = 20, minGap = 1.0, priorityFloor = 34 },
    nearlevel = { maxAge = 20, minGap = 1.0, priorityFloor = 34 },
    questlevel = { maxAge = 20, minGap = 1.0, priorityFloor = 42 },
    idle = { maxAge = 10, minGap = 1.0, priorityFloor = 24 },
    comeback = { maxAge = 8, minGap = 0.7, priorityFloor = 40 },
}

local topicRepeatFloor = {
    -- Low-information behaviors should not comment every time the player repeats them.
    eat = 480, drink = 480, campfire = 900,
    mount = 150, dismount = 150, swim = 240, shore = 240,
    stealth = 150, restenter = 480,
    afk = 300, afkreturn = 180, dnd = 600, dndreturn = 300,
    hearth = 240, mail = 300, bank = 300, auction = 300, trade = 240, barber = 900,
    pet = 300, talents = 300, talentupdate = 240, skillup = 180,
    ragecap = 90, energycap = 90, manalow = 75,
    jumpstreak = 75, longfall = 90,
    targetelite = 90, targetdanger = 75,
    bags = 240, bagfull = 150, repair = 300, repaired = 180, broken = 90,
    readycheck = 90, notready = 90,
}

local function repeatFloorForTopic(topic)
    return topicRepeatFloor[topic] or 0
end

local function timingForTopic(topic, category)
    return topicTiming[topic] or { maxAge = categoryMaxAge[category] or 45 }
end

local function categoryForTopic(topic)
    local category = topicCategory[topic]
    if category then return category end
    if type(topic) == "string" then
        if string.match(topic, "^class_") then return "class" end
        if topic == "questambient" then return "quests" end
        if topic == "goldambient" then return "gold" end
        if topic == "combatambient" then return "combat" end
        if topic == "dungeonambient" then return "group" end
        if topic == "travelambient" or topic == "townambient" or topic == "exploration" or topic == "walking" or topic == "zoneambient" then return "world" end
        if topic == "characterthought" then return "memory" end
    end
    return "ambient"
end


local function commentaryWeight(FC, category)
    local c = FC.db and FC.db.commentary or {}
    if category == "xp" then return tonumber(c.xp) or 1 end
    if category == "quests" then return tonumber(c.quests) or 1 end
    if category == "warning" then return 1 end
    if category == "combat" or category == "class" or category == "target" then return tonumber(c.combat) or 1 end
    if category == "loot" or category == "gold" then return tonumber(c.loot) or 1 end
    if category == "world" or category == "group" or category == "social" or category == "memory" then return tonumber(c.world) or 1 end
    if category == "ambient" then return tonumber(c.jokes) or 1 end
    return 1
end

local function recentlyUsed(FC, topic, line)
    FC.state.recentDialogue = FC.state.recentDialogue or {}
    local recent = FC.state.recentDialogue[topic] or {}
    for _, used in ipairs(recent) do if used == line then return true end end
    return false
end

local function globallyRecent(FC, line)
    for _, used in ipairs(FC.state.globalRecentDialogue or {}) do
        if used == line then return true end
    end
    return false
end

local function dialogueUsage(FC, topic, line)
    FC.state.dialogueUsage = FC.state.dialogueUsage or {}
    FC.state.dialogueUsage[topic] = FC.state.dialogueUsage[topic] or {}
    local stat = FC.state.dialogueUsage[topic][line]
    if not stat then
        stat = { count = 0, lastAt = 0 }
        FC.state.dialogueUsage[topic][line] = stat
    end
    return stat
end

local function rememberLine(FC, topic, line)
    local now = GetTime and GetTime() or 0
    FC.state.recentDialogue = FC.state.recentDialogue or {}
    local recent = FC.state.recentDialogue[topic] or {}
    recent[#recent + 1] = line
    while #recent > 24 do table.remove(recent, 1) end
    FC.state.recentDialogue[topic] = recent

    FC.state.globalRecentDialogue = FC.state.globalRecentDialogue or {}
    FC.state.globalRecentDialogue[#FC.state.globalRecentDialogue + 1] = line
    while #FC.state.globalRecentDialogue > 60 do table.remove(FC.state.globalRecentDialogue, 1) end

    local stat = dialogueUsage(FC, topic, line)
    stat.count = (stat.count or 0) + 1
    stat.lastAt = now
end

-- Prefer unseen lines first, then least-seen lines, then the line that has been absent
-- the longest. This prevents tiny pools from collapsing into their first entry once every
-- line has been seen, while still allowing favorites to get a mild tie-break advantage.
local function pick(FC, topic, pool)
    if not pool or #pool == 0 then return nil end
    local blocked = FC.db and FC.db.sharedMemory and FC.db.sharedMemory.blockedLines or {}
    local favorites = FC.db and FC.db.sharedMemory and FC.db.sharedMemory.favoriteLines or {}
    local eligible = {}
    local minCount = nil

    for _, candidate in ipairs(pool) do
        if candidate and not blocked[candidate] then
            local stat = dialogueUsage(FC, topic, candidate)
            local count = tonumber(stat.count) or 0
            if minCount == nil or count < minCount then minCount = count end
            eligible[#eligible + 1] = { line = candidate, count = count, lastAt = tonumber(stat.lastAt) or 0 }
        end
    end
    if #eligible == 0 then return nil end

    local tier = {}
    for _, item in ipairs(eligible) do
        if item.count == minCount then tier[#tier + 1] = item end
    end

    -- Within the least-used tier, avoid recent topic/global repeats whenever possible.
    local fresh = {}
    for _, item in ipairs(tier) do
        if not recentlyUsed(FC, topic, item.line) and not globallyRecent(FC, item.line) then
            fresh[#fresh + 1] = item
        end
    end
    if #fresh > 0 then tier = fresh end

    -- Favor the oldest half of the remaining tier. This creates natural rotation without
    -- making every session deterministic.
    table.sort(tier, function(a, b)
        if a.lastAt == b.lastAt then
            local af = favorites[a.line] and 1 or 0
            local bf = favorites[b.line] and 1 or 0
            if af ~= bf then return af > bf end
            return tostring(a.line) < tostring(b.line)
        end
        return a.lastAt < b.lastAt
    end)
    local oldestCount = math.max(1, math.ceil(#tier * 0.5))
    local choice = tier[math.random(1, oldestCount)]
    if not choice then return nil end
    rememberLine(FC, topic, choice.line)
    return choice.line
end

function FC:GetLine(topic, data)
    local companionKey = self.db.companion or "Vexa"
    local moodTopic = nil
    if topic == "ambient" and self.state.mood and self.state.mood.name and self.state.mood.name ~= "neutral" and math.random() < 0.35 then
        moodTopic = "mood_" .. tostring(self.state.mood.name)
    end
    local selectedTopic = moodTopic or topic
    local pool = (self.dialogue[companionKey] and self.dialogue[companionKey][selectedTopic]) or (self.dialogue.common and self.dialogue.common[selectedTopic])
    if not pool and selectedTopic ~= topic then
        pool = (self.dialogue[companionKey] and self.dialogue[companionKey][topic]) or (self.dialogue.common and self.dialogue.common[topic])
        selectedTopic = topic
    end
    local template = pick(self, selectedTopic, pool)
    if not template then return nil end

    data = data or {}
    local args
    if topic == "newplayer" then
        args = companionKey == "Vexa"
            and { data.name or "hero", data.level or 0, data.quests or 0, data.complete or 0 }
            or { data.level or 0, data.quests or 0, data.complete or 0 }
    elseif topic == "level" then args = { data.level or 0 }
    elseif topic == "questdone" or topic == "queststalled" then args = { data.title or "that quest" }
    elseif topic == "questpile" or topic == "nearlevel" then args = { data.count or 0 }
    elseif topic == "zone" or topic == "capital" then args = { data.zone or "here" }
    elseif topic == "zonebetter" then args = { data.percent or 0 }
    elseif topic == "bags" then args = { data.free or 0 }
    elseif topic == "repair" or topic == "lowhealth" then args = { data.percent or 0 }
    elseif topic == "objective" then args = { data.title or "that quest", data.current or 0, data.required or 0 }
    elseif topic == "session" then args = { data.xp or "0", data.duration or "0m" }
    elseif topic == "charswitch" then args = { data.name or "hero", data.class or "adventurer", data.previousName or "your other character", data.previousClass or "adventurer" }
    elseif topic == "instanceenter" or topic == "instanceleavewin" or topic == "instanceleavefail" then args = { data.name or "the instance" }
    elseif topic == "pet" or topic == "guildjoin" or topic == "guildleave" then args = { data.name or "that" }
    elseif topic == "lootrare" or topic == "lootepic" or topic == "destroy" or topic == "destroyvaluable" then args = { data.item or "that item" }
    elseif topic == "upgrade" then args = { data.old or 0, data.new or 0 }
    elseif topic == "bosskill" then args = { data.name or "that boss" }
    elseif topic == "targetelite" then args = { data.name or "that target", data.classification or "elite" }
    elseif topic == "deathpattern" then args = { data.count or 0, data.name or "that target" }
    elseif topic == "targetdanger" then args = { data.name or "that target", data.level or 0, data.delta or 0 }
    elseif topic == "lastsession" then args = { data.xp or "0", data.duration or "0m", data.quests or 0, data.deaths or 0, data.startLevel or 0, data.endLevel or 0 }
    elseif topic == "charcallback" then args = { data.name or "that character", data.class or "adventurer", data.xp or "0", data.duration or "0m", data.rate or "0" }
    elseif topic == "restedxp" then args = { data.xp or "0" }
    elseif topic == "rolechange" then args = { data.role or "group" }
    elseif topic == "traveltime" then args = { data.percent or 0 }
    elseif topic == "relationship_name" then args = { data.name or self:GetCurrentPlayerName() or "hero" }
    elseif topic == "characterthought" then args = { data.name or "your other character", data.class or "adventurer", data.level or 0 }
    elseif topic == "zoneambient" then args = { data.zone or self.state.zone or "this place" }
    elseif topic == "personalreflection" then args = { data.name or "hero", data.level or 0, data.class or "adventurer", data.zone or "Azeroth" }
    elseif topic == "jumpmilestone" then args = { data.count or 0 }
    end

    if args then
        local ok, formatted = pcall(string.format, template, unpack(args))
        if ok then return formatted end
    end
    return template
end

function FC:AnimationFor(topic)
    local mapping = {
        level = "celebrate", questdone = "playful", questpile = "point", questlevel = "point", objective = "point", queststalled = "think", nearlevel = "point",
        fastpace = "celebrate", slowpace = "think", death = "angry", deathpattern = "angry", revive = "playful", lowhealth = "worried", zone = "talk", zonebetter = "celebrate",
        bags = "point", bagfull = "worried", repair = "point", repaired = "playful", broken = "worried", idle = "sleep", comeback = "playful",
        newplayer = "talk", charswitch = "playful", rescan = "point", quiet = "shrug", chatty = "playful", ambient = "flirty",
        combatwin = "playful", combatquick = "laugh", combatlong = "think", session = "talk", lastsession = "talk", mount = "playful", dismount = "talk", flightstart = "talk", flightland = "playful", swim = "playful", shore = "talk", traveltime = "think", night = "flirty",
        eat = "talk", drink = "talk", campfire = "flirty", stealth = "think", instanceenter = "point", instanceleavewin = "celebrate", instanceleavefail = "shrug",
        bgenter = "point", bgwin = "celebrate", bgloss = "shrug", pvpkill = "celebrate", crit = "playful", healcrit = "playful", capital = "talk", afk = "sleep", afkreturn = "playful", dnd = "shrug", dndreturn = "talk",
        nomoney = "laugh", hearth = "talk", hearthcombat = "angry", mail = "playful", bank = "think", auction = "think", trade = "talk", barber = "flirty",
        pet = "playful", talents = "think", talentupdate = "point", skillup = "playful", guildjoin = "playful", guildleave = "shrug", restenter = "sleep", ragecap = "point", energycap = "point", manalow = "worried",
        lootrare = "playful", lootepic = "celebrate", upgrade = "celebrate", destroy = "shrug", destroyvaluable = "worried", goldstart = "think", goldstop = "talk", goldstats = "think", goldvalue = "playful", vendorvalue = "talk", goldpace = "think", readycheck = "point", notready = "shrug", rolechange = "point",
        bosskill = "celebrate", longfall = "laugh", jumpstreak = "laugh", jumpmilestone = "playful", targetelite = "think", targetdanger = "worried", logout = "talk", charcallback = "talk", restedxp = "playful", mood_impressed = "flirty", mood_annoyed = "angry", mood_relaxed = "flirty", mood_concerned = "worried", mood_amused = "laugh", mood_focused = "think",
        walking = "talk", exploration = "think", zoneambient = "talk", joke = "laugh", megajoke = "laugh", wowfact = "think", sciencefact = "think", historyfact = "think", famousquote = "talk", curiousquestion = "think", wouldyourather = "playful", minichallenge = "point", deepthought = "think", riddle = "think", riddleanswer = "playful", personalreflection = "talk", relationship = "flirty", relationship_name = "flirty", encourage = "playful", philosophy = "think", questambient = "think", combatambient = "think", townambient = "talk", travelambient = "talk", restambient = "flirty", goldambient = "think", characterthought = "talk",
        languagefact = "think", animalfact = "think", spacefact = "think", geographyfact = "think", mathfact = "think", bodyfact = "think", techfact = "think", foodfact = "talk", naturefact = "think", psychologyfact = "think", oceanfact = "think", weatherfact = "think", inventionfact = "think", artfact = "talk", musicfact = "talk", literaturefact = "talk", mythologyfact = "think", philosophyfact = "think",
        idiom = "talk", proverb = "talk", tonguetwister = "laugh", absurdquestion = "think", microstory = "talk", gamingwisdom = "think", selfaware = "laugh", compliment = "flirty", roast = "laugh", trivia = "think", triviaanswer = "playful", vocabulary = "talk", vocabquiz = "think", wordroot = "think",
    }
    return mapping[topic] or "talk"
end

function FC:QueueTopic(topic, data, priority, cooldown, force, validator)
    local category = categoryForTopic(topic)
    if self.db and self.db.mutedCategories and self.db.mutedCategories[category] and (priority or 0) < 70 then return end
    local weight = commentaryWeight(self, category)
    if not force and (priority or 0) < 70 and weight < 1 and math.random() > weight then return end

    local timing = timingForTopic(topic, category)
    priority = math.max(priority or 10, timing.priorityFloor or 0)
    if not force then
        cooldown = math.max(tonumber(cooldown) or 0, repeatFloorForTopic(topic))
    end

    local fallbackText = self:GetLine(topic, data)
    local personalityVoice = nil
    if type(self.GetPersonalityVoiceForTopic) == "function" then
        local ok, selected = pcall(self.GetPersonalityVoiceForTopic, self, topic, data, false)
        if ok then personalityVoice = selected end
    end
    local text = (personalityVoice and personalityVoice.text) or fallbackText
    if not text then return end
    local facts = type(self.CaptureFacts) == "function" and self:CaptureFacts("queue:" .. tostring(topic)) or nil
    local baseValidator = validator
    local function combinedValidator()
        if baseValidator then
            local ok, valid = pcall(baseValidator)
            if not ok or not valid then return false end
        end
        if type(FC.ValidateStatement) == "function" then
            local ok, valid = pcall(FC.ValidateStatement, FC, topic, data or {}, facts)
            if not ok or not valid then return false end
        end
        return true
    end
    self:QueueSay(text, self:AnimationFor(topic), priority, cooldown, topic, force, combinedValidator, {
        topic = topic,
        data = data or {},
        facts = facts,
        category = category,
        reason = topic,
        maxAge = timing.maxAge,
        minGap = timing.minGap,
        preempt = timing.preempt == true,
        reactive = timing.minGap ~= nil or timing.preempt == true,
        personalityVoice = personalityVoice,
        personalityFallbackText = fallbackText,
    })
end

local function releaseQueuedCooldown(FC, item)
    if not item or not item.key then return end
    if FC.state.cooldowns and FC.state.cooldowns[item.key] == item.at then
        FC.state.cooldowns[item.key] = nil
    end
end

function FC:QueueSay(text, anim, priority, cooldown, key, force, validator, meta)
    if not text or not self.db.enabled then return end
    key = key or text
    local now = GetTime()
    if not force and now - (self.state.cooldowns[key] or -99999) < (cooldown or 0) then return end

    meta = meta or { topic = key, category = categoryForTopic(key), facts = type(self.CaptureFacts) == "function" and self:CaptureFacts("queue:" .. tostring(key)) or nil }
    local category = meta.category or categoryForTopic(key)
    local timing = timingForTopic(meta.topic or key, category)
    if meta.maxAge == nil then meta.maxAge = timing.maxAge or categoryMaxAge[category] or 45 end
    if meta.minGap == nil then meta.minGap = timing.minGap end
    if meta.preempt == nil then meta.preempt = timing.preempt == true end
    meta.enqueuedAt = now
    if type(self.LearningObserveQueued) == "function" then
        pcall(self.LearningObserveQueued, self, text, meta, key)
    end

    self.state.cooldowns[key] = now
    table.insert(self.state.queue, {
        text = text,
        anim = anim or "talk",
        priority = priority or 10,
        at = now,
        expiresAt = now + math.max(1, tonumber(meta.maxAge) or 45),
        validator = validator,
        meta = meta,
        key = key,
        force = force == true,
    })
    table.sort(self.state.queue, function(a, b)
        if a.priority == b.priority then return (a.at or 0) > (b.at or 0) end
        return a.priority > b.priority
    end)
    while #self.state.queue > 20 do
        local removed = table.remove(self.state.queue)
        releaseQueuedCooldown(self, removed)
    end
end

function FC:CanSpeak(priority, category, meta)
    local runtime = self.state.runtime or {}
    if (runtime.cinematic or runtime.loading) and (priority or 0) < 90 then return false end

    -- Protect the bubble currently being read. Queue items stay queued instead of
    -- instantly replacing text. After the minimum read window, only an explicitly
    -- preemptive, higher-priority reaction may interrupt before the normal bubble
    -- lifetime ends. This keeps reactions fast without making messages unreadable.
    local now = GetTime()
    if self.bubble and self.bubble:IsShown() then
        local readLockUntil = tonumber(self.bubble.readLockUntil) or 0
        if now < readLockUntil then return false end

        local bubbleUntil = tonumber(self.bubble.untilTime) or 0
        if now < bubbleUntil then
            local currentPriority = tonumber(self.state.currentSpeechPriority) or 0
            local incomingPriority = tonumber(priority) or 0
            local mayPreempt = meta and meta.preempt == true and incomingPriority > currentPriority
            if not mayPreempt then return false end
        end
    end

    local base = 10 + (1 - (self.db.chatty or 0.5)) * 40
    if category == "warning" then base = 1.25
    elseif (priority or 0) >= 80 then base = 1.25
    elseif (priority or 0) <= 10 then base = base * 1.25 end
    if meta and tonumber(meta.minGap) then base = math.min(base, math.max(0.15, tonumber(meta.minGap))) end
    if GetTime() - (self.state.lastSpeak or 0) < base then return false end

    category = category or "ambient"
    self.state.categoryLastSpeak = self.state.categoryLastSpeak or {}
    local categoryGap = categoryMinimums[category] or 12
    if meta and tonumber(meta.minGap) then categoryGap = math.min(categoryGap, math.max(0.15, tonumber(meta.minGap))) end
    if GetTime() - (self.state.categoryLastSpeak[category] or -99999) < categoryGap then return false end

    local mode = self.state.contextMode or "unknown"
    if mode == "combat" and (category == "ambient" or category == "world" or category == "social" or category == "memory") and (priority or 0) < 70 then
        return false
    end
    if mode == "dead" and category ~= "combat" and category ~= "warning" and (priority or 0) < 70 then return false end
    return true
end

function FC:Say(text, anim, priority, force, meta)
    local category = meta and meta.category or "direct"
    if not text or (not force and not self:CanSpeak(priority, category, meta)) then return false end

    -- A fresh high-value queued reaction may interrupt old ambient/reflective dialogue,
    -- but never during the protected reading window. CanSpeak normally enforces this;
    -- the guard here prevents accidental early replacement from alternate call paths.
    if meta and meta.preempt and self.bubble and self.bubble:IsShown() then
        local currentPriority = tonumber(self.state.currentSpeechPriority) or 0
        local readLockUntil = tonumber(self.bubble.readLockUntil) or 0
        if GetTime() >= readLockUntil and (priority or 0) > currentPriority then
            if self.CancelBubbleSequence then self:CancelBubbleSequence() end
            self.bubble:Hide()
        end
    end

    local personalityPlayed = false
    if meta and meta.personalityVoice and type(self.PlayPersonalityVoiceEntry) == "function" then
        local forceVoice = meta.forcePersonalityVoice == true or (tonumber(priority) or 0) >= 90 or meta.preempt == true
        local ok, played = pcall(self.PlayPersonalityVoiceEntry, self, meta.personalityVoice, {
            force = forceVoice,
            interruptCurrent = forceVoice,
        })
        personalityPlayed = ok and played == true
        if not personalityPlayed and meta.personalityFallbackText then text = meta.personalityFallbackText end
    end

    self.state.lastSpeak = GetTime()
    self.state.categoryLastSpeak = self.state.categoryLastSpeak or {}
    self.state.categoryLastSpeak[category] = GetTime()
    self.state.currentSpeechPriority = priority or 0
    self.state.currentSpeechMeta = meta
    self:SetAnimation(anim or "talk")
    self:ShowBubble(text)
    if not personalityPlayed and meta and meta.topic and type(self.MaybePlayVexaVoiceForTopic) == "function" then
        pcall(self.MaybePlayVexaVoiceForTopic, self, meta.topic, meta)
    end
    if type(self.LogSpeech) == "function" then self:LogSpeech(text, meta) end
    if type(self.LearningObserveSpeech) == "function" then
        pcall(self.LearningObserveSpeech, self, text, meta)
    end
    return true
end

function FC:PumpQueue()
    local now = GetTime()

    -- Purge expired or no-longer-true statements anywhere in the queue, not only at the head.
    -- This is the key safeguard against an AH/bank/mount/etc. line appearing long after the event.
    for i = #self.state.queue, 1, -1 do
        local item = self.state.queue[i]
        local expired = item.expiresAt and now > item.expiresAt
        local valid = true
        if not expired and item.validator then
            local ok, result = pcall(item.validator)
            valid = ok and result == true
        end
        if expired or not valid then
            table.remove(self.state.queue, i)
            releaseQueuedCooldown(self, item)
            if type(self.LearningObserveDrop) == "function" then
                pcall(self.LearningObserveDrop, self, item, expired and "expired" or "context no longer true")
            end
        end
    end

    if #self.state.queue == 0 then return end
    table.sort(self.state.queue, function(a, b)
        if a.priority == b.priority then return (a.at or 0) > (b.at or 0) end
        return a.priority > b.priority
    end)

    local nextItem = self.state.queue[1]
    local category = nextItem and nextItem.meta and nextItem.meta.category or "ambient"
    if nextItem and self:CanSpeak(nextItem.priority, category, nextItem.meta) then
        table.remove(self.state.queue, 1)
        self:Say(nextItem.text, nextItem.anim, nextItem.priority, true, nextItem.meta)
    end
end

function FC:DropQueuedTopic(topic)
    if not topic then return 0 end
    local removed = 0
    for i = #(self.state.queue or {}), 1, -1 do
        local item = self.state.queue[i]
        local itemTopic = item.meta and item.meta.topic or item.key
        if itemTopic == topic then
            table.remove(self.state.queue, i)
            releaseQueuedCooldown(self, item)
            removed = removed + 1
        end
    end
    return removed
end

function FC:TimingDiagnostics()
    local now = GetTime()
    if self.bubble and self.bubble:IsShown() then
        local hold = math.max(0, (tonumber(self.bubble.readLockUntil) or 0) - now)
        local life = math.max(0, (tonumber(self.bubble.untilTime) or 0) - now)
        self:Debug(string.format("Current bubble: read-lock %.1fs | lifetime %.1fs | priority %d", hold, life, tonumber(self.state.currentSpeechPriority) or 0))
    end
    self:Debug("Timing queue: " .. tostring(#(self.state.queue or {})) .. " pending item(s).")
    for i, item in ipairs(self.state.queue or {}) do
        local topic = item.meta and item.meta.topic or item.key or "?"
        local age = now - (item.at or now)
        local ttl = item.expiresAt and math.max(0, item.expiresAt - now) or -1
        self:Debug(string.format("  %d. %s | p=%d | age=%.1fs | ttl=%.1fs", i, tostring(topic), tonumber(item.priority) or 0, age, ttl))
    end
end

function FC:Thought()
    if not self.db.enabled then return end
    if type(self.IsDungeonContext) == "function" and self:IsDungeonContext() and self.db.dungeon and self.db.dungeon.enabled ~= false then
        if type(self.DungeonThought) == "function" then self:DungeonThought(false) end
        return
    end
    local snapshot = self.state.questSnapshot or {}
    if snapshot.complete and snapshot.complete >= 4 then
        local expectedCount = snapshot.complete
        self:QueueTopic("questpile", { count = expectedCount }, 10, 300, false, function()
            return FC.state.questSnapshot and FC.state.questSnapshot.complete == expectedCount
        end)
        return
    end

    local travelShare = type(self.GetTravelShare) == "function" and self:GetTravelShare() or 0
    if self:SessionSeconds() > 600 and travelShare >= 0.50 and (self.state.sessionXP or 0) > 0 then
        self:QueueTopic("traveltime", { percent = math.floor(travelShare * 100) }, 6, 900)
        return
    end

    local remaining, rate, seconds, fights = self:Estimate()
    if fights and fights <= 8 then self:QueueTopic("nearlevel", { count = fights }, 12, 240); return end

    local roll = math.random(1, 6)
    if roll == 1 and rate > 0 and seconds and seconds < 5400 then
        if self:CanSpeak(7, "xp") then
            local text = string.format("Current pace is %s XP/hour. Roughly %s to level.", self:FormatNumber(rate), self:FormatDuration(seconds))
            self:Say(text, "think", 7, true, { topic = "pace", category = "xp", facts = self:CaptureFacts("pace"), reason = "live XP pace" })
        end
    elseif roll == 2 and (self.state.sessionXP or 0) > 0 then
        self:QueueTopic("session", { xp = self:FormatNumber(self.state.sessionXP or 0), duration = self:FormatDuration(self:SessionSeconds()) }, 6, 420)
    elseif roll == 3 and remaining and remaining > 0 and remaining < 2500 then
        local factKey = self:CurrentXPFactKey()
        self:QueueSay("You're very close now. Stay on task and finish the level.", "point", 9, 420, "closepush", false, function()
            return factKey == FC:CurrentXPFactKey() and FC:XPRemaining() > 0 and FC:XPRemaining() < 2500
        end, { topic = "closepush", category = "xp", facts = self:CaptureFacts("closepush"), reason = "XP remaining under 2500" })
    elseif roll == 4 and type(self.FindStalledQuest) == "function" then
        local title = self:FindStalledQuest(600)
        if title then
            self:QueueTopic("queststalled", { title = title }, 7, 900)
        elseif type(self.MaybeConversation) == "function" then
            self:MaybeConversation(false)
        else
            self:QueueTopic("ambient", {}, 5, 180)
        end
    elseif type(self.MaybeConversation) == "function" then
        self:MaybeConversation(false)
    else
        self:QueueTopic("ambient", {}, 5, 180)
    end
end
