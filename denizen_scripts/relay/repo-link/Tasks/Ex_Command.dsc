Ex_DCommand:
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
    debug: false
    Context: Color
    speed: 0
    script:
# - ██ [ Clean Definitions & Inject Dependencies ] ██
        - define Message <[Message].unescaped>
        - inject Role_Verification
        - inject Command_Arg_Registry
        
# - ██ [ Verify Arguments                        ] ██
        - if <[Args].is_empty>:
            - stop
        - else if <[Args].size> == 1:
            - define server Relay
            - define Command "ex <[Args].space_separated>"
            - execute as_server "<[Command]>"
        - else:
            - if !<bungee.list_servers.contains[<[Args].first>]>:
                - define server Relay
                - define Command "ex <[Args].space_separated>"
                - execute as_server "<[Command]>"
            - else:
                - if <bungee.list_servers.contains[<[Args].first>]>:
                    - define Server <[Args].first>
                    - define Command "ex <[Args].remove[1].space_separated>"
                    - bungee <[Server]>:
                        - execute as_server "<[Command]>"

# - ██ [ Send Embedded Message                   ] ██
        #- run Embedded_Discord_Message def:Command_Ran|<[Channel]>|<list[Color/Code|Author/<[Author].Name>|Server/<[Server].to_titlecase>|Command/].escaped>

        
        - define color Code
        - inject Embedded_Color_Formatting
        - define Embeds "<list[<map[color/<[Color]>].with[description].as[Command ran: `/<[Command]>`]>]>"
        - define Data <map[username/<[Server]><&sp>Server|avatar_url/https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
