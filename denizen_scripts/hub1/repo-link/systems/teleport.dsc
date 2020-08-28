teleport_cancel_global_command:
    type: command
    name: tpcancel
    aliases:
    - teleportcancel
    usage: /tpcancel (<&lt>Player<&gt>(,...)/(everyone/all)) (-l/-local/-locally/-s/-server)
    description: Cancels a teleport request from the specified person, list of people, or everyone
    tab complete:
    - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Check for local flag  ] ██
    - if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].is_empty.not>:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.size> != 1:
            - inject Command_Syntax
        - if <list[everyone|all].contains[<context.args.first>]>:
            - define uuid_list <yaml[teleport_requests].read[<player.uuid>]||<list>>
            - define uuid_here_list <yaml[teleporthere_requests].read[].filter[values.contains[<player.uuid>]].parse[keys.first]>
            - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
                - define Reason "You do not have any outgoing teleport requests."
                - inject Command_Error
            - yaml id:teleport_requests set <player.uuid>:!
            - foreach <[uuid_here_list]> as:u:
                - yaml id:teleporthere_requests set <[u]>:<-:<player.uuid>
            - narrate "<player.display_name><&a> has cancelled their teleport request." targets:<[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<player[<[parse_value]>]>]>
            - narrate "<&a>You have cancelled all outgoing teleport requests."
        - else if <context.args.first.contains[,]>:
            - define player_arg <context.args.first>
            - foreach <[player_arg].split[,]> as:user:
                - inject player_verification
                - define player_list:->:<[user]>
            - define uuid_list <yaml[teleport_requests].read[<player.uuid>].filter_tag[<[player_arg].parse[uuid].contains[<[filter_value]>]>]||<list>>
            - define uuid_here_list <yaml[teleporthere_requests].read[].filter[values.contains[<player.uuid>]].parse[keys.first].filter_tag[<[player_arg].parse[uuid].contains[<[filter_value]>]>]>
            - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
                - define Reason "You do not have a teleport request from any of the specified players."
                - inject Command_Error
            - yaml id:teleport_requests set <player.uuid>:<yaml[teleport_requests].read[<player.uuid>].exclude[<[uuid_list]>]>
            - foreach <[uuid_here_list]> as:u:
                - yaml id:teleporthere_requests set <[u]>:<-:<player.uuid>
            - narrate "<player.display_name><&a> has cancelled their teleport request." targets:<[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<player[<[parse_value]>]>]>
            - narrate "<&a>You have cancelled outgoing teleport requests to: <[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<player[<[parse_value]>].display_name>].formatted><&a>."
        - else:
            - define player <server.match_player[<context.args.first>]||null>
            - if <[player]> == null || <[player].uuid> == <player.uuid>:
                - define Reason "The specified player is invalid."
                - inject Command_Error
            - if <yaml[teleport_requests].contains[<player.uuid>]> && <yaml[teleport_requests].read[<player.uuid>].contains[<[player].uuid>]>:
                - yaml id:teleport_requests set <player.uuid>:<-:<[player].uuid>
                - narrate "<player.display_name><&a> has cancelled their teleport request." targets:<[player]>
                - narrate "<&a>You have cancelled your outgoing teleport request to <[player].display_name><&a>."
            - else if <yaml[teleporthere_requests].contains[<[player].uuid>]> && <yaml[teleporthere_requests].read[<[player].uuid>].contains[<player.uuid>]>:
                - yaml id:teleporthere_requests set <[player].uuid>:<-:<player.uuid>
                - narrate "<player.display_name><&a> has cancelled their teleport request." targets:<[player]>
                - narrate "<&a>You have cancelled your outgoing teleport request to <[player].display_name><&a>."
            - else:
                - define Reason "You do not have an outgoing teleport request to <[player].display_name><&a>."
                - inject Command_Error
    - else:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax
        - bungeerun hub1 networkteleport_cancel def:<list_single[context.args.first>].include[<player>|<bungee.server>|<player.display_name>]>

networkteleport_cancel:
    type: task
    definitions: player_1_input|attached_player|attached_server|attached_displayname
    script:
    - if <list[everyone|all].contains[<[player_1_input]>]>:
        - define uuid_list <yaml[networkteleport_requests].read[<[attached_player].uuid>]||<list>>
        - define uuid_here_list <yaml[networkteleporthere_requests].read[].filter[values.contains[<[attached_player].uuid>]].parse[keys.first]>
        - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "You do not have any outgoing teleport requests."
                - inject Command_Error
        - yaml id:networkteleport_requests set <[attached_player].uuid>:!
        - foreach <[uuid_here_list]> as:u:
            - yaml id:networkteleporthere_requests set <[u]>:<yaml[networkteleporthere_requests].read[<[u]>].exclude[<[attached_player].uuid>]>
        - define player_maps <[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<yaml[data_handler].read[].filter[get[uuid].is[==].to[<[parse_value]>]]>]>
        - foreach <[player_maps].parse[get[server]].deduplicate> as:s:
            - bungee <[s]>:
                - narrate "<[attached_displayname]><&a> has cancelled the teleport request" targets:<[player_maps].filter[get[server].is[==].to[<[s]>]].parse_tag[<player[<[parse_value].get[uuid]>]>]>
        - bungee <[attached_server]>:
            - narrate "<&a>You have cancelled all outgoing teleport requests." targets:<[attached_player]>
    - else if <[player_1_input].contains[,]>:
        - define player_arg <[player_1_input]>
        - repeat <[player_arg].to_list.count[,].add[1]>:
            - if <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]].is_empty> || <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]].first.get[uuid]> == <[attached_player].uuid>:
                - bungee <[attached_server]>:
                    - adjust <queue> linked_player:<[attached_player]>
                    - define Reason "At least one of the specified players is invalid."
                    - inject Command_Error
            - define player_maps:->:<yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]].first>
            - define player_arg <[player_arg].after[,]>
        - define uuid_list <yaml[networkteleport_requests].read[<[attached_player].uuid>].filter_tag[<[player_maps].parse[get[uuid]].contains[<[filter_value]>]>]||<list>>
        - define uuid_here_list <yaml[networkteleporthere_requests].read[].filter[values.contains[<[attached_player].uuid>]].parse[keys.first].filter_tag[<[player_maps].parse[get[uuid]].contains[<[filter_value]>]>]>
        - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "You do not have any outgoing teleport requests to the specified people."
                - inject Command_Error
        - yaml id:networkteleport_requests set <[attached_player].uuid>:<yaml[networkteleport_requests].read[<[attached_player].uuid>].exclude[<[uuid_list]>]>
        - foreach <[uuid_here_list]> as:u:
            - yaml id:networkteleporthere_requests set <[u]>:<-:<[attached_player].uuid>
        - define player_maps <[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<yaml[data_handler].read[].filter[get[uuid].is[==].to[<[parse_value]>]]>]>
        - foreach <[player_maps].parse[get[server]].deduplicate> as:s:
            - bungee <[s]>:
                - narrate "<[attached_displayname]><&a> has cancelled the teleport request." targets:<[player_maps].filter[get[server].is[==].[<[s]>]].parse_tag[<player[<[parse_value].get[uuid]>]>]>
        - bungee <[attached_server]>:
            - narrate "<&a>You have cancelled outgoing teleport requests to the specified people." targets:<[attached_player]>
    - else:
        - if <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_1_input]>]].is_empty>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "The specified player is invalid."
                - inject Command_Error
        - define player_map <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_1_input]>]].first>
        - if <yaml[networkteleport_requests].contains[<[attached_player].uuid>]> && <yaml[networkteleport_requests].read[<[attached_player].uuid>].contains[<[player_map].get[uuid]>]>:
            - yaml id:networkteleport_requests <[attached_player].uuid>:<-:<[player_map].get[uuid]>
            - bungee <[player_map].get[server]>:
                - narrate "<[attached_displayname]><&a> has cancelled the teleport request." targets:<player[<[player_map].get[uuid]>]>
                - define displayname <player[<[player_map].get[uuid]>].display_name>
            - bungee <[attached_server]>:
                - narrate "<&a>You have cancelled the teleport request to <[displayname]><&a>."
        - else if <yaml[networkteleporthere_requests].contains[<[player_map].get[uuid]>]> && <yaml[networkteleporthere_requests].read[<[player_map].get[uuid]>].contains[<[attached_player].uuid>]>:
            - yaml id:networkteleporthere_requests set <[player_map].get[uuid]>:<-:<[attached_player].uuid>
            - bungee <[player_map].get[server]>:
                - narrate "<[attached_displayname]><&a> has cancelled the teleport request." targets:<player[<[player_map].get[uuid]>]>
                - define displayname <player[<[player_map].get[uuid]>].display_name>
            - bungee <[attached_server]>:
                - narrate "<&a>You have cancelled the teleport request to <[displayname]><&a>."
        - else:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "You do not have an outgoing teleport request to that person"
                - inject Command_Error

teleport_deny_global_command:
    type: command
    name: tpdeny
    aliases:
    - teleportdeny
    - tpdecline
    - teleportdecline
    usage: /tpdeny (<&lt>Player<&gt>(,...)/(everyone/all)) (-l/-local/-locally/-s/-server)
    description: Declines a teleport request from the specified person, list of people, or everyone
    tab complete:
    - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Check for local flag  ] ██
    - if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].is_empty.not>:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.size> != 1:
            - inject Command_Syntax
        - if <list[everyone|all].contains[<context.args.first>]>:
            - define uuid_list <yaml[teleport_requests].read[].filter[values.contains[<player.uuid>]].parse[keys.first]>
            - define uuid_here_list <yaml[teleporthere_requests].read[<player.uuid>]||<list>>
            - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
                - define Reason "You do not have a teleport request from anyone."
                - inject Command_Error
            - foreach <[uuid_list]> as:u:
                - yaml id:teleport_requests set <[u]>:<-:<player.uuid>
                - if <yaml[teleport_cooldowns].contains[<[u]>]>:
                    - yaml id:teleport_cooldowns set <[u]>:<yaml[teleport_cooldowns].read[<[u]>].with[<player.uuid>].as[<util.time_now>]>
                - else:
                    - yaml id:teleport_cooldowns set <[u]>:<map.with[<player.uuid>].as[<util.time_now>]>
            - foreach <[uuid_here_list]> as:u:
                - yaml id:teleporthere_requests set <player.uuid>:<-:<[u]>
            - if <yaml[teleporthere_cooldowns].contains[<player.uuid>]>:
                - yaml id:teleporthere_cooldowns set <player.uuid>:<yaml[teleporthere_cooldowns].read[<player.uuid>].include[<[uuid_here_list].map_with[<list.pad_right[<[uuid_here_list].size>].with[<util.time_now>]>]>]>
            - else:
                - yaml id:teleporthere_cooldowns set <player.uuid>:<[uuid_here_list].map_with[<list.pad_right[<[uuid_here_list].size>].with[<util.time_now>]>]>
            - narrate "<player.display_name><&a> has declined your teleport request." targets:<[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<player[<[parse_value]>]>]>
            - narrate "<&a>You have declined all teleport requests."
        - else if <context.args.first.contains[,]>:
            - define player_arg <context.args.first>
            - foreach <[player_arg].split[,]> as:user:
                - inject player_verification
                - define player_list:->:<[user]>
            - define uuid_list <yaml[teleport_requests].read[].filter[values.contains[<player.uuid>]].parse[keys.first].filter_tag[<[player_arg].parse[uuid].contains[<[filter_value]>]>]>
            - define uuid_here_list <yaml[teleporthere_requests].read[<player.uuid>].values.filter_tag[<[player_arg].parse[uuid].contains[<[filter_value]>]>]||<list>>
            - if <[uuid_list].include[<[uuid_here_list]>].deduplicate.size> != <[player_arg].size>:
                - define Reason "You do not have a teleport request from at least one of the specified players."
                - inject Command_Error
            - foreach <[uuid_list]> as:u:
                - yaml id:teleport_requests set <[u]>:<-:<player.uuid>
                - if <yaml[teleport_cooldowns].contains[<[u]>]>:
                    - yaml id:teleport_cooldowns set <[u]>:<yaml[teleport_cooldowns].read[<[u]>].with[<player.uuid>].as[<util.time_now>]>
                - else:
                    - yaml id:teleport_cooldowns set <[u]>:<map.with[<player.uuid>].as[<util.time_now>]>
            - foreach <[uuid_here_list]> as:u:
                - yaml id:teleporthere_requests set <[u]>:<-:<player.uuid>
            - if <yaml[teleporthere_cooldowns].contains[<player.uuid>]>:
                - yaml id:teleporthere_cooldowns set <player.uuid>:<yaml[teleporthere_cooldowns].read[<player.uuid>].include[<[uuid_here_list].map_with[<list.pad_right[<[uuid_here_list].size>].with[<util.time_now>]>]>]>
            - else:
                - yaml id:teleporthere_cooldowns set <player.uuid>:<[uuid_here_list].map_with[<list.pad_right[<[uuid_here_list].size>].with[<util.time_now>]>]>
            - narrate "<player.display_name><&a> has declined your teleport request." targets:<[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<player[<[parse_value]>]>]>
            - narrate "<&a>You have declined the teleport requests from: <[uuid_list].include[<[uuid_here_list]>].deduplicate.parse_tag[<player[<[parse_value]>].display_name>].formatted><&a>."
        - else:
            - define player <server.match_player[<context.args.first>]||null>
            - if <[player]> == null:
                - define Reason "The specified player is invalid."
                - inject Command_Error
            - if <yaml[teleport_requests].contains[<[player].uuid>]> && <yaml[teleport_requests].read[<[player].uuid>].contains[<player.uuid>]>:
                - yaml set id:teleport_requests <[player].uuid>:<-:<player.uuid>
                - if <yaml[teleport_cooldowns].contains[<[player].uuid>]>:
                    - yaml id:teleport_cooldowns set <[player].uuid>:<yaml[teleport_cooldowns].read[<[player].uuid>].with[<player.uuid>].as[<util.time_now>]>
                - else:
                    - yaml id:teleport_cooldowns set <[player].uuid>:<map.with[<player.uuid>].as[<util.time_now>]>
                - narrate "<player.display_name><&a> has declined your teleport request." targets:<[player]>
                - narrate "<&a>You have declined <[player].display_name><&a>'s teleport request."
            - else if <yaml[teleporthere_requests].contains[<player.uuid>]> && <yaml[teleporthere_requests].read[<player.uuid>].contains[<[player].uuid>]>:
                - yaml set id:teleporthere_requests <player.uuid>:<-:<[player].uuid>
                - if <yaml[teleporthere_cooldowns].contains[<player.uuid>]>:
                    - yaml id:teleporthere_cooldowns set <player.uuid>:<yaml[teleporthere_cooldowns].read[<player.uuid>].with[<[player].uuid>].as[<util.time_now>]>
                - else:
                    - yaml id:teleporthere_cooldowns set <player.uuid>:<map.with[<[player].uuid>].as[<util.time_now>]>
                - narrate "<player.display_name><&a> has declined your teleport request." targets:<[player]>
                - narrate "<&a>You have declined <[player].display_name><&a>'s teleport request."
            - else:
                - define Reason "You do not have a teleport request from the specified player."
                - inject Command_Error
    - else:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax
        - bungeerun hub1 networkteleport_deny def:<list_single[<context.args.first>].include[<player>|<bungee.server>|<player.display_name>]>

