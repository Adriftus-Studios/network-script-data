Embedded_Discord_Message:
    type: task
    debug: true
    definitions: Data
    script:
    # % ██ [ Create Empty Maps                      ] ██
        - define Embed_Message <map>
        - define Embed_Map <map>
        - foreach Author|Footer:
            - if !<[Data].keys.filter[contains_text[<[Value]>]].is_empty>:
                - define <[Value]>_Map <map>


    # % ██ [ Format Maps                            ] ██
        - foreach <[Data]>:
            - choose <[Key]>:
                - case Avatar Avatar_URL:
                    - define Embed_Map <[Embed_Message].with[avatar_url].as[<[Value]>]>

                - case Username:
                    - define Embed_Map <[Embed_Message].with[username].as[<[Value]>]>

                - case Description Fields Title:
                    - define Embed_Map <[Embed_Map].with[<[Key].to_lowercase>].as[<[Value]>]>

                - case Title_URL:
                    - define Embed_Map <[Embed_Map].with[url].as[<[Value]>]>

                - case Thumbnail Image:
                    - define Embed_Map <[Embed_Map.with[<[Key].to_lowercase>].as[<map.with[url].as[<[Value]>]>]>

                - case Color:
                    - define Color <[Value]>
                    - inject Embedded_Color_Formatting
                    - define Embed_Map <[Embed_Map].with[Color].as[<[Value]>]>

                - case TimeStamp:
                    - define Time <[Value]>
                    - inject Embedded_Time_Formatting

                - case Author_Name:
                    - define <[Author_Map].with[name].as[<[Value]>]>
                - case Author_Icon:
                    - define <[Author_Map].with[icon_url].as[<[Value]>]>
                - case Author_URL:
                    - define <[Author_Map].with[url].as[<[Value]>]>

                - case Footer_Text:
                    - define <[Footer_Map].with[text].as[<[Value]>]>
                - case Footer_Icon:
                    - define <[Footer_Map].with[icon_url].as[<[Value]>]>

                - case Channel:
                    - if !<script[DDTBCTY].list_keys[WebHooks].contains[<[Channel]>]>:
                        - stop
                    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.Hook]>

                - default:
                    - announce to_console "<&c>Error: Invalid Keys Used."
                    - stop

        # % ██ [ Insert Author and Footer into Maps ] ██
        - foreach Author_Map|Footer_Map:
            - if <[<[Value]>]||invalid> != invalid:
                - define Embed_Map <[Embed_Map].with[<[<[Value]>]>]>

        # % ██ [ Format Finalized Message           ] ██
        - define Embed_Message <[Embed_Message].with[embeds].as[<list_single[<[Embed_Map]>]>].to_json>

        # % ██ [ Send Finalized Message             ] ██
        - ~webget <[Hook]> headers:<yaml[Saved_Headers].read[Discord.Webhook_Message]> data:<[Embed_Message]>

Embedded_Discord_Message_New:
    type: task
    debug: false
    definitions: Channel|Definitions
    script:
    # - ██ [ Inject Dependencies                     ] ██
        - inject Definition_Registry
        - define Data <map>
        - define Embeds <map>

        - foreach <list[username|avatar_url|tts]> as:String:
            - if <[<[String]>]||null> != null:
                - define Data <[Data].with[<[String]>].as[<[<[String]>]>]>

        - foreach <list[title|description|author|footer|fields|Thumbnail|image]> as:String:
            - if <[<[String]>]||null> != null:
                - define Embeds <[Embeds].with[<[String]>].as[<[<[String]>]>]>

        - if <[Color]||null> != null:
            - inject Embedded_Color_Formatting
            - if <[Color]> == 0:
                - define Color 5820671
            - define Embeds <[Embeds].with[color].as[<[Color]>]>

        - if <[Timestamp]||null> != null:
            - if <[TimeStamp]> == Default:
                - inject Embedded_Time_Formatting
            - define Embeds <[Embeds].with[timestamp].as[<[Time]>]>

        - define Data <[Data].with[embeds].as[<list[<[Embeds]>]>].to_json>

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

Waitable_Embedded_Webhook:
    type: task
    debug: false
    definitions: Channel|Data
    script:
        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
        - ~webget <[Hook]>?wait=true data:<[Data]> headers:<[Headers]> save:response
        - inject Web_Debug.Webget_Response
