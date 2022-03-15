cosmetic_configuration:
  type: data
  display_data:
    lore:
    - "<&b><&m>---<&r><&8><&m>｜-<&r>  <&8><&m>+--------------------------+<&r>  <&8><&m>-｜<&b><&m>---"
    - "<&7>* <&e>Name: <&7><[display]>"
    - "<&7>* <[preview]>"
    - "<&7>* <&e>Description: <&7><[description]>"
    - "<&r>"
    - "<&7>* Want more cool cosmetics? let us know!"
    - "<&7>  Buy more cosmetics, available at the shops!"
    - "<&r>"
    - "<&a>Click to use this cosmetic."
    - "<&b><&m>---<&r><&8><&m>｜-<&r>  <&8><&m>+--------------------------+<&r>  <&8><&m>-｜<&b><&m>---"
    - "<&r>"

cosmetic_menu_masks:
  type: item
  material: totem_of_undying
  display name: <&d>Masks
  lore:
    - "<&e>Take on different appearances"
    - "<&e>Completely disguise yourself!"

cosmetic_menu_titles:
  type: item
  material: name_tag
  display name: <&6>Titles
  lore:
    - "<&e>Titles appear above your head"
    - "<&e>They are also in chat player info."

cosmetic_menu_bowtrails:
  type: item
  material: crossbow
  display name: <&b>Bowtrails
  lore:
    - "<&e>Spiff up your bow shots!"
    - "<&e>Grab your bow, and show off."


cosmetic_main_menu_open:
  type: task
  debug: false
  data:
    slots_by_count:
      1: 5
      2: 4|6
      3: 3|5|7
      4: 2|4|6|8
      5: 1|3|5|7|9
  script:
    - foreach <script[cosmetic_selection_inventory_open].list_keys[data].exclude[slot_data]>:
      - define items:|:<item[cosmetic_menu_<[value]>].with_flag[run_script:cosmetic_selection_inventory_open].with_flag[cosmetic_type:<[value]>]>
    - define inventory <inventory[generic[title=<&d>Cosmetics;size=9]]>
    - define slots <list[<script.data_key[data.slots_by_count].get[<[items].size>]>]>
    - foreach <[items]>:
      - inventory set slot:<[slots].get[<[loop_index]>]> o:<[value]> d:<[inventory]>
    - inventory open d:<[inventory]>

