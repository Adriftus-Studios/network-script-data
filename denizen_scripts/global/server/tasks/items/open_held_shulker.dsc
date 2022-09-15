open_held_shulker:
  type: task
  debug: false
  script:
    - if <player.is_sneaking>:
      - determine passively cancelled
      - inventory open d:<player.item_in_hand.inventory>