networkteleport_deny:
    type: task
    definitions: player_1_input|attached_player|attached_server|attached_displayname
    script:
    - if <list[everyone|all].contains[<[player_1_input]>]>:
        - define uuid_list <yaml[networkteleport_requests].read[].filter[values.contains[<[attached_player].uuid>]].parse[keys.first]>
        - define uuid_here_list <yaml[networkteleporthere_requests].read[<[attached_player].uuid>]||<list>>
        - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "You do not have a teleport request from anyone."
                - inject Command_Error
        - foreach <[uuid_list]> as:u:
            - yaml id:networkteleport_requests set <[u]>:<-:<[attached_player].uuid>
            - if <yaml[networkteleport_cooldowns].contains[<[u]>]>:
                - yaml id:networkteleport_cooldowns set <[u]>:<yaml[networkteleport_cooldowns].read[<[u]>].with[<[attached_player].uuid>].as[<util.time_now>]>
            - else:
                - yaml id:networkteleport_cooldowns set <[u]>:<map.with[<[attached_player].uuid>].as[<util.time_now>]>
        - yaml id:networkteleporthere_requests set <[attached_player].uuid>:!
        - foreach <[uuid_here_list]> as:u:
            - if <yaml[networkteleporthere_cooldowns].contains[<[attached_player].uuid>]>:
                - yaml id:networkteleporthere_cooldowns set <[attached_player].uuid>:<yaml[networkteleporthere_cooldowns].read[<[attached_player].uuid>].with[<[u]>].as[<util.time_now>]>
            - else:
                - yaml id:networktleporthere_cooldowns set <[attached_player].uuid>:<map.with[<[u]>].as[<util.time_now>]>
        - define player_maps <yaml[data_handler].read[].filter_tag[<[uuid_list].include[<[uuid_here_list]>].deduplicate.contains[<[filter_value].get[uuid]>]>]>
        - foreach <[player_maps].parse[get[server]].deduplicate> as:s:
            - bungee <[s]>:
                - narrate "<[attached_displayname]><&a> has declined your teleport request." targets:<[player_maps].filter[get[server].is[==].to[<[s]>]].parse_tag[<player[<[parse_value].get[uuid]>]>]>
        - bungee <[attached_server]>:
            - narrate "<&a>You have declined all of your teleport requests." targets:<[attached_player]>
    - else if <[player_1_input].contains[,]>:
        - define player_arg <[player_1_input]>
        - repeat <[player_arg].to_list.count[,].add[1]>:
            - if <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]].is_empty> || <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]].first.get[uuid]> == <[attached_player].uuid>:
                - bungee <[attached_server]>:
                    - adjust <queue> linked_player:<[attached_player]>
                    - define Reason "At least one of the specified players is invalid."
                    - inject Command_Error
            - define player_maps:->:<yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]].first>
            - define player_arg <[player_arg].after[,]>
        - define uuid_list <yaml[networkteleport_requests].read[].filter[values.contains[<[attached_player].uuid>]].parse[keys.first].filter_tag[<[player_maps].parse[get[uuid]].contains[<[filter_value]>]>]>
        - define uuid_here_list <yaml[networkteleporthere_requests].read[<[attached_player].uuid>].filter_tag[<[player_maps].parse[get[uuid]].contains[<[filter_value]>]>]||<list>>
        - if <[uuid_list].is_empty> && <[uuid_here_list].is_empty>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "You do not have a teleport request from anyone."
                - inject Command_Error
        - foreach <[uuid_list]> as:u:
            - yaml id:networkteleport_requests set <[u]>:<-:<[attached_player].uuid>
            - if <yaml[networkteleport_cooldowns].contains[<[u]>]>:
                - yaml id:networkteleport_cooldowns set <[u]>:<yaml[networkteleport_cooldowns].read[<[u]>].with[<[attached_player].uuid>].as[<util.time_now>]>
            - else:
                - yaml id:networkteleport_cooldowns set <[u]>:<map.with[<[attached_player].uuid>].as[<util.time_now>]>
        - yaml id:networkteleporthere_requests set <[attached_player].uuid>:<yaml[networkteleporthere_requests].read[<[attached_player].uuid>].exclude[<[uuid_here_list]>]>
        - if <yaml[networkteleporthere_cooldowns].contains[<[attached_player].uuid>]> && <[uuid_here_list].is_empty.not>:
            - yaml id:networkteleporthere_cooldowns set <[attached_player].uuid>:<yaml[networkteleporthere_cooldowns].read[<[attached_player].uuid>].include[<[uuid_here_list].map_with[<list.pad_right[<[uuid_here_list].size>].with[<util.time_now>]>]>]>
        - else:
            - yaml id:networkteleporthere_cooldowns set <[attached_player].uuid>:<[uuid_here_list].map_with[<list.pad_right[<[uuid_here_list].size>].with[<util.time_now>]>]>
        - foreach <[player_maps].parse[get[server]].deduplicate> as:s:
            - bungee <[s]>:
                - narrate "<[attached_displayname]><&a> has declined your teleport request." targets:<[player_maps].filter[get[server].is[==].to[<[s]>]].parse_tag[<player[<[parse_value].get[uuid]>]>]>
        - bungee <[attached_server]>:
            - narrate "<&a>You have declined teleport requests from the specified players." targets:<[attached_player]>
    - else:
        - if <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_1_input]>]].is_empty>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "The specified player is invalid."
                - inject Command_Error
        - define player_map <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_1_input]>]].first>
        - if <yaml[networkteleport_requests].contains[<[player_map].get[uuid]>]> && <yaml[networkteleport_requests].read[<[player_map].get[uuid]>].contains[<[attached_player].uuid>]>:
            - yaml id:networkteleport_requests set <[player_map].get[uuid]>:<-:<[attached_player].uuid>
            - if <yaml[networkteleport_cooldowns].contains[<[player_map].get[uuid]>]>:
                - yaml id:networkteleport_cooldowns set <[player_map].get[uuid]>:<yaml[networkteleport_cooldowns].read[<[player_map].get[uuid]>].with[<[attached_player].uuid>].as[<util.time_now>]>
            - else:
                - yaml id:networkteleport_cooldowns set <[player_map].get[uuid]>:<map.with[<[attached_player].uuid>].as[<util.time_now>]>
            - bungee <[player_map].get[server]>:
                - narrate "<[attached_displayname]><&a> has declined your teleport request." targets:<player[<[player_map].get[uuid]>]>
            - bungee <[attached_server]>:
                - narrate "<&a>You have declined the teleport request." targets:<[attached_player]>
        - else if <yaml[networkteleporthere_requests].contains[<[attached_player].uuid>]> && <yaml[networkteleporthere_requests].read[<[attached_player].uuid>].contains[<[player_map].get[uuid]>]>:
            - yaml id:networkteleporthere_requests set <[attached_player].uuid>:<-:<[player_map].get[uuid]>
            - if <yaml[networkteleporthere_cooldowns].contains[<[attached_player].uuid>]>:
                - yaml id:networkteleporthere_cooldowns set <[attached_player].uuid>:<yaml[networkteleporthere_cooldowns].read[<[attached_player].uuid>].with[<[player_map].get[uuid]>].as[<util.time_now>]>
            - else:
                - yaml id:networkteleporthere_cooldowns set <[attached_player].uuid>:<map.with[<[player_map].get[uuid]>].as[<util.time_now>]>
            - bungee <[player_map].get[server]>:
                - narrate "<[attached_displayname]><&a> has declined your teleport request." targets:<player[<[player_map].get[uuid]>]>
            - bungee <[attached_server]>:
                - narrate "<&a>You have declined the teleport request." targets:<[attached_player]>
        - else:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "You do not have a teleport request from the specified player."
                - inject Command_Error

teleport_accept_global_command:
    type: command
    name: tpaccept
    usage: /tpaccept (<&lt>Player<&gt>) (-l/-local/-locally/-s/-server)
    aliases:
    - teleportaccept
    description: Accepts a teleport request from the specified person or list of people
    tab complete:
    - inject Online_Player_Tabcomplete
    script:
    # % ██ [  Check for local flag  ] ██
    - if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].is_empty.not>:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.size> != 1:
            - inject Command_Syntax
        - define player <server.match_player[<context.args.first>]||null>
        - if <[player]> == null || <[player].uuid> == <player.uuid>:
            - define Reason "The specified player is invalid."
            - inject Command_Error
        - if <yaml[teleport_requests].contains[<[player].uuid>]> && <yaml[teleport_requests].read[<[player].uuid>].contains[<player.uuid>]>:
            - yaml set id:teleport_requests <[player].uuid>:<-:<player.uuid>
            - wait 10t
            - teleport <[player]> <player.location.left[<util.random.decimal[-0.01].to[0.01]>]>
            - narrate "<player.display_name><&a> has accepted your teleport request!" targets:<[player]>
            - narrate "<&a>You have accepted <[player].display_name><&a>'s teleport request!"
        - else if <yaml[teleporthere_requests].contains[<player.uuid>]> && <yaml[teleporthere_requests].read[<player.uuid>].contains[<[player].uuid>]>:
            - yaml set id:teleporthere_requests <player.uuid>:<-:<[player].uuid>
            - wait 10t
            - teleport <[player].location.left[<util.random.decimal[-0.01].to[0.01]>]>
            - narrate "<player.display_name><&a> has accepted your teleport request!" targets:<[player]>
            - narrate "<&a>You have accepted <[player].display_name><&a>'s teleport request!"
        - else:
            - define Reason "You do not have a teleport request from the specified person!"
            - inject Command_Error
    - else:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax
        - define player_name <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>].not>].first>
        - ~bungeetag hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_name]>]]> save:player_1_map
        - if <entry[player_1_map].result.is_empty>:
            - define Reason "The specified player is invalid."
            - inject Command_Error
        - bungeerun hub1 networkteleport_request def:<list_single[<entry[player_1_map].result.first>].include[<player>|<bungee.server>]>

