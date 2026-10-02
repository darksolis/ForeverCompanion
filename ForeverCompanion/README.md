# Forever Companion

**Created by Darktotem Stormforge**  
Version: **0.9.44-rc39**

Forever Companion adds **Vexa**, an animated, context-aware in-game companion for WoW Forever. She reacts to what you are actually doing, remembers your characters, tracks progression, watches combat and dungeons, comments on loot and gold farming, calls out important class procs, and keeps you company with a large local-only conversation library.

No external AI service or API key is required.

## Highlights

- Animated Vexa companion with speech bubbles and reaction states
- Persistent memory for each character plus shared cross-character memory
- Character identity consolidation so the same character stays the same person as they level
- Context-aware XP, quest, combat, travel, target, loot, and world commentary
- Dungeon Intelligence with boss/run awareness and class-appropriate loot watch when supported by the client
- Combat proc callouts such as Overpower, Riposte, Maelstrom Weapon, Hot Streak, Killing Machine, and many others
- Gold-farming sessions with pacing, vendor value, and Auctionator scan-value integration
- Massive local conversation/learning library: **18,100+ dialogue variants**, **2,184 riddles**, **1,328 trivia variants**, **401 dictionary entries**, and **78 word roots**
- Vocabulary builder with definitions, persistent seen-word tracking, four-choice vocabulary quizzes, word roots, and dictionary lookup
- Expanded knowledge topics including language, animals, space, geography, math, the human body, technology, food, nature, psychology, oceans, weather, inventions, art, music, literature, mythology, and philosophy
- More personality content: idioms, proverbs, tongue twisters, absurd questions, original micro-stories, gaming philosophy, self-aware addon jokes, compliments, and roasts
- Expanded arrival system with hundreds of login combinations and tailored greetings for 122 named zones
- Zone greetings distinguish first visits from return visits and remember recent arrival lines to reduce repetition
- Riddles with delayed answers
- Session summaries and conversation history
- Custom purple/gold settings interface
- Minimap launcher and right-click Vexa quick menu
- Diagnostics, Test Lab, fact validation, and explainable commentary

## Installation

1. Exit WoW completely.
2. Delete any existing `Interface/AddOns/ForeverCompanion` folder.
3. Extract the `ForeverCompanion` folder from this ZIP into:

   `World of Warcraft/_retail_/Interface/AddOns/`

   Use the appropriate WoW Forever client AddOns directory if your installation differs.

4. Start the game.
5. Run:

   `/fc version`

You should see:

`0.9.44-rc39`

## Core Commands

- `/fc settings` — open the Companion Control Center
- `/fc version` — show addon version/schema
- `/fc doctor` — run diagnostics
- `/fc scan` — refresh current-character context
- `/fc profile` — current-character profile
- `/fc memoryfix` — merge duplicate memory records for the current character
- `/fc history` — recent Vexa conversation history
- `/fc why` — explain why Vexa said her last factual line
- `/fc repeat` — repeat her last line
- `/fc talk` — ask Vexa to say something context-aware
- `/fc stats` — current leveling snapshot
- `/fc arrival` — preview another login greeting
- `/fc arrival zone` — preview another greeting for the current zone

## Conversation & Learning Commands

- `/fc talk` — context-aware conversation
- `/fc learn` — random learning content
- `/fc quote` — classic/public-domain quote
- `/fc riddle` / `/fc answer` — riddle with delayed answer
- `/fc trivia` / `/fc triviaanswer` — general trivia with delayed answer
- `/fc question` — conversation question / would-you-rather / absurd question
- `/fc strangefact` — random fact from the expanded knowledge library
- `/fc word` — random vocabulary word and definition
- `/fc word <word>` or `/fc define <word>` — dictionary lookup
- `/fc vocabquiz` — four-choice vocabulary quiz
- `/fc vocabanswer 1-4` — answer the active vocabulary quiz
- `/fc root` — word-root lesson
- `/fc idiom` — idiom and meaning
- `/fc proverb` — traditional saying
- `/fc story` — short original Vexa micro-story
- `/fc tonguetwister` — tongue twister
- `/fc joke` / `/fc fact` / `/fc classbanter`
- `/fc vocab` — print current library and vocabulary-learning statistics

The library is entirely local. Conversation selection uses context, recent-topic suppression, class, zone, activity, memories, current gameplay state, and independent topic toggles so the addon can be very talkative without collapsing into one repetitive category.

## Dungeon Intelligence

Inside party/raid instances, Vexa changes priorities automatically. She suppresses normal town/quest-turn-in nagging and focuses on dungeon-relevant information such as:

- instance state
- boss pulls and boss kills
- wipes
- group/run context
- dungeon banter
- useful loot watch when the Encounter Journal provides reliable data

