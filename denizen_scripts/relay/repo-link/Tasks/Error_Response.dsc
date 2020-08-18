Error_Response_Webhook:
    type: task
    debug: false
    Headers:
        User-Agent: Adriftus
        Content-Type: application/json
    definitions: Data
    script:
    # $ ██ [ Verify Server             ] ██
        - if !<script.list_keys[Channel_Map].contains[<[Data].get[Server]>]>:
            - stop

    # % ██ [ Organize Definitions      ] ██
        - define Server <[Data].get[Server]>
        - define Group <script.data_key[AGDev]>
        - define Channel <script.data_key[Channel_Map.<[Data].get[Server]>]>
        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define Headers <script.data_key[Headers]>
        - define UUID <util.random.duuid.after[_]>
        - define File_Location ../../web/webget/
        - define Message <[Data].get[Message]>
        - define Body_text "<list.include_single[<&gt> **Error Message**<&co><&nl><&nl>`<[Message]>`<&nl><&nl>]>"

    # % ██ [ Generate Log              ] ██
        - log <[Message]> type:none file:<[File_Location]><[UUID]>.txt
        - define Log_URL http://147.135.7.85:25580/webget?name=<[UUID]>.txt

    # % ██ [ Organize Fields           ] ██
        - define Embed_Maps <map>
        - define Field_List <list>
        - define DUUID <util.random.duuid>
        - yaml id:<[DUUID]> create

    # % ██ [ Verify Script Fields      ] ██
        - if <[Data].keys.contains[Script]>:
            - define Script_Name <[Data].get[Script].get[Name]>
            - define Script_Line <[Data].get[Script].get[Line]>
            - define Script_File_Location <[Data].get[Script].get[File_Location]>
            - if <[Script_File_Location].after[/plugins/Denizen/scripts/].starts_with[global]>:
                - define File_Link https://github.com/AuroraInteractive/network-script-data/tree/master/denizen_scripts/global/server/<[Script_File_Location].after[/scripts/global/server/]>#L<[Script_Line]>
                - define File_Directory global/<[Script_File_Location].after[/scripts/global/server/]>
            - else:
                - define File_Link https://github.com/AuroraInteractive/network-script-data/tree/master/denizen_scripts/<[Server]>/<[Script_File_Location].after[/plugins/Denizen/scripts/]>#L<[Script_Line]>
                - define File_Directory <[Server]>/./<[Script_File_Location].after[/plugins/Denizen/scripts/]>
            - define Field_List <[Field_List].include_single[<map.with[name].as[Script<&co>].with[value].as[`<[Script_Name]>`].with[inline].as[true]>]>
            - define Field_List <[Field_List].include_single[<map.with[name].as[Line<&co>].with[value].as[`#<[Script_Line]>`].with[inline].as[true]>]>
            - define Field_List <[Field_List].include_single[<map.with[name].as[File<&co>].with[value].as[<&lb>`<[File_Directory]>`<&rb>(<[File_Link]>)].with[inline].as[true]>]>
            - define Footer "<map.with[text].as[Script Error Count (*/hr)<&co> <[Data].get[Script].get[Error_Count]>]>"
            - define Embed_Maps <[Embed_Maps].include[<map.with[footer].as[<[Footer]>]>]>
            
            - define Title_Text "<&lb>BORKED<&rb><[Script_Name]> error on <[Server]>"
            - define Body_Text "<[Body_Text].include_single[<&gt> **Script Information**<&co><&nl><&nl>Script Name<&co>  `<[Script_Name]>`<&nl><&nl>Script Reference<&co>  <&lb>`<[File_Directory]>`<&rb>(<[File_Link]>)<&nl><&nl>Script Line<&co> <[Script_Line]><&nl><&nl>]>"
        - else:
            - define Title_Text "<&lb>BORKED<&rb> Error on <[Server]>"
            - define Field_List "<[Field_List].include_single[<map.with[name].as[Note:].with[value].as[Executed via `/ex`].with[inline].as[true]>]>"

    # % ██ [ Verify Player Fields      ] ██
        - if <[Data].keys.contains[Player]>:
            - define Player_Name <[Data].get[Player].get[Name]>
            - define Player_UUID <[Data].get[Player].get[UUID]>
            - define Field_List "<[Field_List].include_single[<map.with[name].as[Player Name:].with[value].as[`<[Player_Name]>`].with[inline].as[true]>]>"
            - define Field_List "<[Field_List].include_single[<map.with[name].as[Player UUID:].with[value].as[`<[Player_UUID]>`].with[inline].as[true]>]>"
            - foreach <script.parsed_key[Player_Input]>:
                - define Embed_Maps <[Embed_Maps].with[<[Key]>].as[<[Value]>]>
            - define Body_Text "<[Body_Text].include_single[<&gt> **Player Attached**<&co><&nl><&nl>`<[Player_Name]>` / `(<[Player_UUID]>`<&nl><&nl>]>"

    # % ██ [ Verify Definition Fields  ] ██
        - if <[Data].keys.contains[Definition_Map]> && !<[Data].get[Definition_Map].is_empty>:
            - define Definition_Map <[Data].get[Definition_Map]>
            - define Definition_List <list>
            - foreach <[Definition_Map]> key:Definition as:Save:
                - define Definition_List "<[Definition_List].include_single[- <[Definition]>: <[Save]>]>"
            - define Field_List <[Field_List].include_single[<map.with[name].as[Definitions:].with[value].as[```yml<&nl><[Definition_List].separated_by[<&nl>]><&nl>```]>]>
    
    # % ██ [ Create Issue Template Link ] ██
        - define Issue_URL_Base https://github.com/AuroraInteractive/network-script-data/issues/new?labels=Borked&
        - define Body_Text "<[Body_Text].include_single[<&lt>!--- Remove any sections that don't apply or you have inadequate information for. ---<&gt><&nl><&lt>!--- Add any other context about the problem below. ---<&gt><&nl><&nl>]>"
        - define Issue_URL <[Issue_URL_Base]>title=<[Title_Text].url_encode>&body=<[Body_Text].unseparated.url_encode>
        - define Field_List <[Field_List].include_single[<script.parsed_key[Control_Field]>]>

    # % ██ [ Construct Embed           ] ██
        - foreach <script.parsed_key[Message_Context]>:
            - define Embed_Maps <[Embed_Maps].with[<[key]>].as[<[value]>]>

        - define Embed_Maps <[Embed_Maps].with[fields].as[<[Field_List]>]>
        - define Map <map.include[<script.parsed_Key[Hook_Body]>].to_json>

    # % ██ [ Submit Webhook            ] ██
        - ~webget <[Hook]>?wait=true data:<[Map]> headers:<[Headers]> save:response
        - inject Web_Debug.Webget_Response
        - define Webhook_Data <util.parse_yaml[<entry[response].result>]>

    Control_Field:
        name: Create Issue
        value: <&lb>`<&lb>Click to Generate Issue Template<&rb>`<&rb>(<[Issue_URL]>)for this error report.
    Hook_Body:
        embeds: <list_single[<[Embed_Maps]>]>
        username: <[Server]> Server
        avatar_url: https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png
    Message_Context:
        title: "`[Click for Log]` Error Response:"
        url: <[Log_URL]>
        description: <[Message]>
        color: 5820671
        username: <[Server]> Error Response
        avatar_url: https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png
    AGDev: 631199819817549825
    Channel_Map:
        hub1: 744711708077064203
        behrcraft: 744711666142543953
        survival: 744711692570853467
        relay: 744711732433387602
    #$  xeane: 744713622642491433
    Player_Input:
        author:
            name: "Player Attached<&co> <[Player_Name]>"
        thumbnail:
            url: https://minotar.net/avatar/<[Player_Name]>/32.png
