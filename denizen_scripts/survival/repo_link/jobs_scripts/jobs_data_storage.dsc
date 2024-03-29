Jobs_data_script:
  type: data
  debug: false

#TODO Jobs List
  jobs_list:
##Stored this way so we can use <script[Jobs_data_script].list_keys[jobs_list]> because im lazy.
    Blacksmith: 1
    Brewer: 1
    Lumberjack: 1
    Miner: 1
    Farmer: 1
    Enchanter: 1
    Hunter: 1
    Chef: 1
    Excavator: 1
    Fisher: 1


#TODO Blacksmith
  blacksmith:
    icon: anvil
    difficulty_level: 1

    smelt_item:
      iron_ingot:
        money: 3
        experience: 4
      gold_ingot:
        money: 5
        experience: 4
      netherite_scrap:
        money: 5
        experience: 10
    craft_item:
      per_leather: 1.2
      leather_helmet:
        money: 5
        experience: 10
      leather_Chestplate:
        money: 8
        experience: 16
      leather_Leggings:
        money: 7
        experience: 14
      leather_Boots:
        money: 4
        experience: 8
      per_iron: 1.8.3.5
      iron_helmet:
        money: 9
        experience: 17.5
      iron_Chestplate:
        money: 14.4
        experience: 28
      iron_Leggings:
        money: 12.6
        experience: 24.5
      iron_Boots:
        money: 7.2
        experience: 14
      per_gold: 2.25.4
      golden_helmet:
        money: 11.25
        experience: 20
      golden_Chestplate:
        money: 18
        experience: 32
      golden_Leggings:
        money: 15.75
        experience: 28
      golden_Boots:
        money: 9
        experience: 16
      per_diamond: 3.0.4.5
      diamond_helmet:
        money: 15
        experience: 22.5
      diamond_Chestplate:
        money: 24
        experience: 36
      diamond_Leggings:
        money: 21
        experience: 31.5
      diamond_Boots:
        money: 12
        experience: 18
      stone_sword:
        money: 2
        experience: 4
      iron_sword:
        money: 3.6
        experience: 7
      golden_sword:
        money: 4.5
        experience: 8
      diamond_sword:
        money: 6
        experience: 9
      stone_axe:
        money: 2
        experience: 4
      iron_axe:
        money: 5.4
        experience: 10.5
      golden_axe:
        money: 6.75
        experience: 12
      diamond_axe:
        money: 9
        experience: 13.5

#TODO Brewer
  brewer:
    icon: brewing_stand
    difficulty_level: 1

    brew_item:
      nether_wart:
        money: 3
        experience: 3
      redstone:
        money: 3
        experience: 3
      glowstone_dust:
        money: 4
        experience: 4
      fermented_spider_eye:
        money: 6
        experience: 6
      gunpowder:
        money: 3
        experience: 3
      dragons_breath:
        money: 12.5
        experience: 12.5
      sugar:
        money: 3.5
        experience: 3.5
      rabbit_foot:
        money: 9
        experience: 9
      glistering_melon_slice:
        money: 5
        experience: 5
      spider_eye:
        money: 4.5
        experience: 4.5
      pufferfish:
        money: 6
        experience: 6
      magma_cream:
        money: 5.5
        experience: 5.5
      golden_carrot:
        money: 6.5
        experience: 6.5
      blaze_powder:
        money: 4
        experience: 4
      ghast_tear:
        money: 9
        experience: 9
      turtle_helmet:
        money: 6
        experience: 6
      phantom_membrane:
        money: 4.5
        experience: 4.5

