Farming_Handler:
    type: world
    debug: false
    ExpGet:
        - if !<player.has_flag[Behrry.skill.Farming.cd]>:
            - flag player Behrry.skill.Farming.cd:+:<[XP]> duration:2s
            - while true:
                - wait 2s
                - if <player.has_flag[Behrry.skill.Farming.cd]>:
                    - define XP:<player.flag[Behrry.skill.Farming.cd]>
                    - while next
                - run add_xp def:<[XP]>|Farming instantly
                - while stop
        - else:
            - flag player Behrry.skill.Farming.cd:+:<[XP]> duration:2s

    events:
        on player clicks sweet_berry_bush:
        # % ██ [ Check for bonemeal ] ██
            - if <context.item> == bone_meal:
                - define XP 1
            - else:
                - if <context.location.material.age> > 2:
                    - define XP <context.location.material.age>
                - else:
                    - stop

        # % ██ [ Check for Cooldown ] ██
            - if <player.flag[Behrry.skill.exp.cd]||0> < 75:
                - flag player behrry.skill.exp.cd:+:<[XP]> duration:1s
            - else:
                - stop

            - inject Locally ExpGet Instantly

        on player breaks beetroots:
       # % ██ [ Check for bonemeal ] ██
        #^ - if <context.item> == bone_meal:
        #^     - define XP 1
        #^ - else:
            - if <context.location.material.age> > 2:
                - define XP <context.location.material.age>
            - else:
                - stop

        # % ██ [ Check for Cooldown ] ██
            - if <player.flag[Behrry.skill.exp.cd]||0> < 75:
                - flag player behrry.skill.exp.cd:+:<[XP]> duration:1s
            - else:
                - stop

            - inject Locally ExpGet Instantly
        on player breaks wheat|carrots|potatoes:
            - if <context.location.material.age> > 4:
                - define XP <context.location.material.age.div[2].round_down>
            - else:
                - stop

        # % ██ [ Check for Cooldown ] ██
            - if <player.flag[Behrry.skill.exp.cd]||0> < 75:
                - flag player behrry.skill.exp.cd:+:<[XP]> duration:1s
            - else:
                - stop

            - inject Locally ExpGet Instantly
        on player places dandelion|poppy|blue_orchid|allium|azure_bluet|tulips|oxeye_daisy|cornflower|lil*|sunflower|rose_bush|peony:
            - define XP 2
            - inject Locally ExpGet Instantly
        on player places wither_rose:
            - define XP 5
            - inject Locally ExpGet Instantly
        on player breaks pumpkin|watermellon:
            - define XP 5
            - inject Locally ExpGet Instantly
        #on player clicks sugarcane|bamboo:
