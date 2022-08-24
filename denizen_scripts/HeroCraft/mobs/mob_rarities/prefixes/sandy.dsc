custom_mob_prefix_sandy:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:sandy:
        - ratelimit <context.damager> 1s
        - cast BLINDNESS <context.entity> amplifier:5 duration:10s
        - title "title:<yellow><bold>POCKET SAND!" targets:<context.entity> if:<context.entity.is_player>
        - playeffect effect:block_crack at:<context.entity.eye_location> special_data:sand quantity:200 offset:1,1,1
    on entity_flagged:sandy dies:
        - determine passively <context.drops.include[<element[sand].repeat_as_list[<util.random.int[1].to[20]>]>]>