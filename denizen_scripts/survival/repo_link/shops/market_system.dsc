###########-------- DEBUG COMMAND --------########
market_command:
  type: command
  debug: false
  usage: /open_market
  description: opens
  name: open_market
  permission: adriftus.admin
  script:
    - if <server.flag[market_open]>:
      - inventory open d:market_system_main_GUI player:<server.match_player[<context.args.first>]>
    - else:
      - narrate "<&c>The Market is currently closed to update it's pricing."

#################
## INFORMATION ##
#################

# ---------------------- #
# - Market System Data - #
# ---------------------- #
# The below data script container is for adding/removing/categorizing/pricing items
# -- IMPORTANT -- #
## WHEN ADDING A NEW CATEGORY, MODIFY THE market_system_main_GUI SCRIPT TO MAKE ROOM FOR IT
## THIS CAN BE DONE BY DELETING ONE OF THE FILLER SPOTS

market_system_data:
  type: data
  debug: false
  settings:
    adjustment_amount: 2
    # -- IMPORTANT -- #
    ## THE sell_buy_difference (BELOW) SHOULD ALWAYS BE GREATER THAN adjustment_amount (ABOVE).
    ## THIS AVOIDS INFINITE MONEY GLITCHES.
    sell_buy_difference: 0.1
  categories:
    crafting:
      material: diamond_ore
      CMD: 0
      lore: <&e>Various materials for crafting.
    building:
      material: oak_planks
      CMD: 0
      lore: <&3>Building Stuffs!
    potion_ingredients:
      material: spider_eye
      CMD: 0
      lore: <&5>Brewing Ingredients for the masses!
    commodities:
      material: milk_bucket
      CMD: 0
      lore: <&a>Trade Goods!
  items:
    # Crafting


    diamond:
      category: crafting
      minimum_value: 300

#    -- Emeralds can be obtained easily from villagers.
#    emerald:
#      category: crafting
#      minimum_value: 20.0

    iron_ingot:
      category: crafting
      minimum_value: 30

    gold_ingot:
      category: crafting
      minimum_value: 30

    leather:
      category: crafting
      minimum_value: 10

    # Building
    oak_planks:
      category: building
      minimum_value: 15

    spruce_planks:
      category: building
      minimum_value: 15

    acacia_planks:
      category: building
      minimum_value: 15

    dark_oak_planks:
      category: building
      minimum_value: 15

    jungle_planks:
      category: building
      minimum_value: 15

    white_wool:
      category: building
      minimum_value: 50

    # Potions
    # https://minecraft.gamepedia.com/Brewing
    blaze_powder:
      category: potion_ingredients
      minimum_value: 20

    nether_wart:
      category: potion_ingredients
      minimum_value: 20

    glowstone_dust:
      category: potion_ingredients
      minimum_value: 20

    fermented_spider_eye:
      category: potion_ingredients
      minimum_value: 20

    gunpowder:
      category: potion_ingredients
      minimum_value: 20

    dragon_breath:
      category: potion_ingredients
      minimum_value: 20

    sugar:
      category: potion_ingredients
      minimum_value: 20

    rabbit_foot:
      category: potion_ingredients
      minimum_value: 20

    glistering_melon_slice:
      category: potion_ingredients
      minimum_value: 20

    spider_eye:
      category: potion_ingredients
      minimum_value: 20

    pufferfish:
      category: potion_ingredients
      minimum_value: 20

    magma_cream:
      category: potion_ingredients
      minimum_value: 20

    golden_carrot:
      category: potion_ingredients
      minimum_value: 20

    blaze_powder:
      category: potion_ingredients
      minimum_value: 20

    ghast_tear:
      category: potion_ingredients
      minimum_value: 20

    scute:
      category: potion_ingredients
      minimum_value: 20

    phantom_membrane:
      category: potion_ingredients
      minimum_value: 20

    glass_bottle:
      category: potion_ingredients
      minimum_value: 20

    #Commodities
    milk_bucket:
      category: commodities
      minimum_value: 10

    paper:
      category: commodities
      minimum_value: 10

    egg:
      category: commodities
      minimum_value: 10

    blue_ice:
      category: commodities
      minimum_value: 10

    cocoa_beans:
      category: commodities
      minimum_value: 10

    wheat:
      category: commodities
      minimum_value: 10

