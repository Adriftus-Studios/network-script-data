Coins_Command:
    type: command
    name: coins
    debug: false
    description: Tells you how many coins you or another player has.
    usage: /coins (Player)
    permission: Behrry.Economy.Coins
    aliases:
        - coin
        - money
        - bal
        - balance
    script:
    # % ██ [  Check for args ] ██
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly

        - if <context.args.size> == 0:
            - if !<Player.has_flag[Behrry.Economy.Coins]>:
                - flag player Behrry.Economy.Coins:1
            - narrate "<&e>Coin Balance<&6>: <&a><player.flag[Behrry.Economy.Coins].format_number>"
        - else:
            - define User <context.args.first>
            - inject Player_Verification_Offline Instantly
        
            - if !<[User].has_flag[Behrry.Economy.Coins]>:
                - flag <[User]> Behrry.Economy.Coins:1
            - narrate "<proc[User_Display_Simple].context[<[User]>]><&e>'s Coin Balance<&6>: <&a><[User].flag[Behrry.Economy.Coins].format_number>"

Pay_Command:
    type: command
    name: pay
    debug: false
    description: Gives a player some coin.
    usage: /pay <&lt>Player<&gt> <&lt>#<&gt>
    permission: Behrry.Economy.Pay
    aliases:
        - moneygive
        - givemoney
        - payto
    script:
        - if <context.args.size> != 2:
            - inject Command_Syntax Instantly

        - define User <context.args.first>
        - inject Player_Verification Instantly

        - if <[User]> == <player>:
            - narrate format:Colorize_Red "You cannot send yourself coin."
            - stop

        - if <context.args.get[2].contains[$]>:
            - if !<context.args.get[2].after[$].replace[,].is_integer>:
                - narrate format:Colorize_Red "Coins must be a value."
                - stop
            - else:
                - define Money <context.args.get[2].after[$].replace[,]>
        - else if !<context.args.get[2].is_integer>:
            - narrate format:Colorize_Red "Coins must be a value."
            - stop
        - else:
            - define Money <context.args.get[2].replace[,]>

        - if <[Money].contains[.]>:
            - narrate format:Colorize_Red "Coins cannot be decimals."
            - stop

        - if !<player.has_flag[Behrry.Economy.Coins]>:
            - flag player Behrry.Economy.Coins:1
        
        - if <player.flag[Behrry.Economy.Coins]> < <[Money]>:
            - narrate format:Colorize_Red "Not enough coin."
            - stop
        
        - if <[money]> == <&chr[221e]>:
            - narrate format:Colorize_Red "You don't have that much coin!? The maximum is 2,147,483,647!"
        
        - if <[Money]> < 1:
            - narrate format:Colorize_Red "Must enter a valid number."
            - stop

        - if <[Money]> == 1:
            - define Format "coin"
        - else:
            - define Format "coins"

        - narrate "<&a>You sent <proc[User_Display_Simple].context[<[User]>]> <&e><[Money].format_number.replace[,].with[<&6>,<&e>]> <&a><[Format]>!"
        - if <[User].is_online>:
            - narrate targets:<[User]> "<proc[User_Display_Simple].context[<player>]> <&e>sent you <&e><[Money].format_number.replace[,].with[<&6>,<&e>]> <&a><[Format]>!"
        


        - flag player Behrry.Economy.Coins:-:<[Money]>
        - flag <[User]> Behrry.Economy.Coins:+:<[Money]>


