custom_mob_suffix_splitting:
  Type: world
  debug: false
  events:
    after entity_flagged:splitting dies:
      - spawn <context.entity.with_flag[splitting:!].repeat_as_list[2]> <context.entity.location>
