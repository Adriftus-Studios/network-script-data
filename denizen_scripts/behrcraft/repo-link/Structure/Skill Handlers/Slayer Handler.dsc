Slayer_Handler:
    type: world
    debug: false
    ExpGet:
        - if !<player.has_flag[Behrry.skill.Slayer.cd]>:
            - flag player Behrry.skill.Slayer.cd:+:<[XP]> duration:2s
            - while true:
                - wait 2s
                - if <player.has_flag[Behrry.skill.Slayer.cd]>:
                    - define XP:<player.flag[Behrry.skill.Slayer.cd]>
                    - while next
                - run add_xp def:<[XP]>|Slayer instantly
                - while stop
        - else:
            - flag player Behrry.skill.Slayer.cd:+:<[XP]> duration:2s

    events:
        on player kills ender_dragon:
            - define XP 200
            - inject Locally ExpGet Instantly
            - wait 5s
            - if <util.random.int[1].to[5]> == 5:
                - modifyblock <location[0,69,0,World_The_End]> Dragon_Egg
        on player kills wither:
            - define XP 250
            - inject Locally ExpGet Instantly
