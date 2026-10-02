local FC = _G.ForeverCompanion

local STATIC = {
    { "What has keys but cannot open locks?", "A piano." },
    { "What gets wetter the more it dries?", "A towel." },
    { "What has hands but cannot clap?", "A clock." },
    { "What has a neck but no head?", "A bottle." },
    { "What has one eye but cannot see?", "A needle." },
    { "What has many teeth but cannot bite?", "A comb." },
    { "What can travel around the world while staying in one corner?", "A stamp." },
    { "What goes up but never comes down?", "Your age." },
    { "What has words but never speaks?", "A book." },
    { "What has a thumb and four fingers but is not alive?", "A glove." },
    { "What has a head and a tail but no body?", "A coin." },
    { "What has lots of eyes but cannot see?", "A potato." },
    { "What has legs but does not walk?", "A table." },
    { "What kind of room has no doors or windows?", "A mushroom." },
    { "What can fill a room but takes up no space?", "Light." },
    { "What belongs to you but other people use it more than you do?", "Your name." },
    { "The more you take, the more you leave behind. What are they?", "Footsteps." },
    { "What can you catch but not throw?", "A cold." },
    { "What can run but never walks, has a mouth but never talks?", "A river." },
    { "What comes down but never goes up?", "Rain." },
    { "What has cities but no houses, forests but no trees, and water but no fish?", "A map." },
    { "What can be broken without being held?", "A promise." },
    { "What begins with T, ends with T, and has T in it?", "A teapot." },
    { "What has an end but no beginning, a home but no family?", "A keyboard's End and Home keys." },
    { "What has branches but no fruit, trunk, or leaves?", "A bank." },
    { "What has 13 hearts but no organs?", "A deck of cards." },
    { "What can you hold in your left hand but never in your right hand?", "Your right elbow." },
    { "What is always in front of you but cannot be seen?", "The future." },
    { "What goes through towns and over hills but never moves?", "A road." },
    { "What kind of coat is always wet when you put it on?", "A coat of paint." },
    { "What can be cracked, made, told, and played?", "A joke." },
    { "What is full of holes but still holds water?", "A sponge." },
    { "What has four wheels and flies?", "A garbage truck." },
    { "What is easy to lift but hard to throw?", "A feather." },
    { "What has a ring but no finger?", "A telephone." },
    { "What gets bigger the more you take away from it?", "A hole." },
    { "What has a bed but never sleeps?", "A river." },
    { "What has a bark but no bite?", "A tree." },
    { "What has a foot on each side and one in the middle?", "A yardstick." },
    { "What has many needles but does not sew?", "A pine tree." },
    { "What kind of band never plays music?", "A rubber band." },
    { "What building has the most stories?", "A library." },
    { "What is black when clean and white when dirty?", "A chalkboard." },
    { "What has one head, one foot, and four legs?", "A bed." },
    { "What has a bottom at the top?", "Your legs." },
    { "What is so fragile that saying its name breaks it?", "Silence." },
    { "What can be seen once in a minute, twice in a moment, and never in a thousand years?", "The letter M." },
    { "What word becomes shorter when you add two letters to it?", "Short." },
    { "What starts with E, ends with E, and contains one letter?", "An envelope." },
    { "What has a face and two hands but no arms or legs?", "A clock." },
    { "What invention lets you look right through a wall?", "A window." },
    { "What is always coming but never arrives?", "Tomorrow." },
    { "What can you serve but never eat?", "A tennis ball." },
    { "What goes up and down but does not move?", "A staircase." },
    { "What has no life but can die?", "A battery." },
    { "What has a spine but no bones?", "A book." },
    { "What kind of tree can you carry in your hand?", "A palm." },
    { "What is orange and sounds like a parrot?", "A carrot." },
    { "What has ears but cannot hear?", "A cornfield." },
    { "What has a tongue but cannot taste?", "A shoe." },
    { "What runs all around a backyard but never moves?", "A fence." },
    { "What gets lost every time you stand up?", "Your lap." },
    { "What kind of cup cannot hold water?", "A cupcake." },
    { "What can jump higher than a building?", "Anything that can jump; buildings cannot jump." },
    { "Which weighs more: a pound of feathers or a pound of iron?", "They weigh the same: one pound." },
    { "If two is company and three is a crowd, what are four and five?", "Nine." },
    { "What comes once in a year, twice in a week, but never in a day?", "The letter E." },
    { "If you drop me I'm sure to crack, but smile at me and I'll smile back. What am I?", "A mirror." },
    { "What can you keep after giving it to someone?", "Your word." },
    { "What has no beginning, end, or middle?", "A circle." },
    { "What has a mouth but cannot eat?", "A river." },
    { "What is at the end of a rainbow?", "The letter W." },
    { "What has many locks but no doors?", "Hair." },
    { "What can be measured but has no length, width, or height?", "Temperature." },
    { "What kind of lion never roars?", "A dandelion." },
    { "What gets sharper the more you use it?", "Your mind." },
    { "What is yours to keep until you share it?", "A secret." },
    { "What has a crown but is not a king?", "A tooth." },
    { "What goes around a tree but never enters the woods?", "The bark." },
    { "What can be heard but not seen or touched?", "A sound." },
    { "What has pages but is not a book?", "A calendar." },
    { "What has an eye but no face?", "A storm." },
    { "What kind of ship has two mates but no captain?", "A relationship." },
    { "What can you make that nobody can see?", "Noise." },
    { "What has roots nobody sees and is taller than trees, yet never grows?", "A mountain." },
    { "What is lighter than a feather but difficult to hold for long?", "Your breath." },
    { "What is always old and sometimes new, never sad and sometimes blue?", "The Moon." },
    { "What can be opened but has no door?", "A conversation." },
    { "What can fall but never needs help getting up?", "Night." },
    { "What goes from Z to A?", "A zebra." },
    { "What has six faces and twenty-one eyes but cannot see?", "A die." },
    { "What has a heart that does not beat?", "An artichoke." },
    { "What is tall when young and short when old?", "A candle." },
    { "What goes up when rain comes down?", "An umbrella." },
    { "What can you hear but not see, and it only answers when spoken to?", "An echo." },
    { "What kind of table has no legs?", "A timetable." },
    { "What is made of water but disappears in water?", "Ice." },
    { "What gets smaller every time it takes a bath?", "A bar of soap." },
    { "What has a tail and a head but no body and is often flipped?", "A coin." },
}

