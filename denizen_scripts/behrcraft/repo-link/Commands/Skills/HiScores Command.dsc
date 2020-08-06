Hiscores_Command:
    type: command
    name: hiscores
    debug: false
    description: Checks the hiscores
    usage: /hiscores <&lt>Skill/Total<&gt>
    permission: behrry.skill.hiscores
    tab complete:
        - define arg1 <list[Attack|Strength|Defense|Hitpoints|Ranged|Mining|Woodcutting|Farming|Construction]>
        #- inject OneArg_Command_Tabcomplete Instantly
        - determine <proc[OneArg_Command_Tabcomplete].context[1|<[Arg1].escaped>]>
    script:
    # % ██ [ Verify args ] ██
        - if <context.args.size||0> > 1:
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

        - define Players <server.players_flagged[behrry.skill.<[Skill]>.Level]>
        - define PlayersOrdered <[Players].sort_by_number[flag[behrry.skill.<[Skill]>.Level]].reverse>
        - define PlayerGet <[PlayersOrdered].first.to[8]>
        - narrate "<&2>+<&a>-------<&6>[<&e> hiscores <&6>] <&b>| <&6>[<&e> <[Skill]> <&6>]<&a>-------<&2>+"
        - foreach <[PlayerGet]> as:Player:
            - narrate "<proc[User_Display_Simple].context[<[Player]>]> <&b>| <&e> Level<&6>: <&a><[Player].flag[behrry.skill.<[Skill]>.Level]> <&b>| <&e> Exp<&6>: <&a><[Player].flag[behrry.skill.<[Skill]>.Exp].round>"
