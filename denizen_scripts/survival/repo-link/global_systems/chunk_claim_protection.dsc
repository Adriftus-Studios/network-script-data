claim_system_yaml_settings:
  type: yaml data
  settings:
    allowed_worlds: mainland

##################################
## YAML DATA FOR UPGRADE PRICES ##
##################################
claiming_system_upgrade_data:
  type: yaml data
  debug: false
  upgrades:
    fly:
      cost: 100000
      material: feather
      CMD: 1
    auto-plant:
      cost: 10000
      material: wheat
      CMD: 1
    disable-mob-spawn:
      cost: 25000
      material: zombie_head
      CMD: 1
    keep-inventory:
      cost: 50000
      material: chest
      CMD: 1
    time-control:
      cost: 10000
      material: clock
      CMD: 1
    weather-control:
      cost: 10000
      material: yellow_dye
      CMD: 1
    create_fog:
      cost: 10000
      material: white_dye
      CMD: 1
    darken_sky:
      cost: 10000
      material: black_dye
      CMD: 1
    claim_limit:
      cost: 25000
      material: gold_block
      CMD: 1

#######################################
## Commands for player usage go here ##
#######################################

claiming_help:
  type: command
  name: claimhelp
  permission: not.a.perm
  script:
    - narrate "<&a>----------------------------------"
    - narrate "<&a>Use <&b>/claims <&a>for the claims GUI"
    - narrate "<&e>You can also claim directly to a group using <&b>/claim (groupID)<&e>."
    - narrate "<&a>----------------------------------"

claiming_GUI_command:
  type: command
  name: claims
  debug: false
  description: GUI for controlling your claims, and claim groups.
  usage: /claims
  script:
    - inventory open d:claiming_inventory

claiming_command:
  type: command
  name: claim
  debug: false
  description: Claim the chunk you're currently standing in, to the group specified.
  usage: /claim (GroupID)
  tab complete:
    - if <context.args.get[1]||null> == null:
      - determine <yaml[claims].list_keys[groups].filter[starts_with[<player.uuid>]].parse[after[~].before[/]].parse[replace[_].with[<&sp>]]>
    - else if <context.args.get[1]||null> != null && <context.args.get[2]||null> == null:
      - determine <yaml[claims].list_keys[groups].filter[starts_with[<player.uuid>]].parse[after[~].before[/]].filter[starts_with[<context.args.get[1]>]].parse[replace[_].with[<&sp>]]>
    - determine <list>
  script:
    - if <context.args.get[1]||null> == null:
      - narrate "<&c>You must specify a group to claim this to."
      - narrate "<&c><script[claiming_command].yaml_key[usage]>"
      - stop
    - if !<context.raw_args.matches_character_set[1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>]>:
      - narrate "<&c>Claim names can only have letters, numbers, and spaces"
      - stop
    - run claiming_protection_claim def:<context.raw_args.replace[<&sp>].with[_]>|<player.location>

claiming_command_chunk_map:
  type: command
  name: claimmap
  script:
    - if !<script[claim_system_yaml_settings].yaml_key[settings.allowed_worlds].contains[<player.location.world.name>]>:
      - narrate "<&c>Claims are not allowed in this world."
      - stop
    - foreach <proc[claim_system_build_chunkmap].context[<player.location.chunk>|true]>:
      - narrate "<[value]>"
    - narrate "<&e>Click a chunk to be guided to it."

claiming_command_guide_to_chunk:
  type: command
  name: chunkguide
  script:
    - run claim_system_guide_to_chunk_main def:<chunk[<context.args.get[1]>,<context.args.get[2]>,<player.location.world>]>

#########################
## GLOBALLY USED ITEMS ##
#########################

claiming_back_button:
  type: item
  debug: false
  material: barrier
  display name: <&c>Back
  lore:
    - "<&e>Go back to the previous menu"
  mechanisms:
    nbt: action/back

player_info_head:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: <player.name>

##########################
## This is the main GUI ##
##########################

# ITEMS FOR THE MAIN GUI

# TODO Make icon for when chunks is not claimed
claiming_claim_button:
  type: procedure
  debug: false
  script:
    - define chunk <player.location.chunk>
    - if !<script[claim_system_yaml_settings].yaml_key[settings.allowed_worlds].contains[<player.location.world.name>]>:
        - determine <item[claiming_action_unavailable]>
    - if <yaml[claims].read[limits.current.<player.uuid>]||0> >= <yaml[claims].read[limits.max.<player.uuid>]||30>:
        - determine <item[claiming_action_unavailable_limit]>
    - if <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null> != null:
      - if <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>].before[~]> == <player.uuid>:
        - determine <item[claiming_unclaim_this_chunk_button].with[nbt=action/unclaim_chunk]>
      - else:
        - determine <item[claiming_action_unavailable]>
    - else:
      - determine <item[claiming_claim_this_chunk_button].with[nbt=action/claim_chunk]>

claiming_claim_this_chunk_button:
  type: item
  debug: false
  material: green_banner
  display name: <&a>Claim This Chunk.
  lore:
    - "<&a>Claim Limit<&co> <yaml[claims].read[limits.current.<player.uuid>]||0>/<yaml[claims].read[limits.max.<player.uuid>]||30>"
    - "<&a>"
    - "<&c>ATTENTION"
    - "<&e>This will require text input"
    - "<&e>Enter the group in chat"
    - "<&a>"
    - "<&b>You may claim multiple chunks"
    - "<&b>to the same group"
    - "<&a>"
    - "<&a>Relevent Command<&co><&sp><&e>/claim (groupID)"

claiming_unclaim_this_chunk_button:
  type: item
  debug: false
  material: red_wool
  display name: <&c>Unclaim This Chunk.
  lore:
    - "<&e>Unclaim this chunk"
    - "<&c>You must own the chunk."

claiming_action_unavailable:
  type: item
  debug: false
  material: barrier
  display name: <&4>No Action Available
  lore:
    - "<&e>The chunk you are currently in is claimed by another."

claiming_action_unavailable_limit:
  type: item
  debug: false
  material: barrier
  display name: <&4>No Action Available
  lore:
    - "<&e>You are at your max claim limit."

claiming_manage_my_groups_button:
  type: item
  debug: false
  material: player_head
  display name: <&e>Manage Groups.
  lore:
    - "<&e>You can manage your groups here"
  mechanisms:
    skull_skin: toyhouse

claiming_group_upgrades_button:
  type: item
  debug: false
  material: player_head
  display name: <&b>Warp to Claim Upgrades Vendor.
  lore:
    - "<&e>You can buy upgrades for your groups here."
  mechanisms:
    skull_skin: MrCodingMen

# THE GUI INVENTORY

claiming_inventory:
  type: inventory
  inventory: chest
  debug: false
  title: <&a>Claiming GUI
  custom_slots_map:
    claim_map_icon: 12
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    this_player_info: <item[player_info_head]>
    claim_this_chunk: <proc[claiming_claim_button]>
    unclaim_this_chunk: <item[claiming_unclaim_this_chunk_button].with[nbt=action/unclaim_chunk]>
    manage_my_groups: <item[claiming_manage_my_groups_button].with[nbt=action/manage_groups]>
    group_upgrades: <item[claiming_group_upgrades_button].with[nbt=action/group_upgrades]>
  slots:
    - "[filler] [filler] [filler] [filler] [this_player_info] [filler] [filler] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [claim_this_chunk] [filler] [filler] [manage_my_groups] [filler] [filler] [group_upgrades] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"

# GUI INVENTORY EVENTS
claiming_inventory_events:
  type: world
  debug: false
  events:
    on player clicks item in claiming_inventory:
      - determine passively cancelled
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case claim_chunk:
            - inject claiming_multi_chunk_GUI_open
          - case unclaim_chunk:
            - inject claiming_protection_unclaim
          - case manage_groups:
            - inventory open d:claiming_group_selection_inventory
          - case group_upgrades:
            - teleport spawn_market
          - case claim_map:
            - inventory close
            - execute as_player "claimmap"
    on player opens claiming_inventory:
      - if <script[claim_system_yaml_settings].yaml_key[settings.allowed_worlds].contains[<player.location.world.name>]>:
        - define claim_map_icon <item[map].with[flags=HIDE_ALL;display_name=<&b>Claim<&sp>Map;lore=<proc[claim_system_build_chunkmap].context[<player.location.chunk>|false].include[<&a>|<&a>Relevent<&sp>Command<&co><&sp><&e>/ClaimMap]>;nbt=action/claim_map]>
        - inventory set slot:<script[claiming_inventory].yaml_key[custom_slots_map.claim_map_icon]> d:<context.inventory> o:<[claim_map_icon]>

#######################
## MULTI CHUNK CLAIM ##
#######################

claiming_multi_chunk_GUI:
  type: inventory
  inventory: chest
  size: 36
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
  slots:
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [filler] [] [filler] [] [filler] [] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [claiming_back_button] [filler] [filler] [filler] [filler]"

