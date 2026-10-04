local FC = _G.ForeverCompanion

-- Arrival dialogue is intentionally separate from ambient dialogue. These lines are
-- high-salience: the player hears them at login or when crossing into a new zone.
-- Keep a deeper recent-history window here than ordinary chatter so arrivals do not
-- feel like the same three sentences shuffled around.

local loginOpeners = {
    "There you are, %s.",
    "Look who finally showed up, %s.",
    "Back in the saddle, %s.",
    "All right, %s, we're live again.",
    "Welcome back, %s.",
    "I was wondering when you'd come back, %s.",
    "Good, %s. I was getting bored.",
    "And just like that, %s is back on the board.",
    "Well, well. %s returns.",
    "Session started. %s has entered the chaos.",
    "There is my favorite source of questionable decisions: %s.",
    "Ah. %s. Now the day can become dangerous properly.",
    "The world was suspiciously quiet without you, %s.",
    "Okay, %s. I'm awake. You're awake. Close enough.",
    "Back again, %s? Good. I had notes.",
    "I knew the peace and quiet couldn't last, %s.",
    "Hello again, %s. Try to surprise me today.",
    "All systems questionable, %s. Let's begin.",
    "There you are. I kept your seat warm, %s.",
    "Right on time for trouble, %s.",
    "I see %s has decided productivity is an option today.",
    "Good timing, %s. Azeroth was running low on chaos.",
    "Welcome back to the poor-decision simulator, %s.",
    "Okay, %s. Resume adventure.",
    "The file is open again, %s. Let's add something interesting to it.",
    "Back online, %s. I hope you brought a plan. Or snacks.",
    "You logged in. I have opinions. Nature is healing, %s.",
    "All right, troublemaker. %s is back.",
    "I recognize that look, %s. We're about to get distracted, aren't we?",
    "Fine, %s. One more adventure. Twist my arm.",
    "I was enjoying the silence, %s. Ruined now.",
    "There is the %s I remember.",
    "Back to work, %s. Or whatever we call what you do.",
    "Okay. %s has logged in. Everybody act natural.",
    "Good. %s is here. Let's make the session worth remembering.",
    "The loading screen is gone, %s. No excuses now.",
    "You're back, %s. I assume we learned nothing from last time.",
    "Welcome back, menace. Yes, I mean you, %s.",
    "Ready when you are, %s. Mostly.",
    "I had a quiet moment. Then %s logged in.",
}

local loginClosers = {
    "Level %d %s in %s. Let's make some progress.",
    "You're a level %d %s in %s right now. I know where we left the mess.",
    "Level %d, %s, standing in %s. Give me something interesting to narrate.",
    "We're starting at level %d on the %s in %s. Let's see where we end up.",
    "Level %d %s. %s is today's stage. Try not to die during the opening act.",
    "Current situation: level %d %s, %s. Plenty of ways this can go wrong.",
    "The file says level %d %s in %s. The file also says I should supervise you.",
    "You're level %d on the %s in %s. Let's improve at least one number today.",
    "Level %d %s. Location: %s. Mood: cautiously entertained.",
    "We've got a level %d %s in %s and absolutely no guarantee of good judgment.",
    "Level %d %s, %s. I vote for XP, loot, and only the tasteful amount of disaster.",
    "Starting coordinates, emotionally speaking: level %d %s in %s. Let's move.",
    "You brought the level %d %s to %s. I'll bring the commentary.",
    "Level %d %s. %s has us for now. Let's leave with something worth remembering.",
    "The level %d %s is currently in %s. Yes, I'm keeping track.",
    "Level %d %s in %s. New session, clean slate. Your old decisions remain on file.",
    "We're back at level %d on the %s, currently in %s. Pick a direction and make it convincing.",
    "Today begins with a level %d %s in %s. I expect at least one story out of this.",
    "Level %d %s in %s. All right. Let's see what the world has queued up for us.",
    "Status check: level %d %s in %s. Good enough. Adventure first, paperwork later.",
    "Level %d %s. %s. Same world, different set of bad ideas.",
    "We are officially a level %d %s in %s again. I give the situation seven out of ten potential disasters.",
    "Level %d %s. %s is where we begin. Let's make it count.",
    "Level %d %s in %s. I have no idea what you're about to do, which is half the fun.",
}

local loginWildcards = {
    "Before you ask: yes, I remembered you.",
    "I have a feeling the spacebar is about to suffer again.",
    "Try to keep the corpse runs artistically defensible.",
    "No pressure, but I am absolutely keeping score.",
    "If there is a terrible shortcut nearby, I assume you'll find it.",
    "Remember: confidence is not the same thing as having a plan.",
    "I brought sarcasm. You bring survivability.",
    "Let's make future-us proud. Or at least less annoyed.",
    "I expect efficiency, loot, and one completely unnecessary detour.",
    "Today's objective: progress with minimal public embarrassment.",
    "You handle the controls. I'll handle the unsolicited observations.",
    "If nothing else, give me something good to put in the journal.",
    "I am prepared to be impressed. Do not make me regret that sentence.",
    "Fresh session, fresh opportunities to blame pathing.",
    "Let's see whether today is a clean-run day or a learning-experience day.",
    "My standards are reasonable: progress, survival, and entertaining chaos.",
    "If we get lost, I am documenting whose idea it was.",
    "I am rooting for you in the least emotionally vulnerable way possible.",
}

