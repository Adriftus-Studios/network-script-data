Banker:
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
            - if <player.has_flag[GrandExchange.collection.alert]>:
                - narrate format:npc "Good day. Before we go any further, I should inform you that you have items ready for collection from the Grand Exchange. How may i help you?"
            - else:
                - narrate format:npc "Good day. How may I help you?"
            - run NPC_Interaction ID:<[ID]> def:o1
        QuickClick: Access
    Selections:
        # | ██  [ Selection 01 ] ██
        Access:
            - run open_bank instantly
        Pin:
            - narrate format:npc "The banking PIN security system currently is not implented it appears actually, sorry. Please try again later."
            - run NPC_Interaction ID:<[ID]> def:o1
        Collection:
            - narrate format:npc "The Grand Exchange currently is not implented it appears actually, sorry. Please try again later."
            - run NPC_Interaction ID:<[ID]> def:o1
        Location:
            - narrate format:npc "this is a branch of the bank of Runescape. We have branches in many towns."
            - run NPC_Interaction ID:<[ID]> def:o2

        # | ██  [ Selection 02 ] ██
        What:
            - narrate format:npc "We will look after your items and money for you. Leave your valuables with us if you want to keep them safe."
            - run NPC_Interaction ID:<[ID]> def:o1
        Location2:
            - narrate format:npc "Yes we did, but people kept on coming into our branches outside of Varrock and telling us that our signs were wrong. They acted as if we didn't know what town we were in or something."
            - run NPC_Interaction ID:<[ID]> def:o1
    Options:
        Dialogue:
            - run NPC_Interaction Instantly def:<[1]>|<script.name>
        o1:
            - "Access/I'd like to access my bank account, please"
            - "Pin/I'd like to check my pin settings"
            - "Collection/I'd like to see my collection box"
            - "Location/What is this place?"
        o2:
            - "What/And what do you do?"
            - "Location2/didn't you used to be called the Bank of Varrock?"



# | ███████████████████████████████████████████████████████████
# | ██        Open Bank Task
# % ██        - run open_bank (def:#) instantly
# % ██        - run open_bank_admin [def:#|player] instantly
# | ██
# % ██    [ Player Bank ] ██
Open_Bank:
    type: task
    debug: false
    definitions: BankID
    script:
        - define BankID <[BankID]||1>
        - define pBank <player.uuid>pBank_<[BankID]>
        - define slots1 <[BankID].sub[1].mul[45].add[1]>
        - define slots2 <[BankID].sub[1].mul[45].add[45]>
        - define title "Bank|Items <[slots1]>-<[slots2]>/450"
        - note <inventory[generic[title=<[title]>;size=54]]> as:<[pBank]>
        - define items <yaml[pBankKey].read[<player.uuid>.<[BankID]>]||null>
        - if <[BankID]> > 1:
            - define LeftArrow <item[LastPageArrow].with[nbt=BankID/<[BankID].sub[1]>]>
        - else:
            - define LeftArrow Blank
        - if <[bankID]> == 10:
            - define RightArrow Blank
        - else:
            - define RightArrow <item[NextPageArrow].with[nbt=BankID/<[BankID].add[1]>]>
        - define SoftMenu <list[<[LeftArrow]>|Blank|Blank|Blank|Blank|Deposit_All|equipment_slot|Deposit_Equipement|<[RightArrow]>]>
        - inventory set d:<[pBank]> o:<[SoftMenu]> slot:46
        - if <[items]> != null:
            - inventory set d:<[pBank]> o:<[items]>
        - inventory open d:<[pBank]>

# | ██    [ Admin Bank ] ██
Open_Bank_Admin:
    type: task
    debug: false
    definitions: BankID|Player
    ErrorObjection:
        - define key "<&4>invalid character<&co><&nl><&c><[Player]||null>"
        - narrate format:bbf "Internal error <&pipe> <&c><proc[msgHover].context[<&c>Invalid Character|<[key]>]>"
        - stop
    script:
    - define User <[Player]>
    - inject Player_Verification_Offline
    - define BankID <[BankID]||1>
    - define pBank <[User].uuid>pBank_<[BankID]>
    - define slots1 <[BankID].sub[1].mul[45].add[1]>
    - define slots2 <[BankID].sub[1].mul[45].add[45]>
    - define title "Bank<&pipe>Items <[slots1]>-<[slots2]>/450"
    - note "<inventory[generic[title=<[title]>;size=54]]> as:<[pBank]>
    - define items <yaml[pBankKey].read[<[User].uuid>.<[BankID]>]||null>
    - if <[BankID]> > 1:
        - define LeftArrow <item[LastPageArrow].with[nbt=BankID/<[BankID].sub[1]>|PlayerID/<[Player]>]>
    - else:
        - define LeftArrow Blank
    - if <[bankID]> == 10:
        - define RightArrow Blank
    - else:
        - define RightArrow <item[NextPageArrow].with[nbt=BankID/<[BankID].add[1]>|PlayerID/<[Player]>]>
    - define SoftMenu <list[<[LeftArrow]>|Blank|Blank|Blank|Blank|Blank|Deposit_All|equipment_slot|Deposit_Equipement|<[RightArrow]>]>
    - inventory set d:<[pBank]> o:<[SoftMenu]> slot:46
    - if <[items]> != null:
        - inventory set d:<[pBank]> o:<[items]>
    - inventory open d:<[pBank]>

