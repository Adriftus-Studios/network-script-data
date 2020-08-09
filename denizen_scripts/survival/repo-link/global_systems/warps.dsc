##################
## Server Warps ##
##################

server_warps_yaml:
  type: data
  warps:
    spawn:
      location: spawn
      material: grass_block
      lore: <&a>Return To Spawn
      display: <&b>Spawn
    market:
      location: spawn_market
      material: diamond_block
      lore: <&e>Buy and Sell|<&b>Prices Change Hourly
      display: <&a>Marketplace
    grim:
      location: spawn_grim
      material: blaze_powder
      lore: <&d>Make a deal with Grim|<&b>It may cost you dearly...
      display: <&4>Grim
    soul_forge:
      location: spawn_soul_forge
      material: bubble_coral_block
      lore: <&d>Forge souls into your gear|<&b>Soul drop from mobs
      display: <&5>Soul <&5>Forge

##############
## COMMANDS ##
##############

warps_command:
  type: command
  name: warps
  script:
  - inventory open d:warps_GUI_main_menu

warp_command:
  type: command
  name: warp
  tab complete:
    - if <context.args.is_empty>:
      - determine <script[server_warps_yaml].list_keys[warps].include[<yaml[player.<player.uuid>].list_keys[warps.favorite]||<list>>].include[<yaml[warps].list_keys[warps.personal].filter[starts_with[<player.uuid>]].parse[after[~]]>]>
    - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
      - determine <script[server_warps_yaml].list_keys[warps].include[<yaml[player.<player.uuid>].list_keys[warps.favorite]||<list>>].include[<yaml[warps].list_keys[warps.personal].filter[starts_with[<player.uuid>]].parse[after[~]]>].filter[starts_with[<context.args.first>]]>
  script:
    - if <context.args.first||null> == null:
      - inventory open d:warps_GUI_main_menu
    - else if <script[server_warps_yaml].list_keys[warps].contains[<context.args.first>]>:
      - teleport <script[server_warps_yaml].data_key[warps.<context.args.first>.location]>
    - else if <yaml[player.<player.uuid>].read[warps.favorites].contains[<context.args.first>]||false>:
      - teleport <yaml[player.<player.uuid>].read[warps.favorite.<context.args.first>]>
    - else if <yaml[warps].list_keys[warps.personal].filter[starts_with[<player.uuid>]].parse[after[~]].contains[<context.args.first>]>:
      - teleport <yaml[warps].read[warps.personal.<player.uuid>~<context.args.first>.location]>
    - else:
      - narrate "<&c>Unknown Warp."

####################
## MAIN WARPS GUI ##
####################

warps_GUI_main_menu:
  type: inventory
  inventory: chest
  size: 54
  title: <&b>Warps Menu
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    close_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/close]>
    Server_Warps: <item[nether_star].with[display_name=<&b>Server<&sp>Warps;nbt=action/server_warps]>
    Public_Warps: <item[lantern].with[display_name=<&a>Player<&sp>Warps;lore=<&e>Public<&sp>Warp<&sp>Directory|<&b>Vote<&sp>for<&sp>your<&sp>favorites!;nbt=action/player_warps]>
    Manage_My_Warps: <item[gold_block].with[display_name=<&e>Manage<&sp>My<&sp>Warps;nbt=action/manage_warps]>
    My_Warps: <item[hopper].with[display_name=<&e>My<&sp>Warps;nbt=action/my_warps]>
    Make_New_Warp: <item[green_wool].with[display_name=<&a>Make<&sp>New<&sp>Warp;nbt=action/new_warp]>
    favorite_warps: <item[enchanted_book].with[display_name=<&a>Favorite<&sp>Warps;nbt=action/favorite_warps]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [favorite_warps] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [Server_Warps] [filler] [Public_Warps] [filler] [filler] [filler]
    - [filler] [filler] [Make_New_Warp] [filler] [My_Warps] [filler] [Manage_My_Warps] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [close_button] [filler] [filler] [filler] [filler]

