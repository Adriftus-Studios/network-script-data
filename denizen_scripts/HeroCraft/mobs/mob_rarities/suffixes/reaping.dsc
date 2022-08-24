custom_mob_suffix_reaping:
  Type: world
  debug: false
  events:
    on entity dies chance:50:
      - define location <context.entity.location>
      - wait 1t
      - define reaping <[location].find_entities[*].within[10].filter_tag[<[filter_value].has_flag[reaping]>]>
      - if <[reaping].is_empty.not>:
        - foreach <[reaping]> as:entity:
          - health <[entity]> <[entity].health_max.add[<util.random.int[1].to[6]>]> heal
          - playeffect at:<[entity].eye_location> effect:villager_happy quantiy:3 offset:0.1