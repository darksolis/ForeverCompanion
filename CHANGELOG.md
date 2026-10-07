# v0.9.62 RC57 — Full Vexa Personality Voice Expansion

- Integrated all 507 Jessica personality-expansion clips in addition to the existing 100-clip core/proc pack (607 total bundled Vexa clips).
- Added a dedicated `Media/Voice/Vexa/Personality/` package with the supplied CSV/JSON manifests and README.
- Added a manifest-driven personality voice router covering all 60 expansion categories.
- Personality recordings now carry their exact spoken text into Vexa's speech bubble, preventing text/audio mismatches.
- Added bond-aware and rarity-aware selection, recent-file repeat protection, class-aware and role-aware personality rotation, and rare easter-egg weighting.
- Added live routes for combat starts/wins, interrupts, missed interrupts, overpulls, gathering, gold changes, low-value loot, route reversals, and ground/fire damage where the client exposes a reliable signal.
- Existing gameplay topics now draw from the appropriate expansion pools for AFK, bosses, dungeons, loot, quests, health, deaths, resurrection, food/drink, travel, repairs, jumping, late-night play, class banter, roles, jokes, riddles, flirting, affection, and sarcasm.
- Recorded riddles are paired by ID so Vexa always plays the matching recorded answer for the exact recorded question she asked.
- `/fc voicepack personality <category>` directly tests any expansion category; `/fc voicepack personalitylist` lists all 60 categories.
- Voice-pack doctor now reports the complete 607-clip package and the last personality clip played.

# v0.9.61 RC56 — Voice-First Combat Audio

- Changed Combat Calls to use a single-audio priority chain: prerecorded Vexa clip, optional TTS fallback, then generic alert SFX.
- Generic combat alert sounds no longer layer over a successfully played Vexa voice callout.
- Renamed the Combat Calls sound option to `Fallback alert if voice is unavailable` so the setting matches its actual behavior.
- Added audio-route details to proc diagnostics so the last callout reports voice method and why fallback SFX did or did not play.
- Updated Combat Calls status text to show alert SFX as `fallback only` when enabled.

# v0.9.60 RC55 — Pristine Category Header

- Rebuilt the settings page header around the actual ornate center banner instead of centering titles inside the right-hand content panel.
- Active category titles are now centered on the frame artwork itself and automatically scale for longer names such as Dungeon Intelligence.
- Rewrote every category description to a shorter, cleaner one-line summary designed specifically for the banner space.
- Added a subtle violet title glow and restrained divider treatment that matches Vexa's purple-and-gold visual language.
- Moved settings cards into a consistent content start position with safe spacing below the decorative header.
- Kept dynamic description-height handling so future longer copy cannot collide with the first settings card.

# v0.9.59 RC54 — Settings Header Polish

- Moved each settings category title into the decorative top header slot so the active page title fits the frame art more naturally.
- Centered the page description directly under the active category title for a cleaner, more intentional layout.
- Added dynamic header spacing so longer category descriptions push the page content down automatically instead of crowding the top of the panel.
- Increased top padding for the page content area to better separate the decorative header from the first settings card.

# v0.9.58 RC53 — Complete Jessica Voice Pack

- Bundled the complete 100-clip Jessica Vexa voice pack directly inside the addon.
- Added 41 event/reaction clips and 59 class/proc clips with canonical lowercase underscore filenames.
- Verified every bundled event clip is routed by `VoicePack.lua` to an active topic or direct gameplay hook.
- Verified every bundled proc clip maps one-for-one to a canonical `ProcAlerts.lua` proc entry.
- Verified all 100 files decode as OGG Vorbis at 44.1 kHz and match the supplied SHA-256 manifest.
- Preserved the seven previously supplied recordings byte-for-byte while replacing the starter bundle with the full pack.
- Added full audio metadata as `VOICE_PACK_AUDIO_MANIFEST.csv` and an RC53 integration audit as `VOICE_PACK_QA.txt`.
- Updated the in-game voice-pack doctor and documentation for the complete pack.

# v0.9.57 RC52 — Bundled Vexa Starter Voice Pack

- Bundled the seven currently recorded Vexa voice clips directly inside the addon.
- Standardized all packaged filenames to lowercase underscore naming for reliable cross-platform lookup.
- Included `interrupt.ogg`, `low_health.ogg`, `sarcastic_death.ogg`, `overpower.ogg`, `revenge.ogg`, `riposte.ogg`, and `maelstrom_weapon.ogg`.
- Preserved legacy filename aliases in code so older manually installed voice packs still work.
- Updated the voice-pack documentation and test commands to match the files that now ship with the addon.