warps_GUI_main_menu_events:
  type: world
  events:
    on player clicks item in warps_GUI_main_menu:
    - determine passively cancelled
    - if <context.item.has_nbt[action]>:
      - choose <context.item.nbt[action]>:
        - case close:
          - inventory close
        - case server_warps:
          - inventory open d:warps_GUI_server_warps_menu
        - case player_warps:
          - inventory open d:warps_GUI_player_warps_menu_top
        - case manage_warps:
          - inject warp_management_GUI_populate
          - inventory open d:<[inventory]>
        - case new_warp:
          - if <player.location.cuboids.filter[notable_name.starts_with[claim.<player.uuid>]].is_empty>:
            - narrate "<&c>You can only create warps in your own claim."
            - stop
          - flag player text_input:create_warp/personal|<player.location>
          - narrate "<&a>Enter a name for your <&b>Warp<&a>."
          - inventory close
        - case my_warps:
          - inject warps_my_warps_GUI_open
        - case favorite_warps:
          - inject favorite_warps_open


#######################
## MY WARPS GUI MENU ##
#######################
warps_my_warps_GUI:
  type: inventory
  inventory: chest
  size: 54
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [] [filler] [] [filler] [] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

warps_my_warps_GUI_open:
  type: task
  script:
  - define inventory <inventory[warps_my_warps_GUI]>
  - define type personal
  - foreach <yaml[warps].list_keys[warps.personal].filter[starts_with[<player.uuid>]].include[<yaml[player.<player.uuid].read[warps.has_access]>]||<list>>]> as:identifier:
    - inject build_warp_item
    - if <[identifier].before[~]> == <player.uuid>:
      - define list:|:<[item].with[nbt=action/warp].with[lore=<[item].lore.insert[<&e>ID<&co><&sp><&b><[identifier].after[~]>].at[1]>]>
    - else:
      - define list:|:<[item].with[nbt=action/warp]>
  - if <[list].is_empty.not>:
    - give <[list]> to:<[inventory]>
  - inventory open d:<[inventory]>

warps_my_warps_GUI_events:
  type: world
  events:
    on player clicks item in warps_my_warps_GUI:
    - determine passively cancelled
    - if <context.item.has_nbt[action]>:
      - choose <context.item.nbt[action]>:
        - case warp:
          - teleport <yaml[warps].read[warps.personal.<context.item.nbt[warp]>.location].as_location>
        - case back:
          - inventory open d:warps_GUI_main_menu

##################
## SERVER WARPS ##
##################

warps_GUI_server_warps_menu:
  type: inventory
  inventory: chest
  title: <&b>Server Warps
  size: 45
  procedural items:
    - foreach <script[server_warps_yaml].list_keys[warps]> as:ID:
      - define list:|:<item[<script[server_warps_yaml].data_key[warps.<[ID]>.material]>].with[display_name=<script[server_warps_yaml].parsed_key[warps.<[ID]>.display]>;lore=<script[server_warps_yaml].parsed_key[warps.<[ID]>.lore]>;nbt=action/warp|location/<script[server_warps_yaml].data_key[warps.<[ID]>.location]>]>
    - determine <[list]>
  definitions:
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    next_page: <item[arrow].with[display_name=<&e>Next<&sp>Page;nbt=action/next_page]>
    previous_page: <item[white_stained_glass_pane].with[display_name=<&a>;nbt=action/next_page]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

warps_GUI_server_warps_menu_events:
  type: world
  events:
    on player clicks item in warps_GUI_server_warps_menu:
    - determine passively cancelled
    - if <context.item.has_nbt[action]>:
      - choose <context.item.nbt[action]>:
        - case back:
          - inventory open d:warps_GUI_main_menu
        - case warp:
          - teleport <player> <context.item.nbt[location]>
          - inventory close

####################
## FAVORITE WARPS ##
####################

favorite_warps:
  type: inventory
  inventory: chest
  size: 54
  definitions:
    filler: white_stained_glass_pane[display_name=<&a>]
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
  slots:
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
  - [filler] [] [] [] [] [] [] [] [filler]
  - [filler] [] [] [] [] [] [] [] [filler]
  - [filler] [] [] [] [] [] [] [] [filler]
  - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
  - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

favorite_warps_open:
  type: task
  script:
  - foreach <yaml[player.<player.uuid>].list_keys[warps.favorites]||<list>>:
    - define identifier <yaml[player.<player.uuid>].read[warps.favorites.<[value]>]>
    - define type personal
    - inject build_warp_item
    - define "list:|:<[item].with[display_name=<&e><[value]>;nbt=name/<[value]>;lore=<[item].lore.remove[first].include[<&e>----------------|<&a>Left Click to Warp.|<&c>Right Click to Remove]>]>"
  - define inventory <inventory[favorite_warps]>
  - if <[list].is_empty.not>
    - give <[list]> to:<[inventory]>
  - inventory open d:<[inventory]>

