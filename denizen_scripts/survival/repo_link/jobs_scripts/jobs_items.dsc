jobs_full_button:
  type: item
  debug: false
  material: barrier
  display name: <&6>Fully Employed
  lore:
  - "<&c>You are fully employed."
  - "<&6>Please <&e>quit<&6> a job to gain another."
  - "<&6>Your levels will be saved."
  - "<&6>You may only <&e>quit<&6> a job <&e>once a day<&6>."

jobs_quit_button:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 2
  display name: <&c>Quit Job
  flags:
    action: quit
  lore:
  - "<&e>Immediately<&6> leave this job"
  - "<&6>Your levels will be saved."
  - "<&6>You may only <&e>quit<&6> a job <&e>once a day<&6>."

jobs_accept_button:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 1
  display name: <&a>Accept Job
  flags:
    action: accept
  lore:
  - "<&e>Accept<&6> this job."
  - "<&6>You will be able to work immediately."
  - "<&6>You may only <&e>quit<&6> a job <&e>once a day<&6>."

jobs_item_special_explainer:
  type: item
  debug: false
  material: blaze_powder
  display name: <&c>S<&6>p<&e>e<&a>c<&9>i<&b>a<&5>l <&6>A<&e>b<&a>i<&9>l<&b>i<&5>t<&c>i<&6>e<&e>s<&a><&co>
  lore:
  - ''
  - <&6>Most jobs come with <&e>special abilities<&6>.
  - <&6>The chance of it happening improves as you level.
  - <&2>Farmer<&co> <&e>Crops may auto-plant when harvested with a hoe.
  - <&6>Lumberjack<&co> <&e>Trees will be chopped faster.
  - <&e>Miner<&co> <&e>Ores may spontaneously smelt.
  - <&f>Chef<&co> <&e>Food may saturate more.
  - <&d>Brewer<&co> <&e>Potions may double-brew.
  - <&a>Excavation<&co> <&e>Rare items can be found buried.
  - <&7>Blacksmith<&co> <&e>Items may doublecraft.
  - <&9>Fisher<&co> <&e>Items may be ripped from monsters.
  - <&c>Hunter<&co> <&e>You might dodge an attack.
  - <&b>Enchanter<&co> <&e>Items may enchant a level higher.
server_jobs_info_head:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: <player.skull_skin||null>
  display name: <&e><player.name||null><&6><&sq>s stats<&co>
  lore:
  - <&6>Job Count<&co> <&e><player.flag[jobs.current_list].size||0><&6>/<&e><player.flag[jobs.allowed]>
  - <&6>Work Stations<&co> <&e><player.flag[jobs.blocks_owned].size||0><&6>/<&e><player.flag[jobs.blocks_allowed]>
  - ''
  - <&6>Current Jobs<&co>
  - <&e><player.flag[jobs.current_list].separated_by[, <&e>]>
  - ''
  - <&6>Click for <&e>Personal Stats<&6>.
  flags:
    action: player_jobs_info

player_jobs_info_head:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: <player.skull_skin||null>
  display name: <&e><player.name||null><&6><&sq>s stats<&co>
  lore:
  - <&6>Job Count<&co> <&e><player.flag[jobs.current_list].size||0><&6>/<&e><player.flag[jobs.allowed]>
  - <&6>Work Stations<&co> <&e><player.flag[jobs.blocks_owned].size||0><&6>/<&e><player.flag[jobs.blocks_allowed]>
  - ''
  - <&6>Current Jobs<&co>
  - <&e><player.flag[jobs.current_list].separated_by[, <&e>]>
  - ''
  - <&6>Click for <&e>Server Stats<&6>.
  flags:
    action: server_jobs_info

player_info_chef:
  type: item
  debug: false
  material: bread
  display name: <&f>Chef<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Chef.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: chef

player_info_enchanter:
  type: item
  debug: false
  material: enchanting_table
  display name: <&b>Enchanter<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Enchanter.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Enchanter

player_info_Excavation:
  type: item
  debug: false
  material: diamond_shovel
  display name: <&a>Excavation<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Excavation.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Excavation

player_info_Blacksmith:
  type: item
  debug: false
  material: anvil
  display name: <&7>Blacksmith<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Blacksmith.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Blacksmith

player_info_brewer:
  type: item
  debug: false
  material: brewing_stand
  display name: <&d>Brewer<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Brewer.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Brewer

player_info_lumberjack:
  type: item
  debug: false
  material: iron_axe
  display name: <&6>Lumberjack<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Lumberjack.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Lumberjack

player_info_tinkerer:
  type: item
  debug: false
  material: crafting_table
  display name: <&a>Tinkerer<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Tinkerer.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Tinkerer

