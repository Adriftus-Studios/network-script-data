mob_spawner_fragment:
  type: item
  material: prismarine_shard
  display name: <&b>Spawner Fragment
  debug: true
  mechanisms:
    custom_model_data: 1

mob_spawner_reinforced_fragment:
  type: item
  material: fire_charge
  display name: <&b>Reinforced Spawner Fragment
  debug: true
  mechanisms:
    custom_model_data: 3
  lore:
  - <&e>A very sturdy spawner shard.
  recipes:
    1:
      hide_in_recipebook: false
      type: shapeless
      output_quantity: 1
      input: mob_spawner_fragment|mob_spawner_fragment

mob_spawner_frame:
  type: item
  debug: true
  material: prismarine_shard
  display name: <&b>Spawner Frame
  mechanisms:
    custom_model_data: 2
  lore:
  - <&e>Capable of holding back immense power.
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - mob_spawner_fragment|mob_spawner_reinforced_fragment|mob_spawner_fragment
      - mob_spawner_fragment|mob_spawner_reinforced_fragment|mob_spawner_fragment
      - mob_spawner_fragment|mob_spawner_reinforced_fragment|mob_spawner_fragment

mob_spawner_core_uncharged:
  type: item
  material: fire_charge
  display name: <&b>Spawner Core (Uncharged)
  mechanisms:
    custom_model_data: 1
  lore:
  - <&c>This core seems dull and lifeless.
  debug: true
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - mob_spawner_fragment|mob_spawner_fragment|mob_spawner_fragment
      - mob_spawner_fragment|mob_spawner_fragment|mob_spawner_fragment
      - mob_spawner_fragment|mob_spawner_fragment|mob_spawner_fragment

mob_spawner_core_charged:
  debug: false
  type: item
  material: fire_charge
  display name: <&b>Spawner Core (Charged)
  mechanisms:
    custom_model_data: 2
    hides: all
  enchantments:
  - LUCK_OF_THE_SEA:1
  lore:
  - <&d>This core hums and pulses with power.
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - emerald|diamond|emerald
      - diamond|mob_spawner_core_uncharged|diamond
      - emerald|diamond|emerald

mob_spawner_completed:
  debug: false
  type: item
  material: spawner
  display name: <&a>Pig<&b> Spawner
  flags:
    mob: pig
  recipes:
    1:
      hide_in_recipebook: false
      type: shaped
      output_quantity: 1
      input:
      - mob_spawner_frame|mob_spawner_frame|mob_spawner_frame
      - mob_spawner_frame|mob_spawner_core_charged|mob_spawner_frame
      - mob_spawner_frame|mob_spawner_frame|mob_spawner_frame

mob_spawner_events:
  type: world
  debug: true
  events:
    on player places mob_spawner_completed:
    - if !<context.item_in_hand.has_flag[mob]>:
      - determine passively cancelled
      - narrate "<&4>This item was not marked correctly when created, please contact staff to claim a replacement."
      - stop
    - else:
      - define type <context.item_in_hand.flag[mob]>
      - wait 1t
      - adjust <context.location> spawner_type:<[type]>
      - flag server <context.location.simple>.spawner

    on player breaks spawner:
    - if !<player.item_in_hand.enchantments.contains[silk_touch]> || !<player.item_in_hand.material.name.contains[pickaxe]>:
      - determine passively cancelled
      - ratelimit <player> 2s
      - actionbar "<&4>You must have silk touch pickaxe to break this!"
      - playsound <player.location> sound:entity_villager_no volume:2
    - else:
      - if !<server.has_flag[<context.location.simple>.spawner]>:
          - determine <item[mob_spawner_fragment].with[quantity=25]>
      - else if <server.has_flag[<context.location.simple>.spawner]>:
        - define Type <context.location.spawner_type.entity_type.to_titlecase>
        - determine "<item[mob_spawner_completed].with_flag[mob:<[type]>].with[display_name=<&a><[Type]><&b> Spawner]>"
        - flag server <context.location.simple>.spawner:!
      - else:
        - determine passively cancelled
        - narrate "<&4>This location was not marked correctly when the spawner was placed. Contact staff to claim a spawner replacement please."

