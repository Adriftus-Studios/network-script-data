Nickname_Command:
    type: command
    name: nickname
    debug: false
    description: Changes your display name.
    admindescription: Changes a your own or another player's display name.
    usage: /nickname (Hex:)<&lt>Nickname<&gt>
    adminusage: /nickname (Player) (Hex:)<&lt>Nickname<&gt>
    permission: Behr.Essentials.Nickname
    adminpermission: Behr.Essentials.Nickname.Others
    aliases:
        - nick
    tab complete:
        - if <player.has_permission[Behr.Essentials.Nickname.Others]>:
            - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Correct syntax? ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax

    # % ██ [  One or two args? ] ██
        - if <context.args.size> == 1:
            - define User <player>
            - define Nickname <context.args.first>
        - else:
            - inject Admin_Verification
            - define User <context.args.first>
            - inject Player_Verification_Offline
            - define Nickname <context.args.get[2]>

    # % ██ [  Same nickname ? ] ██
        - if <[Nickname].parse_color> == <[User].flag[Behr.Essentials.Display_Name]||>:
            - narrate "Nothing interesting happens."
            - inject Command_Error
    # % ██ [  Alphanumerical ? ] ██
        - if !<[Nickname].matches_character_set[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#,-_&0123456789:]>:
        #- if !<[Nickname].matches[[a-zA-Z0-9-_\&\#,]+]>:
            - define reason "Nicknames should be alphanumerical."
            - inject Command_Error
    # % ██ [  No name ? ] ██
        - if <[Nickname].parse_color.strip_color.length> < 1:
            - define reason "Nickname must have letters."
            - inject Command_Error
    # % ██ [  Blacklisted ? ] ██
        - if <[Nickname].contains[&k]>:
            - define reason "Obfuscated names are blacklisted."
            - inject Command_Error
    # % ██ [  Hex ? ] ██
        - if <[Nickname].starts_with[Hex:]>:
            - define Base <[Nickname].after[Hex:]>
            - if <[Base].split[].count[#].is_odd> || <[Base].split[].count[,].is_odd>:
                - define reason "Invalid Color Syntax. Please insert uisng /NewColors"
                - inject Command_Error
            - define Nickname:!
            - foreach <[Base].split[#]> as:String:
                - if <[Loop_Index].is_odd>:
                #^  - if <[String].split[].contains_any[#|,]>:
                #^      - define reason "Invalid Color Syntax. Please insert uisng /NewColors"
                #^      - inject Command_Error
                    - define HexColored:->:<[String]>
                    - define Nickname:->:<[String]>
                    - foreach next
                - if <[String].split[,].parse[is_integer].contains[false]> || <[String].split[,].parse[length.is[more].than[3]].contains[true]> || <[String].split[,].parse[is[MORE].than[255]].contains[true]> || <[String].split[,].parse[is[LESS].than[0]].contains[true]> || <[String].split[].count[,]> != 2:
                    - define reason "Invalid Color Syntax. Please insert uisng /NewColors"
                    - inject Command_Error
                - define Hex <proc[Hex].context[<[String]>]>
                - define HexColored:->:<[Hex]>
                - define Nickname:->:<&color[<[Hex]>]>
            - define HexColored <[HexColored].unseparated>
            - define Nickname <[Nickname].unseparated>
        # % ██ [  Set Name ] ██
            - define Hover "<proc[Colorize].context[Click to reset to:|green]><&nl> <&r><[User].display_name>"
            - define Text "<proc[Colorize].context[Your nickname has been changed to:|green]> <&r><[Nickname].parse_color>"
            - define Command "nick <[User].display_name.escaped.replace[&ss].with[&]>"
            - narrate targets:<[User]> <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
            - if <[User]> != <player>:
                - narrate "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s nickname changed to:|green]> <&r><[Nickname].parse_color>"
            - adjust <[User]> display_name:<[Nickname].parse_color>
        #% ██ [ Local Server Usage   ] ██
        #^  - flag <[User]> Behr.Essentials.Display_Name:<[Nickname].parse_color>
        #% ██ [ Bungee Network Usage ] ██
            - yaml id:global.player.<[User].uuid> set Display_Name:<[Nickname].parse_color>
            - yaml id:global.player.<[User].uuid> set Tab_Display_Name:<[HexColored].parse_color>

            - stop
    # % ██ [  Too long ? ] ██
        - if <[Nickname].parse_color.strip_color.length> > 16 || <[HexColored].exists>:
            - define reason "Nicknames should be less than 16 charaters."
            - inject Command_Error
    #%  % Blacklisting a list of names %  %#
    #^   - define Blacklist "<server.players.filter[has_permission[Behr.Essentials.Nickname.Others]].parse[name].include[Admin|a d m i n|owner|owna|administrator|moderator|server|behr_riley|Founder|Mod|Admin|Helper]>"
    #^   - if <[Nickname].contains_any[<[Blacklist]>]> || <[Nickname].parse_color.strip_color.contains_any[<[Blacklist]>]>:
    #^       - define reason "Illegal Name."
    #^       - inject Command_Error

    # % ██ [  resetting ? ] ██
        - if <[Nickname]> == <[User].name> || <list[Clear|Reset|Remove|Delete|Default].contains[<[Nickname]>]>:
            - define Hover "<proc[Colorize].context[Click to change nickname.|green]><&nl> <&r><[User].name>"
            - define Text "<proc[Colorize].context[Nickname Reset to:|yellow]> <&r><[User].name><&e>."
            - define Command "nick "
            - narrate targets:<[User]> <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
            - adjust <[User]> display_name:<[User].name>
        #% ██ [ Local Server Usage   ] ██
        #^  - flag <[User]> Behr.Essentials.Display_Name:!
        #% ██ [ Bungee Network Usage ] ██
            - yaml id:global.player.<[User].uuid> set Display_Name:<[User].name>
            - yaml id:global.player.<[User].uuid> set Tab_Display_Name:<[User].name>
            - stop

    # % ██ [  Set Name ] ██
        - define Hover "<proc[Colorize].context[Click to reset to:|green]><&nl> <&r><[User].display_name>"
        - define Text "<proc[Colorize].context[Your nickname has been changed to:|green]> <&r><[Nickname].parse_color>"
        - define Command "nick <[User].display_name.escaped.replace[&ss].with[&]>"
        - narrate targets:<[User]> <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - if <[User]> != <player>:
            - narrate "<proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s nickname changed to:|green]> <&r><[Nickname].parse_color>"
        - adjust <[User]> display_name:<[Nickname].parse_color>
    #% ██ [ Local Server Usage   ] ██
    #^  - flag <[User]> Behr.Essentials.Display_Name:<[Nickname].parse_color>
    #% ██ [ Bungee Network Usage ] ██
        - yaml id:global.player.<[User].uuid> set Display_Name:<[Nickname].parse_color>
        - yaml id:global.player.<[User].uuid> set Tab_Display_Name:<[Nickname].parse_color>
