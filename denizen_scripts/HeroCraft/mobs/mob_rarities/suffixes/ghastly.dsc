custom_mob_suffix_ghastly:
  Type: world
  debug: false
  events:
    after entity_flagged:ghastly targets entity:
      - while <context.entity.is_spawned> && <context.entity.target.exists>:
        - MythicSpawn GhastBlaster <context.entity.location>
        - wait 100t