#####################
## MAIN MARKET GUI ##
#####################

market_system_main_GUI:
  type: inventory
  debug: false
  inventory: chest
  title: <&e>Market
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
  procedural items:
    - foreach <script[market_system_data].list_keys[categories]> as:category:
      - define name <&e><[category].replace_text[_].with[<&sp>].to_titlecase>
      - define lore <script[market_system_data].parsed_key[categories.<[category]>.lore]>
      - define material <script[market_system_data].data_key[categories.<[category]>.material]>
      - define CMD <script[market_system_data].data_key[categories.<[category]>.CMD]>
      - define list:->:<item[<[material]>].with[custom_model_data=<[CMD]>;display_name=<[name]>;lore=<[lore]>;nbt=category/<[category]>]>
    - determine <[list]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
#    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

market_system_main_GUI_events:
  type: world
  debug: false
  events:
    on player clicks item in market_system_main_GUI:
      - determine passively cancelled
      - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
      - if <context.item.has_nbt[category]>:
        - define inventory <inventory[market_system_category_GUI]>
        - define category <context.item.nbt[category]>
        - define page 1
        - inject market_system_category_setup
        - inventory open d:<[inventory]>

#########################
## MARKET CATEGORY GUI ##
#########################

market_system_category_next_page_button:
  type: item
  debug: false
  material: green_wool
  display name: <&a>Next Page

market_system_category_previous_page_button:
  type: item
  debug: false
  material: red_wool
  display name: <&c>Previous Page

market_system_category_GUI:
  type: inventory
  debug: false
  inventory: chest
  title: <&e>Market
  custom_slots_map:
    hidden_marker: 1
    player_info: 5
    market_items: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
    previous_page: 37
    next_page: 45
    buy_sell_item: 41
    sell:
      stack: 47
      half_stack: 48
      one: 49
      all: 46
    buy:
      stack: 53
      half_stack: 52
      one: 51
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    back_button: <item[barrier].with[display_name=<&e>;nbt=back/back]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

market_system_category_events:
  type: world
  debug: false
  events:
    on player clicks item in market_system_category_GUI:
      - determine passively cancelled
      - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
      - ratelimit <player> 5t
      - define inventory <context.inventory>
      - if <context.item.has_nbt[market_item]>:
        - define item <context.item.nbt[market_item]>
        - inject market_system_category_set_buy_sell_items
      - if <context.item.has_nbt[buy]>:
        - define cost <context.item.nbt[price]>
        - define quantity <context.item.nbt[buy]>
        - define item <[inventory].slot[<script[market_system_category_GUI].data_key[custom_slots_map.buy_sell_item]>].nbt[item]>
        - inject market_system_categories_buy_item
      - if <context.item.has_nbt[sell]>:
        - define cost <context.item.nbt[price]>
        - define quantity <context.item.nbt[sell]>
        - define item <[inventory].slot[<script[market_system_category_GUI].data_key[custom_slots_map.buy_sell_item]>].nbt[item]>
        - inject market_system_categories_sell_item
      - if <context.item.has_nbt[back]>:
        - inventory open d:market_system_main_GUI

#---------------#
# - FUNCTIONS - #
#---------------#
market_system_category_setup:
  type: task
  debug: false
  definitions: inventory|category|page
  script:
    - inject market_system_category_set_market_items
    - inject market_system_category_set_player_head
    - inject market_system_category_set_market_next_page
    - inject market_system_category_set_market_previous_page

market_system_get_price_of_multiple:
  type: procedure
  
  debug: false
  definitions: item|amount|buy_or_sell
  script:
    - define current_value <yaml[current_market].read[items.<[item]>.value]>
    - if <[buy_or_sell]> == sell:
      - define current_value <[current_value].*[<script[market_system_data].data_key[settings.sell_buy_difference]>]>
    ## OLD
    #- repeat <[amount]>:
    #  - define list:|:<[current_value]>
    #  - define current_value:+:<script[market_system_data].data_key[settings.adjustment_amount]>
    #- determine <[list].sum>
    - determine <[current_value].*[<[amount]>]>

