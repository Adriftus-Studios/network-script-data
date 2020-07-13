hub_pole_click:
  type: world
  events:
    on player right clicks iron_bars:
      - if <context.location.notable_name.starts_with[behr_pole]||false> && !<player.has_flag[pole_dance]>:
        - flag player pole_dance:<player.location.simple>
        - while <player.has_flag[pole_dance]> && <player.is_online>:
          - animate <player> sneak
          - wait 5t
          - if <player.is_online>:
            - flag player pole_dancing:!
            - stop
          - animate <player> stop_sneaking
          - wait 5t
    on player walks flagged:pole_dance:
      - if <player.location.simple> != <player.flag[pole_dance]>:
        - flag player pole_dance:!