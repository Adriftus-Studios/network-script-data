# @ ███████████████████████████████████████████████████████████
# @ ██    Command Dependencies | Easy injections to complete scripts
# % ██
# % ██  [ Command Syntax Error & Stop ] ██
# - ██  [ Usage ] - inject Command_Syntax Instantly
Command_Syntax:
    type: task
    debug: false
    script:
        - define Command "<queue.script.data_key[aliases].first||<queue.script.data_key[Name]>> "
        - define Hover "<proc[Colorize].context[Click to Insert:|Green]><proc[Colorize].context[<&nl> <queue.script.parsed_key[Usage]>|Yellow]>"
        - define Text "<proc[Colorize].context[Syntax: <queue.script.parsed_key[Usage]>|Yellow]>"
        - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
        - stop


# % ██  [ Used a command wrongly, provide reason ] ██
# - ██  [ Usage ] - define Reason "no"
# - ██  [       ] - inject Command_Error Instantly
Command_Error:
    type: task
    debug: false
    script:
        - define Hover "<proc[Colorize].context[You Typed:|red]><&r><&nl><&4>/<&c><context.alias||<context.command>> <context.raw_args><&nl><&2>C<&a>lick to <&2>I<&a>nsert<&nl><&6>Syntax<&co> <proc[Colorize].context[<queue.script.parsed_key[Usage]>|yellow]>"
        - define Text <proc[Colorize].context[<[Reason]>|red]>
        - define Command "<queue.script.data_key[aliases].first||<context.alias||<context.command>>> "
        - narrate <proc[MsgHint].context[<[Hover]>|<[Text]>|<[Command]>]>
        - stop


# % ██  [ U ] ██
# - ██  [ Usage ] - define Reason "no"
# - ██  [       ] - inject Permission_Error
Permission_Error:
    type: task
    debug: false
    script:
        - define Text "<proc[Colorize].context[You don't have permission to do that.|red]>"
        - define Hover "<proc[Colorize].context[Permission Required:|red]> <&6><queue.script.data_key[adminpermission]>"
        - narrate <proc[HoverMsg].context[<[Hover]>|<[Text]>]>
        - stop


# % ██  [ U ] ██
# - ██  [ Usage ] - define Reason "no"
# - ██  [       ] - inject Command_Error
Admin_Verification:
    type: task
    debug: false
    script:
        - if !<player.has_permission[<queue.script.data_key[adminpermission]>]>:
            - inject Permission_Error

#$# % ██  [ Specifically not moderation, no permission message ] ██
#$# - ██  [ Usage ] - inject Admin_Permission_Denied instantly
#$Admin_Permission_Denied:
#$    type: task
#$    debug: false
#$    script:
#$        - define Text "<proc[Colorize].context[You don't have permission to do that.|red]>"
#$        - define Hover "<proc[Colorize].context[Permission Required:|red]> <&6>Moderation"
#$        - narrate <proc[HoverMsg].context[<[Hover]>|<[Text]>]>
#$        - stop

# % ██  [ Verifies a player online ] ██
# - ██  [ Usage ]  - define User playername
# - ██  [       ]  - inject Player_Verification Instantly
Player_Verification:
    type: task
    debug: false
    ErrorProcess:
        - define Hover "<&6>Y<&e>ou <&6>E<&e>ntered<&co><&nl><&c>/<context.alias.to_lowercase> <context.raw_args>"
        - define Text "<proc[Colorize].context[Player is not online or does not exist.|red]>"
        - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
        - stop
    script:
        - else if <server.match_player[<[User]>]||null> == null:
            - inject locally ErrorProcess Instantly
        - define User <server.match_player[<[User]>]>

