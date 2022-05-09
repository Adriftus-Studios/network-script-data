custom_mob_prefix_explosive:
  Type: world
  debug: false
  events:
    on entity_flagged:explosive dies:
      - define modifier <util.random.int[3].to[6]>
      - explode <context.entity.location> fire power:<[modifier]>
      - hurt <[modifier]> <context.entity.location.find_entities[player].within[<[modifier]>]>
