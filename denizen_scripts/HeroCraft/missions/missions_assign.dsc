# -- MISSIONS ASSIGN ON JOIN
missions_assign:
  type: world
  debug: false
  events:
    after player joins:
      # Daily
      - if <player.has_flag[missions_daily].not>:
        - run missions_reset def:daily
        - run missions_generate def:daily
      - wait 1t
      # Weekly
      - if <player.has_flag[missions_weekly].not>:
        - run missions_reset def:weekly
        - run missions_generate def:weekly
      - wait 1t
      # Monthly
      - if <player.has_flag[missions_monthly].not>:
        - run missions_reset def:monthly
        - run missions_generate def:monthly