# % ██  [ Verifies a player online or offline ] ██
# - ██  [ Usage ]  - define User playername
# - ██  [       ]  - inject Player_Verification_Offline Instantly
Player_Verification_Offline:
    type: task
    debug: false
    ErrorProcess:
        - define Hover "<&6>Y<&e>ou <&6>E<&e>ntered<&e>:<&nl><&c>/<context.command.to_lowercase> <context.raw_args>"
        - define Text "<proc[Colorize].context[Player does not exist.|red]>"
        - narrate <proc[MsgHover].context[<[Hover]>|<[Text]>]>
        - stop
    script:
        - else if <server.match_player[<[User]>]||null> == null:
            - if <server.match_offline_player[<[User]>]||null> == null:
                - inject locally ErrorProcess Instantly
            - else:
                - define User <server.match_offline_player[<[User]>]>
        - else:
            - define User <server.match_player[<[User]>]>

# % ██  [ Verifies a player online or offline, returns null instead of closing the queue if invalid ] ██
# - ██  [ Usage ]  - define User playername
# - ██  [       ]  - inject Player_Verification_Offline_NullReturn Instantly
Player_Verification_Offline_NullReturn:
    type: task
    debug: false
    script:
        - if <server.match_player[<[User]>]||null> == null:
            - define User <server.match_offline_player[<[User]>]||null>
        - else:
            - define User <server.match_player[<[User]>]>

# % ██  [ Easy display for PlayerNickname (PlayerName) / PlayerName ] ██
# - ██  [ Usage ]  - <proc[User_Display_Simple].context[<[User]>]>
User_Display_Simple:
    type: procedure
    debug: false
    definitions: User
    script:
        - if <[User].has_flag[behrry.essentials.display_name]>:
            - determine "<&r><[User].display_name||<[User].flag[behrry.essentials.display_name]>><&r> <proc[Colorize].context[(<[User].name>)|yellow]>"
        - else:
            - determine <proc[Colorize].context[<[User].name>|yellow]>

# % ██  [ Logging chat for global chat ] ██
# - ██  [ Usage ]  - define Log SettingsKey/<[Message]>
# - ██  [       ]  - inject ChatLog Instantly
Chat_Logger:
    type: task
    debug: false
    script:
        - if <server.flag[Behrry.Essentials.ChatHistory.Global].size||0> > 24:
            - flag server Behrry.Essentials.ChatHistory.Global:<-:<server.flag[Behrry.Essentials.ChatHistory.Global].first>
        - flag server Behrry.Essentials.ChatHistory.Global:->:<[Log]>

# @ ███████████████████████████████████████████████████████████
# @ ██    Command Dependencies | Tab Completion
# % ██
# % ██  [ Usage ]   tab-completes all online players by their name, filters as you type:
# - ██  [  # 1  ] - determine <proc[Online_Player_Tabcomplete]>
# % ██  [       ]
# % ██  [       ]   tab completes all players online by their name for the SECOND arg
# - ██  [  # 2  ] - determine <proc[Online_Player_Tabcomplete].context[2]>
# % ██  [       ]
# % ██  [       ]   tab completes all players online by their name for the first arg, blacklisting yourself
# - ██  [  # 3  ] - determine <proc[Online_Player_Tabcomplete].context[1|<player>]>
# % ██  [       ]   tab completes all players online by their name for the first arg, blacklisting players flagged "Admin"
# % ██  [       ]   the Blacklist must be escaped if it is a list of players
# - ██  [ # 4.1 ] - determine <proc[Online_Player_Tabcomplete].context[1|<server.players_flagged[Admin].escaped>]>
# % ██  [       ]   OR you can inject the script directly as opposed to using the procedure tag:
# % ██  [       ]   tab completes all players by their name for the first arg, blacklisting online players flagged "Admin"
# - ██  [  #4.2 ] - define blacklist <server.online_players_flagged[Admin]>
# - ██  [       ] - inject Online_Player_Tabcomplete
# % ██  [       ]
# % ██  [       ]   tab completes all players by their name for the second arg, and blacklisting online players flagged "Admin"
# - ██  [  # 5  ] - define iArg 2
# - ██  [       ] - define blacklist <server.online_players_flagged[Admin]>
# - ██  [       ] - inject Online_Player_Tabcomplete
Online_Player_Tabcomplete:
    type: task
    debug: false
    definitions: iArg|Blacklist
    script:
        - if <[iArg]||null> == null:
            - define iArg 1
        - if <context.args.size> == <[iArg].sub[1]>:
            - determine <server.online_players.exclude[<[Blacklist].unescaped.as_list||null>].parse[name]>
        - else if <context.args.size> == <[iArg]> && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.online_players.exclude[<[Blacklist].unescaped.as_list||null>].parse[name].filter[starts_with[<context.args.get[<[iArg]>]>]]>