#TODO Enchanter
  enchanter:
    icon: enchanting_table
    difficulty_level: 1

    enchant_item:
      aqua_affinity:
        money_per_level: 1
        experience_per_level: 1
      bane_of_arthropods:
        money_per_level: 1
        experience_per_level: 1
      blast_protection:
        money_per_level: 1
        experience_per_level: 1
      channeling:
        money_per_level: 1
        experience_per_level: 1
      cleaving:
        money_per_level: 1
        experience_per_level: 1
      curse_of_binding:
        money_per_level: 1
        experience_per_level: 1
      curse_of_vanishing:
        money_per_level: 1
        experience_per_level: 1
      depth_strider:
        money_per_level: 1
        experience_per_level: 1
      efficiency:
        money_per_level: 1
        experience_per_level: 1
      feather_falling:
        money_per_level: 1
        experience_per_level: 1
      fire_aspect:
        money_per_level: 1
        experience_per_level: 1
      fire_protection:
        money_per_level: 1
        experience_per_level: 1
      flame:
        money_per_level: 1
        experience_per_level: 1
      fortune:
        money_per_level: 1
        experience_per_level: 1
      frost_walker:
        money_per_level: 1
        experience_per_level: 1
      impaling:
        money_per_level: 1
        experience_per_level: 1
      infinity:
        money_per_level: 1
        experience_per_level: 1
      knockback:
        money_per_level: 1
        experience_per_level: 1
      looting:
        money_per_level: 1
        experience_per_level: 1
      loyalty:
        money_per_level: 1
        experience_per_level: 1
      luck_of_the_sea:
        money_per_level: 1
        experience_per_level: 1
      lure:
        money_per_level: 1
        experience_per_level: 1
      mending:
        money_per_level: 1
        experience_per_level: 1
      multishot:
        money_per_level: 1
        experience_per_level: 1
      piercing:
        money_per_level: 1
        experience_per_level: 1
      power:
        money_per_level: 1
        experience_per_level: 1
      projectile_protection:
        money_per_level: 1
        experience_per_level: 1
      protection:
        money_per_level: 1
        experience_per_level: 1
      punch:
        money_per_level: 1
        experience_per_level: 1
      quick_charge:
        money_per_level: 1
        experience_per_level: 1
      respiration:
        money_per_level: 1
        experience_per_level: 1
      riptide:
        money_per_level: 1
        experience_per_level: 1
      sharpness:
        money_per_level: 1
        experience_per_level: 1
      silk_touch:
        money_per_level: 1
        experience_per_level: 1
      soul_speed:
        money_per_level: 1
        experience_per_level: 1.25
      sweeping_edge:
        money_per_level: 1.25
        experience_per_level: 1
      thorns:
        money_per_level: 1
        experience_per_level: 1.25
      unbreaking:
        money_per_level: 1
        experience_per_level: 1

#TODO Hunter
  hunter:
    icon: bow
    difficulty_level: 1

    tame_entity:
      wolf:
        money: 2
        experience: 3
      ocelot:
        money: 2.5
        experience: 3.5
      parrot:
        money: 3
        experience: 4.5

    breed_entity:
      wolf:
        money: 2
        experience: 3
      ocelot:
        money: 2
        experience: 3
      panda:
        money: 4
        experience: 6
      fox:
        money: 3
        experience: 4.5
      bee:
        money: 3
        experience: 4.5

    kill_entity:
      wolf:
        money: 10
        experience: 10
      Creeper:
        money: 10
        experience: 10
      Skeleton:
        money: 10
        experience: 15
      zombie:
        money: 10
        experience: 15
      spider:
        money: 10
        experience: 15
      blaze:
        money: 20
        experience: 20
      cave_spider:
        money: 15
        experience: 15
      enderman:
        money: 5
        experience: 10
      ghast:
        money: 30
        experience: 30
      silverfish:
        money: 3
        experience: 5
      snowman:
        money: 2
        experience: 2
      iron_golem:
        money: 2
        experience: 5
      shulker:
        money: 10
        experience: 15
      phantom:
        money: 10
        experience: 15
      guardian:
        money: 5
        experience: 10
      drowned:
        money: 10
        experience: 15
      husk:
        money: 10
        experience: 10
      wither:
        money: 100
        experience: 150
      wither_skeleton:
        money: 42.5
        experience: 42.5
      ender_dragon:
        money: 250
        experience: 250
      hoglin:
        money: 10
        experience: 15
      piglin:
        money: 15
        experience: 25
      zombified_piglin:
        money: 15
        experience: 25
      piglin_brute:
        money: 30
        experience: 30
      pillager:
        money: 10
        experience: 25
      vindicator:
        money: 15
        experience: 20
      evoker:
        money: 30
        experience: 30
      ravager:
        money: 20
        experience: 20
      polar_bear:
        money: 15
        experience: 10
      stray:
        money: 10
        experience: 15
      witch:
        money: 20
        experience: 20
      slime:
        money: 2.5
        experience: 5
      magma_cube:
        money: 5
        experience: 7.5
      elder_guardian:
        money: 25
        experience: 30
      endermite:
        money: 3
        experience: 5
      fox:
        money: 5
        experience: 5
      illusioner:
        money: 30
        experience: 45
      panda:
        money: 15
        experience: 10

