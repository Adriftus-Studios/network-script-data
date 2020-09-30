Bawb:
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
            - narrate format:npc "Well Howdy there! Lookin' for some Meeseeks?"
            - wait 2s
            - run NPC_Interaction ID:<[ID]> def:o1
        QuickClick: SelectionThree
    Selections:
        QuickSelectOption:
            - narrate format:npc "This is the quick select script."
        # | ██  [ Selection 01 ] ██
        SelectionOne:
            - narrate format:npc "Capitalism at it's finest! These creatures can't survive without constant attention from other people"
            - wait 3s
            - narrate format:npc "They aren't born into this world fumbing for meaning, <player.name>!"
            - wait 3s
            - narrate format:npc "They're created to serve a singular purpose, for which they will go to ANY length to fulfil!"
            - wait 3s
            - narrate format:npc "I've personally been tweaking the Meeseeks to stick around a bit longer, as they don't seem to have any kind of interest in existance..."
            - wait 4s
            - narrate format:npc "But don't let that worry you! They'll be fine with the anti-depressants I've stuffed them up with!"
            - wait 3s
            - run NPC_Interaction ID:<[ID]> def:o2
        SelectionTwo:
            - narrate format:npc "You're here at my house! At least I think I live here?"
            - wait 2s
            - narrate format:npc "Of course I live here! You're at my house, ooowwweee!"
            - wait 2s
            - run NPC_Interaction ID:<[ID]> def:o1
        SelectionThree:
            - run BawbShop def:Action/MainMenu
        SelectionFour:
            - narrate format:npc "Alright, I'll be around if you change your mind!"
            - inject NPC_Interaction path:Disengage
        # | ██  [ Selection 02 ] ██
        SelectionFive:
            - narrate format:npc "Only the finest drugs for the finest workers! So, you wanna trade?"
            - wait 2s
            - run NPC_Interaction ID:<[ID]> def:o1
        SelectionSix:
            - narrate format:npc "Something like that - trust me, they're fine with it! So, you wanna trade?"
            - wait 2s
            - run NPC_Interaction ID:<[ID]> def:o1
    Options:
        o1:
            - "SelectionOne/What's a 'Meeseeks'?"
            - "SelectionTwo/Where are we?"
            - SelectionThree/Yes
            - SelectionFour/No
        o2:
            - SelectionFive/Anti-depressants?
            - "SelectionSix/What did they do before the 'tweak'? explode?"
