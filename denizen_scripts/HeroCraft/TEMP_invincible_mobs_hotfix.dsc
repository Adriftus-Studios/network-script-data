temporary_invincible_mob_hotfix:
  type: world
  debug: false
  events:
    on !player damaged:
      - if <context.entity.health> < 0.5 && <context.entity.exists>:
        - wait 1t
        - kill <context.entity>
        - wait 5t
        - remove <context.entity> if:<context.entity.is_spawned>