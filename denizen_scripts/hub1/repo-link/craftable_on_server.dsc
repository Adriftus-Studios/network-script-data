crafted_allow_command:
  type: command
  debug: false
  name: craftable
  permission: craftable.control
  script:
    - if <context.args.first||null> == null:
      - narrate "<&c>You must specify a player to induct."
      - stop
    - if <bungee.server> == hub1:
      - define targetName <context.args.first>
      - define report_back false
      - inject crafted_allow
    - else:
      - bungeerun hub1 crafted_allow def:<context.args.first>|true|<player>

crafted_deny_command:
  type: command
  debug: false
  name: uncraftable
  permission: craftable.control
  script:
    - if <context.args.first||null> == null:
      - narrate "<&c>You must specify a player to induct."
      - stop
    - if <bungee.server> == hub1:
      - define targetName <context.args.first>
      - define report_back false
      - inject crafted_deny
    - else:
      - bungeerun hub1 crafted_deny def:<context.args.first>|true|<player>

crafted_allow:
  type: task
  debug: false
  definitions: targetName|report_back|origin_player
  script:
    - define target <server.match_player[<[targetName]>]||null>
    - if <[target]> == null:
      - if <[report_back]>:
        - bungeerun crafted crafted_report_back_failure def:<[origin_player]>|<[targetName]>
      - else:
        - narrate "<&c>Unable to find <[added_player]>."
    - else:
      - flag <[target]> crafted:true
      - if <[report_back]>:
        - bungeerun crafted crafted_report_back_success def:<[origin_player]>|<[target].name>
      - else:
        - narrate "<&b><[target].name> <&e>can now access the <&a>Crafted <&e>Server"

crafted_deny:
  type: task
  debug: false
  definitions: targetName|report_back|origin_player
  script:
    - define target <server.match_offline_player[<[targetName]>]||null>
    - if <[target]> == null:
      - if <[report_back]>:
        - bungeerun crafted crafted_report_back_failure def:<[origin_player]>|<[targetName]>
      - else:
        - narrate "<&c>Unable to find <[added_player]>."
    - else:
      - flag <[target]> crafted:!
      - if <[report_back]>:
        - bungeerun crafted crafted_report_back_remove_success def:<[origin_player]>|<[target].name>
      - else:
        - narrate "<&b><[target].name> <&e>can no longer access the <&a>Crafted <&e>Server"

crafted_report_back_sucess:
  type: task
  debug: false
  definitions: origin_player|added_player
  script:
    - narrate "<&b><[added_player]> <&e>can now access the <&a>Crafted <&e>Server" target:<[origin_player]>

crafted_report_back_remove_sucess:
  type: task
  debug: false
  definitions: origin_player|added_player
  script:
    - narrate "<&b><[added_player]> <&e>can no longer access the <&a>Crafted <&e>Server" target:<[origin_player]>

crafted_report_back_failure:
  type: task
  debug: false
  definitions: origin_player|added_player
  script:
    - narrate "<&c>Unable to find <[added_player]> <&e>on the <&a>Hub <&e>Server." target:<[origin_player]>

crafted_insurance:
  type: world
  debug: false
  events:
    on player joins:
      - if <bungee.server> == crafted:
        - ~bungeetag server:hub1 <player.has_flag[crafted]> save:flag
        - if !<entry[flag].result>:
          - kick <player> "reason:You have not been whitelisted on this server<&nl>If you believe this to be an error, contact a Crafted Admin"
      - else:
        - if <yaml[crafted].read[whitelisted].contains[<player.name>]>:
          - flag <player> crafted:true
          - yaml id:crafted set whitelisted:<-:<player.name>
          - yaml id:crafted savefile:data/crafted.yml

crafted_hub_events:
  type: world
  debug: false
  events:
    on server start:
      - if <server.has_file[data/crafted.yml]>:
        - yaml id:crafted load:data/crafted.yml
    on script reload:
      - if <yaml.list.contains[crafted]>:
        - yaml unload id:crafted
      - if <server.has_file[data/crafted.yml]>:
        - yaml id:crafted load:data/crafted.yml
