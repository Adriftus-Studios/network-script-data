Restart_Confirmation_Response:
  type: task
  debug: false
  definitions: Server|DUUID|Log|Confirmation
  script:
  # % ██ [ Check for Cancelled Log Request ] ██
    - if !<server.has_flag[Queue.Restart]>:
      - stop

    - define server_data <server.flag[Queue.Restart]>
    - if !<[server_data].parse[get[Server]].contains[<[Server]>]>:
      - stop

  # % ██ [ Cache & Verify Data             ] ██
    - define Message_Context "<list_single[<[Server]> has just finished restarting.]>"
    - define Data_Map <server.flag[Queue.Restart].filter[get[Server].is[==].to[<[Server]>]].first>
    - define Channel <[Data_Map].get[Channel]>
    - if <[Data_Map].get[DUUID]> != <[DUUID]>:
      - stop
    - flag server Queue.Restart:<-:<[Data_Map]>
    - if !<script[DDTBCTY].list_keys[WebHooks].contains[<[Channel]>]>:
      - stop
    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define RHeaders <yaml[Saved_Headers].read[Discord.Webhook_Message]>

  # % ██ [ Check for Log Request           ] ██
    - if <[Log]>:
      - define LogDir ../../../<[server]>/logs/latest.log
      - define WebDir ../../../../web/webget/<[DUUID]>.txt
      - define URL http://147.135.7.85:25580/webget?name=<[DUUID]>.txt
      - ~filecopy origin:<[LogDir]> destination:<[WebDir]>
      - define Message_Context "<[Message_Context].include_single[<&nl>**Log Output**: <&lb>`<&lb><[DUUID]>.txt<&rb>`<&rb>(<[URL]>)]>"

  # % ██ [ Return Results                          ] ██
    - define color Code
    - inject Embedded_Color_Formatting
    - define Embeds <list_single[<map.with[color].as[<[Color]>].with[description].as[<[Message_Context].unseparated>]>]>
    - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"

    - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
