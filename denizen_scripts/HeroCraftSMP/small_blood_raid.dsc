small_blood_raid:
  type: task
  debug: false
  definitions: town
  script:
    - define players <server.online_players.filter[location.town.equals[<[town]>]]>
    - if <[players].is_empty>:
      - stop
    - narrate "<&c>A Blood Raid has started in <&b><[town].name><&c>..." targets:<server.online_players>
    - flag <[town]> blood_raid expire:5m
    - foreach <[players]> as:target:
      - wait 1s
      - define location <[target].location.chunk.surface_blocks.random.above[3]>
      - wait 1s
      - repeat 30:
        - playeffect at:<[location]> effect:redstone special_data:10|#660000 offset:0.75 quantity:10 targets:<server.online_players>
        - wait 2t
      - spawn small_blood_raid_raider2 <[location]> target:<[target]>
      - spawn small_blood_raid_raider2 <[location]> target:<[target]>

small_blood_raid_event:
  type: world
  debug: false
  events:
    on player enters bed bukkit_priority:LOWEST:
      - if <context.location.has_town> && <context.location.town.has_flag[blood_raids_enabled]>:
        - if !<context.location.town.has_flag[blood_raid]> && <util.random_chance[10]>:
          - determine passively cancelled
          - narrate "<&c>Sleep escapes you..."
          - run small_blood_raid def:<context.location.town>
        - else if <context.location.town.has_flag[blood_raid]>:
          - determine passively cancelled
          - narrate "<&c>Sleep escapes you..."



small_blood_raid_raider2:
  type: entity
  debug: false
  entity_type: skeleton
  mechanisms:
    health_data: 20/20
    custom_name: <&c>Blood Skeleton
    custom_name_visible: true
    equipment: air|air|air|air
  flags:
    on_death: test_spawn_blood_raider_remove