World_barriers:
  type: world
  debug: false
  events:
    on player enters outermost_barrier:
      - if !<player.has_flag[outermost_barrier_bypass]>:
        - wait 1t
        - teleport <player> <context.from>
        - actionbar "<&c>The <&4>Savage Lands<&c> are currently under development, please try again later!"
        - playsound <context.to> sound:ENTITY_VILLAGER_NO
