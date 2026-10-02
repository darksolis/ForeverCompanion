local FC = _G.ForeverCompanion

local function pool(topic)
    FC.dialogue.Vexa[topic] = FC.dialogue.Vexa[topic] or {}
    return FC.dialogue.Vexa[topic]
end

local function add(topic, lines)
    local p = pool(topic)
    for _, line in ipairs(lines) do p[#p + 1] = line end
end

local function cross(topic, starts, endings)
    local p = pool(topic)
    for _, a in ipairs(starts) do
        for _, b in ipairs(endings) do p[#p + 1] = a .. b end
    end
end

cross("mount", { "Mount up. ", "There we go. ", "Good, we're moving. ", "Finally, transportation. " }, {
    "Let's cover some ground.", "Try not to ride past the thing we actually need.", "I approve of fewer footsteps.", "Point us somewhere useful.", "Let's make the travel time count.",
})
add("dismount", { "Back on foot. Something interesting better be nearby.", "Dismounting. Fine, let's do this the slow way.", "Feet on the ground. What are we killing?", "All right, we're here. Focus up.", "Off the mount. That usually means trouble." })
add("eat", { "Food break. Sensible, annoyingly.", "Eat up. I prefer you with a full health bar.", "Tiny break, then back to work.", "Good. Refuel before the next terrible idea.", "At least one of us respects preparation." })
add("drink", { "Mana break? Fine. Hydration before heroics.", "Drink up. Empty resources are not a personality trait.", "Take a second. I'd rather wait than watch you run dry.", "Resource management. Very responsible of you.", "Good. Refill, then move." })
add("campfire", { "Okay, this is actually cozy.", "A campfire? Fine. We can pretend we're civilized for a minute.", "Warmth, quiet, no one trying to kill us. Suspicious.", "I could get used to this. Briefly.", "Campfire break approved." })
add("stealth", { "Quiet now. Let's be sneaky about this.", "Stealth. Good. Subtlety finally entered the chat.", "All right, ghost mode. Pick the right target.", "Sneaking? I support this level of dishonesty.", "Keep it clean. If we're hiding, make it worth it." })

add("instanceenter", { "Dungeon time: %s. Stay sharp.", "We're in %s. Try not to make the healer regret meeting us.", "%s. All right, now things get interesting.", "Welcome to %s. Let's leave with loot and dignity.", "%s. Group content. Behave... selectively." })
add("instanceleavewin", { "Leaving %s after getting it done. That's the version I like.", "%s handled. Nice run.", "We got what we came for in %s. Clean enough.", "Out of %s with a win. I'll take it.", "%s behind us. Good work." })
add("instanceleavefail", { "Leaving %s without much to brag about. We'll call it reconnaissance.", "%s didn't exactly go to plan.", "Well, %s happened. We can improve on that.", "Exiting %s. Let's pretend we learned something.", "%s was... educational." })
add("bgenter", { "Battleground. Good. People are about to make emotional decisions.", "PvP time. Stay unpredictable.", "Battleground loaded. Let's make somebody regret queueing.", "All right, real players. This should be entertaining.", "Here we go. No scripted mobs to blame now." })
add("pvpkill", { "Player down. Nice.", "That one had a human behind it. Even better.", "Clean PvP kill. I approve.", "Someone just learned your name the hard way.", "Good. Keep the pressure on." })
add("capital", { "%s. Civilization. Try not to spend twenty minutes standing still.", "Back in %s. Repairs, bags, business — then leave.", "%s. Handle the chores before we forget.", "We made it to %s. Be efficient with the boring stuff.", "%s. Fine. Let's use the city properly." })

add("afk", { "AFK? Fine. I'll judge the scenery while you're gone.", "You're leaving me here? Rude.", "Go do whatever mysterious real-life thing this is.", "AFK noted. I'll try not to start a fight without you.", "Fine. I'll wait. Elegantly." })
add("afkreturn", { "There you are. Took you long enough.", "Welcome back. I was seconds away from becoming productive.", "Back? Good. Let's move.", "Finally. The world continued being inconvenient without you.", "You're back. Excellent. Do something." })
add("dnd", { "Do not disturb? Fine. Mysterious mode activated.", "DND. Got it. I'll keep the commentary classy.", "All right, private little adventure mode.", "DND noted. I can be discreet.", "Fine. We are officially unavailable and fabulous." })
add("dndreturn", { "DND off. Back to being publicly questionable.", "Available again. Good.", "Privacy mode over. Let's get back to work.", "And we're social again. Allegedly.", "DND cleared. Carry on." })

add("bagfull", { "Your bags are literally full. This is no longer a suggestion.", "Inventory full. Congratulations on collecting too much everything.", "No bag space. We need a vendor, bank, or better life choices.", "You cannot loot that because you've become a portable warehouse.", "Bags full. Town. Now." })
add("nomoney", { "You can't afford that. I wish I could say I'm shocked.", "Insufficient funds. Expensive taste, limited budget.", "The merchant has rejected our financial optimism.", "Not enough money. Maybe sell something first.", "Your wallet just said no." })
add("hearth", { "Hearthstone? Fine. Let's reset somewhere useful.", "Heading home. Make the trip count.", "Hearth time. Good moment to clean up the inventory.", "Back to safety? Acceptable.", "Using the hearth. Please have a plan when we arrive." })
add("hearthcombat", { "You're trying to hearth in combat? Bold cowardice.", "Now? During the fight? Absolutely shameless.", "Hearthstone while something is hitting you. Incredible.", "Maybe survive first, teleport second.", "I respect the instinct. I question the timing." })
add("repaired", { "Gear repaired. Much better.", "Good. I prefer our equipment attached and functional.", "Repairs done. One less excuse.", "There. Proper maintenance. Attractive.", "Everything fixed? Great. Break it responsibly." })
add("broken", { "Something actually broke. We have crossed from reckless into negligent.", "Broken gear. That's impressively avoidable.", "Your equipment gave up before you did.", "Something is broken. Vendor. Repair. Immediately.", "Well, the gear has filed a formal complaint." })
add("mail", { "Mail collected. Tiny dopamine delivery complete.", "You took something from the mailbox. Please let it be useful.", "Mail handled. Efficient.", "One less thing waiting in the inbox.", "Loot by mail is still loot. I'll allow it." })
add("bank", { "Bank time. Please don't turn this into archaeology.", "Organize quickly. I refuse to watch thirty minutes of bag Tetris.", "Bank opened. Be decisive.", "Fine. Inventory management intermission.", "Let's put things away before you forget why we came." })
add("auction", { "Auction house. Time to discover whether your junk is 'valuable'.", "Ah, the marketplace. Where optimism gets priced per stack.", "Auction house open. Buy smart.", "Shopping? Fine. Don't get sentimental about gold.", "Market time. Try not to overpay for convenience." })
add("trade", { "Trading. Let's hope this is profitable.", "A trade window. Be charming and suspicious.", "Business transaction. Very mature.", "Trading with another player. Check the numbers.", "All right, deal-making mode." })
add("barber", { "Changing the look? Good. Vanity is allowed when it works.", "Barber time. Make the pixels count.", "A makeover? I support this.", "Fine, let's improve the aesthetic.", "Appearance matters. Anyone who says otherwise has bad transmog." })

add("pet", { "Oh, %s is here. Cute. Useful too, hopefully.", "%s joined us. I approve of additional company.", "Hello, %s. Please be the responsible one.", "%s is out. Good, someone else can take aggro.", "There you are, %s. Try to keep up." })
add("guildjoin", { "Joined %s? Interesting. Let's see if they can handle you.", "%s is your guild now. Behave just enough.", "New guild: %s. Try to make a good first impression for at least ten minutes.", "%s, huh? All right. New social experiment.", "Guild banner updated: %s." })
add("guildleave", { "We left %s. That chapter's done.", "%s is behind us now.", "No longer in %s. Moving on.", "Guild change noted. Farewell, %s.", "%s didn't make the long-term plan." })
add("restenter", { "Rested area. Good place to breathe for a second.", "We're resting now. I can work with that.", "Safe enough to relax. Briefly.", "Resting. Your XP bar may thank you later.", "This counts as civilized downtime." })

add("ragecap", { "Your rage is basically capped. Spend it before it evaporates into bad decisions.", "Rage is overflowing. Hit something expensive.", "You're sitting on a lot of rage. Use it.", "That rage bar is begging to be spent.", "Warrior problem: too angry to waste this much rage." })
add("energycap", { "Energy is capped. That's resource you could be turning into damage.", "You're sitting full on energy. Spend it.", "Energy cap. Do something stabby.", "Full energy is wasted energy in combat.", "Use the bar. It's not decorative." })
add("manalow", { "Mana's getting dangerously low.", "You're nearly dry on mana. Plan the next few casts.", "Low mana. This is where discipline matters.", "Mana under ten percent. Maybe stop pretending resources are infinite.", "You're running on fumes." })

add("lootrare", { "Rare drop: %s. Okay, that's worth looking at.", "%s is rare quality. Nice little hit.", "Oh, %s. That's not vendor trash.", "Rare loot. %s might actually matter.", "%s dropped. Blue text gets my attention." })
add("lootepic", { "Epic drop: %s. Okayyy, now I'm interested.", "%s. Purple. Gorgeous. Equip it if it's good.", "Oh, that's sexy. %s just dropped.", "Epic loot! %s deserves a proper look.", "%s. Now THAT is why we loot things." })
add("upgrade", { "That slot just jumped from item level %d to %d. Real upgrade.", "Gear improved: %d to %d in that slot. Nice.", "That's an actual upgrade — %d to %d.", "Item level went up from %d to %d. Good choice.", "Better gear equipped. %d → %d." })
add("destroy", { "Deleting %s? Fine. Gone is gone.", "%s is headed to the void.", "Destroying %s. Ruthless inventory management.", "Goodbye, %s.", "%s has been selected for deletion." })
add("destroyvaluable", { "Wait — you're deleting %s? That's valuable.", "%s is rare or better. Are we absolutely sure about this?", "Careful. %s is not junk quality.", "You are about to destroy %s. I am judging this decision heavily.", "%s has quality. Please know what you're doing." })

add("readycheck", { "Ready check. This is the part where everyone lies.", "Ready check up. Time to pretend the group is organized.", "Are we ready? Statistically, someone isn't.", "Ready check. Click carefully.", "Group says 'ready'. Reality pending." })
add("notready", { "You marked not ready. At least you're honest.", "Not ready? Good. Better than pretending.", "We are officially the delay. Handle your business.", "Not ready selected. Fix whatever needs fixing.", "Good call. Don't rush into the pull unprepared." })
add("bosskill", { "Boss down: %s. That's a memory worth keeping.", "%s is dead. Very nice.", "Boss kill confirmed: %s.", "%s handled. That's the good stuff.", "There goes %s. Clean finish." })
add("longfall", {
    "That was a long fall. Graceful is not the word I'd use.",
    "You were airborne long enough for me to reconsider our choices.",
    "Big fall. Next time maybe use the path.",
    "That drop had commitment.",
    "Gravity remains undefeated.",
    "That was less a jump and more a temporary career in aviation.",
    "You were in the air long enough to qualify for beverage service.",
    "I had time to wonder whether we packed a parachute.",
    "That descent had a beginning, middle, and emotional conclusion.",
    "Okay, that one was definitely a fall, not a shortcut.",
    "I respect the confidence you had before leaving the ground.",
    "Next time we could investigate stairs. I hear good things.",
    "That cliff really did look shorter from the top, didn't it?",
    "You committed to that drop like there was loot at the bottom.",
    "That landing had consequences written all over it.",
    "For a moment there, walking felt like an outdated technology.",
    "I was about to start measuring altitude in bad decisions.",
    "That was an impressively long time to regret one step.",
    "You know paths are usually designed around this exact problem, right?",
    "A dramatic descent. Very cinematic. Mildly concerning.",
    "That was enough airtime for me to prepare a speech.",
    "We have successfully tested vertical travel. Results: downward.",
    "I would call that a shortcut if it had saved any dignity.",
    "That fall had excellent commitment and questionable planning.",
    "The ground was very patient. It knew you'd be back.",
})

add("jumpstreak", {
    "Are we traveling, or are you personally testing the spacebar?",
    "You know jumping does not actually make the road shorter, right?",
    "Ah yes. The ancient Azerothian technique: move forward, but bouncier.",
    "If enthusiasm generated altitude, we'd be in Outland by now.",
    "You have turned walking into a rhythm game.",
    "I see we've selected the premium version of walking: with unnecessary airtime.",
    "The floor keeps taking you back. Very committed relationship.",
    "You jump like the ground owes you money.",
    "At this point I'm convinced your spacebar insulted your family.",
    "I admire the cardio. I question the purpose.",
    "Bunny-hopping: because normal locomotion lacked personality.",
    "You are absolutely determined to spend as little continuous time on the ground as possible.",
    "Every jump says, 'Maybe this one will finally make me faster.'",
    "I can hear the imaginary athletic commentator losing their mind.",
    "Strong jump. Excellent form. Zero strategic value.",
    "And another jump. The crowd is going wild. The crowd is me. I am lying.",
    "We are really committed to making this road more vertical than necessary.",
    "Some people walk. You appear to be aggressively negotiating with gravity.",
    "I think you've invented tactical bouncing.",
    "This is either parkour or impatience with extra steps.",
    "You are treating flat ground like an obstacle course.",
    "If jumping burned calories in-game, you'd be unstoppable.",
    "The spacebar is going to file for workers' compensation.",
    "I'm starting to think your mount should come with a trampoline.",
    "You don't need to jump over every invisible pebble, but I respect the commitment.",
    "This feels less like travel and more like a refusal to walk normally.",
    "Somewhere, an NPC is watching this and deciding heroes are weird.",
    "I wonder how many quests have been completed one hop at a time.",
    "You have achieved maximum momentum in every direction except efficiency.",
    "I would ask why, but I think we both know the answer is 'because I can.'",
    "The road is flat. You have declared that unacceptable.",
    "Fine. We bounce now. Apparently that's our thing.",
    "I suppose this is technically more exciting than walking.",
    "You know what? Keep jumping. It gives me something to comment on.",
    "I have officially stopped expecting your feet to stay on the ground.",
    "This is how I know you're not reading quest text right now.",
    "You're moving like standing still between steps would be morally wrong.",
    "Is this a speedrun technique, or are we just entertaining ourselves?",
    "If this is an attempt to confuse nearby mobs, I respect the creativity.",
    "Your travel style has become 'small repeated emergencies.'",
    "You are one cape away from pretending this is dramatic parkour.",
    "I can practically hear you saying 'boing' in your head.",
    "Flat terrain really brings out your need for unnecessary motion.",
    "We could walk. Counterpoint: apparently we cannot.",
    "At least your character model is getting exercise.",
    "This is what happens when a hero gets bored between objectives.",
    "I see the destination. I also see twelve completely optional jumps between here and there.",
    "You have a very personal interpretation of point A to point B.",
    "The terrain has done nothing to deserve this much suspicion.",
    "If you jump enough times, maybe the quest giver will come to us.",
    "I regret to report that the next hop is also not a mount.",
    "This is becoming less 'movement' and more 'performance art.'",
    "I'm scoring these now. That one was a seven. Weak landing.",
    "Eight out of ten. Good height, questionable necessity.",
    "Nine out of ten. Still no loot in midair.",
    "The judges appreciate your consistency, if not your judgment.",
    "Excellent jump. Please submit the same move forty more times for review.",
    "I have seen raid mechanics with less repetition than your travel style.",
    "If the floor were lava, you'd be doing incredibly well.",
    "Bad news: the floor is not lava. You're doing this voluntarily.",
    "Do you think every jump gives the server a tiny headache?",
    "You're making normal walking look suspiciously underdeveloped.",
    "I support movement. I did not realize we were launching a jumping career.",
    "Maybe we're secretly training for an Azerothian long-jump team.",
    "I refuse to believe this many hops are all accidental.",
    "Your feet have commitment issues.",
    "The ground keeps asking for a serious relationship. You keep leaving.",
    "I have started counting landings instead of miles.",
    "At this point, staying grounded would be the surprising choice.",
    "There are easier ways to tell me you're bored.",
    "Okay, pogo-stick energy. I see you.",
    "This is peak 'waiting for something to happen' behavior.",
    "You jump like there might be an achievement for doing it enough times.",
    "If there is a hidden jump counter somewhere, you are absolutely winning.",
    "I want you to know the path remains exactly where we left it.",
    "Some players optimize routes. You optimize airtime.",
    "At least the scenery gets a slightly different angle every half-second.",
    "Your navigation strategy appears to be 60 percent direction, 40 percent hop.",
    "I appreciate a hero who can turn boredom into a full-body activity.",
    "You are proving that repetitive motion can still have confidence.",
    "I'm not saying stop. I'm saying I have noticed. Extensively.",
    "This is the kind of behavior companions were invented to comment on.",
    "You keep jumping and I keep developing opinions. Fair trade.",
    "Honestly, if you stopped hopping now I'd assume something was wrong.",
})

add("jumpmilestone", {
    "That's %d jumps this session. The spacebar has entered a committed relationship with your thumb.",
    "%d jumps. At this point we're tracking a lifestyle, not a habit.",
    "Jump count: %d. I would ask whether this was necessary, but the evidence is overwhelming.",
    "%d jumps logged. Congratulations on making gravity part of the gameplay loop.",
    "We just crossed %d jumps. Somehow this has become a statistic I care about.",
    "%d jumps this session. That road never stood a chance.",
    "Official count: %d jumps. You have made walking look optional.",
    "%d jumps. The ground is starting to take this personally.",
    "That's jump number %d. I hope you're proud of the completely unnecessary consistency.",
    "%d jumps and still no hidden achievement. Tragic.",
})
add("logout", { "Logging out? Fine. I'll remember where we left off.", "Calling it here? I'll keep the notes.", "Session ending. Go do human things.", "All right. I'll summarize this mess for next time.", "Logging out. Try not to forget me." })

add("targetelite", { "%s is %s. This one deserves a little respect.", "%s is classified %s. Pay attention.", "Target: %s. %s. Don't autopilot this.", "%s is not a normal mob — %s classification.", "%s is a %s target. It might actually fight back." })
add("targetdanger", { "%s is level %d — %d levels above you. That's a real warning.", "%s is %d. You're %d levels under it. Proceed with intent.", "%s is level %d. That's %d above you.", "%s is significantly higher level than you. %d versus your current level, a %d-level gap.", "Careful with %s. Level %d, which is %d levels up on you." })

add("lastsession", { "Last time: %s XP in %s, %d quests, %d deaths. We went from level %d to %d.", "Previous session recap: %s XP over %s, %d quest turn-ins, %d deaths, levels %d→%d.", "I kept notes. Last session was %s XP in %s with %d quests and %d deaths, from level %d to %d.", "Yesterday's paperwork: %s XP, %s played, %d quests, %d deaths, level %d to %d.", "Last session summary: %s XP in %s. %d quests. %d deaths. Level %d→%d." })

add("revive", { "Back on your feet. Good.", "Alive again. Let's improve the next attempt.", "There you are. Respawning suits you better than staying dead.", "Welcome back to the living.", "Second chance. Use it well." })
add("flightstart", { "Taxi flight. Fine, enjoy the scenery.", "We're flying. Good time to plan the next stop.", "Flight path engaged. At least travel is automated for once.", "Airborne. Try not to tab out and forget where we're going.", "Taxi ride. Efficient laziness." })
add("flightland", { "Landed. Back to doing the work ourselves.", "We're down. Time to move.", "Flight over. Adventure resumes.", "Ground again. Let's use the time we saved.", "And we're here. What's first?" })
add("invite", { "Party invite. Let's see what kind of people we're dealing with.", "Someone wants to group. Could be useful.", "Invite incoming. Social content approaches.", "Party request. Fine, let's be charming.", "Group invite. I vote cautiously optimistic." })
add("bgwin", { "Battleground win. That felt good.", "Victory. Much better than the alternative.", "We won. I approve of this timeline.", "Battleground handled. Nice work.", "That's a PvP win worth remembering." })
add("bgloss", { "Battleground loss. Annoying. Queue the lesson, not the excuse.", "We lost that one. Fix what we can and move on.", "Not our finest battlefield performance.", "Defeat. Unpleasant, but informative.", "That one goes in the 'do better' column." })
add("crit", { "Nice crit.", "That hit had some attitude.", "Big number. I saw it.", "Okay, that one landed beautifully.", "Crit. More of those." })
add("healcrit", { "That heal landed hard.", "Big heal. Somebody needed that.", "Nice recovery spike.", "Critical heal. Good timing.", "That health bar just got rescued." })
add("queststalled", { "You've made no progress on %s for a while. Maybe the objective is somewhere else.", "%s has been sitting still for a long time. Might be worth checking the objective text again.", "We're stalled on %s. If the route is wrong, let's stop feeding it time.", "%s hasn't moved in a while. Recheck the objective before grinding blindly.", "No progress on %s for a bit. That usually means the target, area, or item is wrong." })
add("restedxp", { "You have %s rested XP banked. Nice little efficiency bonus waiting for us.", "%s rested XP available. Grinding is slightly less offensive right now.", "Rested XP: %s. If we're leveling, this is a good time to push.", "You've got %s rested XP. Might as well put it to work.", "%s rested XP sitting there. That's free acceleration." })
add("deathpattern", { "That's %d deaths with %s as our recent target. I'm noticing a pattern.", "That's death number %d with %s as our recent problem. Maybe we change the plan.", "%d deaths with %s as the recent target. Worth remembering.", "%d deaths with %s involved recently. I'm officially suspicious of this matchup.", "That makes %d deaths while %s was the recent target. Let's stop donating repair money." })
add("charcallback", { "I remember %s, your %s. Last session there was %s XP in %s, around %s XP/hour.", "%s the %s is still in my notes: %s XP over %s, roughly %s XP/hour last session.", "Switching characters doesn't erase the file. %s the %s last logged %s XP in %s at about %s XP/hour." })
add("swim", { "Swimming now? Fine. Try not to make this a long detour.", "Into the water we go.", "Swimming. Because apparently roads were too convenient.", "Water route. Let's hope it's actually shorter.", "All right, aquatic adventure." })
add("shore", { "Back on dry land. Much better.", "Out of the water. Good.", "Ground under our feet again.", "Dry land. We can resume normal bad decisions.", "Swimming segment complete." })
add("night", { "It's late in the game world. Everything looks better when it's slightly ominous.", "Nighttime. Excellent atmosphere for questionable choices.", "The world is dark. Very on-brand.", "Night run. I approve of the mood.", "Late hours. Let's make the session worth staying up for." })
add("mood_impressed", { "Okay, you've been doing pretty well. Don't make me regret saying that.", "I'm impressed right now. Enjoy the compliment while it lasts.", "You've earned a little confidence from me this session.", "Current mood: reluctantly impressed.", "Keep this up and I may have to stop roasting you for a minute." })
add("mood_annoyed", { "I'm still a little annoyed about that last stretch.", "We can do cleaner than this. You know that.", "My patience bar is not quite full right now.", "Let's tighten things up before I start keeping a harsher score.", "I'm giving the recent decisions a very skeptical look." })
add("mood_relaxed", { "This is actually a nice little stretch.", "I'm enjoying the calmer pace for a minute.", "No crisis, no broken gear, no corpse run. Lovely.", "I could get used to moments where nothing is on fire.", "This is suspiciously peaceful." })
add("mood_concerned", { "I'm keeping a closer eye on you right now.", "Let's play this next part a little smarter.", "Recent events have lowered my tolerance for reckless pulls.", "I would like the next few minutes to involve considerably less dying.", "I'm not panicking. I am monitoring aggressively." })
add("mood_amused", { "You are entertaining, I'll give you that.", "I still can't decide whether that was clever or just funny.", "This session has been more amusing than efficient in places.", "I'm having fun. That may be your most dangerous achievement today.", "You keep giving me material." })
add("mood_focused", { "All right. Serious mode for a minute.", "Stay sharp. This is the part where details matter.", "I'm paying attention now. You should too.", "Focus up. We can joke after the dangerous part.", "Let's execute cleanly." })

add("traveltime", { "About %d%% of this session has been travel. If leveling speed matters, we should tighten the route.", "We're spending roughly %d%% of the session traveling. That's a lot of non-XP time.", "Travel is eating about %d%% of the session. We may want a denser route.", "%d%% of our tracked time is travel right now. That's probably the biggest efficiency leak.", "We're at around %d%% travel time. Less commuting, more progress." })

add("rolechange", { "Group role says %s now. Play like it.", "You're marked %s. Time to act the part.", "Role updated: %s. Good to know what everyone expects from us.", "%s role. Fine, let's do the job properly.", "Group role is %s now. Adjust accordingly." })

add("talents", { "Respeccing? Good. Questioning your past decisions is healthy.", "Talent reset. Time to pretend the next build was always the plan.", "Reworking talents? I support informed regret.", "Build surgery. Choose carefully this time.", "Talent wipe confirmed. Fresh mistakes available." })
add("talentupdate", { "Talents changed. I'll update my expectations.", "Build adjusted. Let's see if it plays better.", "New talent choices. Test them before declaring victory.", "Talent update noted.", "Build changed. Time to see what actually improves." })
add("skillup", { "Skill increased. Tiny progress still counts.", "Another skill tick. Good.", "Skill improved. Competence quietly rising.", "That skill just went up.", "Progress isn't always a level. I saw the skill increase." })