# v0.9.56 RC51 — Revenge Voice Reliability

- Fixed prerecorded Revenge proc callouts so both `revenge.ogg` and `Revenge.ogg` are recognized.
- Proc voice lookup now tries the canonical proc filename first, preventing trigger aliases from pointing at the wrong audio filename.
- Proc voice lookup now preserves an original-case filename fallback for better portability across existing voice packs.
- Kept legacy Overpower, Riposte, and Maelstrom voice filename aliases intact.

## 0.9.52-rc47 — Hidden Learning Report UI

- Removed the floating REPORT button from Vexa during normal gameplay.
- Removed Learning Report from Vexa's right-click quick menu.
- Kept background learning/telemetry running quietly.
- Moved report access into Settings > Advanced with a dedicated Vexa Learning Report section and observation count.
- Existing Generate + Select, Missed something, Bad last reaction, and Clear report data tools remain available inside the report window.

# 0.9.51-rc46

- Added a configurable minimum speech-bubble read hold (default 2.25s).
- Queued reactions no longer overwrite the current bubble during that protected window.
- High-priority preemptive reactions may interrupt only after the minimum hold has elapsed.
- Normal queued messages now flow into the next bubble when the current bubble lifetime ends.
- Timing diagnostics now show remaining read-lock and bubble lifetime.

## 0.9.50-rc45 — Vexa Learning Report
- Added passive local observation logging for dialogue repetition, stale/late reactions, topic coverage, and meaningful gameplay events.
- Added an always-available REPORT button on Vexa plus a copy-friendly Learning Report window.
- Added one-click Missed something and Bad last reaction captures; no commands required.
- Added Generate + Select workflow for copying one structured report into ChatGPT.
- Added event-coverage candidates, recent Vexa speech, recent game events, session topic rotation, and manual 15-second context captures to reports.
- Added bounded/deduplicated SavedVariables storage so learning data does not grow without limit.
- Added optional /fc report and /fc missed shortcuts.

# 0.9.49-rc44

- Fixed WoW Forever / 12.x `ADDON_ACTION_FORBIDDEN` spam caused by registering the now-blocked `COMBAT_LOG_EVENT_UNFILTERED` event.
- Modern clients now validate events before registration and never probe blocked CLEU registration through `pcall()`.
- CLEU remains available only on legacy client families where registration is legal.
- Combat Calls continue using safe action-bar, aura, overlay, and spellcast detection on Forever.
- Proc doctor now reports the combat-log restriction explicitly instead of treating it as a missing API.

# v0.9.48 RC43 — Deep Variety / Anti-Repetition Pass

- Replaced the old small-pool fallback that could repeatedly choose the first line after exhausting a topic.
- Added least-used-first dialogue rotation with per-topic exposure tracking and global recent-line suppression.
- Expanded recent topic memory from 7 to 18 topics and added session-wide topic exposure weighting.
- Added a large reactive-vocabulary expansion for eating, drinking, mounting, dismounting, AH, bank, mail, trade, stealth, AFK, hearth, swimming, resting, resources, bags, repairs, death, loot, skills, pets, and more.
- Added stronger cooldown floors for repetitive low-information behaviors so Vexa does not comment every single time.
- Added `/fc variety` to report high-frequency reaction-pool sizes.

# v0.9.47 RC42 — Reaction Timing Pass

- Added queue expiration so event reactions cannot surface long after their trigger.
- Added per-topic freshness windows and response-gap overrides for reactive gameplay events.
- Auction House, bank, mail, trade, barber, ready checks, danger warnings, resource warnings, loot, level-ups, and other short-lived reactions now get prompt priority.
- AH/bank/mail/trade/barber lines are revalidated against live UI state and removed immediately when the related window closes.
- Fresh high-priority reactions can interrupt stale ambient/reflective speech instead of waiting behind it.
- State-based ambient chatter now validates movement, zone, travel, town, resting, dungeon, and farming context before speaking.
- Quest-complete comments are discarded if the quest was already turned in before Vexa could speak.
- Dungeon boss-pull callouts expire quickly and are canceled when the encounter ends.
- Dropped stale queue items release their cooldown so valid future reactions are not suppressed.
- Added `/fc timing` (or `/fc queue`) to inspect pending speech age and remaining TTL.

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
