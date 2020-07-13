Script_Dependency_Support_DCommand:
    type: task
    PermissionRoles:
# - ██ [ Staff Roles  ] ██
        - Development Team
        - Lead Developer
        - External Developer
        - Developer

# - ██ [ Public Roles ] ██
        - Development Team
        - Lead Developer
        - Developer
        - Developer In Training
    definitions: Message|Channel|Author|Group
    debug: true
    speed: 0
    script:
# - ██ [ Clean Definitions & Inject Dependencies ] ██
        - inject Role_Verification
        - inject Command_Arg_Registry
        
# - ██ [ Verify Arguments                        ] ██
        - if <[Args].size> == 0:
            - define Args <[Args].include[Help]>

# - ██ [ Submit Message                          ] ██
        - choose <[Args].first>:
            - case help:
                - if <[Args].size> == 1 || <[Args].size> > 2:
                    - define Data <yaml[SDS_Help].to_json>
                - else if <list[eg|example|ex|use|usage].contains[<[Args].get[2]>]>:
                    - define Data <yaml[SDS_Help_Example].to_json>
            - case msghover msghov hovermsg onhover hoverover messagehover messagehov hovermessage:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgHover].to_json>
            - case msgcmd messagecmd msgcommand messagecommand cmdmsg cmdmessage commandmsg commandmessage:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgCmd].to_json>
            - case msgchat messagechat chatmessage chatmsg:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_msgchat].to_json>

            - case CmdHint cmdhnt commandhnt commandhint hintcommand hntcommand hntcmd hintcmd:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_CmdHint].to_json>
            - case MsgHint messagehint messagehnt hntmessage hintmessage hintmsg:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgHint].to_json>
            - case MsgURL messageurl messagelink msglink linkmsg linkmessage urlmessage urlmsg:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgURL].to_json>
            - case Msghvrins Msghvrinsert Msghoverins Msghoverinsert messagehvrins messagehvrinsert messagehoverins messagehoverinsert hvrmsgins hvrmessageins hvrmsginsert hvrmessageinsert hovermsgins hovermessageins hovermsginsert hovermessageinsert inshvrmsg inshovermsg inshvrmessage inshovermessage inserthvrmsg inserthovermsg inserthvrmessage inserthovermessage:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgHoverIns].to_json>
            - case Msgcmdins Msgcmdinsert Msg commandins Msg commandinsert messagecmdins messagecmdinsert message commandins message commandinsert cmdmsgins cmdmessageins cmdmsginsert cmdmessageinsert  commandmsgins  commandmessageins  commandmsginsert  commandmessageinsert inscmdmsg ins commandmsg inscmdmessage ins commandmessage insertcmdmsg insert commandmsg insertcmdmessage insert commandmessage:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgCmdIns].to_json>
            - case msg cmdhintins msg cmdinshint msghint cmdins msghintins cmd msgins cmdhint msginshint cmd  cmdmsghintins  cmdmsginshint  cmdhintmsgins  cmdhintinsmsg  cmdinsmsghint  cmdinshintmsg hintmsg cmdins hintmsgins cmd hint cmdmsgins hint cmdinsmsg hintinsmsg cmd hintins cmdmsg insmsg cmdhint insmsghint cmd ins cmdmsghint ins cmdhintmsg inshintmsg cmd inshint cmdmsg:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgCmdHintIns].to_json>
            - case msgchathintins msgchatinshint msghintchatins msghintinschat msginschathint msginshintchat chatmsghintins chatmsginshint chathintmsgins chathintinsmsg chatinsmsghint chatinshintmsg hintmsgchatins hintmsginschat hintchatmsgins hintchatinsmsg hintinsmsgchat hintinschatmsg insmsgchathint insmsghintchat inschatmsghint inschathintmsg inshintmsgchat inshintchatmsg:
                - if <[Args].size> == 1:
                    - define Data <yaml[SDS_MsgChatHintIns].to_json>
        #^  - case default:
        #^      - if <[Args].size> == 1:
        #^          - define Data <yaml[SDS_default].to_json>
            - default:
                - stop

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
                #- run Embedded_Discord_Message_New defs:<[Definitions]>


