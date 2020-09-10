Players_DCommand:
    type: task
    definitions: Message|Channel|Author|Group
    error:
        - define definitions <map.with[text].as[<[text]>].with[color].as[red].with[title].as[Invalid<&sp>Usage].with[channel].as[<[channel]>].with[username].as[<[username]>]>
        - run webhook_generic def:<list[title_description].include_single[<[definitions]>]>
        - stop
    script:
    # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject command_arg_registry

    # % ██ [ cache data ] ██
    - define color yellow
    - define title "Online Players"
    - define username "Adriftus Network Info"

    - if <[args].is_empty> || ( <[args].size> == 1 && <list[all|network|everyone|everywhere].contains[<[args].first>]> ):
        - define server_list <list[hub1|survival|behrcraft]>
    - else if <[args].size> == 1:
        - define text <list>
        - if <[args].first.split[|].is_empty>:
            - define text "**Invalid Server Specified**.<n>Command syntax: `/players (<&lt>server<&gt>(|...))`"
            - inject locally error
        - foreach <[args].first.split[|]> as:server:
            - if !<yaml[bungee_config].contains[servers.<[Server]>]>:
                - define text "**Invalid Server Specified**.<n>Command syntax: `/players (<&lt>server<&gt>(|...))`"
                - inject locally error
            - else if !<bungee.list_servers.contains[<[server]>]>:
                - if <bungee.list_servers.shared_contents[hub1|survival|behrcraft].is_empty>:
                    - define text "**No servers online.**"
                - else:
                    - define text "**Server is Offline**: `<[server]>`.<n> Available Live Servers: <bungee.list_servers.shared_contents[hub1|survival|behrcraft].formatted>"
                - inject locally error
            - else:
                - define server_list:->:<[server]>
    - else:
        - define text "Command syntax: `/players (<&lt>server<&gt>(|...))`"
        - inject locally error

    - define servers <map>
    - foreach <[server_list]> as:server:
        - ~bungeetag server:<[server]> <server.online_players.parse[name].map_with[<server.online_players.parse[display_name.strip_color]>]> save:map
        - if <entry[map].result||invalid> == invalid || <entry[map].result.is_empty>:
            - foreach next
        - else:
            - define players <list>
            - foreach <entry[map].result> key:name as:nickname:
                - if <[name]> == <[nickname]>:
                    - define player "- <[name]>"
                - else:
                    - define player "- <[nickname]> (<[name]>)"
                - define players <[players].include_single[<[player]>]>
            - define servers <[servers].with[<[server].to_titlecase>].as[<[players]>]>
    - if <[servers].is_empty>:
        - define "text:->:No Players Online."
    - else:
        - define text <list>
        - foreach <[servers]> key:server as:players:
            - if <[players].size> == 1:
                - define text "<[text].include_single[**<[server]>**  |  1 player:]>"
            - else:
                - define text "<[text].include_single[**<[server]>**  |  <[players].size> players:]>"
            - define text <[text].include[```md<n>].include_single[<[players].separated_by[<n>]>].include[<n>```]>
    - define definitions <map.with[text].as[<[text].separated_by[<n>]>].with[color].as[<[color]>].with[title].as[<[title]>].with[channel].as[<[channel]>].with[username].as[<[username]>]>
    - run webhook_generic def:<list[title_description].include_single[<[definitions]>]>
    