player_info_miner:
  type: item
  debug: false
  material: diamond_pickaxe
  display name: <&e>Miner<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Miner.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Miner

player_info_fisher:
  type: item
  debug: false
  material: fishing_rod
  display name: <&9>Fisher<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Fisher.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Fisher

player_info_Builder:
  type: item
  debug: false
  material: stone_axe
  display name: <&3>Builder<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Builder.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Builder

player_info_farmer:
  type: item
  debug: false
  material: wheat_seeds
  display name: <&2>Farmer<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Farmer.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Farmer

player_info_hunter:
  type: item
  debug: false
  material: bow
  display name: <&c>Hunter<&co>
  lore:
  - ''
  - <&6>Current level<&co> <&e><player.flag[jobs.Hunter.level]>
  - ''
  - <&6>Current Rank<&co> <&e>
  - ''
  - <&6>Click for amounts earned per action.
  flags:
    jobs: Hunter

jobs_item_chef:
  type: item
  debug: false
  material: bread
  display name: <&f>Chef<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Cooking/crafting food.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Chef]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Chef]>
  flags:
    jobs: Chef

jobs_item_chef_info_1:
  type: item
  debug: false
  material: smoker
  display name: <&6>Cooking Food<&co>
  lore:
  - ''
  - <&6>Beef<&co> <&a>$<script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Beef.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Beef.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Chicken<&co> <&a>$<script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Chicken.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Chicken.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Potatoes<&co> <&a>$<script[Jobs_data_script].data_key[Chef.smelt_item.baked_potato.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.smelt_item.baked_potato.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Mutton<&co> <&a>$<script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Mutton.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Mutton.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Porkchop<&co> <&a>$<script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Porkchop.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.smelt_item.Cooked_Porkchop.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - ''
  - <&6><&o>You must own the block that cooks the item to recieve credit.

jobs_item_chef_info_2:
  type: item
  debug: false
  material: Crafting_Table
  display name: <&6>Crafting Food<&co>
  lore:
  - ''
  - <&6>Mushroom Stew<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Mushroom_Stew.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Mushroom_Stew.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Beetroot Soup<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Beetroot_Soup.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Beetroot_Soup.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Rabbit Stew<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Rabbit_Stew.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Rabbit_Stew.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Bread<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Bread.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Bread.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Cake<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Cake.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Cake.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Cookie<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Cookie.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Cookie.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Pumpkin Pie<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Pumpkin_Pie.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Pumpkin_Pie.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Golden Apple<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.Golden_Apple.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.Golden_Apple.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - <&6>Glistening Melon Slice<&co> <&a>$<script[Jobs_data_script].data_key[Chef.craft_item.glistening_melon_slice.money].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Chef.craft_item.glistening_melon_slice.experience].mul[<script[Jobs_data_script].data_key[Chef.difficulty_level]>]>XP
  - ''

jobs_item_enchanter:
  type: item
  debug: false
  material: enchanting_table
  display name: <&b>Enchanter<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Enchanting Items.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Enchanter]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Enchanter]>
  flags:
    jobs: enchanter

jobs_item_enchanter_info_1:
  type: item
  debug: false
  material: diamond_sword
  mechanisms:
    hides: all
    enchantments:
    - SHARPNESS,1
  display name: <&6>Melee Enchantments<&co>
  lore:
  - ''
  - <&6>Bane of Arthropods<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Bane_of_Arthropods.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Bane_of_Arthropods.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Cleaving<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Cleaving.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Cleaving.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Fire Aspect<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Fire_Aspect.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Fire_Aspect.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Impaling<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Impaling.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Impaling.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Knockback<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Knockback.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Knockback.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Looting<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Looting.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Looting.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Sharpness<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Sharpness.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Sharpness.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Sweeping Edge<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Sweeping_Edge.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Sweeping_Edge.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - ''

jobs_item_enchanter_info_2:
  type: item
  debug: false
  material: crossbow
  mechanisms:
    hides: all
    enchantments:
    - SHARPNESS,1
  display name: <&6>Ranged Enchantments<&co>
  lore:
  - ''
  - <&6>Channeling<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Channeling.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Channeling.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Flame<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Flame.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Flame.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Infinity<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Infinity.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Infinity.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Loyalty<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Power.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Power.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Multishot<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Multishot.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Multishot.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Piercing<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Piercing.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Piercing.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Power<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Power.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Power.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Punch<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Punch.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Punch.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Quick Charge<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Quick_Charge.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Quick_Charge.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Riptide<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Riptide.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Riptide.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - ''

