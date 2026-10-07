local FC = _G.ForeverCompanion

local function nowGame()
    if type(GetTime) == "function" then
        local ok, v = pcall(GetTime)
        if ok and type(v) == "number" then return v end
    end
    return 0
end

local function nowEpoch()
    if type(time) == "function" then
        local ok, v = pcall(time)
        if ok and type(v) == "number" then return v end
    end
    return 0
end

local function trim(s, maxLen)
    s = tostring(s or "")
    s = s:gsub("[\r\n]+", " "):gsub("%s+", " ")
    if maxLen and #s > maxLen then return s:sub(1, maxLen - 3) .. "..." end
    return s
end

local function safeProfile(FC)
    local p = type(FC.RefreshLiveProfile) == "function" and FC:RefreshLiveProfile() or {}
    return {
        name = trim(p and p.name or "?", 48),
        class = trim(p and p.class or "?", 32),
        level = tonumber(p and p.level) or 0,
        zone = trim((FC.state and FC.state.zone) or (p and p.zone) or "?", 80),
        mode = trim((FC.state and FC.state.contextMode) or "unknown", 32),
    }
end

local coverageEvents = {
    PLAYER_LEVEL_UP = true,
    PLAYER_DEAD = true,
    PLAYER_ALIVE = true,
    ZONE_CHANGED_NEW_AREA = true,
    QUEST_TURNED_IN = true,
    BOSS_KILL = true,
    ENCOUNTER_START = true,
    ENCOUNTER_END = true,
    READY_CHECK = true,
    AUCTION_HOUSE_SHOW = true,
    AUCTION_HOUSE_CLOSED = true,
    BANKFRAME_OPENED = true,
    BANKFRAME_CLOSED = true,
    MAIL_SHOW = true,
    MAIL_CLOSED = true,
    MERCHANT_SHOW = true,
    MERCHANT_CLOSED = true,
    TRADE_SHOW = true,
    TRADE_CLOSED = true,
    BAG_UPDATE_DELAYED = true,
    PLAYER_EQUIPMENT_CHANGED = true,
    UPDATE_INVENTORY_DURABILITY = true,
    PARTY_INVITE_REQUEST = true,
    PLAYER_PVP_KILLS_CHANGED = true,
    UPDATE_BATTLEFIELD_STATUS = true,
}

function FC:InitializeLearningLab()
    if not self.db then return end
    self.db.learningLab = self.db.learningLab or {}
    local db = self.db.learningLab
    if db.enabled == nil then db.enabled = true end
    db.issues = db.issues or {}
    db.eventStats = db.eventStats or {}
    db.manualCaptures = db.manualCaptures or {}
    db.totalObserved = tonumber(db.totalObserved) or 0
    db.totalSpeech = tonumber(db.totalSpeech) or 0

    self.state.learningLab = self.state.learningLab or {
        events = {},
        speech = {},
        lineSeen = {},
        topicSeen = {},
        pendingCoverage = {},
        badgeCount = 0,
    }
    self:CreateLearningReportUI()
    self:RefreshLearningBadge()
end

function FC:LearningEnabled()
    return self.db and self.db.learningLab and self.db.learningLab.enabled ~= false
end

function FC:LearningContextSnapshot(reason)
    local p = safeProfile(self)
    local q = self.state and self.state.questSnapshot or {}
    local gold = self.state and self.state.goldFarm or nil
    local runtime = self.state and self.state.runtime or {}
    return {
        reason = trim(reason or "snapshot", 40),
        at = nowEpoch(),
        name = p.name,
        class = p.class,
        level = p.level,
        zone = p.zone,
        mode = p.mode,
        inCombat = self.state and self.state.inCombat == true or false,
        questsActive = tonumber(q.active) or 0,
        questsComplete = tonumber(q.complete) or 0,
        auctionOpen = runtime.auctionOpen == true,
        bankOpen = runtime.bankOpen == true,
        mailOpen = runtime.mailOpen == true,
        tradeOpen = runtime.tradeOpen == true,
        moving = runtime.moving == true,
        mounted = runtime.mounted == true,
        goldFarm = gold and gold.active == true or false,
    }
end

