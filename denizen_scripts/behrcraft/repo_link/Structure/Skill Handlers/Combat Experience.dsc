damage_handler:
    type: world
    debug: false
    events:
        on player damages entity:
        # % ██ [  Determine damage amount ] ██
            - define Damage <context.final_damage>
            
        # % ██ [  Determine if damage is impossible ] ██
            - if <[Damage]> > 80:
                - stop
            - if <player.flag[Behrry.skill.exp.cd]||0> < 75:
                - flag player behrry.skill.exp.cd:+:<context.final_damage> duration:1s
            - else:
                - stop
            
        # % ██ [  Determine Spawner or Exploit ] ██
            - if <player.location.find.entities.within[5].size||30> > 25:
                - stop

        # % ██ [  Determine damage style ] ██
            - choose <context.cause>:
                - case projectile:
                    - run add_xp def:<[Damage]>|Ranged instantly
                - case entity_attack entity_sweep_attack:
                    - choose <player.flag[behrry.combat.attackstyle]||Accurate>:
                        - case accurate:
                            - run add_xp def:<[Damage]>|Attack instantly
                        - case aggressive:
                            - run add_xp def:<[Damage]>|Strength instantly
                        - case defensive:
                            - run add_xp def:<[Damage]>|Defense instantly
            - run add_xp def:<[Damage].div[3]>|Hitpoints instantly

Attack_Style:
    type: command
    name: AttackStyle
    debug: false
    description: Changes your attack style.
    usage: /AttackStyle (Accurate/Aggressive/Defensive)
    permission: behrry.combat.attackstyle
    tab complete:
        - define Args <list[Accurate|Aggressive|Defensive].escaped>
        - determine <proc[OneArg_Command_Tabcomplete].context[1|<[Args]>]>
    script:
        - if <context.args.size||0> != 1:
            - inject Command_Syntax Instantly
        
        - define Style <context.args.first>
        - if !<list[Accurate|Aggressive|Defensive].contains[<[Style]>]>:
            - inject Command_Syntax Instantly
        
        - choose <[Style]>:
            - case accurate:
                - narrate format:Colorize_Green "You are now fighting Accurately"
            - case aggressive:
                - narrate format:Colorize_Green "You are now fighting Aggressively"
            - case defensive:
                - narrate format:Colorize_Green "You are now fighting Defensively"
        - flag player behrry.combat.attackstyle:<[style]>



