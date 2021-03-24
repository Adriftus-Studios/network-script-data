mob_spawner_fragment:
  type: item
  material: prismarine_shard
  display name: <&b>Spawner Fragment
  debug: false
  mechanisms:
    custom_model_data: 1

mob_spawner_reinforced_fragment:
  type: item
  material: fire_charge
  display name: <&b>Reinforced Spawner Fragment
  debug: false
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
  debug: false
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
  debug: false
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
  debug: false
  events:
    on player places mob_spawner_completed:
    # - [check if item is valid]
    - if !<context.item_in_hand.has_flag[mob]>:
      - determine passively cancelled
      - narrate "<&4>This item was not marked correctly when created, please contact staff to claim a replacement."
      - stop
    - else:
      # - [set the entity type of the spawner]
      - define type <context.item_in_hand.flag[mob]>
      - wait 1t
      - adjust <context.location> spawner_type:<[type]>
      - flag <context.location> spawner

    on player breaks spawner:
    # - [check for enchantment/item type]
    - if !<player.item_in_hand.enchantments.contains[silk_touch]> || !<player.item_in_hand.material.name.contains[pickaxe]>:
      - determine passively cancelled
      - ratelimit <player> 2s
      - actionbar "<&4>You must a have silk touch pickaxe to break this!"
      - playsound <player.location> sound:entity_villager_no volume:2
    - else:
      # - [if vanilla spawner, give fragments]
      - if !<context.location.has_flag[spawner]>:
          - determine <item[mob_spawner_fragment].with[quantity=25]>
      # - [ if not, give spawner with entity type attached]
      - else if <context.location.has_flag[spawner]>:
        - define Type <context.location.spawner_type.entity_type.to_titlecase>
        - flag <context.location> spawner:!
        - flag <context.location> spawner_mob_tracker:!
        - determine passively "<item[mob_spawner_completed].with_flag[mob:<[type]>].with[display_name=<&a><[Type]><&b> Spawner]>"
      - else:
      # - [ if neither, something bork and get halp]
        - determine passively cancelled
        - narrate "<&4>This location was not marked correctly when the spawner was placed. Contact staff to claim a spawner replacement please."


mob_spawner_spawns:
  type: world
  debug: true
  events:
    on spawner spawns entity:
    # - [check if vanilla spawner and stop if so]
    - if !<context.spawner_location.has_flag[spawner]>:
      - stop
    - else:
      # - [check if the counter mob exists already]
      - if !<context.spawner_location.has_flag[spawner_mob_tracker]>:
        # # [flag the entity as 1 stack]
        - flag <context.entity> spawner_counter:1
        # # [flag the entity with the location it was spawned at to clear on death]
        - flag <context.entity> spawned_by:<context.spawner_location>
        # # [flag the server with the mob's uuid to track it down later to add more stacks]
        - flag <context.spawner_location> spawner_mob_tracker:<context.entity>
        # # [ nuke mob ai and set name for server lag reduction]
        - adjust <context.entity> is_aware:false
        - adjust <context.entity> "custom_name:<&b>Pacified <context.entity.entity_type.to_titlecase> <&6>(<&e><context.entity.flag[spawner_counter]><&6>)"
      - else:
        # - [if the mob already exists, we just want to add a stack to the counter, not spawn an additional entity]
        - determine passively cancelled
        # # [retrieve the UUID of the mob set previously, and increase the counter by 1 and then rename the mob]
        - define spawn_mob <context.spawner_location.flag[spawner_mob_tracker]>
        - if <[spawn_mob].flag[spawner_counter]> <= <element[99]>:
          - flag <[spawn_mob]> spawner_counter:++
          - adjust <[spawn_mob]> "custom_name:<&b>Pacified <context.entity.entity_type.to_titlecase> <&6>(<&e><[spawn_mob].flag[spawner_counter]><&6>)"

    on entity dies flagged:spawned_by:
    - if !<context.entity.has_flag[spawned_by]>:
      - stop
    # - [if the mob isn't flagged, or has 1 stack (less than 2) let it die]
    - if <context.entity.flag[spawner_counter]||0> == <element[1]>:
      - flag <context.entity.flag[spawned_by]> spawner_mob_tracker:!
      - stop
    - else:
      # # [let the mob drop its drops]
      - drop <context.drops> <context.entity.location>
      # # [stop the death]
      - determine passively cancelled
      # # [ decrease counter, heal to full, rename to update stacks on mob]
      - flag <context.entity> spawner_counter:--
      - heal <context.entity>
      - adjust <context.entity> "custom_name:<&b>Pacified <context.entity.entity_type.to_titlecase> <&6>(<&e><context.entity.flag[spawner_counter]><&6>)"