local function issueFingerprint(kind, data)
    data = data or {}
    if kind == "repeat_line" then return kind .. "|" .. trim(data.line, 180) end
    if kind == "late_reaction" then return kind .. "|" .. trim(data.topic, 60) end
    if kind == "shallow_rotation" then return kind .. "|" .. trim(data.topic, 60) end
    if kind == "dropped_reaction" then return kind .. "|" .. trim(data.topic, 60) .. "|" .. trim(data.reason, 20) end
    if kind == "manual_missed" then return kind .. "|" .. tostring(data.at or nowEpoch()) end
    if kind == "bad_reaction" then return kind .. "|" .. trim(data.line, 180) end
    return tostring(kind) .. "|" .. trim(data.topic or data.event or data.line or "general", 120)
end

function FC:RecordLearningIssue(kind, data)
    if not self:LearningEnabled() then return end
    data = data or {}
    local db = self.db.learningLab
    db.issues = db.issues or {}
    local fp = issueFingerprint(kind, data)
    local found = nil
    for _, item in ipairs(db.issues) do
        if item.fingerprint == fp then found = item; break end
    end
    if found then
        found.count = (tonumber(found.count) or 1) + 1
        found.lastAt = nowEpoch()
        found.data = data
    else
        db.issues[#db.issues + 1] = {
            fingerprint = fp,
            kind = tostring(kind or "unknown"),
            count = 1,
            firstAt = nowEpoch(),
            lastAt = nowEpoch(),
            data = data,
        }
        while #db.issues > 120 do table.remove(db.issues, 1) end
    end
    if self.state.learningLab then
        self.state.learningLab.badgeCount = (self.state.learningLab.badgeCount or 0) + 1
    end
    self:RefreshLearningBadge()
end

