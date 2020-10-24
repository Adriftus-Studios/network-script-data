item_system_global_data:
  type: data
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
      - <&a>--------------------------
      middle:
        global:
        - <&e>Level<&co> <[level_stars]>
        - <empty>
        weapons: <&e>Base Damage<&co> <&b><[base]>
        armors: <&e>Base Armor<&co> <&b><[base]>
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
          - <empty>
          - <&e><[flavor]>
      bottom:
        - <&a>--------------------------
    rarity_colors:
      0: <&7>
      1: <&a>
      2: <&b>
      3: <&5>
      4: <&6>
      5: <&4>
    rarity_colors_named:
      0: Gray
      1: Lime
      2: Blue
      3: Purple
      4: Yellow
      5: Red
  soul_names:
    ####### COMMON #######
    ######## buff ########
    0:
      armadillo:
        armor: buff
      rusher:
        attack_speed: buff
      cow:
        health: buff
      basher:
        melee_damage: buff
      hawk:
        ranged_damage: buff
      sprinter:
        speed: buff
    ###### UNCOMMON ######
    ## buff/buff/debuff ##
    1:
      fighter:
        armor: buff
        attack_speed: buff
        health: debuff
      frontier:
        armor: buff
        attack_speed: buff
        ranged_damage: debuff
      wyvern:
        armor: buff
        health: buff
        ranged_damage: debuff
      turtle:
        armor: buff
        health: buff
        speed: debuff
      journeyman:
        armor: buff
        melee_damage: buff
        health: debuff
      sniper:
        armor: buff
        ranged_damage: buff
        speed: debuff
      knight:
        attack_speed: buff
        health: buff
        ranged_damage: debuff
      naive:
        attack_speed: buff
        melee_damage: buff
        armor: debuff
      horse:
        attack_speed: buff
        speed: buff
        melee_damage: debuff
      bear:
        health: buff
        melee_damage: buff
        attack_speed: debuff
      cleric:
        health: buff
        ranged_damage: buff
        armor: debuff
      soldier:
        health: buff
        ranged_damage: buff
        attack_speed: debuff
      scout:
        health: buff
        speed: buff
        armor: debuff
      beater:
        melee_damage: buff
        ranged_damage: buff
        attack_speed: debuff
      kamikaze:
        melee_damage: buff
        ranged_damage: buff
        health: debuff
      barbarian:
        melee_damage: buff
        ranged_damage: buff
        speed: debuff
      pegasus:
        melee_damage: buff
        speed: buff
        armor: debuff
      silverstrike:
        melee_damage: buff
        speed: buff
        health: debuff
      monkey:
        ranged_damage: buff
        speed: buff
        health: debuff
      valkyrie:
        ranged_damage: buff
        speed: buff
        armor: debuff
    ###### RARE ######
    #### buff/buff ###
    2:
      tortoise:
        armor: buff
        health: buff
      paladin:
        armor: buff
        melee_damage: buff
      chief:
        armor: buff
        ranged_damage: buff
      steamroller:
        armor: buff
        speed: buff
      assassin:
        attack_speed: buff
        armor: buff
      swordsman:
        attack_speed: buff
        health: buff
      sabre:
        attack_speed: buff
        melee_damage: buff
      warrior:
        melee_damage: buff
        health: buff
      pirate:
        melee_damage: buff
        speed: buff
      tank:
        ranged_damage: buff
        armor: buff
      ranger:
        ranged_damage: buff
        health: buff
      quicksilver:
        speed: buff
        health: buff
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
  debug: false
  title: <&5>Soul Forge
  inventory: chest
  size: 45
  definitions:
    grayfiller: <item[gray_stained_glass_pane].with[display_name=<&e>]>
    redfiller: <item[red_stained_glass_pane].with[display_name=<&e>]>
    blackfiller: <item[black_stained_glass_pane].with[display_name=<&e>]>
  slots:
   - [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller]
   - [redfiller] [redfiller] [redfiller] [blackfiller] [blackfiller] [blackfiller] [redfiller] [redfiller] [redfiller]
   - [redfiller] [] [redfiller] [blackfiller] [grayfiller] [blackfiller] [redfiller] [] [redfiller]
   - [redfiller] [redfiller] [redfiller] [blackfiller] [blackfiller] [blackfiller] [redfiller] [redfiller] [redfiller]
   - [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller] [grayfiller]


