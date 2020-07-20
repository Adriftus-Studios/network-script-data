# | ███████████████████████████████████████████████████████████
# % ██    /tpaccept - Accepts a teleport request
# | ██
# % ██  [ Command ] ██
TPAccept_Command:
    type: command
    name: tpaccept
    debug: false
    description: Accepts a teleport request sent to you.
    usage: /tpaccept (<&lt>Player<&gt>)
    permission: behrry.essentials.tpaccept
    tab complete:
        - define Blacklist <server.list_online_players.filter[has_flag[Behrry.Moderation.Hide]].include[<Player>]>
        - Inject Online_Player_Tabcomplete
    script:
        - if <context.args.get[2]||null> != null:
            - inject Command_Syntax Instantly

        - if <player.has_flag[behrry.essentials.teleport.request]>:
            - if <context.args.get[1]||null> == null:
                - define User <player.flag[behrry.essentials.teleport.request].get[1].before[/]>
                - define Loc <player.flag[behrry.essentials.teleport.request].get[1].after[/]>
            - else:
                - define User <context.args.get[1]>
                - inject Player_Verification_Offline Instantly
                - if <player.flag[behrry.essentials.teleport.request].parse[before[/]].contains[<[User]>]>:
                    - define Loc <player.flag[behrry.essentials.teleport.request].map_get[<[User]>]>
                - else:
                    - narrate "<proc[Colorize].context[No teleport request found.|red]>"
                    - stop
            
            - narrate targets:<[User]>|<player> "<proc[Colorize].context[Teleport request accepted.|green]>"
            - if <player.has_flag[behrry.essentials.teleport.requesttype]>:
                - if <player.flag[behrry.essentials.teleport.requesttype].map_get[<[User]>]||false> == teleportto:
                    - flag <player> behrry.essentials.teleport.requesttype:<-:<[User]>/teleportto
                    - flag <player> behrry.essentials.teleport.request:<-:<[User]>/<[Loc]>
                    - flag <[User]> behrry.essentials.teleport.back:<[User].location>
                    - teleport <[User]> <player.location.add[0.01,0,0.01]>
            - else:
                - flag <player> behrry.essentials.teleport.request:<-:<[User]>/<[Loc]>
                - flag <player> behrry.essentials.teleport.back:<player.location>
                - teleport <player> <[Loc].add[0.01,0,0.01]>

        - else:
            - narrate "<proc[Colorize].context[No teleport request found.|red]>"