claiming_multi_chunk_GUI_events:
  type: world
  events:
    on player clicks item in claiming_multi_chunk_GUI:
      - determine passively cancelled
      - if <context.item.has_nbt[action]>:
        - if <context.item.nbt[action]> == back:
          - inventory open d:claiming_inventory
          - stop
        - define area <context.item.nbt[action].after[claim]>
        - if <[area]> == 1:
            - flag player text_input:claiming_protection_claim/<player.location> duration:30s
            - inventory close
            - narrate "<&a>Enter the name of the group you want to claim this chunk to."
        - else:
          - flag player text_input:claiming_multiclaim/<player.location>|<[area]>
          - inventory close
          - narrate "<&a>Enter the name of the group you want to claim these chunks to."

          

claiming_multi_chunk_GUI_open:
  type: task
  script:
    - define x <player.location.chunk.x>
    - define z <player.location.chunk.z>
    - define chunk <player.location.chunk>
    - define group <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null>
    - define okay:|:1
    - foreach <list[3|5]> as:claim_size:
      - define count 0
      - define offset -<[claim_size]./[2].round_up>
      - repeat <[claim_size]> as:x_loop:
        - define this_x <[x].+[<[x_loop].+[<[offset]>]>]>
        - repeat <[claim_size]> as:z_loop:
          - define this_z <[z].+[<[z_loop].+[<[offset]>]>]>
          - if <yaml[claims].read[<[chunk].world>.<[this_x]>.<[this_z]>]||null> != null && !<yaml[claims].read[<[chunk].world>.<[this_x]>.<[this_z]>].starts_with[<player.uuid>]||true>:
            - define items:|:<item[red_wool].with[quantity=<[claim_size]>;display_name=<&c>Cannot<&sp>Claim<&sp><[claim_size]>x<[claim_size]>;lore=<&e>Other<&sp>claims<&sp>are<&sp>in<&sp>the<&sp>way.;nbt=order/<[claim_size]>]>
            - foreach next
          - if !<yaml[claims].read[<[chunk].world>.<[this_x]>.<[this_z]>].starts_with[<player.uuid>]||true>:
            - define count:+:1
          - if <yaml[claims].read[limits.current.<player.uuid>].+[<[count]>]||<[count]>> >= <yaml[claims].read[limits.max.<player.uuid>]||30>:
            - define items:|:<item[red_wool].with[quantity=<[claim_size]>;display_name=<&c>Cannot<&sp>Claim<&sp><[claim_size]>x<[claim_size]>;lore=<&e>You<&sp>are<&sp>at<&sp>your<&sp>claim<&sp>limit.;nbt=order/<[claim_size]>]>
            - foreach next
      - define okay:|:<[claim_size]>
    - define items:|:<item[green_wool].with[display_name=<&a>Claim<&sp>This<&sp>Chunk;lore=<&e>Claim<&sp>the<&sp>chunk<&sp>you<&sp>are<&sp>in.;nbt=action/claim1|order/1]>
    - foreach <list[3|5]>:
      - if <[okay].contains[<[value]>]>:
        - define items:|:<item[green_wool].with[quantity=<[value]>;display_name=<&a>Claim<&sp><[value]>;lore=<&e>Claim<&sp>chunks<&sp>in<&sp>a<&sp><[value]>x<[value]><&sp>area.;nbt=action/claim<[value]>|order/<[value]>]>
    - define inventory <inventory[claiming_multi_chunk_GUI]>
    - give <[items].sort_by_number[nbt[order]]> to:<[inventory]>
    - inventory open d:<[inventory]>

###############################
## GUI FOR SELECTING A GROUP ##
###############################

# GUI ITEM TEMPLATES
claiming_group_selection_icon:
  type: item
  debug: false
  material: green_wool

# THE GUI ITSELF

claiming_group_selection_inventory:
  type: inventory
  inventory: chest
  debug: false
  title: <&a>Group Management
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    back_button: <item[claiming_back_button].with[nbt=back/back]>
  slots:
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [] [filler] [] [filler] [] [filler] [] [filler]"
    - "[filler] [] [filler] [] [filler] [] [filler] [] [filler]"
    - "[filler] [] [filler] [] [filler] [] [filler] [] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]"

# THE EVENTS FOR THE GUI

claiming_group_selection_inventory_events:
  type: world
  debug: false
  events:
    on player opens claiming_group_selection_inventory:
      - define groups <yaml[claims].list_keys[groups].filter[starts_with[<player.uuid>]]||>
      - if <[groups].size> >= 1:
        - foreach <[groups]> as:group:
          - define name <[group].after[~]>
          - define members <yaml[claims].list_keys[groups.<[group]>.members].exclude[<player.uuid>|everyone]>
          - if <[members].size> == 0:
            - define lore <&c>No<&sp>Members
          - else:
            - define lore <&c>ID<&co><&sp><&e><[name]>|<&b>Members<&co>|<[members].parse[as_player.name].separated_by[|]>
          - define list:|:<item[claiming_group_selection_icon].with[display_name=<&e><yaml[claims].read[groups.<[group]>.settings.display_name]>;lore=<[lore]>;nbt=group_name/<[name]>]>
        - give <[list]> to:<context.inventory>
    on player clicks item in claiming_group_selection_inventory:
      - determine passively cancelled
      - if <context.item.has_nbt[group_name]>:
        - define group <context.item.nbt[group_name]>
        - define inventory <inventory[claiming_group_management_inventory]>
        - give <proc[claiming_group_management_member_generation].context[<player.uuid>~<context.item.nbt[group_name]>]> to:<[inventory]>
        - inventory open d:<[inventory]>
        - wait 1t
        - run claiming_group_management_permission_generation def:everyone|<player.uuid>~<context.item.nbt[group_name]>
      - if <context.item.has_nbt[back]>:
        - inventory open d:claiming_inventory

##############################
## GUI FOR MANAGING A GROUP ##
##############################

claiming_group_management_everyone_icon:
  type: item
  debug: false
  material: player_head
  display name: <&e>Everyone
  lore:
    - "<&e>These permissions apply to all players, even non members."
  mechanisms:
    skull_skin: 0qt

claiming_group_management_member_generation:
  type: procedure
  debug: false
  definitions: group
  script:
    - define list:|:<item[claiming_group_management_everyone_icon].with[nbt=target/everyone]>
    - foreach <yaml[claims].list_keys[groups.<[group]>.members].exclude[everyone|<player.uuid>]> as:member:
      - define name <[member].as_player.name>
      - define lore <list[<&e>Modify<&sp>permissions<&sp>for<&sp><[name]>]>
      - define list:|:<item[player_head].with[skull_skin=<[member]>;display_name=<[name]>;lore=<[lore]>;nbt=target/<[member]>]>
    - determine <[list]>

# Permission Button Generation
claiming_group_management_permission_icon_enabled:
  type: item
  debug: false
  material: green_wool
  lore:
    - "<&a>Permission is currently enabled"
  mechanisms:
    nbt: status/enabled|action/disable

claiming_group_management_permission_icon_disabled:
  type: item
  debug: false
  material: red_wool
  lore:
    - "<&c>Permission is currently disabled"
  mechanisms:
    nbt: status/disabled|action/enable

claiming_group_management_add_member:
  type: item
  debug: false
  material: player_head
  display name: <&a>Add Member
  mechanisms:
    skull_skin: GoOnReportMe

claiming_group_management_remove_member:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: GoOnReportMe

claiming_group_management_settings:
  type: item
  debug: false
  material: redstone_block
  display name: <&7>Group Settings

claiming_group_management_permission_generation:
  type: task
  debug: false
  definitions: target|groupName
  script:
    # Generate the permission buttons
    - foreach <yaml[claims].list_keys[groups.<[groupName]>.members.everyone].alphabetical> as:permission:
      - if <[permission]> == fly && !<yaml[claims].read[groups.<[groupName]>.upgrades.fly]>:
        - foreach next
        #- define permission_buttons:|:<item[barrier].with[display_name=<&c>Fly<&sp>not<&sp>unlocked]>
      - if <yaml[claims].read[groups.<[groupName]>.members.<[target]>.<[permission]>]||false>:
        - define permission_buttons:|:<item[claiming_group_management_permission_icon_enabled].with[display_name=<&e><[permission].to_titlecase>;nbt=permission/<[permission]>]>
      - else:
        - define permission_buttons:|:<item[claiming_group_management_permission_icon_disabled].with[display_name=<&e><[permission].to_titlecase>;nbt=permission/<[permission]>]>
    - define permission_buttons <[permission_buttons].pad_right[6].with[<item[white_stained_glass_pane].with[display_name=<&a>]>]>
    - foreach <script[claiming_group_management_inventory].yaml_key[permission_button_slots]> as:slot:
      - inventory set d:<player.open_inventory> slot:<[slot]> o:<[permission_buttons].get[<[loop_index]>]>
    - if <[target]> == everyone:
      - inventory set d:<player.open_inventory> slot:<script[claiming_group_management_inventory].yaml_key[permission_head]> o:<item[claiming_group_management_everyone_icon].with[nbt=owner/everyone|group/<[groupName]>]>
    - else:
      - define name <[target].as_player.name>
      - define lore <list[<&e>Modifying<&sp>permissions<&sp>for<&sp><[name]>]>
      - inventory set d:<player.open_inventory> slot:<script[claiming_group_management_inventory].yaml_key[permission_head]> o:<item[player_head].with[skull_skin=<[target]>;display_name=<[name]>;lore=<[lore]>;nbt=owner/<[target]>|group/<[groupName]>]>
    - if <[target]> != everyone:
      - inventory set d:<player.open_inventory> slot:<script[claiming_group_management_inventory].yaml_key[remove_member_button]> o:<item[claiming_group_management_remove_member].with[display_name=<&c>Remove<&sp><[name]><&sp>From<&sp><[groupName].after[~]>.;nbt=action/remove_member]>
    - else:
      - inventory set d:<player.open_inventory> slot:<script[claiming_group_management_inventory].yaml_key[remove_member_button]> o:<script[claiming_group_management_inventory].yaml_key[definitions.filler].parsed>

