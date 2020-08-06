Message_Handler:
  type: world
  events:
    on server generates exception:
      - if <context.message> == "no value present":
        - determine cancelled
    on discord message received for:AdriftusBot:
    #^- if <context.channel.id> != <script[DDTBCTY].yaml_key[testing]>:
    #^    - stop
    # % ██ [ Queue Stopping Cache Data       ] ██
      - if <context.Author||WebHook> == WebHook:
        - stop
      - define Author <context.Author>

      - if <context.Message||WebHook> == WebHook:
        - stop
      - define Message <context.Message>

      - if <context.Bot> == <[Author]>:
        - stop
      - define Bot <context.Bot>

    # % ██ [ Cache Data                      ] ██
      - define Channel <context.Channel.id>
      - define Group <context.Group||Is_Direct>
    #^- define No_Mention_Message <context.No_Mention_Message.escaped||WebHook>
      - define Message_ID <context.Message_ID||WebHook>
    #^- define Mentions <context.Mentions||WebHook>
    #^- define Is_Direct <context.Is_Direct>

    # % ██ [ DM       Based Scripts          ] ██

    # % ██ [ @Mention Based Scripts          ] ██

    # % ██ [ Command  Based Scripts          ] ██
      - if <[Message].starts_with[/]>:
        - choose <[Message].before[<&sp>].after[/]>:
          - case reload:
            - ~Run Reload_Scripts_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case tag parse:
            - ~Run Tag_Parser_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case ex execute:
            - ~Run Ex_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case bungee:
            - ~Run Bungee_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case script sds scripthelp:
            - ~Run Script_Dependency_Support_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case check onlinestatus status online:
            - ~Run Status_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case note meetingnote meetingnotes meetingsnote meetingsnotes meatingnote meatingnotes meatingsnote meatingsnotes notemeeting notesmeeting snotemeeting snotesmeeting notemeating notesmeating snotemeating snotesmeating:
            - ~Run Note_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>
          - case webget wget:
            - ~Run Webget_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>|<[Message_ID]>]>

    # % ██ [ General Plaintext Scripts       ] ██
      - else if <[Message].starts_with[yay]> || <[Message].contains[<&sp>yay<&sp>]>:
        - ~run Yayap_DCommand def:<[Channel]>
