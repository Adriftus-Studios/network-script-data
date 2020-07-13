#### UPDATE PERMISSIONS ####
#Offsite Notify
command_mod_offsite_notify:
  type: task
  debug: false
  definitions: moderatorName|playerName|punishment|reason|length
  script:
    - define message:"<[moderatorName]> issued a <[length]> <[punishment]> to <[playerName]> for <[reason]>."
    - define servers:<bungee.list_servers>
    - foreach <[servers]> as:server:
      - ~bungeetag <[server]> <server.list_online_players> save:players
      - define list:<list[]>
      - foreach <entry[players].result> as:player:
        - define permission:<player.has_permission[aurora.server.role.staff]> player:<[player]>
        - if <[permission]>:
          - define list:|:<[player]>
      - bungeeexecute <[server]> "ex narrate "<[message]>" targets:<[list]>"

#Offsite Bans
command_mod_offsite_ban:
  type: task
  debug: false
  definitions: playerName|level|reason|length|moderator
  script:
    - if <[level]> == 1:
      - execute as_player "ban <[playerName]> -s <[length]> <[reason]>" player:<[moderator]>
    - else if <[level]> == 2:
      - execute as_player "ban <[playerName]> -s <[length]> <[reason]>" player:<[moderator]>
    - else if <[level]> == 3:
      - execute as_player "ban <[playerName]> -s <[length]> <[reason]>" player:<[moderator]>
