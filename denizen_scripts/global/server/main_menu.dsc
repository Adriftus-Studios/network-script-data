main_menu_cosmetics:
  type: item
  debug: false
  material: paper
  display name: <&d><&l>Cosmetics
  lore:
    - "<&e>Control your cosmetics!"
  mechanisms:
    custom_model_data: 102
    hides: ALL
  enchantments:
    - sharpness:1
  flags:
    run_script: cosmetic_main_menu_open

main_menu_help:
  type: item
  debug: false
  material: paper
  display name: <&c><&l>Help
  lore:
    - "<&e>Request A Staff Member!"
    - "<&7>- 5 Minute Cooldown -"
  mechanisms:
    custom_model_data: 105
  flags:
    run_script: main_menu_request_help

main_menu_controls:
  type: item
  debug: false
  material: paper
  display name: <&6><&l>Controls
  lore:
    - "<&e>Server Specific Controls!"
    - "<&e>Not Yet Implemented"
  mechanisms:
    custom_model_data: 104
  flags:
    run_script: cancel

main_menu_settings:
  type: item
  debug: false
  material: paper
  display name: <&e><&l>Settings
  lore:
    - "<&e>Settings for your gameplay"
    - "<&e>Not Yet Implemented"
  mechanisms:
    custom_model_data: 101
  flags:
    run_script: cancel

main_menu_mail:
  type: item
  debug: false
  material: feather
  display name: <&a><&l>Mailbox
  lore:
    - "<&e>Check your Mailbox!"
    - "<&e>Not Yet Implemented"
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: cancel

main_menu_chat:
  type: item
  debug: false
  material: paper
  display name: <&a><&l>Chat Settings
  lore:
    - "<&e>Chat Channels!"
    - "<&e>Manage what you see!"
  mechanisms:
    custom_model_data: 109
  flags:
    run_script: chat_settings_open

main_menu_recipes:
  type: item
  debug: false
  material: paper
  display name: <&6><&l>Recipes
  lore:
    - "<&e>Available custom recipes!"
  mechanisms:
    custom_model_data: 103
  flags:
    run_script: crafting_book_open

main_menu_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[main_menu_inventory]>
    - define "lore:!|:<&e>Title<&co> <proc[get_player_title]>"
    - define "lore:|:<&e>Server<&co> <server.flag[display_name]||<&7><bungee.server>>"
    - inventory set slot:14 o:<item[player_head].with[custom_model_data=1;display=<&6><&l><player.name>;lore=<[lore]>;skull_skin=<player.skull_skin>]> d:<[inventory]>
    - inventory open d:<[inventory]>

main_menu_inventory:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6927]>
  slots:
    - [main_menu_mail] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [main_menu_cosmetics] [] [] [] []
    - [] [] [main_menu_recipes] [] [] [] [main_menu_controls] [] []
    - [main_menu_chat] [] [] [] [main_menu_help] [] [] [] [main_menu_settings]

main_menu_request_help:
  type: task
  debug: false
  script:
    - ratelimit <player> 5m
    - run chat_system_speak "def.message:<&lt>@&976324656594300958<&gt> <&lt>@&976324625678082068<&gt><&nl>I am requesting a staff member to help!<&nl>Server<&co> <bungee.server><&nl>Location<&co> <player.location.simple>" def.channel:staff
