RFood_DCommand:
  type: task
  PermissionRoles:
    - Everyone
  definitions: Message|Channel|Author|Group
  debug: false
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
  #^- inject Role_Verification
    - inject Command_Arg_Registry
    - define UserID <[Author].ID>
    - define Headers <list[User-Agent/really|Authorization/Bot<&sp><yaml[AdriftusBot_temp].read[AdriftusBotToken]>]>
    - ~webget https://discordapp.com/api/users/<[UserID]> Headers:<[Headers]> save:Response
    - Define UserPFP https://cdn.discordapp.com/avatars/<[UserID]>/<util.parse_yaml[<entry[Response].result>].get[avatar]>

  # % ██ [ Verify Arguments            ] ██
    - if !<script[DDTBCTY].list_keys[WebHooks].contains[<[Channel]>]>:
      - stop

    - if <[Args].size> == 0:
      - define Food <server.flag[Data.Lists.Foods].random>
      - define Message "<&lt>:hambehrgeur:732716255567413309<&gt><&sp>Your random food selection<&co><&nl><[Food]>!"
    - else if <[Args].first> == Add:
      - define Suggestion "<[Message].after[add ].replace[`].with[']>"
      - flag server Data.Lists.Foods:->:<[Suggestion]>
      - define Message "<&lt>:hambehrgeur:732716255567413309<&gt><&sp> Added `<[Suggestion]>` to your delicious randomizer listo thingo!"

    - define color Yellow
    - inject Embedded_Color_Formatting
    - define Author <map.with[name].as[<[Author].name>].with[icon_url].as[<[UserPFP]>]>
    - define Embeds <list[<map.with[color].as[<[Color]>].with[description].as[<[Message]>].with[author].as[<[Author]>]>]>
    - define Data <map.with[username].as[NoteHook].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[Embeds]>].to_json>

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define headers <list[User-Agent/really|Content-Type/application/json]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
