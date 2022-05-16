mod_message_discord:
  type: task
  debug: false
  definitions: moderator|uuid|level|infraction|action|length
  script:
    # Define moderator and default fields.
    - define moderator <tern[<[moderator].is[!=].to[Server]>].pass[<[moderator].as_player.name>].fail[Server]>
    - define fields <list[Name<&co><&sp><player[<[uuid]>].name>|Level<&co><&sp><[level]>|Reason<&co><&sp><[infraction]>|Action<&co><&sp><[action]>]>
    # Length applies for bans.
    - if <[length]||null> != null:
      - define fields:->:Duration<&co><&sp><[length]>
    # Append moderator to fields.
    - define fields:->:Moderator<&co><&sp><[moderator]>
    - define fields:->:Server<&co><&sp><bungee.server>
    - define message SEARCHABLE_<[uuid]><&nl>```<[fields].separated_by[<&nl>]>```
    - bungeerun relay discord_sendMessage "def:A Staff|action-log|<[message].escaped>"

