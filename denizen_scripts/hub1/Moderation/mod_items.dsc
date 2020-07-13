#### UPDATE PERMISSIONS ####
##Commands
command_mod_commands:
  type: yaml data
  #HELPERS + MODERATORS
  player:
    mute: <list[ex<&sp>flag<&sp><player.flag[modPlayer].as_player><&sp>chat_mute<&co>true].escaped>
    unmute: <list[ex<&sp>flag<&sp><player.flag[modPlayer].as_player><&sp>chat_mute<&co>!].escaped>
    history: <list[]>
  #HELPERS + MODERATORS - SERVER SIDE KICKS, FREEZES, & JAILS
  bungee:
    kick: <list[minecraft<&co>kick<&sp><player.flag[modPlayer].as_player.name><&sp>Kicked<&sp>from<&sp>the<&sp>Network].escaped>
    #freeze: <list[ex<&sp>adjust<&sp><player.flag[modPlayer]><&sp>walk_speed<&co>0|minecraft<&co>effect<&sp>clear<&sp><player.flag[modPlayer].name>|minecraft<&co>effect<&sp>give<&sp><player.flag[modPlayer]>].name><&sp>resistance<&sp>99999<&sp>255|minecraft<&co>effect<&sp>give<&sp><player.flag[modPlayer].name><&sp>weakness<&sp>99999<&sp>255].escaped>


##Moderator Panel Items
GUIItem_ModP_Mute:
  type: item
  debug: false
  material: <item[jukebox]>
  display name: <&6><&l>Mute
  lore: 
    - "<&c>Mute Player from Chat."
  mechanisms:
    nbt: <list[INV/<list[ex<&sp>flag<&sp><player.flag[modPlayer].as_player><&sp>chat_mute<&co>true].escaped>]>
    flags: <list[HIDE_ATTRIBUTES]>

GUIItem_ModP_Unmute:
  type: item
  debug: false
  material: <item[note_block]>
  display name: <&e><&l>Unmute
  lore:
    - "<&6>Unmute Player from Chat."
  mechanisms:
    nbt: <list[CMDS/<list[ex<&sp>flag<&sp><player.flag[modPlayer].as_player><&sp>chat_mute<&co>!].escaped>]>
    flags: <list[HIDE_ATTRIBUTES]>

GUIItem_ModP_Kick:
  type: item
  debug: false
  material: <item[leather_boots]>
  color: 16711680
  display name: <&c><&l>Kick
  lore:
    - "<&4>Kick Player from the Network."
  mechanisms:
    nbt: <list[INV/command_mod_gui_kick]>
    flags: <list[HIDE_ATTRIBUTES]>

GUIItem_ModP_Send:
  type: item
  debug: false
  material: <item[ender_pearl]>
  display name: <&5><&l>Send<&sp>to<&sp>Server
  lore: 
    - "<&d>Transfer the Player to a Server."
  mechanisms:
    nbt: <list[INV/command_mod_gui_send]>
    flags: <list[HIDE_ATTRIBUTES]>

#FREEZE
#JAIL

GUIItem_ModP_Ban:
  type: item
  debug: false
  material: <item[wooden_axe]>
  display name: <&4><&l>Ban
  lore: 
    - "<&c>Open Offences Menu."
  enchantments:
    - ARROW_INFINITE:1
  mechanisms:
    nbt: <list[INV/command_mod_gui_ban]>
    flags: <list[HIDE_ATTRIBUTES|HIDE_ENCHANTS]>


##Player Items
GUIItem_ModP_History:
  type: item
  debug: false
  material: oak_sign
  display name: <&6><&l>Player History
  lore:
    - "<&e>Open Player History. (SoonTM)"
  mechanisms:
    nbt: <list[INV/command_mod_gui_history]>
    flags: <list[HIDE_ATTRIBUTES]>


##Subpanel Items
#Kick, Ban
GUIItem_ModP_baseLevel1:
  type: item
  material: <item[yellow_terracotta]>

GUIItem_ModP_baseLevel2:
  type: item
  material: <item[orange_terracotta]>

GUIItem_ModP_baseLevel3:
  type: item
  material: <item[red_terracotta]>