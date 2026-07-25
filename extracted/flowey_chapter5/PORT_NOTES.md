# Flowery battle reconstruction notes

The source battle was recovered from `data - Copia.win` with UndertaleModTool v0.9.1.1. The 77 directly relevant decompiled GML entries are preserved in `code/`; extracted sprite frames and sounds remain in their corresponding folders.

## Recovered battle structure

- `obj_flowery_enemy` owns a mercy-driven seven-phase fight and sets Flowery's base damage to 99 in the original game.
- Phase 1/2 sequence: `FloweryDashTutorial`, `FloweryDeflect1`, `FloweryChase`, and bullet-enhanced Jarona deflects.
- Phase 3: Aqua and Seth enter; the fight alternates box attacks, Aqua knives, and rotating stars.
- Phase 4: Orange and Green enter; fist/Jarona patterns are combined with chase patterns.
- Phase 5: Yellow and Blue enter; their paired chase pattern repeats while the Justice ACT advances the route.
- Phase 6: `SuperJarona` and the stronger deflect pattern lead into `SusiesIdea`.
- Phase 7 is the nonviolent conclusion and escape toward the Fountain.
- The source contains 23 attack choices (`myattackchoice` 0 through 22) backed by `obj_dbulletcontroller` types 620 through 641 and 647.

## Kristal port

The attack implementation now mirrors controller types 620-641 and 647 directly through `flowery_gml_base.lua`. The GameMaker 640x240 scrolling coordinate system is proportionally mapped into a 300x190 Kristal arena, while preserving attack types, difficulty values, timer goals, counters, sine paths, Jarona modes, and bullet flags. The orange heart's charge/release dash is recreated with Kristal's Cancel input.

The extracted Omega Flowery sprite family was present in the data but was not referenced by the recovered Flowery controller. This port deliberately uses it for the phase-six power-up so those battle assets are represented.
