Embedded_Discord_Message:
    type: task
    debug: true
    definitions: Template|Channel|Definitions
    script:
        - inject Definition_Registry
        #- inject Embedded_Color_Formatting
        - inject Embedded_Time_Formatting
        - if <script[DDTBCTY].list_keys[WebHooks].contains[<[Channel]>]>:
            - define Token <script[DDTBCTY].data_key[WebHooks.<[Channel]>.Hook]>
            - define Data <yaml[webhook_template_<[Template]>].to_json.parsed>
            - ~webget <[Token]> headers:<list[Content-Type/application/json|User-Agent/denizen]> data:<[Data]> save:test
            - narrate <entry[test].result>

TestTask:
    type: task
    debug: true
    definitions: data
    script:
        - define thumbnail <map.with[url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png]>
        - define image <map.with[url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png]>

        - define Data <map.with[embeds].as[<list[<map[].with[thumbnail].as[<[thumbnail]>].with[image].as[<[Image]>]>]>]>
        - define Data <[Data].to_json>
        - define channel 626098849127071746
        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

Embedded_Discord_Message_New:
    type: task
    debug: true
    definitions: Channel|Definitions
    script:
    # - ██ [ Inject Dependencies                     ] ██
        - inject Definition_Registry_Mapped
        - define Data <map>
        - define Embeds <map>

        - foreach <list[username|avatar_url|tts]> as:String:
            - if <[<[String]>].exists>:
                - define Data <[Data].with[<[String]>].as[<[<[String]>]>]>

        - foreach <list[title|description|author|footer|fields|Thumbnail|image]> as:String:
            - if <[<[String]>].exists>:
                - define Embeds <[Embeds].with[<[String]>].as[<[<[String]>]>]>

        - if <[Color].exists>:
            - inject Embedded_Color_Formatting
            - if <[Color]> == 0:
                - define Color 5820671
            - define Embeds <[Embeds].with[color].as[<[Color]>]>

        - if <[Timestamp].exists>:
            - if <[TimeStamp]> == Default:
                - inject Embedded_Time_Formatting
            - define Embeds <[Embeds].with[timestamp].as[<[Time]>]>

        - define Data <[Data].with[embeds].as[<list[<[Embeds]>]>].to_json>

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>