# The GUI
claiming_group_management_inventory:
  type: inventory
  inventory: chest
  debug: false
  title: <&a>Group Management
  permission_head: 32
  permission_button_slots: 39|40|41|42|43|44
  remove_member_button: 46
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    back_button: <item[claiming_back_button].with[nbt=back/back]>
    add_member: <item[claiming_group_management_add_member].with[nbt=action/add_member]>
    settings: <item[claiming_group_management_settings].with[nbt=action/settings]>
  slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[filler] [filler] [filler] [filler] [] [filler] [filler] [filler] [filler]"
    - "[add_member] [filler] [] [] [] [] [] [] [filler]"
    - "[] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [settings]"

claiming_group_management_inventory_events:
  type: world
  debug: false
  events:
    on player clicks item in claiming_group_management_inventory:
      - determine passively cancelled
      - define group <context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>
      - if <context.item.has_nbt[target]>:
        - run claiming_group_management_permission_generation def:<context.item.nbt[target]>|<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>
      - if <context.item.has_nbt[permission]>:
        - define target <context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[owner]>
        - if <context.item.nbt[action]> == enable:
          - yaml id:claims set groups.<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>.members.<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[owner]>.<context.item.nbt[permission]>:true
          - inventory set d:<player.open_inventory> slot:<context.slot> o:<item[claiming_group_management_permission_icon_enabled].with[display_name=<&e><context.item.nbt[permission].to_titlecase>;nbt=permission/<context.item.nbt[permission]>]>
          - if <context.item.nbt[permission]> == fly:
            - run claim_system_add_fly_target def:<[group]>|<[target]>
        - else:
          - yaml id:claims set groups.<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>.members.<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[owner]>.<context.item.nbt[permission]>:false
          - inventory set d:<player.open_inventory> slot:<context.slot> o:<item[claiming_group_management_permission_icon_disabled].with[display_name=<&e><context.item.nbt[permission].to_titlecase>;nbt=permission/<context.item.nbt[permission]>]>
          - if <context.item.nbt[permission]> == fly:
            - run claim_system_remove_fly_target def:<[group]>|<[target]>
      - if <context.item.has_nbt[back]>:
        - inventory open d:claiming_group_selection_inventory
      - if <context.item.has_nbt[action]>:
        - if <context.item.nbt[action]> == add_member:
          - flag player text_input:claiming_protection_addMember/<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>
          - inventory close
          - narrate "<&a>--------------------------------------------"
          - narrate "<&e>Enter the player's name you want to add to this group"
          - narrate "<&c>Note: this player must be online"
          - narrate "<&a>--------------------------------------------"
        - if <context.item.nbt[action]> == settings:
          - inventory open d:claiming_protection_settings
          - wait 1t
          - inventory set slot:<script[claiming_protection_settings].yaml_key[group_slot]> d:<player.open_inventory> o:<item[white_stained_glass_pane].with[display_name=<&e>;nbt=group/<[group]>]>
          - give <proc[claiming_protection_settings_generate_settings_buttons].context[<[group]>]> to:<player.open_inventory>
        - if <context.item.nbt[action]> == remove_member:
          - run claiming_protection_removeMember def:<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[owner].as_player>|<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>
          - inventory open d:claiming_group_management_inventory
          - wait 1t
          - give <proc[claiming_group_management_member_generation].context[<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>]> to:<player.open_inventory>
          - run claiming_group_management_permission_generation def:everyone|<context.inventory.slot[<script[claiming_group_management_inventory].yaml_key[permission_head]>].nbt[group]>
      
###################
## SETTINGS MENU ##
###################

# GUI ITEMS
claiming_group_management_disband:
  type: item
  debug: false
  material: player_head
  display name: <&c>Disband Group
  lore:
    - "<&e>This will completely delete the group."
    - "<&e>All claims will be removed."
  mechanisms:
    skull_skin: SkidzGaming

claiming_group_management_display_name_icon:
  type: item
  debug: false
  material: green_wool

claiming_group_management_color_icon:
  type: procedure
  debug: false
  script:
    - determine stone
    # TODO ADD WOOL COLOR

claiming_group_management_darken_sky_icon_enabled:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001005

claiming_group_management_darken_sky_icon_disabled:
  type: item
  debug: false
  material: red_wool
  mechanisms:
    custom_model_data: 10001005

claiming_group_management_create_fog_icon_enabled:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001008

claiming_group_management_create_fog_icon_disabled:
  type: item
  debug: false
  material: red_wool
  mechanisms:
    custom_model_data: 10001008

claiming_group_management_auto-plant_icon_enabled:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001002

claiming_group_management_auto-plant_icon_disabled:
  type: item
  debug: false
  material: red_wool
  mechanisms:
    custom_model_data: 10001002

claiming_group_management_disable-mob-spawn_icon_enabled:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001011

claiming_group_management_disable-mob-spawn_icon_disabled:
  type: item
  debug: false
  material: red_wool
  mechanisms:
    custom_model_data: 10001011

claiming_group_management_keep-inventory_icon_enabled:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001019

claiming_group_management_keep-inventory_icon_disabled:
  type: item
  debug: false
  material: red_wool
  mechanisms:
    custom_model_data: 10001014

claiming_group_management_time-control_icon:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001014
  CMD:
    off: 10001014
    morning: 10001014
    noon: 10001014
    evening: 10001014
    sunset: 10001014
    midnight: 10001014
    sunrise: 10001014

claiming_group_management_weather-control_icon:
  type: item
  debug: false
  material: green_wool
  mechanisms:
    custom_model_data: 10001015
  CMD:
    off: 10001015
    sunny: 10001015
    storm: 10001015
    thunder: 10001015

claiming_group_management_fly_icon_enabled:
  type: item
  debug: false
  material: feather
  mechanisms:
    custom_model_data: 10001007

claiming_group_management_fly_icon_disabled:
  type: item
  debug: false
  material: redstone
  mechanisms:
    custom_model_data: 10001007

# THE GUI ITSELF

claiming_protection_settings:
  type: inventory
  inventory: chest
  debug: false
  title: <&e>Claim Upgrades
  group_slot: 5
  setting_show_slot: 32
  setting_optional_buttons_slots: 38|39|40|41|42|43|44
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    delete_group: <item[claiming_group_management_disband].with[nbt=action/disband]>
    back_button: <item[claiming_back_button].with[nbt=action/back]>
  slots:
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [delete_group]"
    - "[filler] [filler] [] [] [] [] [] [filler] [filler]"
    - "[filler] [filler] [] [] [] [] [] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]"
    - "[filler] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]"

