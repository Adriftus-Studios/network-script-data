ExperienceAdjust_Command:
    type: command
    name: experienceadjust
    debug: false
    description: Changes your attack style.
    usage: /experience <&lt>Player<&gt> <&lt>Skill<&gt> <&lt>Set/Add/Reset<&gt> <&lt>#<&gt>
    permission: behrry.skill.experienceadjust
    script:
        - if <context.args.size||0> != 4:
            - if <context.args.get[3]||null> != reset || <context.args.size||0> != 3:
                - inject Command_Syntax Instantly
        - define User <context.args.first||null>
        - inject Player_Verification_Offline Instantly

        - define Skills <list[Attack|Strength|Defense|Hitpoints|Ranged|Mining|Woodcutting|Farming|Construction]>
        - define Skill <context.args.get[2]||null>
        - if !<[Skills].contains[<[Skill]>]>:
            - inject Command_Syntax Instantly

        - define XP <context.args.get[4]||null>
        - if !<[XP].is_integer>:
            - inject Command_Syntax Instantly
        - if <[XP].contains[.]>:
            - inject Command_Syntax Instantly
        - if <[XP]> < 0:
            - inject Command_Syntax Instantly
        - if <[XP]> > 200000000:
            - inject Command_Syntax Instantly

        - choose <context.args.get[3]||null>:
            - case Set:
                - flag <[User]> behrry.skill.<[Skill]>.Level:1
                - flag <[User]> behrry.skill.<[Skill]>.ExpReq:0
                - run add_xp_nostring def:<[XP]>|<[Skill]>|<[User]>
                - flag <[User]> behrry.skill.<[Skill]>.Exp:<[XP]>
            - case Add:
                - define PXP <[User].flag[behrry.skill.<[Skill]>.Exp].add[<[XP]>]||<[XP]>>
                - run add_xp_nostring def:<[XP]>|<[Skill]>|<[User]>
                - flag <[User]> behrry.skill.<[Skill]>.Exp:<[PXP]>
            - case Reset:
                - flag <[User]> behrry.skill.<[Skill]>.Exp:0
                - flag <[User]> behrry.skill.<[Skill]>.Level:1
                - flag <[User]> behrry.skill.<[Skill]>.ExpReq:0
            - case default:
                - inject Command_Syntax Instantly