Commands:

- `/fc dungeon`
- `/fc dungeonloot`
- `/fc lootwatch`
- `/fc dungeondebug`

## Combat Proc Callouts

Vexa can detect important proc/ability opportunities using supported spell-activation events plus fallback conditional detection.

Examples include:

- Warrior — Overpower
- Rogue — Riposte
- Shaman — Maelstrom Weapon
- Mage — Hot Streak / Fingers of Frost
- Death Knight — Killing Machine / Rime
- Druid — Clearcasting
- Hunter — Lock and Load / Kill Shot
- Paladin, Priest, Warlock, Monk, Demon Hunter, Evoker, and others

Commands:

- `/fc proc test [spell]`
- `/fc proc list`
- `/fc proc on`
- `/fc proc off`
- `/fc procs`

## Gold Farming & Auctionator

Forever Companion can track dedicated farming sessions and compare:

- guaranteed vendor-floor value
- Auctionator's most recent scanned AH price when Auctionator is installed and has data
- gold/hour pacing
- session loot value
- top-value drops

Commands:

- `/fc farm start [label]`
- `/fc farm stats`
- `/fc farm stop`
- `/fc farm reset`
- `/fc value [shift-click item]`

Auctionator values are scan-based estimates, not guaranteed sale prices.

## Memory

Vexa keeps separate character histories while maintaining a shared roster across your characters. Character identity is based on normalized realm + character name, so leveling from 12 to 14 does not create a new character record.

If older versions created duplicate records, run:

`/fc memoryfix`

Vocabulary learning also persists in shared memory: Vexa remembers which built-in words she has already shown you and keeps a running vocabulary quiz score across characters.

## Speech Bubble & Companion Controls

- Drag Vexa to reposition her
- Alt + mouse wheel over Vexa to scale her
- Right-click Vexa for the quick menu
- Left-click a speech bubble to dismiss it
- Right-click a speech bubble to pin/unpin it
- Bubble placement automatically flips near screen edges

## Compatibility Notes

WoW Forever can expose a mix of modern and legacy APIs. Forever Companion uses defensive fallbacks and avoids arithmetic on protected/secret combat values when the client restricts them.

If something behaves incorrectly, useful diagnostics include:

- `/fc doctor`
- `/fc questdebug`
- `/fc dungeondebug`
- `/fc cap`

## Credits

**Forever Companion was created by Darktotem Stormforge.**

Vexa, the addon concept, feature direction, gameplay behavior, dialogue direction, memory design, and overall product vision are credited to **Darktotem Stormforge**.

---

Enjoy the road. Vexa will have something to say about it.


## Combat Calls diagnostics
Combat Calls use multiple detection paths because WoW Forever may not emit retail proc-overlay events consistently. The addon checks action-bar usability, proc auras/stacks, combat-log reactive events, and overlay events when available.

Useful commands:
- `/fc proc test Overpower` - force a visual/sound/shout test
- `/fc proc doctor` - show event/API/action-bar detection status
- `/fc proc reset` - restore Combat Calls defaults and rebuild its action map


## Spoken Combat Calls

Combat Calls use a compact borderless spell alert and can use prerecorded Vexa OGG clips for proc names such as Overpower, Riposte, and Maelstrom. Client TTS remains optional as a fallback, but when the custom pack is enabled RC39 leaves TTS fallback off by default. Position, scale, icon size, text size, duration, and audio behavior are adjustable under **Combat Calls**. Use `/fc proc move` to drag the alert and `/fc proc lock` to lock it.

## Speech bubbles

Long Vexa thoughts automatically continue across multiple numbered bubbles so dialogue is not cut off. Hover or pin a bubble to pause the continuation.


## Vexa prerecorded voice pack
RC39 supports prerecorded OGG voice clips for both class procs and gameplay events. Put clips in `Media/Voice/Vexa/`. Proc files are listed in `VOICE_PACK_MANIFEST.csv`; gameplay reactions are listed in `VOICE_PACK_EVENTS.csv`; and `VEXA_VOICE_PACK_MASTER_LIST.csv` combines both. Event hooks include interrupts, low health/close calls, death, level-ups, boss pulls/kills, dungeon entry/wipes/completion, rare/epic loot, upgrades, quest completion, bag/repair warnings, AFK returns, PvP, resource warnings, and travel/farming reactions.

Use `/fc voicepack test interrupt`, `/fc voicepack list`, and `/fc voicepack doctor` to test the pack. Prerecorded clips use WoW's Dialog channel and respect game audio mute settings. When the custom proc pack is enabled, TTS fallback is off by default so missing media does not unexpectedly switch back to the robotic system voice.