# % ██  [ Usage ]   tab-completes all players by their name, filters as you type:
# - ██  [  # 1  ] - determine <proc[All_Player_Tabcomplete]>
# % ██  [       ]
# % ██  [       ]   tab completes all players by their name for the SECOND arg
# - ██  [  # 2  ] - determine <proc[All_Player_Tabcomplete].context[2]>
# % ██  [       ]
# % ██  [       ]   tab completes all players by their name for the first arg, blacklisting yourself
# - ██  [  # 3  ] - determine <proc[All_Player_Tabcomplete].context[1|<player>]>
# % ██  [       ]
# % ██  [       ]   tab completes all players by their name for the first arg, blacklisting players flagged "Admin"
# % ██  [       ]   the Blacklist must be escaped if it is a list of players
# - ██  [ # 4.1 ] - determine <proc[All_Player_Tabcomplete].context[1|<server.players_flagged[Admin].escaped>]>
# % ██  [       ]   OR you can inject the script directly as opposed to using the procedure tag:
# % ██  [       ]   tab completes all players by their name for the first arg, blacklisting players flagged "Admin"
# - ██  [  #4.2 ] - define blacklist <server.players_flagged[Admin]>
# - ██  [       ] - inject All_Player_Tabcomplete
# % ██  [       ]
# % ██  [       ]   tab completes all players by their name for the second arg, and blacklisting players flagged "Admin"
# - ██  [  # 5  ] - define iArg 2
# - ██  [       ] - define blacklist <server.players_flagged[Admin]>
# - ██  [       ] - inject All_Player_Tabcomplete
All_Player_Tabcomplete:
    type: task
    debug: false
    definitions: iArg|Blacklist
    script:
        - if <[iArg]||null> == null:
            - define iArg 1
        - if <context.args.size> == <[iArg].sub[1]>:
            - determine <server.players.exclude[<[Blacklist].unescaped.as_list||null>].parse[name]>
        - else if <context.args.size> == <[iArg]> && !<context.raw_args.ends_with[<&sp>]>:
            - determine <server.players.exclude[<[Blacklist].unescaped.as_list||null>].parse[name].filter[starts_with[<context.args.get[<[iArg]>]>]]>



# % ██  [ Usage ]   Tab-completes a list of a values from an escaped ListTag - List must be escaped
# - ██  [  #1   ] - determine <proc[OneArg_Command_Tabcomplete].context[1|<list[Option1|Option2|Option3].escaped>]>
# % ██  [       ]
# % ██  [       ]   tab completes all players by their name for the SECOND arg
# - ██  [  #2   ] - determine <proc[OneArg_Command_Tabcomplete].context[2]>
# % ██  [       ]
# % ██  [       ]   This can also be injected to avoid escaping the list:
# - ██  [       ] - define Args <list[option1|option2|option3]>
# - ██  [       ] - inject OneArg_Command_Tabcomplete
OneArg_Command_Tabcomplete:
    type: task
    debug: false
    definitions: iArg|Args
    script:
        - if <[iArg]||null> == null:
            - define iArg 1
        - if <context.args.size> == <[iArg].sub[1]>:
            - determine <[Args]>
        - else if <context.args.size> == <[iArg]> && !<context.raw_args.ends_with[<&sp>]>:
            - determine <[Args].filter[starts_with[<context.args.get[<[iArg]>]>]]>



