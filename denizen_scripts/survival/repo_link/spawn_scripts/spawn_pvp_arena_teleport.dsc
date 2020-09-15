on_player_enters_pvp_portal:
  type: world
  events:
#    on entity enters portal:
#      - announce "enters at <context.location>"
    on player uses portal:
      - narrate "<&c>Welcome to Hell!"

#end_gateway_tool:
#  type: item
#  material: stick
#  display name: <&5>End Gateway Tool

#end_gateway_replace:
#  type: world
#  events:
#    on player right clicks block with end_gateway_tool:
#      - determine passively cancelled
#      - modifyblock <context.location> end_gateway