# TASKS AND PROCEDURES FOR BUILDING THE DYNAMIC BUTTONS
claiming_protection_settings_generate_settings_buttons:
  type: procedure
  debug: false
  definitions: group
  script:
    - foreach <yaml[claims].list_keys[groups.<[group]>.settings].alphabetical> as:setting:
      - define display <[setting].replace[_].with[<&sp>].replace[-].with[<&sp>].to_titlecase>
      - if !<yaml[claims].read[groups.<[group]>.upgrades.<[setting]>]>:
        - define list:|:<item[barrier].with[display_name=<&c><[display]><&sp>Not<&sp>Unlocked.]>
        - foreach next
      - define setting_value <yaml[claims].read[groups.<[group]>.settings.<[setting]>]>
      - if <[setting]> == display_name:
        - define "lore:<&e><[display]> is currently set to <[setting_value].to_titlecase>"
        - define list:|:<item[claiming_group_management_<[setting]>_icon].with[lore=<[lore]>;display_name=<[display]><&co><&sp><[setting_value].to_titlecase>;nbt=setting/<[setting]>]>
      - else if <[setting]> == color:
        - define "lore:<&e><[display]> is currently set to <[setting_value].to_titlecase>"
        - define list:|:<item[<[setting_value]>_wool].with[lore=<[lore]>;display_name=<[display]><&co><&sp><[setting_value].to_titlecase>;nbt=setting/<[setting]>]>
      - else if <list[weather-control|time-control].contains[<[setting]>]>:
        - define "lore:<&e><[display]> is currently set to <[setting_value].to_titlecase>"
        - define CMD <script[claiming_group_management_<[setting]>_icon].yaml_key[CMD.<[setting_value]>]>
        - define list:|:<item[claiming_group_management_<[setting]>_icon].with[custom_model_data=<[CMD]>;lore=<[lore]>;display_name=<[display]><&co><&sp><[setting_value].to_titlecase>;nbt=setting/<[setting]>]>
      - else:
        - if <[setting_value]>:
          - define "lore:<&a><[display]> is currently enabled"
          - define list:|:<item[claiming_group_management_<[setting]>_icon_enabled].with[display_name=<&a><[display]>;lore=<[lore]>;nbt=setting/<[setting]>|set_to/disabled]>
        - else:
          - define "lore:<&c><[display]> is currently disabled"
          - define list:|:<item[claiming_group_management_<[setting]>_icon_disabled].with[display_name=<&c><[display]>;lore=<[lore]>;nbt=setting/<[setting]>|set_to/enabled]>
    - determine <[list]>

claiming_protection_settings_process_click:
  type: task
  debug: false
  definitions: setting|value
  script:
    - define group <player.open_inventory.slot[<script[claiming_protection_settings].yaml_key[group_slot]>].nbt[group]>
    - if <[value]||null> == null:
      - if <list[weather-control|time-control|color].contains[<[setting]>]>:
        - inject claiming_protection_settings_build_bottom_settings
        - stop
      - else if <[setting]> == display_name:
        - flag player text_input:claiming_protection_settings_change_name/<[group]>
        - narrate "<&e>What you would like to display the group as?"
        - inventory close
      - else if <player.open_inventory.slot[<script[claiming_protection_settings].yaml_key[setting_show_slot]>]].material.name> != white_stained_glass_pane:
        - inject claiming_protection_settings_reset_bottom
    # If Setting a Value
    - else:
      - if <list[weather-control|time-control].contains[<[setting]>]>:
        - yaml id:claims set groups.<[group]>.settings.<[setting]>:<[value]>
      - else if <[setting]> == color:
        - yaml id:claims set groups.<[group]>.settings.color:<[value]>
      - else if <[value]> == disabled:
        - yaml id:claims set groups.<[group]>.settings.<[setting]>:false
      - else:
        - yaml id:claims set groups.<[group]>.settings.<[setting]>:true
      - inject claiming_protection_setting_update_button
        
# Sub Functions of the above task
claiming_protection_setting_update_button:
  type: task
  debug: false
  script:
    - inventory open d:claiming_protection_settings
    - wait 1t
    - inventory set slot:<script[claiming_protection_settings].yaml_key[group_slot]> d:<player.open_inventory> o:<item[white_stained_glass_pane].with[display_name=<&e>;nbt=group/<[group]>]>
    - give <proc[claiming_protection_settings_generate_settings_buttons].context[<[group]>]> to:<player.open_inventory>
    

claiming_protection_settings_reset_bottom:
  type: task
  debug: false
  script:
    - foreach <script[claiming_protection_settings].yaml_key[setting_show_slot].include[<player.open_inventory.slot[<script[claiming_protection_settings].yaml_key[setting_optional_buttons_slots]>]>]> as:slot:
      - inventory set d:<player.open_inventory> slot:<[slot]> o:<script[claiming_protection_settings].yaml_key[definitions.filler]>

claiming_protection_settings_build_bottom_settings:
  type: task
  debug: false
  script:
    - inventory set slot:<script[claiming_protection_settings].yaml_key[setting_show_slot]> d:<player.open_inventory> o:<script[claiming_protection_settings].yaml_key[definitions.filler].parsed.with[nbt=setting/<[setting]>]>
    - if <[setting]> == time-control:
      - define times <list[off|sunrise|morning|noon|evening|sunset|midnight]>
      - foreach <script[claiming_protection_settings].yaml_key[setting_optional_buttons_slots]> as:slot:
        - define CMD <script[claiming_group_management_time-control_icon].yaml_key[CMD.<[times].get[<[loop_index]>]>]>
        - define "display:<&e>Set<&sp>To<&co><&sp><[times].get[<[loop_index]>]>"
        - inventory set slot:<[slot]> d:<player.open_inventory> o:<item[claiming_group_management_time-control_icon].with[custom_model_data=<[CMD]>;display_name=<[display]>;nbt=set_to/<[times].get[<[loop_index]>]>]>
    - else if <[setting]> == weather-control:
      - define weathers <list[off|sunny|storm|thunder]>
      - repeat 7:
        - if <list[1|2|7].contains[<[value]>]>:
          - define list:|:<script[claiming_protection_settings].yaml_key[definitions.filler].parsed>
        - else:
          - define CMD <script[claiming_group_management_weather-control_icon].yaml_key[CMD.<[weathers].get[<[value].-[2]>]>]>
          - define "display:<&e>Set<&sp>To<&co><&sp><[weathers].get[<[value].-[2]>]>"
          - define list:|:<item[claiming_group_management_time-control_icon].with[custom_model_data=<[CMD]>;display_name=<[display]>;nbt=set_to/<[weathers].get[<[value].-[2]>]>]>
      - foreach <script[claiming_protection_settings].yaml_key[setting_optional_buttons_slots]> as:slot:
        - inventory set slot:<[slot]> d:<player.open_inventory> o:<[list].get[<[loop_index]>]>
    - else:
      - define colors <list[BLUE|GREEN|PINK|PURPLE|RED|WHITE|YELLOW]>
      - foreach <script[claiming_protection_settings].yaml_key[setting_optional_buttons_slots]> as:slot:
        - define color <[colors].get[<[loop_index]>]>
        - inventory set slot:<[slot]> d:<player.open_inventory> o:<item[<[color]>_wool].with[display_name=<proc[getColorCode].context[<[color]>]><[color].to_titlecase>;nbt=set_to/<[color]>]>

        

claiming_protection_settings_events:
  type: world
  debug: false
  events:
    on player clicks item in claiming_protection_settings:
      - determine passively cancelled
      - define setting <context.item.nbt[setting]||<context.inventory.slot[<script[claiming_protection_settings].yaml_key[setting_show_slot]>].nbt[setting]||null>>
      - if <context.item.has_nbt[set_to]>:
        - run claiming_protection_settings_process_click def:<[setting]>|<context.item.nbt[set_to]>
      - else if <context.item.has_nbt[setting]>:
        - run claiming_protection_settings_process_click def:<context.item.nbt[setting]>
      - else if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case disband:
            - run claiming_protection_group_disband def:<context.inventory.slot[<script[claiming_protection_settings].yaml_key[group_slot]>].nbt[group]>
            - inventory open d:claiming_group_selection_inventory
          - case back:
            - define group <context.inventory.slot[<script[claiming_protection_settings].yaml_key[group_slot]>].nbt[group]>
            - inventory open d:claiming_group_management_inventory
            - wait 1t
            - give <proc[claiming_group_management_member_generation].context[<[group]>]> to:<player.open_inventory>
            - run claiming_group_management_permission_generation def:everyone|<[group]>
            - wait 1t
            - inject claiming_settings_update
    on player closes claiming_protection_settings:
      - define group <context.inventory.slot[<script[claiming_protection_settings].yaml_key[group_slot]>].nbt[group]>
      - inject claiming_settings_update






