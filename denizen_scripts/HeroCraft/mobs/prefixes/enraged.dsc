custom_mob_prefix_enraged:
  Type: world
  debug: false
  events:
    on entity damaged by entity_flagged:Enraged:
      - if <context.final_damage> > 1:
        - determine passively <context.final_damage.mul[<list[1|2|1.25|1.5|1.75].random>]>
      - else:
        - determine passively <context.final_damage.add[1].mul[<list[1|2|1.25|1.5|1.75].random>]>
