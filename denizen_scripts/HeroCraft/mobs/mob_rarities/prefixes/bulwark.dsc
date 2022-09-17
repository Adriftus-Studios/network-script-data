custom_mob_prefix_bulwark:
  Type: world
  debug: false
  events:
    on entity_flagged:bulwark damaged:
    - determine <context.final_damage.div[2]>
