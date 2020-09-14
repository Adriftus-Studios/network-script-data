##TEMPLATE##
##custom_zombie:
##  type: entity
##  entity_type: zombie
##  custom_name: <&c>ERROR - REPORT ME
##  custom_name_visible: true
##  scaling_values:
##    GENERIC_ATTACK_DAMAGE:
##      base: 3
##      scaling_formula: <[base].*[<[difficulty]>]>
##    GENERIC_MAX_HEALTH:
##      base: 20
##      scaling_formula: <[base].*[<[difficulty]>]>
##    GENERIC_ARMOR:
##      base: 3
##      scaling_formula: <[base].*[<[difficulty]>]>
##TEMPLATE END##

mob_spawning_system_events:
  type: data
  debug: false
  settings:
    blacklist: tropical_fish|salmon|cod|horse|donkey|cow|chicken|sheep|pig|pufferfish|llama|trader_llama|armor_stand|squid|bat
    min: 500
    max: 20000
  events:
    on entity spawns in:mainland:
      - if <script[mob_spawning_system_events].data_key[settings.blacklist].contains[<context.entity.entity_type>]>:
        - stop
      - if <context.entity.script.name||null> == null && !<server.has_flag[spawning_mob]>:
        - determine passively cancelled
      - else:
        - stop
      - foreach <list[<context.location.z.abs>|<context.location.x.abs>]>:
        - if <[value]> < <script[mob_spawning_system_events].data_key[settings.min]> || <[value]> > <script[mob_spawning_system_events].data_key[settings.max]>:
          - stop
      - define difficulty <element[11].sub[<list[<context.location.z>|<context.location.x>].highest.abs.div[2000].add[1]>].round_up>
      - if !<context.location.find.entities[<context.entity.entity_type>].within[<element[25].-[<[difficulty]>]>].is_empty>:
        - determine cancelled
      - flag server spawning_mob
      - mythicspawn <context.entity.entity_type.to_uppercase>1 <context.location> level:<[difficulty]> save:merp
      - flag server spawning_mob:!
