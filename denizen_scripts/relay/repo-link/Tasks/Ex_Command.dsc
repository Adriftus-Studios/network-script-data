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
    script:
# - ██ [ Clean Definitions & Inject Dependencies ] ██
        - inject Role_Verification
        - inject Command_Arg_Registry
        
# - ██ [ Verify Arguments                        ] ██
        - if <[Args].is_empty>:
            - stop
        - else if <[Args].size> == 1:
            - define server Relay
            - define Command "ex <[Args].space_separated>"
            - execute as_server <[Command]>
        - else:
            - if !<bungee.list_servers.contains[<[Args].first>]>:
                - define server Relay
                - define Command "ex <[Args].space_separated>"
                - execute as_server <[Command]>
            - else:
                - if <bungee.list_servers.contains[<[Args].first>]>:
                    - define Server <[Args].first>
                    - define Command "ex <[Args].remove[1].space_separated>"
                    - bungee <[Server]>:
                        - execute as_server <[Command]>
    
        - define color Code
        - inject Embedded_Color_Formatting
        - define Embeds "<list_single[<map[color/<[Color]>].with[description].as[Command ran: `/<[Command]>`]>]>"
        - define Data <map.with[username].as[<[Server].to_titlecase><&sp>Server].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
