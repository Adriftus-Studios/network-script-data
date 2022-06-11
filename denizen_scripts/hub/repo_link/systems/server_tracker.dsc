player_server_tracker:
    type: world
    events:
        on bungee player switches to server:
            - flag server <context.uuid>.oldServer:<server.flag[<context.uuid>.currentServer]>
            - flag server <context.uuid>.currentServer:<context.server>
            - debug debug "<context.uuid> switched from <server.flag[<context.uuid>.oldServer]> to <context.server>"