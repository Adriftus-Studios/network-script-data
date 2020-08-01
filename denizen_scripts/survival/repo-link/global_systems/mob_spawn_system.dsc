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
  type: world
  debug: false
  settings:
    blacklist: tropical_fish|salmon|cod|horse|donkey|cow|chicken|sheep|pig|pufferfish|llama|trader_llama|armor_stand|squid
    min: 1000
    max: 20000
  events:
    on entity spawns in:mainland:
      - if <script[mob_spawning_system_events].yaml_key[settings.blacklist].contains[<context.entity.entity_type>]>:
        - stop
      - if <context.entity.script.name||null> == null:
        - determine passively cancelled
      - else:
        - stop
      - foreach <list[<context.location.z.abs>|<context.location.x.abs>]>:
        - if <[value]> < <script[mob_spawning_system_events].yaml_key[settings.min]> || <[value]> > <script[mob_spawning_system_events].yaml_key[settings.max]>:
          - stop
      - define difficulty <element[11].-[<list[<context.location.z>|<context.location.x>].highest.abs./[2000].+[1]>].round_up>
      - if !<context.location.find.entities[<context.entity.entity_type>].within[25].is_empty||false>:
        - stop
      - define mob_type <context.entity.entity_type>
      - spawn custom_<context.entity.entity_type> <context.location> save:mob
      - if <entry[mob].spawned_entity||null> == null:
        - stop
      - adjust <entry[mob].spawned_entity> "custom_name:<[mob_type].to_titlecase> <&e>Level <[difficulty]>"
      - foreach <script[custom_<[mob_type]>].list_keys[custom.scaling_values]||<list[]>>:
        - define base <script[custom_<[mob_type]>].yaml_key[custom.scaling_values.<[value]>.base]||<context.entity.attribute_value[<[value]>]>>
        - narrate <[base]>
        - define attributes_built:|:<[value]>/<script[custom_<[mob_type]>].yaml_key[custom.scaling_values.<[value]>.scaling_formula].parsed>
      - if <[attributes_built]||null> != null:
        - adjust <entry[mob].spawned_entity> attributes:<[attributes_built]>
