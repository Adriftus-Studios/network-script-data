Level_Command:
    type: command
    name: level
    debug: false
    description: Checks your level in a skill.
    usage: /level (Skill)
    permission: behrry.skill.level
    tab complete:
        - define Args <list[Attack|Strength|Defense|Hitpoints|Ranged|Mining|Woodcutting|Farming|Construction]>
        - inject OneArg_Command_Tabcomplete
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly
        
    # % ██ [ Check if blank ] ██
        - if <context.args.first||null> == null:
            - narrate format:Colorize_Green "Available Skills:"
            - narrate format:Colorize_Yellow "Attack, Strength, Defense, Hitpoints, Ranged, Mining, Woodcutting, Farming, Construction"
            - stop

    # % ██ [ Verify Skill ] ██
        - define Skills <list[Attack|Strength|Defense|Hitpoints|Ranged|Mining|Woodcutting|Farming|Construction]>
        - define Skill <context.args.first.to_titlecase>
        - if !<[Skills].contains[<[Skill]>]>:
            - inject Command_Syntax Instantly

    # % ██ [ Verify exists ] ██
        - if !<player.has_flag[behrry.skill.<[skill]>.Exp]>:
            - flag player behrry.skill.<[skill]>.Exp:0
        - if !<player.has_flag[behrry.skill.<[skill]>.ExpReq]>:
            - flag player behrry.skill.<[skill]>.ExpReq:0
        - if !<player.has_flag[behrry.skill.<[skill]>.Level]>:
            - flag player behrry.skill.<[skill]>.Level:1

    # % ██ [ Print Format ] ██
        - define Lvl <player.flag[behrry.skill.<[Skill]>.Level]>
        - define TotalExp <player.flag[behrry.skill.<[Skill]>.Exp].round>
        - define ExpReq <player.flag[behrry.skill.<[Skill]>.ExpReq].round>
        - define LvlExpReq <proc[xp_calc].context[<player.flag[behrry.skill.<[Skill]>.level]>]>

        - define SkillLevel "<&6>[<&e><[Skill]><&6>]<&e> level<&6>: <&a><[Lvl]>"
        - define Progress "<&e>Experience<&6>: <&a><[ExpReq]><&2>/<&a><[LvlExpReq]> <&b>| <&a><[ExpReq].div[<[LvlExpReq]>].round_to_precision[0.01].after[.]>%<&e> to level: <&a><[Lvl].add[1]>"
        - define TotalExperience "<&e>Total Experience<&6>: <&a><[TotalExp]>"

        - narrate "<[SkillLevel]> <&b>| <[TotalExperience]>"
        - narrate <[Progress]>
