#Used to make Mythicmobs break shields faster. Shoutout to Pjochillin for making this for me.

shield_degradation:
  type: world
  debug: false
  events:
    on player damaged by entity:
      - if <player.is_blocking> && <context.damager.is_mythicmob>:
        - if <player.item_in_hand.material.name> == shield:
          - define slot <player.held_item_slot>
          - define shield <player.item_in_hand>
        - else:
          - define slot 41
          - define shield <player.item_in_offhand>
        - if <[shield].durability.add[<context.damager.mythicmob.level>]> >= <[shield].max_durability>:
          - playeffect effect:ITEM_CRACK at:<player.location.above[0.5].forward[0.4]> special_data:shield offset:0.2 quantity:15
          - take slot:<[slot]>
        - else:
          - inventory adjust slot:<[slot]> durability:<[shield].durability.add[<context.damager.mythicmob.level>]> 