#########################################
## BELOW HERE ARE THE SYSTEM INTERNALS ##
#########################################
claiming_multiclaim:
  type: task
  definitions: name|location|area
  script:
    - if !<script[claim_system_yaml_settings].yaml_key[settings.allowed_worlds].contains[<[location].world.name>]>:
      - narrate "<&c>Claims are not allowed in this world"
      - stop
    - if !<[name].matches_character_set[1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>]>:
      - narrate "<&c>Claim names can only have letters, numbers, and spaces"
      - stop
    - define name <[name].replace[<&sp>].with[_]>
    - if <[location]||null> == null:
      - define chunk <player.flag[text_input].after[/].as_location.chunk>
    - else:
      - define chunk <[location].chunk>
    - define group <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null>
    - define offset -<[area]./[2].round_up>
    - define x <[chunk].x>
    - define z <[chunk].z>
    - repeat <[area]> as:x_loop:
      - define this_x <[x].+[<[x_loop].+[<[offset]>]>]>
      - repeat <[area]> as:z_loop:
        - define this_z <[z].+[<[z_loop].+[<[offset]>]>]>
        - if <yaml[claims].read[<[chunk].world>.<[this_x]>.<[this_z]>]||null> != null && !<yaml[claims].read[<[chunk].world>.<[this_x]>.<[this_z]>].starts_with[<player.uuid>]||true>:
          - narrate "<&c>Unable to claim due to other nearby claims."
          - stop
    - if !<yaml[claims].list_keys[groups].contains[<player.uuid>~<[name]>]||false>:
      - inject claiming_initialize_group
    - define claimed 0
    - repeat <[area]> as:x_loop:
      - define this_x <[x].+[<[x_loop].+[<[offset]>]>]>
      - repeat <[area]> as:z_loop:
        - define this_z <[z].+[<[z_loop].+[<[offset]>]>]>
        - define chunk <chunk[<[this_x]>,<[this_z]>,<[chunk].world>]>
        - if <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null> == null:
          - yaml id:claims set <[chunk].world>.<[chunk].x>.<[chunk].z>:<player.uuid>~<[name]>
          - note <[chunk].cuboid> as:claim.<player.uuid>~<[name]>/<[chunk].world>x<[chunk].x>z<[chunk].z>
          - define claimed:+:1
    - yaml id:claims set limits.current.<player.uuid>:+:<[claimed]>
    - narrate "<&7>You have claimed chunks within a <&e><[area]>x<[area]><&7> area."
    - narrate "<&7>You have claimed these chunks to your <&b><[name].replace[_].with[<&sp>]> <&7>group."
    - narrate "<&7>Claim Limit<&co> <&b><yaml[claims].read[limits.current.<player.uuid>]||0><&7>/<&b><yaml[claims].read[limits.max.<player.uuid>]||30>"
    - inject text_input_complete

    
claiming_protection_data_handler:
  type: world
  debug: false
  load_data:
    - if <server.has_file[data/claims.yml]>:
      - yaml load:data/claims.yml id:claims
    - else:
      - yaml create id:claims
  events:
    on server start:
      - inject locally load_data
    on delta time minutely every:5:
      - flag server saving_claims:true
      - ~yaml savefile:data/claims.yml id:claims
      - flag server saving_claims:!

claiming_protection_group_disband:
  type: task
  debug: false
  definitions: group
  script:
    - yaml id:claims set groups.<[group]>:!
    - foreach <server.list_notables[cuboids].filter[notable_name.starts_with[claim.<[group]>]]> as:cuboid:
      - define chunk <[cuboid].as_cuboid.center.chunk>
      - yaml id:claims set <[chunk].world>.<[chunk].x>.<[chunk].z>:!
      - yaml id:claims set limits.current.<player.uuid>:-:1
      - foreach <[cuboid].as_cuboid.players> as:target:
        - inject claiming_system_bossBar_Stop player:<[target]>
      - note remove as:<[cuboid].notable_name>
    - narrate "<&7>Group Disbanded!"
    - narrate "<&7>Claim Limit<&co> <&e><yaml[claims].read[limits.current.<player.uuid>]><&7>/<&e><yaml[claims].read[limits.max.<player.uuid>]||30>"

claiming_protection_claim:
  type: task
  debug: false
  definitions: name|location
  script:
    - if !<script[claim_system_yaml_settings].yaml_key[settings.allowed_worlds].contains[<[location].world.name>]>:
      - narrate "<&c>Claims are not allowed in this world"
      - stop
    - if !<[name].matches_character_set[1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz<&sp>]>:
      - narrate "<&c>Claim names can only have letters, numbers, and spaces"
      - stop
    - define name <[name].replace[<&sp>].with[_]>
    - if <[location]||null> == null:
      - define chunk <player.flag[text_input].after[/].as_location.chunk>
    - else:
      - define chunk <[location].chunk>
    - if <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null> != null:
      - narrate "<&c>This chunk is already claimed."
      - stop
    - if <yaml[claims].read[limits.current.<player.uuid>]||0> >= <yaml[claims].read[limits.max.<player.uuid>]||30>:
      - narrate "<&c>You are at your limit of claimable chunks"
      - stop
    # --- THE GROUP LIMIT IS SET ON THE NEXT LINE ---
    # TODO Make this not hard coded, potentially an upgrade system
    - if <yaml[claims].list_keys[groups].filter[starts_with[<player.uuid>]].size||0> >= 8 && !<yaml[claims].list_keys[groups].contains[<player.uuid>~<[name]>]||true>:
      - narrate "<&c>You cannot make more than 8 different groups at this time."
      - stop
    - yaml id:claims set <[chunk].world>.<[chunk].x>.<[chunk].z>:<player.uuid>~<[name]>
    - note <[chunk].cuboid> as:claim.<player.uuid>~<[name]>/<[chunk].world>x<[chunk].x>z<[chunk].z>
    - yaml id:claims set limits.current.<player.uuid>:+:1
    - if !<yaml[claims].list_keys[groups].contains[<player.uuid>~<[name]>]||false>:
      - inject claiming_initialize_group
    - narrate "<&a>You have claimed this chunk to your <[name].replace[_].with[<&sp>]> group."
    - narrate "<&7>Claim Limit<&co> <&b><yaml[claims].read[limits.current.<player.uuid>]||0><&7>/<&b><yaml[claims].read[limits.max.<player.uuid>]||30>"
    - inject text_input_complete

claiming_initialize_group:
  type: task
  script:
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.place:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.place:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.break:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.interact:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.farm:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.fly:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.<player.uuid>.kill-animals:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.display_name:<[name].replace[_].with[<&sp>]>
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.color:white
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.darken_sky:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.create_fog:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.auto-plant:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.disable-mob-spawn:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.keep-inventory:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.time-control:off
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.weather-control:off
    - yaml id:claims set groups.<player.uuid>~<[name]>.settings.fly:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.everyone.place:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.everyone.break:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.everyone.interact:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.everyone.farm:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.everyone.fly:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.members.everyone.kill-animals:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.display_name:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.color:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.fly:false
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.auto-plant:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.disable-mob-spawn:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.keep-inventory:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.time-control:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.weather-control:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.create_fog:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.upgrades.darken_sky:true
    - yaml id:claims set groups.<player.uuid>~<[name]>.member_limit:10

claiming_protection_unclaim:
  type: task
  debug: false
  definitions: location
  script:
    - define chunk <[location].chunk||<player.location.chunk>>
    - define group <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null>
    - if <[group]> == null:
      - narrate "<&c>This chunk is not claimed."
      - stop
    - if <[group].before[~]> != <player.uuid>:
      - narrate "<&c>You cannot unclaim another player's claim."
      - stop
    - yaml id:claims set <[chunk].world>.<[chunk].x>.<[chunk].z>:!
    - foreach <cuboid[claim.<[group]>/<[chunk].world>x<[chunk].x>z<[chunk].z>].players> as:target:
      - bossbar remove <[target].uuid>.in_claim
    - note remove as:claim.<[group]>/<[chunk].world>x<[chunk].x>z<[chunk].z>
    - if <yaml[warps].read[chunks.<[chunk].world>.<[chunk].x>.<[chunk].z>]||null> != null:
      - inject warps_remove_from_chunk
    - yaml id:claims set limits.current.<player.uuid>:-:1
    - narrate "<&7>You have successfully <&c>unclaimed <&7>this chunk."
    - narrate "<&7>Claim Limit<&co> <&e><yaml[claims].read[limits.current.<player.uuid>]><&7>/<&e><yaml[claims].read[limits.max.<player.uuid>]||30>"
    - foreach <player.location.chunk.cuboid.players> as:target:
      - inject claiming_system_bossBar_Stop player:<[target]>
    - if <player.open_inventory||null> != null:
      - inventory open d:<player.open_inventory.script.name.as_inventory>

claiming_protection_addMember:
  type: task
  debug: false
  definitions: player_in|groupName
  script:
    - if <[groupName]||null> == null:
      - define groupName <player.flag[text_input].after[/]>
    - if <[player_in].type> != Player:
      - define player <server.match_player[<[player_in]>]||null>
    - else:
      - define player <[player_in]>
    - if <[player]> == null:
      - narrate "Unknown Player: <[player_in]>"
      - stop
    - define group_limit <yaml[claims].list_keys[groups.<[groupName]>.member_limit]||22>
    - if <yaml[claims].list_keys[groups.<[groupName]>.members].size||0> >= <[group_limit]>:
      - narrate "<&c>You cannot add any more members to this group."
      - inject text_input_complete
      - stop
    - yaml id:claims set groups.<[groupName]>.members.<[player].uuid>.place:false
    - yaml id:claims set groups.<[groupName]>.members.<[player].uuid>.break:false
    - yaml id:claims set groups.<[groupName]>.members.<[player].uuid>.interact:false
    - yaml id:claims set groups.<[groupName]>.members.<[player].uuid>.farm:false
    - yaml id:claims set groups.<[groupName]>.members.<[player].uuid>.fly:false
    - narrate "<&a>Player <[player].name> has been added to your <[groupName].after[~]> group."
    - inject text_input_complete
    - inventory open d:claiming_group_management_inventory
    - wait 1t
    - give <proc[claiming_group_management_member_generation].context[<[groupName]>]> to:<player.open_inventory>
    - run claiming_group_management_permission_generation def:everyone|<[groupName]>


