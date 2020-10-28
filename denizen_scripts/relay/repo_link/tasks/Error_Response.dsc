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
    - define embed <discordembed>

  # % ██ [ Generate Log        ] ██
    - log <[Message]> type:none file:<[File_Location]><[UUID]>.txt
    - define Log_URL http://147.135.7.85:25580/webget?name=<[UUID]>.txt

  # % ██ [ Verify Script Fields    ] ██
    - if <[Data].keys.contains[Script]>:
      - define Script_Name <[Data].get[Script].get[Name]>
      - define Script_Line <[Data].get[Script].get[Line]>
      - define Script_File_Location <[Data].get[Script].get[File_Location]>
      - if <[Script_File_Location].after[/plugins/Denizen/scripts/].starts_with[global]>:
        - define File_Link https://github.com/Adriftus-Studios/network-script-data/blob/master/denizen_scripts/global/server/<[Script_File_Location].after[/scripts/global/server/].replace[<&sp>].with[<&pc>20]>#L<[Script_Line]>
        - define File_Directory global/<[Script_File_Location].after[/scripts/global/server/]>
      - else:
        - define File_Link https://github.com/Adriftus-Studios/network-script-data/blob/master/denizen_scripts/<[Server]>/<[Script_File_Location].after[/plugins/Denizen/scripts/].replace[<&sp>].with[<&pc>20]>#L<[Script_Line]>
        - define File_Directory <[Server]>/./<[Script_File_Location].after[/plugins/Denizen/scripts/]>
      - define embed <[embed].inline_fields[<map.with[Script<&co>].as[`<[Script_Name]>`]>]>
      - define embed <[embed].inline_fields[<map.with[Line<&co>].as[`#<[Script_Line]>`]>]>
      - define embed <[embed].inline_fields[<map.with[File<&co>].as[<&lb>`<&lb><[File_Directory]><&rb>`<&rb>(<[File_Link]>)]>]>
      - define embed "<[embed].footer_text[Script Error Count (*/hr)<&co> <[Data].get[Script].get[Error_Count]>]>"
      
      - define Title_Text "<&lb>BORKED<&rb> <[Script_Name]> error on <[Server].to_titlecase>"
      - define Body_Text "<[Body_Text].include_single[<&gt> **Script Name**<&co> `<[Script_Name]>`<&nl><&gt> **Script Reference**<&co>  <&lb>`<[File_Directory]>`<&rb>(<[File_Link]>)<&nl><&gt> **Script Line**<&co> `<[Script_Line]>`<&nl>]>"
    - else:
      - define Title_Text "<&lb>BORKED<&rb> Error on <[Server].to_titlecase>"
      - define embed "<[embed].inline_fields[<map.with[Note<&co>].as[`Different Queue Callback`]>]>"

  # % ██ [ Verify Player Fields    ] ██
    - if <[Data].keys.contains[Player]>:
      - define Player_Name <[Data].get[Player].get[Name]>
      - define Player_UUID <[Data].get[Player].get[UUID]>
      - define embed "<[embed].inline_fields[<map.with[Player Name<&co>].as[`<[Player_Name]>`]>]>"
      - define embed "<[embed].inline_fields[<map.with[Player UUID<&co>].as[`<[Player_UUID]>`]>]>"
      - define embed "<[embed].author_name[Player Attached<&co> <[Player_Name]>]>"
      - define embed <[embed].thumbnail_url[https://minotar.net/avatar/<[Player_Name]>/32.png]>

      - define Body_Text "<[Body_Text].include_single[<&gt> **Player Attached**<&co> `<[Player_Name]>` / `<[Player_UUID]>`<&nl>]>"

  # % ██ [ Verify Definition Fields  ] ██
    - if <[Data].keys.contains[Definition_Map]> && !<[Data].get[Definition_Map].is_empty>:
      - define Definition_Map <[Data].get[Definition_Map]>
      - define Definition_List <list>
      - foreach <[Definition_Map]> key:Definition as:Save:
        - define Definition_List "<[Definition_List].include_single[- <[Definition]>: <[Save]>]>"
      - define embed <[embed].fields[<map.with[Definitions<&co>].as[```yml<&nl><[Definition_List].separated_by[<&nl>]><&nl>```]>]>
  
  # % ██ [ Create Issue Template Link ] ██
    - define Issue_URL_Base https://github.com/Adriftus-Studios/network-script-data/issues/new?labels=Borked&
    - define Body_Text "<[Body_Text].include_single[<&lt>!--- Remove any sections that don't apply or you have inadequate information for. ---<&gt><&nl><&lt>!--- Add any other context about the problem below. ---<&gt><&nl><&nl>]>"
    - define Issue_URL <[Issue_URL_Base]>title=<[Title_Text].url_encode>&body=<[Body_Text].unseparated.url_encode>
    - define embed "<[embed].fields[<map.with[Create Issue].as[<&lb>`<&lb>Click to Generate Issue Template<&rb>`<&rb>(<[Issue_URL]>)for this error report.]>]>"

  # % ██ [ Construct Embed       ] ██
    - define embed "<[embed].title[`[Click for Log]` <[Server].to_titlecase> Error Response:]>"
    - define embed <[embed].url[<[Log_URL]>]>
    - define embed <[embed].description[<[Message]>]>
    - define embed <[embed].color[5820671]>

  # % ██ [ Submit Message      ] ██
    - narrate "channel id: <[channel_id]>"
    - narrate "embed: <[embed]>"
    - discord id:adriftusbot send_embed channel:<[channel_id]> embed:<[embed]>
  Channel_Map:
    hub1: 744711708077064203
    behrcraft: 744711666142543953
    survival: 744711692570853467
    relay: 744711732433387602
  #$  xeane: 744713622642491433
    test: 757180343244816454
    resort: 763228068789223424
