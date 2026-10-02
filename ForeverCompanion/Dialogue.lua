local FC = _G.ForeverCompanion

local function pool(topic)
    FC.dialogue.Vexa[topic] = FC.dialogue.Vexa[topic] or {}
    return FC.dialogue.Vexa[topic]
end

local function common(topic)
    FC.dialogue.common[topic] = FC.dialogue.common[topic] or {}
    return FC.dialogue.common[topic]
end

local function add(target, lines)
    for _, line in ipairs(lines) do
        target[#target + 1] = line
    end
end

local function cross(target, starts, endings)
    for _, a in ipairs(starts) do
        for _, b in ipairs(endings) do
            target[#target + 1] = a .. b
        end
    end
end

-- Ambient personality. 64 combinations, intentionally broad enough that a quiet minute does not feel repetitive.
cross(pool("ambient"), {
    "You know, ",
    "For the record, ",
    "Just saying, ",
    "Not to distract you, but ",
    "Tiny observation: ",
    "I have decided that ",
    "While we're here, ",
    "I was thinking... ",
}, {
    "this is going considerably better than some of your other ideas.",
    "you look much more competent when you keep moving.",
    "I approve of the current amount of chaos.",
    "we could be making worse decisions, and somehow that feels like progress.",
    "I am still waiting for the part where you admit I was right.",
    "the route is fine, but your confidence remains suspiciously high.",
    "I like this pace. Don't ruin it by opening your bags for ten minutes.",
    "if something explodes, I am blaming you before I inspect the evidence.",
})

-- General combat victory / post-combat reactions.
cross(pool("combatwin"), {
    "All right. ",
    "There we go. ",
    "Much better. ",
    "See? ",
    "Clean enough. ",
    "I'll take it. ",
}, {
    "That one actually looked controlled.",
    "Nothing embarrassing happened that time.",
    "You lived, they didn't. Strong fundamentals.",
    "That is the kind of outcome I prefer.",
    "Efficient, decisive, and only slightly reckless.",
    "A little messy, but effective.",
    "You made that look easier than it probably was.",
    "We can work with that.",
})

cross(pool("combatquick"), {
    "That was fast. ",
    "Oh, that disappeared quickly. ",
    "Efficient. ",
    "Well, that was rude. ",
    "Blink and it's over. ",
    "That barely counted as a fight. ",
}, {
    "Do it again.",
    "I like this version of you.",
    "Keep that tempo.",
    "No notes.",
    "Very attractive use of violence.",
    "Let's pretend they're all that easy.",
})

cross(pool("combatlong"), {
    "That took a while. ",
    "Okay, that one had chapters. ",
    "That fight became a relationship. ",
    "Long one. ",
    "We spent some quality time with that problem. ",
    "That enemy really refused to get the message. ",
}, {
    "At least we finished it.",
    "Maybe the next one can die faster.",
    "You stayed with it, I'll give you that.",
    "Good recovery, though.",
    "I was starting to learn its birthday.",
    "Let's call that perseverance instead of inefficiency.",
})

-- Quest objective progress.
add(pool("objective"), {
    "%s is moving. %d of %d now.",
    "Progress on %s: %d of %d.",
    "%s just ticked forward. %d/%d.",
    "%s is getting there: %d of %d.",
    "Another step on %s. %d/%d.",
    "%s progressed. %d out of %d.",
    "Good. %s is now %d/%d.",
    "%s: %d of %d. Keep going.",
    "That counted for %s. %d/%d now.",
    "One more for %s. You're at %d/%d.",
    "%s is actually moving along. %d of %d.",
    "We're making progress on %s: %d/%d.",
    "%s advanced again. %d of %d.",
    "There. %s is up to %d/%d.",
    "%s just got easier to look at. %d/%d.",
    "Progress. %s is %d of %d.",
    "%s is no longer pretending to be unfinished. %d/%d.",
    "Another objective chunk done for %s: %d/%d.",
    "%s moved. %d of %d.",
    "That helped %s. %d/%d.",
    "%s is coming together. %d of %d.",
    "Nice. %s reached %d/%d.",
    "%s just got one step closer: %d/%d.",
    "Mark it. %s is now %d of %d.",
})

-- Session-aware lines, formatted with session XP and duration.
add(pool("session"), {
    "We've picked up %s XP this session in %s. Not terrible.",
    "%s XP since we started, over %s. That's our current body of work.",
    "Session total: %s XP in %s. Keep building on it.",
    "We've earned %s XP across %s so far.",
    "%s XP in %s. I am quietly keeping score.",
    "For this session, we're at %s XP over %s.",
    "%s XP since login. Time together: %s.",
    "We've been at this %s and gained %s XP. Yes, I noticed.",
    "%s of playtime, %s XP earned. Data can be flattering sometimes.",
    "Current session: %s XP across %s. Continue.",
})

-- More login flavor.
cross(pool("login"), {
    "There you are. ",
    "Finally. ",
    "Good, you're back. ",
    "Perfect timing. ",
    "Well look who logged in. ",
}, {
    "I was getting dangerously close to having no one to judge.",
    "Let's make this session worth remembering.",
    "Try not to make your first decision the worst one.",
    "I have opinions ready and nowhere else to put them.",
    "Let's go find some XP and something expensive.",
    "I am prepared to be impressed. Slightly.",
})

-- Death variety.
cross(pool("death"), {
    "Well, ",
    "So, ",
    "Interesting. ",
    "Okay. ",
    "Right. ",
    "For future reference, ",
    "I would like the record to show that ",
    "Apparently ",
}, {
    "that was not the winning strategy.",
    "we found the limit.",
    "confidence and survivability are not the same stat.",
    "you can, in fact, pull too much.",
    "that enemy had stronger opinions than we expected.",
    "dying remains inefficient.",
})

-- Low health variety.
cross(pool("lowhealth"), {
    "%d%% health. ",
    "We ended that at %d%%. ",
    "%d%% remaining. ",
    "Only %d%% health left. ",
    "%d%%. ",
}, {
    "That was closer than I wanted.",
    "I know you enjoy drama, but come on.",
    "Let's avoid making that the standard.",
    "You're alive, so I will postpone the lecture.",
    "You really do like making me watch the bar disappear.",
    "I prefer you with more health than that.",
})

-- Completed quests.
cross(pool("questdone"), {
    "%s is done. ",
    "Finished %s. ",
    "%s, complete. ",
    "That's %s handled. ",
    "%s is officially off the problem list. ",
}, {
    "Nice work.",
    "Keep moving.",
    "One less thing hanging over us.",
    "Efficient enough for me.",
    "I approve.",
    "Next.",
})

-- Quest pile / turn-in reminders.
cross(pool("questpile"), {
    "%d quests ready. ",
    "You have %d completed quests. ",
    "%d turn-ins waiting. ",
    "There are %d finished quests in that log. ",
    "%d completed quests are just sitting there. ",
}, {
    "Town run is starting to make sense.",
    "That's a lot of XP waiting to be collected.",
    "At some point we should actually get paid.",
    "We are officially hoarding completion credit.",
    "I vote we cash those in soon.",
    "Do not make me watch you grind past free XP.",
})

-- Near level.
cross(pool("nearlevel"), {
    "About %d fights left. ",
    "Roughly %d more decent pulls. ",
    "%d fights or so. ",
    "We're around %d fights from the ding. ",
    "Call it %d more fights. ",
}, {
    "Stay on task.",
    "Do not wander off now.",
    "You're too close to get distracted.",
    "Finish it clean.",
    "Keep the pace and this is done.",
    "I expect a level soon.",
})

-- Pace reactions.
cross(pool("fastpace"), {
    "XP pace is climbing. ",
    "We just sped up. ",
    "That route is paying off. ",
    "We're moving faster now. ",
    "The numbers just improved. ",
}, {
    "Keep doing this.",
    "I like what I'm seeing.",
    "Do not overthink it.",
    "This is worth sticking with.",
    "Now we're getting somewhere.",
    "Good. More of that.",
})

cross(pool("slowpace"), {
    "We're slowing down. ",
    "XP pace dipped. ",
    "The route lost some efficiency. ",
    "We are not moving like we were. ",
    "The numbers cooled off. ",
}, {
    "Tighten it up.",
    "Maybe skip the detours.",
    "We can recover it.",
    "Let's find a better rhythm.",
    "Time to sharpen the route.",
    "I know we can do better than this.",
})

-- Zone entry lines.
cross(pool("zone"), {
    "%s. ",
    "So this is %s. ",
    "Welcome to %s. ",
    "All right, %s. ",
    "New ground: %s. ",
}, {
    "Let's see what it has for us.",
    "Try to leave with more XP than trauma.",
    "I expect efficiency and at least one questionable decision.",
    "Let's learn the good spots quickly.",
    "Show me the route.",
    "New scenery, same mission.",
})

-- Bag reminders.
cross(pool("bags"), {
    "%d bag slots left. ",
    "Only %d free slots. ",
    "%d spaces remaining. ",
    "We're down to %d open slots. ",
    "%d free bag spaces. ",
}, {
    "Inventory trouble is approaching.",
    "Town is becoming a practical idea.",
    "Maybe be selective for once.",
    "We're nearly at the 'delete junk angrily' stage.",
    "That is not much breathing room.",
    "Loot carefully.",
})

-- Repair reminders.
cross(pool("repair"), {
    "Lowest durability is around %d%%. ",
    "We're sitting near %d%% durability on one piece. ",
    "%d%% durability on the low end. ",
    "Something is down around %d%%. ",
    "%d%%. Your gear is getting tired. ",
}, {
    "Repair soon.",
    "Let's fix that before it becomes embarrassing.",
    "Maintenance before heroics.",
    "A vendor visit would be intelligent.",
    "Do not wait for it to break.",
    "Even I cannot flirt your armor back together.",
})

-- Idle and return variety.
cross(pool("idle"), {
    "We have been standing here long enough that ",
    "At this point, ",
    "Just checking, ",
    "I am beginning to suspect ",
    "If this is a break, ",
}, {
    "the local wildlife thinks we're scenery.",
    "I could have taken a nap.",
    "you forgot what we were doing.",
    "we are no longer technically adventuring.",
    "you owe me a more interesting view.",
    "I am carrying this partnership aesthetically.",
})

cross(pool("comeback"), {
    "There you are. ",
    "Oh good. ",
    "Welcome back. ",
    "Movement! ",
    "Finally. ",
}, {
    "I was about to start narrating the grass.",
    "Let's do something worth talking about.",
    "I missed having decisions to criticize.",
    "Back to work.",
    "Try not to disappear again immediately.",
    "The adventure resumes.",
})

-- Milestone variety.
add(pool("xp25"), {
    "Quarter done. Solid start.", "Twenty-five percent. Keep the tempo.", "First quarter is behind us.",
    "25 percent. We're moving.", "Quarter of the level gone. Good.", "One fourth down. Stay efficient.",
    "We're through the first quarter.", "25 percent complete. No complaints yet.",
})
add(pool("xp50"), {
    "Halfway. Now finish the back half cleaner.", "Fifty percent. Nice.", "Half the level is gone.",
    "Midpoint reached.", "We're halfway there. Keep rolling.", "50 percent. Good pace so far.",
    "Halfway through. Don't cool off now.", "The level is officially half dead.",
})
add(pool("xp75"), {
    "Three quarters done. Finish it.", "Seventy-five percent. Final stretch.", "Only the last quarter remains.",
    "75 percent. We're close.", "Three quarters complete. Keep pressure on.", "The level is running out of room.",
    "Final quarter now.", "75 percent and climbing.",
})
add(pool("xp90"), {
    "Ninety percent. Do not get distracted.", "90 percent. Finish this before touching anything unnecessary.",
    "We're at ninety. End it.", "Ten percent left. Stay focused.", "This level is almost over.",
    "90 percent. You can reorganize your life after the ding.", "Nearly there. Keep moving.", "Last ten percent.",
})

-- Generic fallbacks for non-Vexa companions using newer event topics.
add(common("ambient"), {
    "Good pace. Keep moving.", "Everything looks stable for now.", "Stay on task and keep the route clean.",
})
add(common("combatwin"), { "Fight finished. Keep moving.", "Clean enough. Next target.", "Good. Continue." })
add(common("combatquick"), { "Fast kill. Good.", "That was efficient.", "Quick work." })
add(common("combatlong"), { "Long fight, but finished.", "That took time. Recover and continue.", "Done. Move on." })
add(common("objective"), { "%s progressed to %d of %d.", "%s: %d/%d.", "Progress on %s: %d of %d." })
add(common("session"), { "%s XP earned this session over %s.", "Session progress: %s XP in %s." })
