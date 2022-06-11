suicide_command:
  type: command
  name: suicide
  debug: false
  description: Kills yourself
  usage: /suicide
  permission: behr.essentials.suicide
  script:
  # % ██ [ Check Args ] ██
    - if !<context.args.is_empty>:
      - narrate "<&c>Invalid usage - /suicide"

  # % ██ [ Check player's Gamemode ] ██
    - if <player.gamemode.advanced_matches[spectator|creative]>:
      - repeat 10:
        - animate <player> animation:hurt
        - wait 2t
      - adjust <player> health:0

  # % ██ [ Kill Self ] ██
    - else:
      - define gamemode <player.gamemode>
      - while ( <player.health> > 0 || <player.is_online> ) && <player.gamemode> == <[gamemode]>:
        - adjust <player> no_damage_duration:1t
        - hurt 1
        - wait 2t
