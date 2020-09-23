Player_Quit_Message:
  type: task
  debug: false
  definitions: Definitions
  script:
    - define color red
    - inject Embedded_Color_Formatting
    - inject Definition_Registry
    
    - if <[Rank]||null> != null:
      - define Footer "<map.with[text].as[<[Rank]> ★ Left the network]>"
    - else:
      - define Footer "<map.with[text].as[Left the network]>"
    - define Footer <[Footer].with[icon_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png]>
    - define Embeds <list[<map.with[color].as[<[Color]>].with[footer].as[<[Footer]>]>]>

    - define Data <map.with[username].as[<[Name]>].with[avatar_url].as[https://minotar.net/helm/<[Name]>]>
    - define Data <[Data].with[embeds].as[<[Embeds]>].to_json>

    - define Hook <script[DDTBCTY].data_key[WebHooks.651789860562272266.hook]>
    - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
