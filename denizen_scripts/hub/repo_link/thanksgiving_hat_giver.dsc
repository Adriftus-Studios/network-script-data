thanksgiving_2022_hat_giver:
  type: world
  debug: false
  events:
    on player joins:
      - if <player.has_flag[thanksgiving_2022_hats]>:
        - give hat_pilgrim_normal_item
        - give hat_pilgrim_oversized_item
        - flag <player> thanksgiving_2022_hats