soul_forge_events:
  type: world
  debug: false
  events:
    on player clicks gray_stained_glass_pane|red_stained_glass_pane|black_stained_glass_pane|player_head in soul_forge_inventory priority:-2000:
      - determine cancelled
    on player clicks item in soul_forge_inventory:
      - if <context.raw_slot> == 23 && <context.inventory.slot[23].material.name> != gray_stained_glass_pane:
        - wait 1t
        - foreach 20|26 as:slot:
          - if <context.inventory.slot[<[slot]>].quantity> == 1:
            - take <context.inventory.slot[<[slot]>]> from:<context.inventory>
          - else:
            - inventory set slot:<[slot]> d:<context.inventory> o:<context.inventory.slot[<[slot]>].with[quantity=<context.inventory.slot[<[slot]>].quantity.-[1]>]>
        - inventory set slot:23 d:<context.inventory> o:<item[gray_stained_glass_pane].with[display_name=<&e>]>
    after player clicks in soul_forge_inventory:
      - ratelimit <player> 1t
      - inventory set slot:23 d:<context.inventory> o:<proc[item_with_soul_create].context[<context.inventory.slot[20]>|<context.inventory.slot[26]>]>
    on player opens soul_forge_inventory:
      - inventory set d:<context.inventory> slot:5 "o:<item[player_head].with[skull_skin=<player.uuid>;display_name=<&d>        Soul Forge;lore=<&5>---------------------|<empty>|<&e>Place a <&b>soul<&e> on the left|<empty>|<&e>Place an <&a>item<&e> on the right]>"
    on player closes soul_forge_inventory:
      - foreach 20|26:
        - if <context.inventory.slot[<[value]>].material.name> != air:
          - give <context.inventory.slot[<[value]>]> to:<player.inventory>
    on player right clicks block in:soul_forge:
    - inventory open d:soul_forge_inventory
soul_forge_command:
  type: command
  debug: false
  name: open_soul_forge
  permission: adriftus.admin
  script:
    - inventory open d:soul_forge_inventory player:<server.match_player[<context.args.first>]>
#################
## SOUL SYSTEM ##
#################

soul:
  type: item
  debug: false
  material: firework_star
  display_name: <&c>ERROR - REPORT THIS
  mechanisms:
    enchantments: luck,1
    flags: ENCHANTS
  lore_type: <&d>Soul Item

item_with_soul:
  type: item
  debug: false
  material: diamond_sword
  display name: <&c>ERROR - REPORT THIS
get_random_soul:
  type: procedure
  debug: false
  definitions: rarity|level
  script:
    - define buffs <list>
    - define debuffs <list>
    - define soul_type <script[item_system_global_data].list_keys[soul_names.<[rarity]>].random>

    - define NBT <list_single[soul/<map.with[type].as[<[soul_type]>].with[level].as[<[level]>]>]>
    - define NBT <[NBT].include_single[rarity/<[rarity]>].include_single[soul_level/<[level]>].include_single[active_soul/<[soul_type]>]>
    - foreach <script[item_system_global_data].data_key[soul_names.<[rarity]>.<[soul_type]>]> key:stat as:type:
      - if <[type]> == buff:
        - define buffs <[buffs].include_single[<map.with[<[stat]>].as[<script[item_system_global_data].parsed_key[calculations.<[stat]>]>]>]>
      - else:
        - define debuffs <[debuffs].include_single[<map.with[<[stat]>].as[<script[item_system_global_data].parsed_key[calculations.<[stat]>]>]>]>
    - if !<[buffs].is_empty>:
      - define NBT <[NBT].include_single[buffs/<[buffs]>]>
    - if !<[debuffs].is_empty>:
      - define NBT <[NBT].include_single[debuffs/<[debuffs]>]>
    - define flavor "<&d>Soul Item<&nl><&e>Combine with Armor or Weapons"
    - define NBT <[NBT].include_single[flavor/<[flavor]>]>
    - define item <item[soul].with[nbt=<[NBT]>]>
    - determine <proc[item_system_build_item].context[<list_single[<[item]>]>]>

