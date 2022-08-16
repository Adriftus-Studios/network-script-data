custom_mob_prefix_confusing:
  Type: world
  debug: false
  events:
    after entity_flagged:confusing damages player:
        - define hotbar <player.inventory.slot[1|2|3|4|5|6|7|8|9].random[9999]>
        - repeat 9:
            - inventory set air slot:<[value]> d:<player.inventory>
            - inventory set <[hotbar].get[<[value]>]> slot:<[value]> d:<player.inventory>