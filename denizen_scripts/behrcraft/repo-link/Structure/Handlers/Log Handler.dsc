Login_Handler:
    type: world
    debug: false
    events:
        #@on bungee server connects:
        # % ██ [ Message Discord ] ██
        #^    - while !<bungee.connected>:
        #^        - define wait:+:1
        #^        - if <[Wait]> > 5:
        #^            - announce to_console format:Colorize_Red "Bungee could not establish a connection in time."
        #^            - announce to_console format:Colorize_Red "<script.file_name> // lines: [5] - [13]"
        #^            - stop
        #^        - wait 5t
        #^    - if <bungee.list_servers.contains[Discord]||false>:
        #^        - define DiscordMessage ":white_check_mark: **<context.server>** is now connected."
        #^        - wait 1s
        #^        - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
        #@on bungee server disconnects:
        #^    - if <bungee.list_servers.contains[Discord]||false>:
        #^        - define e <&lt>a:WeeWoo2:592074452896972822<&gt>
        #^        - define DiscordMessage "<[E]> **<context.server>** disconnected."
        #^        - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>

        #@on player logs in:
        #^    - if !<server.list_files[../../../../.playerdata/].contains[<player.uuid>.dsc]>:
        #^        - yaml id:<player.uuid> create
        #^        - yaml id:<player.uuid> savefile:../../../../.playerdata/<player.uuid>.dsc
        #^    - else:
        #^        - yaml id:<player.uuid> load:../../../../.playerdata/<player.uuid>.dsc

        on player joins:
            - determine passively NONE

        # % ██ [ Adjust Flags ] ██
            - define BlackFlags <list[behrry.protecc.prospecting]>
            - foreach <[BlackFlags]> as:BlackFlag:
                - if <player.has_flag[<[BlackFlag]>]>:
                    - flag player <[BlackFlag]>:!
                - if !<player.has_flag[behrry.economy.coins]>:
                    - flag player behrry.economy.coins:0

        # % ██ [ Correct Roles ] ██
        #^  - if <player.in_group[Silent]>:
        #^      - while !<player.groups.contains[Public]>:
        #^          - execute as_server "upc addgroup <player.name> Public"
        #^          - wait 5t

        # % ██ [ Print the chat history ] ██
        #^  - foreach <server.flag[Behrry.Essentials.ChatHistory.Global]> as:Log:
        #^      - define LogType <[Log].unescaped.before[/]>
        #^      - define LogMessage <[Log].unescaped.after[/]>
        #^      - define Flag Behrry.Settings.ChatHistory.<[LogType]>
        #^      - if !<player.has_flag[<[Flag]>]>:
        #^          - flag player <[Flag]>
        #^      - if <player.flag[<[Flag]>]>:
        #^          - narrate <[LogMessage]>

        # % ██ [ Check for first login ] ██
            - if !<player.has_flag[Behrry.Essentials.FirstLogin]>:
                - flag player Behrry.Essentials.FirstLogin
                - define Message "<&6><player.name> <&d>joined BehrCraft for the first time!"
                - define DiscordMessage "<&lt>a:sheep:693346095249752066<&gt> **<player.name>** joined BehrCraft for the first time! <&lt>a:sheep:693346095249752066<&gt>"
                - foreach <server.online_players> as:Player:
                # $ ██ [ Implement with /Settings Command ] ██
                    #- if <[Player].has_flag[Behrry.Settings.Chat.FirstJoined]>:
                    - narrate targets:<[Player]> <[Message]>
                - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
                - stop

        # % ██ [ Adjust Displayname ] ██
        #^  - wait 1s
        #^  - if <player.has_flag[behrry.essentials.display_name]>:
        #^      - adjust <player> display_name:<player.flag[behrry.essentials.display_name]>
        
        # % ██ [ Check if Switching Servers ] ██
        #^  - if <player.has_flag[Behrry.Essentials.ServerSwitching]>:
        #^      - flag player Behrry.Essentials.ServerSwitching:!
        #^      - stop

        # % ██ [ Check if a hidden mod ] ██
            - if <player.has_flag[behrry.moderation.hide]>:
                - stop

            - inject Chat_Event_Messages path:Join_Event
        on player quits:
            - determine passively NONE

        # % ██ [ Remove Flags ] ██
            - define BlacklistFlags <list[behrry.chat.lastreply|behrry.essentials.inbed|Behrry.Essentials.Sitting]>
            - foreach <[BlacklistFlags]> as:Flag:
                - flag player <[Flag]>:!
            
        # % ██ [ Cancel if player was kicked ] ██
            - if <player.has_flag[behrry.moderation.kicked]>:
                - stop
                
        # % ██ [ Check if a hidden mod ] ██
            - if <player.has_flag[behrry.moderation.hide]>:
                - stop

            - inject Chat_Event_Messages path:Quit_Event


Chat_Event_Messages:
    type: task
    debug: false
    script:
        - narrate hello
    Join_Event:
    # % ██ [ Format the message ] ██
        - if <player.has_flag[behrry.essentials.display_name]>:
            - define Name <player.flag[behrry.essentials.display_name]>
        - else:
            - define Name <player.name>
        - define Message "<[Name]> <proc[Colorize].context[joined the game.|yellow]>"
        - define DiscordMessage ":heavy_plus_sign: **<player.name>** joined the game."

    # % ██ [ Print the message ] ██
        - foreach <server.online_players> as:Player:
        # $ ██ [ Implement with /Settings Command ] ██
            #- if <[Player].has_flag[Behrry.Settings.Chat.Joins]>:
            - narrate targets:<[Player]> <[Message]>
        - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>

    Quit_Event:
    # % ██ [ Format the message ] ██
        - if <player.has_flag[behrry.essentials.display_name]>:
            - define Name <player.flag[behrry.essentials.display_name]>
        - else:
            - define Name <player.name>
        - define Message "<[Name]> <proc[Colorize].context[left the game.|yellow]>"
        - define DiscordMessage ":heavy_minus_sign: **<player.name>** left the game."

    # % ██ [ Print the message ] ██
        - foreach <server.online_players> as:Player:
        # $ ██ [ Implement with /Settings Command ] ██
            #- if <[Player].has_flag[Behrry.Settings.Chat.quits]>:
            - narrate targets:<[Player]> <[Message]>
        - bungeerun Discord Discord_Message def:LoudGeneral|<[DiscordMessage]>
ChatEvent_Message:
    type: task
    debug: false
    definitions: PlayerUUID|RawMessage|EventType
    script:
    # % ██ [ Check for Setting ] ██
        - define Flag Behrry.Settings.ChatEvent.<[EventType]>
        - wait 1t
        - foreach <server.online_players> as:Player:
            - if !<[Player].has_flag[<[Flag]>]>:
                - flag <[Player]> <[Flag]>
            - if <[Player].flag[<[Flag]>]>:
            # % ██ [ Check if User is Ignored ] ██
                - if <[Player].has_flag[behrry.essentials.ignorelist]>:
                    - if <player.flag[behrry.essentials.ignorelist].parse[uuid].contains[<[PlayerUUID]>]||false>:
                        - foreach next
                - narrate targets:<[Player]> <[RawMessage].unescaped>

items:
    type: item
    material: stick
    mechanisms:
        nbt: key/<util.random.duuid>
