#### UPDATE PERMISSIONS ####
# / MOD
command_mod:
  type: command
  debug: true
  permission: mod.helper
  name: mod
  tab complete:
    - define arguments:<server.list_online_players.parse[name].exclude[<player.name>]>
    - if <context.args.size> == 0:
      - determine <[arguments]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <[arguments].filter[starts_with[<context.args.get[1]>]]>
  script:
    - if <context.args.get[1]||null> == null:
      - inventory open d:<inventory[command_mod_gui_main]>
    - else if <context.args.get[1]> == version:
      - narrate "<&6>Adriftus <&e>Moderator Panel"
      - narrate "<&f>Version 2.0.0 - 2020-05-19"
    - else if <server.list_players.parse[name.to_lowercase].contains[<context.args.get[1].to_lowercase>]>:
      - define permission:<server.match_player[<context.args.get[1]>].has_permission[mod.staff]||false>
      - if <server.match_offline_player[<context.args.get[1]>].name> == <player.name>:
        - narrate "<&c>You cannot perform actions on yourself."
      - else if !<server.match_offline_player[<context.args.get[1]>].is_online>:
        - narrate "<&c>You cannot perform actions on offline players."
      #- else if <[permission]>:
      #  - narrate "<&c>You cannot perform actions on other staff members."
      - else:
        - run command_mod_refresh def:<server.match_player[<context.args.get[1]>].uuid>
        - inventory open d:<inventory[command_mod_gui_panel]>


##MAIN PANELS
#Player List
command_mod_gui_main:
  type: inventory
  debug: true
  title: <&6>Adriftus<&sp><&e>Moderator<&sp>Panel
  inventory: CHEST
  size: 54
  procedural items:
    - define inventory:<list[]>
    - foreach <server.list_online_players.exclude[<player>]> as:player:
      #ITEM
      - define name:<[player].name>
      - define lore:<list[<&r>|<&b>Take<&sp>Action|<&c>View<&sp>History<&sp>(SoonTM)]>
      - define nbt:<list[UUID/<[player].uuid>]>
      #INVENTORY
      - define inventory:|:<item[player_head].with[display_name=<[name]>;lore=<[lore]>;nbt=<[nbt]>;skull_skin=<[player].name>]>
    - determine <[inventory]>
  definitions:
    border: <item[light_blue_stained_glass_pane].with[display_name=<&sp>]>
    close: <item[red_stained_glass_pane].with[display_name=<&c><&l>Close]>
  slots:
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[] [] [] [] [] [] [] [] []"
    - "[close] [border] [border] [border] [border] [border] [border] [border] [close]"

command_mod_gui_main_events:
  type: world
  debug: false
  events:
    on player clicks in command_mod_gui_main priority:10:
      - determine cancelled
    
    on player clicks red_stained_glass_pane in command_mod_gui_main:
      - inventory close

    on player left clicks player_head in command_mod_gui_main:
      - define permission:<player.has_permission[mod.staff]> player:<context.item.nbt[PLAYER]>
      - if <[permission]>:
        - narrate "<&c>You cannot perform actions on other staff members."
      - else:
        - run command_mod_refresh def:<context.item.nbt[UUID]>
        - inventory open d:<inventory[command_mod_gui_panel]>


#Moderation Panel
command_mod_gui_panel:
  type: inventory
  debug: false
  title: <&6>A<&e>MP<&sp><&8>|<&sp><&c><player.flag[modPlayer].as_player.name>
  inventory: CHEST
  size: 9
  procedural items:
    #General Items
    - define air:<item[air]>
    - define border:<item[white_stained_glass_pane].with[display_name=<&sp>]>
    #History Item
    - define HistoryItem:<item[GUIItem_ModP_History]>
    #Player Item
    - define PlayerNickname:<player.flag[modPlayer].as_player.name> player:<player.flag[modPlayer].as_player>
    - define PlayerItem:<item[player_head].with[display_name=<&b><&l><player.flag[modPlayer].as_player.name>;lore=<list[<&3>Nickname<&co><&sp><[PlayerNickname]>]>;skull_skin=<player.flag[modPlayer].as_player.name>]>
    # Helper Perms
    - if <player.has_permission[mod.helper]>:
      #MUTE (<player.flag[modPlayer].has_flag[chat_mute]>)
      - if !<player.flag[modPlayer].as_player.has_flag[chat_mute]>:
        - define MuteItem:<item[GUIItem_ModP_Mute]>
      - else:
        - define MuteItem:<item[GUIItem_ModP_Unmute]>
      #KICK
      - define KickItem:<item[GUIItem_ModP_Kick]>
    # Moderator Perms
    - if <player.has_permission[mod.moderator]>:
      #SEND TO SERVER - GUI
      - define SendItem:<item[GUIItem_ModP_Send]>
      #JAIL
      ##TO BE CONTINUED
      #FREEZE
      ##TO BE CONTINUED
    # Admin Perms
    - if <player.has_permission[mod.admin]>:
      #BAN - GUI
      - define BanItem:<item[GUIItem_ModP_Ban]>
    - determine <list[<[MuteItem]>|<[KickItem]>|<[SendItem]>|<[BanItem]>|<[air]>|<[air]>|<[air]>|<[air]>|<[PlayerItem]>]>