-- The profile table keeps zone-specific flavor compact while allowing a large pool of
-- genuinely different lines for each zone. Every entry supplies vocabulary that only
-- belongs to that place; the templates below create multiple arrivals from it.
local Z = {
    ["Elwynn Forest"] = { "green roads and deceptively peaceful fields", "wolves, kobolds, and low-level confidence", "settle into the road and keep moving", "Even the sheep look like they know something." },
    ["Westfall"] = { "dust, windmills, and a sky that never quite cheers up", "bandits and long walks between problems", "keep the route tight and watch the fields", "Nothing says adventure like agricultural despair." },
    ["Redridge Mountains"] = { "red stone, lakeside roads, and trouble on every ridge", "tight paths and enemies with elevation", "use the roads until the roads betray us", "Scenic views, tactical inconvenience." },
    ["Duskwood"] = { "fog, crooked trees, and aggressively bad vibes", "things in the dark that absolutely have a grudge", "keep an eye on the roads and graveyards", "If the forest whispers, I vote we keep moving." },
    ["Stranglethorn Vale"] = { "jungle heat, ruins, and professional-grade chaos", "cats, trolls, pirates, and players with opinions", "watch the paths and keep an escape route", "Every vine here feels like it is hiding a quest mob." },
    ["Northern Stranglethorn"] = { "thick jungle and roads that invite ambushes", "predators, trolls, and too many reasons to leave the road", "move with purpose and watch the tree line", "The jungle is beautiful in a very predatory way." },
    ["The Cape of Stranglethorn"] = { "coastal jungle, pirates, and questionable harbor energy", "tight camps and things that enjoy surprise attacks", "keep the route clean and the bags open", "Somewhere nearby, a pirate is making a poor career decision." },
    ["Deadwind Pass"] = { "empty roads and the kind of silence that feels deliberate", "very little comfort and too much atmosphere", "do what we came for and do not linger without a reason", "This place could make a sunny day feel haunted." },
    ["Swamp of Sorrows"] = { "mud, mist, and water with commitment issues", "crocolisks, cramped paths, and swamp geometry", "keep to useful ground and avoid unnecessary swimming", "My boots already hate this place." },
    ["Blasted Lands"] = { "scorched ground and end-of-the-world landscaping", "demons, bad terrain, and zero interest in hospitality", "stay focused and make every trip count", "Subtlety was not invited to the landscape meeting." },
    ["Burning Steppes"] = { "black rock, fire, and mountains that look personally offended", "dragons, lava, and vertical inconvenience", "watch the slopes and keep the route efficient", "The ground itself appears to be in combat." },
    ["Searing Gorge"] = { "smoke, iron, and industrial misery", "steep paths, dwarves, and fire in inconvenient places", "plan the climbs before committing to them", "Somebody looked at a mountain and thought: needs more furnace." },
    ["Dun Morogh"] = { "snowy roads, stone ridges, and cold little valleys", "troggs, wolves, and terrain that hides behind white paint", "keep the path clean and enjoy the visibility while it lasts", "At least the snow makes the bad decisions look picturesque." },
    ["Loch Modan"] = { "open roads, rocky hills, and a very large lake", "troggs, wildlife, and long scenic detours", "use the roads and resist sightseeing at the wrong time", "Pretty place. Suspicious amount of walking." },
    ["Wetlands"] = { "rain, marsh, and roads that seem longer when soaked", "raptors, crocolisks, and water where roads should be", "stick to the useful route and keep moving", "Everything here is either damp or trying to bite us." },
    ["Arathi Highlands"] = { "rolling highlands, old ruins, and wide-open roads", "trolls, ogres, and fights with plenty of room", "use the open terrain and keep the pace up", "You can see trouble coming here. That has never stopped us." },
    ["The Hinterlands"] = { "green cliffs, old paths, and terrain with too many opinions", "trolls, beasts, and vertical travel", "choose the route before the mountain chooses it for us", "This zone has never met a straight road it liked." },
    ["Hillsbrad Foothills"] = { "farmland, foothills, and history packed into every road", "patrols, crowded quest pockets, and old grudges", "keep moving between objectives and avoid pointless detours", "Peaceful countryside, if you ignore absolutely everything happening in it." },
    ["Silverpine Forest"] = { "dark pines, cold roads, and permanent evening energy", "wolves, undead, and low-visibility trouble", "stay on the road until there is a good reason not to", "The forest has the lighting of a bad decision." },
    ["Tirisfal Glades"] = { "gray skies, dead fields, and gothic starter-zone confidence", "undead problems and suspiciously lively graveyards", "keep the early route smooth and efficient", "Charming, if your definition of charming includes crypts." },
    ["Western Plaguelands"] = { "scarred fields trying very hard to recover", "undead pockets and roads with history", "work methodically and do not overpull", "This place feels like it remembers every fight." },
    ["Eastern Plaguelands"] = { "ruined countryside, old roads, and heavy atmosphere", "undead everywhere and very little room for complacency", "watch the pulls and keep an exit path", "Even the wind here sounds tired." },
    ["Badlands"] = { "red dust, broken stone, and enormous amounts of nothing between fights", "elementals, wildlife, and travel time", "group objectives together before crossing the zone", "The rocks have rocks. Very ambitious geology." },
    ["Stormwind City"] = { "crowded streets, stone towers, and civilization pretending to be organized", "vendors, banks, and the temptation to stand around forever", "do the errands and escape before productivity dies", "A city visit can become an hour if I stop supervising." },
    ["Ironforge"] = { "stone halls, molten metal, and dwarven engineering at full volume", "stairs, tunnels, and getting turned around indoors", "handle the errands before we forget why we came", "Nothing says cozy like living beside a giant forge." },
    ["Undercity"] = { "green light, stone corridors, and questionable ventilation", "elevators, circular navigation, and undead interior design", "finish the errands before the layout wins", "Every hallway here looks like it knows a secret." },
    ["Silvermoon City"] = { "bright stone, red banners, and magical confidence", "beautiful streets designed to encourage wandering", "stay on task unless sightseeing is the task", "This city is dangerously good at looking expensive." },
    ["Eversong Woods"] = { "golden trees, bright roads, and polished magical scenery", "mana problems and creatures hiding behind pretty colors", "keep the route sharp despite the scenery", "Everything here looks too elegant to be hostile. Yet here we are." },
    ["Ghostlands"] = { "dead forests, red earth, and a sky that refuses optimism", "undead, trolls, and scarred roads", "keep the objectives grouped and the pace steady", "The name was not exactly subtle marketing." },
    ["Isle of Quel'Danas"] = { "sunlit ruins, arcane energy, and endgame traffic", "dense objectives and enemies packed close together", "watch the pulls and keep the route deliberate", "Very pretty island. Alarmingly little personal space." },
    ["Durotar"] = { "red dirt, hard sun, and starter-zone stubbornness", "boars, scorpids, and cliffs in all the wrong places", "keep the path simple and the fights clean", "The landscape has exactly one color and a lot of confidence." },
    ["Mulgore"] = { "wide grasslands, tall mesas, and actual breathing room", "wildlife and very long distances between bad ideas", "enjoy the open terrain and keep the route direct", "This place almost makes me believe in peaceful leveling." },
    ["Teldrassil"] = { "purple forests, giant roots, and dreamlike paths", "spiders, furbolgs, and roads that curve because they can", "keep track of the route before the trees rearrange our sense of direction", "Beautiful place. Terrible for people who navigate by confidence." },
    ["Darkshore"] = { "gray coastlines, dark woods, and permanent drizzle energy", "wildlife, ruins, and long coastal travel", "stack objectives and avoid pointless backtracking", "The weather has apparently chosen melancholy." },
    ["Ashenvale"] = { "deep forest, ancient roads, and moonlit war-zone energy", "tight paths, patrols, and trees blocking every shortcut", "respect the roads until we know the terrain", "The forest is gorgeous and absolutely not interested in convenience." },
    ["The Barrens"] = { "endless savanna, dusty roads, and legendary amounts of travel", "centaurs, quillboars, and distance itself", "bundle the quests before crossing half the continent", "Somewhere, someone is still asking where Mankrik's wife is." },
    ["Northern Barrens"] = { "dry plains, long roads, and classic Barrens scale", "quillboars, centaurs, and travel time", "plan the loop before the loop plans us", "The horizon is mostly an estimate of how long we have to walk." },
    ["Southern Barrens"] = { "scarred savanna, broken roads, and hotter tempers", "battle lines and terrain that interrupts clean travel", "keep objectives clustered and avoid unnecessary crossings", "The zone looks like somebody argued with a map." },
    ["Stonetalon Mountains"] = { "sharp ridges, narrow passes, and vertical annoyance", "harpies, cliffs, and roads that double back", "look before jumping and plan the climb", "Every shortcut here eventually becomes a geology lesson." },
    ["Desolace"] = { "bleached plains, dry wind, and aggressive emptiness", "centaurs, demons, and distances that feel personal", "make the route count before crossing the wasteland", "Even the scenery looks dehydrated." },
    ["Feralas"] = { "thick jungle, ancient ruins, and giant trees hiding giant problems", "ogres, wildlife, and roads swallowed by green", "keep the compass honest and the objectives grouped", "The plants here could probably win a duel." },
    ["Thousand Needles"] = { "towering stone spires and roads with dramatic drop-offs", "cliffs, travel, and questionable shortcut opportunities", "respect the height and plan the crossings", "You are absolutely going to jump off something, aren't you?" },
    ["Tanaris"] = { "sand, ruins, pirates, and a horizon full of heat", "wastes, bandits, and long rides between objectives", "bundle the work and keep water metaphorically nearby", "The desert is mostly beige with occasional violence." },
    ["Un'Goro Crater"] = { "prehistoric jungle, steam vents, and oversized everything", "dinosaurs, elementals, and sudden teeth", "watch the surroundings and never assume the path is safe", "If it moves, there is a fair chance it is enormous." },
    ["Silithus"] = { "sand, hives, and unsettling insect architecture", "silithid, cultists, and ground that probably has tunnels under it", "keep the pulls controlled and the route deliberate", "I preferred the desert before it started buzzing." },
    ["Winterspring"] = { "bright snow, frozen forests, and blue-white silence", "frosty wildlife and long mountain routes", "keep moving and let the scenery pay for the travel time", "Cold enough to make even bad decisions feel crisp." },
    ["Azshara"] = { "coastal cliffs, ancient ruins, and magic in the landscape", "awkward terrain and enemies placed where roads are not", "use the route we have instead of inventing worse ones", "This zone has always been prettier than it is convenient." },
    ["Dustwallow Marsh"] = { "humid swamp, twisted trees, and muddy roads", "crocolisks, spiders, and water in every direction", "stay on solid ground whenever possible", "I can feel the mosquitoes judging our armor choices." },
    ["Moonglade"] = { "quiet forests, moonlit water, and rare actual calm", "mostly the danger of forgetting why we came", "enjoy the peace and handle the reason for the trip", "Suspiciously serene. I do not trust it." },
    ["Orgrimmar"] = { "red stone, spikes, and a city built like an argument", "stairs, valleys, and getting distracted by services", "do the city business before we settle in permanently", "The architecture says subtlety lost the vote." },
    ["Thunder Bluff"] = { "open mesas, rope bridges, and a lot of sky", "elevators and the consequences of not watching your step", "handle the errands and respect gravity", "Beautiful city. Terrible place to discover autorun." },
    ["Darnassus"] = { "purple stone, quiet pools, and ancient-tree serenity", "winding paths and very relaxed navigation", "finish the errands before the calm turns into idling", "This place could make banking feel ceremonial." },
    ["The Exodar"] = { "crystal halls, alien geometry, and glowing technology", "ramps, circles, and indoor navigation puzzles", "keep track of the exit while we run errands", "Very advanced. Still somehow easy to get lost." },
    ["Azuremyst Isle"] = { "blue forests, crystal wreckage, and strange coastal light", "mutated wildlife and unfamiliar paths", "learn the route early and keep objectives close", "Everything glows just enough to be suspicious." },
    ["Bloodmyst Isle"] = { "red-tinted forests and a landscape that looks mildly radioactive", "mutated creatures and heavier atmosphere", "stay focused and clear objectives efficiently", "The color palette is doing a lot of warning for us." },
    ["Hellfire Peninsula"] = { "red wasteland, giant fortifications, and a sky full of bad omens", "demons, fel orcs, and things dropping from above", "keep the pulls clean and the route ruthless", "Welcome to Outland. Subtle opening, isn't it?" },
    ["Zangarmarsh"] = { "giant mushrooms, blue marshlight, and alien wetlands", "naga, bog creatures, and water routes", "watch the terrain and group the objectives", "The mushrooms are larger than some buildings. Fine. Totally normal." },
    ["Terokkar Forest"] = { "dark forests, bone-white ruins, and roads under a broken sky", "arakoa, spirits, and scattered quest hubs", "keep the travel efficient and watch the trees", "Outland somehow made forests feel extraterrestrial." },
    ["Nagrand"] = { "floating islands, open grassland, and absurdly good scenery", "ogres, beasts, and the temptation to stop and stare", "enjoy the view without murdering the pace", "This is the sort of zone that makes screenshots dangerous to productivity." },
    ["Blade's Edge Mountains"] = { "jagged peaks, spikes, and vertical hostility", "ogres, dragons, and roads that hate straight lines", "plan every climb before committing", "Somebody designed a mountain range entirely out of bad posture." },
    ["Netherstorm"] = { "floating rock, arcane storms, and geography held together by optimism", "mana creatures and edges with no ground beyond them", "watch your footing and keep the route deliberate", "The planet is literally falling apart. Very motivating." },
    ["Shadowmoon Valley"] = { "fel fire, black temples, and skies full of menace", "demons, elite pockets, and dangerous terrain", "stay sharp and do not wander into the wrong camp", "If evil needed a brochure photo, this would be on the cover." },
    ["Shattrath City"] = { "layered terraces, glowing light, and neutral-city traffic", "elevators, portals, and errand sprawl", "finish the city loop before we lose the objective", "Every faction is here, which is excellent for commerce and terrible for focus." },
    ["Borean Tundra"] = { "frozen coast, wide tundra, and the first real bite of Northrend", "scattered enemies and long icy routes", "group the objectives before crossing the open ground", "Northrend really opens with 'hope you packed layers.'" },
    ["Howling Fjord"] = { "towering cliffs, cold sea, and dramatic northern scenery", "vrykul, steep paths, and vertical travel", "respect the cliffs and keep the route intentional", "Everything here looks like it belongs on a metal album cover." },
    ["Dragonblight"] = { "snowy wastes, dragon bones, and enormous horizons", "undead, dragons, and long travel lines", "bundle the quests and keep moving across the open ground", "The skeletons are large enough to qualify as landmarks." },
    ["Grizzly Hills"] = { "pine forests, rivers, and suspiciously peaceful mountain views", "wildlife, trolls, and getting distracted by the music", "keep the route moving even if the scenery wins", "This zone is dangerously good at making us forget the objective." },
    ["Zul'Drak"] = { "icy terraces, troll ruins, and grim northern altitude", "trolls, undead, and stacked elevation", "work one tier at a time and avoid needless backtracking", "The stairs have stairs. We are climbing whether we like it or not." },
    ["Sholazar Basin"] = { "lush jungle trapped inside a frozen continent", "beasts, elementals, and sudden terrain changes", "watch for dense pulls and take advantage of the open basin", "Northrend hid a tropical surprise in the middle of the ice. Sure." },
    ["The Storm Peaks"] = { "enormous mountains, frozen ruins, and clouds below our feet", "vertical travel and enemies on every ledge", "think in three dimensions and do not waste the flight path", "At this altitude, every bad jump becomes a long story." },
    ["Icecrown"] = { "black ice, undead fortresses, and endgame menace everywhere", "dense undead, elite areas, and very little kindness", "stay deliberate and keep an escape route", "The architecture is basically 'what if doom had zoning permits?'" },
    ["Wintergrasp"] = { "frozen battlefield, siege roads, and open PvP tension", "players, vehicles, and objectives changing hands", "keep situational awareness higher than usual", "This is not the place to admire your inventory screen." },
    ["Crystalsong Forest"] = { "crystal trees, magical light, and an unusually quiet patch of Northrend", "mostly the temptation to treat it as scenery", "enjoy the view and keep the destination in mind", "The forest looks expensive." },
    ["Dalaran"] = { "floating streets, portals, and enough magic to make physics optional", "crowds, vendors, and endless reasons to stop moving", "do the errands before we become permanent residents", "A flying city should feel less normal than this." },
    ["Mount Hyjal"] = { "ancient forests, burning front lines, and enormous history", "elementals, cultists, and fire where trees would prefer otherwise", "push the objectives while the route stays clear", "The mountain has seen enough drama and apparently wants more." },
    ["Vashj'ir"] = { "open ocean, glowing reefs, and three-dimensional navigation", "naga, sea creatures, and forgetting which way is up", "watch depth as much as distance", "I would like to file a complaint with the concept of underwater questing." },
    ["Deepholm"] = { "stone shelves, crystal caverns, and a world made almost entirely of geology", "elementals and vertical cave travel", "use the flight paths and keep orientation", "The rocks here have stronger personalities than some NPCs." },
    ["Uldum"] = { "desert ruins, giant statues, and sun-baked spectacle", "tol'vir, cultists, and long sandy routes", "bundle objectives and keep the travel efficient", "Ancient civilization really knew how to build for dramatic entrances." },
    ["Twilight Highlands"] = { "stormy highlands, war camps, and dragon-heavy skies", "cultists, dragons, and rough elevation", "watch the ridges and keep pulls controlled", "The weather is doing half the intimidation for them." },
    ["Tol Barad"] = { "island fortifications, prison ruins, and PvP tension", "players, tightly packed enemies, and objective pressure", "stay alert and avoid getting tunnel vision", "Nothing says relaxing island trip like siege warfare." },
    ["The Jade Forest"] = { "green valleys, misty temples, and a very polished first impression", "hozen, mogu, and paths winding through dense scenery", "learn the roads before freelancing shortcuts", "Pandaria clearly decided first impressions matter." },
    ["Valley of the Four Winds"] = { "farmland, rolling hills, and suspiciously comfortable scenery", "virmen, mantid trouble, and food-related distractions", "keep objectives together and enjoy the easy terrain", "This may be the only zone capable of making us hungry." },
    ["Krasarang Wilds"] = { "humid jungle, beaches, and ruins tucked into the green", "saurok, mogu, and swampy travel", "keep the route tight through the vegetation", "Pretty coast. Hostile everything else." },
    ["Kun-Lai Summit"] = { "snowy mountains, high passes, and giant views", "yaungol, mogu, and a lot of climbing", "respect the elevation and use flight wisely", "Another zone where gravity is an active faction." },
    ["Townlong Steppes"] = { "windswept grassland and a wall holding back worse problems", "mantid and wide-open combat", "keep moving and use the open ground", "The horizon feels very calm for a place with this many insects." },
    ["Dread Wastes"] = { "amber skies, dark swamps, and unsettling insect country", "mantid, sha, and terrain with bad intentions", "control the pulls and stay aware of the surroundings", "The word 'dread' was not marketing exaggeration." },
    ["Vale of Eternal Blossoms"] = { "golden architecture, green valleys, and capital-zone polish", "crowds, daily routes, and endless errands", "do the circuit before we get distracted", "Everything here looks important enough to have paperwork." },
    ["Isle of Thunder"] = { "stormy cliffs, mogu ruins, and constant electrical drama", "trolls, mogu, and dense enemy pockets", "keep the pulls deliberate and watch the edges", "Apparently regular thunder was not dramatic enough." },
    ["Timeless Isle"] = { "lush cliffs, hidden paths, and treasure-hunt energy", "rare mobs, elites, and distractions everywhere", "keep an eye out for opportunities without losing the plan", "This island is basically weaponized curiosity." },
    ["Frostfire Ridge"] = { "snow, lava, and mountains arguing about temperature", "ogres, beasts, and brutal terrain", "use the ridges carefully and keep the route efficient", "Fire and ice together. Subtle climate design." },
    ["Shadowmoon Valley (Draenor)"] = { "moonlit forests, pale fields, and Draenor at its prettiest", "orc camps and creatures hiding in calm scenery", "stay focused despite the view", "This version of Shadowmoon is almost suspiciously peaceful." },
    ["Gorgrond"] = { "massive plants, black rock, and nature fighting itself", "beasts, botani, and terrain built for ambushes", "watch the path and expect something enormous", "The ecosystem appears to have chosen violence." },
    ["Talador"] = { "bright forests, draenei ruins, and war moving through beautiful country", "orc forces and scattered fronts", "keep the route purposeful between hubs", "The scenery deserved a quieter expansion." },
    ["Spires of Arak"] = { "towering spires, shadowed forests, and arakkoa territory", "cliffs, birds, and awkward vertical paths", "watch the elevation and choose routes carefully", "Bird people built a zone around making us look up constantly." },
    ["Nagrand (Draenor)"] = { "open grasslands, floating rocks, and familiar beauty with a different history", "ogres, beasts, and long open routes", "keep the pace up without ignoring the scenery", "Apparently Nagrand is good in every timeline." },
    ["Tanaan Jungle"] = { "dense fel jungle and endgame danger packed into every clearing", "demons, elites, and crowded objectives", "stay sharp and avoid stacking unnecessary pulls", "The jungle upgraded from dangerous to aggressively green fire." },
    ["Azsuna"] = { "blue coastline, ancient ruins, and shattered magical history", "demons, naga, and cliffs near everything", "keep the route deliberate and enjoy the coast when safe", "Beautiful ruins. Azeroth has a talent for those." },
    ["Val'sharah"] = { "deep emerald forest and druidic dream energy", "satyrs, corrupted wildlife, and winding paths", "trust the roads more than the shortcuts", "The forest is lovely right up until it starts being haunted." },
    ["Highmountain"] = { "towering peaks, rivers, and altitude as a gameplay mechanic", "harpies, drogbar, and cliffs everywhere", "plan the vertical route before charging ahead", "If we fall from here, I am blaming geography." },
    ["Stormheim"] = { "stormy cliffs, vrykul halls, and heroic amounts of wind", "steep terrain and enemies who enjoy high ground", "keep footing and route awareness", "Every hill here wants to become a saga." },
    ["Suramar"] = { "arcane city lights, vineyards, and elegant danger", "guards, mana problems, and dense urban paths", "move carefully and do not turn every street into a fight", "This city is far too pretty for how often it wants us arrested." },
    ["Broken Shore"] = { "fel-scarred coastline and invasion energy", "demons, elites, and little downtime", "keep pulls deliberate and stay ready for chaos", "Vacation property remains affordable for obvious reasons." },
    ["Argus"] = { "fel skies, shattered terrain, and the Legion's home-field advantage", "demons, elites, and hostile geography", "stay focused and use every safe route we find", "We came to another planet and it is somehow still mostly demons." },
    ["Drustvar"] = { "foggy woods, crooked villages, and excellent horror atmosphere", "witchcraft, beasts, and roads that look guilty", "keep moving and do not trust anything decorative", "This place makes Duskwood look emotionally available." },
    ["Tiragarde Sound"] = { "rocky coastlines, busy ports, and naval-country confidence", "pirates, hills, and winding roads", "use the roads and group the objectives", "Everybody here owns either a boat or a problem." },
    ["Stormsong Valley"] = { "green farmland, cliffs, and sea-priest country", "quilboar, tidesages, and wide travel", "keep the route efficient across the open valleys", "Very pastoral, right up until the ocean cults start." },
    ["Zuldazar"] = { "golden temples, dense jungle, and stairs with ambition", "dinosaurs, trolls, and vertical city travel", "plan the climbs and avoid unnecessary detours", "The architecture is magnificent. My calves disagree." },
    ["Nazmir"] = { "swamp, blood-red danger, and ancient troll ruins", "blood trolls, beasts, and waterlogged paths", "keep to solid ground and control pulls", "The swamp has somehow become more threatening than usual." },
    ["Vol'dun"] = { "desert dunes, ruins, and harsh survival-country energy", "sethrak, beasts, and long hot routes", "bundle the work before crossing the sand", "The desert has snakes with architecture. Great." },
    ["Nazjatar"] = { "ocean floor exposed to the sky and naga territory everywhere", "naga, vertical coral terrain, and dense enemy pockets", "watch elevation and keep the route deliberate", "We are walking where the ocean used to be. This seems healthy." },
    ["Mechagon Island"] = { "scrap metal, machines, and mechanical improvisation everywhere", "robots, gadgets, and collectible distractions", "keep an eye on useful parts without losing the route", "Somebody turned a junkyard into an engineering religion." },
    ["Bastion"] = { "bright skies, floating architecture, and suspiciously perfect lawns", "constructs, aspirants, and serene-looking danger", "keep the objectives moving despite the postcard scenery", "This place is almost offensively clean." },
    ["Maldraxxus"] = { "bone, slime, and military necromancy with zero subtlety", "undead armies and terrain made of questionable biology", "stay focused and accept that cleanliness has lost", "Everything here looks like it has a health bar." },
    ["Ardenweald"] = { "blue forests, glowing wildlife, and dreamlike night", "fae tricks and corrupted pockets", "enjoy the scenery without wandering off the route", "I would trust this forest more if everything stopped sparkling ominously." },
    ["Revendreth"] = { "gothic castles, red skies, and dramatic cliffs", "venthyr, stoneborn, and vertical roads", "watch the elevation and keep the route efficient", "Duskwood grew up, bought a castle, and became theatrical." },
    ["The Maw"] = { "gray wasteland, chains, and absolutely no hospitality", "jailers, elites, and oppressive terrain", "do what we came to do and leave efficiently", "I have seen waiting rooms with better morale." },
    ["Zereth Mortis"] = { "geometric landscapes, floating structures, and cosmic workshop energy", "constructs and reality behaving experimentally", "keep orientation and make the routes count", "Somebody found the universe's developer room." },
    ["The Waking Shores"] = { "volcanic cliffs, dragon ruins, and a loud return to adventure", "dragons, elementals, and steep terrain", "watch the slopes and keep the route clean", "Nothing says welcome like lava beside a dragon." },
    ["Ohn'ahran Plains"] = { "vast grasslands, rivers, and more horizon than walls", "centaur territory and wide travel", "use the open terrain and keep objectives grouped", "A mount finally gets room to stretch its legs." },
    ["The Azure Span"] = { "snowy forests, blue magic, and enormous wilderness", "gnolls, wildlife, and long routes", "keep the travel efficient and enjoy the scenery", "This place feels like Grizzly Hills discovered a blue filter." },
    ["Thaldraszus"] = { "towering architecture, dragon civilization, and vertical travel", "time magic, cliffs, and city distractions", "think vertically and use flight intelligently", "Dragons really do build like gravity is somebody else's problem." },
    ["Valdrakken"] = { "dragon towers, busy plazas, and endgame-city convenience", "vendors, crafting, and the danger of never leaving town", "do the errands and get back into the world", "A city this useful is a productivity trap." },
}

