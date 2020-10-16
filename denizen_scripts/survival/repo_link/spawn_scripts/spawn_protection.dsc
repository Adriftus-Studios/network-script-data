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
    on player clicks block bukkit_priority:HIGHEST in:spawn_cuboid:
      - if !<player.has_flag[world.spawn.modify]> && !<player.has_flag[world.spawn.can_shoot]>:
        - determine cancelled


# Anti Damaged Events
spawn_player_takes_damage:
  type: world
  debug: false
  events:
# Anti Damaged Player
    on player damaged in:spawn:
      - determine cancelled

# Anti Hunger
    on player changes food level in:spawn:
      - determine 20

# Anti Drown
    on player changes air level in:spawn:
      - determine cancelled

# Save the bees!
    on bee damaged by player in:spawn:
      - determine cancelled
