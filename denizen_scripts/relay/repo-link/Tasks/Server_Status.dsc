Status_DCommand:
    type: task
    PermissionRoles:
# - ██ [ Staff Roles  ] ██
        - Lead Developer
        - External Developer
        - Developer

# - ██ [ Public Roles ] ██
        - Lead Developer
        - Developer
    definitions: Message|Channel|Author|Group
    debug: true
    speed: 0
    script:
# - ██ [ Clean Definitions & Inject Dependencies ] ██
        - inject Role_Verification
        - inject Command_Arg_Registry
        
# - ██ [ Verify Arguments                        ] ██
        - if <[Args].is_empty>:
            - define Server Relay
        - else:
            - define Server <[Args].first>

# - ██ [ Build Data                              ] ██
        - if !<yaml[bungee_config].list_keys[servers].contains[<[Args].first>]>:
            - define Data "<map[title/Invalid Server]>"
        - else if !<bungee.list_servers.contains[<[Args].first>]>
            - define Data "<map[title/Server Offline]>"
        - else:
            - ~bungeetag server:<[Server]> <bungee.connected> save:Status
        
        - if <entry[Status].result||false>:
            - define color Green
        - else:
            - define color Red

        - define Data <map[title/Greetings]>
        - define Data <[Data].with[color].as[Green]>
        - define Data <[Data].with[description].as[Hello!]>
        - define Data <[Data].with[time].as[Default]>

        - define Data <list[<[Channel]>].include[<[Data]>]>
        - bungeerun Relay Embedded_Discord_Message_New def:<[Data]>

        - define Data <list[626098849127071746].include[<map[avatar_url/https://img.icons8.com/nolan/64/source-code.png|username/<[Server]> Server Status|description/hello]>]>
        - run Embedded_Discord_Message_New def:<[Data]>
