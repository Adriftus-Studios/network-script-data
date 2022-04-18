throw_item_projectile:
  type: task
  debug: false
  script:
    - spawn snowball[item=<context.item>] <player.location.above[300]> save:ball
    - shoot <entry[ball].spawned_entity> speed:3 origin:<player.eye_location>
    - take item:item_in_hand quantity:1

throw_item:
  type: task
  debug: false
  definition: power
  script:
    - spawn snowball[item=<context.item>] <player.location.above[300]> save:ball
    - shoot <entry[ball].spawned_entity> speed:<[power]> origin:<player.eye_location>
    - take item:item_in_hand quantity:1