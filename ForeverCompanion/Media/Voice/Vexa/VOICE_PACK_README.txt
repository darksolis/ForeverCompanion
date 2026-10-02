FOREVER COMPANION - VEXA VOICE PACK
Created for Darktotem Stormforge

WHAT THIS FOLDER DOES
RC39 supports two kinds of prerecorded Vexa audio:
1) Proc callouts such as Overpower, Riposte, and Maelstrom.
2) Event/reaction clips such as interrupts, low health, death, level up, boss kills, loot, dungeon events, warnings, PvP, and more.

Put OGG Vorbis files directly in this folder:
ForeverCompanion/Media/Voice/Vexa/

Use these files for the exact recording lists:
- VOICE_PACK_MANIFEST.csv = class/proc callouts
- VOICE_PACK_EVENTS.csv = gameplay/event reactions
- VEXA_VOICE_PACK_MASTER_LIST.csv = both lists combined

IMPORTANT CURRENT-FILE COMPATIBILITY
RC39 recognizes the files already shown by Darktotem Stormforge:
- overpower.ogg
- Riposte.ogg (recommended standardized name: riposte.ogg)
- maelstrom.ogg (recommended standardized name: maelstrom_weapon.ogg)
- Interrupt.ogg (recommended standardized name: interrupt.ogg)
- low health.ogg (recommended standardized name: low_health.ogg)
- sarcastic death.ogg (recommended standardized name: sarcastic_death.ogg)
The aliases are included so they work without an immediate rename, but lowercase underscore filenames are recommended for portability.

RECOMMENDED VOICE PERFORMANCE
Create an original adult female fantasy-adventurer voice: confident, quick, dangerous/playful, expressive, and companion-like. Do not imitate or clone a real performer without permission.

PROC STYLE
- Usually 0.4-1.2 seconds.
- Sharp and urgent.
- The ability name should be immediately intelligible.
- No intro music, long breaths, or reverb tails.

EVENT STYLE
- Usually 0.7-2.5 seconds.
- More personality is welcome than on proc clips.
- Death, AFK, loot, and travel lines can be sarcastic/playful.
- Low-health, boss-pull, and interrupt lines should be short and urgent.

AUDIO FORMAT
- OGG Vorbis
- 44.1 kHz or 48 kHz
- Mono recommended for short voice clips
- Trim leading silence
- Keep loudness consistent across the pack

GAME AUDIO ROUTING
Custom clips play on WoW's Dialog channel and respect WoW's global/SFX/Dialog sound settings. If game sounds are muted, Vexa's prerecorded voice is muted too.

TTS FALLBACK
When custom proc clips are enabled, RC39 disables TTS fallback by default. If a requested proc clip is missing, Vexa stays silent instead of suddenly using the robotic system voice. You can re-enable TTS fallback from Combat Calls if desired.

COMMANDS
/fc voicepack on
/fc voicepack off
/fc voicepack test interrupt
/fc voicepack test low_health
/fc voicepack test sarcastic_death
/fc voicepack list
/fc voicepack doctor

Proc testing remains available through /fc proc test [spell].
