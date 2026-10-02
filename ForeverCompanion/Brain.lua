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
}

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

local function rememberLine(FC, topic, line)
    FC.state.recentDialogue = FC.state.recentDialogue or {}
    local recent = FC.state.recentDialogue[topic] or {}
    recent[#recent + 1] = line
    while #recent > 12 do table.remove(recent, 1) end
    FC.state.recentDialogue[topic] = recent
end

local function pick(FC, topic, pool)
    if not pool or #pool == 0 then return nil end
    local blocked = FC.db and FC.db.sharedMemory and FC.db.sharedMemory.blockedLines or {}
    local favorites = FC.db and FC.db.sharedMemory and FC.db.sharedMemory.favoriteLines or {}
    local line
    if math.random() < 0.20 then
        local favPool = {}
        for _, candidate in ipairs(pool) do
            if favorites[candidate] and not blocked[candidate] and not recentlyUsed(FC, topic, candidate) then favPool[#favPool + 1] = candidate end
        end
        if #favPool > 0 then line = favPool[math.random(1, #favPool)] end
    end
    for _ = 1, 20 do
        if line then break end
        local candidate = pool[math.random(1, #pool)]
        if not blocked[candidate] and not recentlyUsed(FC, topic, candidate) then line = candidate break end
    end
    if not line then
        for _, candidate in ipairs(pool) do if not blocked[candidate] then line = candidate break end end
    end
    if not line then return nil end
    rememberLine(FC, topic, line)
    return line
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
    local text = self:GetLine(topic, data)
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
    })
end

function FC:QueueSay(text, anim, priority, cooldown, key, force, validator, meta)
    if not text or not self.db.enabled then return end
    key = key or text
    local now = GetTime()
    if not force and now - (self.state.cooldowns[key] or -99999) < (cooldown or 0) then return end
    self.state.cooldowns[key] = now
    meta = meta or { topic = key, category = categoryForTopic(key), facts = type(self.CaptureFacts) == "function" and self:CaptureFacts("queue:" .. tostring(key)) or nil }
    table.insert(self.state.queue, { text = text, anim = anim or "talk", priority = priority or 10, at = now, validator = validator, meta = meta })
    table.sort(self.state.queue, function(a, b) return a.priority > b.priority end)
    while #self.state.queue > 20 do table.remove(self.state.queue) end
end

function FC:CanSpeak(priority, category)
    local runtime = self.state.runtime or {}
    if (runtime.cinematic or runtime.loading) and (priority or 0) < 90 then return false end
    local base = 10 + (1 - (self.db.chatty or 0.5)) * 40
    if category == "warning" then base = 1.25
    elseif (priority or 0) >= 80 then base = 1.25
    elseif (priority or 0) <= 10 then base = base * 1.25 end
    if GetTime() - (self.state.lastSpeak or 0) < base then return false end

    category = category or "ambient"
    self.state.categoryLastSpeak = self.state.categoryLastSpeak or {}
    local categoryGap = categoryMinimums[category] or 12
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
    if not text or (not force and not self:CanSpeak(priority, category)) then return false end
    self.state.lastSpeak = GetTime()
    self.state.categoryLastSpeak = self.state.categoryLastSpeak or {}
    self.state.categoryLastSpeak[category] = GetTime()
    self:SetAnimation(anim or "talk")
    self:ShowBubble(text)
    if meta and meta.topic and type(self.MaybePlayVexaVoiceForTopic) == "function" then
        pcall(self.MaybePlayVexaVoiceForTopic, self, meta.topic, meta)
    end
    if type(self.LogSpeech) == "function" then self:LogSpeech(text, meta) end
    return true
end

function FC:PumpQueue()
    while #self.state.queue > 0 do
        local nextItem = self.state.queue[1]
        if nextItem.validator then
            local ok, valid = pcall(nextItem.validator)
            if not ok or not valid then table.remove(self.state.queue, 1) else break end
        else break end
    end
    local nextItem = self.state.queue[1]
    local category = nextItem and nextItem.meta and nextItem.meta.category or "ambient"
    if nextItem and self:CanSpeak(nextItem.priority, category) then
        table.remove(self.state.queue, 1)
        self:Say(nextItem.text, nextItem.anim, nextItem.priority, true, nextItem.meta)
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
