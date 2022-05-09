portal_config:
  type: data
  whitelisted_blocks:
    - grass
    - air
    - water
    - cave_air
    - azure_bluet
    - sunflower
    - light
  messages:
    not_enough_arguments: <&c>Not Enough Arguments
    bad_arguments: <&c>Bad Arguments
    saved_location: <&a>You have saved this location as <&b><context.args.get[2]>
    no_room: <&c>There is not enough room for a portal.
    unsafe_destination: <&c>Unsafe Destination
    removed_location: <&c>Saved location removed
    no_saved_with_name: <&c>Unknown save location
    bad_duration: <&c>Bad Duration Specified
  types:
    dtd:
      particle: squid_ink
      particle_quantity: 30
      use_velocity: true
      velocity: 0,0.1,0
      use_showfake: false
      showfake_block: end_gateway
      offset: 0.7
      origin_requirements: true
      destination_requirements: true
    lavagate:
      particle: flame
      particle_quantity: 15
      use_velocity: false
      velocity: 0,0.1,0
      use_showfake: true
      showfake_block: lava
      offset: 0.2
      origin_requirements: true
      destination_requirements: <[destination].find_blocks[lava].within[10].size.is_more_than[1]>
      error_message: <&c>No lava near your destination to create portal.
    watergate:
      particle: water_drop
      particle_quantity: 15
      use_velocity: false
      use_showfake: true
      showfake_block: water
      offset: 0.2
      origin_requirements: <[target].find_blocks[water].within[10].size.is_more_than[1]>
      destination_requirements: true
      error_message: <&c>No water near you to create portal.

dtd_command:
  type: command
  debug: false
  name: dtd
  usage: /dtd
  permission: adriftus.staff
  description: dtd portals
  permission message: Restricted.
  allowed help:
  - determine <player.has_permission[adriftus.staff]>
  tab completions:
    1: save|remove|forward_portal|backward_portal
    2: <list[coordinates].include[<yaml[global.player.<player.uuid>].read[dtd.locations].keys||<list[]>>].include[<server.online_players.parse[name]>]>
  script:
    ## Arg1 = Portal
    - if <context.args.get[1].advanced_matches[*_portal]>:
      - if <context.args.last.starts_with[duration<&co>]>:
        - if <duration[<context.args.last.after[<&co>]>].exists>:
          - define duration <util.time_now.add[<context.args.last.after[<&co>]>]>
        - else:
          - narrate <script[portal_config].parsed_key[messages.bad_duration]>
          - stop
      - else:
        - define duration <util.time_now.add[10s]>
      - if <context.args.size> <= 1:
        - narrate <script[portal_config].parsed_key[messages.not_enough_arguments]>
        - stop
      ## Arg2 = Coordinates
      - if <context.args.get[2]> == coordinates:
        - if <context.args.size> <= 4:
          - narrate <script[portal_config].parsed_key[messages.not_enough_arguments]>
          - stop
        - foreach <context.args.get[3].to[5]>:
          - if !<[value].is_decimal>:
            - narrate <script[portal_config].parsed_key[messages.bad_arguments]>
            - stop
        - run open_portal def:dtd|<context.args.get[1].before[_]>|<location[<context.args.get[3].to[5].separated_by[,]>,<player.location.world.name>]>|<[duration]>
        - stop
      ## Arg2 = Saved Location
      - if <yaml[global.player.<player.uuid>].contains[dtd.locations.<context.args.get[2]>]>:
        - run open_portal def:dtd|<context.args.get[1].before[_]>|<yaml[global.player.<player.uuid>].read[dtd.locations.<context.args.get[2]>.location]>|<[duration]>|<yaml[global.player.<player.uuid>].read[dtd.locations.<context.args.get[2]>.server]>
      ## Arg2 = Player
      - if <server.match_player[<context.args.get[2]>].exists>:
        - run open_portal def:dtd|<context.args.get[1].before[_]>|<server.match_player[<context.args.get[2]>].location>|<[duration]>
    ## Arg1 = save
    - else if <context.args.get[1]> == save:
      - if <context.args.size> <= 1:
        - narrate <script[portal_config].parsed_key[messages.not_enough_arguments]>
        - stop
      - if !<context.args.get[2].to_lowercase.matches_character_set[abcdefghijklmnopqrstuvwxyz_]>:
        - narrate <script[portal_config].parsed_key[messages.bad_arguments]>
        - stop
      - define map <map[dtd.locations.<context.args.get[2]>.location=<player.location>;dtd.locations.<context.args.get[2]>.server=<bungee.server>]>
      - run global_player_data_modify_multiple def:<player.uuid>|<[map]>
      - narrate <script[portal_config].parsed_key[messages.saved_location]>
    ## Arg1 = remove
    - else if <context.args.get[1]> == remove:
      - if <context.args.size> <= 1:
        - narrate <script[portal_config].parsed_key[messages.not_enough_arguments]>
        - stop
      - if !<context.args.get[2].to_lowercase.matches_character_set[abcdefghijklmnopqrstuvwxyz_]>:
        - narrate <script[portal_config].parsed_key[messages.bad_arguments]>
        - stop
      - if !<yaml[global.player.<player.uuid>].contains[dtd.locations.<context.args.get[2]>]>:
        - narrate <script[portal_config].parsed_key[messages.no_saved_with_name]>
        - stop
      - run global_player_data_modify def:<player.uuid>|dtd.locations.<context.args.get[2]>|!
      - narrate <script[portal_config].parsed_key[messages.removed_location]>
    - else:
        - narrate <script[portal_config].parsed_key[messages.bad_arguments]>