favorite_warps_events:
  type: world
  events:
    on player clicks item in favorite_warps:
    - determine passively cancelled
    - wait 1t
    - if <context.item.has_nbt[warp]>:
      - choose <context.click>:
        - case RIGHT:
          - define ID <context.item.nbt[warp]>
          - define name <context.item.nbt[name]>
          - define inventory <context.inventory.script.name>
          - inject warps_handle_favorite
        - case LEFT:
          - teleport <yaml[warps].read[warps.personal.<context.item.nbt[warp]>.location]>
    - if <context.item.has_nbt[action]>:
      - inventory open d:warps_GUI_main_menu

##################
## PLAYER WARPS ##
##################

# ITEMS
warps_GUI_player_warps_menu_next_page_item:
  type: procedure
  definitions: page
  script:
    - define page <[page]||1>
    - if <server.flag[warp_votes].as_map.size||0> > <[page].-[1].*[21].+[9]>:
      - determine <item[arrow].with[display_name=<&e>Next<&sp>Page;nbt=action/next_page]>
    - else:
      - determine <script[warps_GUI_player_warps_menu_top].parsed_key[definitions.filler]>

warps_GUI_player_warps_menu_top:
  type: inventory
  inventory: chest
  size: 54
  title: <&b>Warps Menu
  custom_mapped_keys:
    next_page: 45
    previous_page: 37
    page_marker: 5
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
    next_page: <proc[warps_GUI_player_warps_menu_next_page_item].context[1]>
    page_marker: <item[white_stained_glass_pane].with[display_name=<&a>;nbt=page/1]>
  procedural items:
    - define type personal
    - foreach <server.flag[warp_votes].as_map.to_list.sort_by_number[after[/]].reverse.first.to[9].parse[before[/]]> as:identifier:
      - inject build_warp_item
      - define "list:|:<[item].with[nbt=action/warp;lore=<[item].lore.include[<&e>--------------------|<&b>Shift Left Click<&sp>To<&sp>Toggle<&sp>Vote!|<&a>Shift Right Click<&sp>To<&sp>Favorite]>]>"
    - determine <[list]>
  slots:
    - [filler] [filler] [filler] [filler] [page_marker] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [] [] [] [filler] [filler] [filler]
    - [filler] [filler] [] [] [] [] [] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [next_page]
    - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

warps_GUI_player_warps_menu_pages:
  type: inventory
  inventory: chest
  size: 54
  title: <&b>Warps Menu
  custom_mapped_keys:
    next_page: 45
    previous_page: 37
    page_marker: 5
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
    next_page: <proc[warps_GUI_player_warps_menu_next_page_item]>
    previous_page: <item[arrow].with[display_name=<&e>Previous<&sp>Page;nbt=action/previous_page]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [previous_page] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

warps_GUI_player_warps_menu_pages_events:
  type: world
  events:
    on player clicks item in warps_GUI_player_warps_menu_pages|warps_GUI_player_warps_menu_top:
    - determine passively cancelled
    - if <context.item.has_nbt[action]>:
      - choose <context.item.nbt[action]>:
        - case back:
          - inventory open d:warps_GUI_main_menu
        - case warp:
          - choose <context.click>:
            - case SHIFT_LEFT:
              - inject warps_handle_vote
            - case SHIFT_RIGHT:
              - inject warps_favorite
            - default:
              - teleport <yaml[warps].read[warps.personal.<context.item.nbt[warp]>.location].as_location>
        - case next_page:
          - inject Warps_GUI_player_warps_menu_next_page
        - case previous_page:
          - inject Warps_GUI_player_warps_menu_previous_page

Warps_GUI_player_warps_menu_next_page:
  type: task
  script:
    - define page <context.inventory.slot[5].nbt[page].+[1]>
    - define inventory <inventory[warps_GUI_player_warps_menu_pages]>
    - inventory set d:<[inventory]> slot:5 o:<item[white_stained_glass_pane].with[display_name=<&a>;nbt=page/<[page]>]>
    - inject warps_GUI_player_warps_menu_pages_populate
    - inventory open d:<[inventory]>