#TODO Chef
  chef:
    icon: bread
    difficulty_level: 1
    food_passive:
      scripted:
        custom_food_mutton_stew:
          amount: 12
          saturation: 8
        custom_food_beef_stew:
          amount: 8
          saturation: 12
        custom_food_honey_bun:
          amount: 8
          saturation: 3
        custom_food_apple_pie:
          amount: 6
          saturation: 7
        custom_food_berry_pie:
          amount: 8
          saturation: 2
        custom_food_chocolate_cake:
          amount: 5
          saturation: 5
        custom_food_carrot_cake:
          amount: 5
          saturation: 5
        custom_food_potato_soup:
          amount: 7.2
          saturation: 6

      vanilla:
        apple:
          amount: 4
          saturation: 2.4
        mushroom_stew:
          amount: 6
          saturation: 7.2
        bread:
          amount: 5
          saturation: 6
        cooked_porkchop:
          amount: 8
          saturation: 12.8
        golden_apple:
          amount: 4
          saturation: 9.6
        golden_carrot:
          amount: 6
          saturation: 14.4
        enchanted_golden_apple:
          amount: 4
          saturation: 9.6
        cooked_cod:
          amount: 5
          saturation: 6
        cooked_salmon:
          amount: 6
          saturation: 9.6
        cake:
          amount: 2
          saturation: 0.4
        carrot:
          amount: 3
          saturation: 3.6
        chorus_fruit:
          amount: 4
          saturation: 2.4
        cookie:
          amount: 2
          saturation: 0.4
        melon_slice:
          amount: 2
          saturation: 1.2
        dried_kelp:
          amount: 1
          saturation: 0.6
        cooked_beef:
          amount: 8
          saturation: 12.8
        suspiciod_stew:
          amount: 6
          saturation: 7.2
        cooked_chicken:
          amount: 6
          saturation: 7.2
        baked_potato:
          amount: 5
          saturation: 6
        pumpkin_pie:
          amount: 8
          saturation: 4.8
        cooked_rabbit:
          amount: 5
          saturation: 6
        rabbit_stew:
          amount: 10
          saturation: 12
        cooked_mutton:
          amount: 6
          saturation: 9.6
        beetroot_soup:
          amount: 6
          saturation: 7.2
        sweet_berries:
          amount: 0.4
          saturation: 2.4
        honey_bottle:
          amount: 6
          saturation: 1.2
        beetroot:
          amount: 1
          saturation: 1.2
        potato:
          amount: 1
          saturation: 1.2
        poisonous_potato:
          amount: 2
          saturation: 1.2
        pufferfish:
          amount: 1
          saturation: 0.2


    smelt_item:
      cooked_beef:
        money: 2
        experience: 3
      cooked_chicken:
        money: 2
        experience: 3
      baked_potato:
        money: 2
        experience: 3
      cooked_rabbit:
        money: 2
        experience: 3
      cooked_mutton:
        money: 2
        experience: 3
      cooked_porkchop:
        money: 2
        experience: 3

    craft_item:
      mushroom_stew:
        money: 4
        experience: 6
      bread:
        money: 3
        experience: 5
      golden_apple:
        money: 10
        experience: 15
      glistering_melon_slice:
        money: 12.5
        experience: 12.5
      Cake:
        money: 15
        experience: 10
      Cookie:
        money: 5
        experience: 8.5
      pumpkin_pie:
        money: 6
        experience: 10
      beetroot_soup:
        money: 4
        experience: 6
      rabbit_stew:
        money: 6
        experience: 8

