
item_in_chat_events:
    type: world
    debug: false
    config:
        defaults:
            itemchat:
                permission: itemchat.use
    events:
        on player chats:
            - if <player.has_permission[<yaml[config].read[itemchat.permission]>]>:
                - if <context.full_text.to_lowercase.index_of[<&lb>item<&rb>]> != <context.full_text.to_lowercase.last_index_of[<&lb>item<&rb>]>:
                    - narrate "<&c>You cannot display the same item multiple times."
                    - determine cancelled
                - if <context.full_text.to_lowercase.contains[<&lb>item<&rb>]>:
                    - determine passively cancelled
                    - define item <player.item_in_hand>
                    - define message <context.full_text>
                    - if <player.item_in_hand.quantity.is_more_than[1]>:
                        - narrate <context.full_text.replace[<&lb>item<&rb>].with[<element[<&lb><player.item_in_hand.display||<player.item_in_hand.material.name.to_titlecase.replace_text[_].with[<&sp>]>><&r><&sp><player.item_in_hand.quantity>x<&r><&rb>].on_hover[<player.item_in_hand>].type[show_item]>]> targets:<context.recipients>
                    - else:
                        - narrate <context.full_text.replace[<&lb>item<&rb>].with[<element[<&lb><player.item_in_hand.display||<player.item_in_hand.material.name.to_titlecase.replace_text[_].with[<&sp>]>><&r><&rb>].on_hover[<player.item_in_hand>].type[show_item]>]> targets:<context.recipients>
