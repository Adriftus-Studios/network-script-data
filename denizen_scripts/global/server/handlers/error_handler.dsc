Error_Handler:
  type: world
  debug: false
  events:
    on script generates error:
  # % ██ [ it's like 3am why am i still awake doing this i work in a few hours] ██

    - define group 626078288556851230
    - define channel 626098849127071746

    - define Error_Count 0
    - define File_Location
    - define Player_UUID
    - define Script_Name

    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define RHeaders <list[User-Agent/really|Content-Type/application/json]>
    - define RefURL https://discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>

    - define Data <yaml[SDS_Error_Handler].to_json>
    - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
    - stop