Warps_GUI_player_warps_menu_previous_page:
  type: task
  script:
    - define page <context.inventory.slot[5].nbt[page].-[1]>
    - if <[page]> == 1:
      - inventory open d:warps_GUI_player_warps_menu_top
      - stop
    - define inventory <inventory[warps_GUI_player_warps_menu_pages]>
    - inventory set d:<[inventory]> slot:5 o:<item[white_stained_glass_pane].with[display_name=<&a>;nbt=page/<[page]>]>
    - inject warps_GUI_player_warps_menu_pages_populate
    - inventory open d:<[inventory]>

warps_GUI_player_warps_menu_pages_populate:
  type: task
  definitions: page
  script:
    - define min <[page].-[2].*[21].+[9]>
    - define max <[min].+[21]>
    - define type personal
    - foreach <server.flag[warp_votes].as_map.to_list.sort_by_number[after[/]].reverse.get[<[min]>].to[<[max]>].parse[before[/]]> as:identifier:
      - inject build_warp_item
      - define "list:<[item].with[nbt=action/warp;lore=<[item].lore.include[<&b>Shift Left Click<&sp>To<&sp>Toggle<&sp>Vote!|<&a>Shift Right Click<&sp>To<&sp>Favorite]>]>"
    - give <[list]> to:<[inventory]>

warps_menu_add_vote:
  type: task
  script:
    - if <yaml[warps].read[personal.<[ID]>.voters].contains[<player>]>:
      - narrate "<&c>You've already voted for this warp."
      - stop
    - yaml id:warps set warps.personal.<[ID]>.voters:|:<player>
    - yaml id:warps set warps.personal.<[ID]>.votes:+:1

warps_menu_remove_vote:
  type: task
  script:
    - if !<yaml[warps].read[personal.<[ID]>.voters].contains[<player>]>:
      - narrate "<&c>You have not voted for this warp."
      - stop
    - yaml id:warps set warps.personal.<[ID]>.voters:<-:<player>
    - yaml id:warps set warps.personal.<[ID]>.votes:-:1



#####################
## WARP MANAGEMENT ##
#####################

warp_management_GUI:
  type: inventory
  inventory: chest
  size: 45
  title: <&b>Warp Management
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

warp_management_GUI_populate:
  type: task
  script:
    - define inventory <inventory[warp_management_GUI]>
    - foreach <yaml[warps].list_keys[warps.personal].filter[starts_with[<player.uuid>]]> as:ID:
      - define material <yaml[warps].read[warps.personal.<[ID]>.material]>
      - define name <yaml[warps].read[warps.personal.<[ID]>.display_name]>
      - define lore:!|:<&e>ID<&co><&sp><[ID].after[~]>
      - define lore:|:<yaml[warps].read[warps.personal.<[ID]>.lore]>
      - if <[lore].separated_by[|]||null> != null:
        - define list:|:<[material].as_item.with[display_name=<[name]>;lore=<[lore]>|;nbt=id/<[ID]>|action/manage_warp]>
    - if <[list]||null> != null:
      - give <[list]> to:<[inventory]>

warp_management_events:
  type: world
  events:
    on player clicks item in warp_management_GUI:
      - determine passively cancelled
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case back:
            - inventory open d:warps_GUI_main_menu
          - case manage_warp:
            - define inventory <inventory[warp_management_GUI_panel]>
            - inject warp_management_GUI_panel_populate
            - inventory open d:<[inventory]>

###########################
## WARP MANAGEMENT PANEL ##
###########################

warp_management_GUI_panel:
  type: inventory
  inventory: chest
  size: 54
  title: <&b>Warp Management
  selectable_materials:
    - dirt
    - grass_block
    - ender_chest
    - chest
    - nether_star
    - redstone
    - redstone_block
    - tnt
    - chorus_flower
    - diamond_block
    - gold_block
    - iron_block
    - diamond_sword
    - bow
    - magma_block
    - diamond_hoe
    - ender_eye
    - ender_pearl
    - dragon_head
  custom_slots_map:
    window: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
    add_member: 37
    remove_member: 46
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    back_button: <item[barrier].with[display_name=<&c>Close<&sp>GUI;nbt=action/back]>
    add_member: <item[green_wool].with[display_name=<&a>Add<&sp>Member;nbt=action/add_member]>
    remove_member: <item[red_wool].with[display_name=<&c>Remove<&sp>Member;nbt=action/remove_member]>
    choose_material: <item[dirt].with[display_name=<&b>Choose<&sp>Material;nbt=action/choose_material]>
    display_name: <item[sign].with[display_name=<&b>Set<&sp>Display<&sp>Name;nbt=action/display_name]>
    set_lore: <item[redstone_torch].with[display_name=<&b>Set<&sp>Lore;nbt=action/set_lore]>
    current_window_marker: <item[white_stained_glass_pane].with[display_name=<&e>;nbt=current_window/members]>
    delete_warp: <item[redstone_block].with[display_name=<&c>Delete<&sp>Warp;nbt=action/delete_warp]>
  slots:
    - [current_window_marker] [filler] [filler] [filler] [] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [add_member] [filler] [choose_material] [filler] [display_name] [filler] [set_lore] [filler] [filler]
    - [remove_member] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [delete_warp]


