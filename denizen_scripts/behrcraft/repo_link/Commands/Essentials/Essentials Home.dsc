Home_Command:
    type: command
    name: home
    debug: false
    description: Teleports you to a home.
    admindescription: Teleports you to a home, or another player's home.
    permission: Behr.Essentials.Home
    aliases:
      - h
    usage: /home <&lt>HomeName<&gt> (Remove/Relocate)
    adminusage: /home <&lt>player<&gt> <&lt>HomeName<&gt> (Remove)
    tab complete:
        - if <context.args.is_empty>:
          - determine <player.flag[Behr.Essentials.Homes].parse[before[/]]||>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <player.flag[Behr.Essentials.Homes].parse[before[/]].filter[starts_with[<context.args.first>]]||>
        - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>]>:
            - determine remove
        - else if <context.args.size> == 2 && !<context.raw_args.ends_with[<&sp>]>:
            - determine remove
    script:
    # % ██ [ Open Home GUI ] ██
        - if <context.args.is_empty>:
            - run Home_GUI
            - stop

    # % ██ [ Check for existing homes ] ██
        - else if !<player.has_flag[Behr.Essentials.Homes]>:
            - narrate format:Colorize_Red "You have no homes"
            - stop

    # % ██ [ Verify args ] ██
        - else if <context.args.size> > 2:
            - inject Command_Syntax

    # % ██ [ Check for two remove or relocate ] ██
        - if <context.raw_args.split[<&sp>].filter[is[==].to[remove]].size> == 2:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop
        - if <context.raw_args.split[<&sp>].filter[is[==].to[relocate]].size> == 2:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

    # % ██ [ Check for both relocate and remove ] ██
        - if <context.raw_args.split.contains[remove]> && <context.raw_args.split.contains[relocate]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
            - stop

    # % ██ [ Check for a remove or relocate arg if there's two args ] ██
        - if <context.args.size> == 2:
            - if <context.raw_args.split[<&sp>].filter[is[==].to[remove]].size.add[<context.raw_args.split[<&sp>].filter[is[==].to[relocate]].size>]> != 1:
                - inject Command_Syntax

    # % ██ [ Define the home name and determine if removing ] ██
        - if <context.args.size> == 1:
            - define Name <context.args.first>
            - define Remove false
            - define Relocate False
        - else:
            - if <context.raw_args.contains[remove]>:
                - if <context.args.first> == remove:
                    - define Name <context.args.get[2]>
                - else:
                    - define Name <context.args.first>
                - define Remove true
            - else:
                - if <context.args.first> == Relocate:
                    - define Name <context.args.get[2]>
                - else:
                    - define Name <context.args.first>
                - define Relocate true

    # % ██ [ check if the home exists ] ██
        - if !<player.flag[Behr.Essentials.Homes].parse[before[/]].contains[<[Name]>]>:
            - narrate "<proc[Colorize].context[That home does not exist.|red]>"
            - stop

    # % ██ [ Define the home location ] ██
        - define Location <player.flag[Behr.Essentials.Homes].map_get[<[Name]>].as_location>
        
    # % ██ [ Run removal if removing ] ██
        - if <[Remove]||false>:
            - flag player Behr.Essentials.Homes:<-:<[Name]>/<[Location]>
            - narrate "<&2>H<&a>ome <proc[Colorize].context[[<[Name]>]|yellow]> <&2>R<&a>emoved<&2>."
            - stop
        
    # % ██ [ Run relocate if relocating ] ██
        - if <[Relocate]>:
            - flag player Behr.Essentials.Homes:<-:<[Name]>/<[Location]>
            - define NewLocation <player.location.simple.as_location.add[0.5,0,0.5].with_yaw[<player.location.yaw>].with_pitch[<player.location.pitch>]>
            - flag <player> Behr.Essentials.Homes:->:<[Name]>/<[NewLocation]>
            - narrate "<&2>H<&a>ome <proc[Colorize].context[[<[Name]>]|yellow]> <&2>R<&a>elocated<&2>."
            - stop

    # % ██ [ Check if home world exists ] ██
        - if !<server.worlds.contains[<[Location].world>]>:
            - narrate format:Colorize_Red "World is not loaded."
            - stop

    # % ██ [ Teleport to Home ] ██
        - flag <player> behr.essentials.teleport.back:<map.with[location].as[<player.location>].with[world].as[<player.world.name>]>
        - if !<[Location].chunk.is_loaded>:
            - chunkload <[Location].chunk> duration:20s
        - teleport <player> <[Location]>
        - narrate "<proc[Colorize].context[Teleported to:|green]> <&6>[<&e><[Name]><&6>]"