networkteleport_timeout_accept:
    type: task
    definitions: player_1_map|attached_player|attached_server
    script:
    - if <[player_1_map].get[server]> != <[attached_server]>:
        - bungee <[player_1_map].get[server]>:
            - adjust <player[<[player_1_map].get[uuid]>]> send_to:<[attached_server]>
        - define Timeout <util.time_now.add[1m]>
        - waituntil rate:2s <player[<[player_1_map].get[uuid]>].is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> != 0
        - if <player[<[player_1_map].get[uuid]>].is_online.not>:
            - adjust <queue> linked_player:<[attached_player]>
            - define Reason "Timeout error."
            - inject Command_Error
    - teleport <player[<[player_1_map].get[uuid]>]> <[attached_player].location.left[<util.random.decimal[-0.01].to[0.01]>]>
    - narrate "<&a>You have accepted <player[<[player_1_map].get[uuid]>].display_name><&a>'s teleport request!" targets:<[attached_player]>
    - narrate "<[attached_player].display_name><&a> has accepted your teleport request!" targets:<player[<[player_1_map].get[uuid]>]>

networkteleporthere_timeout_accept:
    type: task
    definitions: player_1_map|attached_player|attached_server
    script:
    - if <[player_1_map].get[server]> != <[attached_server]>:
        - bungee <[attached_server]>:
            - adjust <[attached_player]> send_to:<[player_1_map].get[server]>
        - define Timeout <util.time_now.add[1m]>
        - waituntil rate:2s <[attached_player].is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> != 0
        - if <[attached_player].is_online.not>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "Timeout error."
                - inject Command_Error
    - teleport <[attached_player]> <player[<[player_1_map].get[uuid]>].location.left[<util.random.decimal[-0.01].to[0.01]>]>
    - narrate "<&a>You have accepted <player[<[player_1_map].get[uuid]>].display_name><&a>'s teleport request!" targets:<[attached_player]>
    - narrate "<[attached_player].display_name><&a> has accepted your teleport request!" targets:<player[<[player_1_map].get[uuid]>]>

networkteleport_accept:
    type: task
    definitions: player_1_map|attached_player|attached_server
    script:
    - if <yaml[networkteleport_requests].contains[<[player_1_map].get[uuid]>]> && <yaml[networkteleport_requests].read[<[player_1_map].get[uuid]>].contains[<[attached_player].uuid>]>:
        - yaml set id:networkteleport_requests <[player_1_map].get[uuid]>:<-:<[attached_player].uuid>
        - bungeerun <[attached_server]> networkteleport_timeout_accept def:<list_single[<[player_1_map]>].include[<[attached_player]>|<[attached_server]>]>
    - else if <yaml[networkteleporthere_requests].contains[<[attached_player].uuid>]> && <yaml[networkteleporthere_requests].read[<[attached_player].uuid>].contains[<[player_1_map].get[uuid]>]>:
        - yaml set id:networkteleporthere_requests <[attached_player].uuid>:<-:<[player_1_map].get[uuid]>
        - bungeerun <[player_1_map].get[server]> networkteleporthere_timeout_accept def:<list_single[<[player_1_map]>].include[<[attached_player]>|<[attached_server]>]>
    - else:
        - bungee <[attached_server]>:
            - adjust <queue> linked_player:<[attached_player]>
            - define Reason "You do not have a teleport request from the specified person!"
            - inject Command_Error

teleporthere_global_command:
    type: command
    name: teleporthere
    usage: /teleporthere (<&lt>Player<&gt>(,...)/(everyone/all)) (-r/-request/request) (-l/-local/-locally/-s/-server)
    aliases:
    - tphere
    - ntph
    - tph
    - networktphere
    - servertphere
    description: Teleports a player to your location within the server or across servers within the network
    adminpermission: custom.teleporthere.command
    tab complete:
    - define Arg1 <server.online_players.parse[name]>
    - define Arg2 <server.online_players.parse[name]>
    - inject MultiArg_Command_Tabcomplete
    script:
    # % ██ [  Check for local flag  ] ██
    - if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].is_empty.not>:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 3:
            - inject Command_Syntax
        # % ██ [  One Argument  ] ██
        - define Args <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>].not>]>
        - if <[Args].size> == 1:
            - if <list[everyone|all].contains[<[Args].first>]>:
                - if <player.has_permission[adriftus.staff].not>:
                    - define Reason "You can only request to have players teleport to you."
                    - inject Permission_Error
                - teleport <server.online_players.exclude[<player>]> <player.location.left[<util.random.decimal[-0.01].to[0.01]>]>
                - narrate targets:<server.online_players.exclude[<player>]> "<player.display_name><&a> has teleported you to them."
                - narrate "<&a>You have teleported all online players to you."
            - else if <[Args].first.contains[,]>:
                - define player_arg <[Args].first>
                - foreach <[player_arg].split[,]> as:user:
                    - inject player_verification
                    - define player_list:->:<[user]>
                - if <player.has_permission[adriftus.staff]>:
                    - teleport <[player_list]> <player.location.left[<util.random.decimal[-0.01].to[0.01]>]>
                    - narrate "<player.display_name><&a> has teleported you to them." targets:<[player_list]>
                    - narrate "<&a>You have teleported the specified players to you."
                - else:
                    - run multiple_teleporthere_request def:<list_single[<[player_list]>].include[<player>]>
            - else:
                - define player_2 <server.match_player[<[Args].first>]||null>
                - if <[player_2]> == null || <[player_2].uuid> == <player.uuid>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - if <player.has_permission[adriftus.staff]>:
                    - teleport <[player_2]> <player.location.left[<util.random.decimal[-0.01].to[0.01]>]>
                    - narrate "<&a>You have teleported <[player_2].display_name><&a> to you."
                    - narrate "<player.display_name><&a> has teleported you to them." targets:<[player_2]>
                - else:
                    - run teleporthere_request def:<player>|<[player_2]>|<player>
        # % ██ [  Staff-Only Check  ] ██
        - else if <player.has_permission[adrifuts.staff].not>:
            - define Reason "You can only request to have players teleport to you."
            - inject Permission_Error
        # % ██ [  Two Arguments with Request  ] ██
        - else:
            - if <list[everyone|all].contains[<[Args].first>]>:
                - run everyone_teleporthere_request def:<player>
            - else if <[Args].first.contains[,]>:
                - define player_arg <[Args].first>
                - foreach <[player_arg].split[,]> as:user:
                    - inject player_verification
                    - define player_list:->:<[user]>
                    - run multiple_teleporthere_request def:<list_single[<[player_list]>].include[<player>]>
            - else:
                - define player_1 <server.match_player[<[Args].first>]||null>
                - if <[player_1]> == null || <[player_1].uuid> == <player.uuid>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - run teleporthere_request def:<[player_1]>|<player>
    # % ██ [  Invalid Number of Local Flags?  ] ██
    - else if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].size> > 1:
        - inject Command_Syntax
    - else:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 2:
            - inject Command_Syntax
        # % ██ [  One Argument  ] ██
        - if <context.args.size> == 1:
            - if <list[everyone|all].contains[<context.args.first>]>:
                - if <player.has_permission[adriftus.staff].not>:
                    - define Reason "You can only request a player or list of players to teleport to you."
                    - inject Permission_Error
                - bungeerun hub1 everyone_networkteleporthere_request def:<player>|<bungee.server>|<player.display_name>|<player.name>
            - else if <context.args.first.contains[,]>:
                - define player_arg <context.args.first>
                - repeat <[player_arg].to_list.count[,].add[1]>:
                    - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]]> save:network_player
                    - if <entry[network_player].result.is_empty> || <[player_arg].before[,]> == <player.name>:
                        - define Reason "At least one of the specified players is invalid."
                        - inject Command_Error
                    - define uuid_list:->:<entry[network_player].result.first.get[uuid]>
                    - define player_arg <[player_arg].after[,]>
                - bungeerun hub1 multiple_networkteleporthere_request def:<list_single[<[uuid_list]>].include_single[<player>|<player.display_name>]>
            - else:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<player.name>]]> save:player_map_1
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.first>]]> save:player_map_2
                - if <entry[player_map_2].result.is_empty> || <entry[player_map_2].result.first.get[uuid]> == <player.uuid>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - define player_map_2 <entry[player_map_2].result.first>
                - if <player.has_permission[adriftus.staff].not>:
                    - bungeerun hub1 networkteleporthere_request def:<list_single[<[player_map_2]>].include_single[<entry[player_map_1].result.first>]>
                - else:
                    - if <[player_map_2].get[server]> != <bungee.server>:
                        - define server <bungee.server>
                        - bungee <[player_map_2].get[server]>:
                            - adjust <player[<[player_map_2].get[uuid]>]> send_to:<[server]>
                        - define Timeout <util.time_now.add[1m]>
                        - waituntil rate:2s <player[<[player_map_2].get[uuid]>].is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> != 0
                        - if <player[<[player_map_2].get[uuid]>].is_online.not>:
                            - define Reason "Timeout error."
                            - inject Command_Error
                    - teleport <player[<[player_map_2].get[uuid]>]> <player.location.left[<util.random.decimal[-0.01].to[0.01]>]>
                    - narrate "<&5>You have teleported <player[<[player_map_2].get[uuid]>].display_name><&a> to you."
                    - narrate "<&5><player.display_name> has teleported you to them." targets:<player[<[player_map_2].get[uuid]>]>
        # % ██ [  Staff-Only Check  ] ██
        - else if <player.has_permission[adrifuts.staff].not>:
            - define Reason "You can only teleport to a player."
            - inject Permission_Error
        # % ██ [  Two Arguments wtih Request  ] ██
        - else:
            - if <list[everyone|all].contains[<context.args.first>]>:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<player.name>]]> save:player_map_2
                - bungeerun hub1 everyone_networkteleporthere_request def:<list_single[<entry[player_map_2].result.first>].include[<player>|<bungee.server>|<proc[User_Display_Simple].context[<player>]>]>
            - else if <context.args.first.contains[,]>:
                - define player_arg <context.args.first>
                - repeat <[player_arg].to_list.count[,].add[1]>:
                    - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<[player_arg].before[,]>]]> save:network_player
                    - if <entry[network_player].result.is_empty> || <[player_arg].before[,]> == <player.name>:
                        - define Reason "At least one of the specified players is invalid."
                        - inject Command_Error
                    - define uuid_list:->:<entry[network_player].result.first.get[uuid]>
                    - define player_arg <[player_arg].after[,]>
                - bungeerun hub1 multiple_networkteleporthere_request def:<list_single[<[uuid_list]>].include[<player>|<player.display_name>]>
            - else:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<player.name>]]> save:player_map_1
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.first>]]> save:player_map_2
                - if <entry[player_map_2].result.is_empty> || <entry[player_map_2].result.first.get[uuid]> == <player.uuid>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - bungeerun hub1 networkteleporthere_request def:<list_single[<entry[player_map_2].result.first>].include_single[<entry[player_map_1].result.first>]>

