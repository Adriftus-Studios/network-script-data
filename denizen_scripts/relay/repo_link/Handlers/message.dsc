Message_Handler:
  type: world
  debug: false
  events:
    on discord message received for:champagne:
    # % ██ [ Queue Stopping Cache Data       ] ██
      - if <context.new_message.author.discriminator> == 0000:
        - stop
      - define Author <context.new_message.author>

      - if <context.new_message.text||WebHook> == WebHook:
        - stop
      - define Message <context.new_message.text>

      - if <context.Bot> == <[Author]>:
        - stop
      - define Bot <context.Bot>

    # % ██ [ Cache Data                      ] ██
      - define Channel <context.Channel.id>
      - define Group <context.Group||Is_Direct>
      - define Message_ID <context.new_message.id||WebHook>
      - define Is_Direct <context.new_message.is_direct>

    # % ██ [ DM       Based Scripts          ] ██

    # % ██ [ @Mention Based Scripts          ] ██

    # % ██ [ Command  Based Scripts          ] ██
      - if <[Message].starts_with[/]>:
        - choose <[Message].before[<&sp>].after[/]>:
          - case note meetingnote meetingnotes meetingsnote meetingsnotes meatingnote meatingnotes meatingsnote meatingsnotes notemeeting notesmeeting snotemeeting snotesmeeting notemeating notesmeating snotemeating snotesmeating:
            - ~Run Note_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>|<[Message_ID]>]>

    # % ██ [ General Plaintext Scripts       ] ██
      - else if <[Message].starts_with[yay]> || <[Message].contains_any[<&sp>yay<&sp>|<&sp>yay!**|**yay**]>:
        - ~run Yayap_DCommand def:<[Channel]>

    on discord message received for:aBot:
    # % ██ [ Queue Stopping Cache Data       ] ██
      - if <context.new_message.author||WebHook> == WebHook:
        - stop
      - define Author <context.new_message.author>

      - if <context.new_message.text||WebHook> == WebHook:
        - stop
      - define Message <context.new_message.text>

      - if <context.Bot> == <[Author]>:
        - stop
      - define Bot <context.Bot>

    # % ██ [ Cache Data                      ] ██
      - define Channel <context.channel.id>
      - define Group <context.group||Is_Direct>
    #^- define No_Mention_Message <context.new_message.text_no_mentions.escaped||WebHook>
      - define Message_ID <context.new_message.id||WebHook>
    #^- define Mentions <context.new_mentioned_users||WebHook>
      - define Is_Direct <context.new_message.is_direct>

    # % ██ [ DM       Based Scripts          ] ██
      - if <[Is_Direct]>:
        - choose <[Message].before[<&sp>].after[/]>:
          - case tag parse t:
            - ~Run Tag_Parser_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>|<[Is_Direct]>]>

    # % ██ [ @Mention Based Scripts          ] ██

    # % ██ [ Command  Based Scripts          ] ██
      - else if <[Message].starts_with[/]>:
        - choose <[Message].before[<&sp>].after[/]>:
          - case adddev adddeveloper add_dev add_developer devup devadd developeradd dev_add developer_add promotedev addgit gitadd add_git git_add:
            - ~Run Add_Developer_DCommand def:<list_single[<context.message>].include[<[Channel]>|<[Author]>|<[Group]>]>

          - case bungee:
            - ~Run Bungee_DCommand def:<[Message]>|<[Channel]>|<[Author]>|<[Group]>

          - case discord_connect disc_connect discconnect discordconnect connect_discord connect_disc connectdiscord connectdisc discord_link disc_link disclink discordlink link_discord link_disc linkdiscord linkdisc:
            - ~Run Discord_Connect_DCommand def:<list_single[<context.message>].include[<[Channel]>|<[Author]>|<[Group]>]>

          - case ex execute:
            - ~Run Ex_DCommand def:<[Message]>|<[Channel]>|<[Author]>|<[Group]>

          - case note meetingnote meetingnotes meetingsnote meetingsnotes meatingnote meatingnotes meatingsnote meatingsnotes notemeeting notesmeeting snotemeeting snotesmeeting notemeating notesmeating snotemeating snotesmeating:
            - ~Run Note_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>

          - case reload:
            - ~Run Reload_Scripts_DCommand def:<[Message]>|<[Channel]>|<[Author]>|<[Group]>

          - case Restart:
            - ~Run Restart_DCommand def:<[Message]>|<[Channel]>|<[Author]>|<[Group]>

          - case repository repo git github:
            - ~Run Repository_DCommand def:<[Message]>|<[Channel]>

          - case script sds scripthelp:
            - ~Run Script_Dependency_Support_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>

          - case tag parse t:
            - ~Run Tag_Parser_DCommand def:<[Message]>|<[Channel]>|<[Author]>|<[Group]>|<[Is_Direct]>

          - case webget wget:
            - ~Run Webget_DCommand def:<[Message]>|<[Channel]>|<[Author]>|<[Group]>|<[Message_ID]>

    on discord message received for:Rachela:
    # % ██ [ Queue Stopping Cache Data       ] ██
      - if <context.new_message.author||WebHook> == WebHook:
        - stop
      - define Author <context.new_message.author>

      - if <context.new_message.text||WebHook> == WebHook:
        - stop
      - define Message <context.new_message.text>

      - if <context.bot> == <[Author]>:
        - stop
      - define Bot <context.bot>

    # % ██ [ Cache Data                      ] ██
      - define Channel <context.channel.id>
      - define Group <context.group||Is_Direct>
    #^- define No_Mention_Message <context.new_message.text_no_mentions.escaped||WebHook>
      - define Message_ID <context.new_message.id||WebHook>
    #^- define Mentions <context.new_messge.mentioned_users||WebHook>
      - define Is_Direct <context.new_message.is_direct>

    # % ██ [ DM       Based Scripts          ] ██
      - if <[Is_Direct]>:
        - choose <[Message].before[<&sp>].after[/]>:
          - case tag parse t:
            - ~Run Tag_Parser_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>|<[Is_Direct]>]>

    # % ██ [ @Mention Based Scripts          ] ██

    # % ██ [ Command  Based Scripts          ] ██
      - else if <[Message].starts_with[/]>:
        - choose <[Message].before[<&sp>].after[/]>:

          - case food foodget foodgit gitfood getfood wheretoeat whereshouldieat wheredoieat whereeat whereieat whereeat eatwhere randomfood foodrandom:
            - ~Run RFood_DCommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>]>

          - case link:
            - ~Run link_dcommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>|<[Message_ID]>]>

      - else if <[message].starts_with[!]>:
        - choose <[message].before[<&sp>].after[!]>:
          - case haste paste hast pastie pasties hasties hastie:
            - ~Run link_dcommand def:<list_single[<[Message]>].include[<[Channel]>|<[Author]>|<[Group]>|<[Message_ID]>|haste]>