jobs_item_enchanter_info_3:
  type: item
  debug: false
  material: diamond_chestplate
  mechanisms:
    hides: all
    enchantments:
    - SHARPNESS,1
  display name: <&6>Armor Enchantments<&co>
  lore:
  - ''
  - <&6>Aqua Affinity<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Aqua_Affinity.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Aqua_Affinity.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Blast Protection<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Feather_Falling.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Feather_Falling.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Curse of Binding<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Curse_of_Binding.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Curse_of_Binding.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Depth Strider<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Depth_Strider.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Depth_Strider.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Feather Falling<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Feather_Falling.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Feather_Falling.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Fire Protection<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Fire_Protection.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Fire_Protection.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Frost Walker<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Frost_Walker.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Frost_Walker.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Projectile Protection<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Projectile_Protection.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Projectile_Protection.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Protection<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Protection.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Protection.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Respiration<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Respiration.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Respiration.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Soul Speed<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Soul_Speed.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Soul_Speed.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Thorns<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Thorns.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Thorns.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - ''

jobs_item_enchanter_info_4:
  type: item
  debug: false
  material: book
  mechanisms:
    hides: all
    enchantments:
    - SHARPNESS,1
  display name: <&6>Miscellaneous  Enchantments<&co>
  Lore:
  - ''
  - <&6>Curse of Vanishing<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Curse_of_Vanishing.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Curse_of_Vanishing.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Mending<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Mending.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Mending.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Unbreaking<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Unbreaking.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Unbreaking.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - ''

jobs_item_enchanter_info_5:
  type: item
  debug: false
  material: diamond_pickaxe
  mechanisms:
    hides: all
    enchantments:
    - SHARPNESS,1
  display name: <&6>Tools<&co>
  lore:
  - ''
  - <&6>Efficiency<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Efficiency.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Efficiency.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Fortune<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Fortune.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Fortune.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Luck of the Sea<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Luck_of_the_Sea.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Luck_of_the_Sea.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Lure<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Lure.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Lure.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - <&6>Silk Touch<&co> <&a>$<script[Jobs_data_script].data_key[enchanter.enchant_item.Silk_Touch.money_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[enchanter.enchant_item.Silk_Touch.experience_per_level].mul[<script[Jobs_data_script].data_key[enchanter.difficulty_level]>]>XP
  - ''


jobs_item_Excavation:
  type: item
  debug: false
  material: diamond_shovel
  display name: <&a>Excavation<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Digging up blocks.
  - <&e>- Finding treasure.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Excavation]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Excavation]>
  flags:
    jobs: Excavation

jobs_item_Excavation_info_1:
  type: item
  debug: false
  material: Sand
  display name: <&6>Block breaking<&co>
  lore:
  - ''
  - <&6>Sand<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Sand.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Sand.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - <&6>Red Sand<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Red_Sand.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Red_Sand.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - <&6>Dirt<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Dirt.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Dirt.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - <&6>Grass Block<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Grass_Block.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Grass_Block.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - <&6>Gravel<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Gravel.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Gravel.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - <&6>Soul Sand<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Soul_Sand.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Soul_Sand.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - <&6>Soul Soil<&co> <&a>$<script[Jobs_data_script].data_key[Excavation.block_break.Soul_Soil.money].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Excavation.block_break.Soul_Soil.experience].mul[<script[Jobs_data_script].data_key[Excavation.difficulty_level]>]>XP
  - ''


jobs_item_Excavation_info_2:
  type: item
  debug: false
  material: filled_map
  display name: <&6>Treasure Finding<&co>
  lore:
  - ''
  - <&6>Glowstone<&co> <&a><script[Jobs_data_script].data_key[Excavation.treasure_chance.Glowstone]>
  - <&6>Diamonds<&co> <&a><script[Jobs_data_script].data_key[Excavation.treasure_chance.Diamond]>
  - <&6>Emeralds<&co> <&a><script[Jobs_data_script].data_key[Excavation.treasure_chance.Emerald]>
  - <&6>Netherice<&co> <&a><script[Jobs_data_script].data_key[Excavation.treasure_chance.netherite]>
  - <&6>Other Reward<&co> <&a><script[Jobs_data_script].data_key[Excavation.treasure_chance.lesser_reward]>
  - ''
  - <&6><&o>Drop rates increase with your Excavation level.
  - <&6><&o>Each block rolls a chance at the item off a reward table.

jobs_item_Blacksmith:
  type: item
  debug: false
  material: Anvil
  display name: <&7>Blacksmith<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Crafting Weapons/Armor.
  - <&e>- Smelting Ores.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Blacksmith]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Blacksmith]>
  flags:
    jobs: Blacksmith