#TODO Excavator
  Excavator:
    icon: diamond_shovel
    difficulty_level: 1

    block_break:
      sand:
        money: 1
        experience: 1
      red_sand:
        money: 1
        experience: 1
      soul_sand:
        money: 1
        experience: 1
      soul_soil:
        money: 1
        experience: 1
      gravel:
        money: 1
        experience: 1
      dirt:
        money: 1
        experience: 1
      grass_block:
        money: 1
        experience: 1

    treasure_chance:
      lesser_reward: 83 in 100
      glowstone: 1 in 10
      diamond: 4 in 100
      emerald: 2 in 100
      netherite: 1 in 100

    passive_drop:
      1: bone_meal
      2: bone_meal
      3: bone_meal
      4: bone_meal
      5: bone_meal
      6: bone_meal
      7: bone_meal
      8: bone_meal
      9: bone_meal
      10: bone_meal
      11: bone_meal
      12: leather_boots[durability=<util.random.int[0].to[64]>]
      13: leather_leggings[durability=<util.random.int[0].to[74]>]
      14: leather_chestplate[durability=<util.random.int[0].to[80]>]
      15: leather_helmet[durability=<util.random.int[0].to[54]>]
      16: stone_hoe[durability=<util.random.int[0].to[100]>]
      17: stone_hoe[durability=<util.random.int[50].to[130]>]
      18: bowl
      19: bowl
      20: bowl
      21: stone_pickaxe[durability=<util.random.int[0].to[100]>]
      22: stone_pickaxe[durability=<util.random.int[50].to[130]>]
      23: stone_shovel[durability=<util.random.int[0].to[100]>]
      24: stone_shovel[durability=<util.random.int[50].to[130]>]
      25: stone_axe[durability=<util.random.int[0].to[100]>]
      26: stone_axe[durability=<util.random.int[50].to[130]>]
      27: bone_meal
      28: bone_meal
      29: bone_meal
      30: bone_meal
      31: bone_meal
      32: bone_meal
      33: bone_meal
      34: bone_meal
      35: bone_meal
      36: bone_meal
      37: bone_meal
      38: skeleton_skull
      39: compass
      40: bone
      41: bone
      42: bone
      43: bone
      44: bone
      45: bone
      46: bone
      47: bone
      48: bone
      49: bone
      50: bone
      51: bone
      52: bone
      53: bone
      54: bone
      55: bone
      56: bone
      57: bone
      58: bone
      59: bone
      60: bone
      61: bone
      62: bone
      63: bone
      64: bone
      65: bone
      66: bone
      67: bone
      68: bone
      69: bone
      70: redstone
      71: redstone
      72: redstone
      73: redstone
      74: redstone
      75: redstone
      76: redstone
      77: redstone
      78: redstone
      79: redstone
      80: redstone
      81: redstone
      82: redstone
      83: netherite_scrap
      84: glowstone_dust
      85: glowstone_dust
      86: glowstone_dust
      87: glowstone_dust
      88: glowstone_dust
      89: glowstone_dust
      90: glowstone_dust
      91: glowstone_dust
      92: glowstone_dust
      93: glowstone_dust
      94: glowstone_dust
      98: diamond
      95: diamond
      96: diamond
      97: diamond
      99: emerald
      100: emerald