local questionOpeners = {
    "Riddle time. ", "All right, puzzle break. ", "Thirty-second riddle: ", "Use that brain for a second. ",
    "Vexa's riddle of the moment: ", "No cheating. ", "Quick puzzle: ", "I have one for you. ",
}

function FC:BuildRiddleBank()
    if self.riddleBank then return self.riddleBank end
    local bank = {}
    for _, pair in ipairs(STATIC) do
        for _, opener in ipairs(questionOpeners) do
            bank[#bank + 1] = { question = opener .. pair[1], answer = pair[2], kind = "classic" }
        end
    end

    local forms = {
        function(n, m, a, result)
            return string.format("Number riddle: I pick a number, multiply it by %d, then add %d and get %d. What number did I start with?", m, a, result)
        end,
        function(n, m, a, result)
            return string.format("Quick math puzzle: a mystery number times %d plus %d equals %d. What's the mystery number?", m, a, result)
        end,
        function(n, m, a, result)
            return string.format("Thirty-second puzzle: multiply my hidden number by %d, add %d, and the result is %d. Hidden number?", m, a, result)
        end,
    }
    for n = 2, 30 do
        for m = 2, 5 do
            for a = 1, 7, 2 do
                local result = n * m + a
                for _, form in ipairs(forms) do
                    bank[#bank + 1] = { question = form(n, m, a, result), answer = tostring(n), kind = "math" }
                end
            end
        end
    end
    self.riddleBank = bank
    return bank
end

function FC:StartRiddle(force)
    if not self.db or not self.db.enabled then return false end
    self.state.pendingRiddle = self.state.pendingRiddle or nil
    if self.state.pendingRiddle and not force then return false end

    local bank = self:BuildRiddleBank()
    if #bank == 0 then return false end
    local item = bank[math.random(1, #bank)]
    self.state.pendingRiddle = {
        question = item.question,
        answer = item.answer,
        kind = item.kind,
        askedAt = GetTime(),
        answerAt = GetTime() + 30,
    }
    self:Say(item.question, "think", 30, true, {
        topic = "riddle", category = "ambient", reason = "riddle question",
    })
    return true
end

function FC:AnswerRiddle(force)
    local pending = self.state.pendingRiddle
    if not pending then
        if force then self:Say("No riddle is pending. Ask me for one first.", "shrug", 100, true, { topic = "riddleanswer", category = "ambient" }) end
        return false
    end
    if not force and GetTime() < (pending.answerAt or 0) then return false end
    if not force and (self.state.inCombat or self.state.contextMode == "combat") then return false end

    local answer = pending.answer
    self.state.pendingRiddle = nil
    self:QueueSay("Riddle answer: " .. tostring(answer), "playful", 25, 0, "riddleanswer", true, nil, {
        topic = "riddleanswer", category = "ambient", reason = "30-second riddle answer",
    })
    return true
end

function FC:RiddleTick()
    if self.state.pendingRiddle and GetTime() >= (self.state.pendingRiddle.answerAt or math.huge) then
        self:AnswerRiddle(false)
    end
end

function FC:TellRiddle()
    return self:StartRiddle(true)
end
