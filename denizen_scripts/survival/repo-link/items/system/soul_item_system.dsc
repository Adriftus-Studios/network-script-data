item_system_global_data:
  type: yaml data
  settings:
    lore:
      ## ---------------------------------- ##
      ##  Lore is built from these settings ##
      ## ---------------------------------- ##
      ##        AVAILABLE DEFINITIONS       ##
      ## <[item_type]> = armor, weapon, etc ##
      ##  <[damage]> = damage, for weapons  ##
      ########################################
      ##  .... I'mma finish this later..... ##
      ##  Probably.                         ##
      ########################################
      top:
      - "<&a>--------------------------"
      middle:
        global:
        - "<&e>Level<&co> <[level_stars]>"
        - ""
        weapons: <&e>Base Damage<&co> <&b><[damage]>
        armors: <&e>Base Armor<&co> <&b><[armor]>
        unique_buffs:
          sunfire: <&6>Sets attackers on fire.
          life_saving: <&6>Prevents death, and heals you (10 minute CD)
          survival: <&6>Prevents you from getting hungry.
        buffs:
          melee_damage: <&7>Melee Damage <&a>+<[final_value]>
          ranged_damage: <&7>Ranged Damage <&a>+<[final_value]>
          speed: <&7>Move Speed <&a>+<[final_value]./[0.1].round_to[3].mul[100]>%
          armor: <&7>Armor <&a>+<[final_value]>
          attack_speed: <&7>Attack Speed <&a>+<[final_value]./[4].round_to[2].mul[100]>%
          health: <&7>Health <&a>+<[final_value]>
        debuffs:
          melee_damage: <&7>Melee Damage <&c>-<[final_value]>
          ranged_damage: <&7>Ranged Damage <&c>-<[final_value]>
          speed: <&7>Move Speed <&c>-<[final_value]./[0.1].round_to[3].mul[100]>%
          armor: <&7>Armor <&c>-<[final_value]>
          attack_speed: <&7>Attack Speed <&c>-<[final_value]./[4].round_to[2].mul[100]>%
          health: <&7>Health <&c>-<[final_value]>
        flavor:
          - "<&7>"
          - "<&e><[flavor]>"
      bottom:
        - "<&a>--------------------------"
    rarity_colors:
      0: <&7>
      1: <&a>
      2: <&b>
      3: <&5>
      4: <&6>
      5: <&4>
  soul_names:
    ####### COMMON #######
    ######## buff ########
    0:
      basher: melee_damage/buff
      sprinter: speed/buff
      cow: health/buff
    ###### UNCOMMON ######
    ## buff/buff/debuff ##
    1:
      barbarian: melee_damage/buff|ranged_damage/buff|speed/debuff
      kamikaze: melee_damage/buff|ranged_damage/buff|health/debuff
      beater: melee_damage/buff|ranged_damage/buff|attack_speed/debuff
      silverstrike: melee_damage/buff|speed/buff|health/debuff
      bear: health/buff|melee_damage/buff|attack_speed/debuff
      soldier: health/buff|ranged_damage/buff|attack_speed/debuff
      scout: health/buff|speed/buff|armor/debuff
      horse: speed/buff|attack_speed/buff|melee_damage/debuff
      monkey: speed/buff|ranged_damage/buff|health/debuff
      turtle: health/buff|armor/buff|speed/debuff
    ###### RARE ######
    #### buff/buff ###
    2:
      swordsman: attack_speed/buff|health/buff
      assassin: attack_speed/buff|armor/buff
      warrior: melee_damage/buff|health/buff
      ranger: ranged_damage/buff|health/buff
      tank: ranged_damage/buff|armor/buff
      quicksilver: speed/buff|health/buff
      tortoise: armor/buff|health/buff
  ## INTERNALS ##
  calculations:
    melee_damage: <[level].*[3]>
    ranged_damage: <[level].*[2]>
    speed: <[level].*[0.005]>
    armor: <[level]>
    attack_speed: <[level].*[.15]>
    health: <[level].+[4]>
  nbt_attributes:
    melee_damage: generic.attack_damage
    speed: generic.movement_speed
    armor: generic.armor
    attack_speed: generic.attack_speed
    health: generic.max_health
  nbt_other:
    ranged_damage: bow_damage
  nbt_slots:
    netherite_sword: mainhand
    diamond_sword: mainhand
    iron_sword: mainhand
    wooden_sword: mainhand
    stone_sword: mainhand
    diamond_axe: mainhand
    iron_axe: mainhand
    wooden_axe: mainhand
    stone_axe: mainhand
    trident: mainhand
    diamond_helmet: head
    diamond_chestplate: chest
    diamond_leggings: legs
    diamond_boots: feet
    iron_helmet: head
    iron_chestplate: chest
    iron_leggings: legs
    iron_boots: feet
    leather_helmet: head
    leather_chestplate: chest
    leather_leggings: legs
    leather_boots: feet
    netherite_helmet: head
    netherite_chestplate: chest
    netherite_leggings: legs
    netherite_boots: feet
  regex_type_check:
    weapon: (.*)_(axe|sword)
    armor:  (.*)_(chestplate|leggings|boots|helmet|shell)
    weapon_or_armor: (.*)_(axe|sword|chestplate|leggings|boots|helmet)
  defaults:
    damage:
      wooden_sword: 4
      golden_sword: 4
      stone_sword: 5
      iron_sword: 6
      diamond_sword: 7
      netherite_sword: 8
    armor:
      turtle_shell: 2
      leather_chestplate: 3
      leather_helmet: 1
      leather_leggings: 2
      leather_boots: 1
      golden_chestplate: 5
      golden_helmet: 2
      golden_leggings: 4
      golden_boots: 1
      chainmail_chestplate: 5
      chainmail_helmet: 2
      chainmail_leggings: 4
      chainmail_boots: 1
      iron_chestplate: 6
      iron_helmet: 2
      iron_leggings: 5
      iron_boots: 2
      diamond_chestplate: 8
      diamond_helmet: 3
      diamond_leggings: 6
      diamond_boots: 3
      netherite_chestplate: 8
      netherite_helmet: 3
      netherite_leggings: 6
      netherite_boots: 3