claiming_protection_removeMember:
  type: task
  debug: false
  definitions: player_in|groupName
  script:
    - if <[groupName]||null> == null:
      - define groupName <player.flag[text_input].after[/]>
    - if <[player_in].type> != Player:
      - define player <server.match_offline_player[<[player_in]>]||null>
    - else:
      - define player <[player_in]>
    - if <[player]> == null:
      - narrate "Unknown Player: <[player_in]>"
      - stop
    - yaml id:claims set groups.<[groupName]>.members.<[player_in].uuid>:!
    - inject text_input_complete

claiming_protection_settings_change_name:
  type: task
  debug: false
  definitions: NewName|group
  script:
    - yaml id:claims set groups.<[group]>.settings.display_name:<[NewName]>
    - narrate "<&e>You have changed your group's display name to <proc[getColorCode].context[<yaml[claims].read[groups.<[group]>.settings.color]>]><[NewName]>"
    - inject text_input_complete
    - inventory open d:claiming_protection_settings
    - wait 1t
    - inventory set slot:<script[claiming_protection_settings].yaml_key[group_slot]> d:<player.open_inventory> o:<item[white_stained_glass_pane].with[display_name=<&e>;nbt=group/<[group]>]>
    - give <proc[claiming_protection_settings_generate_settings_buttons].context[<[group]>]> to:<player.open_inventory>
    - wait 1t
    - inject claiming_settings_update

claiming_protection_setUpgrade:
  type: task
  debug: false
  definitions: group|permission|value
  script:
    - yaml id:claims set groups.<player.uuid>~<[group]>.upgrades.<[permission]>:<[value]>

claiming_protection_changeSetting:
  type: task
  debug: false
  definitions: value|group|setting
  script:
    - yaml id:claims set groups.<player.uuid>~<[group]>.settings.<[setting]>:<[value]>

claiming_protection_setMemberPermission:
  type: task
  debug: false
  definitions: target|group|permission|value
  script:
    - yaml id:claims set groups.<player.uuid>~<[group]>.<[target].uuid>.<[permission]>:<[value]>
    

claiming_protection_events:
  type: world
  debug: false
  farmables: pumpkins|carrots|wheat|beetroots|potatoes|cocoa|sugar_cane|kelp_plant|melon
  no_break_bottom: sugar_cane|kelp_plant
  events:
    on player damages cow|chicken|pig|llama|bee|cat|dolphin|donkey|fox|turtle|horse|minecart|mushroom_cow|rabbit|polar_bear|wolf|villager|parrot|skeleton_horse|zombie_horse|sheep:
      - define group <yaml[claims].read[<context.entity.location.chunk.world>.<context.entity.location.chunk.x>.<context.entity.location.chunk.z>]||null>
      - if <[group]> == null:
        - stop
      - if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.kill-animals]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.kill-animals]>:
        - narrate "<&c>You do not have permission to kill animals here."
        - determine cancelled
    on player places block:
      - define group <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - if <[group]> == null:
        - stop
      - if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.place]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.place]>:
        - narrate "<&c>You do not have permission to place blocks here."
        - determine cancelled
    on player right clicks with water_bucket|lava_bucket|bone_meal:
      - if <context.relative||null> == null:
        - stop
      - define group <yaml[claims].read[<context.relative.chunk.world>.<context.relative.chunk.x>.<context.relative.chunk.z>]||null>
      - if <[group]> == null:
        - stop
      - if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.place]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.place]>:
        - narrate "<&c>You do not have permission to place blocks here."
        - determine cancelled
    on player breaks block:
      - define group <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - if <[group]> == null:
        - stop
      - if <script[claiming_protection_events].yaml_key[farmables].contains[<context.material.name>]>:
        - if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.farm]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.farm]>:
          - narrate "<&c>You do not have permission to farm here."
          - determine cancelled
        - else if <script[claiming_protection_events].yaml_key[no_break_bottom].contains[<context.material.name>]> && !<yaml[claims].read[groups.<[group]>.members.everyone.break]> && !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.break]||false>:
          - if <context.location.below.material.name> != <context.material.name>:
            - narrate "<&c>You cannot farm the bottom of this, without break permission."
            - determine cancelled
        - else if <context.location.material.age> < 7 && !<yaml[claims].read[groups.<[group]>.members.everyone.break]> && !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.break]||false>:
          - narrate "<&c>This plant hasn't matured yet."
          - determine cancelled
        - else:
          - if <script[claim_system_upgrade_auto-replant].yaml_key[replantables].contains[<context.material.name>]>:
            - inject claim_system_upgrade_auto-replant
      - else if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.break]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.break]>:
        - narrate "<&c>You do not have permission to break blocks here."
        - determine cancelled
    on player clicks *door|*_button|lever|chest|enderchest|*_gate|crafting_table|anvil|furnace|brewing_stand|enchanting_table|*_bed priority:100:
      - define location <context.location||<player.location>>
      - define group <yaml[claims].read[<[location].chunk.world>.<[location].chunk.x>.<[location].chunk.z>]||null>
      - if <[group]> == null:
        - stop
      - if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.interact]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.interact]>:
        - narrate "<&c>You do not have permission to interact with blocks here."
        - determine cancelled
    on liquid spreads:
      - if <context.location.chunk> == <context.destination.chunk>:
        - stop
      - define group1 <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - define group2 <yaml[claims].read[<context.destination.chunk.world>.<context.destination.chunk.x>.<context.destination.chunk.z>]||null>
      - if <[group1]> == <[group2]>:
        - stop
      - if <[group2]> != null:
        - determine cancelled
    on block spreads:
      - if <context.location.chunk> == <context.source_location.chunk>:
        - stop
      - define group1 <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - define group2 <yaml[claims].read[<context.source_location.chunk.world>.<context.source_location.chunk.x>.<context.source_location.chunk.z>]||null>
      - if <[group1]> == <[group2]>:
        - stop
      - if <[group1]> != null:
        - determine cancelled
    on piston extends:
      - define target_chunk <context.location.add[<context.relative.sub[<context.location>].mul[<context.length.+[1]>]>].chunk>
      - define group1 <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - define group2 <yaml[claims].read[<[target_chunk].world>.<[target_chunk].x>.<[target_chunk].z>]||<[group1]>>
      - if <[group1]> != <[group2]>:
        - determine cancelled
      - define chunks <context.blocks.parse[chunk].deduplicate>
      - foreach <[chunks]> as:chunk:
        - if <[group1]> != <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||<[group1]>>:
          - determine cancelled
    on piston retracts:
      - define group1 <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - define chunks <context.blocks.parse[chunk].deduplicate>
      - foreach <[chunks]> as:chunk:
        - if <[group1]> != <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||<[group1]>>:
          - determine cancelled
    on entity explodes:
      - define chunks <context.blocks.parse[chunk].deduplicate>
      - foreach <[chunks]> as:chunk:
        - if <yaml[claims].read[<[chunk].world>.<[chunk].x>.<[chunk].z>]||null> != null:
          - determine passively cancelled
          - determine 0
    on player stands on material:
      - define group <yaml[claims].read[<context.location.chunk.world>.<context.location.chunk.x>.<context.location.chunk.z>]||null>
      - if <[group]> == null:
        - stop
      - if !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.interact]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.interact]>:
        - determine cancelled
      
      
claiming_system_upgrade_events:
  type: world
  debug: false
  events:
    on player enters notable cuboid:
      - if <context.cuboids.filter[notable_name.starts_with[claim]].is_empty>:
        - stop
      - define group <context.cuboids.filter[notable_name.starts_with[claim]].parse[notable_name.after[.].before[/]].get[1]>
      - if <player.flag[claim_enter_ignore]||null> == <[group]>:
        - flag player claim_enter_ignore:!
        - stop
      - inject claiming_system_bossBar_Start
      - wait 2t
      - foreach fly|time-control|weather-control as:upgrade_name:
        - if <yaml[claims].read[groups.<[group]>.upgrades.<[upgrade_name]>]> && <yaml[claims].read[groups.<[group]>.settings.<[upgrade_name]>]> != off:
          - if <[upgrade_name]> == fly:
            - if <yaml[claims].read[groups.<[group]>.members.<player.uuid>.fly]||false> || <yaml[claims].read[groups.<[group]>.members.everyone.fly]>:
              - inject claim_system_apply_upgrade_fly
              - foreach next
          - inject claim_system_apply_upgrade_<[upgrade_name]>
    on player exits notable cuboid:
      - if <context.cuboids.filter[notable_name.starts_with[claim]].is_empty>:
        - stop
      - define group <context.cuboids.filter[notable_name.starts_with[claim]].parse[notable_name.after[.].before[/]].get[1]>
      - flag player claim_enter_ignore:<[group]> duration:6t
      - wait 2t
      - if !<player.is_online>:
        - stop
      - if <player.has_flag[claim_enter_ignore]>:
        - inject claiming_system_bossBar_Stop
        - wait 2t
        - foreach fly|time-control|weather-control as:upgrade_name:
          - define newgroup:<player.location.cuboids.filter[notable_name.starts_with[claim]].get[1].notable_name.after[.].before[/]||null>
          - if <[newgroup]> != null:
            - if <yaml[claims].read[groups.<[newgroup]>.members.<player.uuid>.<[upgrade_name]>]||true> || <yaml[claims].read[groups.<[newgroup]>.members.everyone.<[upgrade_name]>]||true>:
              - if <yaml[claims].read[groups.<[newgroup]>.upgrades.<[upgrade_name]>]> && <yaml[claims].read[groups.<[newgroup]>.settings.<[upgrade_name]>]> != off:
                - foreach next
            - if <yaml[claims].read[groups.<[newgroup]>.upgrades.<[upgrade_name]>]> && <yaml[claims].read[groups.<[newgroup]>.settings.<[upgrade_name]>]> != off:
                - foreach next
          - if <[upgrade_name]> == fly:
            - inject claim_system_remove_upgrade_fly
            - foreach next
          - inject claim_system_remove_upgrade_<[upgrade_name]>

