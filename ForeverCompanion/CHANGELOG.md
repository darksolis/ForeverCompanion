# v0.9.44 RC39

- Added full prerecorded Vexa event voice-pack subsystem.
- Added immediate player-interrupt voice callouts from combat log.
- Added live low-health and critical-health voice warnings.
- Added voice hooks for level-ups, deaths, boss pulls/kills, dungeon entry/wipes/completion, rare/epic loot, upgrades, quest completion, bags, repairs, PvP, AFK return, resource warnings, travel, farming, elite/dangerous targets, and rare discoveries.
- Added aliases for existing user filenames: Interrupt.ogg, low health.ogg, sarcastic death.ogg, Riposte.ogg, and maelstrom.ogg.
- Custom proc clips now default on; TTS fallback defaults off when a custom proc clip is missing.
- Added VOICE_PACK_EVENTS.csv and combined VEXA_VOICE_PACK_MASTER_LIST.csv.
- Added /fc voicepack commands and settings controls.
- Audio continues to respect WoW global/SFX/Dialog mute settings.

# v0.9.43 RC38

- Added optional HD combat-call artwork for Overpower, Riposte, and Maelstrom.
- Added adjustable HD artwork size while preserving the compact borderless alert as the default.
- Added custom Vexa voice-pack support using `.ogg` files in `Media/Voice/Vexa/`.
- Added a 60-proc voice manifest and voice-pack production guide.
- Added `/fc proc voicepack on|off`.
- Combat alert sounds now route through WoW's SFX channel instead of Master.
- Custom Vexa voice clips route through WoW's Dialog channel.
- TTS and custom proc voices now respect WoW sound settings by default.
- Added CVAR_UPDATE handling to stop active Vexa proc speech when sound is disabled.
- Expanded `/fc proc doctor` with sound-routing, custom voice-pack, and HD-art status.

# Changelog

## 0.9.42-rc37 — Multi-Part Speech

- Long Vexa dialogue now automatically continues across multiple speech bubbles instead of clipping.
- Splits at sentence boundaries whenever possible and uses clause/word boundaries when a sentence is too long.
- Added subtle `1/2`, `2/3`, etc. continuation indicators.
- Continuation pages advance automatically after the current page's reading time.
- Hovering or pinning pauses continuation; dismissing the bubble cancels the remaining pages.
- Bubble page length adapts to the configured font scale to reduce text clipping.

## 0.9.41-rc36 — Library Expansion

- Major pass across the conversation/content system.
- Expanded generated dialogue library to 18,100+ variants across 104 Vexa topic pools.
- Added a built-in 401-entry curated vocabulary dictionary and 78 word roots.
- Added persistent vocabulary seen-word tracking and four-choice vocabulary quizzes.
- Added 1,328 general-trivia variants with 30-second delayed answers that wait through combat.
- Added new learning categories: language, animals, space, geography, math, body, technology, food, nature, psychology, oceans, weather, inventions, art, music, literature, mythology, and philosophy.
- Added idioms, proverbs, tongue twisters, absurd questions, original micro-stories, gaming-design thoughts, self-aware banter, compliments, and roasts.
- Added new commands: `/fc learn`, `/fc word`, `/fc define`, `/fc dictionary`, `/fc vocabquiz`, `/fc vocabanswer`, `/fc root`, `/fc trivia`, `/fc triviaanswer`, `/fc idiom`, `/fc proverb`, `/fc story`, and `/fc tonguetwister`.
- Expanded manual random-fact and question commands to draw from the larger library.
- Added conversation settings toggles for vocabulary, quizzes, roots, trivia, language play, expanded facts, creative content, meta banter, compliments, and roasts.
- Preserved Darktotem Stormforge author credit.

# v0.9.40 RC35

- Rebuilt Combat Calls as a compact borderless icon/text alert.
- Added draggable alert placement plus X/Y settings and reset controls.
- Added independent overall scale, icon size, text size, and duration controls.
- Added real spoken proc names through client TTS when available.
- Added installed voice detection, automatic likely-female voice preference, previous/next voice controls, rate and volume controls.
- Added `/fc proc move`, `lock`, `resetpos`, `voice`, and `voices` commands.
- Expanded Proc Doctor with voice availability and alert-position diagnostics.

## 0.9.39-rc34 - Arrival dialogue expansion
- Added a dedicated arrival engine instead of relying on the small generic login/zone pools.
- Added 40 login openers, 24 live-character/location closers, and 18 optional wildcard tags, producing thousands of possible login greetings.
- Added tailored arrival flavor for 122 named WoW zones across multiple eras.
- Each tailored zone has separate first-visit and return-visit templates, yielding 1,464 zone-specific arrival patterns before fallback combinations.
- Added a 30-line recent-arrival memory per login/zone bucket to reduce obvious repeats.
- Added 324 generic fallback zone combinations for custom/unknown WoW Forever zones.
- Login greeting now runs once per UI session instead of being re-fired by every PLAYER_ENTERING_WORLD transition.
- Added `/fc arrival` and `/fc arrival zone` preview commands.

