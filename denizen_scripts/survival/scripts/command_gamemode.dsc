gamemode_creative:
  type: command
  debug: true
  gamemode: creative
  name: gmc
  description: Set yourself, or another player to Creative mode.
  usage: /gmc
  permission: dutilities.gamemode.creative
  tab complete:
    - inject gamemode_tab_complete
  script:
    - inject gamemode_handle_command

gamemode_adventure:
  type: command
  debug: true
  gamemode: adventure
  name: gma
  description: Set yourself, or another player to Adventure mode.
  usage: /gma
  permission: dutilities.gamemode.adventure
  tab complete:
    - inject gamemode_tab_complete
  script:
    - inject gamemode_handle_command

gamemode_survival:
  type: command
  debug: true
  gamemode: survival
  name: gms
  description: Set yourself, or another player to Survival mode.
  usage: /gms
  permission: dutilities.gamemode.survival
  tab complete:
    - inject gamemode_tab_complete
  script:
    - inject gamemode_handle_command

gamemode_spectator:
  type: command
  debug: true
  gamemode: spectator
  name: gmsp
  description: Set yourself, or another player to Spectator mode.
  usage: /gmsp
  permission: dutilities.gamemode.spectator
  tab complete:
    - inject gamemode_tab_complete
  script:
    - inject gamemode_handle_command

gamemode_tab_complete:
  type: task
  debug: false
  script:
    - if !<player.has_permission[dutilities.gamemode.other]>:
      - determine <list[]>
    - else if <context.args.is_empty||true> || <context.raw_args.ends_with[<&sp>]>:
      - determine <server.list_online_players.parse[name]>
    - else if <context.args.size> >= 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[<context.args.size>]>]]>

gamemode_handle_command:
  type: task
  debug: false
  script:
    - if <context.args.is_empty||true> && !<context.server>:
      - define target_list:<player>
    - else if <context.server>:
      - announce to_console "<&c>You must specify a player when using this command from Console."
      - stop
    - else:
      - define target_list:<context.args>
    - define gamemode:<queue.script.yaml_key[gamemode]>
    - foreach <[target_list]> as:target:
      - if !<[target].is_player>:
        - define target:<server.match_player[<[target]>]||null>
      - if <[completed].contains[<[target]>]||false>:
        - foreach next
      - if <[target]> != null:
        - if <[target]> == <player>:
          - adjust <player> gamemode:<[gamemode]>
          - narrate "<&e>You have set yourself to <&6><[gamemode].to_titlecase> Mode<&e>."
        - else if <[target].is_online>:
          - adjust <[target]> gamemode:<[gamemode]>
          - narrate "<&e>You have been to set to <&6><[gamemode].to_titlecase> Mode<&e> by <&b><player.name||Console>" targets:<[target]>
          - narrate "<&e>You have set <&b><[target].name><&e> to <&6><[gamemode].to_titlecase> Mode<&e>."
        - else:
          - adjust <[target]> gamemode:<[gamemode]>
          - narrate "<&e>You have set <&b><[target].name><&6>(<&7>OFFLINE<&6>)<&e> to <&6><[gamemode].to_titlecase> Mode<&e>."
        - define completed:|:<[target]>