item_with_soul_create:
  type: procedure
  debug: false
  definitions: item1|item2
  script:
    - if <[item1].material.name> == air || <[item2].material.name> == air:
      - determine gray_stained_glass_pane
    - if <list[<[item1]>].include[<[item2]>].filter[has_nbt[soul]].is_empty>:
      - determine gray_stained_glass_pane
    - define soul_item <list[<[item1]>].include[<[item2]>].filter[has_nbt[soul]].first>
    - define contexts <list.include_single[<list[<[item1]>|<[item2]>].filter[has_nbt[soul].not].first.material.name>]>
    - define contexts <[contexts].include_single[<[soul_item].nbt[soul].as_map.get[type]>]>
    - define contexts <[contexts].include_single[<[soul_item].nbt[soul].as_map.get[level]>]>
    - define contexts <[contexts].include_single[<[soul_item].nbt[rarity]>]>
    - define contexts <[contexts].include_single[<list_single[<[item1]>].include_single[<[item2]>].parse_tag[<[parse_value].enchantments.with_levels>].combine.deduplicate>]>
    - determine <proc[item_create_soul_item].context[<[contexts]>]>

item_create_soul_item:
  type: procedure
  debug: false
  definitions: material|soul_type|level|rarity|enchantments
  script:
    - if <[material].matches[<script[item_system_global_data].data_key[regex_type_check.weapon]>]>:
      - define base <script[item_system_global_data].data_key[defaults.damage.<[material]>]>
    - foreach <script[item_system_global_data].data_key[soul_names.<[rarity]>.<[soul_type]>]> key:stat as:type:
      - if <[type]> == buff:
        - define buffs:->:<map.with[<[stat]>].as[<script[item_system_global_data].parsed_key[calculations.<[stat]>]>]>
      - else:
        - define debuffs:->:<map.with[<[stat]>].as[<script[item_system_global_data].parsed_key[calculations.<[stat]>]>]>
    - if !<[enchantments].is_empty>:
      - define item_to_build <item[<[material]>].with[enchantments=<[enchantments]>;nbt=<list_single[buffs/<[buffs]||none>].include_single[debuffs/<[debuffs]||none>].include_single[rarity/<[rarity]>].include_single[soul_level/<[level]>].include_single[active_soul/<[soul_type]>]>]>
    - else:
      - define item_to_build <item[<[material]>].with[nbt=buffs/<[buffs].merge_maps||none>|debuffs/<[debuffs].merge_maps||none>|rarity/<[rarity]>|soul_level/<[level]>|active_soul/<[soul_type]>]>
    - determine <proc[item_system_build_item].context[<[item_to_build]>]>

