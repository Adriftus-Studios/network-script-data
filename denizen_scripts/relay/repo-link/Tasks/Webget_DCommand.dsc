Webget_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - Web Master
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group|MessageID
  debug: true
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    - define EntryResults <list>
    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define RHeaders <list[User-Agent/really|Content-Type/application/json]>
    - define RefURL https://discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>

  # % ██ [ Verify Arguments                        ] ██
    - if <[Args].is_empty> || <[Args].size> > 9:
      - stop

  # % ██ [ Check for Help Argument                 ] ██
    - if <list[help|-help].contains[<[Args].first>]>:
      - define Data <yaml[SDS_WebgetDCmd].to_json>
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Check for Queue Management Argument     ] ██
    - if <list[clear|-clear|cancel|-cancel].contains[<[Args].first>]>:
      - define Queues <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>]>
      - define FallbackRefURL https://discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>
      - define Color Red
      - inject Embedded_Color_Formatting
      - if <[Queues].is_empty>:
        - define Embeds "<list[<map.with[color].as[<[Color]>].with[title].as[Error: `No Active Queues.`]>]>"
      - else:
        - define QueueData "<[Queues].parse_tag[<&lb>Reference<&rb>(<[Parse_Value].definition[RefURL]||<[FallbackRefURL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
        - define Embeds "<list[<map.with[color].as[<[Color]>].with[title].as[Webget Queues Cleared].with[description].as[Webget queues forcibly closed **<queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size>** queue's in process:<&nl><[QueueData]>]>]>"
        - foreach <[Queues]> as:Queue:
          - queue <[Queue]> clear
      - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Check for Multiple Webget Queues        ] ██
    - if <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size> > 2:
      - define Queues <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>]>
      - define FallbackRefURL https://discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>
      - define QueueData "<[Queues].parse_tag[<&lb>Reference<&rb>(<[Parse_Value].definition[RefURL]||<[FallbackRefURL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
      - define Color Red
      - inject Embedded_Color_Formatting
      - define Embeds "<list[<map.with[color].as[<[Color]>].with[title].as[Too Many Active Requests].with[description].as[Webget declined. There are currently **<queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size>** queue's in process:<&nl><[QueueData]><&nl>Use `/webget clear` to clear active requests.]>]>"
      - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Main Arguments                          ] ██
    - define URL <[Args].first>
    - foreach <list[Data|Headers|Method|Timeout]> as:ArgDef:
      - if !<[Args].filter[starts_with[<[ArgDef]>:]].is_empty>:
        - define <[ArgDef]> <[Args].get[<[Args].find[<[Args].filter[starts_with[<[ArgDef]>:]].first>]>].after[<[ArgDef]>:]>

  # % ██ [ Verify Timeout                          ] ██
    - if !<[Timeout].exists>:
      - define Timeout <duration[10s]>
    - else if <duration[<[Timeout]>]||invalid> == invalid:
        - define EntryResults "<[EntryResults].include[<&nl>**Warning**: `Invalid Duration, Defaulted to 10s.`]>"
        - define Timeout <duration[10s]>
    - else if <[Timeout].in_minutes> > 5:
      - define Timouet <duration[5m]>
      - define EntryResults "<[EntryResults].include[<&nl>**Warning**: `Maximum timeout is 5 minutes. Defaulted to 5m.`]>"

  # % ██ [ Check for Confirmation Flag             ] ██
    - if <[Args].contains_any[-c|-confirm]>:
      - define Message "Confirmation Notice: `Request Received. Submitting with a timeout of: <[Timeout].formatted>`"
      - define CData "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[content].as[<[Message]>].to_json>"
      - ~webget <[Hook]> data:<[CData]> headers:<[RHeaders]>

  # % ██ [ Create Webget                           ] ██
    - if <[Data]||invalid> == invalid && <[Headers]||invalid> == invalid && <[Method]||invalid> == invalid:
      - ~webget <[URL]> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> != invalid && <[Headers]||invalid> == invalid && <[Method]||invalid> == invalid:
      - ~webget <[URL]> data:<[Data]> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> != invalid && <[Headers]||invalid> != invalid && <[Method]||invalid> == invalid:
      - ~webget <[URL]> data:<[Data]> headers:<[Headers].parsed> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> != invalid  && <[Headers]||invalid> != invalid && <[Method]||invalid> != invalid:
      - ~webget <[URL]> data:<[Data]> Headers:<[Headers].parsed> Method:<[Method]> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> != invalid  && <[Headers]||invalid> == invalid && <[Method]||invalid> != invalid:
      - ~webget <[URL]> data:<[Data]> Method:<[Method]> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> == invalid  && <[Headers]||invalid> == invalid && <[Method]||invalid> != invalid:
      - ~webget <[URL]> Method:<[Method]> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> == invalid  && <[Headers]||invalid> != invalid && <[Method]||invalid> == invalid:
      - ~webget <[URL]> headers:<[Headers].parsed> Timeout:<[Timeout]> save:Response

    - else if <[Data]||invalid> == invalid  && <[Headers]||invalid> != invalid && <[Method]||invalid> != invalid:
      - ~webget <[URL]> headers:<[Headers].parsed> Method:<[Method]> Timeout:<[Timeout]> save:Response

  # % ██ [ Listener Flags                          ] ██
    - if <[Args].contains_any[-f|-failed]>:
      - define EntryResults "<[EntryResults].include[<&nl>**Failed Status**: `<entry[Response].failed||Invalid Save Entry>`]>"

    - if <[Args].contains_any[-s|-status]>:
      - define EntryResults "<[EntryResults].include[<&nl>**HTTP Status**: <proc[HTTP_Status_Codes].context[<entry[Response].status||Invalid Save Entry>]>]>"

    - if <[Args].contains_any[-r|-result]> || "<entry[Response].result||Invalid Save Entry>" < 2000:
      - define EntryResults "<[EntryResults].include[<&nl>**Result Status**: `<entry[Response].result||Invalid Save Entry>`]>"

    - if <[Args].contains_any[-t|-time|-timeran|-time-ran]>:
      - define EntryResults "<[EntryResults].include[<&nl>**Time Ran**: `<entry[Response].time_ran.formatted||Invalid Save Entry>`]>"

    - if <[Args].contains_any[-l|-log|-logs]> || <[EntryResults].unseparated.length> > 2000:
      - define UUID <util.random.duuid.after[_]>
      - define File_Location ../../web/webget/

