## SHEEP SHEARER
# When a player shears a sheep that is already sheared, it nicks the sheep, and causes
#  damage to it. Since animals don't spawn naturally, this is a good form of crowd
#  control. And will make people think twice about what their doing.

sheep_sheared_listener:
  type: world
  events:
    on player right clicks sheep with:shears:
    - if <context.entity.is_sheared>:
      - hurt 1 <context.entity> source:<player>
