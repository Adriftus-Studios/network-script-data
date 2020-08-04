DeathTop_Hiscores_Command:
    type: command
    name: deathtop
    debug: false
    description: Checks the deathtop highscores
    usage: /deathtop <&lt>Skill/Total<&gt>
    permission: Behr.Skill.Deathtop
    tab complete:
        - define arg1 <list[Deaths]>
        - inject OneArg_Command_Tabcomplete Instantly
    script:
      # % Verify args
        - if !<list[0|1].contains[<context.args.size>]>:
            - inject Command_Syntax Instantly

        - define Players <server.players>
        - define PlayersOrdered <[Players].filter[statistic[deaths].is[!=].to[0]].sort_by_number[statistic[deaths]].reverse>
        - define PlayerGet <[PlayersOrdered].first.to[8]>
        - narrate "<&2>+<&a>-------<&6>[<&e> Hiscores <&6>] <&b>| <&6>[<&e> Deaths <&6>]<&a>-------<&2>+"
        - foreach <[PlayerGet]> as:Player:
            - narrate "<proc[User_Display_Simple].context[<[Player]>]> <&b>| <&e> Deaths<&6>: <&a><[Player].statistic[deaths]>"