function FC:LearningObserveEvent(event)
    if not self:LearningEnabled() then return end
    local lab = self.state.learningLab
    if not lab then return end
    local t = nowGame()
    lab.events[#lab.events + 1] = {
        t = t,
        event = tostring(event or "?"),
        context = tostring(self.state.contextMode or "unknown"),
        zone = trim(self.state.zone or "?", 64),
        covered = false,
    }
    while #lab.events > 100 do table.remove(lab.events, 1) end

    local db = self.db.learningLab
    db.totalObserved = (tonumber(db.totalObserved) or 0) + 1
    if coverageEvents[event] then
        db.eventStats[event] = db.eventStats[event] or { count = 0, covered = 0 }
        db.eventStats[event].count = (tonumber(db.eventStats[event].count) or 0) + 1
        lab.pendingCoverage[#lab.pendingCoverage + 1] = { event = event, t = t, credited = false }
        while #lab.pendingCoverage > 40 do table.remove(lab.pendingCoverage, 1) end
    end
end

function FC:LearningObserveQueued(text, meta, key)
    if not self:LearningEnabled() then return end
    local lab = self.state.learningLab
    if not lab then return end
    local topic = tostring((meta and meta.topic) or key or "direct")
    lab.topicSeen[topic] = lab.topicSeen[topic] or { queued = 0, spoken = 0, unique = {} }
    lab.topicSeen[topic].queued = (lab.topicSeen[topic].queued or 0) + 1
end

function FC:LearningObserveDrop(item, reason)
    if not self:LearningEnabled() or not item then return end
    local topic = tostring(item.meta and item.meta.topic or item.key or "?")
    local age = math.max(0, nowGame() - (tonumber(item.at) or nowGame()))
    -- A few dropped reactions are healthy. Only surface patterns or high-value stale drops.
    local important = tonumber(item.priority or 0) >= 55
    if important or age >= 5 then
        self:RecordLearningIssue("dropped_reaction", {
            topic = topic,
            reason = tostring(reason or "dropped"),
            age = math.floor(age * 10 + 0.5) / 10,
            priority = tonumber(item.priority) or 0,
            line = trim(item.text, 220),
            context = self:LearningContextSnapshot("drop"),
        })
    end
end

function FC:LearningObserveSpeech(text, meta)
    if not self:LearningEnabled() then return end
    local lab = self.state.learningLab
    if not lab then return end
    local t = nowGame()
    local topic = tostring(meta and meta.topic or "direct")
    local clean = trim(text, 300)
    local delay = meta and meta.enqueuedAt and math.max(0, t - meta.enqueuedAt) or 0

    self.db.learningLab.totalSpeech = (tonumber(self.db.learningLab.totalSpeech) or 0) + 1
    lab.speech[#lab.speech + 1] = { t = t, topic = topic, line = clean, delay = delay }
    while #lab.speech > 80 do table.remove(lab.speech, 1) end

    lab.lineSeen[clean] = lab.lineSeen[clean] or { count = 0, first = t, last = 0, topic = topic }
    local ls = lab.lineSeen[clean]
    local previous = ls.last or 0
    ls.count = (ls.count or 0) + 1
    ls.last = t
    if ls.count >= 2 and previous > 0 and (t - previous) < 1800 then
        self:RecordLearningIssue("repeat_line", {
            topic = topic,
            line = clean,
            count = ls.count,
            repeatGap = math.floor(t - previous),
            context = self:LearningContextSnapshot("repeat"),
        })
    end

    lab.topicSeen[topic] = lab.topicSeen[topic] or { queued = 0, spoken = 0, unique = {} }
    local ts = lab.topicSeen[topic]
    ts.spoken = (ts.spoken or 0) + 1
    ts.unique[clean] = true
    local unique = 0
    for _ in pairs(ts.unique) do unique = unique + 1 end
    if ts.spoken >= 6 and unique <= 2 then
        self:RecordLearningIssue("shallow_rotation", {
            topic = topic,
            spoken = ts.spoken,
            unique = unique,
            context = self:LearningContextSnapshot("rotation"),
        })
    end

    if meta and (meta.reactive or meta.preempt) and delay > 6 then
        self:RecordLearningIssue("late_reaction", {
            topic = topic,
            delay = math.floor(delay * 10 + 0.5) / 10,
            line = clean,
            context = self:LearningContextSnapshot("late"),
        })
    end

    -- Treat a reaction within four seconds as approximate coverage for meaningful recent events.
    for _, pending in ipairs(lab.pendingCoverage or {}) do
        if not pending.credited and (t - (pending.t or t)) >= 0 and (t - (pending.t or t)) <= 4 then
            local stat = self.db.learningLab.eventStats[pending.event]
            if stat then stat.covered = (tonumber(stat.covered) or 0) + 1 end
            pending.credited = true
        end
    end
end

function FC:CaptureLearningMoment(reason)
    if not self:LearningEnabled() then return end
    local lab = self.state.learningLab
    local recent = {}
    local t = nowGame()
    for _, e in ipairs(lab.events or {}) do
        if t - (e.t or 0) <= 15 then
            recent[#recent + 1] = string.format("-%.1fs %s [%s]", t - (e.t or t), tostring(e.event), tostring(e.context or "?"))
        end
    end
    local last = self.state.lastSpeech
    local capture = {
        at = nowEpoch(),
        reason = tostring(reason or "manual"),
        context = self:LearningContextSnapshot(reason or "manual"),
        recentEvents = recent,
        lastLine = last and trim(last.text, 260) or "none",
        lastTopic = last and tostring(last.topic or "direct") or "none",
    }
    self.db.learningLab.manualCaptures[#self.db.learningLab.manualCaptures + 1] = capture
    while #self.db.learningLab.manualCaptures > 30 do table.remove(self.db.learningLab.manualCaptures, 1) end
    self:RecordLearningIssue("manual_missed", capture)
    if self.learningReportStatus then self.learningReportStatus:SetText("Captured the last 15 seconds of context.") end
    self:RefreshLearningBadge()
end

function FC:FlagLastReactionBad()
    local last = self.state.lastSpeech
    if not last then
        if self.learningReportStatus then self.learningReportStatus:SetText("Vexa has not spoken yet this session.") end
        return
    end
    self:RecordLearningIssue("bad_reaction", {
        topic = tostring(last.topic or "direct"),
        line = trim(last.text, 300),
        context = self:LearningContextSnapshot("bad reaction"),
    })
    if self.learningReportStatus then self.learningReportStatus:SetText("Marked Vexa's last reaction for review.") end
end

local function issueLine(item)
    local d = item.data or {}
    local detail = ""
    if item.kind == "repeat_line" then
        detail = string.format("topic=%s gap=%ss line=%q", tostring(d.topic), tostring(d.repeatGap or "?"), trim(d.line, 180))
    elseif item.kind == "late_reaction" then
        detail = string.format("topic=%s delay=%ss line=%q", tostring(d.topic), tostring(d.delay or "?"), trim(d.line, 180))
    elseif item.kind == "shallow_rotation" then
        detail = string.format("topic=%s spoken=%s unique=%s", tostring(d.topic), tostring(d.spoken), tostring(d.unique))
    elseif item.kind == "dropped_reaction" then
        detail = string.format("topic=%s reason=%s age=%ss p=%s line=%q", tostring(d.topic), tostring(d.reason), tostring(d.age), tostring(d.priority), trim(d.line, 160))
    elseif item.kind == "bad_reaction" then
        detail = string.format("topic=%s line=%q", tostring(d.topic), trim(d.line, 200))
    elseif item.kind == "manual_missed" then
        detail = string.format("zone=%s mode=%s last=%q", tostring(d.context and d.context.zone or "?"), tostring(d.context and d.context.mode or "?"), trim(d.lastLine, 160))
    else
        detail = trim(d.line or d.topic or d.event or "", 220)
    end
    return string.format("[%s] x%d %s", tostring(item.kind), tonumber(item.count) or 1, detail)
end

function FC:BuildLearningReport()
    self:InitializeLearningLab()
    local db = self.db.learningLab
    local lab = self.state.learningLab
    local p = safeProfile(self)
    local lines = {}
    lines[#lines + 1] = "FOREVER COMPANION - VEXA LEARNING REPORT"
    lines[#lines + 1] = "version=" .. tostring(self.version) .. " schema=" .. tostring(self.schema)
    lines[#lines + 1] = string.format("character=%s class=%s level=%d zone=%s context=%s", p.name, p.class, p.level, p.zone, p.mode)
    lines[#lines + 1] = string.format("session_seconds=%d observed_events=%d spoken_lines=%d stored_issues=%d manual_captures=%d",
        math.floor(nowGame() - (self.startTime or nowGame())), tonumber(db.totalObserved) or 0, tonumber(db.totalSpeech) or 0,
        #(db.issues or {}), #(db.manualCaptures or {}))
    lines[#lines + 1] = ""

    lines[#lines + 1] = "=== REPORT-WORTHY OBSERVATIONS ==="
    if #(db.issues or {}) == 0 then
        lines[#lines + 1] = "none"
    else
        local start = math.max(1, #db.issues - 59)
        for i = start, #db.issues do lines[#lines + 1] = issueLine(db.issues[i]) end
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "=== EVENT COVERAGE CANDIDATES ==="
    local coverage = {}
    for event, stat in pairs(db.eventStats or {}) do
        local count = tonumber(stat.count) or 0
        local covered = tonumber(stat.covered) or 0
        if count >= 3 then
            coverage[#coverage + 1] = { event = event, count = count, covered = covered, ratio = count > 0 and covered / count or 0 }
        end
    end
    table.sort(coverage, function(a, b)
        if a.ratio == b.ratio then return a.count > b.count end
        return a.ratio < b.ratio
    end)
    if #coverage == 0 then
        lines[#lines + 1] = "not enough repeated events yet"
    else
        for i = 1, math.min(25, #coverage) do
            local x = coverage[i]
            lines[#lines + 1] = string.format("%s count=%d reaction_within_4s=%d coverage=%d%%", x.event, x.count, x.covered, math.floor(x.ratio * 100 + 0.5))
        end
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "=== SESSION TOPIC ROTATION ==="
    local topics = {}
    for topic, stat in pairs(lab.topicSeen or {}) do
        local unique = 0
        for _ in pairs(stat.unique or {}) do unique = unique + 1 end
        topics[#topics + 1] = { topic = topic, queued = tonumber(stat.queued) or 0, spoken = tonumber(stat.spoken) or 0, unique = unique }
    end
    table.sort(topics, function(a, b) return a.spoken > b.spoken end)
    if #topics == 0 then lines[#lines + 1] = "none yet" end
    for i = 1, math.min(30, #topics) do
        local x = topics[i]
        lines[#lines + 1] = string.format("%s queued=%d spoken=%d unique_lines=%d", x.topic, x.queued, x.spoken, x.unique)
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "=== RECENT VEXA SPEECH ==="
    local speechStart = math.max(1, #(lab.speech or {}) - 29)
    if #(lab.speech or {}) == 0 then lines[#lines + 1] = "none" end
    for i = speechStart, #(lab.speech or {}) do
        local s = lab.speech[i]
        lines[#lines + 1] = string.format("[%s delay=%.1fs] %s", tostring(s.topic), tonumber(s.delay) or 0, trim(s.line, 260))
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "=== RECENT GAME EVENTS ==="
    local eventStart = math.max(1, #(lab.events or {}) - 49)
    if #(lab.events or {}) == 0 then lines[#lines + 1] = "none" end
    local t = nowGame()
    for i = eventStart, #(lab.events or {}) do
        local e = lab.events[i]
        lines[#lines + 1] = string.format("-%.1fs %s context=%s zone=%s", math.max(0, t - (e.t or t)), tostring(e.event), tostring(e.context), tostring(e.zone))
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "=== MANUAL MISSED-MOMENT CAPTURES ==="
    local cStart = math.max(1, #(db.manualCaptures or {}) - 9)
    if #(db.manualCaptures or {}) == 0 then lines[#lines + 1] = "none" end
    for i = cStart, #(db.manualCaptures or {}) do
        local c = db.manualCaptures[i]
        lines[#lines + 1] = string.format("capture #%d reason=%s zone=%s mode=%s last_topic=%s last_line=%q",
            i, tostring(c.reason), tostring(c.context and c.context.zone or "?"), tostring(c.context and c.context.mode or "?"), tostring(c.lastTopic), trim(c.lastLine, 200))
        for _, ev in ipairs(c.recentEvents or {}) do lines[#lines + 1] = "  " .. ev end
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "Paste this entire report into ChatGPT when improving Forever Companion."
    return table.concat(lines, "\n")
end

local function makeButton(parent, text, width, callback)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(width or 120, 26)
    local bg = b:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.19, 0.10, 0.27, 0.96)
    b.FCBG = bg
    local fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fs:SetPoint("CENTER")
    fs:SetText(text)
    b.FCText = fs
    b:SetScript("OnEnter", function(self) self.FCBG:SetColorTexture(0.35, 0.16, 0.48, 0.98) end)
    b:SetScript("OnLeave", function(self) self.FCBG:SetColorTexture(0.19, 0.10, 0.27, 0.96) end)
    b:SetScript("OnClick", function() if callback then callback() end end)
    return b
end

function FC:CreateLearningReportUI()
    if self.learningReportFrame then return self.learningReportFrame end
    if not UIParent or type(CreateFrame) ~= "function" then return nil end

    local frame = CreateFrame("Frame", "ForeverCompanionLearningReport", UIParent)
    self.learningReportFrame = frame
    frame:SetSize(760, 570)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 10)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(f) f:StartMoving() end)
    frame:SetScript("OnDragStop", function(f) f:StopMovingOrSizing() end)

    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.025, 0.018, 0.04, 0.985)
    local top = frame:CreateTexture(nil, "ARTWORK")
    top:SetPoint("TOPLEFT", 0, 0); top:SetPoint("TOPRIGHT", 0, 0); top:SetHeight(3)
    top:SetColorTexture(0.82, 0.28, 0.72, 1)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 18, -16)
    title:SetText("Vexa Learning Report")
    title:SetTextColor(1, 0.52, 0.86)

    local desc = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -7)
    desc:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -18, -42)
    desc:SetJustifyH("LEFT")
    desc:SetText("Vexa quietly records repetition, late/stale reactions, coverage gaps, and recent gameplay context. Generate the report, press Ctrl+C, then paste it into ChatGPT.")

    local status = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.learningReportStatus = status
    status:SetPoint("TOPLEFT", 18, -76)
    status:SetTextColor(0.72, 0.76, 0.90)
    status:SetText("No commands required.")

    local scroll = CreateFrame("ScrollFrame", nil, frame)
    scroll:SetPoint("TOPLEFT", 18, -106)
    scroll:SetPoint("BOTTOMRIGHT", -18, 62)

    local edit = CreateFrame("EditBox", nil, scroll)
    self.learningReportEditBox = edit
    edit:SetMultiLine(true)
    edit:SetAutoFocus(false)
    if edit.SetFontObject then edit:SetFontObject(ChatFontNormal or GameFontHighlightSmall) end
    edit:SetWidth(680)
    if edit.SetTextInsets then edit:SetTextInsets(8, 8, 8, 8) end
    edit:SetScript("OnEscapePressed", function(e) e:ClearFocus() end)
    edit:SetScript("OnTextChanged", function(e)
        local h = e.GetStringHeight and e:GetStringHeight() or 400
        e:SetHeight(math.max(420, h + 30))
    end)
    scroll:SetScrollChild(edit)
    if scroll.EnableMouseWheel then
        scroll:EnableMouseWheel(true)
        scroll:SetScript("OnMouseWheel", function(s, delta)
            local cur = s:GetVerticalScroll() or 0
            local maxScroll = math.max(0, (edit:GetHeight() or 0) - (s:GetHeight() or 0))
            s:SetVerticalScroll(math.max(0, math.min(maxScroll, cur - delta * 48)))
        end)
    end

    local generate = makeButton(frame, "Generate + Select", 142, function()
        local text = FC:BuildLearningReport()
        edit:SetText(text)
        edit:SetFocus()
        edit:HighlightText()
        status:SetText("Report selected. Press Ctrl+C, then paste it into ChatGPT.")
        if FC.state.learningLab then FC.state.learningLab.badgeCount = 0 end
        FC:RefreshLearningBadge()
    end)
    generate:SetPoint("BOTTOMLEFT", 18, 18)

    local missed = makeButton(frame, "Missed something", 130, function()
        FC:CaptureLearningMoment("user marked missed interaction")
    end)
    missed:SetPoint("LEFT", generate, "RIGHT", 8, 0)

    local bad = makeButton(frame, "Bad last reaction", 130, function()
        FC:FlagLastReactionBad()
    end)
    bad:SetPoint("LEFT", missed, "RIGHT", 8, 0)

    local clear = makeButton(frame, "Clear report data", 120, function()
        FC.db.learningLab.issues = {}
        FC.db.learningLab.manualCaptures = {}
        FC.db.learningLab.eventStats = {}
        FC.db.learningLab.totalObserved = 0
        FC.db.learningLab.totalSpeech = 0
        FC.state.learningLab.events = {}
        FC.state.learningLab.speech = {}
        FC.state.learningLab.lineSeen = {}
        FC.state.learningLab.topicSeen = {}
        FC.state.learningLab.pendingCoverage = {}
        FC.state.learningLab.badgeCount = 0
        edit:SetText("")
        status:SetText("Learning report data cleared.")
        FC:RefreshLearningBadge()
    end)
    clear:SetPoint("LEFT", bad, "RIGHT", 8, 0)

    local close = makeButton(frame, "Close", 78, function() frame:Hide() end)
    close:SetPoint("BOTTOMRIGHT", -18, 18)

    frame:Hide()
    return frame
end

function FC:CreateLearningBadge()
    -- RC47: reporting is intentionally settings-only. Never attach a report
    -- button or notification badge to Vexa's on-screen companion frame.
    if self.learningBadge then
        self.learningBadge:Hide()
    end
    return nil
end

function FC:RefreshLearningBadge()
    -- Keep this method because the learning engine calls it when new issues are
    -- recorded. The report count is surfaced only inside Settings.
    if self.learningBadge then self.learningBadge:Hide() end
end

function FC:OpenLearningReport()
    self:InitializeLearningLab()
    local frame = self.learningReportFrame or self:CreateLearningReportUI()
    if not frame then return end
    if self.learningReportEditBox then
        self.learningReportEditBox:SetText(self:BuildLearningReport())
        self.learningReportEditBox:ClearFocus()
    end
    if self.learningReportStatus then
        self.learningReportStatus:SetText("Click Generate + Select when you are ready to copy the report.")
    end
    frame:Show()
end
