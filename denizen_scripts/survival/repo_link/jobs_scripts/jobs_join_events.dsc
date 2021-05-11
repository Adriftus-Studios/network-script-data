jobs_join_events:
  type: world
  debug: false
  events:
    on player joins:
      ##Sets the required flags for the player to participate in the jobs system without blowing it up with errors
      - if !<player.has_flag[jobs.first_join]>:
        - define jobs_list <script[Jobs_data_script].list_keys[jobs_list]>
        - foreach <[jobs_list]> as:job:
          - flag <player> jobs.<[job]>.level:1
          - flag <player> jobs.<[job]>.experience_earned:0
        - flag <player> jobs.active:0
        - flag <player> jobs.allowed:1
        - flag <player> jobs.blocks_allowed:2
        - flag <player> jobs.blocks_owned:<list[]>
        - flag <player> jobs.current_list:<list[]>
        - flag <player> jobs.first_join
        - advancement grant:<player> id:jobs_master_advancement
        - wait 1t

      ##Gives the player money that they earned offline from crops/etc
      - if <player.has_flag[jobs.money_due]>:
        - narrate "<&6>You earned [<&a>$<player.flag[jobs.money_due]><&6>] while offline."
        - give money quantity:<player.flag[jobs.money_due]>
        - flag <player> jobs.money_due:!

      - if <player.has_flag[jobs.advancement_due]>:
        - foreach <player.flag[jobs.advancement_due]> as:job:
          - define job <[job].before[~]>
          - define level <[job].after[~]>
          - run jobs_advancement_compiler def.player:<player> def.job:<[job]> def.level:<[level]>
        - flag <player> jobs.advancement_due:!

      ##Announces a weekend boost
      - if <server.has_flag[jobs.weekend_boost]>:
        - narrate "<&6>There is a <&3><server.flag[jobs.weekend_boost]>X<&6> weekend boost on jobs <&a>money<&e>/<&b>experience "

      ##Announces a donor boost
      - if <server.has_flag[jobs.donor_boost]>:
        - narrate "<&6>There is a <&3><server.flag[jobs.donor_boost]>X<&6> donor boost on jobs <&a>money<&e>/<&b>experience "