local zoneTemplatesFirst = {
    "First proper look at %s: %s. Keep in mind, %s. For now, %s. %s",
    "%s. New territory for this character. I'm getting %s. Main concern: %s. Let's %s. %s",
    "All right, welcome to %s. The first impression is %s. Expect %s. Best move: %s. %s",
    "New place unlocked: %s. We've got %s, plus %s. I say we %s. %s",
    "So this is %s. Very %s. Watch for %s, and let's %s. %s",
    "%s is officially on the map. It feels like %s. The catch is %s. We should %s. %s",
}

local zoneTemplatesReturn = {
    "Back in %s. I remember the %s. I also remember %s. This time, %s. %s",
    "%s again. Familiar %s, familiar problem: %s. Let's %s. %s",
    "We know %s now. It's still %s, and %s is still part of the deal. %s. %s",
    "Return trip to %s. The %s hasn't changed, and neither has %s. Let's %s. %s",
    "Ah, %s. Back to %s. We already know about %s, so %s. %s",
    "%s, round two-or-more. I remember %s and I remember %s. This visit, %s. %s",
}

local zoneFallbackOpeners = {
    "All right, %s.", "So this is %s.", "Welcome to %s.", "New zone: %s.", "We made it to %s.",
    "%s. New scenery.", "%s is on the board now.", "Okay, %s. Fresh ground.", "Look at that. %s.",
    "And now we're in %s.", "New chapter: %s.", "The map says %s.", "Arrival confirmed: %s.",
    "%s, huh?", "Well then. %s.", "Different horizon: %s.", "Next stop, %s.", "Hello, %s.",
}

