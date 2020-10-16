# @ ███████████████████████████████████████████████████████████
# @ ██    Standard 2 & 3 Step Chat Events |
# @ ██
# $ ██  [ Message Hover ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
msg_hover:
    type: procedure
    debug: false
    definitions: Hover|Text
    script:
        - determine <&hover[<[Hover]>]><[Text]><&end_hover>



# $ ██  [ Message Command ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command help
# - ██  [       ] - narrate <proc[msg_chat].context[<[Hover]>|<[Text]>|<[Command]>]>
msg_cmd:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
        - determine <&hover[<[Hover]>]><&click[/<[Command]>]><[Text]><&end_click><&end_hover>



# $ ██  [ Message Chat ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Chat "Text a player's forced to speak"
# - ██  [       ] - narrate <proc[msg_chat].context[<[Hover]>|<[Text]>|<[Chat]>]>
msg_chat:
    type: procedure
    debug: false
    definitions: Hover|Text|Chat
    script:
        - determine <&hover[<[Hover]>]><&click[<[Command]>]><[Text]><&end_click><&end_hover>



# $ ██  [ Command Hint ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command help
# - ██  [       ] - narrate <proc[cmd_hint].context[<[Hover]>|<[Text]>|<[Command]>]>
cmd_hint:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
        - determine <&hover[<[Hover]>]><&click[/<[Command]>].type[suggest_command]><[Text]><&end_click><&end_hover>



# $ ██  [ Message Hint ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Hint help
# - ██  [       ] - narrate <proc[msg_hint].context[<[Hover]>|<[Text]>|<[Hint]>]>
msg_hint:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
        - determine <&hover[<[Hover]>]><&click[/<[Command]>].type[suggest_command]><[Text]><&end_click><&end_hover>



# $ ██  [ Message URL ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define URL http://banditcraft.pro
# - ██  [       ] - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
msg_url:
    type: procedure
    debug: false
    definitions: Hover|Text|URL
    script:
        - determine <&hover[<[Hover]>]><&click[<[URL]>].type[OPEN_URL]><[Text]><&end_click><&end_hover>



# $ ██  [ Message Script ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Script script_name
# - ██  [       ] - narrate <proc[msg_script].context[<[Hover]>|<[Text]>|<[Script]>]>
msg_script:
    type: procedure
    debug: false
    definitions: hover|text|script
    script:
        - clickable <[script]> save:script
        - determine <element[<&hover[<[hover]>]><[text]><&end_hover>].on_click[<entry[script].command>]>



# @ ███████████████████████████████████████████████████████████
# @ ██    Standard 3+ Chat Events | + Insert
# @ ██
# $ ██  [ Message Hover Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Insert "Text inserted into chat"
# - ██  [       ] - narrate <proc[msg_hover_ins].context[<[Hover]>|<[Text]>|<[Insert]>]>
msg_hover_ins:
    type: procedure
    debug: false
    definitions: Hover|Text|Insert
    script:
        - determine <&hover[<[Hover]>]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_hover>



# $ ██  [ Message Command Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "Text inserted into chat"
# - ██  [       ] - define Insert help
# - ██  [       ] - narrate <proc[msg_hover_ins].context[<[Hover]>|<[Text]>|<[Command]>|<[Insert]>]>
msg_cmd_ins:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
        - determine <&hover[<[Hover]>]><&click[/<[Command]>]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_click><&end_hover>



# $ ██  [ Message Command Hint Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "Text inserted into chat"
# - ██  [       ] - define Insert help
# - ██  [       ] - narrate <proc[msg_hover_ins].context[<[Hover]>|<[Text]>|<[Command]>|<[Insert]>]>
msg_cmd_hint_ins:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
        - determine <&hover[<[Hover]>]><&click[/<[Command]>].type[suggest_command]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_click><&end_hover>



# $ ██  [ Message Chat Hint Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "Text inserted into chat"
# - ██  [       ] - define Insert help
# - ██  [       ] - narrate <proc[msg_hover_ins].context[<[Hover]>|<[Text]>|<[Command]>|<[Insert]>]>
msg_chat_hint_ins:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
        - determine <&hover[<[Hover]>]><&click[/<[Command]>].type[suggest_command]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_click><&end_hover>