teleport_global_command:
    type: command
    name: teleport
    usage: /teleport (<&lt>Player<&gt> (<&lt>Player<&gt>)/(everyone/all) <&lt>Player<&gt>) (-r/-request/request) (-l/-local/-locally/-s/-server)
    description: Teleports a player to another player within the server or across servers within the network
    aliases:
    - tp
    - ntp
    - networktp
    - servertp
    adminpermission: custom.teleport.command
    tab complete:
    - define Arg1 <server.online_players.parse[name]>
    - define Arg2 <server.online_players.parse[name]>
    - inject MultiArg_Command_Tabcomplete
    script:
    # % ██ [  Check for local flag  ] ██
    - if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].is_empty.not>:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 4:
            - inject Command_Syntax
        # % ██ [  One Argument  ] ██
        - define Args <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>].not>]>
        - if <[Args].size> == 1:
            - define player_2 <server.match_player[<[Args].first>]||null>
            - if <[player_2]> == null || <[player_2].uuid> == <player.uuid>:
                - define Reason "The specified player is invalid."
                - inject Command_Error
            - if <player.has_permission[adriftus.staff]>:
                - teleport <[player_2].location.left[<util.random.decimal[-0.01].to[0.01]>]>
                - narrate "<&a>You have teleported to <[player_2].display_name>."
                - narrate "<player.display_name><&a> has teleported to you." targets:<[player_2]>
            - else:
                - run teleport_request def:<player>|<[player_2]>|<player>
        # % ██ [  Staff-Only Check  ] ██
        - if <player.has_permission[adrifuts.staff].not>:
            - define Reason "You can only teleport to a player."
            - inject Permission_Error
        # % ██ [  Two Arguments without Request  ] ██
        - if <[Args].size> == 2 && <list[-r|-request].contains[<[Args].get[2]>].not>:
            - if <list[everyone|all].contains[<[Args].first>]>:
                - define player_2 <server.match_player[<[Args].get[2]>]||null>
                - if <[player_2]> == null:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - teleport <server.online_players> <[player_2].location.left[<util.random.decimal[-0.01].to[0.01]>]>
                - narrate "<player.display_name><&a> has teleported everyone to <[player_2].display_name><&a>." targets:<server.online_players.exclude[<player>|<[player_2]>]>
                - narrate "<&a>You have teleported everyone to <[player_2].display_name><&a>."
                - narrate "<player.display_name><&a> has teleported everyone to you." targets:<[player_2]>
            - else:
                - define player_1 <server.match_player[<[Args].first>]||null>
                - define player_2 <server.match_player[<[Args].get[2]>]||null>
                - if <[player_1]> == null || <[player_2]> == null:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - teleport <[player_1]> <[player_2].location.left[<util.random.decimal[-0.01].to[0.01]>]>
                - narrate "<&a>You have teleported <[player_1].display_name><&a> to <[player_2].display_name><&a>."
                - narrate "<player.display_name><&a> has teleported you to <[player_2].display_name><&a>." targets:<[player_1]>
                - narrate "<player.display_name><&a> has teleported <[player_1].display_name><&a> to you." targets:<[player_2]>
        # % ██ [  Three Arguments  ] ██
        - else if <[Args].size> == 3:
            - if <list[everyone|all].contains[<[Args].first>]>:
                - define player_2 <server.match_player[<[Args].get[2]>]||null>
                - if <[player_2]> == null:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - run everyone_teleport_request def:<[player_2]>|<player>
            - else:
                - define player_1 <server.match_player[<[Args].first>]||null>
                - define player_2 <server.match_player[<[Args].get[2]>]||null>
                - if <[player_1]> == null || <[player_2]> == null:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - run teleport_request def:<[player_1]>|<[player_2]>|<player>
        # % ██ [  Two Arguments with Request  ] ██
        - else:
            - if <list[everyone|all].contains[<[Args].first>]>:
                - run everyone_teleport_request def:<player>|<player>
            - else:
                - define player_2 <server.match_player[<[Args].get[2]>]||null>
                - if <[player_2]> == null || <[player_2].uuid> == <player.uuid>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - run teleport_request def:<player>|<[player_2]>|<player>
    # % ██ [  Invalid Number of Local Flags?  ] ██
    - else if <context.args.filter_tag[<list[-l|-local|-locally|-s|-server].contains[<[filter_value]>]>].size> > 1:
        - inject Command_Syntax
    - else:
        # % ██ [  Syntax Check (Arg Count)  ] ██
        - if <context.args.is_empty> || <context.args.size> > 3:
            - inject Command_Syntax
        # % ██ [  One Argument  ] ██
        - if <context.args.size> == 1:
            - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.first>]]> save:player_map_2
            - if <entry[player_map_2].result.is_empty> || <entry[player_map_2].result.first.get[uuid]> == <player.uuid>:
                - define Reason "The specified player is invalid."
                - inject Command_Error
            - define player_map_2 <entry[player_map_2].result.first>
            - if <player.has_permission[adriftus.staff].not>:
                - bungeerun hub1 networkteleport_request def:<player>|<[player_2]>|<player>
            - else:
                - if <bungee.server> != <[player_map_2].get[server]>:
                    - adjust <player> send_to:<[player_map_2].get[server]>
                    - define Timeout <util.time_now.add[1m]>
                    - bungee <[player_map_2].get[server]>:
                        - waituntil rate:2s <player.is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> != 0
                    - ~bungeetag server:<[player_map_2].get[server]> <player.is_online.not> save:timeout_status
                    - if <entry[timeout_status].result>:
                        - define Reason "Timeout error"
                        - inject Command_Error
                - bungee <[player_map_2].get[server]>:
                    - teleport <player[<[player_map_2].get[uuid]>].location.left[<util.random.decimal[-0.01].to[0.01]>]>
                    - narrate "<&5>You have teleported to <player[<[player_map_2].get[uuid]>].display_name><&a>."
                    - narrate "<&5><player.display_name> has teleported themself to you." targets:<player[<[player_map_2].get[uuid]>]>
        # % ██ [  Staff-Only Check  ] ██
        - if <player.has_permission[adrifuts.staff].not>:
            - define Reason "You can only teleport to a player."
            - inject Permission_Error
        # % ██ [  Two Arguments without Request  ] ██
        - if <context.args.size> == 2 && <list[-r|-request].contains[<context.args.get[2]>].not>:
            - if <list[everyone|all].contains[<context.args.first>]>:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.get[2]>]]> save:player_map_2
                - if <entry[player_map_2].result.is_empty>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - define player_map_2 <entry[player_map_2].result.first>
                - define dest_server <[player_map_2].get[server]>
                - bungee <[dest_server]>:
                    - teleport <server.online_players.exclude[<player[<[player_map_2].get[uuid]>]>]> <player[<[player_map_2].get[uuid]>].location.left[<util.random.decimal[-0.01].to[0.01]>]>
                    - narrate "<player.display_name><&5> has teleported you to <server.match_player[<context.args.get[2]>].display_name><&a>." targets:<server.online_players.exclude[<player[<entry[player_map_2].result.get[uuid]>]>|<player>]>
                    - narrate "<player.display_name><&5> has teleported everyone to you." targets:<player[<entry[player_map_2].result.get[uuid]>]>
                - foreach <bungee.list_servers.exclude[relay|<[dest_server]>]> as:s:
                    - ~bungeetag server:<[s]> <server.online_players> save:online_players
                    - bungee <[s]>:
                        - adjust <server.online_players> send_to:<[dest_server]>
                    - wait 1s
                    - bungee <[dest_server]>:
                        - teleport <entry[online_players].result> <player[<[player_map_2].get[uuid]>].location.left[<util.random.decimal[-0.01].to[0.01]>]>
                - narrate "<&a>You have teleported everyone across the network to <context.args.get[2]>."
            - else:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.first>]]> save:player_map_1
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.get[2]>]]> save:player_map_2
                - if <entry[player_map_1].result.is_empty> || <entry[player_map_2].result.is_empty>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - define player_map_1 <entry[player_map_1].result.first>
                - define player_map_2 <entry[player_map_2].result.first>
                - bungeerun <[player_map_2].get[server]> networkteleport_send_timeout_check def:<list_single[<[player_map_1]>].include_single[<[player_map_2]>].include[<player>|<bungee.server>|<player.display_name>]>
        # % ██ [  Three Arguments  ] ██
        - else if <[Arg].size> == 3:
            - if <list[everyone|all].contains[<context.args.first>]>:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.get[2]>]]> save:player_map_2
                - if <entry[player_map_2].result.is_empty>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - bungeerun hub1 everyone_networkteleport_request def:<list_single[<entry[player_map_2].result.first>].include[<player>|<bungee.server>|<proc[User_Display_Simple].context[<player>]>]>
            - else:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.first>]]> save:player_map_1
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.get[2]>]]> save:player_map_2
                - if <entry[player_map_1].result.is_empty> || <entry[player_map_2].result.is_empty>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - bungeerun hub1 networkteleport_request def:<list_single[<entry[player_map_1].result.first>].include_single[<entry[player_map_2].result.first>].include[<player>]>
        # % ██ [  Two Arguments wtih Request  ] ██
        - else:
            - if <list[everyone|all].contains[<context.args.first>]>:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<player.name>]]> save:player_map_2
                - bungeerun hub1 everyone_networkteleport_request def:<list_single[<entry[player_map_2].result.first>].include[<player>|<bungee.server>|<proc[User_Display_Simple].context[<player>]>]>
            - else:
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<player.name>]]> save:player_map_1
                - ~bungeetag server:hub1 <yaml[data_handler].read[].filter[get[name].is[==].to[<context.args.first>]]> save:player_map_2
                - if <entry[player_map_2].result.is_empty>:
                    - define Reason "The specified player is invalid."
                    - inject Command_Error
                - bungeerun hub1 networkteleport_request def:<list_single[<entry[player_map_1].result.first>].include_single[<entry[player_map_2].result.first>].include[<player>]>