################
## SOUL FORGE ##
################
soul_forge_inventory:
  type: inventory
  title: <&5>Soul Forge
  inventory: chest
  size: 45
  definitions:
    grayfiller: <item[gray_stained_glass_pane].with[display_name=<&e>]>
    redfiller: <item[red_stained_glass_pane].with[display_name=<&e>]>
    blackfiller: <item[black_stained_glass_pane].with[display_name=<&e>]>
  slots:
   - "[grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller]"
   - "[redfiller] [redfiller] [redfiller] [blackfiller] [blackfiller] [blackfiller] [redfiller] [redfiller] [redfiller]"
   - "[redfiller] [] [redfiller] [blackfiller] [grayfiller] [blackfiller] [redfiller] [] [redfiller]"
   - "[redfiller] [redfiller] [redfiller] [blackfiller] [blackfiller] [blackfiller] [redfiller] [redfiller] [redfiller]"
   - "[grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller]"


soul_forge_events:
  type: world
  events:
    on player clicks gray_stained_glass_pane|red_stained_glass_pane|black_stained_glass_pane|player_head in soul_forge_inventory priority:-2000:
      - determine cancelled
    on player clicks item in soul_forge_inventory:
      - if <context.raw_slot> == 23 && <context.inventory.slot[23].material.name||air> != gray_stained_glass_pane:
        - wait 1t
        - foreach <list[20|26]> as:slot:
          - if <context.inventory.slot[<[slot]>].quantity> == 1:
            - take <context.inventory.slot[<[slot]>]> from:<context.inventory>
          - else:
            - inventory set slot:<[slot]> d:<context.inventory> o:<context.inventory.slot[<[slot]>].with[quantity=<context.inventory.slot[<[slot]>].quantity.-[1]>]>
        - inventory set slot:23 d:<context.inventory> o:<item[gray_stained_glass_pane].with[display_name=<&e>]>
    after player clicks in soul_forge_inventory:
      - ratelimit <player> 1t
      - inventory set slot:23 d:<context.inventory> o:<proc[item_with_soul_create].context[<context.inventory.slot[20]>|<context.inventory.slot[26]>]>
    on player opens soul_forge_inventory:
      - inventory set d:<context.inventory> slot:5 "o:<item[player_head].with[skull_skin=<player.uuid>;display_name=<&d>        Soul Forge;lore=<&5>---------------------|<&a>|<&e>Place a <&b>soul<&e> on the left|<&a>|<&e>Place an <&a>item<&e> on the right]>"
    on player closes soul_forge_inventory:
      - foreach <list[20|26]>:
        - if <context.inventory.slot[<[value]>].material.name> != air:
          - give <context.inventory.slot[<[value]>]> to:<player.inventory>