## 0.9.38-rc33 - Combat Calls reliability rebuild
- Rebuilt proc detection around action-bar usability transitions, aura stacks, combat-log reactive mechanics, and overlay events.
- Warrior Overpower now has combat-log dodge detection plus action-bar readiness detection.
- Rogue Riposte can trigger from player parries plus action-bar readiness.
- Shaman Maelstrom Weapon uses live aura-stack detection.
- Replaced fragile proc alert visuals with a compatibility-safe alert panel containing Vexa art, spell icon, and class-colored accents.
- Added multi-path sound fallback and `/fc proc doctor` / `/fc proc reset`.
- Proc alert UI is now created atomically so one unsupported widget call cannot leave a broken half-created alert frame.

# 0.9.35-rc30
- Split repeated jumping from genuine long-fall reactions.
- Added 84 jump-streak lines, 25 long-fall lines, and 10 jump milestone callbacks.
- Added session jump counting with milestone reactions at 10/25/50/100/250/500/1000 jumps.
- Reduced repeated-jump chatter to a dedicated ~18-second topic cooldown instead of reusing long-fall banter.

## 0.9.33 RC28
- Dungeon entry explanation now fires once per run.
- Dungeon ambient chatter is capped to rare intervals and no longer repeats mode/turn-in explanations.
- Loot reminders are deduplicated per item/boss and boss progress only speaks when progress changes.

# 0.9.31-rc26
- Added Combat Calls subsystem for class proc-ready abilities.
- Uses SPELL_ACTIVATION_OVERLAY_GLOW_SHOW when available plus conditional usability and aura fallbacks.
- Added large center-screen proc effect, Vexa shout, alert sound, class-specific callouts, Combat Calls settings page, test tools, and slash commands.
- Includes class catalogs for Warrior, Rogue, Shaman, Paladin, Hunter, Mage, Warlock, Priest, Druid, Death Knight, Monk, Demon Hunter, and Evoker; unknown client overlay procs can be announced generically.

# 0.9.22 RC17

- Replaced the incorrect Auctioneer/AucAdvanced integration with Auctionator v1 API support.
- Uses Auctionator's supported `GetAuctionPriceByItemLink`, `GetAuctionAgeByItemLink`, and exact-match APIs.
- Added `Auctionator` as an optional dependency so its public API is ready when both addons are enabled.
- Gold commentary now accurately calls values the last scanned AH price and includes scan age when available.
- Revalues the active farm when the auction house closes and at pace checkpoints so a new Auctionator scan can update the session.
- Migrates the old `useAuctioneer` setting to `useAuctionator`.

# Forever Companion v0.9.19 RC14

- Added secret-value guards for modern WoW/Forever restricted combat APIs.
- Health and primary-power facts are skipped when the client marks them secret instead of causing Lua arithmetic errors.
- Hardened target identity/level checks for restricted instance/combat contexts.
- Fixed provisional `Realm::Unknown` character identity by rebinding memory on `PLAYER_ENTERING_WORLD` once UnitName is available.
- Session tracking now refreshes after real character identity resolves.
- `/fc doctor` reports secret-value API/restriction status.

# 0.9.18 RC13

## Fact trust and accuracy
- Added queue-time fact snapshots and pre-speech validation for factual commentary.
- Added `/fc why` with statement topic/category/reason, fact summary, source information, and a concise in-world explanation.
- Added repeat, history, favorite-last, and block-last conversation actions.
- Hardened XP milestones so milestone statements are scoped to the active character + level and checked against live XP before speech.
- Expanded validation to quest counts/rewards, bags, durability, zones, targets, role, rested XP, travel, stalled quests, and resource warnings.

## Context engine
- Added transition-based runtime state tracking inspired by useful patterns observed in WhitemaneMotivator.
- Added mount, food/drink, campfire, stealth, resting, taxi, swim, AFK/DND, guild/pet, capital, instance, battleground, group-role, and town-service awareness where exposed by the client.
- Added target elite/rare and dangerous-level reactions.
- Added bag-full/no-money UI error reactions.
- Added durability repair/broken-item tracking.
- Added mail, bank, merchant, auction, trade, barber, hearth, boss, ready-check, PvP, talent/skill, fall, and logout/session hooks.
- Added rare/epic loot and equipped item-level upgrade reactions.
- Added class-resource observations for rage, energy, and mana.
- Added taint diagnostic capture for blocked/forbidden addon actions.

## Memory and sessions
- Expanded cross-character roster memory while preserving per-character profiles/history.
- Added previous-session summaries with XP, duration, levels, deaths, quest turn-ins, best tracked zone, and playstyle/context distribution.
- Added safe text export/import for companion memory.

## Conversation engine
- Added category-specific speech budgets and mute controls.
- Added blocked/favorite line preferences and stronger recent-line suppression.
- Added mood-biased ambient dialogue.
- Added context suppression during combat, death, cinematics, and loading.
- Added a large new context dialogue library for the new gameplay events.

