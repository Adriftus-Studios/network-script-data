custom_object_town_defence:
  type: data
  item: town_defence_item
  entity: town_defence
  interaction: town_defence_use
  place_checks_task: town_defence_checks
  after_place_task: town_defence_after_place
  remove_task: town_defence_remove
  barrier_locations:
    - <[location]>

town_defence:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    custom_name: <&c>Magical Turret
    custom_name_visible: true
    marker: false
    visible: false
    gravity: false
    equipment: air|air|air|feather[custom_model_data=1000]
  flags:
    on_entity_added: custom_object_update
    no_morb: true

town_defence_item:
  type: item
  debug: false
  material: feather
  display name: <&c>Town Defence
  lore:
  - <&e><&l>Stationary Turret
  - <&c>Attacks Outlaws on Sight
  flags:
    right_click_script: custom_object_place
    custom_object: town_defence
  mechanisms:
    custom_model_data: 1000
  data:
    recipe_book_category: gadgets.turret1
  recipes:
    1:
      type: shaped
      input:
        - compressed_amythest_block|compressed_obisdian|compressed_amythest_block
        -  air|compressed_emerald_block|air
        - compressed_amythest_block|compressed_obsidan|compressed_amythest_block

town_defence_watch:
  type: world
  debug: false
  events:
    on towny player enters town:
      - if <context.town.outlaws.contains[<player>]>:
        - run town_defence_add_target def:<context.town>|<player>
    on towny player exits town:
      - if <context.town.has_flag[active_outlaws]> && <context.town.flag[active_outlaws].contains[<player>]>:
        - flag <context.town> active_outlaws:<-:<player>
        - if <context.town.flag[active_outlaws].is_empty>:
          - flag <context.town> active_outlaws:!
    after server start:
      - foreach <towny.list_towns>:
        - flag <[value]> active_outlaws:!

town_defence_add_target:
  type: task
  debug: false
  definitions: town|target
  script:
    - stop if:<[town].has_flag[active_defences].not>
    - flag <[town]> active_outlaws:->:<[target]>
    - if <[town].flag[active_outlaws].size> == 1:
      - run town_defence_loop def:<[town]>

town_defence_checks:
  type: task
  debug: false
  definitions: entity
  script:
    - if !<[location].town.exists> || <[location].town> != <player.town> || !<player.has_permission[towny.command.plot.asmayor]>:
      - narrate "<&c>You do not have permission to place this here."
      - stop

town_defence_after_place:
  type: task
  debug: false
  definitions: entity
  script:
    - flag <[location].town> active_defences:->:<[entity]>
    - flag <[location].above> on_pistoned:->:cancel
    - flag <[entity]> on_right_click:->:cancel
    - flag <[entity]> on_damaged:->:cancel

town_defence_remove:
  type: task
  debug: false
  definitions: entity
  script:
    - flag <[entity].location.town> active_defences:<-:<[entity]>
    - flag <[entity].location.above> on_pistoned:<-:cancel
    - if <[entity].location.above.flag[on_pistoned].is_empty>:
      - flag <[entity].location.above> on_pistoned:!
    - if <[entity].location.town.flag[active_defences].is_empty>:
      - flag <[entity].location.town> active_defences:!
    - run custom_object_remove def:<[entity]>


town_defence_loop:
  type: task
  debug: false
  definitions: town
  script:
    - while <[town].has_flag[active_outlaws]> && <[town].has_flag[active_defences]>:
      - foreach <[town].flag[active_outlaws]> as:outlaw:
        - if !<[outlaw].is_online>:
          - flag <[town]> active_outlaws:<-:<[outlaw]>
          - if <[town].flag[active_outlaws].is_empty>:
            - flag <[town]> active_outlaws:!
            - stop
          - foreach next
        - foreach <[town].flag[active_defences].filter[is_spawned].filter[can_see[<[outlaw]>]]> as:defence:
          - run town_defence_attack def:<[defence]>|<[outlaw]>
          - wait 2t
        - wait 1t
      - wait 1t
    - wait 1t
    - run town_defence_loop def:<[town]> if:<[town].has_flag[active_outlaws]>

town_defence_attack:
  type: task
  debug: false
  definitions: entity|target
  script:
    - playeffect at:<[entity].eye_location.points_between[<[target].location.above>].distance[0.5]> effect:dragon_breath quantity:5 offset:0.1 targets:<[target].location.find_players_within[120]>
    - flag <[target]> custom_damage.cause:<[entity].custom_name>
    - hurt <[target]> <[entity].location.town.flag[active_defences].size.mul[0.25].max[1].min[11]> cause:CUSTOM

town_defence_use:
  type: task
  debug: false
  script:
    - if <player.is_sneaking> && <player.has_permission[towny.command.plot.asmayor]>:
      - run town_defence_remove def:<context.location.flag[custom_object]>