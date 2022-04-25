actor_weapon_blood_bandit:
  type: item
  material: netherite_sword
  display name: <&c>The UGA
  lore:
  - "<&e>Sword of the Blood Bandit"
  mechanisms:
    custom_model_data: 2
  flags:
    right_click_script: actor_weapon_blood_bandit_use
    on_item_drop: cancel

actor_weapon_blood_bandit_use:
  type: task
  debug: false
  script:
    - if <player.uuid> != 339917a6-0fe7-4636-9087-eca0c549c7d2:
      - narrate "<&c>You are too inept to wield these magics"
      - stop
    - define target <player.cursor_on[20].above.if_null[null]>
    - if <[target]> != null:
      - define points <player.location.above.right[0.5].points_between[<[target]>].distance[0.5]>
      - foreach <[points]>:
        - playeffect effect:redstone special_data:5|red at:<[value]> offset:0 quantity:1 targets:<server.online_players>
        - wait 1t
      - repeat 5:
        - playeffect effect:redstone special_data:5|red at:<[target].above> offset:0.5 quantity:1 targets:<server.online_players>
        - wait 1t
      - spawn test_spawn_blood_radier2 <[target]>