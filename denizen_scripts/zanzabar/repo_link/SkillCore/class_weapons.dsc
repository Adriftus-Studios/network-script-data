# Internal Stuff #
class_weapon_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  gui: true
  slots:
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [] [] [] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [standard_filler] [] [] [] [] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
    - [standard_filler] [standard_filler] [] [] [] [] [standard_filler] [standard_filler] [standard_filler]

#/# Test for script meta parser
class_weapon_hotkey_button:
  type: item
  debug: false
  material: feather
  flags:
    run_script: class_weapon_click_handler

#/
# Test for script meta parser
#/
class_weapon_open:
  type: task
  debug: false
  data:
    hotkeys:
      - "Right"
      - "Drop"
      - "Swap"
      - "Sneak_Left"
      - "Sneak_Right"
      - "Sneak_Drop"
      - "Sneak_Swap"
      - "Sprint_Left"
      - "Sprint_Right"
      - "Sprint_Drop"
      - "Sprint_Swap"
    item_format:
      display: <&a><[hotkey_button]>
      lore:
        - "<&a>Lore For <[hotkey_button]> Goes Here"
  script:
    - define inventory <inventory[class_weapon_inventory]>
    - foreach <script.data_key[data.hotkeys]> as:hotkey_button:
      - define map <script.parsed_key[data.item_format]>
      - define mechanisms <[map].keys.parse_tag[<[parse_value]>=<[map].get[<[parse_value]>]>].separated_by[;]>
      - if !<player.has_flag[hotkeys.<[hotkey_button]>]> || !<server.has_flag[skills.abilities.<player.flag[hotkeys.<[hotkey_button]>]>]>:
        - define items:->:<item[class_weapon_hotkey_button].with[<[mechanisms]>].with_flag[hotkey:<[hotkey_button]>]>
      - else:
        - define skill_script <server.flag[skills.abilities.<player.flag[hotkeys.<[hotkey_button]>]>]>
        - define item <item[<[skill_script].data_key[display_item_script]>]>
        - flag <[item]> hotkey:<[hotkey_button]>
        - flag <[item]> run_script:class_weapon_click_handler
        - adjust def:item "lore:<[item].lore.include[<&c>--------------|<&a>Hotkey<&co><&sp><[hotkey_button]>|<&b>Right Click to Unbind]>"
        - define items:->:<[item]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>

class_weapon_click_handler:
  type: task
  debug: false
  script:
    - define hotkey <context.item.flag[hotkey]>
    - if <context.click> == LEFT:
      - inject class_weapon_ability_selection_open
    - if <context.click> == RIGHT:
      - inject class_weapon_clear_hotkey

class_weapon_clear_hotkey:
  type: task
  debug: false
  definitions: hotkey
  script:
    - flag player hotkeys.<[hotkey]>:!
    - run class_weapon_open

class_weapon_ability_selection:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  gui: true
  slots:
    - [] [standard_filler] [] [standard_filler] [] [standard_filler] [] [standard_filler] []
    - [] [standard_filler] [standard_filler] [standard_filler] [] [standard_filler] [standard_filler] [standard_filler] []
    - [standard_filler] [] [] [] [] [] [] [] [standard_filler]
    - [standard_filler] [] [] [] [] [] [] [] [standard_filler]
    - [standard_filler] [] [] [] [] [] [] [] [standard_filler]
    - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

#/#
#/# Script Meta testing
#/# Permissions: adriftus.moderator, adriftus.admin
#/#
class_weapon_ability_selection_open:
  type: task
  debug: false
  definitions: hotkey|skillTree
  script:
    - define inventory <inventory[class_weapon_ability_selection]>
    - inventory set slot:46 destination:<[inventory]> origin:<item[standard_filler].with_flag[hotkey:<[hotkey]>]>
    - define items:!|:<player.flag[skills.trees].keys.pad_right[5].with[filler].parse[proc[class_weapon_skilltree_item]]>
    - foreach <list[staff|moderator|admin]> as:rank:
      # TODO Fix later
      - define items:->:<item[standard_filler].with_flag[unique:<util.random_uuid>]>
      - foreach next
      - if <player.has_permission[adriftus.<[rank]>]>:
        - define items:->:<element[<[rank]>].proc[class_weapon_skilltree_item]>
      - else:
        - define items:->:<item[standard_filler]>
    - if <player.has_flag[skills.trees]> && <player.flag[skills.trees].size> > 0:
      - define tree <[skillTree]||<player.flag[skills.trees].keys.first>>
      - if !<player.flag[skills.trees.<[tree]>].keys.is_empty>:
        - define items:|:<player.flag[skills.trees.<[tree]>].keys.parse[proc[class_weapon_ability_item]]>
    - give <[items]> to:<[inventory]>
    - inventory open d:<[inventory]>

