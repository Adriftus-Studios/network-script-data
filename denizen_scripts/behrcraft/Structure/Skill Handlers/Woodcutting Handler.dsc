Woodcutting_Handler:
    type: world
    debug: false
    ExpGet:
        - if !<player.has_flag[Behrry.skill.Woodcutting.cd]>:
            - flag player Behrry.skill.Woodcutting.cd:+:<[XP]> duration:2s
            - while true:
                - wait 2s
                - if <player.has_flag[Behrry.skill.Woodcutting.cd]>:
                    - define XP:<player.flag[Behrry.skill.Woodcutting.cd]>
                    - while next
                - run add_xp def:<[XP]>|Woodcutting instantly
                - while stop
        - else:
            - flag player Behrry.skill.Woodcutting.cd:+:<[XP]> duration:2s

    events:
        on player breaks stripped*|*_wood|*_log:
            - define XP 5
            - inject Locally ExpGet Instantly
        on player breaks *_planks:
            - define XP 10
            - inject Locally ExpGet Instantly

