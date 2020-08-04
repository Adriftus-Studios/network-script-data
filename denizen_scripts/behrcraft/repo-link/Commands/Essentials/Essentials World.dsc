World_Command:
    type: command
    name: world
    debug: false
    description: Teleports you to the specified world.
    admindescription: Teleports you, or another player, to the specified world; Additionally manages worlds.
    usage: /world (WorldName)
    adminusage: /world (Create/Destroy/Load/Unload/Teleport (Player)) <&lt>WorldName<&gt>
    permission: Behr.Essentials.World
    aliases:
        - spawn
    tab complete:
    # $ ██ [ Change to Whitelist server flag based on GUI ] ██
        #- define blacklist <list[World_Nether|World_The_End|Runescape50px1|Bandit-Craft]>
        - define Worlds <list[World|Creative|SkyBlock]>
        - if !<player.groups.contains_any[Coordinator|Administrator|Developer]> || <context.alias> == spawn:
            - if <context.args.size||0> == 0:
                - determine <[Worlds]>
            - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[Worlds].filter[starts_with[<context.args.first>]]>

        - if <context.alias> != spawn:
            - define SubCommands <list[Create|Destroy|Load|Unload|Teleport]>
            - define LoadedWorlds <server.worlds.parse[name]>
            - if <context.args.size> == 0:
                - determine <[SubCommands].include[<[LoadedWorlds]>]>

            - define ValidFolders "<server.list_files[../../].exclude[<script[WorldFileList].data_key[Blacklist]>]>"
            - foreach <[ValidFolders]> as:Folder:
                - if <server.list_files[../../<[Folder]>].contains[level.dat]||false>:
                    - define ValidWorlds:->:<[Folder]>
            - define ValidWorlds <[ValidWorlds].exclude[<[LoadedWorlds]>]>

            - if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
                - determine <[SubCommands].include[<[LoadedWorlds]>].filter[starts_with[<context.args.last>]]>
            - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
                - choose <context.args.first>:
                    - case Load:
                        - Determine <[ValidWorlds]>
                    - case Destroy Unload Teleport tp:
                        - Determine <[LoadedWorlds]>
                    - default:
                        - stop

            - if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
                - choose <context.args.first>:
                    - case Load:
                        - Determine <[ValidWorlds].filter[starts_with[<context.args.last>]]>
                    - case Destroy Unload Teleport tp:
                        - Determine <[LoadedWorlds].filter[starts_with[<context.args.last>]]>
                    - default:
                        - stop

            - if <context.args.size> == 2 && <context.raw_args.ends_with[<&sp>]> && <context.args.first> == Teleport:
                - determine <server.online_players.exclude[<player>].parse[name]>
            - if <context.args.size> == 3 && !<context.raw_args.ends_with[<&sp>]> && <context.args.first> == Teleport:
                - determine <server.online_players.exclude[<player>].parse[name].filter[starts_with[<context.args.last>]]>

    script:
    # % ██ [  Check Args ] ██
        - if <context.args.is_empty>:
            - flag player Behr.Essentials.Teleport.Back:<player.location>
            - teleport <player> <world[world].spawn_location>
            - stop

    # % ██ [  /world World ] ██
        - else if <context.args.size> == 1:
            - define World <context.args.first.to_titlecase>

            # % ██ [  Check if world is Blacklisted ] ██
            - define blacklist <list[World_Nether|World_The_End|Runescape50px1]>
            - if <[Blacklist].contains[<[World]>]>:
                - if !<player.groups.contains_any[Coordinator|Administrator|Developer]>:
                    - inject Command_Syntax
            
            # % ██ [  Check if world is loaded ] ██
            - if !<server.worlds.parse[name].contains[<[World]>]>:
                - narrate "<&e><[World].to_titlecase> <proc[Colorize].context[is not currently loaded.|Red]>"
                - if <player.groups.contains_any[Coordinator|Administrator|Developer]>:
                    - define Hover "<proc[Colorize].context[Click to Create:|green]><&nl><&e><[World]>"
                    - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
                    - define Command "world Create <[World]>"
                    - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
                    - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Create World instead?:|green]> <[World]>"
                - stop

            # % ██ [  Check if reasonable teleport ] ██
            - if <player.world.name> == <[World]>:
                - if <player.location.distance[<world[<[World]>].spawn_location>]> < 20:
                    - narrate format:Colorize_red "You are already here."
                    - stop

        # % ██ [  Check for Creative Ban ] ██
            - if <[World]> == Creative && <player.has_flag[Behrry.Moderation.CreativeBan]>:
                - narrate "This world is Creative Only and you are Creative Banned."
                - stop

            # % ██ [  Teleport player to the world ] ██
            - flag <Player> Behr.Essentials.teleport.back:<player.location>
            - teleport <player> <world[<[World]>].spawn_location>
            - narrate "<proc[Colorize].context[You were teleported to world:|green]> <[World]>"
            - stop

        - else if !<player.groups.contains_any[Coordinator|Administrator|Developer]>:
            - inject Command_Syntax

        - else if <context.args.size> < 2:
            - define Reason "Must specify a name."
            - inject Command_Error

        - else if <context.args.size> > 4:
            - inject Command_Syntax

        - define ValidFolders "<server.list_files[../../].exclude[<script[WorldFileList].data_key[Blacklist]>]>"
        - foreach <[ValidFolders]> as:Folder:
            - if <server.list_files[../../<[Folder]>].contains[level.dat]||false>:
                - define ValidWorlds:|:<[Folder]>
        - define LoadedWorlds <server.worlds.parse[name]>
        - define ValidWorlds:!|:<[ValidWorlds].exclude[<[LoadedWorlds]>]>
        - define World <context.args.get[2]>
        
        - choose <context.args.first>:
            - case Create:
                - if <context.args.size> != 2:
                    - inject Command_Syntax

                - if <[LoadedWorlds].contains[<[World]>]>:
                    - narrate format:colorize_red "This world is loaded already."
                    - stop

                - if <[ValidWorlds].contains[<[World]>]>:
                    - narrate format:colorize_red "World already exists."
                    - inject Locally LoadWorld

                - else if !<[World].matches[[a-zA-Z0-9-\&]+]>:
                    - narrate "World names should be alphanumerical."
                    - stop

                - else:
                    - inject Locally CreateWorld

            - case Destroy:
                - if <context.args.size> != 2:
                    - inject Command_Syntax
                    
                - if !<[LoadedWorlds].contains[<[World]>]>:
                    - define Reason "World does not exist."
                    - inject Command_Error

                - if <[World]> == world:
                    - narrate format:Colorize_Red "This World requires manual deletion."
                    - stop
                    
                - define Blacklist <list[Runescape50px1|Bandit-Craft|Gielinor3]>
                - if <[Blacklist].contains[<[World]>]> && !<player.in_group[Coordinator]>:
                    - narrate format:Colorize_red "This world is blacklisted for deletion."
                    - stop

                - inject locally DestroyWorld

            - case Load:
                - if <context.args.size> != 2:
                    - inject Command_Syntax
                    
                - if <[LoadedWorlds].contains[<[World]>]>:
                    - narrate format:colorize_red "This world is loaded already."
                    - stop

                - if !<[ValidWorlds].contains[<[World]>]>:
                    - narrate format:colorize_red "World does not exist or not found."
                    - inject Locally Createworld
                    - stop

                - inject Locally LoadWorld

            - case Unload:
                - if <context.args.size> != 2:
                    - inject Command_Syntax
                    
                - if !<[LoadedWorlds].contains[<[World]>]>:
                    - narrate format:colorize_red "This world is not loaded."
                    - stop

                - if <[World]> == world:
                    - narrate format:Colorize_Red "This World cannot be unloaded."
                    - stop
                    
                - define Blacklist <list[World_The_End|World_Nether]>
                - if <[Blacklist].contains[<[World]>]> && !<player.in_group[Coordinator]>:
                    - narrate format:Colorize_red "This world is blacklisted for unloading."
                    - stop
                
                - inject Locally UnloadWorld

            - case Teleport:
                - if <context.args.size> < 2:
                    - inject Command_Syntax
                
                - if <context.args.size> == 3:
                    - define User <context.args.get[3]>
                    - inject Player_Verification
                - else:
                    - define User <player>

                # % ██ [  Check if world is loaded ] ██
                - if !<server.worlds.parse[name].contains[<[World]>]>:
                    - narrate "<&e><[World].to_titlecase> <proc[Colorize].context[is not currently loaded.|Red]>"
                    - define Hover "<proc[Colorize].context[Click to Create:|green]><&nl><&e><[World]>"
                    - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
                    - define Command "world Create <[World]>"
                    - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
                    - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Create World instead?:|green]> <[World]>"
                    - stop

                # % ██ [  Check if reasonable teleport ] ██
                - if <[User].world.name> == <[World]>:
                    - if <[User].location.distance[<world[<[World]>].spawn_location>]> < 20:
                        - narrate format:Colorize_red "Player is already there."
                        - stop

                # % ██ [  Check for Creative Ban ] ██
                - if <[World]> == Creative && <[User].has_flag[Behrry.Moderation.CreativeBan]>:
                    - if <[User]> != <player>:
                        - narrate targets:<player> "Player is Creative Banned."
                    - else:
                        - narrate targets:<[User]> "This world is Creative Only and you are Creative Banned."
                    - stop

                # % ██ [  Teleport player to the world ] ██
                - flag <[User]> Behr.Essentials.teleport.back:<player.location>
                - teleport <[User]> <world[<[World]>].spawn_location>
                - narrate targets:<[User]> "<proc[Colorize].context[You were teleported to world:|green]> <[World]>"
                - if <[User]> != <player>:
                    - narrate "<proc[Colorize].context[was teleported to world:|green]> <[World]>"

            - default:
                - inject Command_Syntax
    LoadWorld:
        - if !<player.has_flag[Behrry.Constructor.WorldPrompt.Load]>:
            - flag player Behrry.Constructor.WorldPrompt.Load duration:10s
            - define Hover "<proc[Colorize].context[Click to Load:|green]><&nl><&e><[World]>"
            - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
            - define Command "world load <[World]>"
            - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Load World?:|green]> <&e><[World]>"
            - stop
        - flag player Behrry.Constructor.WorldPrompt.Load:!
        - narrate format:colorize_green "Loading World..."
        - createworld <[World]>
        - wait 1s
        - narrate "<&a>World Loaded<&2>: <&6>[<&e><[World].to_titlecase><&6>]"
        - execute as_server "dynmap:dmap worldset <[World]> enabled:false"

    CreateWorld:
        - if !<player.has_flag[Behrry.Constructor.WorldPrompt.Create]>:
            - flag player Behrry.Constructor.WorldPrompt.Create duration:10s
            - define Hover "<proc[Colorize].context[Click to Create:|green]><&nl><&e><[World]>"
            - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
            - define Command "world Create <[World]>"
            - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Create World?:|green]> <&e><[World]>"
            - stop
        - flag player Behrry.Constructor.WorldPrompt.Create:!
        - narrate format:colorize_green "Creating World..."
        - createworld <[World]>
        - wait 1s
        - narrate "<&a>World Created<&2>: <&6>[<&e><[World].to_titlecase><&6>]"
        - execute as_server "dynmap:dmap worldset <[World]> enabled:false"

    DestroyWorld:
        - if !<player.has_flag[Behrry.Constructor.WorldPrompt.Destroy0]>:
            - flag player Behrry.Constructor.WorldPrompt.Destroy0 duration:10s
            - define Hover "<proc[Colorize].context[Click to Destroy:|red]><&nl><&e><[World]>"
            - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
            - define Command "world Destroy <[World]>"
            - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Destroy World?:|green]> <&e><[World]>"
            - stop
        - if !<player.has_flag[Behrry.Constructor.WorldPrompt.Destroy1]>:
            - flag player Behrry.Constructor.WorldPrompt.Destroy1 duration:10s
            - define Hover "<proc[Colorize].context[Click to Destroy:|red]><&nl><&e><[World]>"
            - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
            - define Command "world Destroy <[World]>"
            - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Really Really Destroy World?:|green]> <&e><[World]>"
            - stop
        - flag player Behrry.Constructor.WorldPrompt.Destroy0:!
        - flag player Behrry.Constructor.WorldPrompt.Destroy1:!
        - narrate format:colorize_green "Destroying World..."
        - adjust <world[<[World]>]> destroy
        - wait 1s
        - narrate "<&c>World Destroyed<&4>: <&6>[<&e><[World].to_titlecase><&6>]"

    UnloadWorld:
        - if !<player.has_flag[Behrry.Constructor.WorldPrompt.Unload]>:
            - flag player Behrry.Constructor.WorldPrompt.Unload duration:10s
            - define Hover "<proc[Colorize].context[Click to Unload:|green]><&nl><&e><[World]>"
            - define Text "<&a>[<&2><&l><&chr[2714]><&r><&a>]"
            - define Command "world Unload <[World]>"
            - define Accept <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - narrate "<&b>| <[Accept]> <&b>| <proc[Colorize].context[Unload World?:|green]> <[World]>"
            - stop
        - flag player Behrry.Constructor.WorldPrompt.Destroy0:!
        - narrate format:colorize_green "Unloading World..."
        - adjust <world[<[World]>]> Unload
        - wait 1s
        - narrate "<&c>World Unloaded<&4>: <&6>[<&e><[World].to_titlecase><&6>]"

WorldFileList:
    type: data
    Worlds:
        - world
        - world_nether
        - world_the_end
        - Hub
        - Creative
        - Runescape50px1

        - Gielinor3
        - Bandit-Craft
        - 04192020_import
        - GayBabyJail
    Blacklist:
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
