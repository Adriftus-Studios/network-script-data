settings_Command:
    type: command
    name: settings
    debug: false
    description: Adjusts your personal settings.
    usage: /settings (Setting (On/Off)/default)
    permission: Behr.Essentials.Settings
    script:
    # % ██ [ Check for args ] ██
    # $ ██ [ to-do: GUI ] ██
        - if <context.args.size> != 1:
            - inject Command_Syntax
        
        - if <context.args.first> == Default:
            - foreach <script.key[Settings.Defaults]> as:Flag:
                - flag <player> <[Flag]>

        - else:
            - narrate format:colorize_yellow "Nothing interesting happens."
    Settings:
        Defaults:
            - Behrry.Settings.ChatHistory.FirstJoined
            - Behrry.Settings.ChatHistory.Joined
            - Behrry.Settings.ChatHistory.Switched
            - Behrry.Settings.ChatHistory.Quit
            - Behrry.Settings.ChatHistory.Players
            
            - Behrry.Chat.Joins
            - Behrry.Chat.Quit

            - Behr.Essentials.BedSpawn

    # % ██ [ Chat History Loading ] ██
    # % ██ [ Settings for enabling/disabling these settings when Chat History loads ] ██
        Behrry.Settings.ChatHistory:
            - FirstJoined
            - Joined
            - Switched
            - Quit
            - Players
            - PrivateMessage

    # % ██ [ Chat ] ██
    # % ██ [ Settings for what messages players receive in-game ] ██
        Behrry.Settings.Chat:
            - Joins
            - Quit

    # % ██ [ Essentials ] ██
    # % ██ [ Settings for enabling/disabling Survival Settings ] ██
        Behrry.Settings.Essentials:
            - BedSpawn
        
        SponsorExclusive:
            - Behrry.Settings.Chat.FirstJoined
