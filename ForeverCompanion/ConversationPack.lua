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
        for _, b in ipairs(endings) do
            p[#p + 1] = a .. b
        end
    end
end

-- Walking and exploration: deliberately conversational rather than informational.
cross("walking", {
    "While we walk, ", "You know, ", "Random walking thought: ", "Since we have time, ",
    "I was just thinking... ", "Between here and wherever we're going, ", "Tiny observation: ", "Okay, hear me out: ",
    "Not to interrupt the scenery, but ", "I have had several seconds to think, and ", "Travel thought: ", "For no particular reason, ",
    "As your extremely qualified traveling companion, ", "While your legs do all the work, ", "This road has given me time to conclude that ", "One thing about adventuring is ",
}, {
    "we spend an unbelievable amount of time going somewhere so we can immediately leave again.",
    "every shortcut eventually becomes a fight.",
    "the objective is always farther away when you are actually trying to get there.",
    "you walk faster when you pretend you know exactly where you're going.",
    "roads are mostly suggestions with enemies arranged beside them.",
    "I can tell the difference between exploring and being lost. I am choosing not to comment further.",
    "there is something suspicious about how confident you look with the map closed.",
    "we have passed enough scenery that I am expecting a dramatic reveal soon.",
    "if we turn around in thirty seconds, I am absolutely remembering this.",
    "I appreciate that walking gives me uninterrupted time to form opinions about you.",
    "one day I would like a quest giver to stand next to the thing they need killed.",
    "I am beginning to think 'nearby' is one of Azeroth's most flexible words.",
    "adventurers measure distance in how many mobs they can accidentally pull on the way.",
    "you have a gift for making straight lines look optional.",
    "if this becomes another mountain-goat route, I reserve the right to complain.",
    "I like the quiet parts. They make the bad decisions feel more dramatic later.",
    "somewhere ahead of us is either progress or a repair bill.",
    "there should be achievement points for arriving somewhere without checking the map six times.",
    "I am pretty sure half of leveling is travel and the other half is pretending travel is content.",
    "the scenery is nice. Your route planning remains under review.",
    "I respect the commitment to forward motion, even when the direction is questionable.",
    "I wonder how many miles we've walked for rewards we immediately replaced.",
    "there is something peaceful about walking until something decides it wants to die.",
    "the best part of a long walk is having enough time to think of new ways to make fun of you.",
})

cross("exploration", {
    "Exploration rule number one: ", "Azeroth observation: ", "I have a theory: ", "I keep noticing that ",
    "This world has taught me that ", "Adventure logic says ", "Every zone eventually proves that ", "I remain convinced that ",
    "World-travel lesson: ", "If there is one universal truth here, it is that ", "I am adding this to my notes: ", "The longer we wander, the more obvious it becomes that ",
}, {
    "the most interesting-looking cave is almost never empty.", "every abandoned building contains either treasure, ghosts, or paperwork.",
    "if a bridge looks safe, someone has probably put enemies underneath it.", "waterfalls exist primarily to make players wonder whether there is something behind them.",
    "ruins are just quest hubs that have not admitted it yet.", "if the road suddenly ends, the quest objective probably continues anyway.",
    "any peaceful field can become a massacre the moment a quest counter appears.", "the prettier the forest, the more likely something in it is cursed.",
    "every mountain contains at least one path the map refuses to explain.", "a suspiciously empty area is usually waiting for a rare spawn or an ambush.",
    "if you can see a tower in the distance, someone eventually wants you to climb it.", "Azeroth has never met a cave it didn't want to fill with spiders.",
    "old ruins are rarely as abandoned as the architecture suggests.", "the local wildlife always seems innocent until a quest asks for twenty of something.",
    "if a zone has a graveyard, we will eventually learn exactly where it is.", "beautiful scenery is often the loading screen before violence.",
    "every strange glowing crystal should be treated as guilty until proven otherwise.", "a road sign is only useful if we read it before running past it.",
    "the world is enormous, yet somehow every quest item is hidden in the least convenient corner.", "there is always one hill that looks climbable until we are halfway up it.",
})

cross("joke", {
    "Professional adventuring tip: ", "I have a joke for you: ", "Here's something deeply scientific: ", "Vexa wisdom: ",
    "I ran the numbers and ", "A completely serious observation: ", "Breaking news: ", "I have reached an important conclusion: ",
    "You may want to write this down: ", "I asked an imaginary expert and they said ", "Today's lesson is that ", "I would like to formally announce that ",
}, {
    "if the plan begins with 'what if I pull all of them,' it is not a professional plan.",
    "your repair bill is just the world's way of invoicing confidence.", "standing in fire remains a surprisingly poor long-term strategy.",
    "inventory space disappears faster when you say you have plenty of room.", "the last mob in a quest always knows you need exactly one more item.",
    "every player becomes a financial analyst the moment an epic drops.", "the quickest way to find a rare is to stop looking for it.",
    "the safest pull is always the one you did not accidentally add three friends to.", "bags are just portable arguments about what you refuse to throw away.",
    "nothing makes a player read faster than realizing they clicked the wrong dialogue option.", "every dungeon has one hallway designed specifically to test whether the group is paying attention.",
    "a 1 percent drop chance becomes emotionally indistinguishable from zero after enough attempts.", "the most dangerous phrase in any group is 'we can probably skip these.'",
    "there is no such thing as 'just one quick quest.'", "the auction house can turn a piece of cloth into an investment thesis.",
    "every class has at least one button its players insist is absolutely essential and then forget to press.", "a full bag is the natural predator of valuable loot.",
    "the moment you say 'this should be easy,' Azeroth begins preparing paperwork.", "the correct amount of gold is always slightly more than you currently have.",
    "the boss can sense when someone says 'last pull.'", "a map marker is strongest when it is least specific.",
    "the more expensive your gear becomes, the more personally you take durability loss.", "every player has at least one item in the bank whose purpose has been forgotten for years.",
    "if a quest says 'collect ten,' the tenth one is legally required to take longer than the first nine.",
})

cross("relationship", {
    "I've learned something about you: ", "After traveling with you this long, ", "I know your type now. ", "One thing I can say with confidence: ",
    "You have a very specific adventuring style: ", "I am starting to recognize the pattern: ", "You know what I find funny about you? ", "As someone who has watched your decisions closely, ",
    "We have spent enough time together that I can say this: ", "I am keeping a mental file on you, and ", "This may be the most 'you' thing about you: ", "I have noticed a recurring theme: ",
    "I should probably not encourage you, but ", "I will give you credit for one thing: ",
}, {
    "when you say 'one more thing,' I should assume we're here another hour.", "you are at your most dangerous immediately after saying 'I think I can handle this.'",
    "you somehow make efficiency and curiosity fight each other constantly.", "you can ignore a sensible route with remarkable confidence.",
    "you get noticeably more ambitious right after surviving something you probably should not have survived.", "you are very good at turning small objectives into side adventures.",
    "you clearly enjoy the moment right before a bad idea becomes irreversible.", "you are capable of excellent decisions, which makes the other decisions much harder to explain.",
    "you treat low health like a suggestion rather than a warning.", "you have never met a detour you could not justify.",
    "you become extremely focused the moment there is gold involved.", "you are weirdly charming when the plan is falling apart.",
    "you do not panic often; you simply become much faster at clicking things.", "you like progress, but you love finding something unexpected.",
    "you are much more patient with enemies than you are with loading screens.", "you can turn a simple farming route into a personal rivalry with the local wildlife.",
    "you are happiest when the XP is moving and the bags are not full.", "you will absolutely remember the one bad drop before the twenty good ones.",
    "you pretend not to care about efficiency right up until I show you a rate per hour.", "you are extremely predictable in ways I somehow still find entertaining.",
    "you make better decisions after I make fun of the bad ones. I consider that evidence of success.", "if I ever stop commenting, you may actually start missing it.",
})

cross("encourage", {
    "For what it's worth, ", "Credit where it's due: ", "I will admit this: ", "Small compliment, don't get used to it: ",
    "You know what? ", "I can be sarcastic and still say ", "Actual praise incoming: ", "I am temporarily suspending the teasing to say ",
    "One sincere thing before I recover: ", "Fine. You earned this one: ",
}, {
    "you have been pretty consistent this session.", "you recover from mistakes faster than you used to.", "your pacing is better when you stop second-guessing every move.",
    "you are getting noticeably cleaner at this.", "you keep moving even when the route gets annoying, and that matters.", "you are better at adapting than your first plan usually deserves.",
    "you make progress because you actually come back and keep going.", "you have had some genuinely sharp fights today.", "you are doing a good job keeping momentum.",
    "you are much more capable than the occasional disaster suggests.", "you have gotten better at knowing when to commit and when to leave.",
    "you are building a pretty respectable session here.", "you can absolutely finish what you started if you keep this pace.",
    "you tend to figure things out, even when the first attempt is entertainingly bad.", "your good decisions are starting to outnumber the ridiculous ones.",
    "I like this version of your play: steady, confident, and not needlessly dramatic.", "you are making enough progress that I may have to update my opinion of you.",
    "you are actually pretty good when you stop trying to prove you are invincible.", "the consistency is more impressive than one flashy moment.",
    "you keep showing up. That matters more than you think.",
})

cross("philosophy", {
    "Deep adventuring thought: ", "Philosophical question: ", "Azeroth has me wondering whether ", "I may be overthinking this, but ",
    "Consider this: ", "The strange thing about being an adventurer is that ", "If you think about it, ", "I have decided the real lesson here is that ",
    "One of these long walks eventually makes me philosophical: ", "Completely unnecessary thought of the day: ",
}, {
    "heroism is mostly doing dangerous errands for people who refuse to walk twenty yards.", "progress feels slow right up until you look back several levels.",
    "every piece of legendary gear eventually becomes an old item in a bank somewhere.", "the world keeps ending, yet somebody always has time to ask for eight boar parts.",
    "players remember the disasters longer than the flawless runs, which may explain why the disasters are more fun.", "the difference between bravery and overpulling is often whether you survived.",
    "gold only feels like a lot until you find the thing you actually want to buy.", "a good route is basically a story with less wandering.",
    "the strongest memories usually come from things that were inefficient, ridiculous, or both.", "a game world feels alive because we attach stories to places that are technically just coordinates.",
    "the best upgrades are often remembered less than the terrible item you wore for ten levels too long.", "every character slowly becomes a record of the decisions you made while playing them.",
    "there is something satisfying about watching tiny gains become a level, a fortune, or a finished goal.", "the reason farming works psychologically is that small drops become a visible pile over time.",
    "a companion mostly exists to make the quiet spaces between goals feel less empty.", "repetition feels completely different when you can measure improvement.",
    "the route matters, but the reason you keep playing usually has nothing to do with the route.", "sometimes the best session is the one where nothing important happened but you enjoyed being there.",
    "people optimize everything except the parts they actually find fun.", "the most memorable characters are usually the ones you spent enough time with to give them a personality in your head.",
})

cross("questambient", {
    "Quest-log thought: ", "While we're questing, ", "About this questing business: ", "I am looking at the general shape of our objectives and ",
    "One thing about questing: ", "Current questing mood: ", "As your unofficial quest supervisor, ", "Tiny quest observation: ",
    "I know we're supposed to be focused, but ", "Questing wisdom: ", "I would like the record to show that ", "While the log keeps growing, ",
}, {
    "finishing what is already nearby is almost always better than inventing a new detour.", "the completed ones are only valuable after we actually turn them in.",
    "every extra objective feels harmless until the log becomes a second inventory.", "the last objective always finds a way to become personal.",
    "grouping nearby objectives is how we turn wandering into a route.", "there is a special kind of satisfaction in clearing several turn-ins at once.",
    "half the skill is remembering what we were doing before the shiny thing appeared.", "a full quest log is just a to-do list with more wolves.",
    "the optimal route and the interesting route are rarely the same route.", "I support abandoning bad quests emotionally long before we abandon them mechanically.",
    "nothing improves morale like watching three objectives complete in the same area.", "the phrase 'while we're here' has created more side quests than any quest giver.",
    "if we need one more drop, I assume the entire species has agreed not to carry it.", "I appreciate quests that count kills instead of asking me to believe every animal forgot its own organs.",
    "a quest is much more charming before the fifth trip across the zone.", "we should probably turn things in before the rewards become psychologically abstract.",
    "I like progress bars because they make stubbornness look organized.", "the most dangerous quest objective is the one that looks five minutes away.",
    "the map can tell us where to go; apparently it cannot tell us why we keep stopping.", "the fastest way to finish is usually to stop adding new errands.",
})

cross("combatambient", {
    "Combat thought: ", "Between fights, ", "Regarding your recent violence: ", "I have a small tactical opinion: ",
    "One combat observation: ", "Since nothing is currently hitting us, ", "Tactical note: ", "I was reviewing your recent decisions and ",
    "A brief pause in the murder gives me time to say ", "If we're optimizing survival, ", "I have seen enough fights now to believe ", "Friendly reminder: ",
}, {
    "clean pulls are much less exciting and much better for leveling.", "the fight you skip can be more efficient than the fight you win.",
    "surviving at one percent still counts, but it should not become a brand identity.", "resource bars are useful information, not decorative UI.",
    "the best recovery is the one we never need because the pull was sensible.", "you fight better when you commit instead of hesitating halfway through.",
    "adding one extra enemy changes a fight more than people admit.", "there is no bonus XP for making every fight terrifying.",
    "fast kills feel good, but consistent kills build the pace.", "sometimes backing up three steps is more powerful than pressing another button.",
    "the moment you get comfortable is usually when a patrol appears.", "I prefer confident pulls to optimistic pulls. There is a difference.",
    "if we keep finishing fights cleanly, I will have fewer opportunities to insult you.", "cooldowns are much less useful when saved for a theoretical emergency forever.",
    "a good fight ends before I have time to become concerned.", "the most expensive enemy is the one that sends us to repair.",
    "positioning solves an amazing number of problems before damage even matters.", "I respect aggression more when it includes an exit plan.",
})

cross("townambient", {
    "Town thought: ", "While we're among civilization, ", "Since nobody is attacking us for the moment, ", "City life observation: ",
    "The nice thing about town is that ", "I know errands are not glamorous, but ", "This is the part of adventuring nobody puts in the songs: ", "Administrative heroism: ",
    "While we sort things out, ", "Civilization has its advantages: ",
}, {
    "repairs are cheaper than pretending broken gear is a challenge mode.", "bank space is just bag space that developed paperwork.",
    "the auction house can make a farmer feel like a hedge-fund manager.", "vendors are the natural end point of every item we swore might be useful later.",
    "mail is one of the few magical systems everyone uses without asking how it works.", "half of becoming stronger is buying, selling, repairing, and organizing things.",
    "a good town stop should leave us lighter, repaired, and somehow poorer.", "this is where loot turns into either upgrades, gold, or regret.",
    "inventory cleanup is deeply satisfying once somebody else does it.", "there is no shame in errands. There is only inefficient routing between errands.",
    "every bank alt is evidence that storage eventually wins.", "if we leave town with fuller bags than we arrived with, something has gone wrong.",
    "the auction house is where confidence goes to meet price history.", "I support buying upgrades. I also support not spending everything because something is shiny.",
    "town is a good time to remember the professions we keep forgetting exist.", "nothing says 'adventure' like ten minutes comparing item tooltips.",
    "we should probably repair before the next heroic catastrophe.", "selling junk is the closest thing adventurers have to taking out the trash.",
})

cross("travelambient", {
    "Travel time thought: ", "While transportation handles the hard part, ", "Since we are currently passengers, ", "This is the glamorous life: ",
    "On the road again, and ", "I have time for one observation: ", "Long-distance adventuring means ", "The upside of travel is that ",
    "As scenery passes by, ", "I could complain about the distance, but instead I'll say ",
}, {
    "at least we are moving in a direction that seems intentional.", "this is prime time for checking whether we forgot something important.",
    "there is a strange comfort in watching the world pass without needing to kill all of it.", "every long trip feels shorter when there is something valuable waiting at the end.",
    "I appreciate any form of movement that does not require us to fight the entire landscape.", "the map always looks smaller than the trip feels.",
    "someone should calculate how much of an adventurer's life is spent traveling back to people they just left.", "we have officially entered the part where I get to provide entertainment.",
    "this is either peaceful or a very long setup for the next problem.", "I am using this time to remember every questionable choice you made earlier.",
    "if the destination has a vendor, I already approve.", "the best travel route is the one that does not suddenly require swimming.",
    "transportation is one of civilization's finest achievements.", "I wonder how many quests exist solely because nobody wanted to make this trip themselves.",
    "there is something nice about not needing to press anything for a minute.", "we are making distance, which technically counts as progress.",
    "this would be a great time to admire the scenery if I were not busy monitoring you.", "if we arrive and immediately hearth somewhere else, I will have questions.",
})

cross("restambient", {
    "While we rest, ", "Quiet moment: ", "This is nice. ", "Since we're taking a minute, ",
    "I could get used to this. ", "For once, ", "A rare peaceful thought: ", "No enemies, no panic, so ",
}, {
    "you are allowed to enjoy the part where nothing is trying to kill you.", "rested XP is basically the world rewarding you for having a life outside the game.",
    "I support pauses when they prevent stupid mistakes later.", "we can be productive again in a minute. Nobody is grading us.",
    "the silence makes the next fight feel louder.", "you look almost responsible when you're standing still on purpose.",
    "I am choosing to interpret this as strategic recovery rather than distraction.", "sometimes stopping for a moment is the fastest way to avoid a corpse run.",
    "I have fewer jokes when you're making sensible decisions. This is inconvenient.", "there is something suspiciously pleasant about not being in combat.",
    "if we stay here too long, I will start telling stories.", "I could absolutely spend an entire session judging people who run past us.",
    "this is a good time to remember that progress does not disappear because you paused.", "I am relaxed enough to become dangerous conversationally.",
    "peace and quiet are underrated until the next patrol arrives.", "take the moment. Azeroth will still be chaotic when we're done.",
})

cross("goldambient", {
    "Gold-farming thought: ", "Since we're making money, ", "Economic observation: ", "Your inner goblin may appreciate this: ",
    "Farm-route thought: ", "I am watching the value stack up, and ", "One thing about farming: ", "While we chase profit, ",
    "Tiny market-brain moment: ", "This is where my spreadsheet personality comes out: ",
}, {
    "pace matters more than one lucky drop if the farm lasts long enough.", "a bad-looking item becomes interesting the second Auctionator says otherwise.",
    "vendor value is boring, but it is the floor that keeps fantasy profits honest.", "the best farm is usually the one you can repeat without hating your life.",
    "rare drops are exciting; consistent value per hour is what actually builds gold.", "a full bag can quietly destroy a good farming route.",
    "the auction value only matters if somebody is willing to buy it, which is why scan age matters.", "one expensive drop can make a mediocre route look amazing for a few minutes.",
    "I like farms where the common drops are valuable enough that luck becomes a bonus.", "time spent traveling between kills is still part of the gold-per-hour equation.",
    "the most profitable route on paper is useless if you hate running it.", "deposit costs and slow sales are the quiet enemies of beautiful auction-house math.",
    "knowing the vendor floor makes it easier to spot when the auction price is nonsense.", "every stack in the bag is either future gold or future clutter. I prefer gold.",
    "a consistent farm session is basically compound boredom converted into currency.", "if the pace is good and the route feels easy, we may have found something worth remembering.",
    "the market can change faster than your muscle memory, so fresh scan data matters.", "the best time to evaluate a farm is after enough time that one lucky drop stops dominating the average.",
    "gold per hour is useful, but gold per hour you can tolerate is the real metric.", "I will absolutely notice when you start making better money on one character than another.",
})

add("wowfact", {
    "Azeroth has two moons, commonly called the White Lady and the Blue Child.",
    "The Deeprun Tram links Stormwind and Ironforge beneath the mountains.",
    "Ironforge is built inside the mountain of Dun Morogh.",
    "Thunder Bluff sits across a collection of enormous mesas in Mulgore.",
    "The Undercity lies beneath the ruined capital of Lordaeron.",
    "Orgrimmar was named in honor of Orgrim Doomhammer.",
    "Stormwind was destroyed during the First War and later rebuilt.",
    "The Defias Brotherhood grew out of the conflict between Stormwind and the Stonemasons who rebuilt the city.",
    "Onyxia once infiltrated Stormwind's court while disguised as Lady Katrana Prestor.",
    "Hogger became one of the most famous low-level enemies in WoW history.",
    "The Crossroads became one of the most recognizable hubs in the Barrens.",
    "Mankrik's missing-wife quest became one of early WoW's most famous player stories.",
    "Barrens chat became a meme almost as quickly as the Barrens became a leveling zone.",
    "The Corrupted Blood incident in 2005 became famous enough to be discussed outside gaming.",
    "Leeroy Jenkins began as a player-made video and became one of Warcraft's most recognizable memes.",
    "The phrase 'Thunderfury, Blessed Blade of the Windseeker' became a long-running chat joke among players.",
    "Southshore and Tarren Mill were famous open-world PvP hotspots long before formal battleground queues dominated PvP.",
    "Warsong Gulch is built around capture-the-flag gameplay.",
    "Arathi Basin is won by controlling resource nodes over time.",
    "Alterac Valley was designed as a much larger battlefield than Warsong Gulch or Arathi Basin.",
    "The Deadmines run beneath Westfall and were used by the Defias Brotherhood.",
    "Edwin VanCleef led the Defias Brotherhood.",
    "Gnomeregan was devastated by both a trogg invasion and catastrophic radiation.",
    "Shadowfang Keep towers over Silverpine Forest and is closely tied to Arugal and the worgen curse.",
    "Wailing Caverns lies beneath the Barrens.",
    "Blackfathom Deeps is hidden along the coast of Ashenvale.",
    "Razorfen Kraul and Razorfen Downs are strongly associated with the quilboar.",
    "Uldaman in the Badlands contains ancient Titan-related secrets.",
    "Zul'Farrak is a troll city in Tanaris.",
    "Maraudon is deeply tied to the centaur and Princess Theradras.",
    "Dire Maul was once the Highborne city of Eldre'Thalas.",
    "Scholomance became a school for necromancy under the Cult of the Damned.",
    "Stratholme is the city Arthas ordered purged during the plague crisis.",
    "Uther the Lightbringer was one of Arthas's mentors before Arthas's fall.",
    "The Scarlet Crusade is fanatically devoted to fighting the undead, even when that fanaticism makes them dangerous to everyone else.",
    "Blackrock Mountain contains several of classic Warcraft's most famous dungeons and raids.",
    "Ragnaros was summoned into Azeroth beneath Blackrock Mountain by the Dark Iron dwarves.",
    "Molten Core lies deep beneath Blackrock Mountain.",
    "Nefarian rules Blackwing Lair from the upper reaches of Blackrock Mountain.",
    "Onyxia's Lair is hidden in Dustwallow Marsh.",
    "Gadgetzan is a goblin city in Tanaris.",
    "Booty Bay is a goblin port tucked into the southern tip of Stranglethorn Vale.",
    "Ratchet is a neutral goblin port on the eastern coast of the Barrens.",
    "The Steamwheedle Cartel operates several of Azeroth's best-known neutral goblin towns.",
    "The Gurubashi Arena in Stranglethorn Vale has a long reputation for spontaneous player-versus-player chaos.",
    "Un'Goro Crater is packed with dinosaurs, elementals, and Titan-related mysteries.",
    "Silithus is heavily associated with the silithid and the Qiraji.",
    "The Burning Steppes and Searing Gorge both sit around Blackrock Mountain.",
    "Deadwind Pass is home to Karazhan.",
    "Duskwood is one of Azeroth's most famously haunted-looking leveling zones.",
    "Westfall's story is deeply tied to the Defias Brotherhood.",
    "Lakeshire is the main settlement in Redridge Mountains.",
    "Loch Modan is named for the enormous lake at the center of the region.",
    "Menethil Harbor is one of the defining settlements of the Wetlands.",
    "Ashenvale has long been contested between night elves and the Horde.",
    "Feralas is one of Kalimdor's lushest regions.",
    "Thousand Needles is named for its towering stone spires.",
    "Azshara the zone is named after Queen Azshara.",
    "Felwood's corrupted forests are one of the clearest visual examples of demonic corruption in old Azeroth.",
    "Winterspring is one of Kalimdor's major snowy regions.",
    "The Eastern and Western Plaguelands still show the scars of the Scourge.",
    "Murlocs became iconic partly because their battle cry is immediately recognizable even when nobody agrees how to spell it.",
    "A hearthstone is one of the simplest examples of Warcraft magic becoming ordinary everyday technology.",
    "Resting in an inn or capital lets characters accumulate rested experience.",
    "Gray-quality items are usually worth more to a vendor than to your emotional attachment.",
    "Flight masters turned long journeys into a chance to stretch, snack, or stare at scenery.",
    "Rogues have historically been associated with stealth, lockpicking, poisons, and making other players nervous.",
    "Mages are famous for portals, teleportation, conjured food, and turning enemies into sheep.",
    "Warlocks are known for demons, curses, and solving problems with increasingly questionable magic.",
    "Druids can change forms to fill dramatically different roles.",
    "Shamans are defined by their relationship with the elements and, in many eras, their totems.",
    "Warriors turn getting hit and hitting things into a resource called rage, which is extremely on-brand.",
    "Priests have always lived somewhere between holy miracles and deeply unsettling shadow magic.",
    "Paladins are famous for combining heavy armor with holy magic.",
    "Hunters have one of the strongest class identities built around fighting alongside a pet.",
    "Fishing has survived every apocalypse Azeroth has thrown at it.",
    "Cooking is one of the few professions where killing monsters and making dinner naturally overlap.",
    "A surprisingly large amount of adventuring is inventory management disguised as heroism.",
    "Many of Azeroth's most dangerous problems are located suspiciously close to roads used by levelers.",
    "A lot of classic quest design assumes the player will read directions, which explains several famous community memes.",
    "The world map may look peaceful, but nearly every named region contains at least one cult, monster nest, military conflict, ancient curse, or all four.",
    "The Darkmoon Faire has spent years turning questionable carnival safety into a beloved tradition.",
    "The name 'Azeroth' can refer to the world itself, while older Warcraft material also used it more narrowly for the human kingdom around Stormwind.",
    "The Twisting Nether is closely associated with demons and fel magic.",
    "The Emerald Dream is a primal reflection of Azeroth tied strongly to druids and nature.",
    "The Titans shaped huge parts of Azeroth's ancient history without actually making every race directly themselves.",
    "The Old Gods are responsible for an impressive percentage of Azeroth's ancient bad decisions.",
    "The Dragon Aspects were empowered to protect different parts of Azeroth's natural order.",
    "The Bronze dragonflight is associated with time and protecting the proper flow of history.",
    "The Green dragonflight is closely tied to the Emerald Dream.",
    "The Red dragonflight is strongly associated with life.",
    "The Blue dragonflight is strongly associated with arcane magic.",
    "The Black dragonflight was originally charged with protecting the earth before Neltharion became Deathwing.",
    "Kalimdor and the Eastern Kingdoms are the two great landmasses most players associate with old-world Azeroth.",
    "The Maelstrom marks the catastrophic wound left by the ancient Sundering.",
    "The Sundering shattered ancient Kalimdor into the continents and islands known in later eras.",
    "The night elves' ancient conflict with the Burning Legion shaped much of Warcraft's oldest history.",
    "The Burning Legion's goal has repeatedly been to destroy or corrupt worlds across the cosmos.",
    "The Scourge combined plague, necromancy, and military conquest into one very effective nightmare.",
    "The Lich King ruled the Scourge from Northrend.",
    "Frostmourne is one of Warcraft's most famous cursed weapons.",
    "The Horde and Alliance have both spent years saving the world and then immediately finding new reasons to fight each other.",
    "Azeroth has a remarkable talent for producing world-ending emergencies on a fairly regular schedule.",
})

cross("zoneambient", {
    "Something about %s makes me think ", "Walking around %s, ", "Now that we've spent some time in %s, ", "My current opinion of %s is that ",
    "%s has a certain energy. Specifically, ", "One thing I can say about %s: ", "While we're still in %s, ", "I am adding a note about %s: ",
    "The longer we stay in %s, the more I notice that ", "If I had to summarize %s right now, I would say ",
}, {
    "the scenery is doing a lot of work to distract from the violence.", "we are eventually going to know this place better than some of its residents.",
    "every route starts looking obvious after you've run it enough times.", "the local wildlife has become far too familiar with us.",
    "this place is either growing on me or I have simply accepted our fate.", "I am starting to recognize which parts of the map are actually inconvenient.",
    "we should remember whether this place is good for XP, gold, or just stories.", "some zones become memorable because they are beautiful; others because they repeatedly try to kill you.",
    "the best thing a zone can do is give us a reason to come back without making the trip annoying.", "I like having enough history in a place that the roads stop feeling anonymous.",
    "we are slowly converting this entire area into personal data.", "I will absolutely remember if this becomes one of your favorite places to farm.",
})

-- Named relationship lines. These are formatted with the current player's name.
add("relationship_name", {
    "%s, I have been traveling with you long enough to know when that look means we're about to get distracted.",
    "%s, if you say 'this will only take a minute,' I am starting a timer.",
    "%s, I respect the confidence. I reserve judgment on the plan.",
    "%s, you are much easier to read than you think.",
    "%s, I would like one session where 'quick detour' actually means quick.",
    "%s, you know I keep score when you do something ridiculous, right?",
    "%s, I complain because I care. Also because it is entertaining.",
    "%s, we have enough history now that I can recognize your bad ideas before you finish forming them.",
    "%s, your ability to turn a simple objective into a story is honestly impressive.",
    "%s, I am starting to think you keep me around specifically for the commentary.",
    "%s, one day you are going to make a completely sensible decision and I will have nothing prepared.",
    "%s, I know exactly how this goes: we finish one thing and immediately invent three more.",
    "%s, you are doing fine. I will deny saying that if asked.",
    "%s, if the next thing you click causes chaos, I want credit for predicting it.",
    "%s, I am not saying I know you too well, but I can practically hear the detour forming.",
    "%s, I like that you keep coming back to your characters instead of treating them like disposable progress bars.",
    "%s, you have officially given me enough material to remain sarcastic indefinitely.",
    "%s, I am glad you are here. Do not make this sentimental.",
    "%s, your current plan has my cautious approval, which is more valuable than it sounds.",
    "%s, whatever we do next, try to make it interesting enough to remember and sensible enough to survive.",
})

add("characterthought", {
    "I still remember %s, your %s. Last I saw, they were level %d. Your characters have very different energy.",
    "Random memory: %s the %s is still in my notes at level %d. I do, in fact, remember the others.",
    "You know, %s the %s is sitting in my memory at level %d. I wonder what they'll be doing next time you switch.",
    "I haven't forgotten %s, your %s. Level %d when I last saw them.",
    "Cross-character thought: %s the %s was level %d the last time we traveled together.",
    "I keep separate files, you know. %s the %s is still remembered at level %d.",
    "Somewhere in my memory, %s the %s is waiting at level %d for you to come back.",
    "Your roster is becoming a cast of characters. %s the %s is still in there at level %d.",
})

-- Class-specific banter. Each class receives dozens of combinations.
local classParts = {
    WARRIOR = {
        { "Warrior thought: ", "About all that rage: ", "Heavy-armor observation: ", "As your tactical consultant: ", "One thing I enjoy about warriors: ", "Regarding the giant weapon situation: " },
        { "you solve a remarkable number of emotional problems by hitting them very hard.", "rage management is apparently just anger with accounting.", "charging first has never stopped being on-brand.", "there is something reassuring about a plan that begins with armor and ends with violence.", "the class fantasy is basically 'what if stubbornness had a health bar.'", "when the pull gets ugly, you somehow look more comfortable.", "every weapon upgrade feels like permission to become slightly less reasonable.", "I respect a class whose emergency plan is often 'hit harder.'", "you make being surrounded look like a resource-generation strategy.", "if subtlety were required, we would have rolled something else." }
    },
    SHAMAN = {
        { "Shaman thought: ", "Elemental observation: ", "About your relationship with the elements: ", "Totem-related thought: ", "One thing about shamans: ", "Nature-magic note: " },
        { "you are basically negotiating with the weather and somehow making it combat-effective.", "lightning remains one of the most satisfying ways to make a point.", "the elements seem remarkably willing to help with errands.", "totems make every fight feel like you brought portable infrastructure.", "earth, fire, water, and air give you a suspicious number of ways to solve one problem.", "healing people with water is much nicer than what you usually do with lightning.", "there is something deeply satisfying about turning a storm into a rotation.", "I like classes that can look mystical while still smashing things with a weapon.", "every elemental effect makes the fight look more expensive than it probably is.", "you have enough tools that forgetting one occasionally feels inevitable." }
    },
    ROGUE = {
        { "Rogue thought: ", "Stealth observation: ", "About all the knives: ", "Subtlety note: ", "One thing rogues understand: ", "Professional sneaking thought: " },
        { "the best fight is sometimes the one nobody realizes started.", "stealth is basically permission to be judgmental from nearby.", "you carry an impressive amount of sharp metal for someone trying not to be noticed.", "choosing when not to fight is one of the class's strongest talents.", "opening from stealth has an unfair amount of dramatic satisfaction.", "locks are just treasure boxes asking for a specialist.", "poison turns preparation into damage, which I respect.", "you make walking behind people look like a profession.", "a rogue without an escape plan is just a very confident melee class.", "subtlety lasts exactly until the first critical hit." }
    },
    PALADIN = {
        { "Paladin thought: ", "Holy-armor observation: ", "About the glowing hammer energy: ", "One thing paladins have mastered: ", "Divine thought: ", "Heavy holy magic note: " },
        { "you manage to make being heavily armored look spiritually responsible.", "the ability to become dramatically harder to kill is a useful religious perk.", "holy magic looks very polite right up until it hits something.", "you have enough defensive buttons to make bad ideas feel temptingly survivable.", "there is a special confidence that comes from knowing you can occasionally refuse death.", "healing yourself in plate armor feels mildly unfair and I approve.", "your class fantasy has a surprising amount of glowing judgment in it.", "nothing says conviction like a weapon surrounded by holy light.", "you can support a group and still look personally offended by the enemy.", "the line between righteous and stubborn gets wonderfully blurry." }
    },
    HUNTER = {
        { "Hunter thought: ", "Pet-class observation: ", "Ranged-combat note: ", "About your hunting partner: ", "One thing hunters understand: ", "Tracking thought: " },
        { "having a pet means there is always someone else available to blame for the pull.", "ranged damage feels much safer when something furry is negotiating at melee range.", "tracking creatures makes the world feel less mysterious and much more targetable.", "a good pet becomes half teammate and half ongoing story.", "traps are just tactical opinions placed on the ground.", "kiting is the art of winning while refusing to stand where the enemy wants.", "you can make wilderness survival look like a combat rotation.", "the pet usually looks innocent even when it caused everything.", "range creates confidence right up until something reaches you.", "I appreciate a class that can turn wildlife management into heroism." }
    },
    MAGE = {
        { "Mage thought: ", "Arcane observation: ", "Portal-related note: ", "About all this spellcasting: ", "One thing mages understand: ", "Magical convenience thought: " },
        { "teleportation makes everyone else's travel complaints feel less persuasive.", "turning enemies into sheep remains one of magic's funniest tactical achievements.", "conjured food is proof that enormous magical power can still be used for snacks.", "frost is basically crowd control with weather effects.", "fire magic has never been subtle and seems proud of that.", "arcane power looks elegant right up until everything explodes.", "portals may be the strongest argument for keeping a mage friend around.", "mana management is just budgeting with more glowing hands.", "you solve distance with teleportation and problems with elemental violence.", "I respect any class that can make refreshments and catastrophe using the same resource bar." }
    },
    WARLOCK = {
        { "Warlock thought: ", "Fel-magic observation: ", "Demon-management note: ", "About your completely responsible magic: ", "One thing warlocks understand: ", "Questionable-power thought: " },
        { "your solution to danger is often to bring your own danger with you.", "demons make unusual coworkers, but apparently the benefits package is competitive.", "curses are an impressively personal way to deal damage.", "fel magic has never once looked like something a safety committee approved.", "you make terrible cosmic forces look like utilities.", "draining life from enemies is efficient in a way that feels rude.", "summoning is just networking with much worse contacts.", "you operate in a permanent gray area between prepared and deeply suspicious.", "the class fantasy is basically 'I can handle forbidden power.' Bold claim.", "I appreciate that your toolkit asks what could go wrong and then uses it anyway." }
    },
    PRIEST = {
        { "Priest thought: ", "Holy-and-shadow observation: ", "About your spiritual versatility: ", "One thing priests understand: ", "Healing thought: ", "Shadowy little observation: " },
        { "your class can move from comforting miracle to nightmare magic with impressive speed.", "keeping people alive is a strange way to become responsible for everyone else's mistakes.", "shadow magic makes faith look considerably more complicated.", "healing is basically correcting damage after the group ignores several warnings.", "you can be the calmest person in a fight while monitoring everyone's impending disaster.", "discipline is an excellent name for a spec that manages other people's chaos.", "holy magic feels reassuring until the priest starts talking about the void.", "few roles make you appreciate health bars as much as healing.", "supporting a group is easier when the group occasionally supports your sanity.", "you have access to both hope and existential dread, which feels versatile." }
    },
    DRUID = {
        { "Druid thought: ", "Shape-shifting observation: ", "Nature-magic note: ", "About the form-changing: ", "One thing druids understand: ", "Wild little thought: " },
        { "having a different body for every problem is admittedly efficient.", "shape-shifting turns wardrobe changes into combat mechanics.", "nature magic is very peaceful until the roots start attacking people.", "you can solve transportation, combat, and stealth by becoming something else.", "the class fantasy is basically refusing to choose one job.", "turning into an animal makes every mount discussion slightly awkward.", "healing with nature feels wholesome until someone gets mauled by the same nature.", "forms make your action bars look like several characters sharing one account.", "you are living evidence that versatility can become a personality trait.", "I respect the ability to answer 'what role are you?' with 'yes.'" }
    },
    DEATHKNIGHT = {
        { "Death knight thought: ", "Runeblade observation: ", "Undead-knight note: ", "About the whole death-powered thing: ", "One thing death knights understand: ", "Very cheerful class thought: " },
        { "you make grim determination look like a resource system.", "runes turn combat into a surprisingly organized form of necromancy.", "the class aesthetic has never been accused of excessive optimism.", "death magic looks remarkably practical when used for tanking.", "being difficult to kill has extra irony when death is already in the job title.", "you bring a strong 'the problem is coming to me' energy to fights.", "runeblades are extremely dramatic tools for routine questing.", "your class makes ordinary plate armor look underdressed.", "few people can make a sunny zone feel colder just by standing there.", "I appreciate how committed the entire class is to the theme." }
    },
    MONK = {
        { "Monk thought: ", "Martial-arts observation: ", "Brew-related note: ", "About all the rolling around: ", "One thing monks understand: ", "Balance thought: " },
        { "rolling is both transportation and a statement about patience.", "punching monsters while everyone else carries weapons is a confident choice.", "brews make the class feel like combat and hospitality accidentally merged.", "mobility solves a lot of problems before they become problems.", "balance sounds philosophical until someone gets kicked in the face.", "you make hand-to-hand combat look much more organized than it feels.", "there is something satisfying about movement being part of the rotation.", "the class proves that robes do not prevent aggressive problem solving.", "chi makes spiritual focus look mechanically useful.", "I respect a class that can heal, tank, or hit things while still finding time for tea." }
    },
    DEMONHUNTER = {
        { "Demon hunter thought: ", "Fel-powered observation: ", "Glaive-related note: ", "About all the jumping: ", "One thing demon hunters understand: ", "Extremely dramatic class thought: " },
        { "you have turned mobility into a personality.", "double jumping makes ordinary staircases feel like a personal insult.", "glaives are what happens when swords decide they need more attitude.", "fel power apparently comes with excellent visual effects.", "the class has never once entered a room quietly by accident.", "gliding makes cliffs feel more like opportunities than threats.", "you fight like the floor offended you personally.", "mobility can become its own form of overconfidence remarkably quickly.", "few classes are this committed to looking dramatic while traveling.", "the phrase 'I sacrificed everything' somehow still leaves room for very stylish combat." }
    },
    EVOKER = {
        { "Evoker thought: ", "Dragon-magic observation: ", "Dracthyr note: ", "About the whole dragon thing: ", "One thing evokers understand: ", "Scaled little thought: " },
        { "breathing magic at problems is difficult to improve on aesthetically.", "dragonflight magic makes ordinary spell schools look under-specialized.", "wings solve several travel arguments before they begin.", "being part dragon is an aggressively strong class identity.", "empowered spells make timing feel more theatrical than simply pressing a button.", "you have enough magical ancestry packed into one toolkit to confuse a historian.", "the class aesthetic assumes subtlety is optional.", "healing with dragon magic somehow makes the medical explanation less important.", "you look like the encounter mechanic and the player at the same time.", "few classes can literally bring dragon energy to routine errands." }
    },
}

for token, parts in pairs(classParts) do
    cross("class_" .. token, parts[1], parts[2])
end

function FC:RefreshVocabularyStats()
    local total, pools = 0, 0
    for _, lines in pairs(self.dialogue.Vexa or {}) do
        if type(lines) == "table" then total = total + #lines; pools = pools + 1 end
    end
    for _, lines in pairs(self.dialogue.common or {}) do
        if type(lines) == "table" then total = total + #lines end
    end
    self.vocabularyCount = total
    self.vocabularyPools = pools
    return total, pools
end

FC:RefreshVocabularyStats()
