
big_shulker_item:
  type: item
  material: shulker_box
  recipes:
    1:
      type: shapeless
      recipe_id: big_shulker_1
      input: material:*hulker_box|material:*hulker_box|material:*hulker_box|material:*hulker_box
  display name: <&r><&6><&l>Big <&e><&l>Shulker

big_shulker_inventory:
  type: inventory
  inventory: chest
  size: 54
  title: <&r><&6><&l>Big <&e><&l>Shulker

big_shulker_build_lore:
  type: procedure
  debug: false
  definitions: item
  script:
  - determine <[item]> if:<[item].script.name.equals[big_shulker_item].not.if_null[true]>
  - define items <[item].flag[big_shulker]>
  - if !<[items].is_empty>:
    - foreach <[items].get[1].to[5]> as:i:
      - define "lore:|:<&f><[i].display.to_titlecase.if_null[<[i].material.name.to_titlecase>]> <&f>x<[i].quantity>"
    - if <[items].size> > 5:
      - define "lore:|:<&f><&o>and <[items].size.sub[5]> more..."
    - determine <[item].with[lore=<[lore]>]>
  - else:
    - determine <[item].with[lore=<list[]>]>

big_shulker_events:
  type: world
  debug: false
  events:
    on player prepares anvil craft item:
    - define reagent <context.inventory.slot[1]>
    - stop if:<[reagent].script.name.equals[big_shulker_item].not.if_null[true]>
    - stop if:<context.item.script.name.equals[big_shulker_item].not.if_null[true]>
    - define item <context.item>
    - foreach <[reagent].list_flags> as:f:
      - define item <[item].with_flag[<[f]>:<[reagent].flag[<[f]>]>]>
    - define item <[item].with_flag[big_shulker_title:<context.new_name>]>
    - define item <[item].proc[big_shulker_build_lore]>
    - determine <[item]>
    on item recipe formed:
    - if <context.recipe_id> == denizen:big_shulker_1:
      - if <context.recipe.filter[inventory_contents.exists].parse[inventory_contents].combine.size> != 0:
        - determine cancelled
    - if <context.recipe_id.equals[big_shulker_1].if_null[true]>:
      - stop if:<context.item.script.name.equals[big_shulker_item].not.if_null[true]>
      - define reagent <context.recipe.filter[script.name.equals[big_shulker_item]].get[1].if_null[null]>
      - stop if:<[reagent].equals[null]>
      - determine <context.item.with_flag[big_shulker:<[reagent].flag[big_shulker].if_null[<list[]>]>].with[script=big_shulker_item].proc[big_shulker_build_lore]>
    on block explodes:
    - determine <context.blocks.filter[has_flag[big_shulker].not]>
    on entity explodes:
    - determine <context.blocks.filter[has_flag[big_shulker].not]>
    on piston extends:
    - determine cancelled if:<context.blocks.filter[has_flag[big_shulker]].is_empty.not>
    on block dispenses big_shulker_item bukkit_priority:MONITOR:
    - stop if:<context.location.relative[<context.location.block_facing>].material.name.to_lowercase.equals[air].not>
    - define loc <context.location.relative[<context.location.block_facing>]>
    - flag <[loc]> big_shulker:<context.item.flag[big_shulker]>
    - flag <[loc]> big_shulker_title:<context.item.flag[big_shulker_title].parse_color> if:<context.item.has_flag[big_shulker_title]>
    on player breaks *hulker_box bukkit_priority:MONITOR:
    - stop if:<context.location.block.has_flag[big_shulker].not>
    - define location <context.location>
    - if <server.online_players.filter[open_inventory.note_name.equals[big_shulker_<context.location.block>]].size.equals[0].not>:
      - foreach <server.online_players.filter[open_inventory.note_name.equals[big_shulker_<context.location.block>]]> as:p:
        - inventory close player:<[p]>
      - flag <context.location.block> big_shulker:<inventory[big_shulker_<context.location.block>].list_contents>
    - define item <item[big_shulker_item].with[material=<context.location.material.name>]>
    - flag <[item]> big_shulker:<context.location.block.flag[big_shulker]>
    - flag <[item]> big_shulker_title:<context.location.block.flag[big_shulker_title].parse_color> if:<context.location.block.has_flag[big_shulker_title]>
    - define item <[item].with[display=<context.location.block.flag[big_shulker_title].parse_color>]> if:<context.location.block.has_flag[big_shulker_title]>
    - flag <context.location.block> big_shulker:!
    - note remove as:big_shulker_<context.location.block>
    - determine <[item].proc[big_shulker_build_lore]>
    on item moves from inventory to inventory bukkit_priority:MONITOR:
    - stop if:<context.destination.location.note_name.starts_with[big_shulker_].not.if_null[true]>
    - define location <context.destination.location>
    - define inv <inventory[big_shulker_inventory]>
    - adjust <[inv]> contents:<context.destination.location.block.flag[big_shulker]>
    - determine cancelled if:<[inv].can_fit[<context.item>].not>
    - take from:<context.initiator> item:<context.item> quantity:<context.item.quantity>
    - give to:<[inv]> item:<context.item> quantity:<context.item.quantity>
    - flag <context.destination.location.block> big_shulker:<[inv].list_contents>
    on player clicks item in big_shulker_inventory:
    - define item <context.item>
    - define location <player.location>
    - if <context.is_shift_click> && <context.item.material.name.to_lowercase.contains[shulker]> && <context.clicked_inventory.script.name.equals[big_shulker_inventory].not||true>:
      - determine cancelled
    - if <context.cursor_item.material.name.to_lowercase.contains[shulker]> && <context.clicked_inventory.script.name.equals[big_shulker_inventory]>:
      - determine cancelled
    - if <context.click.equals[NUMBER_KEY]> && <player.inventory.slot[<context.hotbar_button>].material.name.to_lowercase.contains[shulker]> && <context.raw_slot.is_less_than_or_equal_to[54]>:
      - determine cancelled
    on player closes big_shulker_inventory:
    - define inv <context.inventory.note_name>
    - define loc <[inv].replace_text[big_shulker_].with[].as_location>
    - wait 1t
    - stop if:<server.online_players.filter[open_inventory.note_name.equals[<context.inventory.note_name>]].size.equals[0].not>
    - animatechest <[loc]> close sound:false <server.online_players>
    - playsound at:<[loc]> BLOCK_SHULKER_BOX_CLOSE
    - flag <[loc].block> big_shulker:<inventory[<[inv]>].list_contents>
    - note remove as:big_shulker_<[loc]>
    on player opens inventory:
    - stop if:<context.inventory.location.material.name.equals[shulker_box].not.if_null[true]>
    - define loc <context.inventory.location>
    - stop if:<[loc].has_flag[big_shulker].not>
    - determine cancelled
    on player right clicks *hulker_box location_flagged:big_shulker bukkit_priority:MONITOR:
    - if <player.is_sneaking> && <player.item_in_hand.material.name.equals[air].not>:
      - stop
    - stop if:<context.location.block.has_flag[big_shulker].not>
    - if <inventory[big_shulker_<context.location.block>].exists.not>:
      - note <inventory[big_shulker_inventory]> as:big_shulker_<context.location.block>
      - define inv <inventory[big_shulker_<context.location.block>]>
      - adjust <[inv]> contents:<context.location.block.flag[big_shulker]>
    - else:
      - define inv <inventory[big_shulker_<context.location.block>]>
    - determine passively cancelled
    - wait 1t
    - animatechest <context.location.block> open sound:false <server.online_players>
    - playsound at:<context.location.block> BLOCK_SHULKER_BOX_OPEN
    - adjust <[inv]> title:<context.location.block.flag[big_shulker_title].parse_color> if:<context.location.block.has_flag[big_shulker_title]>
    - inventory open d:<[inv]>
    on player places big_shulker_item bukkit_priority:MONITOR:
    - flag <context.location.block> big_shulker:<context.item_in_hand.flag[big_shulker]||<list[]>>
    - flag <context.location.block> big_shulker_title:<context.item_in_hand.flag[big_shulker_title].parse_color> if:<context.item_in_hand.has_flag[big_shulker_title]>