command_mod_gui_panel_events:
  type: world
  debug: false
  events:
    on player clicks in command_mod_gui_panel priority:10:
      - determine cancelled

    on player left clicks GUIItem_ModP_Kick in command_mod_gui_panel:
      - run command_mod_refresh def:<player.flag[modPlayer]>
      - inventory open d:<inventory[command_mod_gui_kick]>
    on player left clicks GUIItem_ModP_Send in command_mod_gui_panel:
      - run command_mod_refresh def:<player.flag[modPlayer]>
      - inventory open d:<inventory[command_mod_gui_send]>
    on player left clicks GUIItem_ModP_Ban in command_mod_gui_panel:
      - run command_mod_refresh def:<player.flag[modPlayer]>
      - inventory open d:<inventory[command_mod_gui_ban]>


##TASKS
command_mod_refresh:
  type: task
  debug: false
  definitions: uuid
  script:
    - flag player modPlayer:<[uuid]> duration:2m

command_mod_setmute:
  type: task
  debug: false
  definitions: mute
  script:
    - if <player.has_flag[chat_mute]>:
      - flag player chat_mute:!
    - else:
      - flag player chat_mute:true

command_mod_addhistory:
  type: task
  debug: true
  definitions: moderator|uuid|offence|category|infraction|punishment|length
  script:
    ##COMMAND_MOD_ADDHISTORY COMMENTS - DEFINITIONS
    # MODERATOR | Moderator's UUID
    # UUID | Player's UUID
    # OFFENCE | Offence Level (1, 2, 3)
    # CATEGORY | Category of infraction (Chat, Non-Combat, Combat) 
    # INFRACTION | Specific infraction (Advertising, Kill Aura, Racism)
    # PUNISHMENT | Type of punishment (Mute, Kick, Ban)
    # LENGTH | Length of punishment
    ## ON READ | Split with '/'

    #Define new entry
    - define entry:<[offence]><&fs><[category]><&fs><[infraction]><&fs><[punishment]><&fs><[level]><&fs><[time]>
    #Define new log entry
    - define border:----------------------------------------
    - define logModerator:MODERATOR<&co><&sp><player[<[moderator]>].name>/<[moderator]>
    - define logPlayer:PLAYER<&co><&sp><player[<[uuid]>].name>/<[uuid]>
    - define logOffence:OFFENCE<&sp>LEVEL<&co><&sp><[offence]>
    - define logCategory:CATEGORY<&co><&sp><[category]>
    - define logInfraction:INFRACTION<&co><&sp><[infraction]>
    - define logPunishment:PUNISHMENT<&co><&sp><[punishment]>
    - define logLength:LENGTH<&co><&sp><[length]>
    - define logTime:TIME<&co><&sp><util.date.time.year>-<util.date.time.month>-<util.date.time.day><&sp><util.date.time.twentyfour_hour><&co><util.date.time.second>
    - define log:<&nl><[logModerator]><&nl><[logPlayer]><&nl><[logOffence]><&nl><[logCategory]><&nl><[logInfraction].strip_color><&nl><[logPunishment]><&nl><[logLength]><&nl><[logTime]><&nl><[border]>
    #Define player history
    #- define history:<proc[getGlobalPlayerData].context[history]||null> player:<player[<[uuid]>]>
    #- if <[history]||null> == null:
    #  - run setGlobalPlayerData:def:history|<list[]> player:<player[<[uuid]>]>
    #- define history:<proc[getGlobalPlayerData].context[history]> player:<player[<[uuid]>]>
    #Define new history
    #- define history:|:<[entry]>]>
    #Set player history
    #- run setGlobalPlayerData def:history|<[history]> player:<player[<[uuid]>]>
    - log "<[log]>" type:info file:plugins/Denizen/data/globalLiveData/admin/moderation/<util.date.time.year>-<util.date.time.month>-<util.date.time.day>.log
    #Notify staff
    - run command_mod_offsite_notify def:<player[<[moderator]>].name>|<player[<[player]>].name>|<[punishment]>|<[infraction]>|<[length]>