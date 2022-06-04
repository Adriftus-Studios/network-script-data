# network-script-data meta

| [Previous](https://github.com/Adriftus-Studios/network-script-data) | [Item Flags](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc) | [Next](./item_flags.md) |
|:--------:|:------------:|:----:|

## Entity Flags

### [No Fall Damage](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L13)
Flag: `no_fall_damage`

Any entities with this flag do not take fall damage.

### [No Fall Damage Once](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L15)
Flag: `no_fall_damage_once`

Any entities with this flag do not take fall damage. This flag is removed after one event.

### [No Damage](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L18)
Flag: `no_damage`

Any entities with this flag do not take damage.

### [No Damage Once](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L20)
Flag: `no_damage_once`

Any entities with this flag do not take damage. This flag is removed after one event.

### [No Heal](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L23)
Flag: `no_heal`

Any entities with this flag do not regain health.

### [No Heal Once](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L25)
Flag: `no_heal_once`

Any entities with this flag do not regain health. This flag is removed after one event.

### [On Next Damage](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L28)
Flag: `on_next_damage` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity takes damage. This flag is removed after one event.

### [On Next Hit](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L33)
Flag: `on_next_hit` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity deals damage. This flag is removed after one event.

### [On Target](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L38)
Flag: `on_target` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity is targeted.

### [On Targeting](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L44)
Flag: `on_targetting` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity starts targeting.

### [No Fly Kick](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L50)
Flag: `no_fly_kick` | Requires: Expiration (`DurationTag` or `TimeTag`)

Cancels the fly kick event for a player and sets a cooldown for the event with the flag's expiration value.

### [Right Click Script](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L53)
Flag: `right_click_script` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a player right clicks an entity.

### [Show Fake](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L59)
Flag: `showfake`

Cancels the material falls event for an entity and `showfake`s a falling block to players within 40 blocks.

### [On Fall](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L59)
Flag: `on_fall` | Takes: `ScriptTag`

Injects a script when a falling block is activated.

### [On Hit Entity](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L65)
Flag: `on_hit_entity` | Takes: `ScriptTag`

Injects a script when a projectile hits an entity.

### [On Hit Block](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L67)
Flag: `on_hit_block` | Takes: `ScriptTag`

Injects a script when a projectile hits a block.

### [No Suffocate](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L69)
Flag: `no_suffocate` | Takes: `ScriptTag`

Any players with this flag do not take suffocation damage.

### [On Shot](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L71)
Flag: `on_shot` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity is hit by a projectile.

### [Join Location](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L80)
Flag: `join_location`, `join_location.location`, or `join_location.<player.uuid>`

Teleports a player after joining when the server is flagged with any of the above flags.
- Server has a join location for a player: Teleport the player, then remove the flag.
- Server does not have a join location for a player: Teleport the player to a set location.
- Server does not have a set location: Remove the `join_location` flag.

### [On Entity Added](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L88)
Flag: `on_entity_added` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity is spawned.

### [On Dismount](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L94)
Flag: `on_dismount` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity dismounts.

### [On Dismounted](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L100)
Flag: `on_dismounted` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity is dismounted.

### [On Mount](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L106)
Flag: `on_mount` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity mounts.

### [On Mounted](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L112)
Flag: `on_mounted` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity is mounted.

### [Right Click Script Fake Entity](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L118)
Flag: `right_click_script` | Takes: `ScriptTag`

Injects a script when a player right clicks a fake entity.

### [Player Right Clicks](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L121)
Flag: `player_right_clicks` | Takes: `ScriptTag`

Injects a script when a block is right clicked.

### [Shift Player Right Clicks](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L123)
Flag: `shift_player_right_clicks` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a block is right clicked while sneaking.

### [On Damaged](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L130)
Flag: `on_damaged` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity is damaged.

### [On Death](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L136)
Flag: `on_death` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity dies.

### [On Breed](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L142)
Flag: `on_breed` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity breeds.

### [On Entity Break](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L148)
Flag: `on_break` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a hanging entity breaks.

### [On Item Pickup](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L154)
Flag: `on_item_pickup` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an item is picked up.

### [On Hunger Change](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L160)
Flag: `on_hunger_change` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity's food level changes.

### [On Explode](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L166)
Flag: `on_explode` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity explodes.

### [On Shoots Bow](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L172)
Flag: `on_shoots_bow` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity shoots a bow.

### [On Damage](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L178)
Flag: `on_damage` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity deals damage.

### [On Start Flying](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L184)
Flag: `on_start_flying` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a player starts flying.

### [On Stops Flying](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L190)
Flag: `on_stops_flying` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a player stops flying.

### [On Block Break](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L196)
Flag: `on_break` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a block is broken.

### [On Kick](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L202)
Flag: `on_kick` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when a player is kicked.

### [On Teleport](https://github.com/Adriftus-Studios/network-script-data/blob/Stage/denizen_scripts/global/server/entity_flags.dsc#L208)
Flag: `on_teleport` | Takes: `ScriptTag` or `ListTag[ScriptTag]`

Injects a script, or a list of scripts, when an entity teleports.

| Adriftus meta documentation was originally written by [`ChrispyMC (Kyu#5957)`](https://github.com/ChrispyMC). |
|:----:|
