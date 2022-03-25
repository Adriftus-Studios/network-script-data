main_menu_cosmetics:
  type: item
  debug: false
  material: dragon_head
  display name: <&d>Cosmetics
  lore:
    - "<&e>Control your cosmetics!"
  mechanisms:
    custom_model_data: 1
  flags:
    run_script: cosmetic_main_menu_open

main_menu_help:
  type: item
  debug: false
  material: salmon
  display name: <&a>Help!
  lore:
    - "<&e>Request Help!"
    - "<&e>Not Yet Implement"
  mechanisms:
    custom_model_data: 1
  flags:
    run_script: cancel

main_menu_commands:
  type: item
  debug: false
  material: command_block
  display name: <&6>Commands!
  lore:
    - "<&e>Access your commands!"
    - "<&e>Not Yet Implement"
  mechanisms:
    custom_model_data: 1
  flags:
    run_script: cancel

main_menu_settings:
  type: item
  debug: false
  material: piston
  display name: <&e>Settings!
  lore:
    - "<&e>Settings for your gameplay"
    - "<&e>Not Yet Implement"
  mechanisms:
    custom_model_data: 1
  flags:
    run_script: cancel

main_menu_mail:
  type: item
  debug: false
  material: paper
  display name: <&a>Mailbox!
  lore:
    - "<&e>Check your Mailbox!"
    - "<&e>Not Yet Implement"
  mechanisms:
    custom_model_data: 1
  flags:
    run_script: cancel

main_menu_inventory_open:
  type: task
  debug: false
  script:
    - define inventory <inventory[main_menu_inventory]>
    - define "lore:!|:<&e>Title<&co> <proc[get_player_title]>"
    - define "lore:|:<&e>Server<&co> <server.flag[display_name]||<&7><bungee.server>>"
    - inventory set slot:5 o:<item[player_head].with[display=<player.display_name>;lore=<[lore]>;skull_skin=<player.skull_skin>]> d:<[inventory]>
    - inventory open d:<[inventory]>

main_menu_inventory:
  type: inventory
  debug: false
  inventory: chest
  gui: true
  title: <&a>Menu Placeholder!
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [main_menu_mail] [] [main_menu_cosmetics] [] [main_menu_commands] [] [main_menu_settings] []
    - [] [] [] [] [main_menu_help] [] [] [] []
