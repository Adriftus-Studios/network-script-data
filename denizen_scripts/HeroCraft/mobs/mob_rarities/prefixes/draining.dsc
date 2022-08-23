custom_mob_prefix_draining:
  type: world
  debug: false
  events:
    on entity damaged by entity_flagged:draining:
        - cast SPEED <context.entity> remove
        - cast STRENGTH <context.entity> remove
        - cast ABSORPTION <context.entity> remove
        - cast FIRE_RESISTANCE <context.entity> remove
        - cast WATER_BREATHING <context.entity> remove
        - cast INVISIBILITY <context.entity> remove
        - cast INCREASE_DAMAGE <context.entity> remove
        - cast HEALTH_BOOST <context.entity> remove
        - cast NIGHT_VISION <context.entity> remove
        - cast REGENERATION <context.entity> remove
        - cast SATURATION <context.entity> remove
        - cast FAST_DIGGING <context.entity> remove
        - cast HERO_OF_THE_VILLAGE <context.entity> remove
        - cast LUCK <context.entity> remove