#####################
## BOSS BAR SYSTEM ##
#####################
claiming_system_bossBar_Start:
  type: task
  debug: false
  script:
    - define group_color <proc[getColorCode].context[<yaml[claims].read[groups.<[group]>.settings.color]>]>
    - foreach create_fog|darken_sky as:flag:
      - if <yaml[claims].read[groups.<[group]>.settings.<[flag]>]> && <yaml[claims].read[groups.<[group]>.upgrades.<[flag]>]>:
        - define flag_list:|:<[flag]>
    - if <server.current_bossbars.contains[<player.uuid>.in_claim]>:
      - bossbar remove <player.uuid>.in_claim
    # APOSTROPHE BS
    - if <[group].before[~].as_player.name.ends_with[s]>:
      - define apostrophe <&sq>
    - else:
      - define apostrophe <&sq>s
    - if <[flag_list].is_empty||true>:
      - bossbar <player.uuid>.in_claim "title:<[group_color]><[group].before[~].as_player.name><[apostrophe]> <yaml[claims].read[groups.<[group]>.settings.display_name]>" color:<yaml[claims].read[groups.<[group]>.settings.color]>
    - else:
      - bossbar <player.uuid>.in_claim "title:<[group_color]><[group].before[~].as_player.name><[apostrophe]> <yaml[claims].read[groups.<[group]>.settings.display_name]>" color:<yaml[claims].read[groups.<[group]>.settings.color]> flags:<[flag_list]>
    - if <[update]||null> == null:
      - title title:<[group_color]><yaml[claims].read[groups.<[group]>.settings.display_name]> subtitle:<[group].before[~].as_player.name>'s<&sp>Claim

claiming_system_bossBar_Stop:
  type: task
  debug: false
  script:
    - if <player.location.cuboids.filter[notable_name.starts_with[claim]].is_empty>:
      - if <server.current_bossbars.contains[<player.uuid>.in_claim]>:
        - bossbar remove <player.uuid>.in_claim
      - if !<player.is_online>:
        - stop
      - if <player.location.world.name> == spawn:
        - stop
      - if <player.location.cuboids.parse[notable_name].contains[savage_lands_cuboids]>:
        - inject claiming_system_bossBar_SavageLands
      - else:
        - inject claiming_system_bossBar_OuterRealms

claiming_system_bossbar_initialize:
  type: world
  events:
    on player changes world to mainland:
      - wait 5t
      - inject claiming_system_bossBar_Stop
      
    on player changes world to spawn:
      - wait 5t
      - inject claiming_system_bossBar_Stop
    
    on player enters savage_lands_cuboids:
      - wait 5t
      - inject claiming_system_bossBar_Stop
    
    on player exits savage_lands_cuboids:
      - wait 5t
      - inject claiming_system_bossBar_Stop

## Deprecated
##claiming_system_bossBar_Wilderness:
##  type: task
##  script:
##      - if <server.has_flag[wilderness_bossbar_flags]>:
##        - bossbar <player.uuid>.in_claim "title:<&2>Wilderness" color:green flags:<server.flag[wilderness_bossbar_flags]>
##      - else:
##        - bossbar <player.uuid>.in_claim "title:<&2>Wilderness" color:green

claiming_system_bossBar_OuterRealms:
  type: task
  script:
      - title "title:<&2>Outer Realms" "subtitle:Safe Zone"
      - if <server.has_flag[outerRealms_bossbar_flags]>:
        - bossbar <player.uuid>.in_claim "title:<&2>Outer Realms" color:green flags:<server.flag[outerRealms_bossbar_flags]>
      - else:
        - bossbar <player.uuid>.in_claim "title:<&2>Outer Realms" color:green

claiming_system_bossBar_SavageLands:
  type: task
  script:
      - title "title:<&4>Savage Lands" "subtitle:Here be monsters."
      - if <server.has_flag[SavageLands_bossbar_flags]>:
        - bossbar <player.uuid>.in_claim "title:<&4>Savage Lands" color:red flags:<server.flag[SavageLands_bossbar_flags]>
      - else:
        - bossbar <player.uuid>.in_claim "title:<&4>Savage Lands" color:red

claiming_system_bossBar_Biome:
  type: task
  script:
    - foreach <script[claim_system_yaml_settings].list_keys[biomes]>:
      - if <player.location.biome.name.contains_any[<[value].as_list>]>
        - define title_color <script[claim_system_yaml_settings].yaml_key[biomes.<[value]>.title_color].parsed>
        - define bossbar_color <script[claim_system_yaml_settings].yaml_key[biomes.<[value]>.bossbar_color].parsed>
        - define bossbar_flags <script[claim_system_yaml_settings].yaml_key[biomes.<[value]>.bossbar_flags]||null>
    - title title:<[title_color]><player.location.biome.name.to_titlecase>
    - if <[bossbar_flags]> != null:
      - bossbar <player.uuid>.in_claim "title:<&2><player.location.biome.name.to_titlecase>" color:<[bossbar_color]> flags:<[bossbar_flags]>
    - else:
      - bossbar <player.uuid>.in_claim "title:<&2><player.location.biome.name.to_titlecase>" color:<[bossbar_color]>

###########################
## CLAIM UPGRADE IMPACTS ##
###########################

# AUTO-REPLANT
claim_system_upgrade_auto-replant:
  type: task
  debug: false
  replantables: wheat|carrots|beetroots|potatoes|cocoa
  script:
    - if <yaml[claims].read[groups.<[group]>.settings.auto-plant]> && <yaml[claims].read[groups.<[group]>.upgrades.auto-plant]>:
      - if <context.location.material.age> == 7:
        - wait 1t
        - modifyblock <context.location> <context.material.with[age=0]>

# disable-mob-spawn
claim_system_upgrade_spawn_prevention:
  type: world
  debug: false
  events:
    on entity spawns because natural:
      - if !<context.location.cuboids.filter[notable_name.starts_with[claim]].is_empty>:
        - define group <context.location.cuboids.filter[notable_name.starts_with[claim]].parse[notable_name.after[.].before[/]].get[1]>
        - if <yaml[claims].read[groups.<[group]>.settings.disable-mob-spawn]> && <yaml[claims].read[groups.<[group]>.upgrades.disable-mob-spawn]>:
          - determine cancelled

# keep-inventory
claim_system_upgrade_keep_inventory:
  type: world
  debug: false
  events:
    on player dies:
      - if !<player.location.cuboids.filter[notable_name.starts_with[claim]].is_empty>:
        - define group <player.location.cuboids.filter[notable_name.starts_with[claim]].parse[notable_name.after[.].before[/]].get[1]>
        - if <yaml[claims].read[groups.<[group]>.settings.keep-inventory]> && <yaml[claims].read[groups.<[group]>.upgrades.keep-inventory]>:
          - determine passively "KEEP_INV"
          - determine "NO_DROPS"

# FLY

claim_system_apply_upgrade_fly:
  type: task
  debug: false
  script:
    - adjust <player> can_fly:true

claim_system_remove_upgrade_fly:
  type: task
  debug: false
  script:
    - if <player.gamemode> == SURVIVAL:
      - adjust <player> can_fly:false
      - flag player no_next_fall duration:20s

claim_system_apply_fly_in_all_claims:
  type: task
  debug: false
  definitions: group
  script:
    - define targets <server.list_notables[cuboids].filter[notable_name.starts_with[claim.<[group]>]].parse[players].combine>
    - foreach <[targets]>:
      - if <yaml[claims].read[groups.<[group]>.members.<[value].uuid>.fly]||false> || <yaml[claims].read[groups.<[group]>.members.everyone.fly]>:
        - adjust <[player]> can_fly:true