local zoneFallbackClosers = {
    "Let's learn what this place rewards and what it punishes.",
    "Give me five minutes and I'll have opinions about the route.",
    "Let's figure out whether this place is good for XP, gold, or stories.",
    "New terrain means new opportunities to make very specific mistakes.",
    "Let's get the roads, hubs, and danger spots into memory.",
    "I want a clean route before we start freelancing.",
    "Let's see whether the scenery or the enemies make the stronger impression.",
    "Fresh zone. I am reserving judgment until the first terrible pull.",
    "Let's leave with more XP, more loot, and fewer corpse runs than average.",
    "Time to find out what deserves a return visit.",
    "New map, same rule: useful detours only. Mostly.",
    "I'll remember how this place treats us.",
    "Let's make the first lap efficient enough that future-us benefits.",
    "If there is a terrible shortcut here, I assume you'll discover it shortly.",
    "I give us three objectives before we start pretending we know the zone.",
    "Let's see what kind of personality this place has.",
    "No assumptions. Learn the terrain, then abuse the terrain.",
    "Try not to let the pretty parts destroy the pace.",
}

local function currentProfile(self)
    local profile = self.db and self.db.memory and self.db.memory.profile or {}
    if type(self.RefreshLiveProfile) == "function" then
        local ok, live = pcall(self.RefreshLiveProfile, self)
        if ok and type(live) == "table" then profile = live end
    end
    local name = profile.name or (type(self.GetCurrentPlayerName) == "function" and self:GetCurrentPlayerName()) or (UnitName and UnitName("player")) or "hero"
    local class = profile.class
    if not class and type(UnitClass) == "function" then
        local ok, value = pcall(UnitClass, "player")
        if ok then class = value end
    end
    class = class or "adventurer"

    local level = tonumber(profile.level)
    if level == nil and type(UnitLevel) == "function" then
        local ok, value = pcall(UnitLevel, "player")
        if ok then
            if type(self.ReadableNumber) == "function" then level = self:ReadableNumber(value) end
            if level == nil then level = tonumber(value) end
        end
    end
    level = level or 0

    local zone = self.state and self.state.zone or profile.zone or (GetRealZoneText and GetRealZoneText()) or "Azeroth"
    if not zone or zone == "" or zone == "Unknown" then zone = "Azeroth" end
    return tostring(name), tostring(class), level, tostring(zone)
