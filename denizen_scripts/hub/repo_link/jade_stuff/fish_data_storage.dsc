fishbot_data_storage:
  type: data

  boost_explainers:
    good_catch_modifier: Chance for good items increased by 25%
    fish_time_boost: Time required to return from fishing reduced by 10%
    speed_boost: Catch speed increased by 10%
    attack_chance_modifier: Attack chance reduced by 10%
    catch_increase: Catch amount increased by 20%
    item_increase: Item chance boosted by 20%
    item_decrease: Fish chance boosted by 20%
    experience_boost: Experience boosted by 30%
    legendary_modifier: Legendary catch rate increased by 1%



  emoji_key:
    salmon: <&co>salmon<&co>1004592553473093712
    leather_chestplate: <&co>leather_chestplate<&co>1004593129560744046
    leather_leggings: <&co>leather_chestplate<&co>1004593129560744046
    leather_boots: <&co>leather_chestplate<&co>1004593129560744046
    leather_helmet: <&co>leather_chestplate<&co>1004593129560744046
    cod: <&co>cod<&co>1004593145624936518
    trout: <&co>trout<&co>1004897881657983016
    sheepfish: <&co>sheepfish<&co>1004897880328380489
    murky_potion: <&co>potion<&co>1005354822091939880
    bait_slime: <&co>slime_ball<&co>1005851957975584848
    bait_rabbit: <&co>rabbit_foot<&co>1005852053253406781
    bait_mysterious: <&co>mysterious_shard<&co>1005851499135520918
    bait_magma: <&co>magma_ooze<&co>1005851497944322098
    bait_leech: <&co>leeches<&co>1005851496937693324
    bait_gilded: <&co>gilded_worm<&co>1005851495364837437
    bait_golden: <&co>golden_fragment<&co>1005851494597275658
    bait_chum: <&co>fish_chunks<&co>1005851493246701680
    bait_rod: <&co>end_rod_fragment<&co>1005851492395253900
    bait_worm: <&co>earthworms<&co>1005851491082436659
    bait_clay: <&co>clay_ball<&co>1005851854183333978
    bait_blinding: <&co>blinding_shard<&co>1005851502851665960
    bait_shulker: <&co>shulker_tongue_bait<&co>1006012909765275688
    none: <&co>no<&co>1006014962252120075
    rod_wood: <&co>wood<&co>1008971539678515280
    rod_diamond: <&co>diamond<&co>1008494255876091944
    rod_glass: <&co>glass<&co>1008494256974987314
    rod_golden: <&co>golden<&co>1008494258224893982
    rod_iron: <&co>iron<&co>1008494259520938116
    rod_lapis_line: <&co>lapis_line<&co>1008494246514393129
    rod_light: <&co>light<&co>1008494247550386367
    rod_line: <&co>line<&co>1008494248997437490
    rod_magnetic: <&co>magnetic<&co>1008494251044241458
    rod_netherite: <&co>netherite<&co>1008494252235444286
    rod_redstone_line: <&co>redstone_line<&co>1008494253544046693
    rod_soul: <&co>soul<&co>1008494254684917851
    boat_balloon: <&co>balloon<&co>1008923529208659978
    boat_ironclad: <&co>ironclad<&co>1008923530395648050
    boat_netherite: <&co>netherite<&co>1008923531981115524
    boat_wooden: <&co>wooden<&co>1008923508983726101
    boat_zeppelin: <&co>zeppelin<&co>1008923535101669457
    boat_quartz: <&co>quartz<&co>1008923533470081075
    jungle_leaves: <&co>jungle_leaves<&co>1016778069920468994
    acacia_leaves: <&co>acacia_leaves<&co>1016778071329746994
    oak_leaves: <&co>oak_leaves<&co>1016778072143429633
    birch_leaves: <&co>birch_leaves<&co>1016778074248970330
    azalea_leaves: <&co>azalea_leaves<&co>1016778075863789649
    dark_oak_leaves: <&co>dark_oak_leaves<&co>1016778077457629274
    flowering_azalea_leaves: <&co>flowering_azalea_leaves<&co>1016778078879502358
    spruce_leaves: <&co>spruce_leaves<&co>1016778080834048240
    stick: <&co>stick<&co>1016778429753991309
    iron_boots: <&co>iron_chestplate<&co>1016778480442163321
    iron_chestplate: <&co>iron_chestplate<&co>1016778480442163321
    iron_leggings: <&co>iron_chestplate<&co>1016778480442163321
    iron_helmet: <&co>iron_chestplate<&co>1016778480442163321
    clay_ball: <&co>clay_ball<&co>1005851854183333978
    stick:  <&co>stick<&co>1016778429753991309
    slime_ball: <&co>slime_ball<&co>1005851957975584848

  exp_per_level:
  ## Exp is listed in amount needed to earn the next level
  ## Example: level 1->2 takes 50 exp, so it would be `1: 50`
  ## This is to support the jobs_exp_adding script functions.
  ## Can be altered any time because it's stored as a flag of progress
  ## When a reload is done, all calculations will use the new value.
    0: 1
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


  jade_unlocks:
    5:
      type: bait
      Obtained: killing sea life.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059493244796928/leech_bait.png
      effect: Increases rolls by 5<&pc>.
      object: Leeches
    8:
      object: Mountains
      type: area
    9:
      type: rod
      effect: Increased durability
      thumbnail: 1
      recipe: test
      object: Fishing Rod
    11:
      type: bait
      Obtained: killing rabbits.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059494377259008/rabbit_foot_bait.png
      effect: Increases item catch chance by 10<&pc>.
      object: Rabbits Foot
    15:
      type: area
      object: Swamp
    16:
      type: bait
      Obtained: killing sea life or combining 3 leeches.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059540988575764/chum_bait.png
      effect: increases fish catch chance by 10<&pc>.
      object: Chum
    19:
      type: rod
      effect: test
      thumbnail: 1
      recipe: test
      object: Iron Rod
    20:
      type: dungeon
      object: Stronghold
    21:
      type: bait
      Obtained: killing magma cubes or combining 3 magma creams.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059493626482718/magma_bait.png
      effect: Increases rolls by 8<&pc>.
      object: Magma Lure
    25:
      type: bait
      Obtained: gilding worms.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059496168231032/gilded_worm_bait.png
      effect: Increases legendary fish catch rate by 0.5<&pc>.
      object: Gilded Worm
    27:
      type: area
      object: Warm Ocean
    29:
      type: rod
      effect: Increases legendary fish catch rate by 0.5<&pc>
      thumbnail: 1
      recipe: test
      object: Light Up Rod
    30:
      type: area
      object: Nether Wastes
    31:
      type: bait
      Obtained: killing silverfish.
      thumbnail: 1
      effect: Increases fish catch chance by 14<&pc>.
      object: Silverfish
    35:
      type: bait
      Obtained: killing slimes.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059495123853455/slime_bait.png
      effect: Increases item catch chance by 14<&pc>.
      object: Slime Ball
    39:
      type: rod
      effect: Reduces item catch chance by 20<&pc>.
      thumbnail: 1
      recipe: test
      object: Glass Rod
    41:
      type: bait
      Obtained: breaking clay blocks
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059541521240115/clay_bait.png
      effect: Gives a 1<&pc> chance to catch a key each cast.
      object: Clay Ball
    45:
      type: area
      object: Crimson Forest
    49:
      type: rod
      effect: test
      thumbnail: 1
      recipe: Increases item catch chance by 20<&pc>.
      object: Magnetic Rod
    50:
      type: area
      object: Cold Ocean
    51:
      type: bait
      Obtained: killing end mites, corrupting silverfish with end pearls.
      thumbnail: 1
      effect: Increases rolls by 10<&pc>.
      object: End Mite
    55:
      type: area
      object: Fortress Moat
    60:
      type: area
      object: End Islands
    61:
      type: bait
      Obtained: killing shulkers.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059494708613201/shulker_tongue_bait.png
      effect: Increases fish catch rate by 18<&pc>.
      object: Shulker Tongue
    65:
      type: area
      object: Oasis
    68:
      type: area
      object: Warped Forest
    69:
      type: rod
      effect: test
      thumbnail: 1
      recipe: test
      object: Diamond Rod
    70:
      type: dungeon
      object: Ocean Monument
    71:
      type: bait
      Obtained: killing humanoids.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059493962035261/mysterious_shard_bait.png
      effect: Increases item catch rate by 18<&pc>.
      object: Mysterious Shard
    75:
      type: area
      object: Valley of Souls
    79:
      type: rod
      effect: 1<&pc> chance each cast to find a dungeon key.
      thumbnail: 1
      recipe: test
      object: Golden Rod
    80:
      type: area
      object: Basalt Delta
    81:
      type: bait
      Obtained: combining shulker tongues, mysterious shards, and gold.
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059495841079436/gilded_fragment_bait.png
      effect: Increases legendary fish catch rate to 1.0<&pc>.
      object: Golden Fragment
    89:
      type: rod
      effect: test
      thumbnail: 1
      recipe: test
      object: Netherite Rod
    90:
      type: area
      object: End City Fountain
    91:
      type: bait
      Obtained: combining natural light items, and golden fragments
      thumbnail: https://cdn.discordapp.com/attachments/1004961963136274506/1006059540648833054/blinding_shard_bait.png
      effect: Increases legendary fish catch rate to 1.5<&pc>.
      object: Blinding Shard
    92:
      type: area
      object: City of the Drowned
    94:
      type: rod
      effect: Increases legendary fish catch rate by 0.5<&pc>
      thumbnail: 1
      recipe: test
      object: Soul Rod
    95:
      type: area
      object: Bastion Dungeons
    100:
      type: area
      object: Dragon's Lair


  fish:
    salmon:
      min_catch: 1
      bonus: 0.5
    cod:
      min_catch: 1
      bonus: 0.5
    bowfin:
      min_catch: 16
      bonus: 0
    daggerfish:
      min_catch: 20
      bonus: 0
    tropical_fish:
      min_catch: 30
      bonus: 0
    puffer_fish:
      min_catch: 30
      bonus: 0
    flarefin_koi:
      min_catch: 30
      bonus: 0
    neon_tetra:
      min_catch: 30
      bonus: 0
    golden_cod:
      min_catch: 50
      bonus: 0
    atlantic_cod:
      min_catch: 50
      bonus: 0
    shrimp:
      min_catch: 75
      bonus: 0
    tuna:
      min_catch: 75
      bonus: 0
    jellyfish:
      min_catch: 90
      bonus: 0
    octopus:
      min_catch: 90
      bonus: 0
    clam:
      min_catch: 90
      bonus: 0
    trout:
      min_catch: 1
      bonus: 0
    eel:
      min_catch: 15
      bonus: 0.5
    bass:
      min_catch: 15
      bonus: 0
    sheepfish:
      min_catch: 1
      bonus: 10
    pupfish:
      min_catch: 8
      bonus: 0
    muskfish:
      min_catch: 15
      bonus: 0
    angler:
      min_catch: 20
      bonus: 0
    sunfish:
      min_catch: 30
      bonus: 0
    golden_shark:
      min_catch: 75
      bonus: 0
    frost_minnow:
      min_catch: 50
      bonus: 0
    cuddlefish:
      min_catch: 90
      bonus: 0
    flounder:
      min_catch: 8
      bonus: 0
    slimefish:
      min_catch: 20
      bonus: 0
    snapper:
      min_catch: 20
      bonus: 0
    clownfish:
      min_catch: 30
      bonus: 0
    halibut:
      min_catch: 50
      bonus: 0
    guardian_hatchling:
      min_catch: 75
      bonus: 0
    hemopiranha:
      min_catch: 90
      bonus: 0
    spongefish:
      min_catch: 75
      bonus: 0
  area:
    plains:
      info: **Plains<&co>** <script.data_key[plains]>
      key_cost: 0
      boat_tier: 0
      boat_required: None
      min_level: 0
      duration: 300
      description: A nice lazy river wandering aimlessly through the plains.
      rate: 60
      attack_chance: 10
      attack_repel_message: A wolf leapt at Jade from the shore, but only scratched the boat<&nl>(Durability left <number_left>/<boat_max>)
      attack_succeed_message: A pack of wolves howled on shore startling Jade.<&nl>He dropped some fish.
      attack_penalty: 0.9
      attack_damage: 1
      trash_chance: 66
      trash_items:
        leather_boots[durability=<util.random.int[44].to[64]>]: 1
        leather_leggings[durability=<util.random.int[50].to[74]>]: 1
        leather_chestplate[durability=<util.random.int[52].to[80]>]: 1
        leather_helmet[durability=<util.random.int[36].to[54]>]: 1
      item_chance: 10
      good_items:
        murky_potion[color=<util.random.int[0].to[255]>,<util.random.int[0].to[255]>,<util.random.int[0].to[255]>]: 15
      key_chance: 2
      common_fish:
        salmon: 3
        cod: 7
      rare_chance: 10
      rare_fish:
        trout: 1
      legendary_fish:
        Sheepfish: true

    mountains:
      info: **Mountains<&co>** 8
      key_cost: 0
      boat_tier: 0
      min_level: 8
      duration: 480
      rate: 60
      attack_chance: 15
      attack_succeed_message: Jade saw a Skeleton, in his haste to flee, he dropped some fish!
      attack_repel_message: A skeleton fired upon the boat, but its arrows had no effect! (Durability left <number_left>/<boat_max>)
      attack_penalty: 0.8
      attack_damage: 1
      common_fish:
        salmon: true
        cod: true
        trout: true
      rare_chance: 15
      rare_fish:
        flounder: true
      legendary_fish:
        pupfish: true
      item_chance: 5
      trash_chance: 66
      trash_items:
        leather_boots[durability=<util.random.int[32].to[64]>]: 1
        leather_leggings[durability=<util.random.int[35].to[74]>]: 1
        leather_chestplate[durability=<util.random.int[40].to[80]>]: 1
        leather_helmet[durability=<util.random.int[27].to[54]>]: 1
      good_items:
        iron_boots[durability=<util.random.int[32].to[64]>]: 1
        iron_leggings[durability=<util.random.int[112].to[254]>]: 1
        iron_chestplate[durability=<util.random.int[120].to[239]>]: 1
        iron_helmet[durability=<util.random.int[98].to[194]>]: 1
      key_chance: 3
      boat_required: None
      description: A serene lake nestled between the peaks of a mountain.

    Swamp:
      info: **Swamp<&co>** 15
      key_cost: 0
      boat_tier: 1
      min_level: 15
      duration: 600
      rate: 75
      attack_chance: 20
      attack_succeed_message: Jades boat was stuck in the reeds! He knocked it over while getting in unstuck and lost some of thee catch!
      attack_repel_message: The armor on his boat sliced right through a tangle of muck. (Durability left <number_left>/<boat_max>)
      attack_penalty: 0.75
      attack_damage: 1
      common_fish:
        cod: true
        bass: true
        bowfin: true
      rare_chance: 15
      rare_fish:
        eel: true
      legendary_fish:
        muskfish: true
      item_chance: 25
      trash_chance: 80
      trash_items:
        slime_ball: 1
        stick: 1
        clay_ball: 1
        <list[oak|spruce|birch|jungle|acacia|dark_oak|mangrove|azalea|flowering_azalea].random>_leaves: 1
      good_items:
        iron_boots[durability=<util.random.int[58].to[136]>]: 1
        iron_leggings[durability=<util.random.int[67].to[157]>]: 1
        iron_chestplate[durability=<util.random.int[72].to[168]>]: 1
        iron_helmet[durability=<util.random.int[50].to[116]>]: 1
      key_chance: 5
      boat_required: Wooden
      description: A smelly swamp in a valley.

  rod:
    line:
      info: **Line<&co>**<&sp><&lt><&co>line<&co>1008494248997437490<&gt><&nl>*Level<&co> 0*<&nl>*Effect<&co> N/A*<&nl>*Catch Increase<&co>* N/A<&nl>*Durability<&co> 6*<&nl>
      level: 0
      catch_increase: .00
      legendary_catch: 0
      item_chance: 0
      key_chance: 0
      durability: 32
      trips: 6
    wood:
      info: **Wood<&co>**<&sp><&lt><&co>wood<&co>1008971539678515280<&gt> <&nl>*Level<&co> 10*<&nl>*Effect<&co> N/A*<&nl>*Catch Increase<&co> 2<&pc>*<&nl>*Durability<&co> 10*<&nl>
      level: 10
      catch_increase: .02
      legendary_catch: 0
      item_chance: 0
      key_chance: 0
      durability: 64
      trips: 10
    iron:
      info: **Iron<&co>**<&sp><&lt><&co>iron<&co>1008494259520938116<&gt> <&nl>*Level<&co> 20*<&nl>*Effect<&co> N/A*<&nl>*Catch Increase<&co> 4<&pc>*<&nl>*Durability<&co> 30*<&nl>
      level: 20
      catch_increase: .04
      legendary_catch: 0
      item_chance: 0
      key_chance: 0
      durability: 150
      trips: 30
    light:
      info: **Light<&co>**<&sp><&lt><&co>light<&co>1008494247550386367<&gt> <&nl>*Level<&co> 30*<&nl>*Effect<&co> Legendary Catch increase 0.5<&pc>*<&nl>*Catch Increase<&co> 6<&pc>*<&nl>*Durability<&co> 24*<&nl>
      level: 30
      catch_increase: .06
      legendary_catch: 5
      item_chance: 0
      key_chance: 0
      durability: 128
      trips: 24
    glass:
      info: **Glass<&co>**<&sp><&lt><&co>glass<&co>1008494256974987314<&gt> <&nl>*Level<&co> 40*<&nl>*Effect<&co> Item chance reduced by 20<&pc>*<&nl>*Catch Increase<&co> 6<&pc>*<&nl>*Durability<&co> 25*<&nl>
      level: 40
      catch_increase: .06
      legendary_catch: 0
      item_chance: -20
      key_chance: 0
      durability: 128
      trips: 25
    magnetic:
      info: **Magnetic<&co>**<&sp><&lt><&co>magnetic<&co>1008494251044241458<&gt> <&nl>*Level<&co> 50*<&nl>*Effect<&co> Item chance increased by 20<&pc>*<&nl>*Catch Increase<&co> 6<&pc>*<&nl>*Durability<&co> 25*<&nl>
      level: 50
      catch_increase: .06
      legendary_catch: 0
      item_chance: 20
      key_chance: 0
      durability: 128
      trips: 25
    diamond:
      info: **Diamond<&co>**<&sp><&lt><&co>diamond<&co>1008494255876091944<&gt> <&nl>*Level<&co> 60*<&nl>*Effect<&co> N/A*<&nl>*Catch Increase<&co> 8<&pc>*<&nl>*Durability<&co> 80*<&nl>
      level: 60
      catch_increase: .08
      legendary_catch: 0
      item_chance: 0
      key_chance: 0
      durability: 400
      trips: 80
    golden:
      info: **Golden<&co>**<&sp><&lt><&co>golden<&co>1008494258224893982<&gt> <&nl>*Level<&co> 70*<&nl>*Effect<&co> 1<&pc> chance per cast for a key*<&nl>*Catch Increase<&co> 6<&pc>*<&nl>*Durability<&co> 20*<&nl>
      level: 70
      catch_increase: .06
      legendary_catch: 0
      item_chance: 0
      key_chance: 1
      durability: 100
      trips: 20
    netherite:
      info: **Netherite<&co>**<&sp><&lt><&co>netherite<&co>1008494252235444286<&gt> <&nl>*Level<&co> 80*<&nl>*Effect<&co> N/A*<&nl>*Catch Increase<&co> 8<&pc>*<&nl>*Durability<&co> 120*<&nl>
      level: 80
      catch_increase: .08
      legendary_catch: 0
      item_chance: 0
      key_chance: 0
      durability: 600
      trips: 120
    soul:
      info: **Soul<&co>**<&sp><&lt><&co>soul<&co>1008494254684917851<&gt> <&nl>*Level<&co> 95*<&nl>*Effect<&co> Legendary catch increased by 1<&pc>*<&nl>*Catch Increase<&co> 10<&pc>*<&nl>*Durability<&co> 80*<&nl>
      level: 95
      catch_increase: .10
      legendary_catch: 10
      item_chance: 0
      key_chance: 0
      durability: 400
      trips: 80

  boat:
    none:
      tier: 0
      armored: 0
      catch_increase: .00
      trips: 0
      level: 0
    wooden:
      info: **Wooden<&co>**<&sp><&lt><&co>wooden<&co>1008923508983726101<&gt><&nl>*Level<&co> 10*<&nl>*Armored<&co><&sp>No*<&nl>*Catch Increase<&co>* 6<&pc><&nl>*Durability<&co> 10*<&nl>
      tier: 1
      armored: 0
      catch_increase: 0.06
      trips: 10
      level: 10
    ironclad:
      info: **Ironclad<&co>**<&sp><&lt><&co>ironclad<&co>1008923530395648050<&gt><&nl>*Level<&co> 20*<&nl>*Armored<&co><&sp>Yes*<&nl>*Catch Increase<&co>* 3<&pc><&nl>*Durability<&co> 20*<&nl>
      tier: 2
      armored: 1
      catch_increase: 0.03
      trips: 20
      level: 20
    netherite:
      info: **Netherite<&co>**<&sp><&lt><&co>netherite<&co>1008923531981115524<&gt><&nl>*Level<&co> 40*<&nl>*Armored<&co><&sp>No*<&nl>*Catch Increase<&co>* 12<&pc><&nl>*Durability<&co> 20*<&nl>
      tier: 3
      armored: 0
      catch_increase: 0.12
      trips: 20
      level: 40
    quartz:
      info: **Quartz<&co>**<&sp><&lt><&co>quartz<&co>1008923533470081075<&gt><&nl>*Level<&co> 50*<&nl>*Armored<&co><&sp>Yes*<&nl>*Catch Increase<&co>* 6<&pc><&nl>*Durability<&co> 40*<&nl>
      tier: 4
      armored: 1
      catch_increase: 0.06
      trips: 40
      level: 50
    balloon:
      info: **Balloon<&co>**<&sp><&lt><&co>balloon<&co>1008923529208659978<&gt><&nl>*Level<&co> 60*<&nl>*Armored<&co><&sp>No*<&nl>*Catch Increase<&co>* 15<&pc><&nl>*Durability<&co> 30*<&nl>
      tier: 5
      armored: 0
      catch_increase: 0.15
      trips: 30
      level: 60
    zeppelin:
      info: **Zeppelin<&co>**<&sp><&lt><&co>zeppelin<&co>1008923535101669457<&gt><&nl>*Level<&co> 70*<&nl>*Armored<&co><&sp>Yes*<&nl>*Catch Increase<&co>* 7.5<&pc><&nl>*Durability<&co> 60*<&nl>
      tier: 6
      armored: 1
      catch_increase: 0.075
      trips: 60
      level: 70

  bait:
    none:
      level: 0
      increase_percent: 0
      item_chance: 0
      legendary_chance: 0
      key_chance: 0
    worm:
      level: 0
      info: **Worm<&co>**<&sp><&lt><&co>earthworms<&co>1005851491082436659<&gt><&nl>*Level<&co><&sp>0*<&nl>*Effect<&co><&sp>Catch<&sp>rate<&sp>increased<&sp>by<&sp>2<&pc>*
      increase_percent: .02
      item_chance: 0
      legendary_chance: 0
      key_chance: 0
    leech:
      level: 5
      info: **Leech<&co>**<&sp><&lt><&co>leeches<&co>1005851496937693324<&gt><&nl>*Level<&co><&sp>5*<&nl>*Effect<&co><&sp>Catch<&sp>rate<&sp>increased<&sp>by<&sp>5<&pc>*
      increase_percent: .05
      item_chance: 0
      legendary_chance: 0
      key_chance: 0
    rabbit:
      level: 11
      info: **Rabbit<&co>**<&sp><&lt><&co>rabbit_foot<&co>1005852053253406781<&gt><&nl>*Level<&co><&sp>11*<&nl>*Effect<&co><&sp>Item<&sp>catch<&sp>rate<&sp>increased<&sp>by<&sp>10<&pc>*
      increase_percent: .00
      item_chance: 10
      legendary_chance: 0
      key_chance: 0
    chum:
      level: 16
      info: **Chum<&co>**<&sp><&lt><&co>fish_chunks<&co>1005851493246701680<&gt><&nl>*Level<&co><&sp>16*<&nl>*Effect<&co><&sp>item<&sp>catch<&sp>rate<&sp>decreased<&sp>by<&sp>10<&pc>*
      increase_percent: .00
      item_chance: -10
      legendary_chance: 0
      key_chance: 0
    magma:
      level: 21
      info: **Magma<&co>**<&sp><&lt><&co>magma_ooze<&co>1005851497944322098<&gt><&nl>*Level<&co><&sp>21*<&nl>*Effect<&co><&sp>Catch<&sp>rate<&sp>increased<&sp>by<&sp>8<&pc>*
      increase_percent: .08
      item_chance: 0
      legendary_chance: 0
      key_chance: 0
    gilded:
      level: 25
      info: **Gilded<&co>**<&sp><&lt><&co>gilded_worm<&co>1005851495364837437<&gt><&nl>*Level<&co><&sp>25*<&nl>*Effect<&co><&sp>Legendary<&sp>catch<&sp>rate<&sp>increased<&sp>by<&sp>0.5<&pc>*
      increase_percent: .00
      item_chance: 0
      legendary_chance: 5
      key_chance: 0
    silverfish:
      level: 31
      info: **Silverfish<&co>**<&sp><&lt><&gt><&nl>*Level<&co><&sp>31*<&nl>*Effect<&co><&sp>Item<&sp>catch<&sp>rate<&sp>decreased<&sp>by<&sp>14<&pc>*
      increase_percent: .00
      item_chance: -14
      legendary_chance: 0
      key_chance: 0
    slime:
      level: 35
      info: **Slime<&co>**<&sp><&lt><&co>slime_ball<&co>1005851957975584848<&gt><&nl>*Level<&co><&sp>35*<&nl>*Effect<&co><&sp>Item<&sp>catch<&sp>rate<&sp>increased<&sp>by<&sp>14<&pc>*
      increase_percent: .00
      item_chance: 14
      legendary_chance: 0
      key_chance: 0
    clay:
      level: 41
      info: **Clay<&co>**<&sp><&lt><&gt><&co>clay_ball<&co>1005851854183333978<&nl>*Level<&co><&sp>41*<&nl>*Effect<&co><&sp>1<&pc><&sp>Chance<&sp>to<&sp>catch<&sp>a<&sp>key<&sp>per<&sp>cast*
      increase_percent: .00
      item_chance: 0
      legendary_chance: 0
      key_chance: 1
    endmite:
      level: 51
      info: **Endmite<&co>**<&sp><&lt><&gt><&nl>*Level<&co><&sp>51*<&nl>*Effect<&co><&sp>Catch<&sp>rate<&sp>increased<&sp>by<&sp>10<&pc>*
      increase_percent: .10
      item_chance: 0
      legendary_chance: 0
      key_chance: 0
    shulker:
      level: 61
      info: **Shulker<&co>**<&sp><&lt><&co>shulker_tongue_bait<&co>1006012909765275688<&gt><&nl>*Level<&co><&sp>61*<&nl>*Effect<&co><&sp>Item<&sp>catch<&sp>rate<&sp>decreased<&sp>by<&sp>18<&pc>*
      increase_percent: .00
      item_chance: -18
      legendary_chance: 0
      key_chance: 0
    mysterious:
      level: 71
      info: **Mysterious<&co>**<&sp><&lt><&co>mysterious_shard<&co>1005851499135520918<&gt><&nl>*Level<&co><&sp>71*<&nl>*Effect<&co><&sp>Item<&sp>catch<&sp>rate<&sp>increased<&sp>by<&sp>18<&pc>*
      increase_percent: .00
      item_chance: 18
      legendary_chance: 0
      key_chance: 0
    golden:
      level: 81
      info: **Golden<&co>**<&sp><&lt><&co>golden_fragment<&co>1005851494597275658<&gt><&nl>*Level<&co><&sp>81*<&nl>*Effect<&co><&sp>Legendary<&sp>catch<&sp>rate<&sp>increased<&sp>by<&sp>1.0<&pc>*
      increase_percent: .00
      item_chance: 0
      legendary_chance: 10
      key_chance: 0
    blinding:
      level: 91
      info: **Blinding<&co>**<&sp><&lt><&co>blinding_shard<&co>1005851502851665960<&gt><&nl>*Level<&co><&sp>*<&nl>*Effect<&co><&sp>Legendary<&sp>catch<&sp>rate<&sp>increased<&sp>by<&sp>1.5<&pc>*
      increase_percent: .00
      item_chance: 0
      legendary_chance: 15
      key_chance: 0
