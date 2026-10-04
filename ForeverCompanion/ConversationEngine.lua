local FC = _G.ForeverCompanion

local function safe(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if ok then return a, b, c, d end
    return nil
end

local function pushWeighted(list, topic, weight, data)
    weight = math.max(0, math.floor(weight or 1))
    for _ = 1, weight do
        list[#list + 1] = { topic = topic, data = data }
    end
end

function FC:GetCurrentClassToken()
    local profile = self.character and self.character.memory and self.character.memory.profile or nil
    if profile and profile.classToken then return profile.classToken end
    local _, token = safe(UnitClass, "player")
    return token
end

function FC:GetCurrentPlayerName()
    local profile = self.character and self.character.memory and self.character.memory.profile or nil
    if profile and profile.name and profile.name ~= "Unknown" then return profile.name end
    local name = safe(UnitName, "player")
    return name or "hero"
end

function FC:GetOtherRememberedCharacter()
    local characters = self.db and self.db.sharedMemory and self.db.sharedMemory.characters or nil
    if not characters then return nil end
    local candidates = {}
    for key, info in pairs(characters) do
        if key ~= self.characterKey and info and info.name then
            candidates[#candidates + 1] = info
        end
    end
    if #candidates == 0 then return nil end
    return candidates[math.random(1, #candidates)]
end

function FC:ConversationTopicAllowed(topic)
    local c = self.db and self.db.conversation or {}
    if topic == "wowfact" and c.facts == false then return false end
    if (topic == "sciencefact" or topic == "historyfact") and c.strangeFacts == false then return false end
    if topic == "famousquote" and c.quotes == false then return false end
    if topic == "riddle" and c.riddles == false then return false end
    if (topic == "curiousquestion" or topic == "wouldyourather") and c.questions == false then return false end
    if topic == "minichallenge" and c.challenges == false then return false end
    if topic == "deepthought" and c.deepThoughts == false then return false end
    if (topic == "joke" or topic == "megajoke") and c.jokes == false then return false end
    if topic == "walking" and c.walking == false then return false end
    if string.match(topic or "", "^class_") and c.classBanter == false then return false end
    if topic == "characterthought" and c.memoryBanter == false then return false end
    if (topic == "vocabword" or topic == "vocabquiz") and c.vocabulary == false then return false end
    if topic == "vocabquiz" and c.vocabQuizzes == false then return false end
    if topic == "wordroot" and c.wordRoots == false then return false end
    if topic == "trivia" and c.trivia == false then return false end
    if (topic == "idiom" or topic == "proverb" or topic == "tonguetwister") and c.languagePlay == false then return false end
    if (topic == "languagefact" or topic == "animalfact" or topic == "spacefact" or topic == "geographyfact" or topic == "mathfact" or topic == "bodyfact" or topic == "techfact" or topic == "foodfact" or topic == "naturefact" or topic == "psychologyfact" or topic == "oceanfact" or topic == "weatherfact" or topic == "inventionfact" or topic == "artfact" or topic == "musicfact" or topic == "literaturefact" or topic == "mythologyfact" or topic == "philosophyfact") and c.expandedFacts == false then return false end
    if (topic == "absurdquestion" or topic == "microstory" or topic == "gamingwisdom") and c.creativePrompts == false then return false end
    if topic == "selfaware" and c.metaBanter == false then return false end
    if topic == "compliment" and c.compliments == false then return false end
    if topic == "roast" and c.roasts == false then return false end
    if topic == "dungeonambient" and self.db and self.db.dungeon and self.db.dungeon.chatter == false then return false end
    return true
end

function FC:RememberConversationTopic(topic)
    local now = GetTime()
    self.state.recentConversationTopics = self.state.recentConversationTopics or {}
    local recent = self.state.recentConversationTopics
    recent[#recent + 1] = topic
    while #recent > 18 do table.remove(recent, 1) end

    self.state.conversationTopicUsage = self.state.conversationTopicUsage or {}
    local stat = self.state.conversationTopicUsage[topic] or { count = 0, lastAt = 0 }
    stat.count = (stat.count or 0) + 1
    stat.lastAt = now
    self.state.conversationTopicUsage[topic] = stat
end

function FC:ConversationTopicRecentlyUsed(topic)
    for _, recent in ipairs(self.state.recentConversationTopics or {}) do
        if recent == topic then return true end
    end
    return false
end

-- BuildConversationChoices encodes a topic's base importance by inserting duplicate rows.
-- Collapse those duplicates here, then apply a novelty penalty to topics that have already
-- dominated this session. Context still matters, but unused categories get a real chance.
function FC:ChooseConversationChoice(choices)
    if not choices or #choices == 0 then return nil end
    self.state.conversationTopicUsage = self.state.conversationTopicUsage or {}

    local grouped, order = {}, {}
    for _, choice in ipairs(choices) do
        local key = tostring(choice.topic)
        local entry = grouped[key]
        if not entry then
            entry = { topic = choice.topic, data = choice.data, baseWeight = 0 }
            grouped[key] = entry
            order[#order + 1] = entry
        end
        entry.baseWeight = entry.baseWeight + 1
    end

    local now = GetTime()
    local total = 0
    for _, entry in ipairs(order) do
        local stat = self.state.conversationTopicUsage[entry.topic] or { count = 0, lastAt = 0 }
        local count = tonumber(stat.count) or 0
        local since = now - (tonumber(stat.lastAt) or 0)
        local novelty = 1 / (1 + count * 0.75)
        if count == 0 then novelty = novelty * 2.4 end
        local recency = 1
        if since < 120 then recency = 0.15
        elseif since < 300 then recency = 0.45
        elseif since < 600 then recency = 0.75 end
        entry.weight = math.max(0.01, entry.baseWeight * novelty * recency)
        total = total + entry.weight
    end

    if total <= 0 then return order[math.random(1, #order)] end
    local roll = math.random() * total
    local running = 0
    for _, entry in ipairs(order) do
        running = running + entry.weight
        if roll <= running then return entry end
    end
    return order[#order]
end

function FC:BuildConversationChoices()
    local choices = {}
    local runtime = self.state.runtime or {}
    local mode = self.state.contextMode or "exploring"
    local classToken = self:GetCurrentClassToken()

    pushWeighted(choices, "relationship", 3)
    pushWeighted(choices, "relationship_name", 2, { name = self:GetCurrentPlayerName() })
    local profile = self.character and self.character.memory and self.character.memory.profile or {}
    pushWeighted(choices, "personalreflection", 3, {
        name = self:GetCurrentPlayerName(),
        class = profile.class or (select(1, safe(UnitClass, "player")) or "adventurer"),
        level = profile.level or (safe(UnitLevel, "player") or 0),
        zone = self.state.zone or profile.zone or "Azeroth",
    })
    pushWeighted(choices, "joke", 2)
    pushWeighted(choices, "megajoke", 5)
    pushWeighted(choices, "wowfact", 2)
    pushWeighted(choices, "sciencefact", 3)
    pushWeighted(choices, "historyfact", 2)
    pushWeighted(choices, "famousquote", 3)
    pushWeighted(choices, "curiousquestion", 3)
    pushWeighted(choices, "wouldyourather", 3)
    pushWeighted(choices, "minichallenge", 1)
    pushWeighted(choices, "deepthought", 3)
    if not self.state.pendingRiddle and not self.state.pendingTrivia and not self.state.pendingVocabularyQuiz then pushWeighted(choices, "riddle", 2) end

    -- Expanded learning / entertainment library. The weights are intentionally spread out so
    -- Vexa rotates through categories instead of turning every quiet moment into trivia class.
    pushWeighted(choices, "languagefact", 2)
    pushWeighted(choices, "animalfact", 2)
    pushWeighted(choices, "spacefact", 2)
    pushWeighted(choices, "geographyfact", 1)
    pushWeighted(choices, "mathfact", 1)
    pushWeighted(choices, "bodyfact", 1)
    pushWeighted(choices, "techfact", 2)
    pushWeighted(choices, "foodfact", 1)
    pushWeighted(choices, "naturefact", 2)
    pushWeighted(choices, "psychologyfact", 1)
    pushWeighted(choices, "oceanfact", 1)
    pushWeighted(choices, "weatherfact", 1)
    pushWeighted(choices, "inventionfact", 1)
    pushWeighted(choices, "artfact", 1)
    pushWeighted(choices, "musicfact", 1)
    pushWeighted(choices, "literaturefact", 1)
    pushWeighted(choices, "mythologyfact", 1)
    pushWeighted(choices, "philosophyfact", 1)
    pushWeighted(choices, "idiom", 1)
    pushWeighted(choices, "proverb", 1)
    pushWeighted(choices, "tonguetwister", 1)
    pushWeighted(choices, "absurdquestion", 2)
    pushWeighted(choices, "microstory", 1)
    pushWeighted(choices, "gamingwisdom", 2)
    pushWeighted(choices, "selfaware", 1)
    pushWeighted(choices, "compliment", 1)
    pushWeighted(choices, "roast", 2)
    pushWeighted(choices, "vocabword", 3)
    pushWeighted(choices, "wordroot", 1)
    if not self.state.pendingVocabularyQuiz and not self.state.pendingRiddle and not self.state.pendingTrivia then pushWeighted(choices, "vocabquiz", 1) end
    if not self.state.pendingTrivia and not self.state.pendingRiddle and not self.state.pendingVocabularyQuiz then pushWeighted(choices, "trivia", 1) end

    pushWeighted(choices, "philosophy", 2)
    pushWeighted(choices, "encourage", 2)
    pushWeighted(choices, "exploration", 2)
    if self.state.zone and self.state.zone ~= "" and self.state.zone ~= "Unknown" then
        pushWeighted(choices, "zoneambient", 3, { zone = self.state.zone })
    end

    if runtime.moving and not runtime.mounted and not runtime.onTaxi then
        pushWeighted(choices, "walking", 6)
    end

    if mode == "traveling" or mode == "taxi" or runtime.mounted or runtime.onTaxi then
        pushWeighted(choices, "travelambient", 6)
    elseif mode == "town_chores" then
        pushWeighted(choices, "townambient", 7)
    elseif mode == "resting" then
        pushWeighted(choices, "restambient", 6)
    elseif mode == "instance" then
        pushWeighted(choices, "dungeonambient", 10)
        pushWeighted(choices, "combatambient", 4)
    elseif mode == "questing" then
        pushWeighted(choices, "questambient", 6)
    elseif mode == "exploring" then
        pushWeighted(choices, "exploration", 5)
    end

    if mode ~= "instance" and (self.state.questSnapshot and (self.state.questSnapshot.active or 0) > 0) then
        pushWeighted(choices, "questambient", 3)
    end

    if self.state.gold and self.state.gold.active then
        pushWeighted(choices, "goldambient", 6)
    end

    if classToken and self.dialogue.Vexa["class_" .. classToken] then
        pushWeighted(choices, "class_" .. classToken, 5)
    end

    local other = self:GetOtherRememberedCharacter()
    if other then
        pushWeighted(choices, "characterthought", 2, {
            name = other.name or "your other character",
            class = other.class or "adventurer",
            level = other.level or 0,
        })
    end

    if GetTime() - (self.state.lastCombatEnd or 0) < 90 then
        pushWeighted(choices, "combatambient", 3)
    end

    local filtered = {}
    for _, choice in ipairs(choices) do
        if self:ConversationTopicAllowed(choice.topic) and not self:ConversationTopicRecentlyUsed(choice.topic) then
            filtered[#filtered + 1] = choice
        end
    end
    if #filtered > 0 then return filtered end

    for _, choice in ipairs(choices) do
        if self:ConversationTopicAllowed(choice.topic) then filtered[#filtered + 1] = choice end
    end
    return filtered
end

function FC:NextConversationDelay()
    local c = self.db and self.db.conversation or {}
    local frequency = tonumber(c.frequency) or 0.85
    frequency = math.max(0.05, math.min(1.0, frequency))
    local chatty = tonumber(self.db and self.db.chatty) or 0.75
    local combined = math.max(0.05, math.min(1.0, (frequency * 0.70) + (chatty * 0.30)))

    -- High settings are intentionally very active: about 10-25 seconds.
    -- Low settings still back off substantially.
    local minimum = 4 + (1 - combined) * 45
    local maximum = 12 + (1 - combined) * 95
    return math.random(math.floor(minimum), math.floor(maximum))
end

function FC:MaybeConversation(force)
    if not self.db or not self.db.enabled then return false end
    local c = self.db.conversation or {}
    if c.enabled == false then return false end

    local runtime = self.state.runtime or {}
    if self.state.inCombat or self.state.contextMode == "dead" or runtime.cinematic or runtime.loading then return false end

    local now = GetTime()
    if not force and now < (self.state.nextConversationAt or 0) then return false end
    self.state.nextConversationAt = now + self:NextConversationDelay()

    if not force then
        local frequency = tonumber(c.frequency) or 0.85
        if frequency < 0.35 and math.random() > math.max(0.20, frequency + 0.20) then return false end
    end

    -- Do not overwrite a bubble that is still being read with low-priority chatter.
    if not force and self.bubble and self.bubble:IsShown() and not self.bubble.pinned then
        self.state.nextConversationAt = math.max(self.state.nextConversationAt or 0, now + 4)
        return false
    end

    local choices = self:BuildConversationChoices()
    if #choices == 0 then return false end
    local choice = self:ChooseConversationChoice(choices)
    if not choice then return false end
    self:RememberConversationTopic(choice.topic)

    if choice.topic == "riddle" and type(self.StartRiddle) == "function" then
        return self:StartRiddle(false)
    elseif choice.topic == "trivia" and type(self.StartTrivia) == "function" then
        return self:StartTrivia(false)
    elseif choice.topic == "vocabword" and type(self.TellVocabularyWord) == "function" then
        return self:TellVocabularyWord(nil)
    elseif choice.topic == "vocabquiz" and type(self.StartVocabularyQuiz) == "function" then
        return self:StartVocabularyQuiz(false)
    elseif choice.topic == "wordroot" and type(self.TellWordRoot) == "function" then
        return self:TellWordRoot()
    end

    local priority = force and 100 or 4
    local cooldown = force and 0 or 10
    self:QueueTopic(choice.topic, choice.data or {}, priority, cooldown, force)
    return true
end

function FC:ConversationTick(elapsed)
    self.state.conversationTick = (self.state.conversationTick or 0) + (elapsed or 0)
    if self.state.conversationTick < 1 then return end
    self.state.conversationTick = 0

    if type(self.RiddleTick) == "function" then self:RiddleTick() end
    if type(self.TriviaTick) == "function" then self:TriviaTick() end
    if type(self.VocabularyTick) == "function" then self:VocabularyTick() end
    if not self.db or not self.db.enabled then return end
    if self.state.inCombat or self.state.contextMode == "dead" then return end

    local runtime = self.state.runtime or {}
    if runtime.cinematic or runtime.loading then return end

    if not self.state.nextConversationAt or self.state.nextConversationAt <= 0 then
        self.state.nextConversationAt = GetTime() + math.random(8, 18)
        return
    end

    if GetTime() >= self.state.nextConversationAt then
        self:MaybeConversation(false)
    end
end

function FC:ForceConversation()
    if not self:MaybeConversation(true) then
        self:Say("I have nothing useful to add right this second. Enjoy the silence while it lasts.", "shrug", 100, true, {
            topic = "direct", category = "ambient", reason = "manual conversation request",
        })
    end
end

function FC:TellWowFact()
    self:QueueTopic("wowfact", {}, 100, 0, true)
end

function FC:TellJoke()
    self:QueueTopic("joke", {}, 100, 0, true)
end

function FC:TellClassBanter()
    local token = self:GetCurrentClassToken()
    local topic = token and ("class_" .. token) or nil
    if topic and self.dialogue.Vexa[topic] then
        self:QueueTopic(topic, {}, 100, 0, true)
    else
        self:ForceConversation()
    end
end

function FC:TellQuote()
    self:QueueTopic("famousquote", {}, 100, 0, true)
end

function FC:TellQuestion()
    local topics = { "curiousquestion", "wouldyourather", "absurdquestion" }
    self:QueueTopic(topics[math.random(1, #topics)], {}, 100, 0, true)
end

function FC:TellStrangeFact()
    local topics = {
        "sciencefact", "historyfact", "languagefact", "animalfact", "spacefact",
        "geographyfact", "mathfact", "bodyfact", "techfact", "foodfact", "naturefact", "psychologyfact",
        "oceanfact", "weatherfact", "inventionfact", "artfact", "musicfact", "literaturefact", "mythologyfact", "philosophyfact",
    }
    self:QueueTopic(topics[math.random(1, #topics)], {}, 100, 0, true)
end

function FC:TellLearning()
    local options = { "vocab", "root", "trivia", "fact", "idiom", "proverb" }
    local pick = options[math.random(1, #options)]
    if pick == "vocab" then return self:TellVocabularyWord(nil)
    elseif pick == "root" then return self:TellWordRoot()
    elseif pick == "trivia" then return self:StartTrivia(true)
    elseif pick == "idiom" then return self:QueueTopic("idiom", {}, 100, 0, true)
    elseif pick == "proverb" then return self:QueueTopic("proverb", {}, 100, 0, true)
    else return self:TellStrangeFact() end
end

function FC:PrintVocabularyStats()
    local total, pools = self:RefreshVocabularyStats()
    local riddles = type(self.BuildRiddleBank) == "function" and #(self:BuildRiddleBank() or {}) or 0
    local trivia = type(self.BuildTriviaBank) == "function" and #(self:BuildTriviaBank() or {}) or 0
    local lexicon = #(self.lexicon or {})
    local roots = #(self.wordRoots or {})
    local learning = type(self.VocabularySummary) == "function" and self:VocabularySummary() or (tostring(lexicon) .. " dictionary entries")
    self:Debug("Vexa library: " .. tostring(total or 0) .. " dialogue variants across " .. tostring(pools or 0) .. " topic pools + " .. tostring(riddles) .. " riddles + " .. tostring(trivia) .. " trivia variants. Learning: " .. learning .. ".")
end