warp_management_GUI_panel_populate:
  type: task
  script:
    - define inventory <inventory[warp_management_GUI_panel]>
    - define type personal
    - define identifier <context.item.nbt[id]||<[ID]>>
    - inject build_warp_item
    - inventory set slot:5 d:<[inventory]> o:<[item].with[nbt=warp_id/<[identifier]>]>
    - if <yaml[warps].read[warps.personal.<[identifier]>.can_use.everyone]>:
      - define lore <&e>Access<&co><&sp><&a>True
    - else:
      - define lore <&e>Access<&co><&sp><&c>False
    - define lore:!|:<&e>Click<&sp>to<&sp>toggle
    - define list:|:<item[player_head].with[display_name=<&a>Everyone;lore=<[lore]>;skull_skin=0qt;nbt=owner/everyone|action/toggle_everyone]>
    - foreach <yaml[warps].list_keys[warps.personal.<[identifier]>.can_use].exclude[everyone|<player.uuid>]> as:target:
      - define list:|:<item[player_head].with[display_name=<&a><[target].as_player.name>;skull_skin=<[target].as_player.name>;nbt=owner/<[target]>]>
    - give <[list]> to:<[inventory]>

warp_management_GUI_panel_events:
  type: world
  events:
    on player clicks item in warp_management_GUI_panel:
      - determine passively cancelled
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case back:
            - define inventory <inventory[warp_management_GUI]>
            - inject warp_management_GUI_populate
            - inventory open d:<[inventory]>
          - case add_member:
            - flag player text_input:warps_add_member/<context.inventory.slot[5].nbt[warp_id]>
            - inventory close
          - case remove_member:
            - flag player text_input:warps_remove_member/<context.inventory.slot[5].nbt[warp_id]>
            - inventory close
          - case set_lore:
            - flag player text_input:warps_set_lore/<context.inventory.slot[5].nbt[warp_id]>
            - narrate "<&e>Enter the lore you want, color codes may be used."
            - narrate "<&e>Use <&b>; (semi-colon)<&e> to separate different lines."
            - inventory close
          - case display_name:
            - flag player text_input:warps_set_name/<context.inventory.slot[5].nbt[warp_id]>
            - narrate "<&e>Enter the display name you want, color codes may be used."
            - inventory close
          - case choose_material:
            - if <context.inventory.slot[1].nbt[current_window]> != choose_material:
              - inventory set d:<context.inventory> slot:1 o:<item[white_stained_glass_pane].with[display_name=<&e>;nbt=current_window/choose_material]>
              - define player_head_item <item[player_head].with[display_name=<&e>Custom<&sp>Player<&sp>Head;nbt=action/custom_player_head;hides=all]>
              - define custom_material <item[turtle_egg].with[display_name=<&e>Enter<&sp>Material<&sp>Name;nbt=action/custom_material;hides=all]>
              - define materials:<script[warp_management_GUI_panel].data_key[selectable_materials].parse[as_item.with[nbt=action/set_material;hides=all]].include[<[player_head_item]>|<[custom_material]>]>
              - foreach <script[warp_management_GUI_panel].data_key[custom_slots_map.window]> as:slot:
                - inventory set slot:<[slot]> d:<context.inventory> o:<[materials].get[<[loop_index]>]>
              - foreach <list[37|46]> as:slot:
                - inventory set slot:<[slot]> d:<context.inventory> o:<script[warp_management_GUI_panel].parsed_key[definitions.filler]>
          - case set_material:
            - yaml id:warps set warps.personal.<context.inventory.slot[5].nbt[warp_id]>.material:<context.item.material.name>
            - define ID <context.inventory.slot[5].nbt[warp_id]>
            - define inventory <inventory[warp_management_GUI_panel]>
            - inject warp_management_GUI_panel_populate
            - inventory open d:<[inventory]>
          # - case set_members:
          #   - TODO
          - case delete_warp:
            - define ID <context.inventory.slot[5].nbt[warp_id]>
            - inject remove_warp_personal
            - define inventory <inventory[warp_management_GUI]>
            - inject warp_management_GUI_populate
            - inventory open d:<[inventory]>
          - case toggle_everyone:
            - define ID <context.inventory.slot[5].nbt[warp_id]>
            - if <yaml[warps].read[warps.personal.<context.inventory.slot[5].nbt[warp_id]>.can_use.everyone]>:
              - yaml id:warps set warps.personal.<context.inventory.slot[5].nbt[warp_id]>.can_use.everyone:false
              - inventory set slot:<context.slot> d:<context.inventory> o:<item[player_head].with[display_name=<&a>Everyone;lore=<&e>Access<&co><&sp><&c>False|<&e>Click<&sp>to<&sp>toggle;skull_skin=0qt;nbt=owner/everyone|action/toggle_everyone]>
              - inject warp_everyone_remove
            - else:
              - yaml id:warps set warps.personal.<context.inventory.slot[5].nbt[warp_id]>.can_use.everyone:true
              - inventory set slot:<context.slot> d:<context.inventory> o:<item[player_head].with[display_name=<&a>Everyone;lore=<&e>Access<&co><&sp><&a>True|<&e>Click<&sp>to<&sp>toggle;skull_skin=0qt;nbt=owner/everyone|action/toggle_everyone]>
              - inject warp_everyone_add
          - case custom_material:
            - flag player text_input:warps_set_material/<context.inventory.slot[5].nbt[warp_id]>
            - narrate "<&e>Enter the material you want."
            - narrate "<&e>Full list can be found here<&co> https://hub.spigotmc.org/javadocs/spigot/org/bukkit/Material.html"
            - inventory close
          - case custom_player_head:
            - flag player text_input:warps_set_player_head/<context.inventory.slot[5].nbt[warp_id]>
            - narrate "<&e>Enter the player name you want to use."
            - inventory close
          - default:
            - narrate "<&c>NOT YET IMPLEMENTED"

