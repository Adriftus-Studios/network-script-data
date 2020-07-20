Server_Command:
    type: Command
    debug: false
    name: server
    usage: /server (Server)/(<&lt>Player<&gt>* <&gt>Server<&lt>)
    description: sends yourself or another player to another server
    permission: behrry.essentials.server
    tab complete:
        - define Blacklist <server.list_online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - inject Online_Player_Tabcomplete Instantly
    aliases:
        - send
    script:
        - inject Server_Cmd_Handler "path:events.on server command"


Server_Cmd_Handler:
    type: world
    debug: false
    events:
        on server command:
            - determine passively cancelled
            - if <context.args.get[1]||null> == null:
                - inject Command_Syntax Instantly
            - if <context.args.get[2]||null> == null:
                - define User <player>
                - define Server <context.args.get[1]>
            - else:
                - define Server <context.args.last>
                - if !<bungee.list_servers.contains[<[Server]>]>:
                    - narrate "<&e><[Server]> <proc[Colorize].context[is not a valid server.|red]>"
                    - stop
                - foreach <context.args.remove[last]> as:User:
                    - define User <context.args.get[2]>
                    - inject Player_Verification Instantly
                    - if <[Users].contains[<[User]>]>:
                        - narrate format:Colorize_Red "List contains <[User].name> twice."
                        - stop
                    - else:
                        - define Users:->:<[User]>
                
        on tab complete:
            - if <context.command> == server && !<player.has_permission[behrry.essentials.server]>:
                - determine cancelled