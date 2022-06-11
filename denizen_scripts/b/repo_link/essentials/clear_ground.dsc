clear_ground_command:
  type: command
  name: clear_ground
  debug: false
  description: Clears the ground of dropped items around you
  usage: /clear_ground
  permission: behr.essentials.clear_ground
  aliases:
    - cleanground
    - groundclean
  script:
  # % ██ [ if emptying  ] ██
    - if !<context.args.is_empty>:
      - narrate "<&c>Invalid usage - /clear_ground"
      - stop

  # % ██ [ Find Entnties ] ██
    - define entities <player.location.find_entities[DROPPED_ITEM].within[128]>
    - remove <[entities]>
    - narrate "<&a>Removed <[entities].size> items on the ground"
