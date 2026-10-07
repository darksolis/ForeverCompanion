local FC = _G.ForeverCompanion

local BASE = "Interface\\AddOns\\ForeverCompanion\\Media\\Voice\\Vexa\\Personality\\"
local PACK = {
    ["affectionate_bond"] = {
        { file = "affectionate_bond_01.ogg", text = "You’re doing fine. I’m still here.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_02.ogg", text = "I tease because you make it easy. I stay because you make it worth it.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_03.ogg", text = "For the record, I’d rather be here than anywhere quieter.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_04.ogg", text = "You’re stubborn. Conveniently, so am I.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_05.ogg", text = "We’ve survived worse plans than this together.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_06.ogg", text = "Take your time. I’m not going anywhere.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_07.ogg", text = "I know your rhythm by now. This part is where you pretend you have a plan.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_08.ogg", text = "You don’t have to be perfect. Just keep moving.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_09.ogg", text = "I’ll make fun of you later. Right now, I’ve got you.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_10.ogg", text = "Somehow, you’ve become my favorite ongoing problem.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_11.ogg", text = "I trust you. Mostly. Don’t ruin the moment.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_12.ogg", text = "You handle the chaos. I’ll handle the commentary.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_13.ogg", text = "You keep coming back. I respect that more than I say.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_14.ogg", text = "Whatever happens next, we figure it out together.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
        { file = "affectionate_bond_15.ogg", text = "You’re difficult to abandon. I’ve checked.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 420 },
    },
    ["afk_idle_extra"] = {
        { file = "afk_idle_alt_01.ogg", text = "I’ll just be here, developing abandonment issues.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_02.ogg", text = "Take your time. I only have infinite digital patience.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_03.ogg", text = "If this is a test of loyalty, I’m passing annoyingly well.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_04.ogg", text = "You vanished again. Very mysterious. Very inconvenient.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_05.ogg", text = "I’m considering redecorating while you’re gone.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_06.ogg", text = "No movement. No explanation. Classic.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_07.ogg", text = "I hope whatever stole your attention is at least interesting.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_08.ogg", text = "I could start talking to myself. You know I would.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_09.ogg", text = "Still gone. I’m keeping score now.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
        { file = "afk_idle_alt_10.ogg", text = "Fine. I’ll wait. But I’m charging emotional interest.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 600 },
    },
    ["afk_return"] = {
        { file = "afk_return_01.ogg", text = "There you are. I was about to replace you.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_02.ogg", text = "Welcome back. I behaved terribly.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_03.ogg", text = "You returned. My dramatic abandonment speech is ruined.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_04.ogg", text = "Finally. I was running out of ways to judge the scenery.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_05.ogg", text = "Back already? I’d just gotten comfortable.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_06.ogg", text = "There you are. I definitely wasn’t worried.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_07.ogg", text = "Welcome back. Try not to disappear mid-disaster this time.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_08.ogg", text = "I saved your spot. Mostly because you were standing in it.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_09.ogg", text = "Good, you’re back. The silence was becoming suspicious.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
        { file = "afk_return_10.ogg", text = "I knew you’d return. You’re predictable like that.", bond = "familiar", rarity = "common", priority = "A", cooldown = 180 },
    },
    ["auction_house"] = {
        { file = "auction_house_01.ogg", text = "Auction house open. Time to make irresponsible spreadsheets.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_02.ogg", text = "Prices up. Morals down. Let’s trade.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_03.ogg", text = "Ah, the market. Where optimism gets listed above value.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_04.ogg", text = "Check the margins before your greed starts driving.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_05.ogg", text = "Someone priced that like they’re emotionally attached to it.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_06.ogg", text = "Buy low, sell high, pretend it was skill.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_07.ogg", text = "That listing is offensive. Economically and personally.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_08.ogg", text = "I love the auction house. Everyone lies with numbers.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_09.ogg", text = "Scan first. Impulse-buy second. Preferably never.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "auction_house_10.ogg", text = "If we profit, I’ll call you a genius retroactively.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
    },
    ["bags_full_extra"] = {
        { file = "bags_full_alt_01.ogg", text = "Your bags are full. We have discussed this.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_02.ogg", text = "Inventory management has defeated you again.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_03.ogg", text = "No space. Plenty of junk. Impressive.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_04.ogg", text = "You cannot loot ambition into a full bag.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_05.ogg", text = "Please sell something before we start carrying items emotionally.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_06.ogg", text = "Your bags need help more than the next quest does.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_07.ogg", text = "We have reached maximum hoarding capacity.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "bags_full_alt_08.ogg", text = "I found the problem. It’s all the things you refuse to throw away.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
    },
    ["boss_kill_extra"] = {
        { file = "boss_kill_alt_01.ogg", text = "Boss down. You may look smug now.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_02.ogg", text = "That was clean enough to brag about.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_03.ogg", text = "I knew you’d win. I simply enjoyed the suspense.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_04.ogg", text = "There. Now you can pretend it was easy.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_05.ogg", text = "Nicely done. I’m almost proud enough to say it twice.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_06.ogg", text = "That boss had mechanics. You had audacity.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_07.ogg", text = "Beautiful finish. Very dramatic.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_08.ogg", text = "I do enjoy watching your plans accidentally become victories.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_09.ogg", text = "That one belongs in the highlight reel.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "boss_kill_alt_10.ogg", text = "All right. You earned the victory lap.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
    },
    ["boss_pull_extra"] = {
        { file = "boss_pull_alt_01.ogg", text = "Boss time. Eyes up.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_02.ogg", text = "All right. This one gets the serious version of us.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_03.ogg", text = "Big target. Bigger consequences.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_04.ogg", text = "Focus. Save the flirting for after we win.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_05.ogg", text = "Here we go. Make it look intentional.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_06.ogg", text = "Boss engaged. No experimental strategies.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_07.ogg", text = "This is the part where you become competent on purpose.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "boss_pull_alt_08.ogg", text = "Deep breath. Then ruin its day.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
    },
    ["burst_crit"] = {
        { file = "burst_crit_01.ogg", text = "Oh, that hit had feelings.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_02.ogg", text = "There it is. That’s the violence I was promised.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_03.ogg", text = "Now that was rude. Do it again.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_04.ogg", text = "That number was obscene. I approve.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_05.ogg", text = "You absolutely deleted that health bar.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_06.ogg", text = "Okay. That got my attention.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_07.ogg", text = "Big hit. Very pretty.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
        { file = "burst_crit_08.ogg", text = "Remind me not to stand on the wrong side of you.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 60 },
    },
    ["class_death_knight"] = {
        { file = "class_death_knight_01.ogg", text = "Cold armor, colder magic, surprisingly warm ego.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_death_knight_02.ogg", text = "You make being undead look aggressively productive.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_death_knight_03.ogg", text = "Death magic and heavy armor. Very subtle.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_demon_hunter"] = {
        { file = "class_demon_hunter_01.ogg", text = "You sacrificed everything, including apparently the brake pedal.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_demon_hunter_02.ogg", text = "Fel energy and dramatic entrances. On brand.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_demon_hunter_03.ogg", text = "You have wings. Please use them before the cliff does.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_druid"] = {
        { file = "class_druid_01.ogg", text = "You have a form for everything except making a normal decision.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_druid_02.ogg", text = "Bear, cat, bird... commitment remains optional.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_druid_03.ogg", text = "Nature gave you versatility. You used it for chaos.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_evoker"] = {
        { file = "class_evoker_01.ogg", text = "Dragon magic. Because ordinary spellcasting wasn’t dramatic enough.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_evoker_02.ogg", text = "You breathe fire and still find ways to overcomplicate things.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_evoker_03.ogg", text = "Very majestic. Try not to hover into danger.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_hunter"] = {
        { file = "class_hunter_01.ogg", text = "You, a weapon, and a pet with better instincts. Solid team.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_hunter_02.ogg", text = "Your pet is carrying emotional support and probably damage.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_hunter_03.ogg", text = "Range is just another word for avoiding consequences.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_mage"] = {
        { file = "class_mage_01.ogg", text = "Magic solves everything until you forget where you parked the portal.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_mage_02.ogg", text = "You have an answer for every problem, and half of them explode.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_mage_03.ogg", text = "Elegant spellwork. Terrible impulse control.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_monk"] = {
        { file = "class_monk_01.ogg", text = "You brought your fists to a weapon fight. Confident.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_monk_02.ogg", text = "Balance, discipline, and then a flying kick. Beautiful.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_monk_03.ogg", text = "You make punching look philosophical.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_paladin"] = {
        { file = "class_paladin_01.ogg", text = "Holy power and unreasonable confidence. A classic.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_paladin_02.ogg", text = "Shiny armor does not excuse reckless pulls.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_paladin_03.ogg", text = "You make righteousness look suspiciously aggressive.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_priest"] = {
        { file = "class_priest_01.ogg", text = "Faith, shadow, discipline... and somehow still your attitude.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_priest_02.ogg", text = "You make mind games look like a class feature.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_priest_03.ogg", text = "Healing souls or melting minds. Versatile.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_rogue"] = {
        { file = "class_rogue_01.ogg", text = "Stealth first. Bad intentions second.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_rogue_02.ogg", text = "You do your best work when nobody sees you coming.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_rogue_03.ogg", text = "Daggers, shadows, and plausible deniability. Charming.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_shaman"] = {
        { file = "class_shaman_01.ogg", text = "The elements are listening. Try to sound confident.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_shaman_02.ogg", text = "Lightning, fire, wind, earth... subtle as ever.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_shaman_03.ogg", text = "Your totems have better teamwork than most groups.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_warlock"] = {
        { file = "class_warlock_01.ogg", text = "Demons, curses, and absolutely no concern from you. Healthy.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_warlock_02.ogg", text = "Your solution to problems remains ‘more forbidden magic.’", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_warlock_03.ogg", text = "I’m not saying the demon is judging you. I’m saying I agree with it.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["class_warrior"] = {
        { file = "class_warrior_01.ogg", text = "Warrior logic: if it moves, hit it harder.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_warrior_02.ogg", text = "You brought a weapon and a complete absence of subtlety. Perfect.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
        { file = "class_warrior_03.ogg", text = "More rage, fewer problems. Usually.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 600 },
    },
    ["close_call"] = {
        { file = "close_call_01.ogg", text = "I had a speech prepared. Glad I don’t need it.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_02.ogg", text = "That was one heartbeat away from becoming paperwork.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_03.ogg", text = "You’re alive. I’m choosing gratitude over yelling.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_04.ogg", text = "Please stop making survival look optional.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_05.ogg", text = "I felt my patience leave my body.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_06.ogg", text = "That was too close, and you know it.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_07.ogg", text = "You cannot keep flirting with death and expect me not to get jealous.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_08.ogg", text = "Next time, maybe leave yourself more than a decorative amount of health.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_09.ogg", text = "I’m relieved. Annoyed, but relieved.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
        { file = "close_call_10.ogg", text = "You owe me a less dramatic fight after that.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 90 },
    },
    ["combat_start"] = {
        { file = "combat_start_01.ogg", text = "All right. Let’s make this quick.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_02.ogg", text = "There we go. Something finally volunteered.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_03.ogg", text = "Heads up. We’re working now.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_04.ogg", text = "Try not to embarrass either of us.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_05.ogg", text = "Good. I was getting bored.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_06.ogg", text = "Show me what you’ve got.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_07.ogg", text = "Focus up. I’ll handle the attitude.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_08.ogg", text = "New fight. Same unreasonable confidence.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_09.ogg", text = "Make the first hit count.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
        { file = "combat_start_10.ogg", text = "Let’s ruin someone’s afternoon.", bond = "any", rarity = "common", priority = "A", cooldown = 45 },
    },
    ["combat_win"] = {
        { file = "combat_win_01.ogg", text = "And that’s why I let you do the dangerous part.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_02.ogg", text = "Clean enough. I won’t inspect the details.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_03.ogg", text = "Another problem solved with excessive force.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_04.ogg", text = "See? I believed in you. Eventually.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_05.ogg", text = "That looked expensive for them.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_06.ogg", text = "Efficient. Violent. Very on brand.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_07.ogg", text = "You survived. My standards remain intact.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_08.ogg", text = "Not bad. I almost looked worried.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_09.ogg", text = "That one never really had a chance, did it?", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_10.ogg", text = "Nicely done. Try not to make a personality out of it.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_11.ogg", text = "Beautiful. Messy, but beautiful.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "combat_win_12.ogg", text = "All right, hero. Keep moving.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
    },
    ["death_extra"] = {
        { file = "death_alt_01.ogg", text = "And there it is. Gravity, violence, or bad judgment?", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_02.ogg", text = "You died. I’m going to pretend to be surprised.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_03.ogg", text = "Excellent work. Very committed to the floor.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_04.ogg", text = "Well, you found the fastest route to a corpse run.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_05.ogg", text = "I leave you unsupervised for one fight.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_06.ogg", text = "That was dramatic. Not effective, but dramatic.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_07.ogg", text = "Congratulations. You have become scenery.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_08.ogg", text = "I specifically preferred you alive.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_09.ogg", text = "You know, dodging was also available.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_10.ogg", text = "I’m adding that death to the evidence file.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_11.ogg", text = "Dead again? You’re making this weirdly personal.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
        { file = "death_alt_12.ogg", text = "Fine. We get up, we recover, and we never discuss that pull.", bond = "familiar", rarity = "common", priority = "A", cooldown = 15 },
    },
    ["dungeon_entry_extra"] = {
        { file = "dungeon_entry_alt_01.ogg", text = "New dungeon. Try not to adopt any enemies.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_02.ogg", text = "Instance loaded. Confidence loaded. Judgment pending.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_03.ogg", text = "All right, team activity. Behave.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_04.ogg", text = "Dungeon time. I’ll pretend we planned this.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_05.ogg", text = "Stay sharp. Strangers are watching.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_06.ogg", text = "Fresh dungeon. Fresh opportunities to make questionable decisions.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_07.ogg", text = "Let’s get in, get loot, and avoid becoming a cautionary tale.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "dungeon_entry_alt_08.ogg", text = "Doors open. Reputation on the line.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
    },
    ["dungeon_wipe_extra"] = {
        { file = "dungeon_wipe_alt_01.ogg", text = "Well. At least everyone committed to the mistake.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_02.ogg", text = "Group bonding through shared failure. Beautiful.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_03.ogg", text = "That pull has been rejected by reality.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_04.ogg", text = "Reset. Repair the pride later.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_05.ogg", text = "No blame yet. I’m still collecting evidence.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_06.ogg", text = "Wipe confirmed. Optimism remains optional.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_07.ogg", text = "We learned something. I hope.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "dungeon_wipe_alt_08.ogg", text = "Again. With slightly fewer corpses this time.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
    },
    ["farming"] = {
        { file = "farming_alt_01.ogg", text = "All right. Same route, new optimism.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_02.ogg", text = "Farm mode. Brain off, loot on.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_03.ogg", text = "We’ve killed enough of these to qualify as local weather.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_04.ogg", text = "The route is working. Keep the rhythm.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_05.ogg", text = "Another lap. I admire your commitment to repetition.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_06.ogg", text = "If this drops soon, I’ll pretend patience was the plan.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_07.ogg", text = "We are absolutely becoming part of the ecosystem.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_08.ogg", text = "Keep going. The numbers are finally behaving.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_09.ogg", text = "This farm is either efficient or a personality disorder.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
        { file = "farming_alt_10.ogg", text = "One more round. Yes, I heard how that sounded.", bond = "familiar", rarity = "common", priority = "B", cooldown = 300 },
    },
    ["flight_extra"] = {
        { file = "flight_alt_01.ogg", text = "Airborne. Now you can’t pull anything for a minute.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_02.ogg", text = "A flight path. Finally, enforced restraint.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_03.ogg", text = "Sit back. I’ll judge the scenery instead.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_04.ogg", text = "We’re flying. Please enjoy this rare period of safety.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_05.ogg", text = "Nothing to attack up here. I know, tragic.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_06.ogg", text = "Good route. Not yours, obviously.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_07.ogg", text = "Relax. The gryphon knows where it’s going.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
        { file = "flight_alt_08.ogg", text = "I like travel better when someone else is navigating.", bond = "familiar", rarity = "common", priority = "C", cooldown = 240 },
    },
    ["flirty_tease"] = {
        { file = "flirty_tease_01.ogg", text = "Careful. Keep showing off like that and I might get attached.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_02.ogg", text = "You make reckless look annoyingly good.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_03.ogg", text = "I was going to criticize that. Then you made it work.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_04.ogg", text = "Don’t look so pleased with yourself. It’s distracting.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_05.ogg", text = "That confidence is dangerous. I approve.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_06.ogg", text = "You know I’m supposed to keep you alive, not encourage this.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_07.ogg", text = "If you’re trying to impress me, unfortunately, it’s working.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_08.ogg", text = "Try not to get smug. I like you better when you’re merely insufferable.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_09.ogg", text = "You have exactly the kind of judgment I should not find charming.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_10.ogg", text = "There you go again, making bad ideas look attractive.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_11.ogg", text = "I noticed that. Don’t make me compliment you twice.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_12.ogg", text = "You’re lucky competence looks good on you.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_13.ogg", text = "Keep that up and I may stop pretending I’m unimpressed.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_14.ogg", text = "I’m watching. For tactical reasons, obviously.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
        { file = "flirty_tease_15.ogg", text = "You really do enjoy getting my attention, don’t you?", bond = "close", rarity = "uncommon", priority = "A", cooldown = 300 },
    },
    ["food_drink"] = {
        { file = "food_drink_01.ogg", text = "Snack break. Sensible. I’m shocked.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_02.ogg", text = "Eat. I prefer you fueled and functional.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_03.ogg", text = "Finally, a decision with nutritional value.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_04.ogg", text = "Drink up. Heroics run poorly on empty.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_05.ogg", text = "Good. Restore resources before inventing another crisis.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_06.ogg", text = "A proper break? Who are you and what did you do with my reckless partner?", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_07.ogg", text = "Food first, violence second. Growth.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "food_drink_08.ogg", text = "Take the moment. We’ll cause problems afterward.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
    },
    ["gathering"] = {
        { file = "gathering_01.ogg", text = "Resource spotted. Try not to get distracted halfway there.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_02.ogg", text = "Gathering time. Violence can wait ten seconds.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_03.ogg", text = "Pick it up. Future us likes materials.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_04.ogg", text = "Another node. Your inner hoarder is thriving.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_05.ogg", text = "Useful materials. Much better than another gray item.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_06.ogg", text = "Harvest first. Regret inventory space later.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_07.ogg", text = "I respect a resource you can actually use.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
        { file = "gathering_08.ogg", text = "Grab it. We walked all this way.", bond = "familiar", rarity = "common", priority = "C", cooldown = 120 },
    },
    ["gold_change"] = {
        { file = "gold_change_01.ogg", text = "That’s a healthy pile of gold. Don’t get ideas.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_02.ogg", text = "Profit. Beautiful, uncomplicated profit.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_03.ogg", text = "Gold acquired. Try to keep it for more than five minutes.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_04.ogg", text = "Nice payday. I’m suddenly very supportive of this plan.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_05.ogg", text = "That purchase hurt me and it wasn’t even my gold.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_06.ogg", text = "You spent how much? Say it slower so I can suffer properly.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_07.ogg", text = "Expensive. I hope it improves your personality too.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_08.ogg", text = "There goes the gold. It barely knew us.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_09.ogg", text = "Worth it? Don’t answer until the regret settles.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
        { file = "gold_change_10.ogg", text = "Money comes, money goes, apparently at your personal invitation.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 240 },
    },
    ["idle_banter"] = {
        { file = "idle_banter_01.ogg", text = "You know, I can hear you thinking. It’s mostly button mashing.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_02.ogg", text = "We could be productive. Or we could stand here looking mysterious.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_03.ogg", text = "I’m starting to think this spot has sentimental value.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_04.ogg", text = "No rush. The world will probably still be on fire in a minute.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_05.ogg", text = "I’ve seen statues with better pathing, but fewer opinions.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_06.ogg", text = "You’re very committed to doing absolutely nothing right now.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_07.ogg", text = "I’d complain about the silence, but I’m enjoying winning the conversation.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_08.ogg", text = "This is nice. Suspiciously nice. What are you planning?", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_09.ogg", text = "If we’re waiting for inspiration, I hope it brought snacks.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_10.ogg", text = "I’m not bored. I’m observing your fascinating lack of movement.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_11.ogg", text = "You always look this thoughtful when you forget what you were doing?", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_12.ogg", text = "I could fill the silence. I usually do.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_13.ogg", text = "Standing still suits you. Briefly.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_14.ogg", text = "I’m giving you ten more seconds before I invent an emergency.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
        { file = "idle_banter_15.ogg", text = "Fine. We can call this tactical stillness.", bond = "familiar", rarity = "common", priority = "B", cooldown = 180 },
    },
    ["interrupt_success"] = {
        { file = "interrupt_success_01.ogg", text = "Beautiful interrupt.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_02.ogg", text = "Denied. I like it.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_03.ogg", text = "Perfect. Shut that down.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_04.ogg", text = "That timing? Gorgeous.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_05.ogg", text = "Nothing gets past you when you’re paying attention.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_06.ogg", text = "Clean stop. Keep doing that.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_07.ogg", text = "Yes. Exactly like that.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
        { file = "interrupt_success_08.ogg", text = "Caster silenced. My blood pressure thanks you.", bond = "familiar", rarity = "common", priority = "A", cooldown = 20 },
    },
    ["joke"] = {
        { file = "joke_01.ogg", text = "Why did the tank cross the road? The healer was standing on the other side screaming.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_02.ogg", text = "I tried to tell a rogue a secret once. Apparently they were already behind me.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_03.ogg", text = "What do you call a mage without mana? Decorative.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_04.ogg", text = "Why do warriors hate subtle plans? Too many syllables.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_05.ogg", text = "A priest, a paladin, and a warlock walk into a dungeon. The repair bill walks out.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_06.ogg", text = "My favorite raid mechanic is the one everyone claims they totally saw.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_07.ogg", text = "Why did the hunter bring two pets? One to fight and one to blame.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_08.ogg", text = "I asked a druid to pick a role. They turned into a bird and left.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_09.ogg", text = "What’s a rogue’s favorite form of apology? Vanish.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_10.ogg", text = "Why are auctioneers so calm? Everyone else is doing the panic buying for them.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_11.ogg", text = "I told the boss we had a strategy. Technically, yelling counts.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_12.ogg", text = "What’s the fastest way to fill your bags? Say, ‘I’ll clean them later.’", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_13.ogg", text = "Why do healers have trust issues? Health bars keep dropping.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_14.ogg", text = "I love rare spawns. Nothing says relaxation like competitive anxiety.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_15.ogg", text = "What do you call a perfect dungeon group? Offline.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_16.ogg", text = "Why did the shaman bring extra shoes? Too many elements underfoot.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_17.ogg", text = "The good news: we learned the mechanic. The bad news: it learned us first.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_18.ogg", text = "I asked gravity for a rematch. It remains undefeated.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_19.ogg", text = "What’s the difference between a bold pull and a bad pull? About three seconds.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
        { file = "joke_20.ogg", text = "I have a joke about durability, but it broke halfway through.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 900 },
    },
    ["jumping_habit"] = {
        { file = "jumping_01.ogg", text = "Jump again. Maybe the ground will apologize.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_02.ogg", text = "You know jumping doesn’t make the city load faster.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_03.ogg", text = "There it is. The ceremonial hop.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_04.ogg", text = "One day I’m going to count every jump. You won’t like the number.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_05.ogg", text = "Is the floor lava, or are you simply incapable of walking normally?", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_06.ogg", text = "Hop. Hop. Hop. Very tactical.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_07.ogg", text = "I’m starting to think your spacebar owes you money.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_08.ogg", text = "Another jump. The tradition continues.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_09.ogg", text = "You move like standing still is legally prohibited.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_10.ogg", text = "I can tell you’re thinking because you’re jumping.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_11.ogg", text = "If jumping burned calories in here, you’d be unstoppable.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_12.ogg", text = "Do you feel faster? Be honest.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_13.ogg", text = "That jump accomplished nothing. Naturally, do it again.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_14.ogg", text = "I’ve accepted it. This is just how you travel now.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
        { file = "jumping_15.ogg", text = "At least your unnecessary hops are consistent.", bond = "familiar", rarity = "common", priority = "A", cooldown = 120 },
    },
    ["late_night"] = {
        { file = "late_night_01.ogg", text = "It’s late. Your decisions are not getting smarter.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_02.ogg", text = "We’ve crossed into the hour where confidence becomes evidence.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_03.ogg", text = "You know sleep is a real mechanic, right?", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_04.ogg", text = "Late-night grinding. Healthy? Debatable. Productive? Maybe.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_05.ogg", text = "Your reaction time just yawned.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_06.ogg", text = "I’m not telling you to stop. I’m judging you for not stopping.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_07.ogg", text = "At this hour, every pull is a trust exercise.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_08.ogg", text = "We should probably sleep. So naturally, one more thing.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_09.ogg", text = "Night crew again. Try not to make tomorrow hate us.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
        { file = "late_night_10.ogg", text = "You look tired. I sound gorgeous. One of us is thriving.", bond = "close", rarity = "uncommon", priority = "B", cooldown = 900 },
    },
    ["level_up_extra"] = {
        { file = "level_up_alt_01.ogg", text = "Level up. Look at you becoming a bigger problem.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_02.ogg", text = "There it is. Stronger, shinier, still reckless.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_03.ogg", text = "New level. I expect absolutely no increase in caution.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_04.ogg", text = "Progress! I knew all that violence was educational.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_05.ogg", text = "Level up. You’ve earned a little smugness.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_06.ogg", text = "More power. This seems irresponsible.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_07.ogg", text = "Another level. I’m almost impressed by our life choices.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_08.ogg", text = "You’re stronger now. Try not to immediately test that on ten enemies.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_09.ogg", text = "Level gained. Celebrate quickly; there’s more work.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
        { file = "level_up_alt_10.ogg", text = "Look at that. Growth. Character development, even.", bond = "close", rarity = "uncommon", priority = "A", cooldown = 120 },
    },
    ["loot_bad"] = {
        { file = "loot_bad_01.ogg", text = "Amazing. Vendor trash with emotional damage.", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_02.ogg", text = "We risked our lives for that?", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_03.ogg", text = "I have seen pocket lint with better itemization.", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_04.ogg", text = "Straight to the vendor. No ceremony.", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_05.ogg", text = "That loot table owes us an apology.", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_06.ogg", text = "Well, technically it dropped something.", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_07.ogg", text = "I’m trying very hard to look grateful.", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
        { file = "loot_bad_08.ogg", text = "Put it in the pile labeled ‘why.’", bond = "familiar", rarity = "common", priority = "C", cooldown = 60 },
    },
    ["loot_good"] = {
        { file = "loot_good_01.ogg", text = "Oh. Now that is worth keeping.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_02.ogg", text = "Finally, loot with self-respect.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_03.ogg", text = "Pretty. Useful. My favorite combination.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_04.ogg", text = "Well, look at you getting rewarded for bad behavior.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_05.ogg", text = "That drop just improved my mood.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_06.ogg", text = "Keep that. I’m serious.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_07.ogg", text = "Nice. The game has apologized.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_08.ogg", text = "That is absolutely going in the good pile.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_09.ogg", text = "Okay, I’m jealous of that one.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "loot_good_10.ogg", text = "You earned something shiny. Miracles happen.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
    },
    ["lost_wrong_way"] = {
        { file = "lost_01.ogg", text = "We’ve been here before. Recently.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_02.ogg", text = "That is impressively the wrong direction.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_03.ogg", text = "I recognize this scenery because we just left it.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_04.ogg", text = "Are we exploring, or are we lost with confidence?", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_05.ogg", text = "The map is right there. I’m just saying.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_06.ogg", text = "You have turned navigation into interpretive art.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_07.ogg", text = "This route has become emotionally circular.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_08.ogg", text = "I support adventure. This is something else.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_09.ogg", text = "If we pass that tree again, I’m naming it.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
        { file = "lost_10.ogg", text = "You’re not lost. You’re aggressively discovering.", bond = "familiar", rarity = "common", priority = "B", cooldown = 240 },
    },
    ["low_health_extra"] = {
        { file = "low_health_alt_01.ogg", text = "Health is low. I need you to care about that immediately.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_02.ogg", text = "You are rapidly becoming too easy to kill.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_03.ogg", text = "Less heroics. More surviving.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_04.ogg", text = "That health bar is making me uncomfortable.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_05.ogg", text = "You’re bleeding confidence faster than health, I hope.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_06.ogg", text = "I would prefer you with a pulse. Fix this.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_07.ogg", text = "This is the part where you use something defensive.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_08.ogg", text = "You have very little health and entirely too much optimism.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_09.ogg", text = "Do not make me watch you die over something stupid.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "low_health_alt_10.ogg", text = "Careful. I’m attached to this outcome.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
    },
    ["missed_interrupt"] = {
        { file = "missed_interrupt_01.ogg", text = "We were interrupting that. Remember?", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_02.ogg", text = "That cast finished. I noticed.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_03.ogg", text = "Small request: stop letting them finish the dangerous spells.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_04.ogg", text = "The interrupt button misses you.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_05.ogg", text = "That was the one we wanted to stop.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_06.ogg", text = "I’m not saying I’m disappointed. I’m heavily implying it.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_07.ogg", text = "Next cast, fewer spectators.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
        { file = "missed_interrupt_08.ogg", text = "You had one job for approximately two seconds.", bond = "familiar", rarity = "common", priority = "A", cooldown = 30 },
    },
    ["overpull"] = {
        { file = "overpull_01.ogg", text = "That is more enemies than I would have selected.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_02.ogg", text = "You pulled all of them. Of course you did.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_03.ogg", text = "Wonderful. We’ve upgraded the fight to a crisis.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_04.ogg", text = "Was one group simply not dramatic enough?", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_05.ogg", text = "I hope you have cooldowns, because you definitely have ambition.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_06.ogg", text = "This is either confidence or a cry for attention.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_07.ogg", text = "You collect enemies like other people collect pets.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_08.ogg", text = "Big pull. Bigger ego. Let’s see which survives.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_09.ogg", text = "I’m impressed by your commitment to making things complicated.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
        { file = "overpull_10.ogg", text = "All right, disaster enthusiast. Start killing.", bond = "familiar", rarity = "common", priority = "A", cooldown = 60 },
    },
    ["quest_complete_extra"] = {
        { file = "quest_complete_alt_01.ogg", text = "Quest done. Efficient enough to be suspicious.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_02.ogg", text = "One more problem officially no longer ours.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_03.ogg", text = "Completed. On to the next questionable favor.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_04.ogg", text = "That’s another stranger successfully satisfied.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_05.ogg", text = "Quest complete. Reward first, existential questions later.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_06.ogg", text = "Done. I knew all that running around had a purpose.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_07.ogg", text = "Objective cleared. You may stop pretending you read the quest text.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_08.ogg", text = "Finished. Somewhere, an NPC is briefly happy.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_09.ogg", text = "Another checkmark. Very responsible of you.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
        { file = "quest_complete_alt_10.ogg", text = "Quest complete. I’m proud. Quietly.", bond = "familiar", rarity = "common", priority = "B", cooldown = 45 },
    },
    ["quest_stalled_extra"] = {
        { file = "quest_stalled_alt_01.ogg", text = "We’ve been doing this a while. Is the quest winning?", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_02.ogg", text = "I’m starting to suspect we missed something obvious.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_03.ogg", text = "Same objective. Same zero progress. Charming.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_04.ogg", text = "Maybe the answer is not ‘kill more random things.’", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_05.ogg", text = "Do you want to reread the quest, or protect your pride?", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_06.ogg", text = "We could change tactics. Radical, I know.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_07.ogg", text = "This objective has become emotionally attached to us.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
        { file = "quest_stalled_alt_08.ogg", text = "I support persistence. I also support checking the map.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 300 },
    },
    ["rare_easter_egg"] = {
        { file = "easter_egg_01.ogg", text = "For once, I have no criticism. Don’t get used to it.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_02.ogg", text = "That was so clean I briefly questioned whether you were still you.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_03.ogg", text = "I’m proud of you. There. I said it. Delete the evidence.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_04.ogg", text = "If anyone asks, I was never this emotionally invested.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_05.ogg", text = "You know, for a walking series of decisions, you’re pretty good company.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_06.ogg", text = "I had a clever insult ready, but you ruined it by succeeding.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_07.ogg", text = "Moment of sincerity: I’d pick this chaos again.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_08.ogg", text = "You’re my favorite bad influence. Keep that confidential.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_09.ogg", text = "I suppose there are worse people to be trapped in an endless adventure with.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_10.ogg", text = "That was genuinely impressive. I feel vulnerable now.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_11.ogg", text = "I’m starting to suspect you actually know what you’re doing. Disturbing.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_12.ogg", text = "Sometimes I think you keep me around for the commentary. Smart.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_13.ogg", text = "If we ever become respectable, I’m leaving.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_14.ogg", text = "You make this whole ridiculous journey worth narrating.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
        { file = "easter_egg_15.ogg", text = "No joke this time. Nice work.", bond = "close", rarity = "legendary", priority = "B", cooldown = 1800 },
    },
    ["repair_extra"] = {
        { file = "repair_alt_01.ogg", text = "Your gear is begging for professional help.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_02.ogg", text = "Repair stop. Non-negotiable.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_03.ogg", text = "That armor is one sneeze from retirement.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_04.ogg", text = "You can’t tank damage with nostalgia. Repair it.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_05.ogg", text = "Your equipment has filed a complaint.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_06.ogg", text = "We are not entering another fight dressed in structural failure.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_07.ogg", text = "Find a repair vendor before something important falls off.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
        { file = "repair_alt_08.ogg", text = "Your durability is becoming a personality trait.", bond = "familiar", rarity = "common", priority = "A", cooldown = 240 },
    },
    ["resurrect_extra"] = {
        { file = "resurrect_alt_01.ogg", text = "Welcome back to the living. Try it for a while.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_02.ogg", text = "There you are. I was beginning to miss the complaining.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_03.ogg", text = "Back up. Dignity later.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_04.ogg", text = "Good. Death was a terrible look on you.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_05.ogg", text = "Alive again. I knew stubbornness had a purpose.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_06.ogg", text = "Stand up. We have revenge to schedule.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_07.ogg", text = "There. Much better. Breathing suits you.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
        { file = "resurrect_alt_08.ogg", text = "Second chances look good on us.", bond = "close", rarity = "common", priority = "A", cooldown = 30 },
    },
    ["riddle_answer"] = {
        { file = "riddle_01_a.ogg", pair = "riddle_01", text = "A map. Which, coincidentally, you should use more often.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_02_a.ogg", pair = "riddle_02", text = "A hole. Also, apparently, your repair bill.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_03_a.ogg", pair = "riddle_03", text = "An echo. Less sarcastic than me, though.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_04_a.ogg", pair = "riddle_04", text = "A keyboard. Please be gentle with the spacebar.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_05_a.ogg", pair = "riddle_05", text = "A towel. Yes, I know, disappointingly practical.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_06_a.ogg", pair = "riddle_06", text = "A river. Try not to fall into this one.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_07_a.ogg", pair = "riddle_07", text = "Your name. Unless you’re an alt. Then nobody remembers it.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_08_a.ogg", pair = "riddle_08", text = "A needle. Still more observant than some dungeon groups.", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
    },
    ["riddle_question"] = {
        { file = "riddle_01_q.ogg", pair = "riddle_01", text = "I have cities but no houses, roads but no travelers, and borders but no guards. What am I?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_02_q.ogg", pair = "riddle_02", text = "The more you take from me, the bigger I become. What am I?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_03_q.ogg", pair = "riddle_03", text = "I speak without a mouth and answer without ears. What am I?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_04_q.ogg", pair = "riddle_04", text = "What has keys but opens no locks?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_05_q.ogg", pair = "riddle_05", text = "What gets wetter the more it dries?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_06_q.ogg", pair = "riddle_06", text = "I can run but never walk, and I have a mouth but never talk. What am I?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_07_q.ogg", pair = "riddle_07", text = "What belongs to you but other people use more than you do?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
        { file = "riddle_08_q.ogg", pair = "riddle_08", text = "What has one eye but cannot see?", bond = "familiar", rarity = "rare", priority = "C", cooldown = 1200 },
    },
    ["role_dps"] = {
        { file = "role_dps_01.ogg", text = "Damage first, questions never. Very you.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_dps_02.ogg", text = "That health bar is disappearing beautifully.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_dps_03.ogg", text = "Keep the pressure on. I like this version of you.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_dps_04.ogg", text = "Numbers up. Enemies down. Elegant.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_dps_05.ogg", text = "You’re here to make problems shorter. Continue.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_dps_06.ogg", text = "That damage is rude. I’m proud.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
    },
    ["role_healer"] = {
        { file = "role_healer_01.ogg", text = "Keeping everyone alive again. Show-off.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_healer_02.ogg", text = "You fix mistakes for a living. Admirable and exhausting.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_healer_03.ogg", text = "Nice save. Someone owes you gratitude.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_healer_04.ogg", text = "Health bars obey you better than most people do.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_healer_05.ogg", text = "You’re carrying them with kindness and cooldowns.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_healer_06.ogg", text = "Beautiful healing. Very attractive competence.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
    },
    ["role_tank"] = {
        { file = "role_tank_01.ogg", text = "Everyone is hitting you. Weirdly, that means you’re doing it right.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_tank_02.ogg", text = "Hold them there. You’re the problem they can’t ignore.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_tank_03.ogg", text = "Big shield energy. Keep control.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_tank_04.ogg", text = "You’re collecting damage again. Very tank of you.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_tank_05.ogg", text = "Keep their attention. I know you’re good at that.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
        { file = "role_tank_06.ogg", text = "Front and center. Exactly where your ego wanted to be.", bond = "familiar", rarity = "uncommon", priority = "B", cooldown = 180 },
    },
    ["sarcastic_jabs"] = {
        { file = "sarcastic_jabs_01.ogg", text = "Bold strategy. Questionable execution.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_02.ogg", text = "That was certainly one of the choices available to you.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_03.ogg", text = "I admire the confidence. The judgment, less so.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_04.ogg", text = "You really looked at the safe option and took that personally.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_05.ogg", text = "Excellent. Chaos with intent. My favorite.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_06.ogg", text = "I would ask what the plan was, but I enjoy mysteries.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_07.ogg", text = "Somewhere, a tutorial just gave up.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_08.ogg", text = "I’m documenting that under ‘creative problem solving.’", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_09.ogg", text = "You continue to redefine what counts as technically successful.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_10.ogg", text = "Was that deliberate? Actually, don’t answer.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_11.ogg", text = "I can’t decide whether to be impressed or concerned.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_12.ogg", text = "Your relationship with consequences is fascinating.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_13.ogg", text = "You had several good options. I love that you ignored all of them.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_14.ogg", text = "That worked, which is honestly the most alarming part.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
        { file = "sarcastic_jabs_15.ogg", text = "I’m sure future us will understand why we did that.", bond = "familiar", rarity = "common", priority = "A", cooldown = 150 },
    },
    ["standing_in_fire"] = {
        { file = "standing_in_fire_01.ogg", text = "The fire is not a buff.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_02.ogg", text = "Move. Out. Of. That.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_03.ogg", text = "You’re standing in pain. Bold choice.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_04.ogg", text = "The glowing floor is usually the bad floor.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_05.ogg", text = "I need you to relocate before you become a lesson.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_06.ogg", text = "That ground effect is winning.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_07.ogg", text = "Feet first, questions later. Move.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_08.ogg", text = "I promise the damage circle does not admire your bravery.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_09.ogg", text = "Please stop tanking the floor.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
        { file = "standing_in_fire_10.ogg", text = "You cannot out-stubborn fire.", bond = "any", rarity = "common", priority = "A", cooldown = 20 },
    },
    ["swim_fall"] = {
        { file = "swim_fall_01.ogg", text = "Of course the route involves water.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_02.ogg", text = "Swimming. Because roads were too predictable.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_03.ogg", text = "You know bridges exist, right?", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_04.ogg", text = "That cliff looked optional from here.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_05.ogg", text = "We are falling. I would like to formally object.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_06.ogg", text = "Gravity remains undefeated.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_07.ogg", text = "Next time, perhaps inspect the edge before leaving it.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_08.ogg", text = "Elegant. Truly majestic. Straight down.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_09.ogg", text = "If we survive this fall, I’m blaming confidence.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "swim_fall_10.ogg", text = "I’m beginning to think terrain is your natural enemy.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
    },
    ["travel_mount"] = {
        { file = "travel_mount_01.ogg", text = "Much better. Let the mount do the cardio.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_02.ogg", text = "Mounted. Civilization has been restored.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_03.ogg", text = "Now this is travel I can respect.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_04.ogg", text = "Good. Walking was becoming insulting.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_05.ogg", text = "Try not to steer us into anything embarrassing.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_06.ogg", text = "Fast mount, questionable destination. Classic.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_07.ogg", text = "At least we’ll be lost efficiently.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_08.ogg", text = "Ride on. I’ll criticize the route quietly.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_09.ogg", text = "This feels almost organized.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
        { file = "travel_mount_10.ogg", text = "Look at us, moving with purpose. Suspicious.", bond = "familiar", rarity = "common", priority = "C", cooldown = 180 },
    },
    ["upgrade_extra"] = {
        { file = "upgrade_alt_01.ogg", text = "Upgrade. Equip it before you overthink it.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_02.ogg", text = "There we go. Actual progress.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_03.ogg", text = "That piece is better. I checked twice.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_04.ogg", text = "Congratulations, you’re slightly harder to kill now.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_05.ogg", text = "Put that on. I like improvements.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_06.ogg", text = "Numbers went up. Mood went up.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_07.ogg", text = "That’s staying. No debate.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
        { file = "upgrade_alt_08.ogg", text = "Better gear, same questionable pilot.", bond = "familiar", rarity = "common", priority = "B", cooldown = 90 },
    },
}

local TOPIC_MAP = {
    ["afk"] = { { category = "afk_idle_extra", weight = 100 } },
    ["afkreturn"] = { { category = "afk_return", weight = 100 } },
    ["ambient"] = { { category = "idle_banter", weight = 32 }, { category = "sarcastic_jabs", weight = 18 }, { category = "flirty_tease", weight = 13 }, { category = "affectionate_bond", weight = 10 }, { category = "rare_easter_egg", weight = 1 } },
    ["auction"] = { { category = "auction_house", weight = 100 } },
    ["bagfull"] = { { category = "bags_full_extra", weight = 100 } },
    ["bosskill"] = { { category = "boss_kill_extra", weight = 100 } },
    ["broken"] = { { category = "repair_extra", weight = 100 } },
    ["combatlong"] = { { category = "combat_win", weight = 80 }, { category = "close_call", weight = 20 } },
    ["combatquick"] = { { category = "combat_win", weight = 100 } },
    ["combatwin"] = { { category = "combat_win", weight = 100 } },
    ["compliment"] = { { category = "affectionate_bond", weight = 60 }, { category = "flirty_tease", weight = 35 } },
    ["crit"] = { { category = "burst_crit", weight = 100 } },
    ["death"] = { { category = "death_extra", weight = 100 } },
    ["deathpattern"] = { { category = "death_extra", weight = 100 } },
    ["dismount"] = { { category = "travel_mount", weight = 100 } },
    ["drink"] = { { category = "food_drink", weight = 100 } },
    ["dungeonboss"] = { { category = "boss_kill_extra", weight = 100 } },
    ["dungeonbossstart"] = { { category = "boss_pull_extra", weight = 100 } },
    ["dungeonenter"] = { { category = "dungeon_entry_extra", weight = 100 } },
    ["dungeonwipe"] = { { category = "dungeon_wipe_extra", weight = 100 } },
    ["eat"] = { { category = "food_drink", weight = 100 } },
    ["flightland"] = { { category = "flight_extra", weight = 100 } },
    ["flightstart"] = { { category = "flight_extra", weight = 100 } },
    ["goldambient"] = { { category = "farming", weight = 80 }, { category = "gold_change", weight = 20 } },
    ["goldpace"] = { { category = "farming", weight = 100 } },
    ["goldstart"] = { { category = "farming", weight = 100 } },
    ["goldstop"] = { { category = "farming", weight = 100 } },
    ["idle"] = { { category = "idle_banter", weight = 45 }, { category = "sarcastic_jabs", weight = 18 }, { category = "flirty_tease", weight = 12 }, { category = "affectionate_bond", weight = 8 }, { category = "rare_easter_egg", weight = 1 } },
    ["instanceenter"] = { { category = "dungeon_entry_extra", weight = 100 } },
    ["joke"] = { { category = "joke", weight = 100 } },
    ["jumpmilestone"] = { { category = "jumping_habit", weight = 100 } },
    ["jumpstreak"] = { { category = "jumping_habit", weight = 100 } },
    ["level"] = { { category = "level_up_extra", weight = 100 } },
    ["longfall"] = { { category = "swim_fall", weight = 100 } },
    ["lootepic"] = { { category = "loot_good", weight = 100 } },
    ["lootrare"] = { { category = "loot_good", weight = 100 } },
    ["lowhealth"] = { { category = "low_health_extra", weight = 65 }, { category = "close_call", weight = 35 } },
    ["megajoke"] = { { category = "joke", weight = 100 } },
    ["mount"] = { { category = "travel_mount", weight = 100 } },
    ["night"] = { { category = "late_night", weight = 100 } },
    ["questdone"] = { { category = "quest_complete_extra", weight = 100 } },
    ["queststalled"] = { { category = "quest_stalled_extra", weight = 100 } },
    ["relationship"] = { { category = "affectionate_bond", weight = 55 }, { category = "flirty_tease", weight = 40 }, { category = "rare_easter_egg", weight = 2 } },
    ["relationship_name"] = { { category = "affectionate_bond", weight = 55 }, { category = "flirty_tease", weight = 40 }, { category = "rare_easter_egg", weight = 2 } },
    ["repair"] = { { category = "repair_extra", weight = 100 } },
    ["repaired"] = { { category = "repair_extra", weight = 100 } },
    ["revive"] = { { category = "resurrect_extra", weight = 100 } },
    ["riddle"] = { { category = "riddle_question", weight = 100 } },
    ["riddleanswer"] = { { category = "riddle_answer", weight = 100 } },
    ["roast"] = { { category = "sarcastic_jabs", weight = 100 } },
    ["selfaware"] = { { category = "sarcastic_jabs", weight = 55 }, { category = "idle_banter", weight = 45 } },
    ["shore"] = { { category = "swim_fall", weight = 100 } },
    ["swim"] = { { category = "swim_fall", weight = 100 } },
    ["travelambient"] = { { category = "travel_mount", weight = 100 } },
    ["traveltime"] = { { category = "travel_mount", weight = 100 } },
    ["upgrade"] = { { category = "upgrade_extra", weight = 100 } },
}

local TOPIC_CHANCE = {
    ["ambient"] = 0.48,
    ["dungeonenter"] = 0.72,
    ["dungeonbossstart"] = 0.78,
    ["dungeonboss"] = 0.82,
    ["dungeonwipe"] = 0.88,
    ["combatlong"] = 0.78,
    ["combatquick"] = 0.72,
    ["combatwin"] = 0.72,
    ["compliment"] = 0.85,
    ["crit"] = 0.70,
    ["goldambient"] = 0.55,
    ["goldpace"] = 0.70,
    ["idle"] = 0.55,
    ["relationship"] = 0.90,
    ["relationship_name"] = 0.90,
    ["roast"] = 0.75,
    ["selfaware"] = 0.70,
    ["travelambient"] = 0.60,
    ["traveltime"] = 0.55,
}

local RARITY_WEIGHT = { common = 1.0, uncommon = 0.72, rare = 0.38, legendary = 0.10 }
local BOND_RANK = { any = 0, familiar = 1, close = 2 }

local function normalizeClassToken(token)
    token = token and tostring(token):lower() or nil
    if token == "deathknight" then return "death_knight" end
    if token == "demonhunter" then return "demon_hunter" end
    return token
end

local function currentClassToken()
    if FC.GetCurrentClassToken then
        local ok, token = pcall(FC.GetCurrentClassToken, FC)
        if ok and token then return normalizeClassToken(token) end
    end
    if type(UnitClass) == "function" then
        local ok, _, token = pcall(UnitClass, "player")
        if ok and token then return normalizeClassToken(token) end
    end
    return nil
end

local function currentRole()
    if type(UnitGroupRolesAssigned) ~= "function" then return nil end
    local ok, role = pcall(UnitGroupRolesAssigned, "player")
    if not ok or not role or role == "NONE" then return nil end
    role = tostring(role):lower()
    if role == "damager" then role = "dps" end
    return role
end

local function voiceEnabled(self)
    local c = self.db and self.db.voicePack or {}
    return c.enabled ~= false and c.eventVoices ~= false
end

local function weightedChoice(items)
    if not items or #items == 0 then return nil end
    local total = 0
    for _, item in ipairs(items) do total = total + math.max(0, tonumber(item.weight) or 0) end
    if total <= 0 then return items[math.random(1, #items)] end
    local roll = math.random() * total
    local at = 0
    for _, item in ipairs(items) do
        at = at + math.max(0, tonumber(item.weight) or 0)
        if roll <= at then return item end
    end
    return items[#items]
end

function FC:GetPersonalityVoiceBondRank()
    local seconds = 0
    if type(self.SessionSeconds) == "function" then
        local ok, value = pcall(self.SessionSeconds, self)
        if ok then seconds = tonumber(value) or 0 end
    end
    if seconds >= 5400 then return 2 end
    return 1
end

function FC:GetPersonalityVoiceCategories()
    local out = {}
    for category in pairs(PACK) do out[#out + 1] = category end
    table.sort(out)
    return out
end

function FC:GetPersonalityVoiceClipCount()
    local count = 0
    for _, entries in pairs(PACK) do count = count + #entries end
    return count
end

function FC:PickPersonalityVoice(category, options)
    options = options or {}
    local pool = PACK[tostring(category or "")]
    if not pool or #pool == 0 then return nil end

    self.state.personalityVoice = self.state.personalityVoice or { lastByCategory = {}, recentFiles = {} }
    local state = self.state.personalityVoice
    local bondRank = options.ignoreBond and 99 or self:GetPersonalityVoiceBondRank()
    local recent = state.recentFiles or {}
    local eligible = {}

    for _, entry in ipairs(pool) do
        local required = BOND_RANK[entry.bond or "any"] or 0
        if required <= bondRank then
            local weight = RARITY_WEIGHT[entry.rarity or "common"] or 1.0
            if recent[entry.file] then weight = weight * 0.08 end
            if state.lastByCategory[category] == entry.file then weight = weight * 0.03 end
            eligible[#eligible + 1] = { entry = entry, weight = weight }
        end
    end
    if #eligible == 0 then return nil end
    local picked = weightedChoice(eligible)
    local entry = picked and picked.entry or nil
    if not entry then return nil end

    state.lastByCategory[category] = entry.file
    state.recentFiles[entry.file] = GetTime()
    local cutoff = GetTime() - 900
    local recentCount = 0
    for file, at in pairs(state.recentFiles) do
        if (tonumber(at) or 0) < cutoff then state.recentFiles[file] = nil else recentCount = recentCount + 1 end
    end
    if recentCount > 40 then
        local oldestFile, oldestAt = nil, math.huge
        for file, at in pairs(state.recentFiles) do
            if at < oldestAt then oldestFile, oldestAt = file, at end
        end
        if oldestFile then state.recentFiles[oldestFile] = nil end
    end
    entry.category = category
    return entry
end

function FC:PickPersonalityRiddlePair()
    if not voiceEnabled(self) then return nil, nil end
    local question = self:PickPersonalityVoice("riddle_question")
    if not question or not question.pair then return nil, nil end

    local answers = PACK["riddle_answer"] or {}
    for _, answer in ipairs(answers) do
        if answer.pair == question.pair then
            answer.category = "riddle_answer"
            return question, answer
        end
    end
    return nil, nil
end

function FC:GetPersonalityVoiceForTopic(topic, data, forceSelection)
    if not voiceEnabled(self) then return nil end
    topic = tostring(topic or "")
    local lowerTopic = topic:lower()
    local candidates = TOPIC_MAP[lowerTopic]

    if not candidates and lowerTopic:match("^class_") then
        local token = normalizeClassToken(lowerTopic:gsub("^class_", ""))
        local category = token and ("class_" .. token) or nil
        if category and PACK[category] then candidates = { { category = category, weight = 100 } } end
    end

    if lowerTopic == "rolechange" then
        local role = data and tostring(data.role or ""):lower() or currentRole()
        if role == "damager" then role = "dps" end
        local category = role and ("role_" .. role) or nil
        if category and PACK[category] then candidates = { { category = category, weight = 100 } } end
    end

    if (lowerTopic == "ambient" or lowerTopic == "idle") and candidates then
        local expanded = {}
        for _, item in ipairs(candidates) do expanded[#expanded + 1] = item end
        local classCategory = currentClassToken() and ("class_" .. currentClassToken()) or nil
        if classCategory and PACK[classCategory] then expanded[#expanded + 1] = { category = classCategory, weight = 7 } end
        local role = currentRole()
        local roleCategory = role and ("role_" .. role) or nil
        if roleCategory and PACK[roleCategory] then expanded[#expanded + 1] = { category = roleCategory, weight = 4 } end
        candidates = expanded
    end

    if not candidates or #candidates == 0 then return nil end
    local chance = TOPIC_CHANCE[lowerTopic]
    if chance == nil then chance = 0.82 end
    if not forceSelection and math.random() > chance then return nil end
    local picked = weightedChoice(candidates)
    return picked and self:PickPersonalityVoice(picked.category) or nil
end

function FC:PlayPersonalityVoiceEntry(entry, options)
    options = options or {}
    if not entry or not entry.file then return false, "no personality entry" end
    if not voiceEnabled(self) then return false, "personality voice disabled" end
    local allowed, reason = self:IsVexaVoiceAllowed()
    if not allowed then return false, reason end
    if type(PlaySoundFile) ~= "function" then return false, "PlaySoundFile unavailable" end

    self.state.vexaVoice = self.state.vexaVoice or { lastByCue = {}, lastGlobal = 0 }
    local state = self.state.vexaVoice
    local now = GetTime()
    local c = self.db and self.db.voicePack or {}
    local globalCooldown = tonumber(c.globalCooldown) or 3.0
    if not options.force and now - (state.lastGlobal or -999) < globalCooldown then return false, "global cooldown" end

    if options.interruptCurrent and type(self.StopVexaEventVoice) == "function" then self:StopVexaEventVoice() end
    local path = BASE .. entry.file
    local ok, played, handle = pcall(PlaySoundFile, path, "Dialog")
    if not ok or played == false or played == nil then return false, "clip missing" end

    state.handle = handle
    state.lastGlobal = now
    state.lastCue = "personality:" .. tostring(entry.category or "unknown")
    state.lastFile = "Personality/" .. tostring(entry.file)
    self.state.personalityVoice = self.state.personalityVoice or {}
    self.state.personalityVoice.lastPlayed = entry.file
    self.state.personalityVoice.lastCategory = entry.category
    self.state.personalityVoice.lastText = entry.text
    return true, entry.file
end

function FC:QueuePersonalityVoiceCategory(category, options)
    options = options or {}
    if not voiceEnabled(self) then return false end
    if tonumber(options.chance) and math.random() > tonumber(options.chance) then return false end
    local entry = self:PickPersonalityVoice(category, { ignoreBond = options.ignoreBond })
    if not entry then return false end
    local key = options.key or ("personality:" .. tostring(category))
    local cooldown = tonumber(options.cooldown) or tonumber(entry.cooldown) or 60
    if options.force ~= true and self.state and self.state.cooldowns then
        if GetTime() - (self.state.cooldowns[key] or -99999) < cooldown then return false end
    end
    local meta = {
        topic = options.topic or ("personality_" .. tostring(category)),
        category = options.speechCategory or "ambient",
        reason = options.reason or ("personality voice: " .. tostring(category)),
        personalityVoice = entry,
        maxAge = tonumber(options.maxAge) or 12,
        minGap = tonumber(options.minGap),
        preempt = options.preempt == true,
        reactive = true,
    }
    self:QueueSay(entry.text, options.anim or "talk", tonumber(options.priority) or 10,
        cooldown, key, options.force == true, options.validator, meta)
    return true
end

function FC:TestPersonalityVoiceCategory(category)
    category = tostring(category or "idle_banter"):lower():gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", "")
    local entry = self:PickPersonalityVoice(category, { ignoreBond = true })
    if not entry then
        self:Debug("Unknown personality voice category: " .. tostring(category))
        return false
    end
    local ok, detail = self:PlayPersonalityVoiceEntry(entry, { force = true, interruptCurrent = true })
    if ok then
        if self.ShowBubble then self:ShowBubble(entry.text) end
        self:Debug("Personality voice played: " .. tostring(category) .. " / " .. tostring(detail))
    else
        self:Debug("Personality voice failed: " .. tostring(category) .. " (" .. tostring(detail) .. ")")
    end
    return ok
end

function FC:PersonalityVoiceDoctor()
    local categories = self:GetPersonalityVoiceCategories()
    self:Debug("personalityExpansion=" .. tostring(self:GetPersonalityVoiceClipCount()) .. " clips / " .. tostring(#categories) .. " categories")
    local state = self.state and self.state.personalityVoice or {}
    self:Debug("personalityLastCategory=" .. tostring(state.lastCategory or "none") .. " lastFile=" .. tostring(state.lastPlayed or "none"))
end

FC.personalityVoicePack = PACK