# % ██  [ Notes ] Tab-completes a list of options for a numbered list of args
# % ██  [       ] Note: definitions must be numbered "Arg1, Arg2, ..." - Skips if undefined
# % ██  [       ] Example usage for a command describing your pizza:
# - ██  [ Usage ] - define Arg1 <list[small|medium|large]>
# - ██  [       ] - define Arg2 <list[thin|handtossed|brooklyn]>
# - ██  [       ] - define Arg3 <list[redsauce|bbq|alfredo]>
# - ██  [       ] - define Arg4 <list[pepperonies|sausage|pineapples|none]>
# - ██  [       ] - inject MultiArg_Command_Tabcomplete Instantly
MultiArg_Command_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size> == 0:
            - determine <[Arg1]>
        - foreach <context.args> as:Arg:
            - if <[Loop_Index]> == <context.args.size>:
                - if !<context.raw_args.ends_with[<&sp>]>:
                    - if <[Arg<[Loop_Index]>]||null> != null:
                        - determine <[Arg<[Loop_Index]>].filter[starts_with[<context.args.get[<[Loop_Index]>]>]]>
                - else if <[Arg<[Loop_Index].add[1]>]||null> != null:
                    - determine <[Arg<[Loop_Index].add[1]>]>
            - else:
                - foreach next


# % ██  [ Notes ] Tab-completes a list of options for any list of args, including sub-args
# % ██  [       ] First arg is required, every arg afterwards is optional, including deciding between args, or sub-args from the previous arg
# % ██  [       ] Sub-Args are defined as Arg#<ARGNAME>Args - where the # is the arg number and <ARGNAME> is the name from Arg# you want to have sub-args
# - ██  [  # 1  ] - define Arg1 <list[Option1|Option2]>
# - ██  [  # 1  ] - define Arg2Option1Args <list[Option3|Option4]>
# - ██  [  # 1  ] - define Arg2Option2Args <list[Option5|Option6]>
# % ██  [       ] Example usage for a command describing your pizza from a shop that restricts the toppings based on your pizza size,
# % ██  [       ]   and only letting you add a secondary topping if you opted to get red-sauce:
# - ██  [ Usage ] - define Arg1 <list[small|medium|large]>
# - ██  [       ] - define Arg2SmallArgs <list[Peppernoies|Sausage]>
# - ██  [       ] - define Arg2MediumArgs <list[Pepperonies|Sausage|Ham|Chicken]>
# - ██  [       ] - define Arg2LargeArgs <list[Pepperonies|Sausage|Ham|Chicken|Pineapples|Bacon]>
# - ██  [       ] - define Arg3 <list[RedSauce|bbq|alfredo]>
# - ██  [       ] - define Arg4RedSauceArgs <list[Pepperonies|Sausage|Pineapples]>
# - ██  [       ] - inject MultiArg_With_MultiArgs_Command_Tabcomplete Instantly
# % ██  [ Notes ] Tab-completes a list of options for a numbered list of args with specific args per args
MultiArg_With_MultiArgs_Command_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size> == 0:
            - determine <[Arg1]>
        - foreach <context.args> as:Arg:
            - if <[Loop_Index]> == <context.args.size>:
                - if !<context.raw_args.ends_with[<&sp>]>:
                    - if <[Arg<[Loop_Index]>]||null> != null:
                        - determine <[Arg<[Loop_Index]>].filter[starts_with[<context.args.get[<[Loop_Index]>]>]]>
                    - if  <[Arg<[Loop_Index].sub[1]>].contains[<context.args.get[<[Loop_Index].sub[1]>]>]>:
                        - define Option <context.args.get[<[Loop_Index].sub[1]>]>:
                        - if <[Arg<[loop_index]><[Option]>Args]||null> != null:
                            - determine <[Arg<[Loop_Index]><[Option]>Args].filter[starts_with[<context.args.last>]]>
                - else if <[Arg<[Loop_Index].add[1]>]||null> != null:
                    - determine <[Arg<[Loop_Index].add[1]>]>
                - else if <[Arg<[Loop_Index]>].contains[<context.args.last>]>:
                    - if <[Arg<[Loop_Index].add[1]><context.args.last>Args]||null> != null:
                        - determine <[Arg<[Loop_Index].add[1]><context.args.last>Args]>
            - else:
                - foreach next


