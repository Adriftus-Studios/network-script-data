mod_mute_item:
  type: item
  debug: false
  material: jukebox
  display name: <&2>Mute
  lore:
    - "<&6>Mute the Player from Chat."
    - "<&6>Empêchez le joueur de parler."
    - "Right Click / Clic Droit"
  mechanisms:
    hides: ALL

mod_unmute_item:
  type: item
  debug: false
  material: note_block
  display name: <&a>Unmute
  lore:
    - "<&e>Unmute the Player from Chat."
    - "<&e>Permettez le joueur de parler."
    - "Right Click / Clic Droit"
  mechanisms:
    hides: ALL

mod_send_item:
  type: item
  debug: false
  material: ender_pearl
  display name: <&5><&l>Send
  lore:
    - "<&d>Transfer the Player to a Server."
    - "<&d>Envoyez le joueur au serveur."
  mechanisms:
    hides: ALL

mod_kick_item:
  type: item
  debug: false
  material: leather_boots
  color: 16711680
  display name: <&d><&l>Kick
  lore:
    - "<&e>Kick the Player from the Server."
    - "<&e>Coup de pied du serveur."
  mechanisms:
    hides: ALL

mod_ban_item:
  type: item
  debug: false
  material: wooden_axe
  display name: <&c><&l>Ban
  lore:
    - "Left Click / Clic Gauche:"
    - "- <&c>Ban the Player from the Server."
    - "- <&c>Bannissez le joueur du serveur."
    - "Right Click / Clic Droit:"
    - "- <&c>Ban the Player from the Network."
    - "- <&c>Bannissez le joueur du réseau."
  enchantments:
    - ARROW_INFINITE:1
  mechanisms:
    hides: ATTRIBUTES|ENCHANTS

mod_player_item:
  type: item
  debug: false
  material: player_head
  display name: <player.flag[amp_map].as_map.get[uuid].as_player.name>
  lore:
    - "<&6>Nickname: <&r><yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[Display_Name]||None>"
    - "<&6>Rank: <&r><yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[Rank]||None>"
    - "<&e>Current Channel: <&r><yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[chat.channels.current].to_titlecase||None>"
    - "<&e>Active Channels:"
    - "<&a><&gt><&r> <yaml[global.player.<player.flag[amp_map].as_map.get[uuid]>].read[chat.channels.active].separated_by[<&nl><&a><&gt><&r><&sp>].to_titlecase||None>"
  mechanisms:
    skull_skin: <player.flag[amp_map].as_map.get[uuid].as_player.name>

mod_level1_item:
  type: item
  debug: false
  material: yellow_terracotta
  tag: <&f><&lb><&e>1<&f><&rb><&e>
  colour: <&e>

mod_level2_item:
  type: item
  debug: false
  material: orange_terracotta
  tag: <&7><&lb><&6>2<&7><&rb><&6>
  colour: <&6>

mod_level3_item:
  type: item
  debug: false
  material: red_terracotta
  tag: <&8><&lb><&c>3<&8><&rb><&c>
  colour: <&c>
