jobs_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: Jobs Browsing Menu
  size: 45
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
  - [standard_filler] [standard_filler] [standard_filler] [jobs_item_farmer] [jobs_item_lumberjack] [jobs_item_miner] [standard_filler] [standard_filler] [standard_filler]
  - [server_jobs_info_head] [standard_filler] [jobs_item_chef] [jobs_item_brewer] [jobs_item_Archaeologist] [jobs_item_blacksmith] [jobs_item_special_explainer] [standard_filler] [standard_close_button]
  - [standard_filler] [standard_filler] [standard_filler] [jobs_item_fisher] [jobs_item_hunter] [jobs_item_enchanter] [standard_filler] [standard_filler] [standard_filler]
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

personal_jobs_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <Player.name>'s Jobs Statistics
  size: 45
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
  - [standard_filler] [standard_filler] [standard_filler] [player_info_farmer] [player_info_lumberjack] [player_info_miner] [standard_filler] [standard_filler] [standard_filler]
  - [player_jobs_info_head] [standard_filler] [player_info_chef] [player_info_brewer] [player_info_Archaeologist] [player_info_blacksmith] [jobs_item_special_explainer] [standard_filler] [standard_close_button]
  - [standard_filler] [standard_filler] [standard_filler] [player_info_fisher] [player_info_hunter] [player_info_enchanter] [standard_filler] [standard_filler] [standard_filler]
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]

chef_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&f>Chef Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [jobs_item_chef_info_1] [standard_filler] [jobs_item_chef_info_2] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_back_button]

enchanter_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&b>Enchanter Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [jobs_item_enchanter_info_1] [standard_filler] [jobs_item_enchanter_info_3] [standard_filler] [jobs_item_enchanter_info_5] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [jobs_item_enchanter_info_2]  [standard_filler] [jobs_item_enchanter_info_4] [standard_filler] [standard_filler] [standard_back_button]

archaeologist_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&e>Archaeologist Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [jobs_item_archaeologist_info_1] [standard_filler] [jobs_item_archaeologist_info_2] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_back_button]

blacksmith_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&8>Blacksmith Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [jobs_item_Blacksmith_info_1] [standard_filler] [jobs_item_Blacksmith_info_2] [standard_filler] [jobs_item_Blacksmith_info_3 [standard_filler] [jobs_item_Blacksmith_info_4] [standard_filler]
  - [] [standard_filler] [jobs_item_Blacksmith_info_5] [standard_filler] [jobs_item_Blacksmith_info_6] [standard_filler] [jobs_item_Blacksmith_info_7] [standard_filler] [standard_back_button]

brewer_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&d>Brewer Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [jobs_item_brewer_info_1] [standard_filler] [jobs_item_brewer_info_3] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [standard_filler] [jobs_item_brewer_info_2] [standard_filler] [standard_filler] [standard_filler] [standard_back_button]

lumberjack_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&6>Lumberjack Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [jobs_item_lumberjack_info_1] [standard_filler] [standard_filler] [standard_filler] [jobs_item_lumberjack_info_2] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [jobs_item_lumberjack_info_3]  [standard_filler] [jobs_item_lumberjack_info_4] [standard_filler] [standard_filler] [standard_back_button]

Tinkerer_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&a>Tinkerer Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_back_button]


miner_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&e>Miner Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [jobs_item_miner_info_1] [jobs_item_miner_info_3] [jobs_item_miner_info_4] [jobs_item_miner_info_6] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [jobs_item_miner_info_2] [jobs_item_miner_info_5] [standard_filler]  [standard_filler] [standard_filler] [standard_back_button]

fisher_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&9>Fisher Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [jobs_item_fisher_info_1] [standard_filler] [jobs_item_fisher_info_2] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [jobs_item_fisher_info_4] [standard_filler] [jobs_item_fisher_info_3] [standard_filler] [standard_filler] [standard_filler] [standard_back_button]

Builder_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&3>Builder Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_back_button]


farmer_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&2>Farmer Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [standard_filler] [jobs_item_farmer_info_1] [standard_filler] [standard_filler] [standard_filler] [jobs_item_farmer_info_3] [standard_filler] [standard_filler]
  - [] [standard_filler] [standard_filler] [jobs_item_farmer_info_2] [standard_filler] [jobs_item_farmer_info_4] [standard_filler] [standard_filler] [standard_back_button]

hunter_info_gui:
  type: inventory
  debug: false
  gui: true
  inventory: chest
  title: <&c>Hunter Job Information
  size: 18
  definitions:
    filler: gray_stained_glass_pane[display_name=<&a>]
  slots:
  - [standard_filler] [jobs_item_hunter_info_1] [standard_filler] [jobs_item_hunter_info_3] [standard_filler] [jobs_item_hunter_info_5] [standard_filler] [jobs_item_hunter_info_7] [standard_filler]
  - [] [standard_filler] [jobs_item_hunter_info_2] [standard_filler] [jobs_item_hunter_info_4] [standard_filler] [jobs_item_hunter_info_6] [standard_filler] [standard_back_button]
