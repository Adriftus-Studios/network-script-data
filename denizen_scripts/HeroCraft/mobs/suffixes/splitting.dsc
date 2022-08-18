custom_mob_suffix_splitting:
  Type: world
  debug: false
  events:
    on entity_flagged:splitting dies:
      - define entity <context.entity.with[custom_name=<context.entity.custom_name.replace[Splitting].with[Split]>].with_flag[splitting:!]>
      - define location <context.location>
      - wait 5t
      - repeat 2:
        - spawn <[entity]> <[location].left[<[value]>]> target:<context.damager.if_null[<[location].find_entities.within[50].get[1]>]>
      - playsound sound:entity_arrow_shoot pitch:0.5 volume:2.0 <[location]>
      - playeffect effect:flame at:<[location]> offset:0.5,0.5,0.5 quantity:100