# % ██  [ Notes ] Tab-completes a list of options for any list of args, including sub-args
# % ██  [       ] First arg is required, every arg afterwards is optional, including deciding between args, or sub-args from the previous arg
# % ██  [       ] Sub-Args are defined as Arg#<ARGNAME>Args - where the # is the arg number and <ARGNAME> is the name from Arg# you want to have sub-args
# - ██  [  # 1  ] - define Arg1 <list[Option1|Option2]>
# - ██  [  # 1  ] - define Arg2Option1Args <list[Option3|Option4]>
# - ██  [  # 1  ] - define Arg3Option2Args <list[Option5|Option6]>
# - ██  [       ] - inject MultiArg_With_MultiArgs_Command_Tabcomplete Instantly
# % ██  [ Notes ] Tab-completes a list of options for a numbered list of args with specific args per args
MultiArg_With_MultiArgs_Excess_Command_Tabcomplete:
    type: task
    debug: false
    script:
        - if <context.args.size> == 0:
            - determine <[Arg1]>
        - define ArgSize <context.args.size>
        - foreach <context.args> as:Arg:
            #@ Check for the correct index
            - if <[Loop_Index]> == <[ArgSize]>:
                #@ Player is typing a current arg
                - if !<context.raw_args.ends_with[<&sp>]>:
                    #@ TabCompleting Arg#
                    - if <[Arg<[Loop_Index]>]||null> != null:
                        - determine <[Arg<[Loop_Index]>].filter[starts_with[<context.args.get[<[Loop_Index]>]>]]>
                    #@ TabCompleting Arg#ArgArgs
                    - repeat <[ArgSize]>:
                        - define ArgRef <[ArgSize].sub[<[Value]>]>
                        - if <[Arg<[ArgRef]>]||null> != null:
                            - if <[Arg<[ArgRef]>].contains[<context.args.get[<[ArgRef]>]>]>:
                                - define Option <context.args.get[<[ArgRef]>]>
                                - if <[Arg<[loop_index]><[Option]>Args]> != null:
                                    - determine <[Arg<[Loop_Index]><[Option]>Args].filter[starts_with[<context.args.last>]]>
                                    
                #@ Player is typing a new arg - check for Arg#
                - else if <[Arg<[Loop_Index].add[1]>]||null> != null:
                    - determine <[Arg<[Loop_Index].add[1]>]>
                
                #@ Player is typing a new arg - check for Arg#ArgArgs
                - else:
                    - repeat <[ArgSize]>:
                        - define i1 <[Value]>
                        #@ Check for previous Arg#
                        - define ArgRef <[ArgSize].add[1].sub[<[i1]>]>
                        - if <[Arg<[i1]>]||null> != null:
                            - repeat <[ArgRef].add[1]>:
                                - define i2 <[Value]>
                                - if <context.args.size.add[1]> != <[i2]>:
                                    - repeat next
                                - define iArg <context.args.get[<[ArgSize].add[1].sub[<[i1]>]>]>
                                - if <[Arg<[i1]>].contains[<[iArg]>]>:
                                    - if <[Arg<[ArgSize].add[1]><[iArg]>Args]||null> != null:
                                        - determine <[Arg<[ArgSize].add[1]><[iArg]>Args]>
            #@ Skip to next index
            - else:
                - foreach next
