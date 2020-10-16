grappling_hook:
  type: item
  debug: false
  material: tripwire_hook
  display name: <&a><&l><&n>Grappling Hook
  lore:
  - <&b><&l>Use this to grapple a block
  - <&b><&l>and pull yourself to it.

grappling_hook_events:
  type: world
  debug: false
  worlds: mainland|mainland_nether
  events:
    on player right clicks block with:grappling_hook:
      - determine passively cancelled
      - if !<script[grappling_hook_events].data_key[worlds].contains[<player.world.name>]>:
        - narrate "<&c>You cannot use that here."
        - stop
      - if <player.has_flag[grappling]>:
        - narrate "<&c>You can only fire one grappling hook at a time."
        - stop
      - shoot arrow shooter:<player> speed:3 script:grappling_hook_pull save:hook
      - flag player grappling:true duration:10s
      - wait 1t
      - flag <entry[hook].shot_entity> no_trail:true duration:30s
      - repeat 999:
        - if !<server.entity_is_spawned[<entry[hook].shot_entity>]> || !<player.has_flag[grappling]>:
          - stop
        - playeffect redstone at:<player.location.points_between[<entry[hook].shot_entity.location>].distance[0.5]> quantity:5 special_data:1|gray offset:0.1
        - wait 2t
    on player shoots block flagged:grappling bukkit_priority:LOWEST:
      - flag player grappling:<context.location.add[<context.hit_face>].center>

grappling_hook_pull:
 type: task
 debug: false
 script:
   - if !<[hit_entities].is_empty||true>:
     - wait 1t
     - if <player.can_see[<[hit_entities].first>]||false>:
       - push <[hit_entities]> d:<player.location> script:grappling_hook_sanity def:false
     - else:
       - if <server.entity_is_spawned[<[hit_entities].first>]>:
         - narrate "<&c>Unable to grapple this mob from here."
       - flag player grappling:!
   - else if <[location].find.blocks.within[2].filter[material.name.is[!=].to[air]].is_empty> || !<player.can_see[<[last_entity]>]||true>:
     - narrate "<&c>Unable to grapple to this location from here."
     - flag player grappling:!
   - else if <player.flag[grappling].as_location.type||null> == location:
     - wait 5t
     - push <player> d:<player.flag[grappling]> script:grappling_hook_sanity def:<player.flag[grappling].as_location>
   - else:
     - narrate "<&c>Unable to grapple to this location from here."
     - flag player grappling:!

grappling_hook_sanity:
  type: task
  debug: false
  definitions: loc
  script:
    - flag player grappling:!
    - if <[loc].not>:
      - stop
    - teleport <[loc].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>

arrow_no_pickup:
  type: world
  debug: false
  events:
    on player picks up arrow:
      - if <context.entity.has_flag[no_trail]>:
        - determine passively cancelled
        - wait 1t
        - remove <context.entity>
