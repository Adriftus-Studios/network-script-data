Status_DCommand:
  type: task
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - External Developer
    - Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
  definitions: Message|Channel|Author|Group
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry
    
  # % ██ [ Verify Arguments ] ██
    - if <[Args].is_empty>:
      - define Args:->:Relay
    - define Server <[Args].first>

    - if <[Args].size> > 9:
      - stop

  # % ██ [ Help Argument ] ██
    - if <[Server]> == help:
      - define Data <yaml[SDS_StatusDCmd].to_json>
      - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
      - define headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>
      - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
      - stop

  # % ██ [ All Argument ] ██
    - if <list[Network|Servers|All].contains[<[Server]>]>:
      - define Data <map.with[color].as[code]>
      - define Data "<[Data].with[username].as[Network Status]>"
      - define Data <[Data].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png]>

      - define Fields <list>
      - define FieldMap <map.with[inline].as[true]>
      - foreach <yaml[bungee_config].list_keys[servers]> as:Server:
        - define Field <[FieldMap].with[name].as[<[Server].to_titlecase>]>
        - if <bungee.list_servers.contains[<[Server]>]>:
          - ~Bungeetag server:<[Server]> <bungee.connected> save:Data
          - define Status <entry[Data].result||false>
        - else:
          - define Status false

        - if <[Status]>:
          - define Field <[Field].with[value].as[`Online`]>
        - else:
          - define Field <[Field].with[value].as[**`Offline`**]>
        - define Fields <[Fields].include[<[Field]>]>
      - if <[Args].size> > 1:
        - define "<[Data].with[description].as[Note: Flags cannot be used for Network Status.]>"

      - define Data <[Data].with[fields].as[<[Fields]>]>
      - bungeerun Relay Embedded_Discord_Message_New def:<list[<[Channel]>].include[<[Data]>]>
      - stop
      
  # % ██ [ Server Argument Check ] ██
    - if !<yaml[bungee_config].contains[servers.<[Server]>]>:
      - stop
    - else if !<bungee.list_servers.contains[<[Server]>]>:
      - stop
    - else if <[Args].size> == 1:
      - define Args:->:-online
      - define Flags <list[-o]>
  # % ██ [ All Flag ] ██
    - else if <list[-a|-all].contains_any[<[Args]>]>:
      - define Flags <list[-o|-p|-w|-pl|-v|-ch|-tps|-s|-u]>
    - else:
      - define Flags <[Args].remove[first]>
    
  # % ██ [ Define Empty Defintions ] ██
    - define Fields <list>
    - define Duplicates <list>
    - define FieldMap <map.with[inline].as[true]>

  # % ██ [ Online Flag ] ██
    - if <list[-o|-online].contains_any[<[Flags]>]>:
      - define Duplicates:->:Online
      - define Field <[FieldMap].with[name].as[Online]>
      - ~bungeetag server:<[Server].to_titlecase> <bungee.connected> save:Data
      - if <entry[Data].result> == 0:
        - define Field <[Field].with[value].as[<empty>]>
      - else:
        - define Field <[Field].with[value].as[<entry[Data].result>]>
      - define Fields <[Fields].include[<[Field]>]>

  # % ██ [ Entry Flags ] ██
    - foreach <script.list_keys[Flags].exclude[o|online]> as:Flag:
      - define FlagName <script.data_key[Flags.<[Flag]>.nodes]||invalid>
      - if <[Flags].contains_any[<[Flagname].parse_tag[-<[Parse_Value]>]>]>:
        - if <[Duplicates].contains_any[<[Flagname]>]>:
          - foreach next
        - define Duplicates:->:<[Flag]>
        - define Field <[FieldMap].with[name].as[<[Flag]>]>
        - define Tag <script.data_key[Flags.<[Flag]>.tag].escaped>
        - ~bungeetag server:<[Server]> <[Tag].unescaped.parsed> save:Data
        - define Field <[Field].with[value].as[<entry[Data].result>]>
        - define Fields <[Fields].include[<[Field]>]>
    
  # % ██ [ Build Data ] ██
  #^- define Data "<map.with[title].as[<[Server]> Status]>"
    - define Data "<map.with[color].as[code].with[fields].as[<[Fields]>].with[username].as[<[Server]> Server].with[avatar_url].as[https://cdn.discordapp.com/attachments/625076684558958638/739228903700168734/icons8-code-96.png]>"
    - if !<[Duplicates].exclude[Online].is_empty>:
      - define Data "<[Data].with[description].as[**Flags Used**: `<[Duplicates].comma_separated>`]>"
    - define Data <[Data].with[time].as[Default]>
    - bungeerun Relay Embedded_Discord_Message_New def:<list[<[Channel]>].include[<[Data]>]>

  Flags:
    Players:
      tag: "Online<&co> `(<server.online_players.size>)`<n>```md<n>- <server.online_players.parse[name].separated_by[<n>- ]>```"
      nodes:
        - p
        - players
    Worlds:
      tag: <server.worlds.parse[name].comma_separated>
      nodes:
        - w
        - world
        - worlds
    Plugins:
      tag: "<server.list_plugins.parse_tag[<[Parse_Value].name><&co> `<[Parse_Value].version>`].separated_by[<n>]>"
      nodes:
        - pl
        - plugin
        - plugins
    Version:
      tag: "Version<&co> `<server.version>`<n>Denizen Version: `<server.denizen_version>`"
      nodes:
        - v
        - version
    Versions:
      tag: "Version<&co> `<server.version>`<n><server.list_plugins.parse_tag[<[Parse_Value].name><&co> `<[Parse_Value].version>`].separated_by[<n>]>"
      nodes:
        - versions
        - stats
    Chunks:
      tag: <server.worlds.parse_tag[<[Parse_Value].name><&co> `<[Parse_Value].loaded_chunks.size>`].separated_by[<n>]>
      nodes:
        - ch
        - chunks
    TPS:
      tag: <server.recent_tps.parse[round_down_to_precision[0.001]].comma_separated>
      nodes:
        - tps
    Scripts:
      tag: "Total Scripts<&co> `(<server.scripts.size>)`<n>Yaml Files<&co> `(<yaml.list.size>)`<n><server.scripts.parse[data_key[type]].deduplicate.parse_tag[<[Parse_Value].to_titlecase> Scripts<&co> `(<server.scripts.filter[data_key[type].is[==].to[<[Parse_Value]>]].size>)`].separated_by[<n>]>"
      nodes:
        - s
        - scripts
    Uptime:
      tag: "Real<&co> `<server.real_time_since_start.formatted>`<n>Delta<&co> `<server.delta_time_since_start.formatted>`"
      nodes:
        - u
        - uptime
