
easy_shulker_transfer:
  type: world
  debug: false
  events:
    on player right clicks block:
    - stop if:<player.item_in_hand.material.name.ends_with[shulker_box].not>
    - stop if:<context.location.material.name.ends_with[chest].not>
    - determine passively cancelled
    - define items <player.item_in_hand.inventory.list_contents>
    - define inventory <context.location.inventory>
    - if <[inventory].can_fit[<[items]>]>:
      - inventory adjust d:<player.inventory> slot:<player.held_item_slot> inventory_contents:<list[]>
      - inventory swap d:<context.location.inventory> o:<context.location.inventory.include[<[items]>]>