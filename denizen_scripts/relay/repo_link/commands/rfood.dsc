RFood_DCommand:
  type: task
  PermissionRoles:
    - Everyone
  definitions: Message|Channel|Author|Group
  debug: false
  icons:
    - https://cdn.discordapp.com/attachments/625076684558958638/746849947382448288/icons8-kawaii-rice-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849948926214265/icons8-kawaii-taco-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849950985617587/icons8-kawaii-noodle-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849952252297286/icons8-kawaii-cupcake-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849954370289704/icons8-kawaii-jam-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849956740202627/icons8-kawaii-bread-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849960489910382/icons8-kawaii-croissant-96.png
    - https://cdn.discordapp.com/attachments/625076684558958638/746849962515759136/icons8-kawaii-milk-96.png
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
  #^- inject Role_Verification
    - inject Command_Arg_Registry
    - define UserID <[Author].ID>
    - define Headers <list[User-Agent/really|Authorization/Bot<&sp><yaml[AdriftusBot_temp].read[AdriftusBotToken]>]>
    - ~webget https://discordapp.com/api/users/<[UserID]> Headers:<[Headers]> save:Response
    - Define UserPFP https://cdn.discordapp.com/avatars/<[UserID]>/<util.parse_yaml[<entry[Response].result>].get[avatar]>
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - define channel_id <[channel]>
    - inject get_webhooks
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>

  # % ██ [ Verify Arguments            ] ██
    - if <[Args].size> == 0:
      - define Food <server.flag[Data.Lists.Foods].random>
      - define Message "<&lt>:hambehrgeur:732716255567413309<&gt><&sp>Your random food selection<&co><&nl><[Food]>!"
    - else if <[Args].first> == Add:
      - define Suggestion "<[Message].after[add ].replace[`].with[']>"
      - flag server Data.Lists.Foods:->:<[Suggestion]>
      - define Message "<&lt>:hambehrgeur:732716255567413309<&gt><&sp> Added `<[Suggestion]>` to your delicious randomizer listo thingo!"
    - else if <[Args].first.is_integer> && <[Args].first> >= 0:
      - define Food_List <server.flag[Data.Lists.Foods].random[<[Args].first>]>
      - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> Your random list of food selections: <[Food_List].formatted>"
    - else if <[Args].first> == Shots:
      - if <[Args].get[2].contains[-]||false> && <[Args].get[2].before[-].is_integer> && <[Args].get[2].after[-].is_integer> && <[Args].get[2].before[-]> >= 0 && <[Args].get[2].before[-]> < <[Args].get[2].after[-]>:
        - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> The number of shots to take: <util.random.int[<[Args].get[2].before[-]>].to[<[Args].get[2].after[-]>]>"
      - else if <[Args].get[2].is_integer||false> && <[Args].get[2]> > 0:
        - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> The number of shots to take: <util.random.int[0].to[<[Args].get[2]>]>"
      - else:
        - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> The number of shots to take: <util.random.int[0].to[9]>"
    - else if <[Args].first> == List:
      - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> The list of foods: <server.flag[Data.Lists.Foods].formatted>"
    - else if <[Args].first> == Remove:
      - if <server.flag[Data.Lists.Foods].contains[<[Message].after[remove<&sp>]>]>:
        - flag server Data.Lists.Foods:<-:<[Message].after[remove<&sp>]>
        - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> Removed `<[Message].after[remove<&sp>]>` from your delicious randomizer listo thingo!"
      - else:
        - define Message "<&lt>:hambehrgeur:732716255567413309<&gt> Error: `<[Message].after[remove<&sp>]>` is not in the list of foods"
    - else if <[Args].first> == Help:
      - define Data <yaml[SDS_FoodDCmd].to_json>
      - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
      - stop
    # Other Definitions
    - define color Yellow
    - inject Embedded_Color_Formatting
    - define Author <map.with[name].as[<[Author].name>].with[icon_url].as[<[UserPFP]>]>
    - define Embeds <list[<map.with[color].as[<[Color]>].with[description].as[<[Message]>].with[author].as[<[Author]>]>]>
    - define Data <map.with[username].as[Food<&sp>Support].with[avatar_url].as[<script.data_key[icons].random>].with[embeds].as[<[Embeds]>].to_json>

    # normal webget
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
