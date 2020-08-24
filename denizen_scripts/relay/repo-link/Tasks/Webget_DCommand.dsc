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
  debug: false
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    - define Entry_Results <list>
    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define RHeaders <yaml[Saved_Headers].read[Discord.Webhook_Message]>
    - define Reference_URL https://discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>

  # % ██ [ Verify Arguments                        ] ██
    - if <[Args].is_empty> || <[Args].size> > 12:
      - stop

  # % ██ [ Check for Help Argument                 ] ██
    - if <list[help|-help].contains[<[Args].first>]>:
      - define Data <yaml[SDS_WebgetDCmd].to_json>
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Check for Queue List                    ] ██
    - if <[Args].first> == list:
      - if <[Args].size> > 1:
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Error: `Invalid Usage`].with[description].as[The `List` argument only accepts this syntax:`/webget list`<&nl>Refer to `/webget help` for command help.]>]>"
        - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
        - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
        - stop
      - define Queues <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>]>
      - define Fallback_URL https<&co>//discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>
      - define color Code
      - inject Embedded_Color_Formatting
      - if <[Queues].is_empty>:
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Error: `No Active Queues.`]>]>"
      - else:
        - define QueueData "<[Queues].parse_tag[<&lb>`<&lb>Reference<&rb>`<&rb>(<[Parse_Value].definition[Reference_URL]||<[Fallback_URL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Webget Queues Cleared].with[description].as[Webget queues forcibly closed: `<queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size>` queue's in process:<&nl><[QueueData]>]>]>"
      - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Check for Queue Remove Arguments         ] ██
    - if <list[cancel|-cancel|remove|-remove].contains[<[Args].first>]>:
      - if <[Args].size> != 2:
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Error: `Invalid Usage`].with[description].as[The `Cancel` argument only accepts this syntax:<&nl>`/webget (cancel|-cancel|remove|-remove) (Queue)`<&nl>Refer to `/webget help` for command help.]>]>"
        - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
        - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
        - stop
      - define Queues <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>]>
      - define Fallback_URL https<&co>//discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>
      - if <[Queues].parse[ID].contains[<[Args].get[2]>]> && <queue.exists[<[Args].get[2]>]>:
        - define Color Yellow
        - inject Embedded_Color_Formatting
        - define QueueData "<[Queues].exclude[<queue[<[Args].get[2]>]>].parse_tag[<&lb>`<&lb>Reference<&rb>`<&rb>(<[Parse_Value].definition[Reference_URL]||<[Fallback_URL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Webget Queue Cleared].with[description].as[Webget Queue forcibly closed: `<[Args].get[2]>` <&nl>Queue's left in process:<&nl><[QueueData]>]>]>"
        - queue <queue[<[Args].get[2]>]> clear
      - else:
        - define Color Red
        - inject Embedded_Color_Formatting
        - if <[Queues].is_empty>:
          - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Error: `No Active Queues.`]>]>"
        - else:
          - define QueueData "<[Queues].parse_tag[<&lb>`<&lb>Reference<&rb>`<&rb>(<[Parse_Value].definition[Reference_URL]||<[Fallback_URL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
          - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Webget Queues Cleared].with[description].as[Webget queues forcibly closed: `<queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size>` queue's in process:<&nl><[QueueData]>]>]>"
      - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop
    
  # % ██ [ Check for Queue Clear Arguments         ] ██
    - if <list[clear|-clear|cancel|-cancel].contains[<[Args].first>]>:
      - if <[Args].size> == 1 || <[Args].get[2]> != All:
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Error: `Invalid Usage`].with[description].as[The `Cancel` argument only accepts this syntax:<&nl>`/webget (cancel|-cancel|remove|-remove) (Queue)`<&nl>Refer to `/webget help` for command help.]>]>"
        - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
        - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
        - stop
      - define Queues <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>]>
      - define Fallback_URL https<&co>//discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>
      - define Color Red
      - inject Embedded_Color_Formatting
      - if <[Queues].is_empty>:
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Error: `No Active Queues.`]>]>"
      - else:
        - define QueueData "<[Queues].parse_tag[<&lb>`<&lb>Reference<&rb>`<&rb>(<[Parse_Value].definition[Reference_URL]||<[Fallback_URL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
        - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Webget Queues Cleared].with[description].as[Webget queues forcibly closed **<queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size>** queue's in process:<&nl><[QueueData]>]>]>"
        - foreach <[Queues]> as:Queue:
          - queue <[Queue]> clear
      - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Check for Multiple Webget Queues        ] ██
    - if <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size> > 2:
      - define Queues <queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>]>
      - define Fallback_URL https<&co>//discordapp.com/channels/<[Group].id>/<[Channel]>/<[MessageID]>
      - define QueueData "<[Queues].parse_tag[<&lb>`<&lb>Reference<&rb>`<&rb>(<[Parse_Value].definition[Reference_URL]||<[Fallback_URL]>>): `<[Parse_Value].definition[URL]||(Invalid URL)>`].separated_by[<&nl>]>"
      - define Color Red
      - inject Embedded_Color_Formatting
      - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[title].as[Too Many Active Requests].with[description].as[Webget declined. There are currently **<queue.list.filter[id.contains_any_text[<script.name>]].exclude[<queue>].size>** queue's in process:<&nl><[QueueData]><&nl>Use `/webget clear` to clear active requests.]>]>"
      - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"
      - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
      - stop

  # % ██ [ Preliminary Arguments                   ] ██
    - define URL <[Args].first>
    - foreach <list[Data|Headers|Method|Timeout]> as:ArgDef:
      - if !<[Args].filter[starts_with[<[ArgDef]>:]].is_empty>:
        - define <[ArgDef]> <[Args].get[<[Args].find[<[Args].filter[starts_with[<[ArgDef]>:]].first>]>].after[<[ArgDef]>:]>

  # % ██ [ Check for Parsed Argument               ] ██
    - if <[Args].contains_any[-p|-parse|-parsed]>:
      - define URL <[URL].replace[<&pc>].with[<&chr[6969]>].parsed.replace[<&chr[6969]>].with[<&pc>]>
      - if <[Data]||invalid> != invalid:
        - define Data <[Data].parsed>

  # % ██ [ Verify Timeout                          ] ██
    - if <[Timeout]||null> == null:
      - define Timeout <duration[10s]>
    - else if <duration[<[Timeout]>]||invalid> == invalid:
        - define Entry_Results "<[Entry_Results].include[<&nl>**Warning**: `Invalid Duration, Defaulted to 10s.`]>"
        - define Timeout <duration[10s]>
    - else if <[Timeout].in_minutes> > 5:
      - define Timeout <duration[5m]>
      - define Entry_Results "<[Entry_Results].include[<&nl>**Warning**: `Maximum timeout is 5 minutes. Defaulted to 5m.`]>"

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
    - if <[Args].contains_any[-f|-fail|-failed]>:
      - define Entry_Results "<[Entry_Results].include[<&nl>**Failed Status**: `<entry[Response].failed||Invalid Save Entry>`]>"

    - if <[Args].contains_any[-s|-status]>:
      - define Entry_Results "<[Entry_Results].include[<&nl>**HTTP Status**: <proc[HTTP_Status_Codes].context[<entry[Response].status||Invalid Save Entry>]>]>"

    - if <[Args].contains_any[-r|-result|-results]> && <entry[Response].result.length> < 2000:
      - define Entry_Results "<[Entry_Results].include[<&nl>**Result Status**: `<entry[Response].result||Invalid Save Entry> `]>"

    - if <[Args].contains_any[-t|-time|-timeran|-time-ran]>:
      - define Entry_Results "<[Entry_Results].include[<&nl>**Time Ran**: `<entry[Response].time_ran.formatted||Invalid Save Entry>`]>"

    - if <[Args].contains_any[-h|-head|-headers]>:
      - define Entry_Results "<[Entry_Results].include[<&nl>**Result Headers**: `<entry[Response].result_headers.formatted||Invalid Save Entry>`]>"

    - if !<[Args].filter_tag[before[:].contains_any[e:/ext:/extension:/extensions:]].is_empty>:
      - if <[Args].contains_any[-r|-result|-results|-l|-log|-logs]>:
        - define Extension <[Args].filter[before[:].contains_any[e:/ext:/extension:/extensions:]].first.after[:]>
        - if !<[Extension].starts_with[.]>:
          - define Extension .<[Extension]>
        - if <[Extension].contains_any[.exe|.jar|.bin|.csh|.ksh|.out|.run|.js|.com|.cmd|.bat|.sh]>:
          - define Entry_Results "<[Entry_Results].include[<&nl>***Severe Warning***: `Blacklisted Extension: <[Extension]>`]>"
          - define Extension .txt
      - else:
        - define Entry_Results "<[Entry_Results].include[<&nl>**Warning**: `Extension flag specified without required RESULT or LOG flag.`]>"
        - define Extension .txt
    - else:
      - define Extension .txt
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

    - if <[Args].contains_any[-l|-log|-logs]> || <[Entry_Results].unseparated.length> > 2000:
      - define UUID <util.random.duuid.after[_]>
      - define File_Location ../../web/webget/
      - define URL http://147.135.7.85:25580/webget?name=<[UUID]><[Extension]>
      - log <entry[Response].result> type:none file:<[File_Location]><[UUID]><[Extension]>
      - define Entry_Results "<[Entry_Results].include[<&nl>**Log Output**: [`[<[UUID]><[Extension]>]`](<[URL]>)]>"

  # % ██ [ Determine Color Display                 ] ██
    - if "<[Entry_Results].contains_any_text[Invalid Save Entry|**Warning**:]>":
      - define color yellow
    - else if "<[Entry_Results].contains_text[***Severe Warning***]>":
      - define color Red
    - else:
      - define color Code

  # % ██ [ Return Results                          ] ██
    - inject Embedded_Color_Formatting
    - define Embeds "<list_single[<map.with[color].as[<[Color]>].with[description].as[**Command ran**: `/WebGet <[Args].space_separated>`<[Entry_Results].unseparated>]>]>"
    - define Data "<map.with[username].as[WebGet Command Response].with[avatar_url].as[https://cdn.discordapp.com/attachments/626098849127071746/737916305193173032/AY7Y8Zl9ylnIAAAAAElFTkSuQmCC.png].with[embeds].as[<[Embeds]>].to_json>"

    - ~webget <[Hook]> data:<[Data]> headers:<[RHeaders]>
