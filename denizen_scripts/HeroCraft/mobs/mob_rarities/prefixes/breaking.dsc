custom_mob_prefix_breaking:
  Type: world
  debug: false
  events:
    after entity_flagged:breaking damages player:
        - stop if:<player.item_in_hand.material.name.equals[air]>
        - stop if:<server.has_flag[disable_prefix_breaking]>
        - itemcooldown <player.item_in_hand.material> duration:5s
        - flag <player> breaking_applied:<player.item_in_hand.material> expire:5s
        - narrate "<context.damager.custom_name.if_null[<context.entity.entity_type.replace[_].with[ ].to_titlecase>]><&r> disabled your <player.item_in_hand.display.if_null[<player.item_in_hand.material.name.replace_text[_].with[ ].to_titlecase>]>!"
    on player left clicks block flagged:breaking_applied:
        - if <player.flag[breaking_applied]> == <context.item.material>:
          - determine cancelled
    on player right clicks block flagged:breaking_applied:
        - if <player.flag[breaking_applied]> == <context.item.material>:
          - determine cancelled
