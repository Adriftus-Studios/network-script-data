custom_mob_prefix_sandy:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:sandy:
        - cast BLINDNESS <context.entity> amplifier:5 duration:10s
        - narrate "<yellow><bold>POCKET SAND!" targets:<context.entity> if:<context.entity.is_player>
        - playeffect effect:block_crack at:<context.entity.eye_location.forward[1]> velocity:<context.entity.location.direction.vector> special_data:sand
    on entity_flagged:sandy dies:
        - determine passively <context.drops.include_single[sand]>