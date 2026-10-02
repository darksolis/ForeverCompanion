local FC = _G.ForeverCompanion

local function addResult(results, name, ok, detail)
    results[#results + 1] = { name = name, ok = ok and true or false, detail = detail }
end

function FC:RunTestSuite()
    local results = {}

    addResult(results, "character key", type(self.characterKey) == "string" and self.characterKey ~= "" and not tostring(self.characterKey):match("::Unknown$"), self.characterKey)

    local liveClass = UnitClass and select(1, UnitClass("player")) or nil
    local profileClass = self.db and self.db.memory and self.db.memory.profile and self.db.memory.profile.class
    addResult(results, "profile class matches live", not liveClass or not profileClass or liveClass == profileClass, tostring(profileClass) .. " vs " .. tostring(liveClass))

    addResult(results, "98% rejects halfway", self:MilestoneMatchesProgress("xp50", 0.98) == false, "xp50@98%=false")
    addResult(results, "98% accepts 90%", self:MilestoneMatchesProgress("xp90", 0.98) == true, "xp90@98%=true")

    addResult(results, "speech bubble", self.bubble ~= nil and self.bubbleText ~= nil, self.bubble and "created" or "missing")
    addResult(results, "renderer", self.state.renderer ~= nil, tostring(self.state.renderer))
    addResult(results, "fact capture", type(self.CaptureFacts) == "function", nil)
    addResult(results, "doctor", type(self.RunDoctor) == "function", nil)
    addResult(results, "context", type(self.HandleContextEvent) == "function", nil)
    addResult(results, "integrations", type(self.RefreshIntegrations) == "function", nil)
    addResult(results, "memory export", type(self.ExportMemoryText) == "function" and type(self.ImportMemoryText) == "function", nil)
    addResult(results, "bubble anchoring", type(self.ReanchorBubble) == "function", nil)
    addResult(results, "gold tracker", type(self.StartGoldFarm) == "function" and type(self.GetItemPriceSnapshot) == "function", nil)
    addResult(results, "gold formatter", self:FormatMoneyCopper(123456) == "12g 34s 56c", self:FormatMoneyCopper(123456))
    local vocab, vocabPools = self:RefreshVocabularyStats()
    local riddles = type(self.BuildRiddleBank) == "function" and #(self:BuildRiddleBank() or {}) or 0
    local trivia = type(self.BuildTriviaBank) == "function" and #(self:BuildTriviaBank() or {}) or 0
    addResult(results, "conversation vocabulary", (vocab or 0) >= 18000, tostring(vocab) .. " variants / " .. tostring(vocabPools) .. " pools")
    addResult(results, "learning lexicon", #(self.lexicon or {}) >= 400 and #(self.wordRoots or {}) >= 75, tostring(#(self.lexicon or {})) .. " words / " .. tostring(#(self.wordRoots or {})) .. " roots")
    addResult(results, "riddle library", riddles >= 2000, tostring(riddles))
    addResult(results, "trivia library", trivia >= 1200, tostring(trivia))
    addResult(results, "conversation engine", type(self.MaybeConversation) == "function" and type(self.ForceConversation) == "function", nil)
    addResult(results, "proc callouts", type(self.InitializeProcAlerts) == "function" and type(self.HandleProcOverlay) == "function" and type(self.ProcTick) == "function", nil)
    addResult(results, "dungeon intelligence", type(self.IsDungeonContext) == "function" and type(self.ScanDungeonLoot) == "function" and type(self.ShowDungeonIntel) == "function", nil)

    addResult(results, "secret-value guard", type(self.CanAccessValue) == "function" and type(self.ReadableNumber) == "function", type(canaccessvalue) == "function" and "native secret API present" or "fallback mode")

    local passed = 0
    for _, result in ipairs(results) do if result.ok then passed = passed + 1 end end
    self.state.lastTestResults = results
    self:Debug(string.format("Test Lab: %d/%d checks passed.", passed, #results))
    for _, result in ipairs(results) do
        self:Debug((result.ok and "PASS " or "FAIL ") .. result.name .. (result.detail and (" — " .. tostring(result.detail)) or ""))
    end
    return passed == #results, results
end

function FC:TestScenario(name)
    name = tostring(name or ""):lower()
    local scenarios = {
        xp98 = { "At 98%, I should only consider you in the final stretch — never halfway.", "point" },
        death = { "[TEST] That went badly. The real death event would use live combat facts.", "angry" },
        elite = { "[TEST] Elite target detected. I would warn you based on the live target level and classification.", "worried" },
        loot = { "[TEST] Rare or epic loot reaction. The live version reads item quality from your loot message.", "celebrate" },
        bags = { "[TEST] Bag-space warning. Live warnings are rechecked before I speak.", "point" },
        boss = { "[TEST] Boss kill reaction and instance memory.", "celebrate" },
        class = { "[TEST] Class-aware power reaction. Warrior rage, energy caps, and low mana use live power data.", "think" },
        bubble = { "[TEST] Speech bubble layout check: this sentence is intentionally long enough to wrap across multiple lines without leaving the bubble.", "talk" },
        gold = { "[TEST] Gold-farm tracker is available. Live loot uses vendor value plus Auctionator scan data when Auctionator is loaded.", "think" },
        conversation = { "[TEST] Conversation engine sample. The live selector weighs walking, class, quest, memory, gold, jokes, facts, and current context.", "talk" },
        proc = { "[TEST] Combat proc alert. The live version listens for the client's proc glow and conditional ability readiness.", "angry" },
        dungeon = { "[TEST] Dungeon mode suppresses turn-in reminders and prioritizes bosses, group flow, and class-compatible loot.", "think" },
    }

    if name == "all" then
        self:RunTestSuite()
        self:Say("Test suite complete. Check chat for PASS/FAIL details.", "talk", 100, true)
        return
    end

    local scenario = scenarios[name]
    if not scenario then
        self:Debug("Test scenarios: xp98, death, elite, loot, bags, boss, class, bubble, gold, conversation, proc, dungeon, all")
        return
    end
    if name == "proc" and self.TestProcAlert then
        self:TestProcAlert()
        return
    end
    self:Say(scenario[1], scenario[2], 100, true)
end

function FC:RunDoctor()
    local facts = self:CaptureFacts("doctor")
    local missing = {}
    local required = {
        "CreateUI", "CreateSettings", "CreateMinimapButton", "QueueTopic", "CaptureFacts",
        "HandleContextEvent", "RunTestSuite", "RefreshIntegrations", "FinalizeSession",
        "ExportMemoryText", "ImportMemoryText", "OpenMemoryTransfer", "ReanchorBubble", "WhyLastStatement",
        "StartGoldFarm", "TrackLootValue", "ShowGoldFarmStats", "GetItemPriceSnapshot",
        "MaybeConversation", "ForceConversation", "RefreshVocabularyStats", "TellVocabularyWord", "StartVocabularyQuiz", "StartTrivia",
        "InitializeProcAlerts", "HandleProcOverlay", "ProcTick", "ShowProcAlert",
        "IsDungeonContext", "ScanDungeonLoot", "ShowDungeonIntel", "ShowDungeonLootWatch",
    }
    for _, name in ipairs(required) do
        if type(self[name]) ~= "function" then missing[#missing + 1] = name end
    end

    local clientVersion, clientBuild, clientDate, clientInterface = nil, nil, nil, nil
    if type(GetBuildInfo) == "function" then
        local ok, a, b, c, d = pcall(GetBuildInfo)
        if ok then clientVersion, clientBuild, clientDate, clientInterface = a, b, c, d end
    end
    self:Debug("Doctor: version=" .. tostring(self.version) .. " schema=" .. tostring(self.schema) .. " client=" .. tostring(clientVersion) .. " interface=" .. tostring(clientInterface))
    self:Debug("Doctor: character=" .. tostring(self.characterKey) .. " renderer=" .. tostring(self.state.renderer) .. " queue=" .. tostring(#(self.state.queue or {})))
    local restricted = nil
    if C_Secrets and type(C_Secrets.HasSecretRestrictions) == "function" then
        local ok, value = pcall(C_Secrets.HasSecretRestrictions)
        if ok then restricted = value end
    end
    self:Debug("Doctor: secretAPI=" .. tostring(type(canaccessvalue) == "function" or type(issecretvalue) == "function") .. " restrictions=" .. tostring(restricted))
    local vocab, vocabPools = self:RefreshVocabularyStats()
    local riddles = type(self.BuildRiddleBank) == "function" and #(self:BuildRiddleBank() or {}) or 0
    local trivia = type(self.BuildTriviaBank) == "function" and #(self:BuildTriviaBank() or {}) or 0
    self:Debug("Doctor: library=" .. tostring(vocab or 0) .. " dialogue / " .. tostring(vocabPools or 0) .. " pools / " .. tostring(riddles) .. " riddles / " .. tostring(trivia) .. " trivia / " .. tostring(#(self.lexicon or {})) .. " dictionary words / " .. tostring(#(self.wordRoots or {})) .. " roots")
    self:Debug("Doctor facts: " .. self:FactsToText(facts))
    self:Debug("Integrations: " .. self:IntegrationSummary())
    if self.state.lastTaint then self:Debug("Last taint: " .. tostring(self.state.lastTaint)) end
    if #missing > 0 then
        self:Debug("Doctor FAIL missing: " .. table.concat(missing, ", "))
        return false
    end
    self:Debug("Doctor PASS: required systems present.")
    return true
end
