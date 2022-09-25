fishing_boat_wooden:
  type: item
  material: dark_oak_boat
  display name: <&F>Wooden Fishing Boat
  lore:
  - <&6>A cramped dinghy.
  - <&sp>
  - <&e>Increases fish catch rate by 6<&pc>.
  - <&6>Jade Level<&co> <&e>10
  flags:
    trips: 10


fishing_boat_blocker:
  type: world
  debug: false
  events:
    on player right clicks block with:fishing_boat_*:
      - determine passively cancelled
