Simple_Discord_Embed:
    type: task
    definitions: Text|Channel|Username
    script:
        - if <[Username]||null> == null:
            - define Username "Dehr Network Bot"
        - if <[Channel]||null> == null:
            - define Channel 626098849127071746
        - if <[Text]||null> == null:
            - stop

        - define color Code
        - inject Embedded_Color_Formatting
        - define Embeds <list[<map[color/<[Color]>].with[description].as[<[Text]>]>]>
        - define Data <map.with[username].as[<[Username]>].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png].with[embeds].as[<[Embeds]>].to_json>

        - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
        - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
