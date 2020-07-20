# | ███████████████████████████████████████████████████████████
# % ██    /sendserver
# | ██
# % ██  [ Command ] ██
sendserver_Command:
    type: command
    name: sendserver
    debug: false
    description: Sends everyone but yourself to the selected server..
    usage: /sendserver
    permission: behrry.essentials.sendserver
    script:
    # @ ██ [  Check for args ] ██
        - if <context.args.get[1]||null> == null:
            - inject Command_Syntax Instantly
        
    # @ ██ [  Check for valid server ] ██
        - if !<bungee.list_servers.contains[<context.args.get[1]>]>:
            - narrate format:Colorize_Red "Invalid Server: <context.args.get[1]>"

    # @ ██ [  warn & send ] ██
        - announce "<&c>Sending you to: <&e>BanditCraft"
        - wait 2s
        - foreach <server.list_online_players.exclude[<player>]> as:Player:
            - adjust <[Player]> send_to:<context.args.get[1]>



