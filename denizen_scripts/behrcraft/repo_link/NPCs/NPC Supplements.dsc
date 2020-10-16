#NPC_Interaction:
#    type: task
#    debug: true
#    definitions: ID|Option|DeDupe
#    # % ██ [ Give the player a period of time to cancel out option with QuickClick ] ██
#        - wait 2s
#
#
#    # % ██ [ Define Definitions ] ██
#        - define NPC <npc[<queue.id.after_last[/]>]>
#        - define Options <npc.script.data_key[Options.<[Option]>]>

NPC_Interaction:
    type: task
    debug: false
    definitions: Option|DeDupe
    script:
    # % ██ [ Give the player a period of time to cancel out option with QuickClick ] ██
        - wait 2s
    # % ██ [ Check if forcibly removing an option, or set of options, from the cooldown ] ██
        - if <[DeDupe]||null> != null:
            - foreach <[Dedupe].unescaped.as_list> as:Selection:
                - flag player Behrry.Interaction.OptionsCooldown:<-:<queue.split[/].get[2].as_script.name>/<[Selection]>
        
    # % ██ [ Define Definitions ] ██
        - define NPC <npc[<queue.id.after_last[/]>]>
        - define Options <npc.script.data_key[Options.<[Option]>]>

    # % ██ [ Construct Options Chat ] ██
        - foreach <[Options]> as:Option:
        # % ██ [ Check if player has options on cooldown                 ] ██
            - if <player.has_flag[Behrry.Interaction.OptionsCooldown]>:
            # % ██ [ Check if options on cooldown are:                   ] ██
            # % ██ [ This queue's relevant NPC                           ] ██
            # % ██ [ Any of the listed options                           ] ██
                - if <player.flag[Behrry.Interaction.OptionsCooldown].parse[before[/]].contains[<queue.split[/].get[2].as_script.name>]> && <player.flag[Behrry.Interaction.OptionsCooldown].parse[after[/]].contains[<[Option].split[/].limit[2].first>]>:
                    - foreach next

        # % ██ [ Define Hover and Text Messages                          ] ██
            - define Hover0 "<&6>[<&e>Insert<&6>]<&3> Select Dialogue with chat"
            - define Message0 <&3>[<&b><[Loop_Index]><&3>]
            - define Command0 "d <[Loop_Index]>"
            - define Hover1 "<&6>[<&e>Select<&6>]<&a> <[Option].split[/].limit[2].get[2]>"
            - define Message1 "<&6>[<&e>Click<&6>]<&a> <[Option].split[/].limit[2].get[2]>"

        # % ██ [ Build Commands and Flags                                ] ██
            - define UUID <util.random.uuid>
        # % ██ [ / Loop_Index / UUID / Script Name / Selection / NPC     ] ██
            - define Command1 "dialogue <[Loop_Index]> <[UUID]> <queue.split[/].get[2]> <[Option].split[/].limit[2].first> <[NPC]>"
            - flag Behrry.Interaction.ActiveOptions:|:<[Loop_Index]>/<[UUID]>/<queue.split[/].get[2]>/<[Option].split[/].limit[2].first>/<[NPC]> duration:10s

        # % ██ [ Print Messages                                          ] ██
            - narrate <proc[msg_hint].context[<[Hover0]>|<[Message0]>|<[Command0]>]><proc[msg_cmd].context[<[Hover1]>|<[Message1]>|<[Command1]>]>
    Disengage:
    # % ██ [ Check if player is talking to NPCs                          ] ██
        - if <player.has_flag[Behrry.Interaction.ActiveNPC]>:
        # % ██ [ Check if player is talking with This NPC                ] ██
            - if <player.flag[Behrry.Interaction.ActiveNPC].contains[<queue.script.name>]>:
                - flag player Behrry.Interaction.ActiveNPC:<-:<queue.script.name>
            # % ██ [ Check if player has Active Options with this NPC    ] ██
                - if <player.has_flag[Behrry.Interaction.ActiveOptions]>:
                    - flag player Behrry.Interaction.ActiveOptions:!

    # % ██ [ Remove Options from this NPC if disengaging                 ] ██
        - if <player.has_flag[Behrry.Interaction.ActiveOptions]>:
            - define Options <player.flag[Behrry.Interaction.ActiveOptions]>
            - define OptionsFiltered <[Options].filter[split[/].get[3].contains_any[<player.flag[Behrry.Interaction.ActiveNPC]>]]>
            - flag player Behrry.Interaction.ActiveOptions:!|:<[Options].exclude[<[OptionsFiltered]>]>
            - flag player Behrry.Interaction.OptionsCooldown:!
            - stop
    Assignment:
    # % ██ [ Enable triggers                                             ] ██
        - trigger name:damage state:true
        - trigger name:click state:true
        - trigger name:proximity state:true radius:4

    # % ██ [ Check for saved skins                                       ] ██
        - if <server.has_flag[Behrry.Meeseeks.Skin.<queue.script.name>]>:
            - adjust <npc> skin_blob:<server.flag[Behrry.Meeseeks.Skin.<queue.script.name>]>
        - else:
            - narrate "<proc[Colorize].context[No NPC skin saved for:|red]> <&6>'<&e><queue.script.name><&6>'"

    Exit:
        - inject Locally Disengage Instantly
    Click:
    # % ██ [ QuickClick mechanic                                         ] ██
        - if <player.has_flag[Behrry.Interaction.ActiveNPC]>:
            - if <player.flag[Behrry.Interaction.ActiveNPC].contains[<queue.script.name>]> && <queue.script.list_keys[Dialogue].contains[QuickClick]> && <player.has_flag[Behrry.Interaction.QuickClick]> && <player.has_flag[Behrry.Interaction.Cooldown.ClickTrigger]>:
                - if <player.has_flag[Behrry.Interaction.Cooldown.QuickClickTrigger]>:
                    - stop
                - if <queue.list.contains[<player.flag[Behrry.Interaction.QuickClick].as_queue||null>]>:
                    - queue <player.flag[Behrry.Interaction.QuickClick].as_queue> stop
                    - flag player Behrry.Interaction.QuickClick:!
                - flag player Behrry.Interaction.Cooldown.QuickClickTrigger duration:2s
                - inject <queue.script> path:Selections.<queue.script.data_key[Dialogue.QuickClick]>
                - inject Locally Disengage Instantly
            - if <queue.script.list_keys[Dialogue].contains[QuickClick]>:
                - flag player Behrry.Interaction.QuickClick:<queue> duration:2s

    # % ██ [ Check if player has a Quick-Chat option available           ] ██
        - if !<player.has_flag[Behrry.Interaction.ActiveNPC]>:
            - flag player Behrry.Interaction.ActiveNPC:->:<queue.script.name>
        - else if !<player.flag[Behrry.Interaction.ActiveNPC].contains[<queue.script.name>]>:
            - flag player Behrry.Interaction.ActiveNPC:->:<queue.script.name>
                
    # % ██ [ Manual Click Trigger Cooldown                           [1] ] ██
    # % ██ | This is so we can have two separately timed checks          | ██
    # % ██ | One for regular chatter, and one for initiating QuickClicks | ██
        - if <player.has_flag[Behrry.Interaction.Cooldown.ClickTrigger]>:
            - stop

    # % ██ [ Recursive Option Queue Cancel                               ] ██
        - foreach <queue.list.filter[contains[<player.uuid>]]> as:Queue:
            - queue <[Queue]> Stop

    # % ██ [ Run generic dialogue                                        ] ██
        - flag player Behrry.Interaction.ActiveOptions:!
        - flag player Behrry.Interaction.OptionsCooldown:!
        - flag player Behrry.Interaction.Cooldown.ClickTrigger duration:2s
        - define ID <player.uuid>/<queue.script.name>/<npc.id>
        - inject <queue.script> path:Dialogue.Generic

Interaction_Handlers:
    type: world
    debug: false
    events:
        on player logs out:
        - inject NPC_Interaction path:Disengage Instantly