open_portal:
  type: task
  debug: false
  definitions: type|direction|destination|duration|server
  script:
    - define particle <script[portal_config].parsed_key[types.<[type]>.particle]>
    - define particle_quantity <script[portal_config].parsed_key[types.<[type]>.particle_quantity]>
    - define use_velocity <script[portal_config].parsed_key[types.<[type]>.use_velocity]>
    - define use_showfake <script[portal_config].parsed_key[types.<[type]>.use_showfake]>
    - define offset <script[portal_config].parsed_key[types.<[type]>.offset]>
    - if <[direction]> == forward:
      - define target <player.location.above[0.2].forward_flat[3]>
    - else:
      - define target <player.location.above[0.2].backward_flat[2]>
    - define cube <player.location.above[0.2].to_cuboid[<[target].above[1.2]>]>
    - if <[cube].blocks.filter[material.is_solid].size> >= 1:
      - narrate <script[portal_config].parsed_key[messages.no_room]>
      - stop
    - if <[type]> == dtd && <[server].exists>:
      - if !<bungee.connected>:
        - narrate "Unable to use this right now (awaiting bungee)"
        - stop
      - if <[server]> != <bungee.server>:
        - inject cross_server_portal
        - stop
    - if !<[destination].chunk.is_loaded>:
      - chunkload <[destination].chunk> duration:10s
    - if <[destination].material.is_solid>:
        - narrate <script[portal_config].parsed_key[messages.unsafe_destination]>
        - stop
    - if !<script[portal_config].parsed_key[types.<[type]>.origin_requirements].parsed>:
      - narrate <script[portal_config].parsed_key[types.<[type]>.error_message]>
      - stop
    - if !<script[portal_config].parsed_key[types.<[type]>.destination_requirements].parsed>:
      - narrate <script[portal_config].parsed_key[types.<[type]>.error_message]>
      - stop
    - define points <player.location.points_between[<[target].center.below[0.5]>].distance[0.2]>
    - if <[use_velocity]>:
      - define velocity <script[portal_config].parsed_key[types.<[type]>.velocity]>
      - foreach <[points]>:
        - define players1 <[target].find_players_within[96]>
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
    - else:
      - foreach <[points]>:
        - define players1 <[target].find_players_within[96]>
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
    - if <[use_velocity]>:
      - repeat 8:
        - playeffect at:<[target].center.above[<[value].div[5]>]> effect:squid_ink quantity:<[particle_quantity]> velocity:<[velocity]> offset:1 targets:<[target].find_players_within[96]>
        - wait 1t
    - define old_block1:<[target].material>
    - define old_block2:<[target].above.material>
    - if <[use_showfake]>:
      - define showfake <script[portal_config].parsed_key[types.<[type]>.showfake_block]>
      - showfake <[target]>|<[target].above> <[showfake]> duration:10s
    - modifyblock <[target]> end_gateway
    - modifyblock <[target].above> end_gateway
    - adjust <[target]> age:-999999
    - adjust <[target].above> age:-999999
    - adjust <[target]> exit_location:<[destination].with_world[<player.location.world>]>
    - adjust <[target].above> exit_location:<[destination].with_world[<player.location.world>]>
    - adjust <[target]> is_exact_teleport:true
    - adjust <[target].above> is_exact_teleport:true
    - flag <[target]> destination.location:<[destination]>
    - flag <[target].above> destination.location:<[destination]>
    - define offset <[offset].mul[2]>
    - define quantity2 <[particle_quantity].div[2]>
    - runlater portal_close delay:<[duration].from_now> def:<[target]>|<[old_block1]>|<[old_block2]>
    - if <[use_velocity]>:
      - while <util.time_now.is_after[<[duration]>].not>:
        - define players1 <[target].find_players_within[96]>
        - define players2 <[destination].find_players_within[96]>
        - repeat 10:
          - if !<[players1].is_empty>:
            - playeffect at:<[target].center> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
            - playeffect at:<[target].above.center> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
          - if !<[players2].is_empty>:
            - playeffect at:<[destination].center> effect:<[particle]> quantity:<[quantity2]> velocity:<[velocity]> offset:<[offset]> targets:<[players2]>
            - playeffect at:<[destination].above.center> effect:<[particle]> quantity:<[quantity2]> velocity:<[velocity]> offset:<[offset]> targets:<[players2]>
          - wait 2t
          - define players1 <[players1].filter[is_online]>
          - define players2 <[players2].filter[is_online]>
    - else:
      - while <util.time_now.is_after[<[duration]>].not>:
        - define players1 <[target].find_players_within[96]>
        - define players2 <[destination].find_players_within[96]>
        - repeat 10:
          - if !<[players1].is_empty>:
            - playeffect at:<[target].center> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
            - playeffect at:<[target].above.center> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
          - if !<[players2].is_empty>:
            - playeffect at:<[destination].center> effect:<[particle]> quantity:<[quantity2]> offset:<[offset]> targets:<[players2]>
            - playeffect at:<[destination].above.center> effect:<[particle]> quantity:<[quantity2]> offset:<[offset]> targets:<[players2]>
          - wait 2t
          - define players1 <[players1].filter[is_online]>
          - define players2 <[players2].filter[is_online]>