# | ███████████████████████████████████████████████████████████
# % ██        Bank Handlers
# | ██
# % ██    [ Events ] ██
PlayerBank_Handler:
    type: world
    debug: false
    Inventory_Load:
        - if <server.has_file[data/pBank/pBankKey.yml].not>:
            - yaml create id:pBankKey
            - yaml savefile:data/pBank/pBankKey.yml id:pBankKey
        - else:
            - yaml load:data/pBank/pBankKey.yml id:pBankKey
    Inventory_Save:
        - define BankID <context.inventory.after[_]>
        - define dvlist <context.inventory.list_contents.first.to[45]>
        - yaml set id:pBankKey "<player.uuid>.<[BankID]>:<[dvlist]>"
        - yaml savefile:data/pBank/pBankKey.yml id:pBankKey
        - define id "<player.uuid>pBank_<[BankID]>"
        - note remove as:<[id]>
    events:
        on server start:
            - inject Locally Inventory_Load
        on reload scripts:
            - inject Locally Inventory_Load
        on player closes pBank*:
            - inject Locally Inventory_Save
        on player clicks blank in inventory:
            - determine cancelled
        on player clicks LastPageArrow|NextPageArrow in pBank*:
            - determine passively cancelled
            - inject locally Inventory_Save
            - run Open_Bank def:<context.item.nbt[bankid]> Instantly


# | ███████████████████████████████████████████████████████████
# % ██    /npc assignment --set Grand Exchange ClerkNPC
# | ██
# % ██  [ Assignment Script ] ██
# $ ██  [ To-Do ] | Pin Settings | Grand Exchange            ██
Grand_Exchange_Clerk:
    type: assignment
    debug: false
    actions:
        on assignment:
            - trigger name:click state:true
            - trigger name:proximity state:true radius:4
            - trigger name:chat state:true
            - if <server.has_flag[npc.skin.<script.name>]>:
                - adjust <npc> skin_blob:<server.flag[npc.skin.<script.name>]>
            - else:
                - narrate "<proc[Colorize].context[No NPC skin saved for:|red]> <&6>'<&e><script.name><&6>'"
        on exit proximity:
            - if <player.flag[interacting_npc]||> == <script.name>:
                - flag player interacting_npc:!
                - if <script[<script.name>_Interact].step[<player>]> != Normal:
                        - zap "Grand Exchange Clerk_Interact" Normal
        on click:
            - if <player.flag[interacting_npc]||> != <script.name>:
                - flag player interacting_npc:<script.name>
            - narrate format:npc "Welcome to the Grand Exchange. Would you like to trade now, or exchange item sets?
            - inject locally GenericGreeting Instantly
    GenericGreeting:
        - wait 2s
        #|How do I use the Grand Exchange?
        #|I'd like to set up trade offers please.
        #|Can you help me with item sets?
        #|I'd like Exchange collection reminders on login, please.
        #|I'm fine, thanks.
        - define Options_List "<list[How do I use the Grand Exchange?|I'd like to set up trade offers please.|Can you help me with item sets?|I'd like Exchange collection reminders on login, please.|I'm fine, thanks.]>"
        - define Trigger_List <list[How|Trade|Sets|Reminder|Bye]>
        - if <script[<script.name>_Interact].step[<player>]> != Normal:
            - zap "Grand Exchange Clerk_Interact" Normal
        - inject Trigger_Option_builder Instantly
    interact scripts:
        - Grand_Exchange_Clerk_Interact

# | ██  [ Grand Exchange Clerk Interact Script ] ██
Grand_Exchange_Clerk_Interact:
    type: interact
    debug: false
    speed: 0
    steps:
        Normal*:
            chat trigger:
                Bank:
                    trigger: hi
                    hide trigger message: true
                    script:
                    - narrate format:npc "hi"
                    - wait 2s
                    - define Options_List "<list[And what do you do?|didn't you used to be called the Bank of Varrock?]>"
                    - define Trigger_List "<list[what|Varrock]>"


npctest:
    type: assignment
    actions:
        on assignment:
            - trigger name:click state:true
        on click:
            - inject tasktwo path:2 Instantly
        

tasktwo:
    type: task
    script:
        - narrate t
    2:
        - wait 2s
        - narrate <queue.script.name>