jobs_item_Blacksmith_info_1:
  type: item
  debug: false
  material: Leather
  display name: <&6>Leather Armor<&co>
  lore:
  - ''
  - <&6>Leather Helmet<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Helmet.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Helmet.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Leather Chestplate<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Chestplate.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Chestplate.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Leather Leggings<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Leggings.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Leggings.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Leather Boots<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Boots.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Leather_Boots.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_Blacksmith_info_2:
  type: item
  debug: false
  material: Iron_ingot
  display name: <&6>Iron Armor<&co>
  lore:
  - ''
  - <&6>Iron Helmet<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Helmet.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Helmet.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Iron Chestplate<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Chestplate.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Chestplate.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Iron Leggings<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Leggings.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Leggings.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Iron Boots<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Boots.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Boots.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_Blacksmith_info_3:
  type: item
  debug: false
  material: Gold_ingot
  display name: <&6>Golden Armor<&co>
  lore:
  - ''
  - <&6>Golden Helmet<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Helmet.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Helmet.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Golden Chestplate<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Chestplate.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Chestplate.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Golden Leggings<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Leggings.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Leggings.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Golden Boots<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Boots.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Boots.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_Blacksmith_info_4:
  type: item
  debug: false
  material: Diamond
  display name: <&6>Diamond Armor<&co>
  lore:
  - ''
  - <&6>Diamond Helmet<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Helmet.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Helmet.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Diamond Chestplate<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Chestplate.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Chestplate.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Diamond Leggings<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Leggings.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Leggings.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Diamond Boots<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Boots.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Boots.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_Blacksmith_info_5:
  type: item
  debug: false
  material: Iron_Sword
  display name: <&6>Swords<&co>
  mechanisms:
    hides: all
  lore:
  - ''
  - <&6>Stone Sword<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Stone_Sword.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Stone_Sword.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Iron Sword<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Sword.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Sword.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Golden Sword<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Sword.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Sword.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Diamond Sword<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Sword.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Sword.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_Blacksmith_info_6:
  type: item
  debug: false
  material: Blast_Furnace
  display name: <&6>Smelting<&co>
  lore:
  - ''
  - <&6>Iron Ingot<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.smelt_item.Iron_Ingot.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.smelt_item.Iron_Ingot.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Gold Ingot<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.smelt_item.Gold_Ingot.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.smelt_item.Gold_Ingot.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Netherite Scrap<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.smelt_item.Netherite_Scrap.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.smelt_item.Netherite_Scrap.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_Blacksmith_info_7:
  type: item
  debug: false
  material: Iron_Axe
  display name: <&6>Axes<&co>
  mechanisms:
    hides: all
  lore:
  - ''
  - <&6>Stone Axe<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Stone_Axe.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Stone_Axe.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Iron Axe<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Axe.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Iron_Axe.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Golden Axe<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Axe.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Golden_Axe.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - <&6>Diamond Axe<&co> <&a>$<script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Axe.money].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Blacksmith.craft_item.Diamond_Axe.experience].mul[<script[Jobs_data_script].data_key[Blacksmith.difficulty_level]>]>XP
  - ''

jobs_item_brewer:
  type: item
  debug: false
  material: brewing_stand
  display name: <&d>Brewer<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Brewing potions.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Brewer]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Brewer]>
  flags:
    jobs: brewer

jobs_item_brewer_info_1:
  type: item
  debug: false
  material: potion
  display name: <&6>Base Ingredients<&co>
  mechanisms:
    color: <color[64,64,255]>
  lore:
  - ''
  - <&6>Nether Wart<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Nether_Wart.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Nether_Wart.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Gunpowder<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Gunpowder.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Gunpowder.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Dragon<&sq>s Breath<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.dragons_breath.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.dragons_breath.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when a potion brews sucessfully.

jobs_item_brewer_info_2:
  type: item
  debug: false
  material: splash_potion
  display name: <&6>Effect Ingredients<&co>
  mechanisms:
    color: <color[128,64,255]>
  lore:
  - ''
  - <&6>Sugar<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Sugar.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Sugar.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Glistering Melon Slice<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Glistering_Melon_Slice.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Glistering_Melon_Slice.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Pufferfish<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Pufferfish.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Pufferfish.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Magma Cream<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Magma_Cream.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Magma_Cream.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Golden Carrot<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Golden_Carrot.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Golden_Carrot.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Blaze Powder<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Blaze_Powder.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Blaze_Powder.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Ghast Tear<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Ghast_Tear.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Ghast_Tear.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Turtle Shell<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Turtle_Helmet.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Turtle_Helmet.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Phantom Membrane<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Phantom_Membrane.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Phantom_Membrane.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Spider eye<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Spider_eye.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Spider_eye.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when a potion brews sucessfully.