soul_forge_command:
  type: command
  name: open_soul_forge
  permission: not.a.perm
  script:
    - inventory open d:soul_forge_inventory player:<server.match_player[<context.args.get[1]>]>
#################
## SOUL SYSTEM ##
#################

soul:
  type: item
  material: clay_ball
  display_name: <&c>ERROR - REPORT THIS
  mechanisms:
    enchantments: luck,1
    flags: HIDE_ENCHANTS
  lore_type: <&d>Soul Item

item_with_soul:
  type: item
  material: diamond_sword
  display name: <&c>ERROR - REPORT THIS

get_random_soul:
  type: procedure
  definitions: rarity|level
  script:
    - define soul_type <script[item_system_global_data].list_keys[soul_names.<[rarity]>].random>
    - foreach <script[item_system_global_data].yaml_key[soul_names.<[rarity]>.<[soul_type]>]> as:modifier:
      - define stat <[modifier].before[/]>
      - define type <[modifier].after[/]>
      - if <[type]> == buff:
        - define buffs:|:<[stat]>,<script[item_system_global_data].yaml_key[calculations.<[stat]>].parsed>
      - else:
        - define debuffs:|:<[stat]>,<script[item_system_global_data].yaml_key[calculations.<[stat]>].parsed>
    - if <[buffs]||null> != null:
      - define buffs_and_debuffs:|:buffs/<[buffs].escaped>
    - if <[debuffs]||null> != null:
      - define buffs_and_debuffs:|:debuffs/<[debuffs].escaped>
    - define flavor:<element[<&d>Soul&spItem<&nl><&e>Combine&spwith&spArmor&spor&spWeapons].escaped>
    - determine <proc[item_system_build_item].context[<item[soul].with[nbt=soul/<[soul_type]>,<[level]>|rarity/<[rarity]>|soul_level/<[level]>|active_soul/<[soul_type]>|flavor/<[flavor]>|<[buffs_and_debuffs].separated_by[|]>]>]>

item_with_soul_create:
  type: procedure
  definitions: item1|item2
  script:
    - if <[item1].material.name> == air || <[item2].material.name> == air:
      - determine gray_stained_glass_pane
    - if !<list[<[item1]>|<[item2]>].filter[material.name.is[==].to[<script[soul].yaml_key[material]>]].get[1].has_nbt[soul]>:
      - determine gray_stained_glass_pane
    - define soul_item <list[<[item1]>|<[item2]>].filter[has_nbt[soul]].get[1]>
    - define soul_type <[soul_item].nbt[soul].before[,]>
    - define soul_level <[soul_item].nbt[soul].after[,]>
    - define rarity <[soul_item].nbt[rarity]>
    - define item <list[<[item1]>|<[item2]>].filter[has_nbt[soul].not].get[1].material.name>
    - define enchants <list[<[item1]>|<[item2]>].filter[has_nbt[soul].not].get[1].enchantments.with_levels.escaped||<list[]>>
    - determine <proc[item_create_soul_item].context[<[item]>|<[soul_type]>|<[soul_level]>|<[rarity]>|<[enchants]>]>