#/#
#/#
#/#
class_weapon_skilltree_item:
  type: procedure
  debug: false
  definitions: input
  script:
    - if <[input]> == filler:
        - determine <item[standard_filler].with_flag[unique:<util.random_uuid>]>
    - define skillTree_script <server.flag[skills.trees.<[input]>.script]>
    - determine <item[<[skillTree_script].data_key[display_item_script]>].with_flag[skillTree:<[skillTree_script].data_key[name]>].with_flag[run_script:class_weapon_set_skillTree]>

class_weapon_set_skillTree:
  type: task
  debug: false
  script:
    - define hotkey <context.inventory.slot[46].flag[hotkey]>
    - define skillTree <context.item.flag[skillTree]>
    - run class_weapon_ability_selection_open def:<[hotkey]>|<[skillTree]>

#/#
#/#
#/#
class_weapon_ability_item:
  type: procedure
  debug: false
  definitions: input
  script:
    - define skill_script <server.flag[skills.abilities.<[input]>]>
    - define item <item[<[skill_script].data_key[display_item_script]>].with_flag[skill:<[skill_script].data_key[name]>].with_flag[run_script:class_weapon_set_skill]>
    - determine <[item]>

class_weapon_set_skill:
  type: task
  debug: false
  script:
    - define hotkey <context.inventory.slot[46].flag[hotkey]>
    - define skill <context.item.flag[skill]>
    - flag player hotkeys.<[hotkey]>:<[skill]>
    - run class_weapon_open

class_weapon_add_skill:
  type: task
  debug: false
  definitions: skillTree|skill
  script:
    - if !<server.has_flag[skills.trees.<[skillTree]>]>:
      - debug error "UNKNOWN SKILL TREE<&co> <[skillTree]>"
      - stop
    - if !<server.has_flag[skills.trees.<[skillTree]>.<[skill]>]>:
      - debug error "UNKNOWN SKILL<&co> <[skill]> in skillTree <[skillTree]>"
      - stop
    - define skill_script <server.flag[skills.trees.<[skillTree]>.<[skill]>]>
    - flag player skills.trees.<[skillTree]>.<[skill]>:<[skill_script]>
    - flag player skills.abilities.<[skill]>:<[skill_script]>

class_weapon_remove_skill:
  type: task
  debug: false
  definitions: skillTree|skill
  script:
    - if <player.has_flag[skills.trees.<[skillTree]>]>:
      - flag player skills.trees.<[skillTree]>.<[skill]>:!
      - if <player.flag[skills.trees.<[skillTree]>].is_empty>:
        - flag player skills.trees.<[skillTree]>:!
    - if !<player.has_flag[skills.abilities.<[skill]>]>:
      - flag player skills.abilities.<[skill]>:!

class_weapon_remove_skillTree:
  type: task
  debug: false
  definitions: skillTree
  script:
    - if <player.has_flag[skills.trees.<[skillTree]>]>:
      - foreach <player.flag[skills.trees.<[skillTree]>].keys> as:skill:
        - flag player skills.abilities.<[skill]>:!
      - flag player skills.trees.<[skillTree]>:!

class_weapon_add_skillTree:
  type: task
  debug: false
  definitions: skillTree
  script:
    - if <server.has_flag[skills.trees.<[skillTree]>]>:
      - foreach <server.flag[skills.trees.<[skillTree]>].keys.exclude[script]> as:skill:
        - flag player skills.abilities.<[skill]>:<server.flag[<server.flag[skills.tree.<[skillTree]>.<[skill]>]>]>
        - flag player skills.trees.<[skillTree]>.<[skill]>:<server.flag[<server.flag[skills.tree.<[skillTree]>.<[skill]>]>]>

