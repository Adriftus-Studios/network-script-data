#discord_sendMessage:
#  type: task
#  definitions: group|channel|messageEscaped|PlayerName
#  script:
#    - announce to_console "<[group]> - <[channel]>"
#    #- define Fchannel <discord[AdriftusBot].group[<[group]>].channel[<[channel]>]>
#    - choose <[Channel]>:
#      - case "global-chat":
#        - define Channel 651789860562272266
#      - case "development-chat":
#        - define Channel 626080540638052382
#      - case "manager-chat":
#        - define Channel 626086306606350366
#        
#    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel].id>.hook]>
#    - define data '{"content": "<[messageEscaped].unescaped>", "username": "<[Name]>", "avatar_url": "https://minotar.net/helm/<[Name]>"}'
#    - define Data <map[content/<[messageEscaped].unescaped>|username/<[Name]>|avatar_url/https://minotar.net/helm/<[Name]>].to_json>
#    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
#    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
#    #- discord id:AdriftusBot channel:<[Fchannel]> message <[messageEscaped].unescaped>


discord_sendMessage:
  type: task
  debug: false
  definitions: group|channel|messageEscaped
  script:
    - announce to_console "<[group]> - <[channel]>"
    - define Fchannel <discord[AdriftusBot].group[<[group]>].channel[<[channel]>]>
    - discord id:AdriftusBot channel:<[Fchannel]> message <[messageEscaped].unescaped>


discord_editMessage:
  type: task
  debug: false
  definitions: group|channel|MessageID|messageEscaped
  script:
    - define Fchannel <discord[AdriftusBot].group[<[group]>].channel[<[channel]>]>
    - discord id:AdriftusBot channel:<[Fchannel]> edit_message <[messageEscaped].unescaped> message_id:<[MessageID]>

