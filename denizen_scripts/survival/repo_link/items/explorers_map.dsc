explorers_map:
  type: item
  debug: false
  display name: <&a>Explorer's Map
  material: filled_map

explorers_map_give:
  type: task
  debug: false
  script:
    - map new:<player.world> reset:<player.location> scale:CLOSEST tracking:true save:map
    - give <item[explorers_map].with[map=<entry[map].created_map>]>

explorer_map_update:
  type: task
  debug: false
  definitions: hand
  script:
    - wait 1t
    - if <[hand]> == main:
      - while <player.item_in_hand.script.name||null> == explorers_map:
        - map <player.item_in_hand.map> reset:<player.location>
        - wait 5t
    - else:
      - while <player.item_in_offhand.script.name||null> == explorers_map:
        - map <player.item_in_offhand.map> reset:<player.location>
        - wait 5t

explorers_map_events:
  type: world
  debug: false
  events:
    on player holds items item:explorers_map:
      - run explorer_map_update def:main
    after player swaps items main:explorers_map:
      - run explorer_map_update def:main
    after player swaps items offhand:explorers_map:
      - run explorer_map_update def:offhand