Home_GUI:
  type: task
  debug: false
  House: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2Y3Y2RlZWZjNmQzN2ZlY2FiNjc2YzU4NGJmNjIwODMyYWFhYzg1Mzc1ZTlmY2JmZjI3MzcyNDkyZDY5ZiJ9fX0=
  definitions: nbt|click|slot
  script:
    - if <[nbt]||null> != null:
        - foreach <[nbt].unescaped> as:Data:
            - define <[Data].before[/]> <[Data].after[/]>
    - else:
        - define Action Main_Menu
        - define Mode Teleport

    - choose <[Action]>:
        - case Main_Menu:
            - if !<player.has_flag[Behr.Essentials.Homes]>:
                - define reason "You have no homes!"
                - inject error_response
            - define Homes <player.flag[Behr.Essentials.Homes]>
            - define Title "My Homes"
            - define WorldList <server.worlds.parse[name]>
            - choose <[Mode]>:
                - case Teleport:
                    - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>T<&b>eleport"
                    - define ActionNBT <list[Menu/Home_GUI|Action/Teleport]>
                - case Rename:
                    - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>R<&b>ename"
                    - define ActionNBT <list[Menu/Home_GUI|Action/Rename]>
                - case HomeSelect:
                    - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>S<&b>elect"
                    - define ActionNBT <list[Menu/Home_GUI|Action/HomeSelect]>
                - case Relocate:
                    - define ActionLore "<&3>C<&b>lick <&3>t<&b>o <&3>R<&b>elocate"
                    - define ActionNBT <list[Menu/Home_GUI|Action/Relocate]>
                - case Delete:
                    - define ActionLore "<&4>C<&c>lick <&4>t<&c>o <&4>D<&c>elete"
                    - define ActionNBT <list[Menu/Home_GUI|Action/Delete]>
                    
            - foreach <[Homes]> as:HomeData:
                - define HomeName <[HomeData].before[/]>
                - define HomeWorld <[HomeData].after[/].as_location.world.name||invalid>
                - if <[HomeList]||null> != null:
                    - if <[HomeList].size> == 27:
                        - foreach stop
                        
                - if <[WorldList].contains[<[HomeWorld]>]>:
                    - define HomeLoc <[HomeData].after[/].as_location>

                    - define Display "<&6>N<&e>ame<&6>: <&a><[HomeName]>"
                    - define Lore "<list[<[ActionLore]>|<&6>W<&e>orld<&6>: <&a><[HomeLoc].world.name>|<&6>L<&e>ocation<&6>: <&6>[<&a><[HomeLoc].x.round_up>,<[HomeLoc].y.round_up>,<[HomeLoc].z.round_up><&6>]]>"
                    - define NBT <[ActionNBT].include[name/<[HomeName]>|Location/<[HomeLoc]>]>
                    - define Item <item[Action_Item].with[material=Player_Head;Skull_skin=a|<script.data_key[House]>;display_name=<[Display]>;lore=<[Lore]>;nbt=<[NBT]>]>
                    - define HomeList:->:<[Item]>

            - define HomeCount <[HomeList].size>
            - define Size <[HomeCount].div[9].round_up.mul[9].add[9].min[18].max[36]>
            - repeat <[HomeCount].div[9].round_up.mul[9].sub[<[HomeList].size>]>:
                - define HomeList:->:<item[Blank]>

            - foreach <list[Teleport]> as:Option:
            #- foreach <list[Teleport|Rename|Relocate|HomeSelect|Delete]> as:Option:
                - define Selected <[Option].is[==].to[<[Mode]>]>
                - if <[Selected]>:
                    - define Display <&6>[<&e>Selected<&6>]
                - else:
                    - define Display "<&7>[<&e>Click to Select<&7>]"

                - choose <[Option]>:
                    - case teleport Rename Relocate HomeSelect:
                        - if <[Selected]>:
                            - define Material Ender_Eye
                        - else:
                            - define Material Ender_Pearl
                    - case Delete:
                        - if <[Selected]>:
                            - define Material magma_cream
                        - else:
                            - define Material fire_charge

                - choose <[Mode]>:
                    - case Teleport:
                        - define NBT <list[Menu/Home_GUI|Action/ModeSelect|Mode/Teleport]>
                        - define Lore "<list[<proc[Colorize].context[[Teleport to Home]|blue]>|<proc[Colorize].context[Teleports you to a home.|green]>]>"
                    - case Rename:
                        - define NBT <list[Menu/Home_GUI|Action/ModeSelect|Mode/Rename]>
                        - define Lore "<list[<proc[Colorize].context[[Rename Home]|blue]>|<proc[Colorize].context[Renames a home.|green]>]>"
                    - case Relocate:
                        - define NBT <list[Menu/Home_GUI|Action/ModeSelect|Mode/Relocate]>
                        - define Lore "<list[<proc[Colorize].context[[Relocate Home]|blue]>|<proc[Colorize].context[Relocates a home|green]>|<proc[Colorize].context[to your location.|green]>]>"
                    - case HomeSelect:
                        - define NBT <list[Menu/Home_GUI|Action/ModeSelect|Mode/HomeSelect]>
                        - define Lore "<list[<proc[Colorize].context[[Select Homes]|blue]>|<proc[Colorize].context[Selects a bunch of homes|green]>|<proc[Colorize].context[for group commands.|green]>]>"
                    - case Delete:
                        - define NBT <list[Menu/Home_GUI|Action/ModeSelect|Mode/Delete]>
                        - define Lore "<list[<proc[Colorize].context[[Delete Home]|blue]>|<proc[Colorize].context[Permanently deletes a home.|red]>]>"

                - define Item <item[Action_Item].with[material=<[Material]>;display_name=<[Display]>;Lore=<[Lore]>;NBT=<[NBT]>;enchantments=respiration,1;hides=ALL]>
                - define HomeList:->:<[Item]>
            - repeat 8:
                - define HomeList:->:<item[Blank]>
            #- narrate <[HomeList].size>
            #- define Inventory <inventory[generic[title=<[title]>;size=<[Size]>]]>
            #- inventory open <[Inventory]>
            #- foreach <[HomeList]> as:i:
            #    - inventory set d:<[Inventory]> slot:<[Loop_Index]> o:<[i]>
            - define Inventory <inventory[generic[title=<[title]>;size=<[Size]>;contents=<[HomeList]>]]>
            - inventory open d:<[Inventory]>

        - case ModeSelect:
            - run Home_GUI def:<list[Menu/Home_GUI|Action/Main_Menu|Mode/<[Mode]>].escaped>
        - case Teleport:
            - execute as_player "home <[Name]>"
        - case Rename:
            - execute as_player "renamehome <[Name]>"
            - inventory close
        - case Relocate:
            - execute as_player "home <[Name]> relocate"
            - run Home_GUI def:<list[Menu/Home_GUI|Action/Teleport].escaped>
        - case HomeSelect:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - case Delete:
            - if !<player.has_flag[Behr.Essentials.HomeWarning]>:
                - flag player Behr.Essentials.Homewarning duration:1m
                - narrate format:Colorize_Red "Are you sure you want to delete?"
                - stop
            - else:
                - flag player Behr.Essentials.HomeWarning:!
                - execute as_player "home <[Name]> remove"
                - run Home_GUI def:<list[Menu/Home_GUI|Action/Teleport].escaped>

HomeGUI_Handler:
    type: data
    t:
    - case menuAddHome:
        - execute as_player "sethome Home<player.flag[Behr.Essentials.Homes].size.add[1]||>"
        - run Home_GUI def:Teleport