networkteleport_send_timeout_check:
    type: task
    definitions: player_map_1|player_map_2|attached_player|attached_server|attached_displayname
    script:
    - if <[player_map_1].get[server]> != <[player_map_2].get[server]>:
        - bungee <[player_map_1].get[server]>:
            - adjust <player[<[player_map_1].get[uuid]>]> send_to:<[player_map_2].get[server]>
        - define Timeout <util.time_now.add[1m]>
        - waituntil rate:2s <player[<[player_map_1].get[uuid]>].is_online> || <[Timeout].duration_since[<util.time_now>].in_seconds> != 0
        - if <player[<[player_map_1].get[uuid]>].is_online.not>:
            - bungee <[attached_server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "Timeout error."
                - inject Command_Error
    - teleport <player[<[player_map_1].get[uuid]>]> <player[<[player_map_2].get[uuid]>].location.left[<util.random.decimal[-0.01].to[0.01]>]>
    - narrate "<[attached_displayname]><&5> has teleported you to <player[<[player_map_2].get[uuid]>].display_name>." targets:<player[<[player_map_1].get[uuid]>]>
    - narrate "<[attached_displayname]><&5> has teleported <player[<[player_map_1].get[uuid]>].display_name> to you." targets:<player[<[player_map_2].get[uuid]>]>

everyone_teleporthere_request:
    type: task
    definitions: player
    script:
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<[player]>]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player].name> -s"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player].name> -s"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel everyone -s"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>
    - define online_players <server.online_players.exclude[<[player]>]>
    - foreach <[online_players]> as:p:
        - yaml set id:teleporthere_requests <[p].uuid>:->:<[player].uuid>
    - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<[player]>]> <proc[Colorize].context[is requesting you to teleport to them.|green]>" targets:<[online_players]>
    - narrate targets:<[player]> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to everyone.|green]>"
    - wait 3m
    - foreach <[online_players]> as:p:
        - yaml set id:teleporthere_requests <[p].uuid>:<-:<[player].uuid>

multiple_teleporthere_request:
    type: task
    definitions: player_list|player_2
    script:
    - foreach <[player_list]> as:p:
        - if <yaml[teleporthere_requests].contains[<[p].uuid>]> && <yaml[teleporthere_requests].read[<[p].uuid>].contains[<[player_2].uuid>]>:
            - adjust <queue> linked_player:<[player_2]>
            - define Reason "You have already sent a request at least one of the people!"
            - inject Command_Error
        - else if <yaml[teleporthere_cooldowns].contains[<[p].uuid>]> && <yaml[teleporthere_cooldowns].read[<[p].uuid>].keys.contains[<[player_2].uuid>]>:
            - if <yaml[teleporthere_cooldowns].read[<[p].uuid>].get[<[player_2].uuid>].duration_since[<util.time_now>].in_minutes> >= 3:
                - yaml id:teleporthere_cooldowns set <[p].uuid>:<yaml[teleporthere_cooldowns].read[<[p].uuid>].exclude[<[player_2].uuid>]>
            - else:
                - adjust <queue> linked_player:<[player_2]>
                - define Reason "At least one of the players specified is on cooldown!"
                - inject Command_Error
    - foreach <[player_list]> as:p:
        - yaml set id:teleporthere_requests <[p].uuid>:->:<[player_2].uuid>
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<[player_2]>]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_2].name> -s"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_2].name> -s"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel <[player_list].parse[name].separated_by[,]>"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - narrate targets:<[player_list]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<[player_2]>]> <proc[Colorize].context[is requesting you to teleport to them.|green]>"
    - narrate targets:<[player_2]> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <[player_list].parse[display_name].formatted> <&2>."
    - wait 3m
    - foreach <[player_list]> as:p:
        - yaml set id:teleporthere_requests <[p].uuid>:<-:<[player_2].uuid>

