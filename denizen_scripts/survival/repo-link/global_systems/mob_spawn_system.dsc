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
    blacklist: tropical_fish|salmon|cod|horse|donkey|cow|chicken|sheep|pig|pufferfish|llama|trader_llama|armor_stand|squid
    min: 1000
    max: 20000
  events:
    on entity spawns in:mainland:
      - if <script[mob_spawning_system_events].data_key[settings.blacklist].contains[<context.entity.entity_type>]>:
        - stop
      - if <context.entity.script.name||null> == null && !<context.entity.is_mythicmob>:
        - determine passively cancelled
      - else:
        - stop
      - foreach <list[<context.location.z.abs>|<context.location.x.abs>]>:
        - if <[value]> < <script[mob_spawning_system_events].data_key[settings.min]> || <[value]> > <script[mob_spawning_system_events].data_key[settings.max]>:
          - stop
      - define difficulty <element[11].sub[<list[<context.location.z>|<context.location.x>].highest.abs.div[2000].add[1]>].round_up>
      - if !<context.location.find.entities[<context.entity.entity_type>].within[25].is_empty||false>:
        - stop
      - define mob_type <context.entity.entity_type>
      - spawn custom_<context.entity.entity_type> <context.location> save:mob
      - if <entry[mob].spawned_entity||null> == null:
        - stop
      - adjust <entry[mob].spawned_entity> "custom_name:<[mob_type].to_titlecase> <&e>Level <[difficulty]>"
      - foreach <script[custom_<[mob_type]>].list_keys[custom.scaling_values]||<list>>:
        - define base <script[custom_<[mob_type]>].data_key[custom.scaling_values.<[value]>.base]||<context.entity.attribute_value[<[value]>]>>
        - narrate <[base]>
        - define attributes_built:|:<[value]>/<script[custom_<[mob_type]>].parsed_key[custom.scaling_values.<[value]>.scaling_formula]>
      - if <[attributes_built]||null> != null:
        - adjust <entry[mob].spawned_entity> attributes:<[attributes_built]>
