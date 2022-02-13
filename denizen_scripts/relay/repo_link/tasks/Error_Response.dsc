Error_Response_Webhook:
  type: task
  debug: false
  definitions: Data
  script:
  # $ ██ [ Verify Server       ] ██
    - if !<script.list_keys[Channel_Map].contains[<[Data].get[Server]>]>:
      - stop

  # % ██ [ Organize Definitions    ] ██
    - define channel_id <script.data_key[Channel_Map.<[Data].get[Server]>]>
    - define Server <[Data].get[Server]>
    - define UUID <util.random.duuid.after[_]>
    - define File_Location ../../web/webget/
    - define Message <[Data].get[Message]>
    - define Body_text "<list.include_single[<&gt> **Error Message**<&co> `<[Message]>`<&nl>]>"
    - define embed <map>
    - define fields <list>

  # % ██ [ Generate Log        ] ██
    - log <[Message]> type:none file:<[File_Location]><[UUID]>.txt
    - define Log_URL http://147.135.7.85:25581/webget?name=<[UUID]>.txt

  # % ██ [ Verify Script Fields    ] ██
    - if <[Data].keys.contains[Script]>:
      - define Script_Name <[Data].get[Script].get[Name]>
      - define Script_Line <[Data].get[Script].get[Line]>
      - define Script_File_Location <[Data].get[Script].get[File_Location]>
      - if <[Script_File_Location].after[/plugins/Denizen/scripts/].starts_with[global]>:
        - define File_Link https://github.com/Adriftus-Studios/network-script-data/blob/stage/denizen_scripts/global/server/<[Script_File_Location].after[/scripts/global/server/].replace[<&sp>].with[<&pc>20]>#L<[Script_Line]>
        - define File_Directory global/<[Script_File_Location].after[/scripts/global/server/]>
      - else if <[Server]> == test:
        - define File_Link https://github.com/Adriftus-Studios/test/blob/main/<[Script_File_Location].after[/plugins/Denizen/scripts/<[Server]>/].replace[<&sp>].with[<&pc>20]>#L<[Script_Line]>
        - define File_Directory /<[Script_File_Location].after[/plugins/Denizen/scripts/<[Server]>/]>
      - else:
        - define File_Link https://github.com/Adriftus-Studios/network-script-data/blob/stage/denizen_scripts/<[Server]>/<[Script_File_Location].after[/plugins/Denizen/scripts/<[Server]>/].replace[<&sp>].with[<&pc>20]>#L<[Script_Line]>
        - define File_Directory /<[Script_File_Location].after[/plugins/Denizen/scripts/<[Server]>/]>
      - define fields <[fields].include_single[<map.with[name].as[Script<&co>].with[value].as[`<[Script_Name]>`].with[inline].as[true]>]>
      - define fields <[fields].include_single[<map.with[name].as[Line<&co>].with[value].as[`#<[Script_Line]>`].with[inline].as[true]>]>
      - define fields <[fields].include_single[<map.with[name].as[File<&co>].with[value].as[<&lb>`<&lb><[File_Directory]><&rb>`<&rb>(<[File_Link]>)].with[inline].as[true]>]>
      - define embed "<[embed].with[footer].as[<map.with[text].as[Script Error Count (*/hr)<&co> <[Data].get[Script].get[Error_Count]>]>]>"

      - define Title_Text "<&lb>BORKED<&rb> <[Script_Name]> error on <[Server].to_titlecase>"
      - define Body_Text "<[Body_Text].include_single[<&gt> **Script Name**<&co> `<[Script_Name]>`<&nl><&gt> **Script Reference**<&co>  <&lb>`<[File_Directory]>`<&rb>(<[File_Link]>)<&nl><&gt> **Script Line**<&co> `<[Script_Line]>`<&nl>]>"
    - else:
      - define Title_Text "<&lb>BORKED<&rb> Error on <[Server].to_titlecase>"
      - define fields "<[fields].with[name].as[<map.with[Note<&co>].with[value].as[`Different Queue Callback`].with[inline].as[true]>]>"

  # % ██ [ Verify Player Fields    ] ██
    - if <[Data].keys.contains[Player]>:
      - define Player_Name <[Data].get[Player].get[Name]>
      - define Player_UUID <[Data].get[Player].get[UUID]>
      - define fields "<[fields].include_single[<map.with[name].as[Player Name<&co>].with[value].as[`<[Player_Name]>`].with[inline].as[true]>]>"
      - define fields "<[fields].include_single[<map.with[name].as[Player UUID<&co>].with[value].as[`<[Player_UUID]>`].with[inline].as[true]>]>"
      - define embed "<[embed].with[author].as[<map.with[name].as[Player Attached<&co> <[Player_Name]>]>]>"
      - define embed <[embed].with[thumbnail].as[<map.with[url].as[https://minotar.net/avatar/<[Player_Name]>/32.png]>]>

      - define Body_Text "<[Body_Text].include_single[<&gt> **Player Attached**<&co> `<[Player_Name]>` / `<[Player_UUID]>`<&nl>]>"

  # % ██ [ Verify Definition Fields  ] ██
    - if <[Data].keys.contains[Definition_Map]> && !<[Data].get[Definition_Map].is_empty>:
      - define Definition_Map <[Data].get[Definition_Map]>
      - define fields <[fields].include_single[<map.with[name].as[Definitions<&co>].with[value].as[```yml<n><proc[object_formatting].context[<list_single[<[Definition_Map]>].include[0]>].strip_color><n>```]>]>

  # % ██ [ Create Issue Template Link ] ██
    - define Issue_URL_Base https://github.com/Adriftus-Studios/network-script-data/issues/new?labels=Borked&
    - define Body_Text "<[Body_Text].include_single[<&lt>!--- Remove any sections that don't apply or you have inadequate information for. ---<&gt><&nl><&lt>!--- Add any other context about the problem below. ---<&gt><&nl><&nl>]>"
    - define Issue_URL <[Issue_URL_Base]>title=<[Title_Text].url_encode>&body=<[Body_Text].unseparated.url_encode>
    - define fields "<[fields].include_single[<map.with[name].as[Create Issue].with[value].as[<&lb>`<&lb>Click to Generate Issue Template<&rb>`<&rb>(<[Issue_URL]>) for this error report.]>]>"

  # % ██ [ Submit Message      ] ██
    - define headers <yaml[saved_headers].parsed_key[discord.Bot_Auth]>
    - define url https://discordapp.com/api/channels/<[channel_id]>/messages
    - define data <map.with[embed].as[<[embed].include[<script.parsed_key[embed]>]>].to_json>
    - ~webget <[url]> method:post data:<[data]> headers:<[headers]> save:response

  embed:
    title: "`[Click for Log]` <[Server].to_titlecase> Error Response:"
    url: <[Log_URL]>
    color: 5820671
    description: <[Message]||>
    fields: <[fields]||>

  Channel_Map:
  #$  xeane: 744713622642491433
    hub: 744711708077064203
    behrcraft: 744711666142543953
    survival: 744711692570853467
    relay: 744711732433387602
    test: 757180343244816454
    resort: 763228068789223424