claim_system_apply_fly_in_all_claims:
  type: task
  debug: false
  definitions: group
  script:
    - define targets <server.list_notables[cuboids].filter[notable_name.starts_with[claim.<[group]>]].parse[players].combine>
    - foreach <[targets]> as:player:
      - if <yaml[claims].read[groups.<[group]>.members.<[value].uuid>.fly]||false> || <yaml[claims].read[groups.<[group]>.members.everyone.fly]>:
        - adjust <[player]> can_fly:true

claim_system_remove_fly_target:
  type: task
  debug: false
  definitions: group|player
  script:
    - if !<server.list_notables[cuboids].filter[notable_name.starts_with[claim.<[group]>]].filter[players.contains[<player>]].is_empty>:
      - if <player.gamemode> == SURVIVAL:
        - adjust <player> can_fly:false

claim_system_add_fly_target:
  type: task
  debug: false
  definitions: group|player
  script:
    - if !<server.list_notables[cuboids].filter[notable_name.starts_with[claim.<[group]>]].filter[players.contains[<player>]].is_empty>:
      - if <player.gamemode> == SURVIVAL:
        - adjust <player> can_fly:true
# TIME-CONTROL

claim_system_apply_upgrade_time-control:
  type: task
  debug: false
  script:
    - choose <yaml[claims].read[groups.<[group]>.settings.time-control]>:
      - case morning:
        - time player 100 freeze
      - case noon:
        - time player 300 freeze
      - case evening:
        - time player 500 freeze
      - case sunset:
        - time player 600 freeze
      - case midnight:
        - time player 900 freeze
      - case sunrise:
        - time player 1 freeze
      - case off:
        - time player reset

claim_system_remove_upgrade_time-control:
  type: task
  debug: false
  script:
    - time player reset

# WEATHER-CONTROL

claim_system_apply_upgrade_weather-control:
  type: task
  debug: false
  script:
    - if <yaml[claims].read[groups.<[group]>.settings.weather-control]> != off:
      - weather player <yaml[claims].read[groups.<[group]>.settings.weather-control]>
    - else:
      - weather player reset

claim_system_remove_upgrade_weather-control:
  type: task
  debug: false
  script:
    - weather player reset

claim_system_build_chunkmap:
  type: procedure
  definitions: chunk|json
  script:
    - define world <[chunk].world>
    - repeat 9 as:z:
      - define z_to_use <[z].-[5].+[<[chunk].z>]>
      - repeat 9 as:x:
        - define x_to_use <[x].-[5].+[<[chunk].x>]>
        - define group_owner <yaml[claims].read[<[world]>.<[x_to_use]>.<[z_to_use]>].before[~]||Wilderness>
        - define group_owner_name <[group_owner].as_player.name||Wilderness>
        - define group_name <yaml[claims].read[groups.<yaml[claims].read[<[world]>.<[x_to_use]>.<[z_to_use]>]||Wilderness>.settings.display_name]>
        - define group_color <proc[getColorCode].context[<yaml[claims].read[groups.<yaml[claims].read[<[world]>.<[x_to_use]>.<[z_to_use]>]||Wilderness>.settings.color]>]>
        - if <[chunk].x> == <[x_to_use]> && <[chunk].z> == <[z_to_use]>:
          - define x_color <&e>
        - else:
          - define x_color <&7>
        - if <[json]>:
          - if <[group_owner]> == <player.uuid>:
            - define "row_<[z]>:|:<element[<&a><&lb><[x_color]>X<&a><&rb>].on_hover[<[group_color]><[group_owner_name]><&nl><[group_color]><[group_name]>].on_click[/chunkguide <[x_to_use]> <[z_to_use]>]>"
          - else if <[group_owner]> == Wilderness:
            - define "row_<[z]>:|:<element[<&2><&lb><[x_color]>X<&2><&rb>].on_hover[<[group_color]><[group_owner_name]><&nl><[group_color]><[group_name]>].on_click[/chunkguide <[x_to_use]> <[z_to_use]>]>"
          - else:
            - define "row_<[z]>:|:<element[<&c><&lb><[x_color]>X<&c><&rb>].on_hover[<[group_color]><[group_owner_name]><&nl><[group_color]><[group_name]>].on_click[/chunkguide <[x_to_use]> <[z_to_use]>]>"
        - else:
          - if <[group_owner]> == <player.uuid>:
            - define "row_<[z]>:|:<element[<&a><&lb><[x_color]>X<&a><&rb>]>"
          - else if <[group_owner]> == Wilderness:
            - define "row_<[z]>:|:<element[<&2><&lb><[x_color]>X<&2><&rb>]>"
          - else:
            - define "row_<[z]>:|:<element[<&c><&lb><[x_color]>X<&c><&rb>]>"
    - define "list:|:<&e>--------------------------------|<&b>                    NORTH"
    - repeat 9:
      - define list:|:<[row_<[value]>].separated_by[<&sp><&sp>]>
    
    - define "list:|:<&b>                    SOUTH|<&e>--------------------------------"
    - determine <[list]>
    

claim_system_guide_to_chunk_main:
  type: task
  definitions: chunk
  script:
    - if <player.has_flag[chunk_guide]>:
      - narrate "<&c>You are already being guided to a chunk."
      - stop
    - flag player chunk_guide:true
    - define center <[chunk].cuboid.center.with_y[<player.location.y>]>
    - look <player> <[center]> duration:2t
    - title "title:<&a>Follow The Particles!"
    - if <player.location.distance[<[center]>]> > 20:
      - define last_distance <player.location.distance[<[center]>]>
      - inject claim_system_guide_to_chunk_draw_line
    - if !<player.is_online>:
      - flag player chunk_guide:!
      - stop
    - inject claim_system_guide_to_outline_chunk
    - flag player chunk_guide:!

claim_system_guide_to_chunk_draw_line:
  type: task
  script:
    - while <player.location.distance[<[center]>]> > 20 && <player.is_online>:
      - define locs <player.location.points_between[<[center]>].get[5].to[35]>
      - if <[last_distance].+[5]> < <player.location.distance[<[center]>]>:
        - narrate "<&c>Chunk Guide has ended, due to walking away from the chunk."
        - flag player chunk_guide:!
        - stop
      - else if <[last_distance]> > <player.location.distance[<[center]>]>:
        - define last_distance <player.location.distance[<[center]>]>
      - repeat <[locs].size>:
        - playeffect totem at:<[locs].get[<[value]>].with_y[<[locs].get[<[value]>].highest.y.+[3]>]> quantity:10 targets:<player>
        - wait 1t

claim_system_guide_to_outline_chunk:
  type: task
  script:
    - define y <player.location.y>
    - repeat 20:
      - if <player.is_online>:
        - playeffect happy_villager at:<[chunk].cuboid.center.with_y[<[y]>].add[0,<[value].*[0.25]>,0]> quantity:30 offset:1 targets:<player>
        - wait 1t

claiming_settings_update:
  type: task
  definitions: group
  script:
    - ratelimit <[group]> 10t
    - define update true
    - foreach <server.list_online_players.filter[location.cuboids.parse[notable_name].filter[starts_with[claim.<[group]>]].is_empty.not]> as:target:
      - adjust <queue> linked_player:<[target]>
      - inject claiming_system_bossBar_Start
      - foreach fly|time-control|weather-control as:upgrade_name:
        - if <yaml[claims].read[groups.<[group]>.upgrades.<[upgrade_name]>]> && <yaml[claims].read[groups.<[group]>.settings.<[upgrade_name]>]> != off:
          - if <[upgrade_name]> == fly:
            - if <yaml[claims].read[groups.<[group]>.members.<player.uuid>.fly]||false> || <yaml[claims].read[groups.<[group]>.members.everyone.fly]>:
              - inject claim_system_apply_upgrade_fly
              - foreach next
          - inject claim_system_apply_upgrade_<[upgrade_name]>
        - else:
          - if <[upgrade_name]> == fly:
            - if <yaml[claims].read[groups.<[group]>.members.<player.uuid>.fly]||false> || <yaml[claims].read[groups.<[group]>.members.everyone.fly]>:
              - inject claim_system_remove_upgrade_fly
              - foreach next
          - inject claim_system_remove_upgrade_<[upgrade_name]>
          


##################
## UPDATE YAMLS ##
##################
claiming_update_yamls:
  type: task
  update_keys: 
  script:
    - foreach <yaml[claims].list_keys[groups]> as:ID:
        - yaml set id:claims groups.<[ID]>.members.<player.uuid>.kill-animals:true
        - yaml set id:claims groups.<[ID]>.members.everyone.kill-animals:false

##################################################
## VARIOUS - NEED TO MOVE THESE AT A LATER DATE ##
##################################################

getColorCode:
  type: procedure
  debug: false
  definitions: color
  script:
    - choose <[color]>:
      - case blue:
        - determine <&b>
      - case green:
        - determine <&2>
      - case pink:
        - determine <&d>
      - case purple:
        - determine <&5>
      - case red:
        - determine <&c>
      - case white:
        - determine <&f>
      - case yellow:
        - determine <&e>