# TODO - Make This WAY less fucking stupid.
# Lore should be built off the nbt applicable_lore, in a foreach loop properly
# This is some AJ level shit....
item_system_build_item:
  type: procedure
  definitions: item
  debug: false
  script:
    - define item <[item].as_item>
  # % ██ [ Determine the amount of Stars  ] ██
    - if <[item].has_nbt[soul_level]>:
      - define level <[item].nbt[soul_level]>
      - define level_stars <list.pad_right[<[level]>].with[<&e>✭].pad_right[5].with[<&7>✭].unseparated>
    - else:
      - define level 0
      - define level_stars <list.pad_right[5].with[<&7>✭].unseparated>

  # % ██ [ Determine the base of the item?  ] ██
    - if <script[item_system_global_data].list_keys[defaults.damage].contains[<[item].material.name>]>:
      - define base <script[item_system_global_data].data_key[defaults.damage.<[item].material.name>]>
    - else:
      - define base 0

  # % ██ [ Determine the NBT_Attributes  ] ██
    - define nbt <list>
    - define nbt_attributes <list>
    - foreach buffs|debuffs as:modifier:
      - if <[item].has_nbt[<[modifier]>]> && <[item].material.name> != <script[soul].data_key[material]> && <[Item].nbt[<[modifier]>]> != none:
        - foreach <[item].nbt[<[modifier]>].as_list.merge_maps> key:alt as:stat:
          - if <script[item_system_global_data].data_key[nbt_attributes].contains[<[alt]>]>:
            - define attribute <script[item_system_global_data].data_key[nbt_attributes.<[alt]>]>
            - define slot <script[item_system_global_data].data_key[nbt_slots.<[item].material.name>]>
            - if <[alt]> == melee_damage:
              - if <[Modifier]> == buff:
                - define nbt_attributes <[nbt_attributes].include[<[attribute]>/<[slot]>/0/<[stat].add[<[base]>]>]>
              - else:
                - define nbt_attributes <[nbt_attributes].include[<[attribute]>/<[slot]>/0/<[stat].sub[<[base]>]>]>
            - else:
              - define nbt_attributes <[nbt_attributes].include[<[attribute]>/<[slot]>/0/<[stat]>]>
          - else:
            - define nbt <[nbt].include_single[<script[item_system_global_data].data_key[nbt_other.<[alt]>]>/<[alt]>]>

  # % ██ [ Determine Misc Item Properties  ] ██
    - if <[Item].has_script>:
      - define sn1 <[item].script.name>
    - else:
      - define sn1 <[Item].material.name>

    - if <[Item].has_nbt[rarity]>:
      - define rarity_color <script[item_system_global_data].parsed_key[settings.rarity_colors.<[item].nbt[rarity]>]>
    - else:
      - define rarity_color <script[item_system_global_data].parsed_key[settings.rarity_colors.0]>
    # TODO - Clean this up, and turn it into a loop using nbt[applicable_lore]

    - if <[item].has_nbt[active_soul]>:
      - define name "<[rarity_color]><[sn1].replace[_].with[<&sp>].to_titlecase> of the <[item].nbt[active_soul].to_titlecase>"
    - else:
      - define name <[rarity_color]><[sn1].replace[_].with[<&sp>].to_titlecase>


    - define lore <list.include[<script[item_system_global_data].parsed_key[settings.lore.top]>]>
    - define lore <[lore].include[<script[item_system_global_data].parsed_key[settings.lore.middle.global]>]>
    - if <[item].material.name.matches[<script[item_system_global_data].data_key[regex_type_check.weapon]>]>:
      - define damage <script[item_system_global_data].data_key[defaults.damage.<[item].material.name>]>
      - define lore <[Lore].include[<script[item_system_global_data].parsed_key[settings.lore.middle.weapons]>]>

    - if <[item].material.name.matches[<script[item_system_global_data].data_key[regex_type_check.armor]>]>:
      - define armor <script[item_system_global_data].data_key[defaults.armor.<[item].material.name>]>
      - define lore <[Lore].include[<script[item_system_global_data].parsed_key[settings.lore.middle.armors]>]>

    - foreach buffs|debuffs as:modifier:
      - if <[item].has_nbt[<[modifier]>]>:
        - foreach <[item].nbt[<[modifier]>]> as:Modifiers:
          - foreach <[Modifiers]> key:alt as:final_value:
            - if <[alt]> == none:
                - foreach next
            - define lore <[Lore].include_single[<script[item_system_global_data].parsed_key[settings.lore.middle.<[modifier]>.<[alt]>]>]>

    - if <[item].has_nbt[flavor]>:
      - define flavor <[item].nbt[flavor]>
      - define lore <[Lore].include[<script[item_system_global_data].parsed_key[settings.lore.middle.flavor]>]>
    - define lore <[lore].include[<script[item_system_global_data].parsed_key[settings.lore.bottom]>]>

    - define NewItem <[item].with[display_name=<[name]>;lore=<[lore]>;hides=ATTRIBUTES]>
    - if !<[nbt].is_empty>:
      - define NewItem <[NewItem].with[nbt=<[nbt]>]>
    - else:
      - define NewItem <[NewItem].with[nbt=vanilla/true]>

    - if !<[nbt_attributes].is_empty>:
      - define NewItem <[NewItem].with[nbt_attributes=<[nbt_attributes]>]>

    - determine <[NewItem]>
    
vanilla_craft_item_build:
  type: world
  debug: false
  events:
    on player crafts *_(sword|axe|chestplate|leggings|boots|helmet) bukkit_priority:HIGHEST:
      - if !<context.item.has_display>:
        - determine <proc[item_system_build_item].context[<context.item>]>
    
vanilla_craft_item_build2:
  type: world
  debug: false
  events:
    on player crafts diamond_sword bukkit_priority:HIGHEST:
      - if !<context.item.has_display>:
        - determine <proc[item_system_build_item].context[<context.item>]>
