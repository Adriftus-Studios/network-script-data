# MOD PANEL ITEMS
mod_send_item:
  type: item
  debug: false
  material: ender_pearl
  display name: <&5><&l>Send
  lore:
    - <&1>Right Click<&co>
    - <&d>Transfer the Player to another Server.
  mechanisms:
    hides: ALL

mod_teleport_item:
  type: item
  debug: false
  material: feather
  display name: <&3><&l>Teleport
  lore:
    - <&1>Right Click<&co>
    - <&b>Teleport to the Player.
  mechanisms:
    hides: ALL
    custom_model_data: 200

mod_spectate_item:
  type: item
  debug: false
  material: spyglass
  display name: <&6><&l>Spectate
  lore:
    - <&1>Right Click<&co>
    - <&e>Spectate the Player.
  mechanisms:
    hides: ALL

mod_inventory_item:
  type: item
  debug: false
  material: chest
  display name: <&2><&l>Inventory
  lore:
    - <&1>Left Click<&co>
    - <&a>View Inventory of Player.
    - <&1>Right Click<&co>
    - <&a>View Inventory Log of Player.
  mechanisms:
    hides: ALL

mod_kick_item:
  type: item
  debug: false
  material: leather_boots
  color: 16711680
  display name: <&5><&l>Kick
  lore:
    - <&1>Right Click<&co>
    - <&d>Kick the Player from the Network.
  mechanisms:
    hides: ALL

mod_ban_item:
  type: item
  debug: false
  material: netherite_axe
  display name: <&4><&l>Ban
  lore:
    - <&1>Right Click<&co>
    - <&c>Ban the Player from the Network.
  enchantments:
    - ARROW_INFINITE:1
  mechanisms:
    hides: ATTRIBUTES|ENCHANTS

mod_unban_item:
  type: item
  debug: false
  material: netherite_axe
  display name: <&4><&l>Unban
  lore:
    - <&1>Right Click<&co>
    - <&c>Unban the Player from the Network.
  enchantments:
    - ARROW_INFINITE:1
  mechanisms:
    hides: ATTRIBUTES|ENCHANTS

mod_player_item:
  type: item
  debug: false
  material: player_head
  display name: <&r><player.flag[amp].get[name].if_null[invalid]>
  lore:
    - <&6>Nickname<&co> <&r><yaml[global.player.<player.flag[amp].get[uuid]>].read[Display_Name]||<player.flag[amp].get[name]>>
    - <&6>Rank<&co> <&r><yaml[global.player.<player.flag[amp].get[uuid]>].read[Rank]||None>
    - <&e>Current Channel<&co> <&r><yaml[global.player.<player.flag[amp].get[uuid]>].read[chat.channels.current].to_titlecase||Server>
    - <&e>Active Channels<&co>
    - <&2><&gt><&r> <yaml[global.player.<player.flag[amp].get[uuid]>].list_keys[chat.channels.active].separated_by[<&nl><&2><&gt><&r><&sp>].to_titlecase||Server>
  mechanisms:
    custom_model_data: 3
    skull_skin: <player.flag[amp].get[name]>

# KICK/BAN INFRACTION ITEMS
mod_level1_item:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 100
    hides: ALL
  flags:
    tag: <&f><&lb><&e>1<&f><&rb><&e>
    colour: <&e>

mod_level2_item:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 100
    hides: ALL
  flags:
    tag: <&7><&lb><&6>2<&7><&rb><&6>
    colour: <&6>

mod_level3_item:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 100
    hides: ALL
  flags:
    tag: <&8><&lb><&c>3<&8><&rb><&c>
    colour: <&c>

mod_level4_item:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 100
    hides: ALL
  flags:
    tag: <&8><&lb><&c>4<&8><&rb><&c>
    colour: <&c>

# MOD TOOL ITEMS
mod_ban_hammer_item:
  type: item
  debug: false
  material: netherite_axe
  display name: <&4><&l>Ban Hammer
  lore:
    - <&1>Drop<&co>
    - <&c>Open the Ban Menu.
  enchantments:
    - ARROW_INFINITE:1
    - VANISHING_CURSE:1
  mechanisms:
    hides: ATTRIBUTES|ENCHANTS
  flags:
    on_drop: mod_ban_hammer_task
