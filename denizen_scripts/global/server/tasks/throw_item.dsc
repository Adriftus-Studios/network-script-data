throw_item:
  type: task
  debug: false
  script:
    - spawn snowball[item=brick] <player.location.above[300]> save:ball
    - shoot <entry[ball].spawned_entity> speed:3 origin:<player.eye_location>
    - take item:item_in_hand quantity:1