#TODO Fisher
  fisher:
    icon: fishing_rod
    difficulty_level: 1

    breed_entity:
      turtle:
        money: 1.25
        experience: 1.5

    kill_entity:
      cod:
        money: 1.25
        experience: 1
      salmon:
        money: 1.25
        experience: 1
      pufferfish:
        money: 1.25
        experience: 1
      tropical_fish:
        money: 1.25
        experience: 1
      squid:
        money: 1.25
        experience: 1.25
      drowned:
        money: 1.5
        experience: 1.5
      elder_guardian:
        money: 2.5
        experience: 3
      guardian:
        money: 1.25
        experience: 1.5
      turtle:
        money: 1.25
        experience: 1.5

    caught_item:
      cod:
        money: 1
        experience: 1.25
      salmon:
        money: 1
        experience: 1.25
      pufferfish:
        money: 1
        experience: 1.25
      tropical_fish:
        money: 1
        experience: 1.25
      bow:
        money: 2
        experience: 1.25
      enchanted_book:
        money: 2
        experience: 1.25
      fishing_rod:
        money: 1.25
        experience: 1.5
      name_tag:
        money: 1.5
        experience: 1.5
      nautilus_shell:
        money: 2
        experience: 1.5
      saddle:
        money: 1.5
        experience: 2

    caught_entity:
      creeper:
        common: gunpowder
        common_quantity: <util.random.int[1].to[2]>
        rare: TNT
        rare_quantity: 1
        legendary: creeper_head
        legendary_quantity: 1
      drowned:
        common: rotten_flesh
        common_quantity: <util.random.int[1].to[2]>
        rare: trident[durability=<util.random.int[0].to[249]>;display_name=<&b>Trident;enchantments=<list[loyalty,1;enchantments=riptide,<util.random.int[1].to[2]>|mending,1;enchantments=impaling,<util.random.int[4].to[6]>;enchantments=vanishing_curse,1|mending,1;enchantments=riptide,3|impaling,<util.random.int[3].to[6]>].random>]
        rare_quantity: 1
        legendary: nautilus_shell
        legendary_quantity: 1
      hoglin:
        common: rotten_flesh
        common_quantity: 1
        rare: bone
        rare_quantity: <util.random.int[4].to[6]>
        legendary: tipped_arrow[potion_effects=FIRE_RESISTANCE,false,true]
        legendary_quantity: <util.random.int[3].to[8]>
      pig:
        common: leather
        common_quantity: 1
        rare: lead
        rare_quantity: 1
        legendary: "player_head[display_name=<&b>Pig Head;skull_skin=e1e1c2e4-1ed2-473d-bde2-3ec718535399|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjIxNjY4ZWY3Y2I3OWRkOWMyMmNlM2QxZjNmNGNiNmUyNTU5ODkzYjZkZjRhNDY5NTE0ZTY2N2MxNmFhNCJ9fX0=]"
        legendary_quantity: 1
      cow:
        common: leather
        common_quantity: 1
        rare: beef
        rare_quantity: <util.random.int[1].to[2]>
        legendary: legendary_item_devin_bucket
        legendary_quantity: 1
      husk:
        common: rotten_flesh
        common_quantity: 1
        rare: fire_charge
        rare_quantity: 1
        legendary: legendary_item_noble_chestplate
        legendary_quantity: 1
      phantom:
        common: phantom_membrane
        common_quantity: 1
        rare: custom_item_phantom_breath
        rare_quantity: 1
        legendary: legendary_item_behr_claw
        legendary_quantity: 1
      piglin_brute:
        common: gold_ingot
        common_quantity: 1
        rare: golden_axe[durability=<util.random.int[0].to[31]>]
        rare_quantity: 1
        legendary: head_chooser_token
        legendary_quantity: 1
      skeleton:
        common: bone
        common_quantity: <util.random.int[1].to[8]>
        rare: arrow
        rare_quantity: 1
        legendary: bow[durability=<util.random.int[0].to[384]>;display_name=<&b>Bow;enchantments=<list[flame,1;enchantments=power,<util.random.int[1].to[3]>|infinity,1;enchantments=mending,1;enchantments=vanishing_curse,1|mending,1;enchantments=punch,3|power,<util.random.int[3].to[6]>|punch,<util.random.int[2].to[3]>|unbreaking,<util.random.int[1].to[4]>].random>]
        legendary_quantity: 1
      slime:
        common: slime_ball
        common_quantity: <util.random.int[1].to[5]>
        rare: enchanted_book[enchantments=<server.enchantment_types.random>,1]
        rare_quantity: 1
        legendary: legendary_item_noble_helmet
        legendary_quantity: 1
      stray:
        common: bone
        common_quantity: 1
        rare: tipped_arrow[potion_effects=SLOWNESS,false,true]
        rare_quantity: <util.random.int[1].to[3]>
        legendary: bow[durability=<util.random.int[0].to[384]>;display_name=<&b>Bow;enchantments=<list[flame,1;enchantments=power,<util.random.int[1].to[3]>|infinity,1;enchantments=mending,1;enchantments=vanishing_curse,1|mending,1;enchantments=punch,3|power,<util.random.int[3].to[6]>|punch,<util.random.int[2].to[3]>|unbreaking,<util.random.int[1].to[4]>].random>]
        legendary_quantity: 1
      vex:
        common: iron_sword
        common_quantity: 1
        rare: tipped_arrow[potion_effects=@INVISIBILITY,false,true]
        rare_quantity: <util.random.int[1].to[3]>
        legendary: legendary_item_noble_boots
        legendary_quantity: 1
      zombie:
        common: rotten_flesh
        common_quantity: <util.random.int[1].to[2]>
        rare: potion[potion_effects=JUMP,true,false]
        rare_quantity: 1
        legendary: legendary_item_bill_cane
        legendary_quantity: 1
      spider:
        common: string
        common_quantity: 1
        rare: spider_eye
        rare_quantity: 1
        legendary: potion[potion_effects=NIGHT_VISION,false,false]
        legendary_quantity: 1
      cave_spider:
        common: string
        common_quantity: 2
        rare: fermented_spider_eye
        rare_quantity: 1
        legendary: tipped_arrow[potion_effects=SLOW_FALLING,false,true]
        legendary_quantity: 1
      bee:
        common: honey_bottle
        common_quantity: 1
        rare: beehive
        rare_quantity: 1
        legendary: legendary_item_bee_stinger
        legendary_quantity: 1
      piglin:
        common: gold_ingot
        common_quantity: 1
        rare: crying_obsidian
        rare_quantity: 1
        legendary: legendary_item_noble_helmet
        legendary_quantity: 1
      zombified_piglin:
        common: gold_ingot
        common_quantity: 1
        rare: crying_obsidian
        rare_quantity: 1
        legendary: spectral_arrow
        legendary_quantity: 1
      zoglin:
        common: rotten_flesh
        common_quantity: <util.random.int[1].to[3]>
        rare: bone
        rare_quantity: <util.random.int[4].to[6]>
        legendary: tipped_arrow[potion_effects=FIRE_RESISTANCE,false,true]
        legendary_quantity: <util.random.int[3].to[8]>

