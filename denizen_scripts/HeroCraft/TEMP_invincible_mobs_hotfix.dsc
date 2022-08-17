temporary_invincible_mob_hotfix:
  type: world
  debug: false
  events:
    on player damages entity:
      - if <context.entity.health> < 0.1:
        - wait 1t
        - kill <context.entity>