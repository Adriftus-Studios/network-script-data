grass_break_listener:
  type: world
  events:
    on player breaks grass bukkit_priority:HIGH:
    #- if <context.location.material.name> == air:
    - if <util.random.int[1].to[100]> <= 10:
      - drop custom_food_onion <context.location>
    on player right clicks farmland with:custom_food_onion:
    - narrate "<&c>You cannot replant onions"
    - determine cancelled
