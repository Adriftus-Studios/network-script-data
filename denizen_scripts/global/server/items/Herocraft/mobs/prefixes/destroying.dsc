custom_mob_prefix_destroying:
  type: world
  debug: false
  events:
    on entity_flagged:destroying dies:
      - run destroying_prefix_explosion_task def.location:<context.entity.location>

destroying_prefix_explosion_task:
  type: task
  definitions: location
  script:
    - foreach <[location].find_entities.within[5]>:
      - define modifier <util.random.int[3].to[6]>
      - explode <context.entity.location> fire power:<[modifier]> breakblocks
