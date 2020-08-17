Note_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group
  debug: false
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    
  # % ██ [ Verify Arguments            ] ██
    - if <[Args].size> == 0:
      - stop

    - if !<script[DDTBCTY].list_keys[WebHooks].contains[<[Channel]>]>:
      - stop
    - define UserID <[Author].ID>
    - define Headers <list[User-Agent/really|Authorization/Bot<&sp><yaml[AdriftusBot_temp].read[AdriftusBotToken]>]>

    - ~webget https://discordapp.com/api/users/<[UserID]> Headers:<[Headers]> save:Response
    - Define UserPFP https://cdn.discordapp.com/avatars/<[UserID]>/<util.parse_yaml[<entry[Response].result>].get[avatar]>
    - inject Web_Debug.Webget_Response

    - define Message <&lt>:hambehrgeur:732716255567413309<&gt><&sp><[Message].after[/note<&sp>]>
    - define color Yellow
    - inject Embedded_Color_Formatting
    - define Author <map.with[name].as[<[Author].name>].with[icon_url].as[<[UserPFP]>]>
    - define Embeds <list[<map.with[color].as[<[Color]>].with[description].as[<[Message]>].with[author].as[<[Author]>]>]>
    - define Data <map.with[username].as[NoteHook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[Embeds]>].to_json>

    - define Hook <script[DDTBCTY].data_key[WebHooks.731607719165034538.hook]>
    - define headers <list[User-Agent/really|Content-Type/application/json]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>


    - define Message "Note saved to: <&lt>#731607719165034538<&gt><&nl><&gt> `<[Message].after[<&lt>:hambehrgeur:732716255567413309<&gt><&sp>]>`"
    - define Embeds <list[<map.with[color].as[<[Color]>].with[description].as[<[Message]>].with[author].as[<[Author]>]>]>
    - define Data <map.with[username].as[NoteHook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[Embeds]>].to_json>

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <list[User-Agent/really|Content-Type/application/json]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
