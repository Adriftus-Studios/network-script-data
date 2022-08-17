custom_mob_suffix_reaping:
  Type: world
  debug: false
  events:
    after entity dies chance:50:
        - define reaping <context.location.find_entities[*].within[10].filter_tag[<[filter_value].has_flag[reaping]>]>
        - if <[reaping].is_empty.not>:
            - foreach <[reaping]> as:<[e]>:
                - health <[reaping]> <[reaping].health_max.add[<util.random.int[1].to[6]>]> heal