CoinTop_Command:
    type: command
    name: cointop
    debug: false
    description: Shows you the players with the most coins.
    usage: /cointop (#)
    permission: Behrry.Economy.CoinTop
    aliases:
        - baltop
        - balancetop
        - moneytop
        - coinstop
    script:
        - define Players <server.players_flagged[Behrry.Economy.Coins]>
        - define PlayersOrdered <[Players].sort_by_number[flag[Behrry.Economy.Coins]].reverse>
        - define PrintCount 8
        - define TotalPages <[PlayersOrdered].size.div[<[PrintCount]>].round_up>

        - if <context.args.size> == 0:
            - define Page 1
        - else if <context.args.first.is_integer>:
            - if <context.args.first> < 0:
                - narrate format:Colorize_Red "Page must be a valid number."
                - stop
            - else if <context.args.first.contains[.]>:
                - narrate format:Colorize_Red "Page cannot be a decimal."
                - stop
            - else if <context.args.first> > <[TotalPages]>:
                - narrate format:Colorize_Red "Invalid Page."
                - stop
            - define Page <context.args.first>
        - else:
            - inject Command_Syntax Instantly

        - define Math1 <[PrintCount].mul[<[Page].sub[1]>].add[1]>
        - define Math2 <[PrintCount].mul[<[Page].sub[1]>].add[<[PrintCount]>]>

        - define PlayerGet <[PlayersOrdered].get[<[Math1]>].to[<[Math2]>]>
        - narrate "<&2><&m>+<&a><&m>---------------<&2>[<&e> Highest Value Players <&2>]<&a><&m>--------------<&2><&m>+"
        - foreach <[PlayerGet]> as:Player:
            - narrate "<&6>[<&e><[Math1].add[<[Loop_Index]>].sub[1]><&6>]<&r> <proc[User_Display_Simple].context[<[Player]>]> <&b>| <&a><[Player].flag[Behrry.Economy.Coins].format_number> coins"
        
        #- backward  <&chr[25c0]>
        #- forward <&chr[25b6]>
        - if <[Page]> == 1:
            - define Previous "<&2>[<&8><&chr[25c0]><&2>]"

            - define Hover "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e>-<&chr[25b6]><&6>] <proc[Colorize].context[(<[Page].add[1]>/<[TotalPages]>)|yellow]> <&6>[<&e>-<&chr[25b6]><&6>]"
            - define Text "<&2>[<&e><&chr[25b6]><&2>]"
            - define Command "cointop <[Page].add[1]>"
            - define Next "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
        - else if <[Page]> > 1 && <[Page]> < <[TotalPages]>:
            - define Hover1 "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e><&chr[25c0]>-<&6>] <proc[Colorize].context[(<[Page].sub[1]>/<[TotalPages]>)|yellow]> <&6>[<&e><&chr[25c0]>-<&6>]"
            - define Text1 "<&2>[<&e><&chr[25c0]><&2>]"
            - define Command1 "cointop <[Page].sub[1]>"
            - define Previous "<proc[MsgCmd].context[<[Hover1]>|<[Text1]>|<[Command1]>]>"

            - define Hover2 "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e>-<&chr[25b6]><&6>] <proc[Colorize].context[(<[Page].add[1]>/<[TotalPages]>)|yellow]> <&6>[<&e>-<&chr[25b6]><&6>]"
            - define Text2 "<&2>[<&e><&chr[25b6]><&2>]"
            - define Command2 "cointop <[Page].add[1]>"
            - define Next "<proc[MsgCmd].context[<[Hover2]>|<[Text2]>|<[Command2]>]>"
        - else if <[Page]> == <[TotalPages]>:
            - define Hover "<proc[Colorize].context[Click for Page:|green]><&nl><&6>[<&e><&chr[25c0]>-<&6>] <proc[Colorize].context[(<[Page].sub[1]>/<[TotalPages]>)|yellow]> <&6>[<&e><&chr[25c0]>-<&6>]"
            - define Text "<&2>[<&e><&chr[25c0]><&2>]"
            - define Command "cointop <[Page].sub[1]>"
            - define Previous "<proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"

            - define Next "<&2>[<&8><&chr[25b6]><&2>]"


        - narrate "<&2><&m>+<&a><&m>----------------<[Previous]><&a><&m>-<&2>[<&e>Page<&2>]<&a><&m>-<&2>[<&e><[Page]><&2>/<&e><[TotalPages]><&2>]<&a><&m>-<[Next]><&a><&m>----------------<&2><&m>+"
