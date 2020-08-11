player_death_event:
  type: world
  debug: false
  events:
    on player death:
      - flag <player> player_death_location:<player.location>
      - if <player.world.name> == world:
        - narrate "<&c>You just died at <&b>X <player.location.x.round_to[0]><&c>, <&b>Y <player.location.y.round_to[0]><&c>, <&b>Z <player.location.z.round_to[0]> <&c>in the Overworld"
      - else if <player.world.name> == world_nether:
        - narrate "<&c>You just died at <&b>X <player.location.x.round_to[0]><&c>, <&b>Y <player.location.y.round_to[0]><&c>, <&b>Z <player.location.z.round_to[0]> <&c>in the Nether"
      - else if <player.world.name> == world_the_end:
        - narrate "<&c>You just died at <&b>X <player.location.x.round_to[0]><&c>, <&b>Y <player.location.y.round_to[0]><&c>, <&b>Z <player.location.z.round_to[0]> <&c>in the End"
      - else:
        - narrate "<&c>You just died at <&b>X <player.location.x.round_to[0]><&c>, <&b>Y <player.location.y.round_to[0]><&c>, <&b>Z <player.location.z.round_to[0]> <&c>in <player.world.name>"
