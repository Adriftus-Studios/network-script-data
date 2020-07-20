# | ███████████████████████████████████████████████████████████
# % ██    /tpdecline - Declines a teleport request
# | ██
# % ██  [ Command ] ██
TPDecline_Command:
    type: command
    name: tpdecline
    debug: false
    description: Declines a teleport request sent to you.
    usage: /tpdecline (<&lt>Player<&gt>)
    permission: behrry.essentials.tpdecline
    tab complete:
        - if <context.args.size||0> == 0:
            - determine <server.list_online_players.parse[name].exclude[<player.name>]>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.list_online_players.parse[name].exclude[<player.name>].filter[starts_with[<context.args.get[1]>]]>
    script:
        #@ Check Args
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly

        #@ Check if player has a request
        - if <player.has_flag[behrry.essentials.teleport.request]>:
            #@ Check if player is specifying player
            - if <context.args.get[1]||null> == null:
                - define User <player.flag[behrry.essentials.teleport.request].get[1].before[/]>
                - define Loc <player.flag[behrry.essentials.teleport.request].get[1].after[/]>
            - else:
                - define User <context.args.get[1]>
                - inject Player_Verification_Offline Instantly
                #@ Check if player is requested a teleport
                - if <player.flag[behrry.essentials.teleport.request].parse[before[/]].contains[<[User]>]>:
                    - define Loc <player.flag[behrry.essentials.teleport.request].map_get[<[User]>]>
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop

            #@ Check teleport request type, adjust flags
            - if <player.flag[behrry.essentials.teleport.requesttype].map_get[<[User]>]||false> == teleportto:
                - flag <player> behrry.essentials.teleport.requesttype:<-:<[User]>/teleportto
            - flag <player> behrry.essentials.teleport.request:<-:<[User]>/<[Loc]>

            #@ Print to Players
            - narrate targets:<player> "<proc[Colorize].context[Teleport request declined.|green]>"
            - narrate targets:<[User]> "<proc[User_Display_Simple].context[<player>]> <proc[Colorize].context[declined your teleport request.|green]>"
        - else:
            - narrate "<proc[Colorize].context[No teleport request found.|red]>"