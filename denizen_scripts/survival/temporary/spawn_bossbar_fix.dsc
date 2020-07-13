title_fix_command:
  type: world
  events:
    on play command:
      - if <context.args.get[1]||null> != null && <player.location.world.name> == spawn:
        - bossbar spawn_bossbar remove