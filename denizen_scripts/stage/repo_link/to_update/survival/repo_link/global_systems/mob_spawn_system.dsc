##TEMPLATE##
##custom_zombie:
##  type: entity
##  entity_type: zombie
##  custom_name: <&c>ERROR - REPORT ME
##  custom_name_visible: true
##  scaling_values:
##    GENERIC_ATTACK_DAMAGE:
##      base: 3
##      scaling_formula: <[base].mul[<[difficulty]>]>
##    GENERIC_MAX_HEALTH:
##      base: 20
##      scaling_formula: <[base].mul[<[difficulty]>]>
##    GENERIC_ARMOR:
##      base: 3
##      scaling_formula: <[base].mul[<[difficulty]>]>
##TEMPLATE END##

mob_spawning_system_events:
  type: world
  debug: false
  events:
    on zombie|skeleton|spider|creeper|enderman|husk|vindicator|pillager|silverfish|wolf|polar_bear|panda|stray|drowned|vex|evoker|cave_spider|slime|bee spawns because natural in:mainland|spawn :
      - determine passively cancelled
      - mythicspawn <context.entity.entity_type.to_uppercase>1 <context.location>
    on zombie|skeleton|spider|creeper|enderman|husk|vindicator|pillager|silverfish|wolf|polar_bear|panda|stray|drowned|vex|evoker|cave_spider|slime|bee spawns because spawner in:mainland|spawn:
    - if !<context.spawner_location.has_flag[spawner]>:
      - determine passively cancelled
      - mythicspawn <context.entity.entity_type.to_uppercase>1 <context.location>
