###################
## ACCESSOR TASK ##
###################
title_unlock:
  type: task
  definitions: tagID
  debug: false
  script:
    - if <yaml[titles].read[titles.<[tagID]>]||null> != null && !<yaml[global.player.<player.uuid>].read[titles.unlocked].contains[<[tagID]>]||false>:
      - yaml id:global.player.<player.uuid> set titles.unlocked:|:<[tagID]>


title_remove:
  type: task
  definitions: tagID
  debug: false
  script:
    - if <yaml[global.player.<player.uuid>].read[titles.unlocked].contains[<[tagID]>]||false>:
      - yaml id:global.player.<player.uuid> set titles.unlocked:<-:<[tagID]>

##################
## Open Command ##
##################

titles_gui_command:
  type: command
  name: title
  aliases:
    - titles
  debug: false
  usage: /title
  description: Used to access and change any unlocked titles.
  script:
    - inject title_inventory_open

###################
## Internal Shit ##
###################

title_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  title: <yaml[titles].read[gui.title].parse_color>
  custom:
    mapping:
      next_page: 54
      previous_page: 46
      current_title: 50
      page_marker: 1
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&a>]>
    next_page: <item[arrow].with[display_name=<&a>Next<&sp>Page;nbt=action/next_page]>
    previous_page: <item[arrow].with[display_name=<&c>Previous<&sp>Page;nbt=action/previous_page]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [] [] [] [] [] [] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

title_inventory_events:
  type: world
  debug: false
  events:
    on player clicks item in title_inventory:
      - determine passively cancelled
      - wait 1t
      - if <context.item.has_nbt[action]>:
        - choose <context.item.nbt[action]>:
          - case set_title:
            - yaml id:global.player.<player.uuid> set titles.current:<context.item.nbt[title]>
            - yaml id:global.player.<player.uuid> set titles.current_tag:<yaml[titles].read[titles.<context.item.nbt[title]>.tag].parse_color>
            - inject title_inventory_open
            - narrate "<&b>You have changed your active title to<&co> <yaml[titles].read[titles.<context.item.nbt[title]>.tag].parse_color.parsed>"
          - case remove_title:
            - yaml id:global.player.<player.uuid> set titles.current:!
            - inject title_inventory_open
          - case next_page:
            - define page <context.inventory.slot[<script[title_inventory].data_key[custom.mapping.page_marker]>].nbt[page].+[1]>
            - inject title_inventory_open
          - case previous_page:
            - define page <context.inventory.slot[<script[title_inventory].data_key[custom.mapping.page_marker]>].nbt[page].-[1]>
            - inject title_inventory_open

title_inventory_open:
  type: task
  definitions: page
  debug: false
  script:
    - define page <[page]||1>
    - define inventory <inventory[title_inventory]>
    - define unlocked_tags <yaml[global.player.<player.uuid>].read[titles.unlocked].as_list||<list[Default]>>
    - foreach <[unlocked_tags]> as:tagID:
      - inject build_title_select_item
      - define list:|:<[item]>
    - give <[list].get[<[page].sub[1].mul[21].add[1]>].to[<[page].sub[1].mul[21].add[21]>]> to:<[inventory]>
    - foreach <script[title_inventory].list_keys[custom.mapping]>:
      - choose <[value]>:
        - case next_page:
          - if <[unlocked_tags].size> > <[page].sub[1].mul[21].add[21]>:
            - inventory set d:<[inventory]> slot:<script[title_inventory].data_key[custom.mapping.next_page]> o:<script[title_inventory].parsed_key[definitions.next_page]>
        - case previous_page:
          - if <[page]> > 1:
            - inventory set d:<[inventory]> slot:<script[title_inventory].data_key[custom.mapping.previous_page]> o:<script[title_inventory].parsed_key[definitions.previous_page]>
        - case current_title:
          - inject build_current_title
          - inventory set d:<[inventory]> slot:<script[title_inventory].data_key[custom.mapping.current_title]> o:<[item]>
        - case page_marker:
          - inventory set d:<[inventory]> slot:<script[title_inventory].data_key[custom.mapping.page_marker]> o:<script[title_inventory].parsed_key[definitions.filler].with[nbt=page/<[page]>]>
    - inventory open d:<[inventory]>

build_title_select_item:
  type: task
  definitions: tagID
  debug: false
  script:
    - define tag <yaml[titles].read[titles.<[tagID]>.tag].parse_color>
    - define description <yaml[titles].read[titles.<[tagID]>.description].parse_color.parsed>
    - define material <yaml[titles].read[gui.tag_select_item.material]>
    - define lore <yaml[titles].read[gui.tag_select_item.lore].parse[parse_color.parsed]>
    - define name <yaml[titles].read[gui.tag_select_item.displayname].parse_color.parsed>
    - define item <item[<[material]>].with[display_name=<[name]>;lore=<[lore]>;nbt=action/set_title|title/<[tagID]>]>

build_current_title:
  type: task
  debug: false
  script:
    - define tagID <yaml[global.player.<player.uuid>].read[titles.current]||Default>
    - define description <yaml[titles].read[titles.<[tagID]>.description].parse_color.parsed>
    - define material <yaml[titles].read[gui.current_title.material]>
    - define tag <yaml[titles].read[titles.<[tagID]>.tag].parse_color>
    - define name <yaml[titles].read[gui.no_current_title.displayname].parse_color.parsed>
    - if <[tagID]> == Default:
      - define lore <yaml[titles].read[gui.no_current_title.lore].parse[parse_color.parsed]>
      - define item <item[<[material]>].with[display_name=<[name]>;lore=<[lore]>]>
    - else:
      - define lore <yaml[titles].read[gui.current_title.lore].parse[parse_color.parsed]>
      - define item <item[<[material]>].with[display_name=<[name]>;lore=<[lore]>;nbt=action/remove_title]>

titles_config_manager:
  type: world
  debug: false
  load_yaml:
    - if <server.has_file[data/global/network/titles.yml]>:
      - yaml id:titles load:data/global/network/titles.yml
  events:
    on server start:
      - inject locally load_yaml
    on reload scripts:
      - inject locally load_yaml