#TODO Lumberjack
  Lumberjack:
    icon: iron_axe
    difficulty_level: 1

    block_growth:
      oak_sapling:
        money: 1
        experience: 1
      acacia_sapling:
        money: 1
        experience: 1
      birch_sapling:
        money: 1
        experience: 1
      spruce_sapling:
        money: 1
        experience: 1
      jungle_sapling:
        money: 1
        experience: 1
      dark_oak_sapling:
        money: 1
        experience: 1.5
      crimson_fungus:
        money: 1.25
        experience: 2.5
      warped_fungus:
        money: 1.25
        experience: 2.5
      brown_mushroom:
        money: 1
        experience: 1.5
      red_mushroom:
        money: 1
        experience: 1.5

    block_break:
      brown_mushroom_block:
        money: 0.25
        experience: 0.25
      red_mushroom_block:
        money: 0.25
        experience: 0.25
      mushroom_stem:
        money: 1
        experience: 1.5
      oak_log:
        money: 1
        experience: 0.75
      acacia_log:
        money: 1
        experience: 0.75
      birch_log:
        money: 1
        experience: 0.75
      spruce_log:
        money: 1
        experience: 0.75
      jungle_log:
        money: 1
        experience: 0.75
      dark_oak_log:
        money: 1
        experience: 0.75
      stripped_oak_log:
        money: 1
        experience: 0.75
      stripped_acacia_log:
        money: 1
        experience: 0.75
      stripped_birch_log:
        money: 1
        experience: 0.75
      stripped_spruce_log:
        money: 1
        experience: 0.75
      stripped_jungle_log:
        money: 1
        experience: 0.75
      stripped_dark_oak_log:
        money: 1
        experience: 0.75
      crimson_stem:
        money: 1.5
        experience: 1.125
      warped_stem:
        money: 1.5
        experience: 1.125
      stripped_crimson_stem:
        money: 1.5
        experience: 1.125
      stripped_warped_stem:
        money: 1.5
        experience: 1.125
      oak_wood:
        money: 1
        experience: 0.75
      acacia_wood:
        money: 1
        experience: 0.75
      birch_wood:
        money: 1
        experience: 0.75
      spruce_wood:
        money: 1
        experience: 0.75
      jungle_wood:
        money: 1
        experience: 0.75
      dark_oak_wood:
        money: 1
        experience: 0.75
      stripped_oak_wood:
        money: 1
        experience: 0.75
      stripped_acacia_wood:
        money: 1
        experience: 0.75
      stripped_birch_wood:
        money: 1
        experience: 0.75
      stripped_spruce_wood:
        money: 1
        experience: 0.75
      stripped_jungle_wood:
        money: 1
        experience: 0.75
      stripped_dark_oak_wood:
        money: 1
        experience: 0.75
      crimson_hyphae:
        money: 1.5
        experience: 1.125
      warped_hyphae:
        money: 1.5
        experience: 1.125
      stripped_crimson_hyphae:
        money: 1.5
        experience: 1.125
      stripped_warped_hyphae:
        money: 1.5
        experience: 1.125

