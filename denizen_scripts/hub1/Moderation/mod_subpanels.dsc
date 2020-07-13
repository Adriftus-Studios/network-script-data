##SUBPANELS
#Kick Panel
command_mod_gui_kick:
  type: inventory
  debug: false
  title: <&6>A<&e>MP<&sp><&8>|<&sp><&c>Kick<&sp><player.flag[modPlayer].as_player.name>
  inventory: CHEST
  size: 54
  procedural items:
    ##Define inventory variable
    - define inventory:<list[]>
    #Define infractions
    - define level1:<list[Spam|Excessive<&sp>Characters|Excessive<&sp>Capitals|Chat<&sp>Maturity]>
    - define level2:<list[Advertising<&sp>Servers|Excessive<&sp>Negativity]>
    - define level3:<list[Racism|Sexism|Disrespect<&sp>to<&sp>Players<&sp>and/or<&sp>Staff<&sp>Members|Political<&sp>Chat|Cyber-Bullying|False<&sp>Accusations<&sp>on<&sp>Cyber-Bullying<&sp>(C)]>
    - define tags:<list[<&r><&f><&lb><&e><&l>1<&f><&rb><&sp><&e>|<&r><&7><&lb><&6><&l>2<&7><&rb><&sp><&6>|<&r><&8><&lb><&c><&l>3<&8><&rb><&sp><&c>]>
    - define colours:<list[<&e>|<&6>|<&c>]>
    - foreach <list[1|2|3]> as:lvl:
      #Define Infraction Level X Items
      - foreach <[level<[lvl]>]> as:infraction:
        - define name:<[tags].get[<[lvl]>]><[infraction]>
        - define lore:<list[<&b>Level<&co><&sp><[colours].get[<[lvl]>]><[lvl]>|<&c>Right-Click<&sp>to<&sp>Kick<&co>|<&e><player.flag[modPlayer].as_player.name>]>
        - define nbt:<list[LEVEL/<[lvl]>|CATEGORY/Chat]>
        #Define item using .with[<mechanism>=<value>;...]
        - define item:<item[GUIItem_ModP_baseLevel<[lvl]>].with[display_name=<[name]>;lore=<[lore]>;nbt=<[nbt]>]>
        - define inventory:|:<[item]>
    ##Define Final Inventory
    - determine <[inventory]>
  definitions:
    x: <item[air]>
    border: <item[orange_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[cyan_stained_glass_pane].with[display_name=<&3><&l>Back]>
  slots:
    - "[x] [x] [x] [x] [x] [x] [x] [x] [x]"
    - "[x] [] [x] [] [x] [] [x] [] [x]"
    - "[x] [x] [] [x] [x] [x] [] [x] [x]"
    - "[x] [] [] [] [x] [] [] [] [x]"
    - "[x] [] [] [] [] [] [] [] [x]"
    - "[back] [border] [border] [border] [border] [border] [border] [border] [back]"

command_mod_gui_kick_events:
  type: world
  debug: false
  events:
    on player clicks in command_mod_gui_kick priority:10:
      - determine cancelled

    on player left clicks cyan_stained_glass_pane in command_mod_gui_kick:
      - run command_mod_refresh def:<player.flag[modPlayer]>
      - inventory open d:<inventory[command_mod_gui_panel]>

    on player right clicks GUIItem_ModP_baseLevel* in command_mod_gui_kick:
      - run command_mod_addhistory def:<player.uuid>|<player.flag[modPlayer]>|<context.item.nbt[LEVEL]>|<context.item.nbt[CATEGORY]>|<context.item.display>|Kick|5s
      - execute as_player "kick <player.flag[modPlayer].as_player.name> <&c>Kicked from Adriftus: <context.item.display>"

#Send to Server Panel (WORK IN PROGRESS)
command_mod_gui_send:
  type: inventory
  debug: false
  title: <&6>A<&e>MP<&sp><&8>|<&sp><&5>Send<&sp><&c><player.flag[modPlayer].as_player.name>
  inventory: CHEST
  size: 27
  procedural items:
    - define inventory:<list[]>
    - define lore:<list[<&r><&5>Right-Click<&sp>to<&sp>Send<&co>|<&e><player.flag[modPlayer].as_player.name>]>
    #Define item material from bungee config
    - foreach <bungee.list_servers.exclude[hub1|relay]> as:server:
      - define name:<[server].to_titlecase>
      #Replace item material with 
      - define item:<item[oak_sign].with[display_name=<[name]>;lore=<[lore]>]>
      - define inventory:|:<[item]>
    #Determine Final Inventory
    - determine <list[]>
  definitions:
    x: <item[magenta_stained_glass_pane].with[display_name=<&sp>]>
    y: <item[air]>
    hub: <item[nether_star].with[display_name=<&b><&l>Hub;lore=<list[<&r><&5>Right-Click<&sp>to<&sp>Send<&co>|<&e><player.flag[modPlayer].as_player.name>]>]>
    back: <item[cyan_stained_glass_pane].with[display_name=<&3><&l>Back]>
  slots:
    - "[back] [x] [y] [x] [hub] [x] [y] [x] [back]"
    - "[x] [] [] [] [] [] [] [] [x]"
    - "[back] [x] [y] [x] [back] [x] [y] [x] [back]"

command_mod_gui_send_events:
  type: world
  debug: false
  events:
    on player clicks in command_mod_gui_send priority:10:
      - determine cancelled
    
    on player left clicks cyan_stained_glass_pane in command_mod_gui_send:
      - run command_mod_refresh def:<player.flag[modPlayer]>
      - inventory open d:<inventory[command_mod_gui_panel]>
    on player right clicks nether_star in command_mod_gui_send:
      - bungeeexecute "send <player.flag[modPlayer].as_player.name> hub1"
    
    on player right clicks in command_mod_gui_send:
      - bungeeexecute "send <player.flag[modPlayer].as_player.name> <context.item.display.strip_color.to_lowercase>"


#Ban Panel
command_mod_gui_ban:
  type: inventory
  debug: false
  title: <&6>A<&e>MP<&sp><&8>|<&sp><&4>Ban<&sp><&c><player.flag[modPlayer].as_player.name>
  inventory: CHEST
  size: 54
  procedural items:
    ##Define inventory variable
    - define inventory:<list[]>
    #Define infractions
    - define level1:<list[Inappropriate<&sp>Chat<&sp>Usage/Chat/7d|Advertising<&sp>Servers/Chat/7d|X-Ray/Visual/14d]>
    - define level2:<list[Minor<&sp>Unfair<&sp>Advantage<&sp>(MOVEMENT)/Combat/14d|Minor<&sp>Unfair<&sp>Advantage<&sp>(COMBAT)/Combat/14d|Excessive<&sp>Negativity/Chat/14d|ESP/Visual/14d|Bug<&sp>Abuse/Exploit/14d]>
    - define level3:<list[Major<&sp>Unfair<&sp>Advantage<&sp>(MOVEMENT)/Combat/30d|Major<&sp>Unfair<&sp>Advantage<&sp>(COMBAT)/Combat/30d]>
    #Define colours and tags
    - define tags:<list[<&r><&f><&lb><&e><&l>1<&f><&rb><&sp><&e>|<&r><&7><&lb><&6><&l>2<&7><&rb><&sp><&6>|<&r><&8><&lb><&c><&l>3<&8><&rb><&sp><&c>]>
    - define colours:<list[<&e>|<&6>|<&c>]>
    #Define Infraction Level X Items
    - foreach <list[1|2|3]> as:lvl:
      - foreach <[level<[lvl]>]> as:infraction:
        - define name:<[tags].get[<[lvl]>]><[infraction].split[/].get[1]>
        - define lore:<list[<&b>Level<&co><&sp><[colours].get[<[lvl]>]><[lvl]>|<&4>Right-Click<&sp>to<&sp>Ban<&co>|<&e><player.flag[modPlayer].as_player.name>]>
        - define nbt:<list[LEVEL/<[lvl]>|CATEGORY/<[infraction].split[/].get[2]>|LENGTH/<[infraction].split[/].get[3]>]>
        #Define item using .with[<mechanism>=<value>;...]
        - define item:<item[GUIItem_ModP_baseLevel<[lvl]>].with[display_name=<[name]>;lore=<[lore]>;nbt=<[nbt]>]>
        - define inventory:|:<[item]>
    ##Define Final Inventory
    - determine <[inventory]>
  definitions:
    x: <item[air]>
    border: <item[red_stained_glass_pane].with[display_name=<&sp>]>
    back: <item[cyan_stained_glass_pane].with[display_name=<&3><&l>Back]>
  slots:
    - "[x] [x] [x] [x] [x] [x] [x] [x] [x]"
    - "[x] [x] [] [x] [] [x] [] [x] [x]"
    - "[x] [] [] [x] [] [x] [] [] [x]"
    - "[x] [x] [] [x] [x] [x] [] [x] [x]"
    - "[] [] [] [] [] [] [] [] []"
    - "[back] [border] [border] [border] [border] [border] [border] [border] [back]"

command_mod_gui_ban_events:
  type: world
  debug: false
  events:
    on player clicks in command_mod_gui_ban priority:10:
      - determine cancelled

    on player left clicks cyan_stained_glass_pane in command_mod_gui_ban:
      - run command_mod_refresh def:<player.flag[modPlayer]>
      - inventory open d:<inventory[command_mod_gui_panel]>

    on player right clicks GUIItem_ModP_baseLevel* in command_mod_gui_ban:
      - run command_mod_addhistory def:<player.uuid>|<player.flag[modPlayer]>|<context.item.nbt[LEVEL]>|<context.item.nbt[CATEGORY]>|<context.item.display>|Temporary<&sp>Ban|<context.item.nbt[LENGTH]>
      - run command_mod_offsite_ban def:<player.flag[modPlayer].name>|<context.item.nbt[LEVEL]>|<context.item.display>|<context.item.nbt[LENGTH]>|<player>
      #- bungeerun relay command_mod_offsite_ban def:<player.flag[modPlayer].name>|<context.item.nbt[LEVEL]>|<context.item.display>|<player>