jobs_item_brewer_info_3:
  type: item
  debug: false
  material: lingering_potion
  display name: <&6>Enhancing Ingredients<&co>
  mechanisms:
    color: <color[192,64,255]>
  lore:
  - ''
  - <&6>Glowstone Dust<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Glowstone_Dust.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Glowstone_Dust.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Redstone<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Redstone.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Redstone.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - <&6>Fermented Spider Eye<&co> <&a>$<script[Jobs_data_script].data_key[brewer.brew_item.Fermented_Spider_eye.money].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[brewer.brew_item.Fermented_Spider_eye.experience].mul[<script[Jobs_data_script].data_key[brewer.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when a potion brews sucessfully.

jobs_item_lumberjack:
  type: item
  debug: false
  material: iron_axe
  display name: <&6>Lumberjack<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Chopping down and planting trees.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Lumberjack]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Lumberjack]>
  flags:
    jobs: lumberjack

jobs_item_lumberjack_info_1:
  type: item
  debug: false
  material: dark_oak_log
  display name: <&6>Overworld Blocks<&co>
  lore:
  - ''
  - <&6>Oak<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.oak_log.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.oak_log.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Birch<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.birch_log.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.birch_log.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Dark Oak<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.dark_oak_log.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.dark_oak_log.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Spruce<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.spruce_log.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.spruce_log.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Acacia<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.acacia_log.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.acacia_log.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Jungle<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.jungle_log.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.jungle_log.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - ''
  - <&6><&o>Stripped blocks are worth the same as regular.

jobs_item_lumberjack_info_2:
  type: item
  debug: false
  material: crimson_stem
  display name: <&6>Nether Blocks<&co>
  lore:
  - ''
  - <&6>Crimson<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.crimson_stem.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.crimson_stem.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Warped<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_break.warped_stem.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_break.warped_stem.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - ''
  - <&6><&o>Stripped blocks are worth the same as regular.

jobs_item_lumberjack_info_3:
  type: item
  debug: false
  material: oak_sapling
  display name: <&6>Tree Growth<&co>
  lore:
  - ''
  - <&6>Oak<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.oak_sapling.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.oak_sapling.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Birch<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.birch_sapling.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.birch_sapling.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Dark Oak<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.dark_oak_sapling.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.dark_oak_sapling.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Spruce<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.spruce_sapling.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.spruce_sapling.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Acacia<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.acacia_sapling.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.acacia_sapling.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Jungle<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.jungle_sapling.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.jungle_sapling.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when a tree you plant fully grows.

jobs_item_lumberjack_info_4:
  type: item
  debug: false
  material: crimson_fungus
  display name: <&6>Mushroom Tree Growth<&co>
  lore:
  - ''
  - <&6>Crimson Fungus<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.crimson_fungus.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.crimson_fungus.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Warped Fungus<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.warped_fungus.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.warped_fungus.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Brown Mushroom<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.brown_mushroom.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.brown_mushroom.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - <&6>Red Mushroom<&co> <&a>$<script[Jobs_data_script].data_key[lumberjack.block_growth.brown_mushroom.money].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[lumberjack.block_growth.brown_mushroom.experience].mul[<script[Jobs_data_script].data_key[lumberjack.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when a tree you plant fully grows.

jobs_item_tinkerer:
  type: item
  debug: false
  material: crafting_table
  display name: <&a>Tinkerer<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Crafting trinkets and items.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Tinkerer]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Tinkerer]>
  flags:
    jobs: tinkerer

jobs_item_miner:
  type: item
  debug: false
  material: diamond_pickaxe
  display name: <&e>Miner<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Mining ores/rocks.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Miner]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Miner]>
  flags:
    jobs: miner

jobs_item_miner_info_1:
  type: item
  debug: false
  material: stone
  display name: <&6>Common Overworld Blocks<&co>
  lore:
  - ''
  - <&6>Stone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.stone.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.stone.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Andesite<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Andesite.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Andesite.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Diorite<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Diorite.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Diorite.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Granite<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Granite.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Granite.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Sandstone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Sandstone.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Sandstone.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - ''
  - <&6><&o>Derivative blocks have values similiar to their recipes.


jobs_item_miner_info_2:
  type: item
  debug: false
  material: diamond_ore
  display name: <&6>Overworld Ore Blocks<&co>
  lore:
  - ''
  - <&6>Coal<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Coal_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Coal_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Redstone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Redstone_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.redstone_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Iron<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.iron_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.iron_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Gold<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.gold_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.gold_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Lapis<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.lapis_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.lapis_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Diamond<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.diamond_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.diamond_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Emerald<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.emerald_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.emerald_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - ''
  - <&6><&o>Wages are independent from the quantity dropped.