#TODO Miner
  Miner:
    icon: diamond_pickaxe
    difficulty_level: 1

    block_break:
      stone:
        money: 1
        experience: 0.75
      stone_bricks:
        money: 1
        experience: 0.75
      andesite:
        money: 1
        experience: 0.75
      granite:
        money: 1
        experience: 0.75
      diorite:
        money: 1
        experience: 0.75
      sandstone:
        money: 0.5
        experience: 0.375
      chiseled_sandstone:
        money: 0.5
        experience: 0.375
      cut_sandstone:
        money: 0.5
        experience: 0.375
      coal_ore:
        money: 3
        experience: 2
      redstone_ore:
        money: 2.5
        experience: 2
      iron_ore:
        money: 3.5
        experience: 3
      gold_ore:
        money: 5
        experience: 2
      lapis_ore:
        money: 7.5
        experience: 6
      diamond_ore:
        money: 10
        experience: 20
      emerald_ore:
        money: 15
        experience: 35
      nether_quartz:
        money: 2.5
        experience: 2.5
      obsidian:
        money: 5
        experience: 5
      Cobblestone:
        money: 1
        experience: 1
      cobblestone_wall:
        money: 2.5
        experience: 2.5
      mossy_cobblestone_wall:
        money: 2.5
        experience: 2.5
      nether_bricks:
        money: 2
        experience: 2
      nether_brick_stairs:
        money: 2.5
        experience: 3
      nether_brick_fence:
        money: 1
        experience: 1
      netherrack:
        money: 0.1
        experience: 0.1
      glowstone:
        money: 2
        experience: 4
      sea_lantern:
        money: 4
        experience: 2
      prismarine:
        money: 3
        experience: 2.5
      prismarine_bricks:
        money: 3
        experience: 2.5
      dark_prismarine:
        money: 3
        experience: 2.5
      end_stone:
        money: 3
        experience: 3
      purpur:
        money: 5
        experience: 5
      basalt:
        money: 1.25
        experience: 1.25
      blackstone_slab:
        money: 2.5
        experience: 3
      blackstone_stairs:
        money: 2.5
        experience: 3
      blackstone:
        money: 1
        experience: 1
      polished_blackstone_slab:
        money: 2.5
        experience: 3
      polished_blackstone_stairs:
        money: 2.5
        experience: 3
      polished_blackstone:
        money: 2.5
        experience: 3
      chiseled_polished_blackstone:
        money: 2.5
        experience: 3
      cracked_polished_blackstone_bricks:
        money: 2.5
        experience: 3
      polished_blackstone_brick_slab:
        money: 2.5
        experience: 3
      polished_blackstone_brick_stairs:
        money: 2.5
        experience: 3
      polished_blackstone_bricks:
        money: 2.5
        experience: 3
      gilded_blackstone:
        money: 10
        experience: 20
      nether_gold_ore:
        money: 5
        experience: 2
      crying_obsidian:
        money: 15
        experience: 35
      ancient_debris:
        money: 15
        experience: 35
      bedrock:
        money: -15
        experience: 0

