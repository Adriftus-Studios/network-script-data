# -- Hub Protection Scripts
hub_world_protection:
  type: world
  debug: false
  events:
    # - Cancel natural entity spawning.
    on entity spawns:
      - if <context.reason> == NATURAL:
        - determine cancelled
    # - Cancel the placement of blocks.
    on player places block:
      - if !<player.has_flag[world.hub.modify]>:
        - determine cancelled
    # - Cancel the breakage of blocks.
    on player breaks block:
      - if !<player.has_flag[world.hub.modify]>:
        - determine cancelled
    # - Cancel creative mode block breakage.
    on player clicks block bukkit_priority:HIGHEST:
      - if !<player.has_flag[world.hub.modify]> && !<player.has_flag[world.hub.can_shoot]>:
        - determine cancelled


# -- Anti-Damage Events
hub_player_takes_damage:
  type: world
  debug: false
  events:
    # - Anti-Player Damage ~(>_<~)
    on player damaged:
      - determine cancelled

    # - Anti-Hunger (￣︿￣)
    on player changes food level:
      - determine 20

    # - Anti-Drowning 〜(＞＜)〜
    on player changes air level:
      - determine cancelled

    # - Save the bees! ヽ(￣ω￣(。。 )ゝ
    on bee damaged by player:
      - determine cancelled
