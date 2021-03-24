boat_breaker:
  type: world
  debug: false
  events:
    on player exits boat:
    - wait 1s
    - if <context.vehicle.has_passenger>:
      - stop
    - else:
      - choose <context.vehicle.boat_type>:
        - case DARK_OAK:
          - define type <context.vehicle.boat_type>
        - case GENERIC:
          - define type oak
        - case ACACIA:
          - define type <context.vehicle.boat_type>
        - case JUNGLE:
          - define type <context.vehicle.boat_type>
        - case BIRCH:
          - define type <context.vehicle.boat_type>
        - case REDWOOD:
          - define type spruce
      - remove <context.vehicle>
      - give <[type]>_boat

    on armor_stand exits boat:
      - if <context.vehicle.has_flag[chest]>:
        - if <inventory[<context.vehicle.flag[chest]>_inventory]||null> != null:
          - foreach <inventory[<context.vehicle.flag[chest]>_inventory].list_contents> as:item:
            - drop <[item]> <context.vehicle.location>
          - note remove as:<context.vehicle.flag[chest]>_inventory
          - drop chest <context.vehicle.location>
        - remove <context.vehicle.flag[chest]>

    on boat destroyed:
      - if <context.vehicle.has_flag[chest]>:
        - if <inventory[<context.vehicle.flag[chest]>_inventory]||null> != null:
          - foreach <inventory[<context.vehicle.flag[chest]>_inventory].list_contents> as:item:
            - drop <[item]> <context.vehicle.location>
          - note remove as:<context.vehicle.flag[chest]>_inventory
          - drop chest <context.vehicle.location>
        - remove <context.vehicle.flag[chest]>
