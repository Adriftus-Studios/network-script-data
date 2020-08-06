Save_Handler:
    type: world
    debug: false
    events:
        on system time minutely every:15:
            - if <server.online_players.size> == 0:
                - if <server.has_flag[behrry.essentials.save.lastrack]>:
                    - stop
                - else:
                    - flag server behrry.essentials.save.lastrack
                    - execute as_server save-all
                - flag server behrry.essentials.save.playertrack:!
            - else:
                - execute as_server save-all
