spawn_world_protection:
  type: world
  debug: false
  whitelist_items: cooked_beef|bread|apple|mushroom_stew|golden_apple|enchanted_golden_apple|cooked_cod|cooked_salmon|cookie|cooked_chicken
  events:
    on entity spawns in:spawn:
      - if <context.reason> == NATURAL:
        - determine cancelled
    on player places block in:spawn_cuboid:
      - if !<player.has_flag[world.spawn.modify]>:
        - determine cancelled
    on player breaks block in:spawn_cuboid:
      - if !<player.has_flag[world.spawn.modify]>:
        - determine cancelled
    on player breaks hanging in:spawn_cuboid:
      - if !<player.has_flag[world.spawn.modify]>:
        - determine cancelled
    on player clicks bukkit_priority:HIGHEST in:spawn_cuboid:
      - if !<player.has_flag[world.spawn.modify]> && !<player.has_flag[world.spawn.can_shoot]>:
        - determine cancelled

# fall protection in spawn
spawn_player_takes_fall_damage:
  type: world
  debug: false
  events:
    on player damaged by fall in:spawn:
      - determine cancelled

# Anti pvp in spawn
spawn_player_damages:
  type: world
  debug: false
  events:
    on player damaged by player in:spawn:
      - determine cancelled

# Anti Hunger
spawn_player_food_level:
  type: world
  debug: false
  events:
    on entity changes food level in:spawn:
      - determine cancelled

# Save the bees!
spawn_bee_damage_prevent:
  type: world
  debug: false
  events:
    on bee damaged by player in:spawn:
      - determine cancelled
