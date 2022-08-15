custom_mob_suffix_reaping:
  Type: world
  debug: false
  events:
    after entity dies chance:50:
        - define reaping <context.location.find_entities[*].within[10].filter_tag[<[filter_value].has_flag[reaping]>]>
        - if <[reaping].is_empty.not>:
            - foreach <[reaping]> as:<[e]>:
                - heal <util.random.int[1].to[5]> <[e]>