#+    # % ██ [ Check for JSON format               ] ██
#^    - if <util.parse_yaml[<entry[Response].result>]||invalid> != Invalid || <util.parse_yaml[{"Data":<[<entry[Response].result>]>}]||Invalid> != Invalid:
#^      - define Ext .json
#^    - else:
#+    # % ██ [ Check for YAML / DSC format         ] ██
#^      - define Temp_Locaton data/temp/<util.random.uuid>.txt
#^      - ~log <entry[Response].result> type:none file:<[Temp_Locaton]>
#^      - flag server WebGet.Log_Queue:<queue.id> duration:5s
#^      - ~yaml id:TempLoad load:<[Temp_Locaton]>
#^    - define Timeout <util.time_now.add[5s]>
#^    - waituntil rate:1s <server.has_flag[WebGet.LogResponse]> || <[Timeout].duration_since[<util.time_now>].in_seconds> == 0:
#^    - if <server.has_flag[WebGet.LogResponse]>:
#^      - if <server.flag[WebGet.LogResponse]> != "Invalid Yaml":
#^        - define Extension .yml
#^    - if <[Extension]||invalid> == invalid:
#+    # % ██ [ Check For HTML Format               ] ██
#^      - if <entry[Response].result.contains_any_text[<&lt>html<&gt>]>:
#^        - define Extension .html
#^      - else:
#+    # % ██ [ Determine Fallback Format           ] ██
#^        - define Extension .txt
#^    - if <server.has_flag[Temp_Locaton]>:
#^      - adjust server delete_file:<[Temp_Locaton]>

      - define Extension .txt
      - define URL http://147.135.7.85:25580/webget?name=<[UUID]><[Extension]>
      - log <entry[Response].result> type:none file:<[File_Location]><[UUID]><[Extension]>
      - define EntryResults "<[EntryResults].include[<&nl>**Log Output**: [`<[UUID]><[Extension]>`](<[URL]>)]>"

  # % ██ [ Determine Color Display                 ] ██
    - if "<[EntryResults].contains_any_text[Invalid Save Entry|**Warning**:]>":
      - define color yellow
    - else:
      - define color Code

  # % ██ [ Return Results                          ] ██
    - inject Embedded_Color_Formatting
    - define Embeds "<list[<map.with[color].as[<[Color]>].with[description].as[Command ran: `/WebGet <[Args].space_separated>`<[EntryResults].unseparated>]>]>"
    - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"

    - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
