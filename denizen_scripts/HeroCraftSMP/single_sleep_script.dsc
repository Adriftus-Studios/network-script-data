single_sleep_script:
  type: world
  debug: false
  time_change_duration_in_ticks: 140
  events:
    on player enters bed bukkit_priority:MONITOR:
      - announce "<&6><player.display_name> <&e>went to bed. Skipping Night!"
      - ratelimit <player.world> 10s
      - define increment <server.worlds.first.time.sub[24000].abs.div[<script[single_sleep_script].data_key[time_change_duration_in_ticks]>].round_up>
      - repeat <script[single_sleep_script].data_key[time_change_duration_in_ticks]>:
        - adjust <server.worlds.first> time:<server.worlds.first.time.add[<[increment]>]>
        - wait 1t
      - if <server.worlds.first.thundering>:
        - adjust <server.worlds.first> thundering:false