#@MultiArg_With_MultiArgs_Excess_Command_Tabcomplete:
#@    type: task
#@    debug: false
#@    script:
#^        - if <context.args.size> == 0:
#^            - determine <[Arg1]>
#^        - foreach <context.args> as:Arg:
#^            - if <[Loop_Index]> == <context.args.size>:
#^                - if !<context.raw_args.ends_with[<&sp>]>:
#^                    - if <[Arg<[Loop_Index]>]||null> != null:
#^                        - determine <[Arg<[Loop_Index]>].filter[starts_with[<context.args.get[<[Loop_Index]>]>]]>
#^                    - repeat <context.args.size>:
#^                        - if <[Arg<context.args.size.sub[<[Value]>]>]||null> != null:
#^                            - if <[Arg<context.args.size.sub[<[Value]>]>].contains[<context.args.get[<context.args.size.sub[<[Value]>]>]>]>:
#^                                - if <[Arg<[loop_index]><context.args.get[<context.args.size.sub[<[Value]>]>]>Args]||null> != null:
#^                                    - determine <[Arg<[Loop_Index]><context.args.get[<context.args.size.sub[<[Value]>]>]>Args].filter[starts_with[<context.args.last>]]>
#^                - else if <[Arg<[Loop_Index].add[1]>]||null> != null:
#^                    - determine <[Arg<[Loop_Index].add[1]>]>
#^                - else:
#^                    - repeat <context.args.size>:
#^                        - define i1 <[Value]>
#^                        - if <[Arg<[i1]>]||null> != null:
#^                            - repeat <context.args.size.add[1].sub[<[i1]>].add[1]>:
#^                                - define i2 <[Value]>
#^                                - if <context.args.size.add[1]> != <[i2]>:
#^                                    - repeat next
#^                                - if <[Arg<[i1]>].contains[<context.args.get[<context.args.size.add[1].sub[<[i2]>]>]>]>:
#^                                    - if <[Arg<context.args.size.add[1]><context.args.get[<context.args.size.add[1].sub[<[i2]>]>]>Args]||null> != null:
#^                                        - determine <[Arg<context.args.size.add[1]><context.args.get[<context.args.size.add[1].sub[<[i2]>]>]>Args]>
#%            #@ Skip to next index
#^            - else:
#^                - foreach next

# % ███████████████████████████████████████████████████████████
# @ ██    Command Dependencies | Unique Command Features
# % ██
# @ ██  [ Activates or Deactivates a toggle command ] ██
# @ ██  [ Usage ] - define Arg <context.args.first||null>
# @ ██  [       ] - define ModeFlag "Behr.Essentials.Example"
# @ ██  [       ] - define ModeName "Mode Name"
# @ ██  [       ] - inject Activation_Arg_Command Instantly
# @ ██  [       ]
# @ ██  [       ] - run Activation_Arg_Command "def:Behr.Essentials.Example|Mode Name"
# @ ██  [       ] - run Activation_Arg_Command "def:Behr.Essentials.Example|Mode Name|on"

Activation_Arg:
    type: task
    debug: false
    definitions: Flag|Mode|Arg
    Activate:
        - if <player.has_flag[<[ModeFlag]>]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - flag player <[ModeFlag]>
            - narrate "<proc[Colorize].context[<[ModeName]> Enabled.|green]>"
    Deactivate:
        - if !<player.has_flag[<[ModeFlag]>]>:
            - narrate "<proc[Colorize].context[Nothing interesting happens.|yellow]>"
        - else:
            - flag player <[ModeFlag]>:!
            - narrate "<proc[Colorize].context[<[ModeName]> Disabled.|green]>"
    script:
        - choose <[Arg]||null>:
            - case on true activate:
                - inject locally Activate Instantly
            - case off false deactivate:
                - inject locally Deactivate Instantly
            - case null:
                - if <player.has_flag[<[ModeFlag]>]>:
                    - inject locally Deactivate Instantly
                - else:
                    - inject locally Activate Instantly
            - default:
                - inject Command_Syntax Instantly



