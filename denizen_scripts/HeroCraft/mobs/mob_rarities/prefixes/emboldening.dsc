custom_mob_prefix_emboldening:
  Type: world
  debug: false
  events:
    on entity_flagged:Emboldening dies:
      - cast INCREASE_DAMAGE <context.entity.location.find_entities[entity_flagged:Emboldable].within[8]>
