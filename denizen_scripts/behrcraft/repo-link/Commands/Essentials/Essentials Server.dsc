Server_Command:
    type: Command
    debug: false
    name: server
    usage: /server (Server)/(<&lt>Player<&gt>* <&gt>Server<&lt>)
    description: sends yourself or another player to another server
    permission: Behr.Essentials.Server
    tab complete:
        - define Blacklist <server.online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete
    aliases:
        - send
    script:
        - run Server_Command_Task def:<context.raw_args>
        - inject Server_Cmd_Handler "path:events.on server command"

Server_Cmd_Handler:
    type: world
    debug: false
    events:
        on server command:
            - determine passively cancelled
            - run Server_Command_Task def:<context.raw_args>

        on tab complete:
            - if <context.command> == server && !<player.has_permission[Behr.Essentials.Server]>:
                - determine cancelled

Server_Command_Task:
    type: task
    debug: false
    definitions: Args
    script:
        - define Args <[Args].split_args>
        - if <[Args].is_empty>:
            - inject Command_Syntax
        - else if <[Args].size> < 2:
            - define User <player>
            - define Server <[Args].first>
        - else:
            - define Server <[Args].last>
            - if !<bungee.list_servers.contains[<[Server]>]>:
                - narrate "<&e><[Server]> <proc[Colorize].context[is not a valid server.|red]>"
                - stop
            - foreach <[Args].remove[last]> as:User:
                - define User <[Args].get[2]>
                - inject Player_Verification
                - if <[Users].contains[<[User]>]>:
                    - narrate format:Colorize_Red "List contains <[User].name> twice."
                    - stop
                - else:
                    - define Users:->:<[User]>
