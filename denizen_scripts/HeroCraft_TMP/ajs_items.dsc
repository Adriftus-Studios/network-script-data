calculate_durability_damage:
    type: procedure
    definitions: unbreaking_level
    debug: false
    script:
    - determine <element[1].div[<[unbreaking_level].add[1]>]>

calculate_fortune_drops:
    type: procedure
    definitions: fortune_level|quantity
    debug: false
    script:
    - define quantity <[quantity]||1>
    - define list:|:1
    - repeat <[fortune_level].add[1]>:
        - define list:|:<[value]>
    - determine <[quantity].mul[<util.random.decimal[1].to[<[list].random>]>]||1>

hammer_fix_events:
  type: world
  debug: false
  data:
    repair_reagent_amount:
      iron_ingot: 62
      netherite_ingot: 507
      diamond: 390
  task:
  - stop if:<context.inventory.slot[1].script.data_key[data.repair_reagent_requirement_multiplier].exists.not>
  - stop if:<context.inventory.slot[1].script.data_key[data.repair_reagent].exists.not>
  - define current_durability <context.inventory.slot[1].durability>
  - stop if:<[current_durability].equals[<context.item.durability>]>
  - define reagent <context.inventory.slot[1].script.data_key[data.repair_reagent]>
  - stop if:<context.inventory.slot[2].material.name.equals[<[reagent]>].not>
  - stop if:<script.list_keys[data.repair_reagent_amount].contains[<[reagent]>].not>
  - define multiplier <context.inventory.slot[1].script.data_key[data.repair_reagent_requirement_multiplier]>
  - define diff <script.data_key[data.repair_reagent_amount.<[reagent]>].div[<[multiplier]>]>
  - define reagent_item <context.inventory.slot[2]>
  - define new_durability <[current_durability].sub[<[diff].round.mul[<[reagent_item].quantity>]>]>
  events:
    on player breaks block:
    - stop if:<player.item_in_hand.enchantment_types.parse[name].contains[area_dig].not>
    - stop if:<player.item_in_hand.enchantment_types.parse[name].contains[efficiency].not>
    - inventory adjust d:<player.inventory> slot:<player.held_item_slot> remove_enchantments:efficiency
    on player clicks item in anvil bukkit_priority:high:
    - stop if:<context.raw_slot.equals[3].not>
    - inject <script.name> path:task
    - if <[new_durability].is_more_than[0]>:
      - inventory adjust d:<context.clicked_inventory> slot:2 quantity:0
    - else:
      - define num1 <[current_durability]>
      - define quantity 1
      - while <[num1]> > 0:
        - define quantity:+:1
        - define num1 <[num1].sub[<[diff]>]>
      - inventory adjust d:<context.clicked_inventory> slot:2 quantity:<context.clicked_inventory.slot[2].quantity.sub[<[quantity]>]>
    - inventory adjust d:<context.clicked_inventory> slot:1 quantity:0
    - inventory adjust d:<context.clicked_inventory> slot:3 quantity:0
    - adjust <player> item_on_cursor:<context.item>
    - wait 1t
    - inventory update
    on player prepares anvil craft item bukkit_priority:high:
    - inject <script.name> path:task
    - determine passively <context.item.with[durability=<[new_durability].max[0]>]>
    - if <[new_durability].is_more_than[0]>:
      - define quantity <[reagent_item].quantity>
    - else:
      - define num1 <[current_durability]>
      - define quantity 1
      - while <[num1]> > 0:
        - define quantity:+:1
        - define num1 <[num1].sub[<[diff]>]>
    - determine passively <context.repair_cost.add[<[quantity].mul[2.2].round>]>
