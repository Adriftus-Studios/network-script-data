PlayerData_Command:
    type: command
    name: playerdata
    debug: false
    description: Manage the notable player data
    usage: /PlayerData <&lt>Player<&gt>
    permission: Behrry.Moderation.PlayerData
    aliases:
        - pdata
    tab complete:
        - inject All_Player_Tabcomplete Instantly
    script:
    # % ██ [ Check Args] ██
        - if <context.args.size> != 1:
            - inject Command_Syntax Instantly
        
    # % ██ [ Check player arg ] ██
        - define User <context.args.first>
        - inject Player_Verification_Offline Instantly
        
    # % ██ [ Essentials ] ██
    # % ██ [ GameModes ] ██
        - foreach <list[Survival|Creative|Spectator|Adventure]> as:Gamemode:
        # $ ██ [ Flag Consistency Update: ] ██
        # $ ██ | Replace: Gamemode.Inventory.*
        # $ ██ | With:    Behrry.Essentials.GamemodeInventory.*
            - define Inventories:->:Gamemode.Inventory.<[Gamemode]>
        
    # % ██ [ Define Settings ] ██
        - define SettingsList <list[settings.essentials.bedspawn]>
       

    # % ██ [ Define Sponsor Settings ] ██
        - define List <list[Behrry.Essentials.RepairLimit]>

Flag_Consistency_Task:
    type: task
    debug: false
    definitions: OldFlag|NewFlag
    script:
        - define Day <util.date.time.Day>
        - define Month <util.date.time.Month>
        - define Year <util.date.time.Year>
        - define Hour <util.date.time.Hour>
        - define Minute <util.date.time.Minute>
        - define Time <[Day]>-<[Month]>-<[Year]>---<[Hour]>-<[Minute]>

        - foreach <server.players> as:Player:
            - if <[Player].has_flag[<[OldFlag]>]>:
                - flag <[Player]> <[NewFlag]>:<[Player].flag[<[OldFlag]>]>
                - log "<[Player]> (<[Player].name>/<[Player].UUID>) OldFlag:<[OldFlag]>:<[Player].flag[<[OldFlag]> && NewFlag:<[NewFlag]>:<[Player].flag[<[NewFlag]>" type:INFO file:plugins/Denizen/data/ConsistencyUpdate_<[Time]>.log
            #^  - flag <[Player]> <[OldFlag]>:!
