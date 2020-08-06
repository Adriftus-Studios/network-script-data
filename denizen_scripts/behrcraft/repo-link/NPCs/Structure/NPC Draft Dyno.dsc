Meeseeks:
    type: assignment
    debug: false
    actions:
        on assignment:
            - inject NPC_Interaction path:Assignment
        on exit proximity:
            - inject NPC_Interaction path:Exit
        on click:
            - inject NPC_Interaction path:Click
        on damage:
            - inject NPC_Interaction path:Click
    Dialogue:
        Generic:
            - if <npc.owner> == <player>:
                - run <npc.flag[Interaction.Dialogue.Generic.Owner]>
            - else:
                - run <npc.flag[Interaction.Dialogue.Generic.Player]>
    placeholder0:
        - choose <npc.flag[Interaction.Placeholder]>:
            - case Generic:
            - case QuickClick:
            - case Selection:
            - case Option:
    Placeholder1:
        #@ Each Flag would contain each Command and the respective Arg(s)
        #%  Each Dialogue Stage would automatically insert a WAIT commbat by default;
        #%  based on the .length of the dialogue (1/1t) // (20/1s) // (40/2s)
        #@ Basis of flag setups:
        #%  ie:Interaction.Placeholder.Generic.Stage1:Dialogue/Context of the dialogue
        #%  ie:Interaction.Placeholder.Generic.Stage2:Wait/2
        #%  ie:Interaction.Placeholder.Generic.Stage3:Selection/SelectionOne
        #^- foreach <npc.flag[Interaction.Placeholder]> as:PlaceHolder:
        #^    - choose Action:
        #^        - case Dialogue:
        #^            - foreach <npc.flag[Interaction.Placeholder]>
        #^        - case Wait:
        #^            - wait <npc.flag[Interaction.Placeholder]>
        #^        - case Selection:
        #^        #^  - run NPC_Interaction ID:<[ID]> def:o1
        #^            - run NPC_Interaction ID:<[ID]> def:<npc.flag[Interaction.Placeholder]>
        #^        - case Trade:
        #^            - run TradeTask
        #^        - case OpenShop:
        #^            - run OpenShop
    DialogueStages:
        - Dialogue
        - Wait
        - Selection
        - Trade
        - OpenShop
    Tasks:
        - Fetch
        - Go-To
        - Follow
        - Stay
        - Farm
        - Mine
        - Gather
    #^  - Run (1.5)
    #^  - Walk (1.35)
