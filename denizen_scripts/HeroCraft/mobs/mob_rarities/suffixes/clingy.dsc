custom_mob_suffix_clingy:
  Type: world
  debug: false
  events:
    on entity_flagged:clingy damages entity:
    - if <util.random.int[1].to[10]> > 5:
        - mount <context.damager>|<context.entity>
        - wait 20t
        - mount cancel <context.damager>
