premium_currency_command:
    type: command
    ## The name of the currency is linked to the name datakey of this command ##
    name: orbsus
    description: A command for the premium currency on this server
    #- Might need to change the usage if you change the name -#
    tab completions:
        1: <tern[<player.has_permission[adriftus.economy.admin]>].pass[<list[give|remove|set].include[<server.online_players.parse[name]>]>].fail[<server.online_players>]>
        2: <server.online_players.parse[name]>
        3: <tern[<player.has_permission[adriftus.economy.admin]>].pass[<&lb>amount<&rb>].fail[]>
    usage: /orbsus
    script:
        - define currencyName <script[premium_currency_command].data_key[name]>

        # % ██ [ View other players balance ] ██
        #- Requires the [adriftus.economy.other] permission -#
        - if <context.args.size> > 0 && <player.has_permission[adriftus.economy.other]> && <server.online_players.parse[name].contains[<context.args.get[1]>]>:
            - define player <server.match_player[<context.args.get[1]>]>
            - narrate "<&b><[player].name> <[currencyName]> balance is: <proc[premium_currency_global_get].context[<[player]>].round_to[2]>"

        # % ██ [ Economy modifier commands ] ██
        #- Requires the [adriftus.economy.admin] permission -#
        - else if <context.args.size> > 0 && <player.has_permission[adriftus.economy.admin]>:
            # % ██ [ Checks to make sure all arguments are present ] ██
            - if !<context.args.get[2].exists>:
                - narrate "<&c>Please specify a player name"
                - stop
            - if !<server.online_players.parse[name].contains[<context.args.get[2]>]>:
                - narrate "<&c>That player is not online"
                - stop
            - if !<context.args.get[3].exists>:
                - narrate "<&c>Please specify an amount"
                - stop
            - if !<context.args.get[3].is_integer>:
                - narrate "<&c>Please make sure your amount is a number"
                - stop

            # % ██ [ Run code based on argument ] ██
            - define player <server.match_player[<context.args.get[2]>]>
            - choose <context.args.get[1]>:
                - case give:
                    - run premium_currency_give def:<[player]>|<context.args.get[3]>
                    - narrate "<&a>Successfully deposited <context.args.get[3]> <[currencyName]> to <[player].name>'s account"
                - case remove:
                    - run premium_currency_remove def:<[player]>|<context.args.get[3]> save:outcome

                    # % ██ [ Check if the balance was removed successfully ] ██
                    - if <entry[outcome].created_queue.determination.first>:
                        - narrate "<&a>Successfully removed <context.args.get[3]> <[currencyName]> from <[player].name>'s account"
                    - else:
                        - narrate "<&c><[player].name> does not have enough funds, to remove <context.args.get[3]> <[currencyName]>"
                - case set:
                    - run premium_currency_set def:<[player]>|<context.args.get[3]> save:outcome

                    # % ██ [ Check if the balance was set successfully ] ██
                    - if <entry[outcome].created_queue.determination.first>:
                        - narrate "<&a>Successfully set <[player].name>'s account to <context.args.get[3]> <[currencyName]>"
                    - else:
                        - narrate "<&c>You cannot set account balance below 0 <[currencyName]>"

        # % ██ [ Print current players balance ] ██
        - else:
            - narrate "<&b>You're <[currencyName]> balance is: <proc[premium_currency_global_get].context[<player>].round_to[2]>"

premium_currency_event_handler:
    type: world
    events:
        on player joins:
            # % ██ [ Used to set initial currency ] ██
            - wait 5t
            - if !<yaml[global.player.<player.uuid>].contains[economy.premium]>:
                - run premium_currency_global_set def:<player>|0

## Internal ##
premium_currency_global_get:
    type: procedure
    definitions: player
    script:
        - determine <yaml[global.player.<[player].uuid>].read[economy.premium]>

## Internal ##
premium_currency_global_set:
    type: task
    definitions: player|amount
    script:
        - run global_player_data_modify def:<[player].uuid>|economy.premium|<[amount]>

## External ##
# % ██ [ Give player curency ] ██
premium_currency_give:
    type: task
    definitions: player|amount
    script:
        - define currentBal <proc[premium_currency_global_get].context[<[player]>]>
        - define newBal <[currentBal].add[<[amount]>]>
        - run premium_currency_global_set def:<[player]>|<[newBal]>
        - narrate "<&a><[amount]> <script[premium_currency_command].data_key[name]> has been deposited to you're account" targets:<[player]>

## External ##
# % ██ [ Remove player curency ] ██
#- Returns false if it fails to remove the currency -#
premium_currency_remove:
    type: task
    definitions: player|amount
    script:
        - define currentBal <proc[premium_currency_global_get].context[<[player]>]>
        - define newBal <[currentBal].sub[<[amount]>]>
        - if <[newBal]> < 0:
            - determine false
        - run premium_currency_global_set def:<[player]>|<[newBal]>
        - narrate "<&c><[amount]> <script[premium_currency_command].data_key[name]> has been deducted from you're account" targets:<[player]>
        - determine true

## External ##
# % ██ [ Set player curency ] ██
#- Returns false if it fails to set the currency -#
premium_currency_set:
    type: task
    definitions: player|amount
    script:
        - if <[amount]> < 0:
            - determine false
        - run premium_currency_global_set def:<[player]>|<[amount]>
        - narrate "<&b>You're account has been set to <[amount]> <script[premium_currency_command].data_key[name]>" targets:<[player]>
        - determine true