########################
## INTERNAL FUNCTIONS ##
########################

warps_favorite:
  type: task
  script:
    - if <player.uuid> == <context.item.nbt[warp].before[~]>:
      - narrate "<&c>You can't favorite your own warp"
      - stop
    - narrate "<&a>Enter the name for this favorite."
    - flag player text_input:warps_handle_favorite/<context.item.nbt[warp]>|<context.inventory>
    - inventory close

warps_handle_vote:
  type: task
  script:
    - define ID <context.item.nbt[warp]>
    - if <player.uuid> == <[ID].before[~]>:
      - narrate "<&c>You can't vote on your own warp!"
      - stop
    - if <yaml[warps].read[warps.personal.<[ID]>.voters].contains[<player.uuid>]>:
      - yaml id:warps set warps.personal.<[ID]>.voters:<-:<player.uuid>
      - yaml id:warps set warps.personal.<[ID]>.votes:--
      - narrate "<&e>You have rescinded your vote."
    - else:
      - yaml id:warps set warps.personal.<[ID]>.voters:|:<player.uuid>
      - yaml id:warps set warps.personal.<[ID]>.votes:++
      - narrate "<&e>You have voted for this warp!"
    - flag server warp_votes:<server.flag[warp_votes].as_map.with[<[ID]>].as[<yaml[warps].read[warps.personal.<[ID]>.votes]>]>
    - define identifier <context.item.nbt[warp]>
    - define type personal
    - inject build_warp_item
    - inventory set slot:<context.slot> d:<context.inventory> "o:<[item].with[nbt=action/warp;lore=<[item].lore.include[<&b>Shift-Click<&sp>To<&sp>Toggle<&sp>Vote!|<&a>Shift Right Click<&sp>To<&sp>Favorite]>]>]>"



warps_handle_favorite:
  type: task
  definitions: name|ID|inventory
  script:
    - if <player.uuid> == <[ID].before[~]>:
      - narrate "<&c>You can't favorite your own warp"
      - stop
    - if <yaml[player.<player.uuid>].read[warps.favorites].contains[<[name]>]||false>:
      - yaml id:player.<player.uuid> set warps.favorites.<[name]>:!
      - narrate "<&e>You have un-favorited the warp as<&co> <&b><[name]>"
    - else:
      - yaml id:player.<player.uuid> set warps.favorites.<[name]>:<[ID]>
      - narrate "<&e>You have favorited the warp as<&co> <&b><[name]>"
    - inject text_input_complete
    - inventory open d:<[inventory]>