jobs_item_miner_info_3:
  type: item
  debug: false
  material: prismarine_bricks
  display name: <&6>Uncommon Overworld Blocks<&co>
  lore:
  - ''
  - <&6>Stone Bricks<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.stone_bricks.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.stone_bricks.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Obsidian<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Obsidian.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Obsidian.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Prismarine<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Prismarine.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Prismarine.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Prismarine Bricks<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Prismarine_Bricks.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Prismarine_Bricks.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Dark Prismarine<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Dark_Prismarine.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Dark_Prismarine.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Sea Lantern<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Sea_Lantern.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Sea_Lantern.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - ''
  - <&6><&o>Derivative blocks have values similiar to their recipes.

jobs_item_miner_info_4:
  type: item
  debug: false
  material: netherrack
  display name: <&6>Nether Blocks<&co>
  lore:
  - ''
  - <&6>Nether Bricks<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Nether_Bricks.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Nether_Bricks.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Netherrack<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Netherrack.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Netherrack.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Basalt<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Basalt.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Basalt.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Blackstone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Blackstone.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Blackstone.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Crying Obsidian<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Crying_Obsidian.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Crying_Obsidian.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Gilded Blackstone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Gilded_Blackstone.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Gilded_Blackstone.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Glowstone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Glowstone.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Glowstone.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - ''
  - <&6><&o>Derivative blocks have values similiar to their recipes.


jobs_item_miner_info_5:
  type: item
  debug: false
  material: nether_gold_ore
  display name: <&6>Nether Ore Blocks<&co>
  lore:
  - ''
  - <&6>Nether Gold<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.nether_gold_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.nether_gold_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Ancient Debris<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Ancient_Debris.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Ancient_Debris.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Nether Quartz<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Nether_Quartz.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Nether_Quartz.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - ''
  - <&6><&o>Wages are independent from the quantity dropped.

jobs_item_miner_info_6:
  type: item
  debug: false
  material: end_stone
  display name: <&6>End Blocks<&co>
  lore:
  - ''
  - <&6>End Stone<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.nether_gold_ore.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.nether_gold_ore.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - <&6>Purpur<&co> <&a>$<script[Jobs_data_script].data_key[miner.block_break.Andesite.money].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[miner.block_break.Andesite.experience].mul[<script[Jobs_data_script].data_key[miner.difficulty_level]>]>XP
  - ''
  - <&6><&o>Derivative blocks have values similiar to their recipes.

jobs_item_fisher:
  type: item
  debug: false
  material: fishing_rod
  display name: <&9>Fisher<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Catching fish.
  - <&e>- Breeding/Killing Sea creatures.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Fisher]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Fisher]>
  flags:
    jobs: fisher

jobs_item_fisher_info_1:
  type: item
  debug: false
  material: fishing_rod
  display name: <&6>Catching Fish<&co>
  lore:
  - ''
  - <&6>Cod<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Cod.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Cod.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Salmon<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Salmon.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Salmon.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Pufferfish<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Pufferfish.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Pufferfish.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Tropical Fish<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Tropical_Fish.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Tropical_Fish.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - ''

jobs_item_fisher_info_2:
  type: item
  debug: false
  material: chest
  display name: <&6>Catching Treasure<&co>
  mechanisms:
    hides: all
    enchantments:
    - SHARPNESS,1
  lore:
  - ''
  - <&6>Bow<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Bow.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Bow.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Enchanted Book<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Enchanted_Book.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Enchanted_Book.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Fishing_Rod<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Fishing_Rod.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Fishing_Rod.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Name Tag<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Name_Tag.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Name_Tag.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Nautilus Shell<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Nautilus_Shell.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Nautilus_Shell.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Saddle<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.caught_item.Saddle.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.caught_item.Saddle.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - ''

jobs_item_fisher_info_3:
  type: item
  debug: false
  material: shears
  display name: <&4>Rip<&co>
  lore:
  - ''
  - <&6><&o>Hook a mob with your rod to damage/steal items.
  - <&6><&o>Drops are specific to the mob, with secret drops.
  - ''

jobs_item_fisher_info_4:
  type: item
  debug: false
  material: dark_oak_boat
  display name: <&6>Sea Interactions<&co>
  lore:
  - ''
  - <&6>Killing creatures<&co>
  - <&6>Cod<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Cod.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Cod.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Salmon<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Salmon.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Salmon.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Pufferfish<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Pufferfish.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Pufferfish.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Tropical Fish<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Tropical_Fish.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Tropical_Fish.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Guardian<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Guardian.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Guardian.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Elder_Guardian<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Elder_Guardian.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Elder_Guardian.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Drowned<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Drowned.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Drowned.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - <&6>Squid<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.kill_entity.Squid.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.kill_entity.Squid.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - ''
  - <&6>Breeding creatures<&co>
  - <&6>Turtle<&co> <&a>$<script[Jobs_data_script].data_key[Fisher.breed_entity.Turtle.money].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[Fisher.breed_entity.Turtle.experience].mul[<script[Jobs_data_script].data_key[Fisher.difficulty_level]>]>XP
  - ''

