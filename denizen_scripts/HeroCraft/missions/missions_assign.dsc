# -- MISSIONS ASSIGN ON JOIN
missions_assign:
  type: world
  debug: false
  events:
    on player joins:
      # Daily
      - if <player.has_flag[missions_daily].not>:
        - run missions_reset def:daily
        - run missions_generate def:daily
      # Weekly
      - if <player.has_flag[missions_weekly].not>:
        - run missions_reset def:weekly
        - run missions_generate def:weekly
      # Monthly
      - if <player.has_flag[missions_monthly].not>:
        - run missions_reset def:monthly
        - run missions_generate def:monthly
