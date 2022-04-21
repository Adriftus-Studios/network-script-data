mod_mute_item:
  type: item
  debug: false
  material: jukebox
  display name: <&2>Mute
  lore:
    - "<&a>Right Click:"
    - "<&6>Mute the Player from Chat."
  mechanisms:
    hides: ALL

mod_unmute_item:
  type: item
  debug: false
  material: note_block
  display name: <&a>Unmute
  lore:
    - "<&a>Right Click:"
    - "<&e>Unmute the Player from Chat."
  mechanisms:
    hides: ALL

mod_send_item:
  type: item
  debug: false
  material: ender_pearl
  display name: <&5><&l>Send
  lore:
    - "<&d>Transfer the Player to another Server."
  mechanisms:
    hides: ALL

mod_kick_item:
  type: item
  debug: false
  material: leather_boots
  color: 16711680
  display name: <&d><&l>Kick
  lore:
    - "<&a>Right Click:"
    - "<&e>Kick the Player from the Network."
  mechanisms:
    hides: ALL

mod_ban_item:
  type: item
  debug: false
  material: wooden_axe
  display name: <&c><&l>Ban
  lore:
    - "<&a>Right Click:"
    - "<&c>Ban the Player from the Network."
  enchantments:
    - ARROW_INFINITE:1
  mechanisms:
    hides: ATTRIBUTES|ENCHANTS

mod_player_item:
  type: item
  debug: false
  material: player_head
  display name: <player.flag[amp_map].as_map.get[uuid].as_player.name.if_null[invalid]>
  lore:
    - "<&6>Nickname: <&r><yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[Display_Name]||<player.flag[amp_map].as_map.get[uuid].as_player.name>>"
    - "<&6>Rank: <&r><yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[Rank]||None>"
    - "<&e>Current Channel: <&r><yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[chat.channels.current].to_titlecase||Server>"
    - "<&e>Active Channels:"
    - "<&a><&gt><&r> <yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].list_keys[chat.channels.active].separated_by[<&nl><&a><&gt><&r><&sp>].to_titlecase||Server>"
  mechanisms:
    skull_skin: <player.flag[amp_map].as_map.get[uuid].as_player.name>

mod_level1_item:
  type: item
  debug: false
  material: yellow_terracotta
  flags:
    tag: <&f><&lb><&e>1<&f><&rb><&e>
    colour: <&e>

mod_level2_item:
  type: item
  debug: false
  material: orange_terracotta
  flags:
    tag: <&7><&lb><&6>2<&7><&rb><&6>
    colour: <&6>

mod_level3_item:
  type: item
  debug: false
  material: red_terracotta
  flags:
    tag: <&8><&lb><&c>3<&8><&rb><&c>
    colour: <&c>
