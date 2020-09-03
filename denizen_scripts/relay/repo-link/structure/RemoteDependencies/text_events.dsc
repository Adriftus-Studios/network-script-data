# @ ███████████████████████████████████████████████████████████
# @ ██    Standard 2 & 3 Step Chat Events |
# @ ██
# $ ██  [ Message Hover ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - narrate "<proc[MsgHover].context[<[Hover]>|<[Text]>]>"
MsgHover:
    type: procedure
    debug: false
    definitions: Hover|Text
    script:
        - determine <&hover[<[Hover].unescaped>]><[Text].unescaped><&end_hover>
HoverMsg:
    type: procedure
    debug: false
    definitions: Hover|Text
    script:
        - determine <&hover[<[Hover].unescaped>]><[Text].unescaped><&end_hover>



# $ ██  [ Message Command ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "help"
# - ██  [       ] - narrate "<proc[MsgChat].context[<[Hover]>|<[Text]>|<[Command]>]>"
MsgCmd:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>]><[Text].unescaped><&end_click><&end_hover>



# $ ██  [ Message Chat ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Chat "Text a player's forced to speak"
# - ██  [       ] - narrate "<proc[MsgChat].context[<[Hover]>|<[Text]>|<[Chat]>]>"
MsgChat:
    type: procedure
    debug: false
    definitions: Hover|Text|Chat
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[<[Command]>]><[Text].unescaped><&end_click><&end_hover>



# $ ██  [ Command Hint ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "help"
# - ██  [       ] - narrate "<proc[CmdHint].context[<[Hover]>|<[Text]>|<[Command]>]>"
CmdHint:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>].type[suggest_command]><[Text].unescaped><&end_click><&end_hover>



# $ ██  [ Message Hint ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Hint "help"
# - ██  [       ] - narrate "<proc[MsgHint].context[<[Hover]>|<[Text]>|<[Hint]>]>"
MsgHint:
    type: procedure
    debug: false
    definitions: Hover|Text|Command
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>].type[suggest_command]><[Text].unescaped><&end_click><&end_hover>



# $ ██  [ Message URL ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define URL "http://banditcraft.pro"
# - ██  [       ] - narrate "<proc[MsgURL].context[<[Hover]>|<[Text]>|<[URL]>]>"
MsgURL:
    type: procedure
    debug: false
    definitions: Hover|Text|URL
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[<[URL]>].type[OPEN_URL]><[Text].unescaped><&end_click><&end_hover>





# @ ███████████████████████████████████████████████████████████
# @ ██    Standard 3+ Chat Events | + Insert
# @ ██
# $ ██  [ Message Hover Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Insert "Text inserted into chat"
# - ██  [       ] - narrate "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>"
MsgHoverIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Insert
    script:
        - determine <&hover[<[Hover]>]><&insertion[<[Insert]>]><[Text]><&end_insertion><&end_hover>



# $ ██  [ Message Command Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "Text inserted into chat"
# - ██  [       ] - define Insert "help"
# - ██  [       ] - narrate "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Command]>|<[Insert]>]>"
MsgCmdIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>]><&insertion[<[Insert].unescaped>]><[Text].unescaped><&end_insertion><&end_click><&end_hover>



# $ ██  [ Message Command Hint Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "Text inserted into chat"
# - ██  [       ] - define Insert "help"
# - ██  [       ] - narrate "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Command]>|<[Insert]>]>"
MsgCmdHintIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>].type[suggest_command]><&insertion[<[Insert].unescaped>]><[Text].unescaped><&end_insertion><&end_click><&end_hover>



# $ ██  [ Message Chat Hint Insert ] ██
# - ██  [ Usage ] - define Hover "Text in hoverbox"
# - ██  [       ] - define Text "Text in chat"
# - ██  [       ] - define Command "Text inserted into chat"
# - ██  [       ] - define Insert "help"
# - ██  [       ] - narrate "<proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Command]>|<[Insert]>]>"
MsgChatHintIns:
    type: procedure
    debug: false
    definitions: Hover|Text|Command|Insert
    script:
        - determine <&hover[<[Hover].unescaped>]><&click[/<[Command]>].type[suggest_command]><&insertion[<[Insert].unescaped>]><[Text].unescaped><&end_insertion><&end_click><&end_hover>

