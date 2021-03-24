weekly_token_reset:
  type: command
  name: weekly_token_reset
  debug: false
  usage: /weekly_token_reset
  permission: adriftus.staff
  description: resets the weekly progress for the current world event, and hands out player rewards/tokens. To be updated and filled out each time.
  script:
    - define week <element[2]>
    - define event world_barrier
    - if <server.has_file[<[event]>.yml]>:
      - yaml load:<[event]>.yml id:<[event]>
    - if !<server.has_file[<[event]>.yml]>:
      - yaml id:<[event]> create
      - yaml load:<[event]>.yml id:<[event]>
    - foreach <server.players> as:rewardee:
      - yaml id:<[event]> set <[rewardee].name>_week_<[week]>_start_tokens:<[rewardee].flag[world_event.tokens.current]||0>
      - yaml id:<[event]> set <[rewardee].name>_week_<[week]>_progress:<[rewardee].flag[world_event.progress]||0>
      - wait 1t
      - flag <[rewardee]> world_event.tokens.current:+:<[rewardee].flag[world_event.progress].div[8].round_down||0>
      - define server_percentage <element[<server.flag[world_event.progress]||0>].div[<script[world_event_config].data_key[server_amount_needed]>]>
      - define personal_percentage <element[<[rewardee].flag[world_event.progress]||0>].div[<script[world_event_config].data_key[personal_amount_needed]>].round_to[1]>
      - yaml id:<[event]> set <[rewardee].name>_week_<[week]>_progress_percent:<[personal_percentage]>
      - wait 2t
      - if <[personal_percentage]> >= 0.2:
        - define current_tokens world_event.tokens.current:<[rewardee].flag[world_event.progress].div[8].round_down||0>
        - wait 2t
        - flag <[rewardee]> world_event.tokens.current:+:1000
      - if <[personal_percentage]> >= 0.4:
        - if <player.inventory.is_full>:
          - if <player.enderchest.is_full>:
            - flag <[rewardee]> 40_reward_due
          - else:
            - give food_crate to:<[rewardee].enderchest> quantity:3
        - else:
          - give food_crate to:<[rewardee].inventory> quantity:3
      - if <[personal_percentage]> >= 0.6:
        - if <player.inventory.is_full>:
          - if <player.enderchest.is_full>:
            - flag <[rewardee]> 60_reward_due
          - else:
            - give teleportation_crystal quantity:3 to:<[rewardee].enderchest>
        - else:
          - give teleportation_crystal quantity:3 to:<[rewardee].inventory>
      - if <[personal_percentage]> >= 0.8:
        - if <yaml[claims].read[limits.max.<[rewardee].uuid>]||null> != null:
          - yaml id:claims set limits.max.<[rewardee].uuid>:+:10
      - if <[server_percentage]> >= 1.0 && <[personal_percentage]> >= 1.0::
        - if <yaml[claims].read[limits.max.<[rewardee].uuid>]||null> != null:
#          - yaml id:claims set limits.max.<[rewardee].uuid>:+:10
      - wait 2t
      - yaml id:<[event]> set <[rewardee].name>_week_<[week]>_end_tokens:<player.flag[world_event.tokens.current]>
      - flag <[rewardee]> world_event.progress:!
    - yaml id:<[event]> set !week_<[week]>_progress:<server.flag[world_event.progress]||0>
    - yaml id:<[event]> set !week_<[week]>_progress_percent:<element[<server.flag[world_event.progress]||0>].div[<script[world_event_config].data_key[server_amount_needed]>]||0>
    - yaml id:<[event]> savefile:<[event]>.yml
    - narrate "<&b>Token and reward distribution for week <[week]> complete!"
    - wait 2t
    - flag <server> world_event.progress:!