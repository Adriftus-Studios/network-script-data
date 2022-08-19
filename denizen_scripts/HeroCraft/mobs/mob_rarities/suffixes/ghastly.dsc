custom_mob_suffix_ghastly:
  Type: world
  debug: false
  events:
    after entity_flagged:ghastly targets entity:
      - while <context.entity.is_spawned> && <context.entity.target.exists> && <context.entity.target||null> == <context.target>:
        - spawn ghastly_fireball <context.entity.location> save:fireball
        - shoot <entry[fireball].spawned_entity> destination:<context.target.eye_location> speed:1.5 shooter:<context.entity>
        - wait 100t
    on ghastly_fireball explodes:
      - determine <list[]>

ghastly_fireball:
  type: entity
  entity_type: fireball