market_system_categories_buy_item:
  type: task
  debug: false
  script:
    - if <player.money> < <[cost]>:
      - narrate "<&c>You don't have enough money"
      - playsound <player> sound:ENTITY_VILLAGER_NO volume:0.6 pitch:1.4
      - stop
    - give <[item].as_item.with[quantity=<[quantity]>]>
    - take money quantity:<[cost]>
    - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
    - define buy_or_sell buy
    - inject market_system_category_set_player_head

market_system_categories_sell_item:
  type: task
  debug: false
  script:
    - if !<player.inventory.contains[<[item].as_item>].quantity[<[quantity]>]>:
      - if <[quantity]> == 1:
        - narrate "<&c>You do not have that item to sell."
      - else:
        - narrate "<&c>You do not have enough of that item to sell <[quantity]>"
      - stop
    - give money quantity:<[cost]>
    - take <[item].as_item> quantity:<[quantity]>
    - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
    - define buy_or_sell sell
    - inject market_system_category_set_player_head

market_system_category_set_buy_sell_items:
  type: task
  debug: false
  script:
    - define slot <script[market_system_category_GUI].data_key[custom_slots_map.buy_sell_item]>
    - define buy_price <yaml[current_market].read[items.<[item]>.value]>
    - define sell_price <[buy_price].*[<script[market_system_data].data_key[settings.sell_buy_difference]>]>
    - define "lore:<&a>Buy Price<&co> <&e><[buy_price]>|<&c>Sell Price<&co> <[sell_price]>"
    - define name <&a><[item].replace[_].with[<&sp>].to_titlecase>
    - inventory set slot:<[slot]> d:<[inventory]> o:<[item].as_item.with[display_name=<[name]>;lore=<[lore]>;nbt=item/<[item]>]>
    # SELL ALL
    - define amount_in_inventory <player.inventory.quantity[<[item].as_item>]>
    - if <[amount_in_inventory]> > 1:
      - define this_sell_price <proc[market_system_get_price_of_multiple].context[<[item]>|<[amount_in_inventory]>|sell]>
      - define slot <script[market_system_category_GUI].data_key[custom_slots_map.sell.all]>
      - inventory set slot:<[slot]> d:<[inventory]> o:<item[red_wool].with[display_name=<&c>Sell<&sp>All<&sp>(<[amount_in_inventory]>);nbt=sell/<[amount_in_inventory]>|price/<[this_sell_price]>;lore=<&a>Price<&co><&sp><&e><[this_sell_price]>]>
    # FULL STACK
    - define max_stack <[item].as_material.max_stack_size>
    - if <[max_stack]> > 1:
      - define this_buy_price <proc[market_system_get_price_of_multiple].context[<[item]>|<[max_stack]>|buy]>
      - define this_sell_price <proc[market_system_get_price_of_multiple].context[<[item]>|<[max_stack]>|sell]>
      - define slot <script[market_system_category_GUI].data_key[custom_slots_map.sell.stack]>
      - inventory set slot:<[slot]> d:<[inventory]> o:<item[red_wool].with[quantity=<[max_stack]>;display_name=<&c>Sell<&sp><[max_stack]>;nbt=sell/<[max_stack]>|price/<[this_sell_price]>;lore=<&a>Price<&co><&sp><&e><[this_sell_price]>]>
      - define slot <script[market_system_category_GUI].data_key[custom_slots_map.buy.stack]>
      - inventory set slot:<[slot]> d:<[inventory]> o:<item[green_wool].with[quantity=<[max_stack]>;display_name=<&c>Buy<&sp><[max_stack]>;nbt=buy/<[max_stack]>|price/<[this_buy_price]>;lore=<&c>Price<&co><&sp><&e><[this_buy_price]>]>
    # HALF STACK
    - if <[max_stack]> > 1 && <[max_stack].mod[2]> == 0:
      - define this_sell_price <proc[market_system_get_price_of_multiple].context[<[item]>|<[max_stack]./[2]>|sell]>
      - define this_buy_price <proc[market_system_get_price_of_multiple].context[<[item]>|<[max_stack]./[2]>|buy]>
      - define slot <script[market_system_category_GUI].data_key[custom_slots_map.sell.half_stack]>
      - inventory set slot:<[slot]> d:<[inventory]> o:<item[red_wool].with[quantity=<[max_stack]./[2]>;display_name=<&c>Sell<&sp><[max_stack]./[2]>;nbt=sell/<[max_stack]./[2]>|price/<[this_sell_price]>;lore=<&a>Price<&co><&sp><&e><[this_sell_price]>]>
      - define slot <script[market_system_category_GUI].data_key[custom_slots_map.buy.half_stack]>
      - inventory set slot:<[slot]> d:<[inventory]> o:<item[green_wool].with[quantity=<[max_stack]./[2]>;display_name=<&c>Buy<&sp><[max_stack]./[2]>;nbt=buy/<[max_stack]./[2]>|price/<[this_buy_price]>;lore=<&c>Price<&co><&sp><&e><[this_buy_price]>]>
    # ONLY ONE
    - define slot <script[market_system_category_GUI].data_key[custom_slots_map.sell.one]>
    - inventory set slot:<[slot]> d:<[inventory]> o:<item[red_wool].with[display_name=<&c>Sell<&sp>1;nbt=sell/1|price/<[sell_price]>;lore=<&a>Price<&co><&sp><&e><[sell_price]>]>
    - define slot <script[market_system_category_GUI].data_key[custom_slots_map.buy.one]>
    - inventory set slot:<[slot]> d:<[inventory]> o:<item[green_wool].with[display_name=<&c>Buy<&sp>1;nbt=buy/1|price/<[buy_price]>;lore=<&a>Price<&co><&sp><&e><[buy_price]>]>
      
