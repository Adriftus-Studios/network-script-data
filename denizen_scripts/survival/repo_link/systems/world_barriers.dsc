World_barriers:
  type: world
  debug: false
  events:
    on player enters outermost_barrier:
      - teleport <player.location.sub[<context.area.center>].normalize.mul[10].find.surface_blocks.within[3].first>
      - actionbar "<&c>The <&4>Savage Lands<&c> are currently under development, please try again later!"
      - playsound <context.location> sound:ENTITY_VILLAGER_NO
