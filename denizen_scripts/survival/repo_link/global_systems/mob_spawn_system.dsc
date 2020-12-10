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
  type: data
  debug: false
  settings:
    blacklist: tropical_fish|salmon|cod|horse|donkey|cow|chicken|sheep|pig|pufferfish|llama|trader_llama|armor_stand|squid|bat
    whitelist: zombie|skeleton|spider|creeper|enderman|husk|vindicator|pillager|silverfish|wolf|polar_bear|panda|stray|drowned|vex|evoker|cave_spider|slime|bee
    min: 500
    max: 20000
  events:
    on zombie|skeleton|spider|creeper|enderman|husk|vindicator|pillager|silverfish|wolf|polar_bear|panda|stray|drowned|vex|evoker|cave_spider|slime|bee spawns in:mainland:
      - if <context.entity.is_mythicmob>:
        - stop
      - define x <context.location.x.abs>
      - define z <context.location.z.abs>
      - if <[x]> > 500 && <[x]> < 20000 && <[z]> > 500 && <[z]> < 20000:
        - determine passively cancelled
        - define difficulty <element[11].sub[<list[<[x]>|<[z]>].highest.abs.div[2000].add[1]>].round_up>
        - mythicspawn <context.entity.entity_type.to_uppercase>1 <context.location> level:<[difficulty]>
      - else:
        - stop