## UI and QA
- Added Characters, Conversation, and Test Lab settings pages.
- Added `/fc doctor` and integration diagnostics.
- Added `/fc test` scenarios and an internal self-test suite.
- Added auto-flipping speech bubble, separate bubble/font scaling, click-to-dismiss, hover pause, and pinning.
- Added remembered-character, previous-session, recent-fight, quest, bag, recommendation, history, and explanation actions to Vexa's quick menu.

## Integrations
- Added safe detection for Questie, Details, ElvUI, Grid/Grid2, and ChatSentry.
- Added best-effort Details combat snapshot support.

# 0.9.17 RC12
- Compact speech bubble and typography fixes.
- Per-character memory plus shared roster memory.
- Live XP milestone validation, including the 98%-XP regression case.
- High-resolution steady Vexa state art with restrained motion.

## 0.9.21-rc16 — Gold Farming Intelligence
- Added Auctionator integration using stored last-scanned AH price and scan-age data when Auctionator is loaded.
- Added vendor-floor pricing from item sell values.
- Added manual gold-farm sessions with auction value/hour, vendor floor/hour, cash gained/spent, item mix, and top item.
- Added valuable-drop commentary with Auctionator last-scanned AH value and scan age when available.
- Added periodic pacing commentary and trend comparison versus the prior pace check.
- Added cross-character learned item values and farm-session history.
- Added Gold Farming settings page, quick-menu actions, `/fc farm ...`, and `/fc value [item]`.
- Added gold-tracker Test Lab and Doctor checks.

## 0.9.23 RC18 — Conversation Expansion
- Expanded active dialogue vocabulary from roughly 1,271 to more than 5,000 runtime variants.
- Added dedicated walking, exploration, zone-aware, joke, WoW-trivia, relationship, encouragement, philosophy, quest, combat, town, travel, rest, and gold-farming conversation families.
- Added class-specific banter packs for Warrior, Shaman, Rogue, Paladin, Hunter, Mage, Warlock, Priest, Druid, Death Knight, Monk, Demon Hunter, and Evoker.
- Added cross-character memory callbacks during ambient conversation.
- Added context-weighted conversation selection with recent-topic suppression.
- Added conversation frequency and content toggles to the Conversation settings page.
- Added `/fc talk`, `/fc fact`, `/fc joke`, `/fc classbanter`, and `/fc vocab`.
- Added “Tell me something” to the companion quick menu.
- Movement state now feeds the conversation engine so walking chatter is actually tied to walking.

## 0.9.25-rc20
- Updated TOC interface IDs to match the current client family used by the uploaded Auctionator v339 build, including 120100.
- Added second-line protected math helpers for secret-value arithmetic (`SafeRatio`, `SafeSubtract`, `SafeMultiply`).
- Routed health, power, XP percentage, XP delta, combat XP delta, and player-level reads through protected/readable helpers.
- Doctor output now includes the live client version/interface reported by `GetBuildInfo()`.

## 0.9.28-rc23
- Reparented the minimap launcher to Minimap so EllesmereUI and similar button collectors can discover it.
- Made launcher textures resize with the button so holder/grid resizes stay clean.
- Expanded the control center to the native 4:3 artwork size and moved all pages into the decorative safe area.
- Narrowed sliders and re-spaced controls for better readability inside the custom panel.
- Simplified the Companion page around Vexa only.
- Removed Brannick and Pip from the active companion registry until their art/personality systems are fully built.

## 0.9.30-rc25 — Settings Layout V2
- Replaced fixed-coordinate page layouts with a shared scrollable layout system.
- Added consistent card sections, margins, two-column sizing, and automatic page height.
- Removed overlapping slider Low/High/min/max labels; sliders now show a single live value.
- Rebuilt all 11 settings pages around the new layout primitives.
- Added dedicated scroll regions for conversation history and memory journal.
- Moved long Appearance, Conversation, Gold Farming, and diagnostics pages into natural vertical scrolling.
- Kept the custom purple/gold shell while separating decorative art from functional control geometry.

## 0.9.32-rc27 — Dungeon Intelligence
- Added dungeon-aware context mode that suppresses quest turn-in/town reminders while in party/raid instances.
- Added Encounter Journal dungeon/raid matching and loot scanning.
- Added class/spec compatibility checks and item-level comparison against equipped slots.
- Added boss-start, boss-kill, wipe, and dungeon-progress commentary.
- Added dungeon loot watch, settings page, quick-menu actions, diagnostics, and Test Lab coverage.
- Added `/fc dungeon`, `/fc dungeonloot`, `/fc lootwatch`, and `/fc dungeondebug`.

## 0.9.34 RC29 — Massive Conversation Expansion
- Added ConversationMegaPack with quotes, science/history facts, questions, would-you-rathers, mini challenges, deep thoughts, jokes, and personal reflections.
- Added 2,184 riddle variants with delayed 30-second answers and combat-aware postponement.
- Added independent high-frequency ConversationTick so ambient speech is no longer limited by the 60-second Thought loop.
- Added quote/riddle/question/strange-fact controls and slash commands.
- Expanded active vocabulary to 8,916 dialogue variants plus 2,184 riddles.
- Increased default conversation frequency for existing users migrating to schema 25.
