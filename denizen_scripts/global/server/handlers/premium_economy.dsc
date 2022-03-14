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
            - narrate "<&b><[player].name> <[currencyName]> balance is: <proc[premium_currency_global_get_current].context[<[player]>].round_to[2]>"

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
                    - run premium_currency_give "def:<[player]>|<context.args.get[3]>|COMMAND by <player.name> (<player.uuid>)"
                    - narrate "<&a>Successfully deposited <context.args.get[3]> <[currencyName]> to <[player].name>'s account"
                - case remove:
                    - run premium_currency_remove "def:<[player]>|<context.args.get[3]>|COMMAND by <player.name> (<player.uuid>)" save:outcome

                    # % ██ [ Check if the balance was removed successfully ] ██
                    - if <entry[outcome].created_queue.determination.first>:
                        - narrate "<&a>Successfully removed <context.args.get[3]> <[currencyName]> from <[player].name>'s account"
                    - else:
                        - narrate "<&c><[player].name> does not have enough funds, to remove <context.args.get[3]> <[currencyName]>"
                - case set:
                    - run premium_currency_set "def:<[player]>|<context.args.get[3]>|COMMAND by <player.name> (<player.uuid>)" save:outcome

                    # % ██ [ Check if the balance was set successfully ] ██
                    - if <entry[outcome].created_queue.determination.first>:
                        - narrate "<&a>Successfully set <[player].name>'s account to <context.args.get[3]> <[currencyName]>"
                    - else:
                        - narrate "<&c>You cannot set account balance below 0 <[currencyName]>"

        # % ██ [ Print current players balance ] ██
        - else:
            - narrate "<&b>Your <[currencyName]> balance is: <player.proc[premium_currency_display]>"

## Internal ##
premium_currency_global_get_current:
    type: procedure
    definitions: player
    script:
        - determine <yaml[global.player.<[player].uuid>].read[economy.premium.current].if_null[0]>
## Internal ##
premium_currency_global_get_lifetime:
    type: procedure
    definitions: player
    script:
        - determine <yaml[global.player.<[player].uuid>].read[economy.premium.lifetime].if_null[0]>

## External ##
# % ██ [ Give player curency ] ██
premium_currency_give:
    type: task
    definitions: player|amount|reason
    script:
        - if !<[reason].exists>:
          - debug error "Script tried to give premium currency wtihout specifying a reason."
          - stop
        - define currentBal <yaml[global.player.<[player].uuid>].read[economy.premium.current].if_null[0]>
        - define lifetimeBal <yaml[global.player.<[player].uuid>].read[economy.premium.lifetime].if_null[0]>
        - define newBal <[currentBal].add[<[amount]>]>
        - define newLifetime <[lifetimeBal].add[<[amount]>]>
        - define map <map[economy.premium.current=<[newBal]>;economy.premium.lifetime=<[newLifetime]>]>
        - run global_player_data_modify_multiple def:<[player].uuid>|<[map]>
        - define message "SEARCHABLE_<[player].uuid>```<[player].name> has been given <[amount]> Premium Currency<&nl>Reason<&co> <[reason]>```"
        - bungeerun relay discord_sendMessage "def:Adriftus Staff|manager-logs|<[message].escaped>"

## External ##
# % ██ [ Remove player curency ] ██
#- Returns false if it fails to remove the currency -#
premium_currency_remove:
    type: task
    definitions: player|amount|reason
    script:
        - if !<[reason].exists>:
          - debug error "Script tried to give premium currency wtihout specifying a reason."
          - determine false
        - define currentBal <yaml[global.player.<[player].uuid>].read[economy.premium.current].if_null[0]>
        - define newBal <[currentBal].sub[<[amount]>]>
        - if <[newBal]> < 0:
          - debug error "Script tried to take premium currency without checking the balance first."
          - determine false
        - run global_player_data_modify def:<[player].uuid>|economy.premium.current|<[amount]>
        - define message "SEARCHABLE_<[player].uuid>```<[player].name> has spent <[amount]> Premium Currency<&nl>Reason<&co> <[reason]>```"
        - bungeerun relay discord_sendMessage "def:Adriftus Staff|manager-logs|<[message].escaped>"
        - determine true

## External ##
# % ██ [ Set player curency ] ██
#- Returns false if it fails to set the currency -#
premium_currency_set:
    type: task
    definitions: player|amount|reason
    script:
        - if !<[reason].exists>:
          - debug error "Script tried to give premium currency wtihout specifying a reason."
          - determine false
        - if <[amount]> < 0:
          - determine false
        - run global_player_data_modify def:<[player].uuid>|economy.premium.current|<[amount]>
        - define message "SEARCHABLE_<[player].uuid>```<[player].name> was set to <[amount]> Premium Currency<&nl>Reason<&co> <[reason]>```"
        - bungeerun relay discord_sendMessage "def:Adriftus Staff|manager-logs|<[message].escaped>"
        - determine true

premium_currency_can_afford:
  type: procedure
  debug: false
  definitions: player|amount
  script:
    - define balance <yaml[global.player.<[player].uuid>].read[economy.premium.current].if_null[0]>
    - determine <[amount].is_less_than_or_equal_to[<[balance]>]>

premium_currency_display:
  type: procedure
  debug: false
  definitions: player
  script:
    - define balance <yaml[global.player.<[player].uuid>].read[economy.premium.current].if_null[0]>
    - determine "<&6><[balance]> Ⓐ"