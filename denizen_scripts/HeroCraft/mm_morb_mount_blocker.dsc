Mm_no_morb:
  Type: world
  Debug: false
  Events:
    After mythicmob mob spawns:
    - wait 1t
    - flag <context.entity> no_morb
    - flag <context.entity> on_mount:cancel