teleporthere_request:
    type: task
    definitions: player_1|attached_player
    script:
    - if <yaml[teleporthere_requests].contains[<[player_1].uuid>]> && <yaml[teleporthere_requests].read[<[player_1].uuid>].contains[<[attached_player].uuid>]>:
        - adjust <queue> linked_player:<[attached_player]>
        - define Reason "You have already sent a request to that person!"
        - inject Command_Error
    - else if <yaml[teleporthere_cooldowns].contains[<[player_1].uuid>]> && <yaml[teleporthere_cooldowns].read[<[player_1].uuid>].keys.contains[<[attached_player].uuid>]>:
        - if <util.time_now.duration_since[<yaml[teleporthere_cooldowns].read[<[player_1].uuid>].get[<[attached_player].uuid>]>].in_minutes> >= 3:
            - yaml id:teleporthere_cooldowns set <[player_1].uuid>:<yaml[teleporthere_cooldowns].read[<[player_1].uuid>].exclude[<[attached_player].uuid>]>
        - else:
            - adjust <queue> linked_player:<[attached_player]>
            - define Reason "The player specified is on cooldown!"
            - inject Command_Error
    - yaml set id:teleporthere_requests <[player_1].uuid>:->:<[attached_player].uuid>

    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<[attached_player]>]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[attached_player].name> -s"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[attached_player].name> -s"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel <[player_1].name> -s"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - narrate targets:<[player_1]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<[attached_player]>]> <proc[Colorize].context[is requesting you to teleport to them.|green]>"
    - narrate targets:<[attached_player]> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[player_1]>]><&2>."
    - wait 3m
    - yaml set id:teleporthere_requests <[player_1].uuid>:<-:<[attached_player].uuid>

everyone_teleport_request:
    type: task
    definitions: player_2|attached_player
    script:
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<[player_2]>]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_2].name> -s"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_2].name> -s"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel everyone -s"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>
    - define online_players <server.online_players.exclude[<[attached_player]>|<[player_2]>]>
    - foreach <[online_players]> as:p:
        - yaml set id:teleport_requests <[p].uuid>:->:<[player_2].uuid>
    - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<[attached_player]>]> <proc[Colorize].context[is requesting you to teleport to |green]> <proc[User_Display_Simple].context[<[player_2]>]><&2>." targets:<[online_players]>
    - narrate targets:<[attached_player]> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to: Everyone.|green]>"
    - teleport <[attached_player]> <[player_2].location.left[<util.random.decimal[-0.01].to[0.01]>]>
    - narrate "<&a>You have been teleported to <proc[User_Display_Simple].context[<[player_2]>]>'s location." targets:<[attached_player]>
    - wait 3m
    - foreach <[online_players]> as:p:
        - yaml set id:teleport_requests <[p].uuid>:<-:<[player_2].uuid>

teleport_request:
    type: task
    definitions: player_1|player_2|attached_player
    script:
    - if <yaml[teleport_requests].contains[<[player_1].uuid>]> && <yaml[teleport_requests].read[<[player_1].uuid>].contains[<[player_2].uuid>]>:
        - adjust <queue> linked_player:<[attached_player]>
        - define Reason "You have already sent a request to that person!"
        - inject Command_Error
    - else if <yaml[teleport_cooldowns].contains[<[player_1].uuid>]> && <yaml[teleport_cooldowns].read[<[player_1].uuid>].keys.contains[<[player_2].uuid>]>:
        - if <util.time_now.duration_since[<yaml[teleport_cooldowns].read[<[player_1].uuid>].get[<[player_2].uuid>]>].in_minutes> >= 3:
            - yaml id:teleport_cooldowns set <[player_1].uuid>:<yaml[teleport_cooldowns].read[<[player_1].uuid>].exclude[<[player_2].uuid>]>
        - else:
            - adjust <queue> linked_player:<[attached_player]>
            - define Reason "The player specified is on cooldown!"
            - inject Command_Error
    - yaml set id:teleport_requests <[player_1].uuid>:->:<[player_2].uuid>

    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><proc[User_Display_Simple].context[<[player_2]>]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_2].name> -s"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_2].name> -s"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel <[player_1].name> -s"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - if <list[<[player_1]>|<[player_2]>].contains[<[attached_player]>].not>:
        - narrate targets:<[attached_player]> "<proc[Colorize].context[Teleport request sent from <[player_1].display_name> to:|green]> <proc[User_Display_Simple].context[<[player_2]>]><&2>."
    - narrate targets:<[player_2]> "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <proc[User_Display_Simple].context[<[player_1]>]> <proc[Colorize].context[is requesting to teleport to you.|green]>"
    - narrate targets:<[player_1]> "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <proc[User_Display_Simple].context[<[player_2]>]><&2>."
    - wait 3m
    - yaml set id:teleport_requests <[player_1].uuid>:<-:<[player_2].uuid>

everyone_networkteleport_request:
    type: task
    definitions: player_map_2|attached_player|attached_server|attached_displayname
    script:
    - define player_2 <player[<[player_map_2].get[uuid]>]>
    - define uuids <yaml[data_handler].read[].parse[get[uuid]].exclude[<[player_map_2].get[uuid]>|<[attached_player].uuid>]>
    - foreach <[uuids]> as:u:
        - yaml set id:networkteleport_requests <[u]>:->:<[player_map_2].get[uuid]>
    - ~bungeetag server:<[player_map_2].get[server]> <player[<[player_map_2].get[uuid]>].display_name> save:displayname_2
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><entry[displayname_2].result>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_map_2].get[name]>"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_map_2].get[name]>"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel everyone"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>
    - if <list[<player[<[player_map_2].get[uuid]>]>].contains[<[attached_player]>].not>:
        - bungee <[attached_server]>:
            - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent from everyone to:|green]> <entry[displayname_2].result><&2>." to:<[attached_player]>
    - foreach <bungee.list_servers.exclude[relay]> as:s:
        - bungee <[s]>:
            - if <player[<[player_map_2].get[uuid]>].is_online>:
                - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to everyone from:|green]> <[attached_displayname]><&2>." to:<player[<[player_map_2].get[uuid]>]>
            - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <[attached_displayname]> <proc[Colorize].context[is requesting you to teleport to|green]> <entry[displayname_2].result><&2>." targets:<server.online_players.exclude[<[attached_player]>|<player[<[player_map_2].get[uuid]>]>]>
    - wait 3m
    - foreach <[uuids]> as:u:
        - yaml set id:networkteleport_requests <[u]>:<-:<[player_map_2].get[uuid]>


networkteleport_request:
    type: task
    definitions: player_map_1|player_map_2|attached_player
    script:
    - define player_uuid_1 <[player_map_1].get[uuid]>
    - define player_uuid_2 <[player_map_2].get[uuid]>
    - if <yaml[networkteleport_requests].contains[<[player_uuid_1]>]> && <yaml[networkteleport_requests].read[<[player_uuid_1]>].contains[<[player_uuid_2]>]>:
        - bungee <yaml[data_handler].read[].filter[get[uuid].is[==].to[<[attached_player].uuid>]].first.get[server]>:
            - adjust <queue> linked_player:<[attached_player]>
            - define Reason "You have already sent a request to that person!"
            - inject Command_Error
    - else if <yaml[networkteleport_cooldowns].contains[<[player_uuid_1]>]> && <yaml[networkteleport_requests].read[<[player_uuid_1]>].keys.contains[<[player_uuid_2]>]>:
        - if <util.time_now.duration_since[<yaml[networteleport_cooldowns].read[<[player_uuid_1]>].get[<[player_uuid_2]>]>].in_minutes> >= 3:
            - yaml id:networkteleport_cooldowns set <[player_uuid_1]>:<yaml[networkteleport_cooldowns].read[<[player_uuid_1]>].exclude[<[player_uuid_2]>]>
        - else:
            - bungee <yaml[data_handler].read[].filter[get[uuid].is[==].to[<[attached_player].uuid>]].first.get[server]>:
                - adjust <queue> linked_player:<[attached_player]>
                - define Reason "The player specified is on cooldown!"
                - inject Command_Error
    - yaml set id:networkteleport_requests <[player_uuid_1]>:->:<[player_uuid_2]>
    - ~bungeetag server:<[player_map_1].get[server]> <player[<[player_uuid_1]>].display_name> save:displayname_1
    - ~bungeetag server:<[player_map_2].get[server]> <player[<[player_uuid_2]>].display_name> save:displayname_2
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><entry[displayname_2].result>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_map_2].get[name]>"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_map_2].get[name]>"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel <[player_map_2].get[name]>"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - if <list[<player[<[player_map_1].get[uuid]>]>|<player[<[player_map_2].get[uuid]>]>].contains[<[attached_player]>].not>:
        - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent from <entry[displayname_1].result> to:|green]> <entry[displayname_2].result><&2>." to:<[attached_player]>
    - bungee <[player_map_1].get[server]>:
        - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <entry[displayname_2].result><&2>." to:<player[<[player_map_1].get[uuid]>]>
    - bungee <[player_map_2].get[server]>:
        - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <entry[displayname_1].result> <proc[Colorize].context[is requesting to teleport to you.|green]>" targets:<player[<[player_map_2].get[uuid]>]>
    - wait 3m
    - yaml set id:networkteleport_requests <[player_uuid_1]>:<-:<[player_uuid_2]>

