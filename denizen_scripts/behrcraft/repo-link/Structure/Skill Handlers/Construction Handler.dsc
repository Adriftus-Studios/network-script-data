Construction_Handler:
    type: world
    debug: false
    ExpGet:
        - if !<player.has_flag[Behrry.skill.Construction.cd]>:
            - flag player Behrry.skill.Construction.cd:+:<[XP]> duration:2s
            - while true:
                - wait 2s
                - if <player.has_flag[Behrry.skill.Construction.cd]>:
                    - define XP:<player.flag[Behrry.skill.Construction.cd]>
                    - while next
                - run add_xp def:<[XP]>|Construction instantly
                - while stop
        - else:
            - flag player Behrry.skill.Construction.cd:+:<[XP]> duration:2s

    events:
        on player places *leaves|ladder|*_wood|*_log|dirt|clay|stone|sand|andesite|cobblestone|end_stone|granite|mossy_cobblestone|nether_bricks|sandstone|stone|diorite|gravel:
            - define XP 1
            - inject Locally ExpGet Instantly
        on player places *stairs|*slab|*_powder|*redstone*:
            - define XP 2
            - inject Locally ExpGet Instantly
        on player places *glass_pane|*banner:
            - define XP 3
            - inject Locally ExpGet Instantly
        on player places *planks|*door|*prismarine*|*fence|*trapdoor|*_terracotta|*carpet|*_wool|stripped*|*concrete_block|*bricks|*sandstone|*quartz|lapis_block|coal_block|redstone_block|polished_andesite|polished_diorite|stone_bricks|mossy_stone_bricks|obsidian:
            - define XP 5
            - inject Locally ExpGet Instantly
        on player places *_stained_glass:
            - define XP 6
            - inject Locally ExpGet Instantly
        on player places *rail|dispenser|hopper|dropper|observer:
            - define XP 10
            - inject Locally ExpGet Instantly
        on player places diamond_block|emerald_block|gold_block|iron_block|anvil:
            - define XP 15
            - inject Locally ExpGet Instantly
        on player places conduit|beacon:
            - define XP 100
            - inject Locally ExpGet Instantly
            