warps_add_member:
  type: task
  definitions: player|ID
  script:
    - define target <server.match_player[<[player]>]||null>
    - if <[target]> == null:
      - narrate "<&c>Unknown Player<&co> <&e><[player]><&c>."
      - stop
    - if <yaml[warps].contains[warps.personal.<[ID]>.can_use.<[target].uuid>]>:
      - narrate "<&c>Player already has access to this warp."
      - inject text_input_complete
      - inject warp_management_GUI_panel_populate
      - inventory open d:<[inventory]>
      - stop
    - yaml set id:warps warps.personal.<[ID]>.can_use.<[target].uuid>:true
    - yaml set id:player.<player.uuid> warps.has_access:|:<[ID]>
    - narrate "<&a><[target].name> <&e>now has access to your <&b><[ID].after[~]><&e> warp."
    - inject text_input_complete
    - inject warp_management_GUI_panel_populate
    - inventory open d:<[inventory]>

warps_remove_member:
  type: task
  definitions: player|ID
  script:
    - define target <server.match_player[<[player]>]||null>
    - if <[target]> == null:
      - narrate "<&c>Unknown Player<&co> <&e><[player]><&c>."
      - stop
    - if <yaml[warps].read[warps.personal.<[ID]>.can_use.<[target].uuid>]||null> == null:
      - narrate "<&c>Player <&e><[target].name><&c> does not have access to your warp<&co> <&b><[ID].after[~]><&c>."
      - stop
    - yaml set id:warps warps.personal.<[ID]>.can_use.<[target].uuid>:!
    - yaml set id:player.<player.uuid> warps.has_access:<-:<[ID]>
    - narrate "<&a><[target].name> <&e>no longer has access to your <&b><[ID].after[~]><&e> warp."
    - inject text_input_complete
    - inject warp_management_GUI_panel_populate
    - inventory open d:<[inventory]>

warps_set_lore:
  type: task
  definitions: lore|ID
  script:
    - if !<[lore].matches_character_set[1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>;&!<&sq><&dq>]>:
      - narrate "<&c>Invalid characters were specified, only numbers, letters, and color codes may be used."
      - stop
    - yaml set id:warps warps.personal.<[ID]>.lore:!|:<[lore].parse_color.split[;]>
    - inject text_input_complete
    - inject warp_management_GUI_panel_populate
    - inventory open d:<[inventory]>

warps_set_name:
  type: task
  definitions: name|ID
  script:
    - if !<[name].matches_character_set[&1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp><&sq>!]>:
      - narrate "<&c>Invalid characters were specified, only numbers, letters, and color codes may be used."
      - stop
    - yaml set id:warps warps.personal.<[ID]>.display_name:<[name].parse_color>
    - inject text_input_complete
    - inject warp_management_GUI_panel_populate
    - inventory open d:<[inventory]>

warps_set_material:
  type: task
  definitions: material_name|ID
  script:
    - if !<[material_name].matches_character_set[&1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>_<&sq>!]>:
      - narrate "<&c>Invalid characters were specified, only numbers, letters, and color codes may be used."
      - stop
    - if <material[<[material_name]>]||null> == null:
      - narrate "<&c>Unknown Material<&co><&sp><[material_name]>"
      - stop
    - yaml set id:warps warps.personal.<[ID]>.material:<[material_name]>
    - inject text_input_complete
    - inject warp_management_GUI_panel_populate
    - inventory open d:<[inventory]>

warps_set_player_head:
  type: task
  definitions: name|ID
  script:
    - if !<[name].matches_character_set[&1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>_<&sq>!]>:
      - narrate "<&c>Invalid characters were specified, only numbers, letters, and color codes may be used."
      - stop
    - yaml set id:warps warps.personal.<[ID]>.material:<item[player_head].with[skull_skin=<[name]>]>
    - inject text_input_complete
    - inject warp_management_GUI_panel_populate
    - inventory open d:<[inventory]>

create_warp:
  type: task
  definitions: ID|type|location
  script:
    - define location <[location]||<player.location>>
    - define chunk <[location].chunk>
    - if <[type]> == server:
      - inject create_warp_server
    - else if <[type]> == personal:
      - define group <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null>
      - if <[group]> != null:
        - if <[group].before[~]> != <player.uuid>:
          - narrate "<&c>You cannot create a warp outside of your own claim."
          - inject text_input_complete
          - stop
      - inject create_warp_personal
    - else:
      - error

create_warp_server:
  type: task
  definitions: ID|location
  script:
    - define ID <[ID].replace[<&sp>].with[_]>
    - yaml id:warps set warps.server.<[ID]>.location:<[location]>
    - yaml id:warps set warps.server.<[ID]>.display_name:<[name]>
    - yaml id:warps set warps.server.<[ID]>.material:<item[green_wool]>
    - yaml id:warps set warps.server.<[ID]>.lore:<&a>Blank<&sp>Lore

build_warp_item:
  type: task
  definitions: type|identifier
  script:
    - define display_name <yaml[warps].read[warps.<[type]>.<[identifier]>.display_name]>
    - define lore:!|:<&e>Votes<&co><&sp><&f><yaml[warps].read[warps.<[type]>.<[identifier]>.votes]||0>
    - define lore:|:<yaml[warps].read[warps.<[type]>.<[identifier]>.lore]>
    - define item <yaml[warps].read[warps.<[type]>.<[identifier]>.material].as_item.with[display_name=<[display_name]>;hides=all;lore=<[lore]>;nbt=warp/<[identifier]>]>

create_warp_personal:
  type: task
  definitions: ID|location
  script:
    - define chunk <[location].chunk>
    - define group <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null>
    - if <[group].before[~]> != <player.uuid>:
      - narrate "<&c>You can only create a warp within your own claim."
      - inject text_input_complete
      - stop
    - if <yaml[warps].list_keys[warps.personal].filter[starts_with[<player.uuid>]].size||0> >= 9:
      - narrate "<&c>You are at your maximum amount of warps."
      - inject text_input_complete
      - stop
    - define ID <[ID].replace[<&sp>].with[_]>
    - yaml id:warps set chunks.<[chunk].world>.<[chunk].x>.<[chunk].z>:|:<player.uuid>~<[ID]>
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.location:<[location]>
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.display_name:<[ID]>
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.material:<item[green_wool]>
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.lore:<&a>Blank<&sp>Lore
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.voters:<player.uuid>
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.votes:0
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.can_use.<player.uuid>:true
    - yaml id:warps set warps.personal.<player.uuid>~<[ID]>.can_use.everyone:false
    - narrate "<&e>You have created a warp!"
    - inject text_input_complete

remove_warp_personal:
  type: task
  definitions: ID
  script:
    - define chunk <yaml[warps].read[warps.personal.<[ID]>.location].as_location.chunk>
    - yaml id:warps set warps.personal.<[ID]>:!
    - yaml id:warps set chunks.<[chunk].world>.<[chunk].x>.<[chunk].z>:<-:<[ID]>

warps_remove_from_chunk:
  type: task
  definitions: chunk
  script:
    - foreach <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||<list>> as:ID:
      - yaml id:warps set warps.personal.<[ID]>:!
    - yaml id:warps set chunks.<[chunk].world>.<[chunk].x>.<[chunk].z>:!

warp_everyone_add:
  type: task
  definitions: ID
  script:
    - define votes <yaml[warps].read[warps.personal.<[ID]>.votes]>
    - if <server.has_flag[warp_votes]>:
      - flag server warp_votes:<server.flag[warp_votes].as_map.with[<[ID]>].as[<[votes]>]>
    - else:
      - flag server warp_votes:<map[<[ID]>/<[votes]>]>
      

warp_everyone_remove:
  type: task
  definitions: ID
  script:
    - if <server.flag[warp_votes].as_map.size||0> <= 1:
      - flag server warp_votes:!
    - else:
      - flag server warp_votes:<server.flag[warp_votes].as_map.exclude[<[ID]>]>

warp_data_manager:
  type: world
  debug: false
  load_data:
    - if <server.has_file[data/warps.yml]>:
      - yaml load:data/warps.yml id:warps
    - else:
      - yaml create id:warps
  events:
    on server start:
      - inject locally load_data
    on delta time minutely every:5:
      - flag server saving_warps:true
      - ~yaml savefile:data/warps.yml id:warps
      - flag server saving_warps:!
