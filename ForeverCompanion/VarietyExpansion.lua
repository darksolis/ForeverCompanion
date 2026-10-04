local FC = _G.ForeverCompanion

-- RC43 reactive-variety expansion.
-- These pools intentionally target behaviors that can happen repeatedly in a normal play
-- session. Combined with the least-used line selector, the addon should exhaust a large
-- portion of a scenario's vocabulary before returning to an old line.

local function pool(topic)
    FC.dialogue.Vexa[topic] = FC.dialogue.Vexa[topic] or {}
    return FC.dialogue.Vexa[topic]
end

local function add(topic, lines)
    local p = pool(topic)
    local seen = {}
    for _, old in ipairs(p) do seen[old] = true end
    for _, line in ipairs(lines or {}) do
        if line and not seen[line] then
            p[#p + 1] = line
            seen[line] = true
        end
    end
end

local function cross(topic, starts, endings)
    local lines = {}
    for _, a in ipairs(starts or {}) do
        for _, b in ipairs(endings or {}) do
            lines[#lines + 1] = a .. b
        end
    end
    add(topic, lines)
end

cross("eat", {
    "Food break. ", "All right, refuel. ", "Good call stopping to eat. ", "Snack intermission. ",
    "Health bar maintenance. ", "Fine, responsible adventuring. ", "A rare moment of preparation. ",
    "Sit, eat, recover. ", "Actual self-preservation. ", "Meal time in the middle of chaos. ",
}, {
    "I would rather wait ten seconds than scrape you off the floor.",
    "Get the health back before the next pull decides for us.",
    "This is significantly cheaper than dying.",
    "Try to remember this feeling the next time you pull at half health.",
    "Your future healer would approve.",
    "We can resume the bad decisions when the bar is full.",
    "For once, the correct choice was also the easy one.",
    "No complaints from me. Recovery is part of the route.",
    "Take the pause. The mobs are not going anywhere.",
    "I am documenting this as evidence that you can plan ahead.",
    "Good. Full health makes confidence slightly less reckless.",
    "Finish the food before your attention span declares the break over.",
})

cross("drink", {
    "Mana break. ", "Drink first, heroics second. ", "Resource refill. ", "Good, take a drink. ",
    "Pause for mana. ", "We are temporarily choosing patience. ", "Hydration arc. ", "Blue bar maintenance. ",
}, {
    "Running dry in the next pull would be deeply avoidable.",
    "I prefer spells that can actually be cast.",
    "Use the quiet seconds before something finds us.",
    "A full resource bar is considerably more persuasive than optimism.",
    "This is the boring part that makes the exciting part work.",
    "Better now than halfway through the next fight.",
    "Take the time. Efficiency includes not becoming useless.",
    "Refill properly instead of standing up at eighty percent because you got impatient.",
    "Good. We are respecting finite resources today.",
    "The next target can wait until the bar agrees with the plan.",
})

cross("mount", {
    "Mount up. ", "There we go, transportation. ", "Good, wheels... hooves... whatever. ", "Travel mode. ",
    "Much better than walking. ", "Finally, some speed. ", "All aboard the questionable route. ", "Moving out. ",
}, {
    "Point us somewhere useful.", "Try not to ride past the objective again.", "Let's turn distance into progress.",
    "I support any plan involving fewer footsteps.", "Now pick a direction and commit to it.",
    "The map says one thing. Your instincts usually say something more entertaining.",
    "At least travel time gives me more opportunities to comment on your route.",
    "This should improve the odds of getting somewhere before we change our mind.",
    "Please resist the urge to stop for every shiny thing on the horizon.",
    "Fast travel would be nicer, but this will do.",
})

cross("dismount", {
    "Back on foot. ", "Off the mount. ", "Feet on the ground. ", "Travel mode over. ",
    "All right, we're stopping. ", "Dismounted. ", "Apparently this is the place. ", "Fine, walking again. ",
}, {
    "Something useful better be nearby.", "That usually means combat, loot, or confusion.",
    "Let's find out whether the stop was intentional.", "Try to remember what made you get off in the first place.",
    "Now the route becomes personal.", "I assume we have a reason. I am choosing to believe that.",
    "Time to interact with whatever interrupted the ride.", "Keep moving before inventory management happens to us.",
})

cross("auction", {
    "Auction house open. ", "Market time. ", "Welcome back to Azeroth economics. ", "All right, merchant brain on. ",
    "The AH is open. ", "Time to price the questionable treasures. ", "Commerce mode activated. ", "Here comes the market check. ",
}, {
    "Buy with a plan, not with vibes.", "Check the price twice before convenience taxes your patience.",
    "Somebody else's optimism is always hiding in these listings.", "Let's see whether the junk was secretly rent money.",
    "Remember that a listed price and a sold price are not the same thing.", "Try not to turn browsing into a shopping spree.",
    "This is where bag clutter attempts to become capital.", "Patience usually costs less than impulse buying.",
    "I am emotionally prepared to judge every overpriced stack.", "Make the gold leave only when the value makes sense.",
})

cross("bank", {
    "Bank open. ", "Storage intermission. ", "All right, inventory surgery. ", "Banking time. ",
    "The vault awaits. ", "Time to move the clutter somewhere respectable. ", "Fine, organization mode. ", "Welcome to bag Tetris headquarters. ",
}, {
    "Put things where future-you can actually find them.", "Do not turn this into archaeology.",
    "If we are still here in ten minutes, I am staging an intervention.", "Keep the useful things and stop emotionally adopting every item.",
    "A clean bag is a tiny miracle. Let's attempt one.", "Please remember which tab you put the important thing in.",
    "This is less exciting than combat and somehow more dangerous to our schedule.",
    "Organize quickly before a new category of junk appears.", "Future-you deserves better than random stacks in six different places.",
})

cross("mail", {
    "Mailbox opened. ", "Mail check. ", "Tiny delivery ritual. ", "Let's see what found us by post. ",
    "Inbox time. ", "The mailbox has our attention. ", "Correspondence and suspicious attachments. ",
}, {
    "Please let at least one attachment be worth the trip.", "Clear it before it becomes another forgotten chore.",
    "Nothing says adventure like administrative errands.", "Gold in the mail is still gold. I will not complain.",
    "Take the useful things and leave the emotional baggage.", "I support any inbox that contains loot.",
    "Let's handle it now so it does not become tomorrow's problem.", "Efficient, boring, necessary. My favorite trio.",
})

cross("trade", {
    "Trade window open. ", "Player-to-player business. ", "All right, deal time. ", "Trading. ",
    "A transaction has appeared. ", "Commerce without an auctioneer. ", "Direct negotiation. ",
}, {
    "Check both sides before you click anything final.", "Be friendly and mildly suspicious.",
    "Numbers first, trust second.", "Make sure generosity is intentional.", "This is where one extra zero becomes a story.",
    "I am watching the confirmation button with you.", "Do not let impatience become a donation.", "A clean trade is a beautiful thing.",
})

cross("campfire", {
    "Campfire moment. ", "Okay, this is cozy. ", "Warmth and no immediate violence. ", "A fire, finally. ",
    "Temporary civilization. ", "We have achieved atmosphere. ",
}, {
    "I could tolerate this for a minute.", "The quiet feels suspicious, but I will allow it.",
    "Somehow this feels more restful than standing inside an inn.", "Do not ruin it by opening twenty menus.",
    "If somebody starts telling a ghost story, I am leaving.", "I almost forgot the world was trying to kill us.",
    "A small pause makes the road feel longer in a good way.", "Fine. We can pretend this was planned.",
})

cross("stealth", {
    "Stealth on. ", "Quiet now. ", "Shadow mode. ", "Fine, subtlety. ", "We are officially sneaking. ", "Ghost walk. ", "No witnesses mode. ",
}, {
    "Pick the target before the target picks us.", "I support tactical dishonesty.", "Move like you meant to be invisible.",
    "The goal is to skip problems, not collect them quietly.", "Try not to break stealth on something embarrassing.",
    "Patience looks surprisingly good on you.", "This is much more elegant than charging through the front door.",
    "If nobody notices us, I get to call this professional.",
})

cross("afk", {
    "AFK. ", "You're stepping away. ", "Real life has apparently interrupted. ", "Fine, go do human things. ", "Away mode. ", "I suppose I can wait. ",
}, {
    "I will guard the pixels with appropriate seriousness.", "Try not to come back three hours from now confused.",
    "I am absolutely judging the scenery while you are gone.", "Nothing important better spawn the second you leave.",
    "I will be here, being more patient than advertised.", "Go. I will pretend this was scheduled.",
    "I am not promising I will not rearrange your priorities while you are gone.", "Come back before I develop hobbies.",
})

cross("afkreturn", {
    "There you are. ", "Welcome back. ", "Finally, movement. ", "Oh good, the operator returned. ", "Back from reality. ", "You survived AFK. ",
}, {
    "Let's make the next few minutes count.", "I had almost started respecting the silence.",
    "The world remained inconvenient without you.", "Pick up where we left off before we forget what that was.",
    "I was one minute away from assigning myself a quest.", "Good. I was getting bored.",
    "Resume questionable decision-making when ready.", "No need to explain. I have already invented three better stories.",
})

cross("hearth", {
    "Hearthstone time. ", "Heading home. ", "Teleporting out. ", "Fine, strategic retreat. ", "Homeward. ", "Stone is glowing. ",
}, {
    "Please remember why we are going back.", "Use the reset to handle the boring things efficiently.",
    "Bags, repairs, turn-ins, then move again.", "A good reset beats wandering around with no plan.",
    "I support leaving when staying stops being useful.", "Try not to arrive and immediately forget the objective.",
    "This is either efficient routing or homesickness. I am choosing efficient routing.", "See you on the other side.",
})

cross("swim", {
    "Into the water. ", "Swimming now. ", "Aquatic route engaged. ", "Fine, we are getting wet. ", "Water crossing. ", "Apparently the road was optional. ",
}, {
    "Please tell me this is actually shorter.", "Keep an eye on where the shore went.", "I hope whatever is underwater minds its business.",
    "This had better save more time than it costs.", "The mount is probably judging us.", "At least the scenery changed.",
    "Try not to discover an underwater detour we suddenly need to investigate.", "We are committed now. Keep moving.",
})

cross("shore", {
    "Dry land again. ", "Back on solid ground. ", "Out of the water. ", "Feet down. ", "Shore reached. ", "Aquatic segment complete. ",
}, {
    "Much better.", "Now we can resume normal bad decisions.", "I prefer problems that do not involve breath meters.",
    "Let's make the detour worth it.", "Good. Everything is easier when the floor stays still.",
    "I am counting that as successful navigation.", "No drowning, no drama. Acceptable.", "Forward before we find another lake.",
})

cross("restenter", {
    "Rested area. ", "Safe enough to pause. ", "We found civilization. ", "Rest zone. ", "A little sanctuary. ",
}, {
    "Breathe before the next stretch.", "This is a good place to sort the plan without being attacked.",
    "I almost trust the surroundings.", "Take the quiet while it is available.", "Your rested XP future approves.",
    "Use the safety. Do not just stand here staring at bags.", "A minute of calm can fix a surprising amount of chaos.", "Fine. We can relax briefly.",
})

cross("barber", {
    "Barber time. ", "Appearance editor open. ", "A makeover? ", "Fine, aesthetic maintenance. ", "We are changing the look. ", "Style break. ",
}, {
    "Make the pixels count.", "If we are doing this, commit to the bit.", "Vanity is acceptable when the result is good.",
    "I reserve the right to judge every option equally.", "A new look is cheaper than a new identity.", "Try not to spend longer here than in the last dungeon.",
})

cross("ragecap", {
    "Rage capped. ", "That rage bar is full. ", "You are sitting on maximum anger. ", "Warrior resources are overflowing. ",
}, {
    "Spend it before it becomes decorative.", "Turn the anger into damage.", "This is the part where buttons get pressed.",
    "Full rage is wasted rage.", "You worked hard for that fury. Use it.", "The bar cannot get angrier than this.", "Cash it in before the fight changes.", "Do something expensive with it.",
})

cross("energycap", {
    "Energy capped. ", "Full energy. ", "That yellow bar is overflowing. ", "You are sitting at maximum energy. ",
}, {
    "Spend it before regeneration goes to waste.", "Turn it into buttons now.", "The resource is not a collectible.",
    "Use it while there is something worth hitting.", "Cap time is lost time.", "Your abilities would like a word.", "Make the bar move.", "Convert that energy into consequences.",
})

cross("manalow", {
    "Mana is low. ", "Blue bar warning. ", "You are almost dry. ", "Resource situation is getting thin. ",
}, {
    "Plan the next casts instead of hoping.", "Do not discover zero mana at the worst possible second.", "Slow down before the bar makes the decision for you.",
    "Efficiency matters now.", "Keep enough in reserve for the thing that saves you.", "This is where discipline starts paying rent.", "Choose the next spell like it costs something, because it does.", "You can be aggressive again after the resource problem stops being a problem.",
})

cross("bags", {
    "Bag check. ", "Inventory pressure. ", "Space is getting tight. ", "Your bags are becoming a negotiation. ", "Inventory warning. ",
}, {
    "Start deciding what deserves to exist.", "Do not wait until the next good drop has nowhere to go.", "We are approaching the bag-Tetris portion of the adventure.",
    "A vendor is becoming increasingly attractive.", "Keep a few slots free for something actually exciting.", "Future loot would appreciate some breathing room.", "This is how every farming session becomes inventory management.", "Cull the junk before the junk wins.",
})

cross("bagfull", {
    "Bags full. ", "Zero free slots. ", "Inventory has officially surrendered. ", "We have reached maximum clutter. ",
}, {
    "Fix it before the next drop becomes a problem.", "Something has to go.", "Congratulations, every pocket is now a storage crisis.",
    "Find a vendor or make a ruthless decision.", "This is no longer a warning. This is logistics.", "Loot cannot help us if we cannot pick it up.", "The next item is going to force a choice, and I know how much you love those.", "Please solve this before we kill anything valuable.",
})

cross("repair", {
    "Durability warning. ", "Gear is taking a beating. ", "Your equipment is asking for maintenance. ", "Repair status is getting ugly. ", "Armor check. ",
}, {
    "Find a repair before a small problem becomes a broken one.", "A vendor visit is cheaper than pretending this is fine.", "Do not wait for the red icons to make the point louder.",
    "Keep the equipment functional. It is doing most of the physical work here.", "Plan a repair stop into the route.", "This is the part people ignore until something snaps.", "We can be reckless after the gear is healthy again.", "Maintenance is boring right up until broken gear is worse.",
})

cross("repaired", {
    "Repairs done. ", "Gear fixed. ", "Durability restored. ", "Equipment crisis resolved. ",
}, {
    "Much better.", "Now go damage it responsibly.", "One less invisible problem waiting to happen.", "I approve of preventative maintenance.", "Back to full confidence, or at least the equipment version of it.", "Good. Nothing should fall apart unexpectedly now.", "We bought ourselves another round of bad decisions.", "Clean slate for the armor.",
})

cross("broken", {
    "Something broke. ", "Gear failure. ", "That red equipment icon is not decorative. ", "We officially broke a piece of gear. ",
}, {
    "Repair it before pretending everything is normal.", "That is what happens when warnings become background decoration.", "The equipment has filed a formal complaint.", "Find a repair. Now would be good.", "Our stats are literally falling apart.", "This is the expensive version of procrastination.", "I would like to submit 'maintenance' as the next objective.", "Keep going only if the plan includes fixing this very soon.",
})

cross("death", {
    "Well. ", "And there it is. ", "You died. ", "That went poorly. ", "The floor wins this round. ", "Death confirmed. ",
}, {
    "Take the lesson and leave the drama.", "I assume we are calling that reconnaissance.", "Try the next version with slightly more surviving.",
    "At least the mistake is now extremely well documented.", "We can absolutely do better than that.", "The route back is your thinking time.", "I have notes. Several.", "Fine. Reset and make the rematch embarrassing for them instead.",
})

cross("revive", {
    "Back alive. ", "We're up again. ", "Resurrection complete. ", "Round two. ", "Welcome back to the living. ",
}, {
    "Use the second chance better than the first one.", "Now retrieve the dignity with the corpse.", "Fresh health bar, fresh opportunity to listen to me.", "Reset the plan before repeating the mistake.", "Good. The adventure resumes.", "Try not to make this a recurring feature.", "We know one way not to do it now.", "Back to work.",
})

cross("lootrare", {
    "Blue drop. ", "Rare loot. ", "That one has some color to it. ", "Something potentially useful dropped. ", "Rare item spotted. ",
}, {
    "Give it a real look before vendoring anything.", "Now we're paying attention.", "Check whether it is upgrade, market value, or expensive clutter.", "At least this corpse respected our time.", "This is why we keep opening things.", "Put it in the 'actually inspect this' pile.", "Not every blue is exciting, but every blue earns a glance.", "Maybe the run just improved.",
})

cross("lootepic", {
    "Purple. ", "Epic drop. ", "Now that is a color I respect. ", "Okay, the loot just became interesting. ", "Epic item spotted. ",
}, {
    "Stop and inspect that properly.", "That deserves more than a quick vendor-price glance.", "Now you've got my attention.", "Please tell me it is actually useful.", "This is the kind of interruption I support.", "Do not accidentally sell it while cleaning bags.", "A little dopamine has entered the chat.", "Maybe the grind just paid rent.",
})

cross("skillup", {
    "Skill up. ", "Another proficiency point. ", "Tiny competence increase. ", "Progress tick. ", "That skill moved. ",
}, {
    "Quiet progress still counts.", "One point closer to making this look intentional.", "Small number, real improvement.", "I saw that.", "Competence is accumulating in the background.", "Keep stacking the little gains.", "Not every milestone needs fireworks.", "That is how mastery sneaks up on you.",
})

-- Pet lines preserve the %s placeholder expected by Brain:GetLine.
add("pet", {
    "%s is here. Good, another witness to the decision-making.", "%s joined us. I hope they're the responsible one.",
    "%s is out. Excellent, more company and potentially less aggro on you.", "There you are, %s. Try to keep your person alive.",
    "%s has arrived. The party's average judgment may have just improved.", "%s is with us. I approve of reinforcements.",
    "Hello, %s. You missed at least one questionable choice.", "%s is back. Good. Somebody competent should be present.",
    "%s reporting for duty. Very official.", "%s is here, which means the adventure is statistically cuter now.",
    "%s joined the route. Keep up, little one.", "%s is active. I expect professionalism from exactly one of you.",
})

function FC:VarietyDiagnostics()
    local topics = {
        "eat", "drink", "mount", "dismount", "auction", "bank", "mail", "trade", "campfire", "stealth",
        "afk", "afkreturn", "hearth", "swim", "shore", "restenter", "barber", "ragecap", "energycap", "manalow",
        "bags", "bagfull", "repair", "repaired", "broken", "death", "revive", "lootrare", "lootepic", "skillup", "pet",
    }
    local total = 0
    self:Debug("Reactive variety pools:")
    for _, topic in ipairs(topics) do
        local count = #(self.dialogue.Vexa[topic] or {})
        total = total + count
        self:Debug(string.format("  %s: %d lines", topic, count))
    end
    self:Debug(string.format("Tracked reactive total: %d lines. Exact lines rotate least-used-first.", total))
end
