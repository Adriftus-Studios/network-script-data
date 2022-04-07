
tpa_command:
    type: command
    name: tpa
    description: Used To Request A Teleport
    usage: /tpa (name)
    permission: adriftus.staff
    script:
    - if <context.args.size> < 1:
      - narrate "<red><bold>Please Use A Name That's Online"
      - stop
    - define target <server.match_player[<context.args.get[1]>].if_null[null]>
    - if <[target]> = null:
      - narrate "<red><bold>This Is Not A Player"
      - stop
    - if <[target]> = <player.name>:
      - narrate "You Can Not Tpaccept Yourself"
      - stop
    - else:
      - inject tpa_execute

tpa_crystal:
  type: item
  material: feather
  display name: <&2>TPA Crystal
  data:
    recipe_book_category: travel.crystal
  lore:
    - "<&e>--------------------"
    - "<&e>Use to request a teleport"
    - "<&e>You can target anyone awake"
    - "<&e>--------------------"
  flags:
    right_click_script:
      - tpa_remove_item
      - target_players_open
    callback: tpa_execute
    type: crystal
  mechanisms:
    custom_model_data: 102
  recipes:
    1:
      type: shaped
      input:
      - magical_pylon|air|magical_pylon
      - air|emerald_block|air
      - magical_pylon|air|magical_pylon

tpa_execute:
  type: task
  debug: false
  definitions: target
  script:
    - inventory close
    - define prompt "<proc[get_player_display_name]><&r><&e> wants to teleport to you"
    - narrate "<&a>TPA Request sent!"
    - flag <[target]> tmp.tpa_accept:<player> expire:30s
    - run chat_confirm def:<[prompt]>|tpa_command_callback player:<[target]>

tpa_remove_item:
  type: task
  debug: false
  script:
    - take iteminhand
    - wait 1t
    - run totem_test def:102
    - wait 2s

tpa_command_callback:
    type: task
    debug: true
    definitions: bool
    script:
    - if !<player.has_flag[tmp.tpa_accept]>:
      - narrate "<&c>TPA Request has expired."
      - stop
    - if !<player.flag[tmp.tpa_accept].is_online>:
      - narrate "<&c>Player is offline."
      - stop
    - if !<[bool]>:
      - narrate "<&c>TPA was Denied" targets:<player.flag[tmp.tpa_accept]>|<player>
      - stop
    - narrate "<&a>TPA Accepted!" targets:<player.flag[tmp.tpa_accept]>|<player>
    - define location <player.location>
    - run teleportation_animation_run def:<[location]> player:<player.flag[tmp.tpa_accept]>