market_system_category_set_market_next_page:
  type: task
  debug: false
  script:
    - if <yaml[market].list_keys[categories.<[category]>].size> > <script[market_system_category_GUI].data_key[custom_slots_map.market_items].as_list.size>:
      - inventory set slot:<script[market_system_category_GUI].data_key[custom_slots_map.next_page]> d:<[inventory]> o:<item[market_system_category_next_page_button].with[nbt=action/next_page]>
    - else if <[inventory].slot[<script[market_system_category_GUI].data_key[custom_slots_map.next_page]>].script.name||null> == market_system_category_next_page_button:
      - inventory set slot:<script[market_system_category_GUI].data_key[custom_slots_map.next_page]> d:<[inventory]> o:<script[market_system_category_GUI].parsed_key[definitions.filler]>

market_system_category_set_market_previous_page:
  type: task
  debug: false
  script:
    - if <[inventory].slot[<script[market_system_category_GUI].data_key[custom_slots_map.hidden_marker]>].nbt[page]> > 1:
      - inventory set slot:<script[market_system_category_GUI].data_key[custom_slots_map.previous_page]> d:<[inventory]> o:<item[market_system_category_previous_page_button].with[nbt=action/previous_page]>
    - else if <[inventory].slot[<script[market_system_category_GUI].data_key[custom_slots_map.previous_page]>].script.name||null> == market_system_category_previous_page_button:
      - inventory set slot:<script[market_system_category_GUI].data_key[custom_slots_map.previous_page]> d:<[inventory]> o:<script[market_system_category_GUI].parsed_key[definitions.filler]>

market_system_category_set_market_items:
  type: task
  debug: false
  script:
    - inventory set slot:<script[market_system_category_GUI].data_key[custom_slots_map.hidden_marker]> d:<[inventory]> o:<script[market_system_category_GUI].parsed_key[definitions.filler].with[nbt=page/<[page]>|category/<[category]>]>
    - foreach <script[market_system_category_GUI].data_key[custom_slots_map.market_items]> as:slot:
      - define items_per_page <script[market_system_category_GUI].data_key[custom_slots_map.market_items].as_list.size>
      - define index_to_pull <[loop_index].+[<[page].-[1].*[<[items_per_page]>]>]>
      - if <yaml[market].list_keys[categories.<[category]>].get[<[index_to_pull]>]||null> == null:
        - foreach stop
      - define item <yaml[market].list_keys[categories.<[category]>].get[<[index_to_pull]>]>
      - define buy_price <yaml[current_market].read[items.<[item]>.value]>
      - define sell_price <[buy_price].*[<script[market_system_data].data_key[settings.sell_buy_difference]>]>
      - define "lore:<&a>Buy Price<&co><&sp><&e><[buy_price]>|<&c>Sell Price<&co><&sp><[sell_price]>"
      - define name <&a><[item].replace[_].with[<&sp>].to_titlecase>
      - inventory set slot:<[slot]> d:<[inventory]> o:<[item].as_item.with[lore=<[lore]>;nbt=market_item/<[item]>;display_name=<[name]>]>

