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
    - bungeerun relay discord_sendMessage "def:Adriftus Staff|action-log|<[message].escaped>"

mod_message_discord_command:
  type: task
  debug: false
  definitions: moderator|command
  script:
    - define moderator <[moderator].as_player.name>
    - bungeerun relay discord_sendMessage "def:Adriftus Staff|command-log|`<bungee.server>`<&co>`<[moderator]>` ran command `<[command]>`"

mod_message_discord_notification:
  type: task
  debug: false
  definitions: moderator|text
  script:
    - define moderator <[moderator].as_player.name>
    - bungeerun relay discord_sendMessage "def:Adriftus Staff|command-log|`<bungee.server>`<&co>`<[moderator]>` <[text]>"

mod_message_discord_report:
  type: task
  debug: false
  definitions: text
  script:
    - bungeerun relay discord_sendMessage "def:Adriftus Staff|in-game-reports|`<bungee.server>`<&co>`<player.name>` <[text]>"
