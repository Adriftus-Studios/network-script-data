custom_mob_prefix_confusing:
  Type: world
  debug: false
  events:
    after entity_flagged:confusing damages player:
        - ratelimit <context.damager> 20s
        - define hotbar <player.inventory.slot[1|2|3|4|5|6|7|8|9].random[9]>
        - repeat 9:
          - fakeitem <[hotbar].get[<[value]>]> slot:<[value]> duration:5s
        - wait 5.1s
        - inventory update