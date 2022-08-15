custom_mob_prefix_breaking:
  Type: world
  debug: false
  events:
    after entity_flagged:breaking damages player:
        - itemcooldown <player.item_in_hand.material> duration:5s
        - narrate "<context.entity.custom_name.if_null[<context.entity.entity_type>]> disabled your <player.item_in_hand.display.if_null[<player.item_in_hand.material.replace_text[_].with[ ].to_titlecase>]>!"