coins_command:
    type: command
    name: coins
    debug: false
    description: tells you how many coins you or another player has.
    usage: /coins (player)
    permission: behrry.economy.coins
    aliases:
        - coin
        - money
        - bal
        - balance
    script:
    # % ██ [  check for args ] ██
        - if <context.args.size> > 1:
            - inject command_syntax

        - if <context.args.size> == 0:
            - if !<player.has_flag[behrry.economy.coins]>:
                - flag player behrry.economy.coins:1
            - narrate "<&e>Coin balance<&6>: <&a><player.flag[behrry.economy.coins].format_number>"
        - else:
            - define user <context.args.first>
            - inject player_verification_offline
        
            - if !<[user].has_flag[behrry.economy.coins]>:
                - flag <[user]> behrry.economy.coins:1
            - narrate "<proc[user_display_simple].context[<[user]>]><&e>'s coin balance<&6>: <&a><[user].flag[behrry.economy.coins].format_number>"

pay_command:
    type: command
    name: pay
    debug: false
    description: gives a player some coin.
    usage: /pay <&lt>player<&gt> <&lt>#<&gt>
    permission: behrry.economy.pay
    aliases:
        - moneygive
        - givemoney
        - payto
    script:
        - if <context.args.size> != 2:
            - inject command_syntax

        - define user <context.args.first>
        - inject player_verification

        - if <[user]> == <player>:
            - narrate format:colorize_red "You cannot send yourself coin."
            - stop

        - if <context.args.get[2].contains[$]>:
            - if !<context.args.get[2].after[$].replace[,].is_integer>:
                - narrate format:colorize_red "Coins must be a value."
                - stop
            - else:
                - define money <context.args.get[2].after[$].replace[,]>
        - else if !<context.args.get[2].is_integer>:
            - narrate format:colorize_red "Coins must be a value."
            - stop
        - else:
            - define money <context.args.get[2].replace[,]>

        - if <[money].contains[.]>:
            - narrate format:colorize_red "Coins cannot be decimals."
            - stop

        - if !<player.has_flag[behrry.economy.coins]>:
            - flag player behrry.economy.coins:1
        
        - if <player.flag[behrry.economy.coins]> < <[money]>:
            - narrate format:colorize_red "Not enough coin."
            - stop
        
        - if <[money]> == <&chr[221e]>:
            - narrate format:colorize_red "You don't have that much coin!? the maximum is 2,147,483,647!"
        
        - if <[money]> < 1:
            - narrate format:colorize_red "Must enter a valid number."
            - stop

        - if <[money]> == 1:
            - define format coin
        - else:
            - define format coins

        - narrate "<&a>You sent <proc[user_display_simple].context[<[user]>]> <&e><[money].format_number.replace[,].with[<&6>,<&e>]> <&a><[format]>!"
        - if <[user].is_online>:
            - narrate targets:<[user]> "<proc[user_display_simple].context[<player>]> <&e>sent you <&e><[money].format_number.replace[,].with[<&6>,<&e>]> <&a><[format]>!"
        


        - flag player behrry.economy.coins:-:<[money]>
        - flag <[user]> behrry.economy.coins:+:<[money]>


cointop_command:
    type: command
    name: cointop
    debug: false
    description: shows you the players with the most coins.
    usage: /cointop (#)
    permission: behrry.economy.cointop
    aliases:
        - baltop
        - balancetop
        - moneytop
        - coinstop
    script:
        - define players <server.players_flagged[behrry.economy.coins]>
        - define players_ordered <[players].sort_by_number[flag[behrry.economy.coins]].reverse>
        - define print_count 8
        - define total_pages <[players_ordered].size.div[<[print_count]>].round_up>

        - if <context.args.size> == 0:
            - define page 1
        - else if <context.args.first.is_integer>:
            - if <context.args.first> < 0:
                - narrate format:colorize_red "Page must be a valid number."
                - stop
            - else if <context.args.first.contains[.]>:
                - narrate format:colorize_red "Page cannot be a decimal."
                - stop
            - else if <context.args.first> > <[total_pages]>:
                - narrate format:colorize_red "Invalid page."
                - stop
            - define page <context.args.first>
        - else:
            - inject command_syntax

        - define player_get <[players_ordered].sub_lists[<[print_count]>].get[<[page]>]>
        - narrate "<&2><&m>+<&a><&m>---------------<&2>[<&e> Highest Value Players <&2>]<&a><&m>--------------<&2><&m>+"
        - foreach <[player_get]> as:player:
            - narrate "<&6>[<&e><[print_count].mul[<[page]>].add[<[loop_index]>]><&6>]<&r> <proc[user_display_simple].context[<[player]>]> <&b>| <&a><[player].flag[behrry.economy.coins].format_number> coins"
        
        #- backward  <&chr[25c0]>
        #- forward <&chr[25b6]>
        - if <[page]> == 1:
            - define previous <&2>[<&8><&chr[25c0]><&2>]

            - define hover "<proc[colorize].context[click for page:|green]><&nl><&6>[<&e>-<&chr[25b6]><&6>] <proc[colorize].context[(<[page].add[1]>/<[total_pages]>)|yellow]> <&6>[<&e>-<&chr[25b6]><&6>]"
            - define text <&2>[<&e><&chr[25b6]><&2>]
            - define command "cointop <[page].add[1]>"
            - define next <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
        - else if <[page]> > 1 && <[page]> < <[total_pages]>:
            - define hover1 "<proc[colorize].context[click for page:|green]><&nl><&6>[<&e><&chr[25c0]>-<&6>] <proc[colorize].context[(<[page].sub[1]>/<[total_pages]>)|yellow]> <&6>[<&e><&chr[25c0]>-<&6>]"
            - define text1 <&2>[<&e><&chr[25c0]><&2>]
            - define command1 "cointop <[page].sub[1]>"
            - define previous <proc[msg_cmd].context[<[hover1]>|<[text1]>|<[command1]>]>

            - define hover2 "<proc[colorize].context[click for page:|green]><&nl><&6>[<&e>-<&chr[25b6]><&6>] <proc[colorize].context[(<[page].add[1]>/<[total_pages]>)|yellow]> <&6>[<&e>-<&chr[25b6]><&6>]"
            - define text2 <&2>[<&e><&chr[25b6]><&2>]
            - define command2 "cointop <[page].add[1]>"
            - define next <proc[msg_cmd].context[<[hover2]>|<[text2]>|<[command2]>]>
        - else if <[page]> == <[total_pages]>:
            - define hover "<proc[colorize].context[click for page:|green]><&nl><&6>[<&e><&chr[25c0]>-<&6>] <proc[colorize].context[(<[page].sub[1]>/<[total_pages]>)|yellow]> <&6>[<&e><&chr[25c0]>-<&6>]"
            - define text <&2>[<&e><&chr[25c0]><&2>]
            - define command "cointop <[page].sub[1]>"
            - define previous <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>

            - define next <&2>[<&8><&chr[25b6]><&2>]


        - narrate <&2><&m>+<&a><&m>----------------<[previous]><&a><&m>-<&2>[<&e>page<&2>]<&a><&m>-<&2>[<&e><[page]><&2>/<&e><[total_pages]><&2>]<&a><&m>-<[next]><&a><&m>----------------<&2><&m>+
