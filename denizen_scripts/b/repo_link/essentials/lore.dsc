lore_command:
  type: command
  name: lore
  debug: false
  description: Applies basic lore to the item in hand
  usage: /lore <&lt>Lore line 1<&gt>|(Lore line <&ns>)*
  permission: behr.essentials.lore
  script:
  # % ██ [ check if not typing anything ] ██
    - if <context.args.is_empty>:
      - narrate "<&c>Invalid usage - type lore to add to an item"
      - stop

  # % ██ [ check if holding an item     ] ██
    - if <player.item_in_hand.material.name> == air:
      - narrate "<&c>Invalid usage - hold an item to add lore to"
      - stop

  # % ██ [ format lore to add           ] ██
    - define lore <context.raw_args.split[|].parse[trim.parse_color]>

  # % ██ [ sets lore to item            ] ██
    - inventory adjust slot:<player.held_item_slot> lore:<list>
    - inventory adjust slot:<player.held_item_slot> lore:<[lore]>
    - playsound <player> entity_ender_eye_death
