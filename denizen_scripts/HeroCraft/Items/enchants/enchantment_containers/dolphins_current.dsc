Dolphins_Current_enchantment:
  type: enchantment
  id: dolphins_current
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Gives the user Dolphins Grace while holding
    item_slots:
      - trident
  category: breakable
  full_name: <&7>Dolphins Current <context.level.to_roman_numerals>
  min_level: 1
  max_level: 1
  is_tradable: false
  can_enchant: <context.item.advanced_matches[trident]>


Dolphins_Current_enchantment_events:
  type: world
  debug: false
  scripts:
    give:
    - cast DOLPHINS_GRACE amplifier:1 duration:999d hide_particles no_ambient
    - flag <player> dolphins_grace
    take:
    - cast DOLPHINS_GRACE amplifier:1 duration:0t
    - flag <player> dolphins_grace:!
  events:
    on player scrolls their hotbar item:item_enchanted:dolphins_current:
    - inject locally path:scripts.give
    on player scrolls their hotbar item:!item_enchanted:dolphins_current flagged:dolphins_grace:
    - inject locally path:scripts.take
    on player number_key clicks item_enchanted:dolphins_current in inventory:
    - if <context.hotbar_button> == <player.held_item_slot>:
      - inject locally path:scripts.give
    on player number_key clicks in inventory flagged:dolphins_grace:
    - if <player.inventory.slot[<context.hotbar_button>].enchantments.contains[dolphins_current]>:
      - inject locally path:scripts.take
    on player clicks in inventory with:item_enchanted:dolphins_current:
    - if <context.slot> == <player.held_item_slot>:
      - inject locally path:scripts.give
    on player clicks item_enchanted:dolphins_current in inventory flagged:dolphins_grace:
    - if <context.slot> == <player.held_item_slot>:
      - inject locally path:scripts.take
    on trident launched:
    - if <context.entity.shooter.has_flag[dolphins_grace]> && <context.entity.item.enchantments.contains[dolphins_current]>:
      - adjust <queue> linked_player:<context.entity.shooter>
      - inject locally path:scripts.take
    on player drops item_enchanted:dolphins_current flagged:dolphins_grace:
    - inject locally path:scripts.take
    on player picks up item_enchanted:dolphins_current:
    - wait 1t
    - if <player.item_in_hand> == <context.item>:
      - inject locally path:scripts.give
    on player swaps items main:item_enchanted:dolphins_current:
    - if <context.main.enchantments.contains[dolphins_current]>:
      - inject locally path:scripts.give
    - else if <context.offhand.enchantments.contains[dolphins_current]>:
      - inject locally path:scripts.take
    on player swaps items offhand:item_enchanted:dolphins_current:
    - if <context.offhand.enchantments.contains[dolphins_current]> && !<context.main.enchantments.contains[dolphins_current]>:
      - inject locally path:scripts.take