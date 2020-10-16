Mining_Handler:
    type: world
    debug: false
    ExpGet:
        - if !<player.has_flag[Behrry.skill.Mining.cd]>:
            - flag player Behrry.skill.Mining.cd:+:<[XP]> duration:2s
            - while true:
                - wait 2s
                - if <player.has_flag[Behrry.skill.Mining.cd]>:
                    - define XP:<player.flag[Behrry.skill.Mining.cd]>
                    - while next
                - run add_xp def:<[XP]>|Mining instantly
                - while stop
        - else:
            - flag player Behrry.skill.Mining.cd:+:<[XP]> duration:2s

    events:
        on player breaks dirt|stone|sand|andesite|cobblestone|end_stone|granite|mossy_cobblestone|nether_bricks|sandstone|stone|diorite|gravel:
            - define XP 1
            - inject Locally ExpGet Instantly
        on player breaks iron_ore|lapis_ore|coal_ore|nether_quartz_ore|redstone_ore|gold_ore|polished_andesite|polished_diorite|stone_bricks|mossy_stone_bricks|obsidian:
            - define XP 5
            - inject Locally ExpGet Instantly
        on player breaks diamond_ore|emerald_ore:
            - define XP 15
            - inject Locally ExpGet Instantly
        on player clicks block with *pickaxe using either_hand:
            - if <player.has_flag[Behrry.Skill.Mining.Ability.PowerMining.Queued]>:
                - flag player Behrry.Skill.Mining.Ability.PowerMining.Queued:!
                - flag player Behrry.Skill.Mining.Ability.PowerMining.Cooldown duration:300s
                - narrate "<&a>Power-Mining enabled!"
                - playsound <player> BLOCK_BEACON_ACTIVATE
                - define Duration <player.flag[Behrry.Skill.Mining.Level].mul[0.25].add[10]>s
                - cast fast_digging duration:<[Duration]> power:1 no_ambient hide_particles
                - wait <[Duration]>
                - cast fast_digging remove
                - narrate "<&c>Fast Digging wore off."
                - playsound <player> BLOCK_BEACON_DEACTIVATE
                - wait 300s
                - narrate "<&a>Power-Mining ability is now refreshed."
            - else if <player.is_sneaking> && <context.click_type.contains[right]>:
                - if <player.has_flag[Behrry.Skill.Mining.Ability.PowerMining.Cooldown]>:
                    - define Cooldown <player.flag[Behrry.Skill.Mining.Ability.PowerMining.Cooldown].expiration.formatted>
                    - narrate "<&4>Power-Mining: <&c>Currently on cooldown. <&6>[<&e><[Cooldown]><&6>]"
                - else:
                    - narrate "<&e>You ready your pickaxe..."
                    - flag player Behrry.Skill.Mining.Ability.PowerMining.Queued
                    - wait 3s
                    - if <player.has_flag[Behrry.Skill.Mining.Ability.PowerMining.Queued]>:
                        - flag player Behrry.Skill.Mining.Ability.PowerMining.Queued:!
                        - narrate "<&c>You lower your pickaxe."

Ability_Command:
    type: command
    name: Ability
    permission: test
    usage: /Ability <&lt>Skill<&gt>
    description: Runs the ability lol
    script:
        - flag player Behrry.Skill.Mining.Ability.PowerMining.Cooldown:!