cross_server_portal:
  type: task
  debug: false
  definitions: server|destination|duration
  script:
    - define points <player.location.points_between[<[target].center.below[0.5]>].distance[0.2]>
    - if <[use_velocity]>:
      - define velocity <script[portal_config].parsed_key[types.<[type]>.velocity]>
      - foreach <[points]>:
        - define players1 <[target].find_players_within[96]>
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
    - else:
      - foreach <[points]>:
        - define players1 <[target].find_players_within[96]>
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
        - playeffect at:<[value]> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
        - wait 1t
    - if <[use_velocity]>:
      - repeat 8:
        - playeffect at:<[target].center.above[<[value].div[5]>]> effect:squid_ink quantity:<[particle_quantity]> velocity:<[velocity]> offset:1 targets:<[target].find_players_within[96]>
        - wait 1t
    - define old_block1:<[target].material>
    - define old_block2:<[target].above.material>
    - if <[use_showfake]>:
      - define showfake <script[portal_config].parsed_key[types.<[type]>.showfake_block]>
      - showfake <[target]>|<[target].above> <[showfake]> duration:10s
    - modifyblock <[target]> end_gateway
    - modifyblock <[target].above> end_gateway
    - adjust <[target]> age:-999999
    - adjust <[target].above> age:-999999
    - adjust <[target]> exit_location:<[destination].with_world[<player.location.world>]>
    - adjust <[target].above> exit_location:<[destination].with_world[<player.location.world>]>
    - adjust <[target]> is_exact_teleport:true
    - adjust <[target].above> is_exact_teleport:true
    - flag <[target]> destination.location:<[destination]>
    - flag <[target].above> destination.location:<[destination]>
    - flag <[target]> destination.server:<[server]>
    - flag <[target].above> destination.server:<[server]>
    - define offset <[offset].mul[2]>
    - define quantity2 <[particle_quantity].div[2]>
    - bungeerun <[server]> cross_server_portal_destination def:<[destination]>|<[duration]>
    - runlater portal_close delay:<[duration].from_now> def:<[target]>|<[old_block1]>|<[old_block2]>
    - if <[use_velocity]>:
      - while <util.time_now.is_after[<[duration]>].not>:
        - define players1 <[target].find_players_within[96]>
        - if !<[players1].is_empty>:
          - repeat 10:
            - playeffect at:<[target].center> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
            - playeffect at:<[target].above.center> effect:<[particle]> quantity:<[particle_quantity]> velocity:<[velocity]> offset:<[offset]> targets:<[players1]>
            - wait 2t
            - define players1 <[players1].filter[is_online]>
        - else:
          - wait 1s
    - else:
      - while <util.time_now.is_after[<[duration]>].not>:
        - define players1 <[target].find_players_within[96]>
        - if !<[players1].is_empty>:
          - repeat 10:
            - playeffect at:<[target].center> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
            - playeffect at:<[target].above.center> effect:<[particle]> quantity:<[particle_quantity]> offset:<[offset]> targets:<[players1]>
            - wait 2t
            - define players1 <[players1].filter[is_online]>
        - else:
          - wait 1s

portal_close:
  type: task
  debug: false
  definitions: target|old_block1|old_block2
  script:
    - if !<[target].chunk.is_loaded>:
      - chunkload <[target].chunk> duration:10s
      - wait 1t
    - modifyblock <[target]> <[old_block1]>
    - modifyblock <[target].above> <[old_block2]>
    - flag <[target]> destination.location:!
    - flag <[target].above> destination.location:!

cross_server_portal_destination:
  type: task
  debug: false
  definitions: location|duration
  script:
    - if !<[location].chunk.is_loaded>:
      - chunkload <[location]> duration:11s
      - wait 1t
    - while <util.time_now.is_after[<[duration]>].not>:
        - define players1 <[location].find_players_within[96]>
        - if !<[players1].is_empty>:
          - repeat 10:
            - playeffect at:<[location].center> effect:squid_ink quantity:15 velocity:0,0.1,0 offset:0.7 targets:<[players1]>
            - playeffect at:<[location].above.center> effect:squid_ink quantity:15 velocity:0,0.1,0 offset:0.7 targets:<[players1]>
            - wait 2t
            - define players1 <[players1].filter[is_online]>
        - else:
          - wait 1s
