Script_Dependency_Support_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group
  debug: false
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    
  # % ██ [ Verify Arguments            ] ██
    - if <[Args].size> == 0:
      - define Args <[Args].include[Help]>

  # % ██ [ Submit Message              ] ██
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
      - case MsgCmdHintIns MsgHintCmdIns:
        - if <[Args].size> == 1:
          - define Data <yaml[SDS_MsgCmdHintIns].to_json>
      - case msgchathintins msgchatinshint msghintchatins msghintinschat msginschathint msginshintchat chatmsghintins chatmsginshint chathintmsgins chathintinsmsg chatinsmsghint chatinshintmsg hintmsgchatins hintmsginschat hintchatmsgins hintchatinsmsg hintinsmsgchat hintinschatmsg insmsgchathint insmsghintchat inschatmsghint inschathintmsg inshintmsgchat inshintchatmsg:
        - if <[Args].size> == 1:
          - define Data <yaml[SDS_MsgChatHintIns].to_json>
    #^- case default:
    #^  - if <[Args].size> == 1:
    #^    - define Data <yaml[SDS_default].to_json>
      - default:
        - stop

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
        #- run Embedded_Discord_Message_New defs:<[Definitions]>