cosmetic_selection_inventory_open:
  type: task
  debug: false
  definitions: type|page
  data:
    slot_data:
      slots_used: 11|12|13|14|15|16|17|20|21|22|23|24|25|26|29|30|31|32|33|34|35
      remove_slot: 50
      next_page: 45
      previous_page: 37
      back: 46
    masks:
      inventory_title: <&chr[F808]><&f><&chr[6912].font[adriftus:guis]>
      players_list: <yaml[global.player.<player.uuid>].list_keys[masks.unlocked].if_null[<list>]>
      material: <server.flag[masks.ids.<[cosmetic]>].data_key[display_data.material]>
      display_name: <server.flag[masks.ids.<[cosmetic]>].parsed_key[display_data.display_name]>
      description: <server.flag[masks.ids.<[cosmetic]>].parsed_key[display_data.description]>
      preview: "<&e>Disguised Name<&co> <&r><server.flag[masks.ids.<[cosmetic]>].parsed_key[mask_data.display_name]>"
      current: <yaml[global.player.<player.uuid>].read[masks.current.id].if_null[default]>
      equip_task: mask_wear
      remove_task: mask_remove
    titles:
      inventory_title: <&chr[F808]><&f><&chr[6910].font[adriftus:guis]>
      players_list: <yaml[global.player.<player.uuid>].list_keys[titles.unlocked].if_null[<list>]>
      material: name_tag
      display_name: <[cosmetic]>
      preview: "<&e>Preview<&co> <&r><yaml[titles].parsed_key[titles.<[cosmetic]>.tag].parse_color>"
      description: <yaml[titles].parsed_key[titles.<[cosmetic]>.description].parse_color>
      current: <yaml[global.player.<player.uuid>].read[titles.current].if_null[default]>
      equip_task: titles_equip
      remove_task: titles_remove
    bowtrails:
      inventory_title: <&chr[F808]><&f><&chr[6911].font[adriftus:guis]>
      players_list: <yaml[global.player.<player.uuid>].list_keys[bowtrails.unlocked].if_null[<list>]>
      material: <yaml[bowtrails].read[bowtrails.<[cosmetic]>.icon]>
      display_name: <yaml[bowtrails].parsed_key[bowtrails.<[cosmetic]>.name].parse_color>
      preview: "<&e>Trail Type<&co> <&r><&f><yaml[bowtrails].parsed_key[bowtrails.<[cosmetic]>.trail_type].replace_text[_].with[<&sp>].to_titlecase>"
      description: <yaml[bowtrails].parsed_key[bowtrails.<[cosmetic]>.description].parse_color>
      current: <yaml[global.player.<player.uuid>].read[bowtrails.current].if_null[default]>
      equip_task: bowtrails_equip
      remove_task: bowtrails_remove
  script:
    # Sanity Check
    - if !<[type].exists>:
      - define type <context.item.flag[cosmetic_type]>

    # Define our initialization data
    - define page 1 if:<[page].exists.not>
    - define title <script.parsed_key[data.<[type]>.inventory_title]>
    - define slots <list[<script.data_key[data.slot_data.slots_used]>]>
    - define start <[page].sub[1].mul[<[slots].size>].add[1]>
    - define end <[slots].size.mul[<[page]>]>
    - define cosmetics <script.parsed_key[data.<[type]>.players_list]>

    # Build the cosmetic icons
    - foreach <[cosmetics].get[<[start]>].to[<[end]>]> as:cosmetic:
      - define material <script.parsed_key[data.<[type]>.material]>
      - define display <script.parsed_key[data.<[type]>.display_name]>
      - define preview <script.parsed_key[data.<[type]>.preview]>
      - define description <script.parsed_key[data.<[type]>.description]>
      - define equip_script <script.parsed_key[data.<[type]>.equip_task]>
      - define lore <script[cosmetic_configuration].parsed_key[display_data.lore]>
      - define items:|:<item[<[material]>].with[lore=<[lore]>;flag=run_script:<[equip_script]>;flag=cosmetic:<[cosmetic]>]>
    - define inventory <inventory[generic[title=<[title]>;size=54]]>

    # Put the items into the new inventory
    - foreach <[items]>:
      - inventory set slot:<[slots].get[<[loop_index]>]> o:<[value].with[display=<&6>]> d:<[inventory]>

    # Build the "unequip cosmetic" item, and store pagination data on it
    - define cosmetic <script.parsed_key[data.<[type]>.current]>
    - if <[cosmetic]> != default:
      - define material <script.parsed_key[data.<[type]>.material]>
      - define display "<&e>Unequip Cosmetic"
      - define lore "<&b>Left Click to Unequip|<&e>Current<&co> <&a><script.parsed_key[data.<[type]>.display_name]>"
      - define remove_script <script.parsed_key[data.<[type]>.remove_task]>
      - define item <item[<[material]>[display=<[display]>;lore=<[lore]>;flag=run_script:<[remove_script]>;flag=page:<[page]>;flag=type:<[type]>]]>
    - else:
      - define item "barrier[display=<&e>No Cosmetic Equipped;flag=run_script:cancel;flag=page:<[page]>;flag=type:<[type]>]"
    - inventory set slot:<script.data_key[data.slot_data.remove_slot]> o:<[item]> d:<[inventory]>

    # Next Page Button
    - if <[cosmetics].size> > <[end]>:
      - inventory set slot:<script.data_key[data.slot_data.next_page]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Next<&sp>Page;flag=run_script:cosmetics_next_page;color=green;custom_model_data=7]> d:<[inventory]>

    # Previous Page Button
    - if <[page]> != 1:
      - inventory set slot:<script.data_key[data.slot_data.previous_page]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Previous<&sp>Page;flag=run_script:cosmetics_previous_page;color=green;custom_model_data=6]> d:<[inventory]>

    # Back to Cosmetics
    - inventory set slot:<script.data_key[data.slot_data.back]> o:<item[leather_horse_armor].with[hides=all;display_name=<&a>Back<&sp>To<&sp>Cosmetics;flag=run_script:cosmetic_main_menu_open;color=red;custom_model_data=6]> d:<[inventory]>
    # Open The Inventory
    - inventory open d:<[inventory]>

cosmetics_next_page:
  type: task
  debug: false
  script:
    - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
    - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page].add[1]>

cosmetics_previous_page:
  type: task
  debug: false
  script:
    - define info_item <context.inventory.slot[<script[cosmetic_selection_inventory_open].data_key[data.slot_data.remove_slot]>]>
    - run cosmetic_selection_inventory_open def:<[info_item].flag[type]>|<[info_item].flag[page].sub[1]>