item_create_soul_item:
  type: procedure
  definitions: material|soul_type|level|rarity|enchants_escaped
  script:
    - if <[material].matches[<script[item_system_global_data].yaml_key[regex_type_check.weapon]>]>:
      - define base <script[item_system_global_data].yaml_key[defaults.damage.<[material]>]>
    - foreach <script[item_system_global_data].yaml_key[soul_names.<[rarity]>.<[soul_type]>]> as:modifier:
      - define stat <[modifier].before[/]>
      - define type <[modifier].after[/]>
      - if <[type]> == buff:
        - define buffs:|:<[stat]>,<script[item_system_global_data].yaml_key[calculations.<[stat]>].parsed>
      - else:
        - define debuffs:|:<[stat]>,<script[item_system_global_data].yaml_key[calculations.<[stat]>].parsed>
    - if <[enchants_escaped].unescaped.as_list.size||0> >= 1:
      - define item_to_build <item[<[material]>].with[enchantments=<[enchants_escaped].unescaped>;nbt=buffs/<[buffs].escaped||none>|debuffs/<[debuffs].escaped||none>|rarity/<[rarity]>|soul_level/<[level]>|active_soul/<[soul_type]>]>
    - else:
      - define item_to_build <item[<[material]>].with[nbt=buffs/<[buffs].escaped||none>|debuffs/<[debuffs].escaped||none>|rarity/<[rarity]>|soul_level/<[level]>|active_soul/<[soul_type]>]>
    - determine <proc[item_system_build_item].context[<[item_to_build]>]>