market_system_category_set_player_head:
  type: task
  debug: false
  script:
    - define player_head:<item[player_head].with[display_name=<player.display_name>;lore=<&a>Money<&co><&sp><&e><player.money>;skull_skin=<player.uuid>]>
    - inventory set slot:<script[market_system_category_GUI].data_key[custom_slots_map.player_info]> d:<[inventory]> o:<[player_head]>

###############
## INTERNALS ##
###############

market_system_yaml_builder:
  type: world
  debug: false
  save_market_data:
    - yaml id:current_market savefile:data/current_market.yml
  save_market_data_async:
    - if !<server.has_flag[market_saving]>:
      - flag server market_saving:true duration:1m
      - ~yaml savefile:data/current_market.yml id:current_market
      - flag server market_saving:!
  make_market_data:
    - if <server.has_file[data/current_market.yml]>:
      - yaml load:data/current_market.yml id:current_market
    - else:
      - yaml create id:current_market
    - foreach <script[market_system_data].list_keys[items]> as:item:
      - if <yaml[current_market].data_key[items.<[item]>.value]||null> == null:
        - yaml id:current_market set items.<[item]>.value:<script[market_system_data].data_key[items.<[item]>.minimum_value]>
  build_yaml_data:
    - yaml id:market create
    - foreach <script[market_system_data].list_keys[items]> as:item:
      - define category <script[market_system_data].data_key[items.<[item]>.category]>
      - yaml id:market set categories.<[category]>.<[item]>:true
  events:
    on server start:
      - flag server market_open:true
      - inject locally build_yaml_data
      - inject locally make_market_data
    on server shutdown:
      - inject locally save_market_data
    on delta time hourly:
      - inject locally save_market_data_async
      - inject market_system_changeover

market_system_changeover:
  type: task
  debug: false
  script:
    - inject market_system_shutdown
    - inject market_system_save_async
    - run market_system_open
    - inject market_system_transfer_yaml_hourly

market_system_shutdown:
  type: task
  debug: false
  script:
    - announce "<&c>The Market will be closing for an update in 1 minute."
    - playsound <server.online_players> sound:ENTITY_EXPERIENCE_ORB_PICKUP volume:0.6 pitch:1.8
    - wait 50s
    - announce "<&c>The Market will be closing for an update in 10 seconds."
    - playsound <server.online_players> sound:ENTITY_EXPERIENCE_ORB_PICKUP volume:0.6 pitch:1.6
    - wait 10s
    - announce "<&c>The Market has closed for an update, and will be available in 10 seconds.."
    - playsound <server.online_players> sound:ENTITY_EXPERIENCE_ORB_PICKUP volume:0.6 pitch:1.4
    - flag server market_timer:true duration:10s
    - flag server market_open:false
    - define player_list:<server.players.filter[open_inventory.script.name.starts_with[market_system]]>
    - foreach <[player_list]>:
      - inventory close player:<[value]>
    - narrate "<&c>The Market is updating, and will be available again within a few moments." targets:<[player_list]>
    - playsound <server.online_players> sound:ENTITY_EXPERIENCE_ORB_PICKUP volume:1.0 pitch:1.0

market_system_save_async:
  type: task
  debug: false
  script:
    - if !<server.has_flag[market_saving]>:
      - flag server market_saving:true duration:1m
      - ~yaml savefile:data/current_market.yml id:current_market
      - flag server market_saving:!

market_system_transfer_yaml_hourly:
  type: task
  debug: false
  script:
    - foreach <script[market_system_data].list_keys[items]> as:item:
      - define min_value <script[market_system_data].data_key[items.<[item]>.minimum_value]>
      - yaml id:current_market set items.<[item]>.value:<[min_value].*[<util.random.decimal[1].to[<list[1|1|1|1|1|2|2|2|2|2|3|3|3|4|4|5].random>]>].round_up>

market_system_open:
  type: task
  debug: false
  script:
    - waituntil rate:5t <server.has_flag[market_timer].not>
    - flag server market_open:true
    - announce "<&a>The Market is now open, and has updated prices."
    - playsound <server.online_players> sound:ENTITY_EXPERIENCE_ORB_PICKUP volume:1.0 pitch:1.0
