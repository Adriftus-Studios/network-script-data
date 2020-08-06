KillAura_Command:
    type: command
    name: killaura
    debug: false
    description: Activates a kill-aura
    usage: /killaura (Player)
    permission: Behrry.Moderation.KillAura
    script:
        - if <context.args.is_empty>:
            - define User <player>

        - else if <context.args.size> > 1:
            - inject Command_Syntax Instantly
        
        - else:
            - define User <context.args.first>
            - inject Player_Verification Instantly
        
        - if <[User].has_flag[Behrry.Moderation.KillAura]>:
            - flag <[User]> Behrry.Moderation.KillAura:!
            - narrate "Deactivated"
            - stop
        - else:
            - flag <[User]> Behrry.Moderation.KillAura
            - narrate "Activated"
        - while <[User].has_flag[Behrry.Moderation.KillAura]> || <[player].is_online>:
            - define Mobs <[User].location.find.entities[Zombie|Vex|Creeper|Witch|Spider|cave_spider|Phantom|Drowned|Slime|Skeleton|Pillager].within[35]>
            - remove <[Mobs]>
            - wait 3s

KillAura_Handler:
    type: world
    debug: false
    events:
        on player quits:
            - flag player Behrry.Moderation.KillAura:!