class_weapon_use_event:
  type: world
  debug: false
  events:
    on player left clicks block with:item_flagged:class_weapon flagged:hotkeys bukkit_priority:LOW:
      - ratelimit <player> 2t
      - if <player.is_sprinting> && <player.has_flag[hotkeys.sprint_left]>:
        - run skill_core_use def:<player.flag[hotkeys.sprint_left]>
        - determine cancelled
      - else if <player.is_sneaking> && <player.has_flag[hotkeys.sneak_left]>:
        - run skill_core_use def:<player.flag[hotkeys.sneak_left]>
        - determine cancelled
      - else if <player.has_flag[hotkeys.left]> && !<player.is_sneaking> && !<player.is_sprinting>:
        - run skill_core_use def:<player.flag[hotkeys.left]>
        - determine cancelled
    on player right clicks block with:item_flagged:class_weapon flagged:hotkeys bukkit_priority:LOW:
      - ratelimit <player> 2t
      - if <player.is_sprinting> && <player.has_flag[hotkeys.sprint_right]>:
        - run skill_core_use def:<player.flag[hotkeys.sprint_right]>
        - determine cancelled
      - else if <player.is_sneaking> && <player.has_flag[hotkeys.sneak_right]>:
        - run skill_core_use def:<player.flag[hotkeys.sneak_right]>
        - determine cancelled
      - else if <player.has_flag[hotkeys.right]> && !<player.is_sneaking> && !<player.is_sprinting>:
        - run skill_core_use def:<player.flag[hotkeys.right]>
        - determine cancelled
    on player right clicks horse|villager with:item_flagged:class_weapon flagged:hotkeys bukkit_priority:LOW:
      - ratelimit <player> 2t
      - if <player.is_sprinting> && <player.has_flag[hotkeys.sprint_right]>:
        - run skill_core_use def:<player.flag[hotkeys.sprint_right]>
        - determine cancelled
      - else if <player.is_sneaking> && <player.has_flag[hotkeys.sneak_right]>:
        - run skill_core_use def:<player.flag[hotkeys.sneak_right]>
        - determine cancelled
      - else if <player.has_flag[hotkeys.right]> && !<player.is_sneaking> && !<player.is_sprinting>:
        - run skill_core_use def:<player.flag[hotkeys.right]>
        - determine cancelled
    on player swaps items offhand:item_flagged:class_weapon flagged:hotkeys bukkit_priority:LOW:
      - if <player.is_sprinting> && <player.has_flag[hotkeys.sprint_swap]>:
        - run skill_core_use def:<player.flag[hotkeys.sprint_swap]>
        - determine cancelled
      - else if <player.is_sneaking> && <player.has_flag[hotkeys.sneak_swap]>:
        - run skill_core_use def:<player.flag[hotkeys.sneak_swap]>
        - determine cancelled
      - else if <player.has_flag[hotkeys.swap]> && !<player.is_sneaking> && !<player.is_sprinting>:
        - run skill_core_use def:<player.flag[hotkeys.swap]>
        - determine cancelled
    on player drops item_flagged:class_weapon flagged:hotkeys bukkit_priority:LOW:
      - if <player.is_sprinting> && <player.has_flag[hotkeys.sprint_drop]>:
        - run skill_core_use def:<player.flag[hotkeys.sprint_drop]>
        - determine cancelled
      - else if <player.is_sneaking> && <player.has_flag[hotkeys.sneak_drop]>:
        - run skill_core_use def:<player.flag[hotkeys.sneak_drop]>
        - determine cancelled
      - else if <player.has_flag[hotkeys.drop]> && !<player.is_sneaking> && !<player.is_sprinting>:
        - run skill_core_use def:<player.flag[hotkeys.drop]>
        - determine cancelled

class_select:
  type: task
  debug: false
  definitions: class
  script:
    - if !<list[rogue|warrior|mage|ranger].contains[<[class]>]>:
      - narrate "<element[Unknown class - <[class]>].rainbow>"
      - stop
    - if <player.has_flag[class]>:
      - run class_weapon_remove_skillTree def:<player.flag[class]>
    - run class_weapon_add_skillTree def:<[class]>
    - flag player class:<[class]>

class_weapon_select:
  type: command
  name: select_class
  usage: /select_class (class)
  description: Selects Class
  tab completions:
    1: rogue|warrior|mage|ranger
  script:
    - if <context.args.size> < 1:
      - narrate "<element[You must specify a class, dumbass].rainbow>"
      - stop
    - if !<list[rogue|warrior|mage|ranger].contains[<context.args.get[1]>]>:
      - narrate "<element[Unknown class, dumbass].rainbow>"
      - stop
    - if <player.has_flag[class]>:
      - run class_weapon_remove_skillTree def:<player.flag[class]>
    - run class_weapon_add_skillTree def:<context.args.get[1]>
    - flag player class:<context.args.get[1]>

class_weapon_give:
  type: command
  name: class_weapon
  usage: /class_weapon
  description: turns held item into a class weapon
  script:
    - if <player.item_in_hand.material.name> == air:
      - narrate "<element[You have to be holding an item, dumbass].rainbow>"
      - stop
    - inventory flag slot:<player.held_item_slot> class_weapon:true

class_weapon_skills_command:
  type: command
  name: skills
  usage: /skills
  description: customize skills hotkeys
  script:
    - if <context.args.get[1]||null> == help:
      - narrate "<&b>/select_class <&a> chooses your class"
      - narrate "<&b>/skills <&a> chooses your hotkeys"
      - narrate "<&b>/class_weapon <&a> sets your held item as a class weapon"
      - stop
    - run class_weapon_open
