Webget_DCommand:
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
    script:
# - ██ [ Clean Definitions & Inject Dependencies ] ██
        - inject Role_Verification
        - inject Command_Arg_Registry
        
# - ██ [ Verify Arguments                        ] ██
        - if <[Args].is_empty>:
            - stop
        - if <[Args].size> == 1 || <[Args].size> > 6:
            - stop

        - define URL <[Args].first>
        - foreach <list[Data|Headers]> as:ArgDef:
            - if !<[Args].filter[starts_with[<[ArgDef]>:]].is_empty>:
                - define <[ArgDef]> <[Args].get[<[Args].find[<[Args].filter[starts_with[<[ArgDef]>:]].first>]>].after[<[ArgDef]>:]>

        - if <[Data].exists> && !<[Headers].exists>:
            - ~webget <[URL]> data:<[Data]> save:Response
        - else if <[Data].exists> && <[Headers].exists>:
            - ~webget <[URL]> data:<[Data]> headers:<[Headers].parsed> save:Response

        - define EntryResults <list[]>
        - if <[Args].contains_any[-f|-failed]>:
            - define EntryResults "<[EntryResults].include[<&nl>**Failed Status**: `<entry[Response].failed||Invalid Save Entry>`]>"
        - if <[Args].contains_any[-s|-status]>:
            - define EntryResults "<[EntryResults].include[<&nl>**HTTP Status**: `<entry[Response].status||Invalid Save Entry>`]>"
        - if <[Args].contains_any[-r|-result]>:
            - define EntryResults "<[EntryResults].include[<&nl>**Result Status**: `<entry[Response].result||Invalid Save Entry>`]>"

        - define color Code
        - inject Embedded_Color_Formatting
        - define Embeds "<list[<map[color/<[Color]>].with[description].as[Command ran: `/WebGet <[Args].space_separated>`<[EntryResults].unseparated>]>]>"
        - define Data "<map[username/WebGet Command Response|avatar_url/https://img.icons8.com/nolan/64/buysellads.png].with[embeds].as[<[Embeds]>].to_json>"

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

#| {
#|   "embeds": [
#|     {
#|       "description": ":hamburger: Notes can be saved by typing `/note `, followed by your note.\nYou can delete or remove this note by clicking the `X` in the example above.",
#|       "author": {
#|         "name": "Bear",
#|         "icon_url": "https://cdn.discordapp.com/attachments/547556605328359455/603671749917147136/rainbow.gif"
#|       }
#|     }
#|   ],
#|   "username": "NoteHook",
#|   "avatar_url": "https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png"
#| }