jobs_item_Builder:
  type: item
  debug: false
  material: stone_axe
  display name: <&3>Builder<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Placing blocks.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Builder]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Builder]>
  flags:
    jobs: Builder

jobs_item_farmer:
  type: item
  debug: false
  material: wheat_seeds
  display name: <&2>Farmer<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Growing/Harvesting crops
  - <&e>- Breeding/Butchering animals
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Farmer]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Farmer]>
  flags:
    jobs: farmer

jobs_item_farmer_info_1:
  type: item
  debug: false
  material: wheat_seeds
  display name: <&6>Crop Growth<&co>
  lore:
  - ''
  - <&6>Wheat<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_growth.Wheat.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_growth.Wheat.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Beetroots<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_growth.Beetroots.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_growth.Beetroots.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Carrots<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_growth.Carrots.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_growth.Carrots.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Potatoes<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_growth.Potatoes.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_growth.Potatoes.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Cocoa<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_growth.Cocoa.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_growth.Cocoa.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Nether Wart<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_growth.Nether_Wart.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_growth.Nether_Wart.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when a crop you plant fully grows.

jobs_item_farmer_info_2:
  type: item
  debug: false
  material: iron_hoe
  display name: <&6>Crop Harvesting<&co>
  lore:
  - ''
  - <&6>Wheat<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Wheat.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Wheat.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Beetroots<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Beetroots.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Beetroots.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Carrots<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Carrots.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Carrots.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Potatoes<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Potatoes.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Potatoes.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Cocoa<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Cocoa.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Cocoa.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Nether Wart<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Nether_Wart.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Nether_Wart.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Melon<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Melon.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Melon.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Pumpkin<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Pumpkin.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Pumpkin.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Sugar Cane<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.Sugar_Cane.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.Sugar_Cane.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Brown Mushroom<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.brown_mushroom.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.brown_mushroom.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>red Mushroom<&co> <&a>$<script[Jobs_data_script].data_key[farmer.block_break.red_mushroom.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.block_break.red_mushroom.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - ''
  - <&6><&o>Wages are independent from the items dropped.

jobs_item_farmer_info_3:
  type: item
  debug: false
  material: iron_sword
  display name: <&6>Butchering<&co>
  lore:
  - ''
  - <&6>Cows<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.Cow.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.Cow.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Sheep<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.Sheep.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.Sheep.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Rabbits<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.Rabbit.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.Rabbit.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Chickens<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.Chicken.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.Chicken.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Mooshroom<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.mushroom_cow.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.mushroom_cow.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Pigs<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.Pig.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.Pig.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Horses<&co> <&a>$<script[Jobs_data_script].data_key[farmer.kill_entity.Horse.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.kill_entity.Horse.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - ''
  - <&6><&o>Wages are independent from the items dropped.


jobs_item_farmer_info_4:
  type: item
  debug: false
  material: apple
  display name: <&6>Husbandry<&co>
  lore:
  - ''
  - <&6>Cows<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.Cow.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.Cow.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Sheep<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.Sheep.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.Sheep.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Rabbits<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.Rabbit.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.Rabbit.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Chickens<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.Chicken.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.Chicken.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Mooshroom<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.mushroom_cow.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.mushroom_cow.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Pigs<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.Pig.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.Pig.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - <&6>Horses<&co> <&a>$<script[Jobs_data_script].data_key[farmer.breed_entity.Horse.money].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[farmer.breed_entity.Horse.experience].mul[<script[Jobs_data_script].data_key[farmer.difficulty_level]>]>XP
  - ''
  - <&6><&o>You are paid when the animals successfully breed.
  - <&6><&o>Each parent can generate income.

jobs_item_hunter:
  type: item
  debug: false
  material: bow
  display name: <&c>Hunter<&co>
  lore:
  - <&6>Gains <&a>money <&6>from<&co>
  - <&e>- Killing monsters.
  - <&e>- Taming/Breeding forest creatures.
  - ''
  - <&6>Click for amounts earned per action.
  - ''
  - <&6>Current Workers<&co><&e> <server.flag[jobs.count.Hunter]||0>
  - <&6>Current Employment Modifier<&co><&e> <server.flag[jobs.rarity.balancer.Hunter]>
  flags:
    jobs: hunter


jobs_item_hunter_info_1:
  type: item
  debug: false
  material: iron_sword
  display name: <&6>Common Monster Slaying<&co>
  lore:
  - ''
  - <&6>Creeper<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Creeper.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Creeper.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Skeleton<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Skeleton.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Skeleton.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Zombie<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Zombie.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Zombie.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Spider<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Spider.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Spider.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Silverfish<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Silverfish.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Silverfish.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Iron Golem<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Iron_Golem.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Iron_Golem.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Phantom<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Phantom.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Phantom.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Guardian<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Guardian.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Guardian.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Pillager<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Pillager.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Pillager.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when you deal the killing blow.

jobs_item_hunter_info_2:
  type: item
  debug: false
  material: diamond_sword
  display name: <&6>Uncommon Monster Slaying<&co>
  lore:
  - ''
  - <&6>Cave Spider<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Cave_spider.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Cave_spider.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Enderman<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Enderman.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Enderman.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Stray<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Stray.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Stray.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Snowman<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Snowman.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Snowman.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Shulker<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Shulker.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Shulker.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Elder Guardian<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Elder_Guardian.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Elder_Guardian.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Drowned<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Drowned.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Drowned.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Husk<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Husk.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Husk.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Vindicator<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Vindicator.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Vindicator.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Slime<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Slime.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Slime.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Endermite<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Endermite.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Endermite.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when you deal the killing blow.

jobs_item_hunter_info_3:
  type: item
  debug: false
  material: netherite_sword
  display name: <&6>Nether Monster Slaying<&co>
  lore:
  - ''
  - <&6>Blaze<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Blaze.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Blaze.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Ghast<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Ghast.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Ghast.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Wither Skeleton<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Wither_Skeleton.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Wither_Skeleton.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Hoglin<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Hoglin.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Hoglin.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Piglin<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Piglin.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Piglin.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Zombified Piglin<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Zombified_Piglin.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Zombified_Piglin.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Magma Cube<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Magma_Cube.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Magma_Cube.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when you deal the killing blow.

jobs_item_hunter_info_4:
  type: item
  debug: false
  material: dragon_head
  display name: <&6>Boss Monster Slaying<&co>
  lore:
  - ''
  - <&6>Ender Dragon<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Ender_Dragon.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Ender_Dragon.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Wither<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Wither.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Wither.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Illusioner<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Illusioner.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Illusioner.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Evoker<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Evoker.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Evoker.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Ravager<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Ravager.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Ravager.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Piglin Brute<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Piglin_Brute.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Piglin_Brute.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Witch<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Witch.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Witch.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when you deal the killing blow.

jobs_item_hunter_info_5:
  type: item
  debug: false
  material: iron_axe
  display name: <&6>Wild Animal Slaying<&co>
  lore:
  - ''
  - <&6>Wolf<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Wolf.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Wolf.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Polar Bear<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Polar_Bear.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Polar_Bear.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Panda<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Panda.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Panda.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Fox<&co> <&a>$<script[Jobs_data_script].data_key[hunter.kill_entity.Fox.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.kill_entity.Fox.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when you deal the killing blow.

jobs_item_hunter_info_6:
  type: item
  debug: false
  material: lead
  display name: <&6>Wild Animal Taming<&co>
  lore:
  - ''
  - <&6>Wolf<&co> <&a>$<script[Jobs_data_script].data_key[hunter.tame_entity.Wolf.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.tame_entity.Wolf.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Ocelot<&co> <&a>$<script[Jobs_data_script].data_key[hunter.tame_entity.Ocelot.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.tame_entity.Ocelot.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Parrot<&co> <&a>$<script[Jobs_data_script].data_key[hunter.tame_entity.Parrot.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.tame_entity.Parrot.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You recieve the reward when an attempt succeeds.

jobs_item_hunter_info_7:
  type: item
  debug: false
  material: cooked_mutton
  display name: <&6>Wild Animal Breeding<&co>
  lore:
  - ''
  - <&6>Wolf<&co> <&a>$<script[Jobs_data_script].data_key[hunter.Breed_entity.Wolf.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.Breed_entity.Wolf.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Ocelot<&co> <&a>$<script[Jobs_data_script].data_key[hunter.Breed_entity.Ocelot.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.Breed_entity.Ocelot.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Panda<&co> <&a>$<script[Jobs_data_script].data_key[hunter.Breed_entity.Panda.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.Breed_entity.Panda.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Fox<&co> <&a>$<script[Jobs_data_script].data_key[hunter.Breed_entity.Fox.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.Breed_entity.Fox.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - <&6>Wolf<&co> <&a>$<script[Jobs_data_script].data_key[hunter.Breed_entity.Wolf.money].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]><&6>/<&b><script[Jobs_data_script].data_key[hunter.Breed_entity.Wolf.experience].mul[<script[Jobs_data_script].data_key[hunter.difficulty_level]>]>XP
  - ''
  - <&6><&o>You are paid when the animals successfully breed.
  - <&6><&o>Each parent can generate income.
