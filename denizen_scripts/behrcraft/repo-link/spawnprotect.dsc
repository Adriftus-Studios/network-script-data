spawn_events:
    type: world
    debug: false
    events:
        on player breaks block in:spawn:
            - if !<player.is_op> && !<list[PolGesMohol|Behr_Riley|_Behr|Behrry].contains[<player.name>]>:
                - determine cancelled
        on player places block in:spawn:
            - if !<player.is_op> && !<list[PolGesMohol|Behr_Riley|_Behr|Behrry].contains[<player.name>]>:
                - determine cancelled
        on entity spawns in:spawn:
            - if <context.reason> == natural:
                - determine cancelled
