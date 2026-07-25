# Chapter 4 Titan Spawn evidence

Source: `chapter4_windows/data.win`, read by UTMT CLI v0.9.1.1. The source file was never used as an output target.

- Enemy object: `obj_titan_spawn_enemy` (distinct from `obj_titan_enemy`). Its Create event maps idle/hurt to
  `spr_titan_spawn_idle` and `spr_titan_spawn_hurt`; its Check text establishes AT 30 / DF 200.
- Its turn event selects attack-controller types 456, 460, then 450. `obj_dbulletcontroller` maps those to
  `obj_darkshape_manager.pattern_default_intro`, `.pattern_default_speedup`, and `.pattern_default`.
- The encounter's reachable sequence is intro once, speedup once, then default thereafter because the third
  selection resets `phaseturn` to 2 before each subsequent increment. No Titan (`obj_titan_enemy`) attacks
  were included.
- Source timing is 30 steps/second: attack duration 360 steps (12 seconds), intro spawn every 24 steps,
  speedup every 16, initial manager timer 17. Dark shapes fade by 0.025/step, accelerate by 0.15/step to
  2.25 px/step, and are destroyed after reaching full exposure in the SOUL's 48px light aura.
- Sprite metadata from UTMT: idle 8 frames, 40x46, origin 0,0; hurt 1 frame, 53x46, origin 0,0;
  animated dark shape 8 frames and static shrivel shape 6 frames, both 30x34, origin 15,17.
- Referenced sound mappings: `snd_spawn_attack` -> embedded `snd_spawn_attack.ogg` (audio 315),
  `snd_dark_odd` -> embedded `snd_dark_odd.mp3` (audio 103), and `snd_organ_enemy_loop_temp` -> embedded
  `snd_organ_enemy_loop_temp.wav` (audio 191), and `snd_spawn_weaker` -> embedded `snd_spawn_weaker.ogg`
  (audio 316), all in `audiogroup_default`. These four files were exported for this local port. The room setup
  at `obj_dw_churchc_titanclimb1_post_Step_0:503` initializes external `mus/titan_spawn.ogg`; that file was
  integrated as `assets/music/titan_spawn.ogg` and the encounter now selects it.
- Relevant room references are the Titan climb room family (`room_dw_churchc_titanclimb1*` and
  `room_dw_churchc_titanclimb2*`). The battle enemy/controller code does not bind Titan Spawn to one room;
  this Kristal encounter is intentionally debug-spawnable and does not port Titan's overworld sequence.

## Rebuilt runtime mapping (bounded re-extraction)

The July 2026 rebuild used `tools/ExtractTitanSpawnBounded.csx` against the specified Chapter 4 `data.win`.
The resulting bounded evidence is under `bounded/` and includes only the Titan Spawn enemy, dark-shape manager,
ordinary/red shape, LIGHT aura, COURAGE blob, battle-controller references, relevant global scripts, and matching
sprite families. The source data was opened read-only and was not an output target.

- Runtime stats are HP 3000 / AT 18 / DF 0; the deliberately misleading Check display remains AT 30 / DF 200.
- The 160x130 board, 360-step duration, manager timer 17, intro 24-step cadence, speedup 16-step cadence,
  subsequent 12-step cadence, 120..169/150..199 radial geometry, and intro -> speedup -> default loop are retained.
- Default and speedup attacks now create a red shape every fifth spawn. `obj_redshape_Create_0` proves these are
  2.5x-speed, non-purifiable shapes which continuously steer with a decaying 0.3 tracking interpolation, halve
  speed inside LIGHT, and remain dangerous. Ordinary shapes retain source's one-time heading at fade completion;
  `obj_darkshape_Step_0:21-27` does not continuously steer them.
- A persistent `titan_spawn_light` battle object now renders the SOUL aura and approaches its 48px target by 10%
  per source step. Brighten costs 10 internal TP (4%), raises the current barrage target to 63px, and resets for
  the following turn. Ordinary shapes use the original six shrivel frames/radii (20,16,13,10,8,8), LIGHT gain
  0.05/step and recovery 0.01/step before dropping source-style COURAGE.
- COURAGE primes for 20 steps, begins at 4px/step away from the SOUL, then homes up to 5px/step using
  `20/distance` acceleration. Collection radius is 20px and grants 4 internal TP (1.6%), doubled after four
  barrages. Banish consumes 160 internal TP (64%), purifies every enemy in the encounter, and ends through normal
  spare completion. Titan Spawn retains normal HP damage/violent defeat.

- `obj_darkshape_Step_0:21-27` aims exactly once when its 40-step fade completes. `chase_heart()` changes speed
  and light but never direction. The first port recomputed direction every update, producing the reported
  suction/homing. Kristal now locks the heading after fade-in. Source speed (2.25 px/step = 67.5 px/s) and
  acceleration (0.15 px/step per step = 135 px/s2) are converted independently; the old conversion made the
  acceleration 30 times too low. Spawn radii remain 120..169 or 150..199 around the 160x130 arena center,
  because they are growtangle-local source coordinates rather than 640x480 viewport coordinates.
- `obj_darkshape_Create_0:97-137` creates a size-2 green blob when LIGHT reaches one. Its Step event primes for
  20 steps, homes to the SOUL, and awards `size * 2` TP, doubled after Titan Spawn turn four. The Kristal
  `titan_spawn_courage` adapter preserves those delays and 4/8 TP awards. `Shine` changes the aura from 48 to
  63 exactly as enemy Step lines 172-181 do.
- `scr_monstersetup` names Banish and assigns cost 160; enemy Step lines 147-168 teach the LIGHT/COURAGE loop,
  and lines 277-296 launch purification and `scr_wincombat`. Kristal exposes Banish as an ACT, rejects it below
  160 TP, consumes 160 TP, spares Titan Spawn, and therefore uses the engine's normal battle completion path.
  Physical damage remains possible at engine level, unlike the intended source route, but is not required.
- Enemy Draw calls `scr_enemy_drawidle_generic(1/6)`: eight idle frames advance at five frames/second. The actor
  default previously named frame zero, so Kristal never selected the animation. It now defaults to `idle` at
  the source rate. The green/black trailing silhouettes are baked into those eight source frames; there is no
  separate Titan Spawn afterimage object in the complete code-reference search. Dark-shape light particles and
  TP blobs are separate source objects; the blob is ported, while shader particles remain represented by the
  shrinking/brightening shape and yellow blob.
- Attack start, per-shape odd noise, hurt, blob collection, and purification references were audited. The port
  includes attack, odd, hurt, organ-loop, and battle-music files. It currently plays attack, hurt, collection,
  purification, and battle music. The source's quarter-pitch organ layer is not mixed concurrently because
  Kristal encounter music has one native channel; the exported file is retained for a future layered mixer.

Remaining engine-level differences: GameMaker's 46x46 per-scanline sine surface and darkness shader are represented
with Kristal sprite/color drawing rather than a custom shader. Kristal has no encounter-local equivalent of
Chapter 4's global darkness TP multiplier, so ordinary defend/graze TP remains engine-standard; COURAGE values are
exact. The original concurrent quarter-pitch organ loop is still retained as an asset but not mixed over Kristal's
single encounter music channel. No in-game verification was performed.