networkteleporthere_request:
    type: task
    definitions: player_map_1|player_map_2
    script:
    - define player_uuid_1 <[player_map_1].get[uuid]>
    - define player_uuid_2 <[player_map_2].get[uuid]>
    - if <yaml[networkteleporthere_requests].contains[<[player_uuid_1]>]> && <yaml[networkteleporthere_requests].read[<[player_uuid_1]>].contains[<[player_uuid_2]>]>:
        - bungee <[player_map_2].get[server]>:
            - adjust <queue> linked_player:<player[<[player_uuid_2]>]>
            - define Reason "You have already sent a request to that person!"
            - inject Command_Error
    - else if <yaml[networkteleporthere_cooldowns].contains[<[player_uuid_1]>]> && <yaml[networkteleporthere_cooldowns].read[<[player_uuid_1]>].keys.contains[<[player_uuid_2]>]>:
        - if <util.time_now.duration_since[<yaml[networkteleporthere_cooldowns].read[<[player_uuid_1]>].get[<[player_uuid_2]>]>].in_minutes> >= 3:
            - yaml id:networkteleporthere_cooldowns set <[player_uuid_1]>:<yaml[networkteleporthere_cooldowns].read[<[player_uuid_1]>].exclude[<[player_uuid_2]>]>
        - else:
            - bungee <[player_map_2].get[server]>:
                - adjust <queue> linked_player:<player[<[player_uuid_2]>]>
                - define Reason "The player specified is on cooldown!"
                - inject Command_Error
    - yaml set id:networkteleporthere_requests <[player_uuid_1]>:->:<[player_uuid_2]>
    - ~bungeetag server:<[player_map_1].get[server]> <player[<[player_uuid_1]>].display_name> save:displayname_1
    - ~bungeetag server:<[player_map_2].get[server]> <player[<[player_uuid_2]>].display_name> save:displayname_2
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><entry[displayname_1].result>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_map_2].get[name]>"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_map_2].get[name]>"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel <[player_map_1].get[name]>"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - bungee <[player_map_2].get[server]>:
        - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <entry[displayname_1].result><&2>." to:<player[<[player_map_2].get[uuid]>]>
    - bungee <[player_map_1].get[server]>:
        - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <entry[displayname_2].result> <proc[Colorize].context[is requesting you teleport to them.|green]>" targets:<player[<[player_map_1].get[uuid]>]>
    - wait 3m
    - yaml set id:networkteleporthere_requests <[player_uuid_1]>:<-:<[player_uuid_2]>

multiple_networkteleporthere_request:
    type: task
    definitions: uuid_list|player_2|player_2_displayname
    script:
    - foreach <[uuid_list]> as:u:
        - if <yaml[networkteleporthere_requests].contains[<[u]>]> && <yaml[networkteleporthere_requests].read[<[u]>].contains[<[player_2].uuid>]>:
            - bungee <yaml[data_handler].read[].filter[get[uuid].is[==].to[<[player_2].uuid>]].first.get[server]>:
                - adjust <queue> linked_player:<[player_2]>
                - define Reason "You have already sent a request to at least one of the specified people!"
                - inject Command_Error
        - else if <yaml[networkteleporthere_cooldowns].contains[<[u]>]> && <yaml[networkteleporthere_cooldowns].read[<[u]>].keys.contains[<[player_2].uuid>]>:
            - if <util.time_now.duration_since[<yaml[networkteleporthere_cooldowns].read[<[u]>].get[<[player_2].uuid>]>]>:
                - yaml id:networkteleporthere_cooldowns set <[u]>:<yaml[networkteleporthere_cooldowns].read[<[u]>].exclude[<[player_2].uuid>]>
            - else:
                - bungee <yaml[data_handler].read[].filter[get[uuid].is[==].to[<[player_2].uuid>]].first.get[server]>:
                    - adjust <queue> linked_player:<[player_2]>
                    - define Reason "One of the players specified is on cooldown!"
                    - inject Command_Error
    - foreach <[uuid_list]> as:u:
        - yaml set id:networkteleport_requests <[u]>:->:<[player_2].uuid>

    - define player_maps <yaml[data_handler].read[].filter_tag[<[uuid_list].contains[<[filter_value].get[uuid]>]>]>
    - define player_2_name <yaml[data_handler].read[].filter[get[uuid].is[==].to[<[player_2].uuid>]].first.get[name]>
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><[player_2_displayname]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[player_2_name]>"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[player_2_name]>"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel <[player_maps].parse[get[name]].separated_by[,]>"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - foreach <[player_maps].parse[get[server]].deduplicate> as:s:
        - bungee <[s]>:
            - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <[player_2_displayname]> <proc[Colorize].context[is requesting you teleport to them.|green]>" targets:<[player_maps].filter[get[server].is[==].to[<[s]>]].parse_tag[<player[<[parse_value].get[uuid]>]>]>
    - bungee <yaml[data_handler].read[].filter[get[uuid].is[==].to[<[player_2].uuid>]].first.get[server]>:
        - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to:|green]> <[player_maps].parse[get[name]].formatted><&2>." to:<[player_2]>
    - wait 3m
    - foreach <[uuid_list]> as:u:
        - yaml set id:networkteleporthere_requests <[u]>:<-:<[player_2].uuid>

everyone_networkteleporthere_request:
    type: task
    definitions: attached_player|attached_server|attached_displayname|attached_name
    script:
    - define uuids <yaml[data_handler].read[].parse[get[uuid]].exclude[<[attached_player].uuid>]>
    - foreach <[uuids]> as:u:
        - yaml set id:networkteleporthere_requests <[u]>:->:<[attached_player].uuid>
    - define HoverA "<proc[Colorize].context[Accept Teleport Request from:|Green]><&nl><[attached_displayname]>"
    - define DisplayA <&a>[<&2><&l><&chr[2714]><&r><&a>]
    - define CommandA "tpaccept <[attached_name]>"
    - define Accept <proc[MsgCmd].context[<[hoverA]>|<[displayA]>|<[commandA]>]>

    - define HoverB "<proc[Colorize].context[Decline Teleport Request|Red]>"
    - define DisplayB <&c>[<&4><&chr[2716]><&c>]
    - define CommandB "tpdecline <[attached_name]>"
    - define Decline <proc[MsgCmd].context[<[hoverB]>|<[displayB]>|<[commandB]>]>

    - define HoverC "<proc[Colorize].context[Cancel Teleport Request|Red]>"
    - define DisplayC <&c>[<&4><&chr[2716]><&c>]
    - define CommandC "tpcancel everyone"
    - define Cancel <proc[MsgCmd].context[<[hoverC]>|<[displayC]>|<[commandC]>]>

    - foreach <bungee.list_servers.exclude[relay]> as:s:
        - bungee <[s]>:
            - if <[attached_player].is_online>:
                - narrate "<&b>| <[Cancel]> <&b>| <proc[Colorize].context[Teleport request sent to everyone.|green]>" to:<[attached_player]>
            - narrate "<&b>| <[Accept]> <&b>| <[Decline]> <&b>| <[attached_displayname]> <proc[Colorize].context[is requesting you to teleport to them|green]>" targets:<server.online_players.exclude[<[attached_player]>]>
    - wait 3m
    - foreach <[uuids]> as:u:
        - yaml set id:networkteleporthere_requests <[u]>:<-:<[player_map_2].get[uuid]>

teleport_yaml_load:
    type: world
    events:
        on server start:
        - yaml create id:teleport_requests
        - yaml create id:teleporthere_requests
        - yaml create id:teleport_cooldowns
        - yaml create id:teleporthere_cooldowns