end

local function rememberArrival(self, bucket, text)
    self.state.recentArrivals = self.state.recentArrivals or {}
    local recent = self.state.recentArrivals[bucket] or {}
    recent[#recent + 1] = text
    while #recent > 30 do table.remove(recent, 1) end
    self.state.recentArrivals[bucket] = recent
end

local function wasRecent(self, bucket, text)
    local recent = self.state.recentArrivals and self.state.recentArrivals[bucket] or nil
    if not recent then return false end
    for _, v in ipairs(recent) do if v == text then return true end end
    return false
end

local function chooseFresh(self, bucket, builder, attempts)
    local text
    for _ = 1, attempts or 24 do
        text = builder()
        if text and not wasRecent(self, bucket, text) then break end
    end
    if text then rememberArrival(self, bucket, text) end
    return text
end

function FC:GetLoginArrivalLine()
    local name, class, level, zone = currentProfile(self)
    local text = chooseFresh(self, "login", function()
        local opener = loginOpeners[math.random(1, #loginOpeners)]
        local closer = loginClosers[math.random(1, #loginClosers)]
        local ok1, a = pcall(string.format, opener, name)
        if not ok1 then a = opener end
        local ok2, b = pcall(string.format, closer, level, class, zone)
        -- Several closers deliberately use a different placeholder order.
        if not ok2 then
            local variants = {
                string.format("Level %d %s in %s. Let's see where this goes.", level, class, zone),
                string.format("We're in %s on a level %d %s. Time to move.", zone, level, class),
            }
            b = variants[math.random(1, #variants)]
        end
        if math.random() < 0.34 then
            return a .. " " .. b .. " " .. loginWildcards[math.random(1, #loginWildcards)]
        end
        return a .. " " .. b
    end, 40)
    return text
end

function FC:QueueLoginArrival()
    self.state.arrivalRuntime = self.state.arrivalRuntime or {}
    if self.state.arrivalRuntime.loginQueued then return false end
    self.state.arrivalRuntime.loginQueued = true

    local text = self:GetLoginArrivalLine()
    if not text then return false end
    self:QueueSay(text, "talk", 72, 0, "loginarrival", true, nil, {
        topic = "loginarrival",
        category = "memory",
        reason = "session login greeting",
        facts = type(self.CaptureFacts) == "function" and self:CaptureFacts("loginarrival") or nil,
        maxAge = 24,
        minGap = 0.8,
    })
    return true
end

function FC:GetZoneArrivalLine(zone, oldZone)
    if not zone or zone == "" or zone == "Unknown" then return nil end
    local record = self.db and self.db.memory and self.db.memory.zones and self.db.memory.zones[zone] or nil
    local visits = tonumber(record and record.visits) or 1
    local p = Z[zone]
    local bucket = "zone:" .. zone

    if p then
        return chooseFresh(self, bucket, function()
            local templates = visits <= 1 and zoneTemplatesFirst or zoneTemplatesReturn
            local t = templates[math.random(1, #templates)]
            local ok, line = pcall(string.format, t, zone, p[1], p[2], p[3], p[4])
            return ok and line or nil
        end, 30)
    end

    return chooseFresh(self, bucket, function()
        local opener = zoneFallbackOpeners[math.random(1, #zoneFallbackOpeners)]
        local closer = zoneFallbackClosers[math.random(1, #zoneFallbackClosers)]
        local ok, first = pcall(string.format, opener, zone)
        if not ok then first = "Welcome to " .. tostring(zone) .. "." end
        if oldZone and oldZone ~= "" and oldZone ~= "Unknown" and math.random() < 0.25 then
            return first .. " Different energy from " .. tostring(oldZone) .. ". " .. closer
        end
        return first .. " " .. closer
    end, 36)
end

function FC:QueueZoneArrival(zone, oldZone)
    local text = self:GetZoneArrivalLine(zone, oldZone)
    if not text then return false end
    local expectedZone = zone
    self:QueueSay(text, "talk", 28, 75, "zonearrival:" .. tostring(zone), false, function()
        local current = (GetRealZoneText and GetRealZoneText()) or (GetZoneText and GetZoneText()) or "Unknown"
        return current == expectedZone
    end, {
        topic = "zonearrival",
        category = "world",
        reason = "entered a different zone",
        data = { zone = zone, oldZone = oldZone },
        facts = type(self.CaptureFacts) == "function" and self:CaptureFacts("zonearrival") or nil,
        maxAge = 20,
        minGap = 0.9,
    })
    return true
end

function FC:ArrivalStats()
    local zoneCount = 0
    for _ in pairs(Z) do zoneCount = zoneCount + 1 end
    return {
        loginOpeners = #loginOpeners,
        loginClosers = #loginClosers,
        loginWildcards = #loginWildcards,
        loginCombinations = (#loginOpeners * #loginClosers) + (#loginOpeners * #loginClosers * #loginWildcards),
        tailoredZones = zoneCount,
        tailoredZoneLines = zoneCount * (#zoneTemplatesFirst + #zoneTemplatesReturn),
        fallbackCombinations = #zoneFallbackOpeners * #zoneFallbackClosers,
    }
end
