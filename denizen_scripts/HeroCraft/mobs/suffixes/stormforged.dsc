custom_mob_suffix_stormforged:
  Type: world
  debug: false
  events:
    on entity_flagged:Stormforged damages entity:
      - define strike_area <context.entity.location.find.surface_blocks.within[2]>
      - foreach <[strike_area]>:
        - if <util.random.int[1].to[5]> == 5:
          - strike <[value]>
          - wait <util.random.int[3].to[5]>t

Stormforged_immunity_task:
  Type: world
  debug: false
  events:
    on entity_flagged:Stormforged damaged:
      - if <context.cause> == LIGHTNING:
        - determine passively cancelled
        - wait 1t
        - burn <context.entity> duration:0