# TODO - Make This WAY less fucking stupid.
# Lore should be built off the nbt "applicable_lore", in a foreach loop properly
# This is some AJ level shit....
item_system_build_item:
  type: procedure
  definitions: item
  script:
    - define level <[item].nbt[soul_level]||0>
    - if <[level]> != 0:
      - define level_stars <list[].pad_right[<[level]>].with[<&e>✭].pad_right[5].with[<&7>✭].unseparated>
    - else:
      - define level_stars <list[].pad_right[5].with[<&7>✭].unseparated>
    - define base <script[item_system_global_data].yaml_key[defaults.damage.<[item].material.name>]||0>
    - if <[item].has_nbt[buffs]> && <[item].material.name> != <script[soul].yaml_key[material]> && <[item].nbt[buffs]||none> != none:
      - foreach <[item].nbt[buffs].unescaped.as_list> as:buff:
        - if <script[item_system_global_data].yaml_key[nbt_attributes.<[buff].before[,]>]||null> != null:
          - define attribute <script[item_system_global_data].yaml_key[nbt_attributes.<[buff].before[,]>]>
          - define slot <script[item_system_global_data].yaml_key[nbt_slots.<[item].material.name>]>
          - if <[buff].before[,]> == melee_damage:
            - define value <[buff].after[,].+[<[base]>]>
          - else:
            - define value <[buff].after[,]>
          - define nbt_attributes:|:<[attribute]>/<[slot]>/0/<[value]>
        - else:
          - define value <[buff].after[,]>
          - define nbt:|:<script[item_system_global_data].yaml_key[nbt_other.<[buff].before[,]>]>/<[value]>
    - if <[item].has_nbt[debuffs]> && <[item].material.name> != <script[soul].yaml_key[material]> && <[item].nbt[debuffs]||none> != none:
      - foreach <[item].nbt[debuffs].unescaped.as_list> as:debuff:
        - if <script[item_system_global_data].yaml_key[nbt_attributes.<[debuff].before[,]>]||null> != null:
          - define attribute <script[item_system_global_data].yaml_key[nbt_attributes.<[debuff].before[,]>]>
          - define slot <script[item_system_global_data].yaml_key[nbt_slots.<[item].material.name>]>
          - if <[debuff].before[,]> == melee_damage:
            - define value <[debuff].after[,].+[<[base]>]>
          - else:
            - define value <[debuff].after[,]>
          - define nbt_attributes:|:<[attribute]>/<[slot]>/0/-<[value]>
        - else:
          - define value <[debuff].after[,]>
          - define nbt:|:<script[item_system_global_data].yaml_key[nbt_other.<[debuff].before[,]>]>/<[value]>
    - define rarity_color <script[item_system_global_data].yaml_key[settings.rarity_colors.<[item].nbt[rarity]||0>].parsed>
    # TODO - Clean this up, and turn it into a loop using nbt[applicable_lore]
    - define name1 <[item].script.name||<[item].material.name>>
    - if <[item].has_nbt[active_soul]>:
      - define "name:<[rarity_color]><[name1].replace[_].with[<&sp>].to_titlecase> of the <[item].nbt[active_soul].to_titlecase>"
    - else:
      - define "name:<[rarity_color]><[name1].replace[_].with[<&sp>].to_titlecase>"
    #- define lore:|:<script[item_system_global_data].yaml_key[settings.lore.top].parse[parsed]>
    - define lore:|:<script[item_system_global_data].yaml_key[settings.lore.middle.global].parse[parsed]>
    - if <[item].material.name.matches[<script[item_system_global_data].yaml_key[regex_type_check.weapon]>]>:
      - define damage <script[item_system_global_data].yaml_key[defaults.damage.<[item].material.name>]>
      - define lore:|:<script[item_system_global_data].yaml_key[settings.lore.middle.weapons].parsed>
    - if <[item].material.name.matches[<script[item_system_global_data].yaml_key[regex_type_check.armor]>]>:
      - define armor <script[item_system_global_data].yaml_key[defaults.armor.<[item].material.name>]>
      - define lore:|:<script[item_system_global_data].yaml_key[settings.lore.middle.armors].parsed>
    ##- if <[item].nbt[buffs].unescaped.as_list||<[item].nbt[soul_buffs].unescaped.as_list||null>> != null:
    ##  - define lore:|:<&a>Buffs
    - foreach <[item].nbt[buffs].unescaped.as_list||<[item].nbt[soul_buffs].unescaped.as_list||<list[]>>> as:buff:
      - if <[buff]> == none:
        - foreach next
      - define final_value <[buff].after[,]>
      - define lore:|:<script[item_system_global_data].yaml_key[settings.lore.middle.buffs.<[buff].before[,]>].parsed>
    - foreach <[item].nbt[debuffs].unescaped.as_list||<[item].nbt[soul_debuffs].unescaped.as_list||<list[]>>> as:debuff:
      - if <[debuff]> == none:
        - foreach next
      - define final_value <[debuff].after[,]>
      - define lore:|:<script[item_system_global_data].yaml_key[settings.lore.middle.debuffs.<[debuff].before[,]>].parsed>
    - if <[item].has_nbt[flavor]>:
      - define flavor <[item].nbt[flavor].unescaped>
      - define lore:|:<script[item_system_global_data].yaml_key[settings.lore.middle.flavor].parse[parsed]>
    #- define lore:|:<script[item_system_global_data].yaml_key[settings.lore.bottom].parse[parsed]>
    - if <[nbt]||null> != null:
      - define final:|:nbt=<[nbt]>
    - if <[nbt_attributes]||null> != null:
      - define final:|:nbt_attributes=<[nbt_attributes].separated_by[$]>
    - determine <[item].with[display_name=<[name]>;lore=<[lore]>;flags=HIDE_ALL;<[final].separated_by[;].replace[$].with[|]||nbt=vanilla/true>]>
    
vanilla_craft_item_build:
  type: world
  events:
    on player crafts *_(sword|axe|chestplate|leggings|boots|helmet) bukkit_priority:HIGHEST:
      - if <context.item.display||null> == null:
        - determine <proc[item_system_build_item].context[<context.item>]>

    
vanilla_craft_item_build2:
  type: world
  events:
    on player crafts diamond_sword bukkit_priority:HIGHEST:
      - if <context.item.display||null> == null:
        - determine <proc[item_system_build_item].context[<context.item>]>