world_command:
    type: command
    name: world
    debug: false
    description: teleports you to the specified world.
    admindescription: teleports you, or another player, to the specified world; additionally manages worlds.
    usage: /world (worldname)
    adminusage: /world (create/destroy/load/unload/teleport (player)) <&lt>worldname<&gt>
    permission: behr.essentials.world
    aliases:
        - spawn
    tab complete:
    # $ ██ [ change to whitelist server flag based on gui ] ██
        #- define blacklist <list[world_nether|world_the_end|runescape50px1|bandit-craft]>
        - define worlds <list[world|creative|skyblock]>
        - if !<player.groups.contains_any[coordinator|administrator|developer]> || <context.alias> == spawn:
            - if <context.args.is_empty>:
                - determine <[worlds]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[worlds].filter[starts_with[<context.args.first>]]>

        - if <context.alias> != spawn:
            - define subcommands <list[create|destroy|load|unload|teleport]>
            - define loadedworlds <server.worlds.parse[name]>
            - if <context.args.size> == 0:
                - determine <[subcommands].include[<[loadedworlds]>]>

            - define validfolders <server.list_files[../../].exclude[<script[worldfilelist].data_key[blacklist]>]>
            - foreach <[validfolders]> as:folder:
                - if <server.list_files[../../<[folder]>].contains[level.dat]||false>:
                    - define validworlds:->:<[folder]>
            - define validworlds <[validworlds].exclude[<[loadedworlds]>]>

            - if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[subcommands].include[<[loadedworlds]>].filter[starts_with[<context.args.last>]]>
            - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
                - choose <context.args.first>:
                    - case load:
                        - determine <[validworlds]>
                    - case destroy unload teleport tp:
                        - determine <[loadedworlds]>
                    - default:
                        - stop

            - if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - choose <context.args.first>:
                    - case load:
                        - determine <[validworlds].filter[starts_with[<context.args.last>]]>
                    - case destroy unload teleport tp:
                        - determine <[loadedworlds].filter[starts_with[<context.args.last>]]>
                    - default:
                        - stop

            - if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>]> && <context.args.first> == teleport:
                - determine <server.online_players.exclude[<player>].parse[name]>
            - if <context.args.size> == 3 && !<context.raw_args.ends_with[<&sp>]> && <context.args.first> == teleport:
                - determine <server.online_players.exclude[<player>].parse[name].filter[starts_with[<context.args.last>]]>

    script:
    # % ██ [  check args ] ██
        - if <context.args.is_empty>:
            - flag player behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
            - teleport <player> <world[world].spawn_location>
            - stop

    # % ██ [  /world world ] ██
        - else if <context.args.size> == 1:
            - define world <context.args.first.to_titlecase>

            # % ██ [  check if world is blacklisted ] ██
            - define blacklist <list[world_nether|world_the_end|runescape50px1]>
            - if <[blacklist].contains[<[world]>]>:
                - if !<player.groups.contains_any[coordinator|administrator|developer]>:
                    - inject command_syntax
            
            # % ██ [  check if world is loaded ] ██
            - if !<server.worlds.parse[name].contains[<[world]>]>:
                - narrate "<&e><[world].to_titlecase> <proc[colorize].context[is not currently loaded.|red]>"
                - if <player.groups.contains_any[coordinator|administrator|developer]>:
                    - define hover "<proc[colorize].context[click to create:|green]><&nl><&e><[world]>"
                    - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
                    - define command "world create <[world]>"
                    - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
                    - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[create world instead?:|green]> <[world]>"
                - stop

            # % ██ [  check if reasonable teleport ] ██
            - if <player.world.name> == <[world]>:
                - if <player.location.distance[<world[<[world]>].spawn_location>]> < 20:
                    - narrate format:colorize_red "you are already here."
                    - stop

        # % ██ [  check for creative ban ] ██
            - if <[world]> == creative && <player.has_flag[behrry.moderation.creativeban]>:
                - narrate "this world is creative only and you are creative banned."
                - stop

            # % ██ [  teleport player to the world ] ██
            - flag <player> behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
            - teleport <player> <world[<[world]>].spawn_location>
            - narrate "<proc[colorize].context[you were teleported to world:|green]> <[world]>"
            - stop

        - else if !<player.groups.contains_any[coordinator|administrator|developer]>:
            - inject command_syntax

        - else if <context.args.size> < 2:
            - define reason "must specify a name."
            - inject command_error

        - else if <context.args.size> > 4:
            - inject command_syntax

        - define validfolders <server.list_files[../../].exclude[<script[worldfilelist].data_key[blacklist]>]>
        - foreach <[validfolders]> as:folder:
            - if <server.list_files[../../<[folder]>].contains[level.dat]||false>:
                - define validworlds:->:<[folder]>
        - define loadedworlds <server.worlds.parse[name]>
        - define validworlds:!|:<[validworlds].exclude[<[loadedworlds]>]>
        - define world <context.args.get[2]>
        
        - choose <context.args.first>:
            - case create:
                - if <context.args.size> != 2:
                    - inject command_syntax

                - if <[loadedworlds].contains[<[world]>]>:
                    - narrate format:colorize_red "this world is loaded already."
                    - stop

                - if <[validworlds].contains[<[world]>]>:
                    - narrate format:colorize_red "world already exists."
                    - inject locally loadworld

                - else if !<[world].matches[[a-za-z0-9-\&]+]>:
                    - narrate "world names should be alphanumerical."
                    - stop

                - else:
                    - inject locally createworld

            - case destroy:
                - if <context.args.size> != 2:
                    - inject command_syntax
                    
                - if !<[loadedworlds].contains[<[world]>]>:
                    - define reason "world does not exist."
                    - inject command_error

                - if <[world]> == world:
                    - narrate format:colorize_red "this world requires manual deletion."
                    - stop
                    
                - define blacklist <list[runescape50px1|bandit-craft|gielinor3]>
                - if <[blacklist].contains[<[world]>]> && !<player.in_group[coordinator]>:
                    - narrate format:colorize_red "this world is blacklisted for deletion."
                    - stop

                - inject locally destroyworld

            - case load:
                - if <context.args.size> != 2:
                    - inject command_syntax
                    
                - if <[loadedworlds].contains[<[world]>]>:
                    - narrate format:colorize_red "this world is loaded already."
                    - stop

                - if !<[validworlds].contains[<[world]>]>:
                    - narrate format:colorize_red "world does not exist or not found."
                    - inject locally createworld
                    - stop

                - inject locally loadworld

            - case unload:
                - if <context.args.size> != 2:
                    - inject command_syntax
                    
                - if !<[loadedworlds].contains[<[world]>]>:
                    - narrate format:colorize_red "this world is not loaded."
                    - stop

                - if <[world]> == world:
                    - narrate format:colorize_red "this world cannot be unloaded."
                    - stop
                    
                - define blacklist <list[world_the_end|world_nether]>
                - if <[blacklist].contains[<[world]>]> && !<player.in_group[coordinator]>:
                    - narrate format:colorize_red "this world is blacklisted for unloading."
                    - stop
                
                - inject locally unloadworld

            - case teleport:
                - if <context.args.size> < 2:
                    - inject command_syntax
                
                - if <context.args.size> == 3:
                    - define user <context.args.get[3]>
                    - inject player_verification
                - else:
                    - define user <player>

                # % ██ [  check if world is loaded ] ██
                - if !<server.worlds.parse[name].contains[<[world]>]>:
                    - narrate "<&e><[world].to_titlecase> <proc[colorize].context[is not currently loaded.|red]>"
                    - define hover "<proc[colorize].context[click to create:|green]><&nl><&e><[world]>"
                    - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
                    - define command "world create <[world]>"
                    - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
                    - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[create world instead?:|green]> <[world]>"
                    - stop

                # % ██ [  check if reasonable teleport ] ██
                - if <[user].world.name> == <[world]>:
                    - if <[user].location.distance[<world[<[world]>].spawn_location>]> < 20:
                        - narrate format:colorize_red "player is already there."
                        - stop

                # % ██ [  check for creative ban ] ██
                - if <[world]> == creative && <[user].has_flag[behrry.moderation.creativeban]>:
                    - if <[user]> != <player>:
                        - narrate targets:<player> "player is creative banned."
                    - else:
                        - narrate targets:<[user]> "this world is creative only and you are creative banned."
                    - stop

                # % ██ [  teleport player to the world ] ██
                - flag <[user]> behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
                - teleport <[user]> <world[<[world]>].spawn_location>
                - narrate targets:<[user]> "<proc[colorize].context[you were teleported to world:|green]> <[world]>"
                - if <[user]> != <player>:
                    - narrate "<proc[colorize].context[was teleported to world:|green]> <[world]>"

            - default:
                - inject command_syntax
    loadworld:
        - if !<player.has_flag[behrry.constructor.worldprompt.load]>:
            - flag player behrry.constructor.worldprompt.load duration:10s
            - define hover "<proc[colorize].context[click to load:|green]><&nl><&e><[world]>"
            - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
            - define command "world load <[world]>"
            - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
            - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[load world?:|green]> <&e><[world]>"
            - stop
        - flag player behrry.constructor.worldprompt.load:!
        - narrate format:colorize_green "loading world..."
        - createworld <[world]>
        - wait 1s
        - narrate "<&a>world loaded<&2>: <&6>[<&e><[world].to_titlecase><&6>]"
        - execute as_server "dynmap:dmap worldset <[world]> enabled:false"

    createworld:
        - if !<player.has_flag[behrry.constructor.worldprompt.create]>:
            - flag player behrry.constructor.worldprompt.create duration:10s
            - define hover "<proc[colorize].context[click to create:|green]><&nl><&e><[world]>"
            - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
            - define command "world create <[world]>"
            - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
            - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[create world?:|green]> <&e><[world]>"
            - stop
        - flag player behrry.constructor.worldprompt.create:!
        - narrate format:colorize_green "creating world..."
        - createworld <[world]>
        - wait 1s
        - narrate "<&a>world created<&2>: <&6>[<&e><[world].to_titlecase><&6>]"
        - execute as_server "dynmap:dmap worldset <[world]> enabled:false"

    destroyworld:
        - if !<player.has_flag[behrry.constructor.worldprompt.destroy0]>:
            - flag player behrry.constructor.worldprompt.destroy0 duration:10s
            - define hover "<proc[colorize].context[click to destroy:|red]><&nl><&e><[world]>"
            - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
            - define command "world destroy <[world]>"
            - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
            - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[destroy world?:|green]> <&e><[world]>"
            - stop
        - if !<player.has_flag[behrry.constructor.worldprompt.destroy1]>:
            - flag player behrry.constructor.worldprompt.destroy1 duration:10s
            - define hover "<proc[colorize].context[click to destroy:|red]><&nl><&e><[world]>"
            - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
            - define command "world destroy <[world]>"
            - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
            - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[really really destroy world?:|green]> <&e><[world]>"
            - stop
        - flag player behrry.constructor.worldprompt.destroy0:!
        - flag player behrry.constructor.worldprompt.destroy1:!
        - narrate format:colorize_green "destroying world..."
        - adjust <world[<[world]>]> destroy
        - wait 1s
        - narrate "<&c>world destroyed<&4>: <&6>[<&e><[world].to_titlecase><&6>]"

    unloadworld:
        - if !<player.has_flag[behrry.constructor.worldprompt.unload]>:
            - flag player behrry.constructor.worldprompt.unload duration:10s
            - define hover "<proc[colorize].context[click to unload:|green]><&nl><&e><[world]>"
            - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
            - define command "world unload <[world]>"
            - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
            - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[unload world?:|green]> <[world]>"
            - stop
        - flag player behrry.constructor.worldprompt.destroy0:!
        - narrate format:colorize_green "unloading world..."
        - adjust <world[<[world]>]> unload
        - wait 1s
        - narrate "<&c>world unloaded<&4>: <&6>[<&e><[world].to_titlecase><&6>]"

worldfilelist:
    type: data
    worlds:
        - world
        - world_nether
        - world_the_end
        - hub
        - creative
        - runescape50px1

        - gielinor3
        - bandit-craft
        - 04192020_import
        - gaybabyjail
    blacklist:
        - banned-ips.json
        - banned-players.json
        - bukkit.yml
        - cache
        - commands.yml
        - crash-reports
        - data
        - eula.txt
        - help.yml
        - logs
        - ops.json
        - paper.yml
        - permissions.yml
        - plugins
        - server-icon.png
        - server.properties
        - spigot.yml
        - usercache.json
        - version_history.json
        - wepif.yml
        - whitelist.json
