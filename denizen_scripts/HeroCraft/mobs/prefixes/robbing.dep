custom_mob_prefix_robbing:
  Type: world
  debug: false
  events:
    on player damaged by entity_flagged:robbing:
        - stop if:<util.random_chance[90]>
        - define item <player.item_in_hand>
        - inventory set air slot:hand d:<player.inventory>
        - narrate "<context.damager.custom_name.if_null[<context.entity.entity_type.replace[_].with[ ].to_titlecase>]> stole your <[item].display.if_null[<[item].material.name.replace[_].with[ ].to_titlecase>]>"
        - drop item:<[item]> at:<context.damager>