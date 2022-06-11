hat_command:
  type: command
  name: hat
  debug: false
  description: Places a held item as a hat
  usage: /hat
  permission: behr.essentials.hat
  script:
  # % ██ [ check if tryping arguments               ] ██
    - if !<context.args.is_empty>:
      - narrate "<&c>Invalid usage - /hat"

  # % ██ [ check if not holding a hat               ] ██
    - if <player.item_in_hand.material.name> == air:
      - narrate "<&c>No item in hand."
      - stop

  # % ██ [ check if player is wearing a hat already ] ██
    - if <player.equipment_map.contains[helmet]>:
      - narrate "<&c>You must remove your current hat first."
      - stop

  # % ██ [ receive hat                              ] ██
    - equip <player> head:<player.item_in_hand.with[quantity=1]>
    - take iteminhand quantity:1
