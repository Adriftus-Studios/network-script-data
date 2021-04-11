turtle_scute_dropper:
    type: world
    debug: true
    events:
        on turtle killed by player:
            - if <player.item_in_hand.is_enchanted> && <player.item_in_hand.enchantments.contains[looting]>:
                - define looting_level <player.item_in_hand.enchantments.level[LOOTING]>
                - define chance <util.random.int[1].to[10]>
                - choose <[looting_level]>:
                    - case 1:
                        - if <[chance]> > 3:
                            - stop
                        - drop scute
                    - case 2:
                        - if <[chance]> > 6:
                            - stop
                        - drop scute
                    - case 3:
                        - drop scute <context.entity.location>
                    - case 4:
                        - drop scute
                        - if <[chance]> > 3:
                            - stop
                        - drop scute
                    - case 5:
                        - drop scute
                        - if <[chance]> > 6:
                            - stop
                        - drop scute
                    - case 6:
                        - drop scute quantity:2