#TODO Farmer
  farmer:
    icon: wheat_seeds
    difficulty_level: .75

    block_growth:
      wheat:
        money: 1
        experience: 1
      beetroots:
        money: 1
        experience: 1
      carrots:
        money: 1
        experience: 1
      potatoes:
        money: 1
        experience: 1
      cocoa:
        money: 2
        experience: 6
      nether_wart:
        money: 1
        experience: 1

    kill_entity:
      cow:
        money: 2
        experience: 3
      chicken:
        money: 2
        experience: 3
      sheep:
        money: 2
        experience: 3
      rabbit:
        money: 2
        experience: 3
      mushroom_cow:
        money: 2
        experience: 3
      pig:
        money: 2
        experience: 3
      horse:
        money: 2
        experience: 3
      donkey:
        money: 2
        experience: 3
      llama:
        money: 2
        experience: 3
      hoglin:
        money: 2
        experience: 3
      strider:
        money: 2
        experience: 3

    breed_entity:
      cow:
        money: 0.5
        experience: 1.5
      chicken:
        money: 0.5
        experience: 1.5
      sheep:
        money: 0.5
        experience: 1.5
      rabbit:
        money: 0.5
        experience: 1.5
      mushroom_cow:
        money: 1
        experience: 2
      pig:
        money: 0.5
        experience: 1.5
      horse:
        money: 0.5
        experience: 1.5

    block_break:
      wheat:
        money: 0.5
        experience: 2
      beetroots:
        money: 0.5
        experience: 2
      carrots:
        money: 0.5
        experience: 2
      potatoes:
        money: 0.5
        experience: 2
      cocoa:
        money: 3
        experience: 6
      nether_wart:
        money: 1.25
        experience: 1.15
      melon:
        money: 0.5
        experience: 1.5
      pumpkin:
        money: 0.5
        experience: 1.5
      sugar_cane:
        money: 0.2
        experience: 0.5
      red_mushroom:
        money: 0.4
        experience: 0.8
      brown_mushroom:
        money: 0.4
        experience: 0.8

  exp_per_level:
  ## Exp is listed in amount needed to earn the next level
  ## Example: level 1->2 takes 50 exp, so it would be `1: 50`
  ## This is to support the jobs_exp_adding script functions.
  ## Can be altered any time because it's stored as a flag of progress
  ## When a reload is done, all calculations will use the new value.
    1: 40
    2: 77
    3: 129
    4: 199
    5: 283
    6: 382
    7: 494
    8: 619
    9: 756
    10: 1548
    11: 1839
    12: 2149
    13: 2481
    14: 2833
    15: 3204
    16: 3591
    17: 3966
    18: 4416
    19: 4850
    20: 75470
    21: 8210
    22: 8888
    23: 9582
    24: 10287
    25: 11004
    26: 11731
    27: 12465
    28: 13206
    29: 13953
    30: 192120
    31: 20246
    32: 21286
    33: 22332
    34: 23381
    35: 24432
    36: 25483
    37: 26534
    38: 27582
    39: 28628
    40: 337940
    41: 35061
    42: 36324
    43: 37585
    44: 38840
    45: 40091
    46: 41333
    47: 42569
    48: 43795
    49: 45010
    50: 490230
    51: 50358
    52: 51681
    53: 52991
    54: 54287
    55: 55570
    56: 56837
    57: 58087
    58: 59322
    59: 60539
    60: 672600
    61: 68608
    62: 69937
    63: 71250
    64: 72546
    65: 73822
    66: 75080
    67: 76321
    68: 77540
    69: 78742
    70: 877300
    71: 89034
    72: 90318
    73: 91579
    74: 92819
    75: 94037
    76: 95233
    77: 96408
    78: 97561
    79: 98692
    80: 1205370
    81: 122195
    82: 123832
    83: 125447
    84: 127042
    85: 128614
    86: 130166
    87: 131695
    88: 133202
    89: 134689
    90: 165755
    91: 167596
    92: 169412
    93: 171202
    94: 172967
    95: 174704
    96: 176416
    97: 178103
    98: 179764
    99: 181398
    100: 18300800
