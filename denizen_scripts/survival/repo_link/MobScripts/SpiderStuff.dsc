Paranoia_poison_canceller:
  type: world
  debug: false
  events:
    on player damaged by cave_spider:
      - if !<context.damager.is_mythicmob>:
        - stop
    # % Using determine cancelled then hurt to prevent poison on the player from hallucination spiders.
      - if <context.damage.entity.mythicmob.stance> == HALLUCINATED:
        - determine passively cancelled
        - ratelimit <player> 1t
        - hurt <context.damager.mythicmob.level.sub[6]> <player> source:<context.entity>
