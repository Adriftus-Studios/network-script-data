jobs_join_events:
  type: world
  debug: false
  events:
    on player joins:
      - if !<player.has_flag[jobs.first_join]>:
        - define jobs_list <list[weaponsmith|brewer|lumberjack|miner|farmer|enchanter|hunter|chef|archaeologist|armorsmith|fisher]>
        - foreach <[jobs_list]> as:job:
          - flag <player> jobs.<[job]>.level:1
          - flag <player> jobs.<[job]>.experience_earned:0
        - flag <player> jobs.active:0
        - flag <player> jobs.allowed:<&6>Complete<&sp><&e>Tutorial<&sp><&6>to<&sp>unlock.
        - flag <player> jobs.blocks_allowed:<&6>Complete<&sp><&e>Tutorial<&sp><&6>to<&sp>unlock.
        - flag <player> jobs.blocks_owned:<list[]>
        - flag <player> jobs.current_list:<list[]>
        - flag <player> jobs.first_join
        - wait 1t

      - if <player.has_flag[jobs.money_due]>:
        - narrate "<&6>You earned [<&a>$<player.flag[jobs.money_due]><&6>] while offline."
        - give money quantity:<player.flag[jobs.money_due]>
        - flag <player> jobs.money_due:!