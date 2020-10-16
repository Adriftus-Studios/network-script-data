            
Dialogue_Command:
    type: command
    name: dialogue
    debug: false
    description: Selects a dialogue option
    usage: /dialogue <&lt>#<&gt>
    permission: Behrry.Interaction.Dialogue
    aliases:
        - d
    script:
    # % ██ [ Check if Option Selection is active   ] ██
        - if !<player.has_flag[Behrry.Interaction.ActiveOptions]>:
            - stop

    # % ██ [ Define Definitions                    ] ██
        - define Options <player.flag[Behrry.Interaction.ActiveOptions]>
        - define OptionsFiltered <[Options].filter[split[/].get[3].contains_any[<player.flag[Behrry.Interaction.ActiveNPC]>]]>
        - define OptionChoice <context.args.first>

    # % ██ [ Check if Player ran command directly  ] ██
        - if <context.args.size> == 1:
        # % ██ [ Check if Option Choice is valid       ] ██
            - if !<[OptionsFiltered].parse[before[/]].contains[<[OptionChoice]>]>:
                - stop
            - define SelectedOption <[OptionsFiltered].map_get[<[OptionChoice]>].split[/]>

    # % ██ [ Check if Chat Click option is valid ] ██
        - else if <context.args.get[2].length> == 36 && <context.args.size> == 5:
        # % ██ [ Check if UUID is valid                ] ██
            - define UUID <context.args.get[2]>
            - if !<[OptionsFiltered].parse[after[/].before[/]].contains[<[UUID]>]>:
                - stop
            - define SelectedOption <[OptionsFiltered].map_get[<[OptionChoice]>].split[/]>
        - else:
            - inject Command_Syntax Instantly
        
    # % ██ [ Define remaining Definitions, set flags ] ██
        - define ASS <[SelectedOption].get[2]>
        - define SEL <[SelectedOption].get[3]>
        - define NPC <[SelectedOption].get[4]>
        - flag player Behrry.Interaction.OptionsCooldown:|:<[ASS]>/<[SEL]> duration:30s
        - flag player Behrry.Interaction.ActiveOptions:!|:<[Options].exclude[<[OptionsFiltered]>]>
        - define ID <player.uuid>/<[NPC].script.name>/<[NPC].id>

    # % ██ [ Initiate Interaction ] ██
        - playsound <player> BLOCK_STONE_BUTTON_CLICK_ON
        - inject <[ASS].as_script> path:Selections.<[SEL]> npc:<[NPC]>

DisguiseFix:
    type: world
    events:
        on d command bukkit_priority:lowest:
            - determine passively fulfilled
            - inject Dialogue_Command Instantly
