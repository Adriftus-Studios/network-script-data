grappling_hook:
  type: item
  debug: true
  material: tripwire_hook
  display name: <&b>Grappling Hook
  lore:
  - <&E>Use this to grapple a block
  - <&E>and pull yourself to it.
  - <&e>Uses remaining: 75
  flags:
    durability: 75
  mechanisms:
    custom_model_data: 3

grappling_hook_events:
  type: world
  debug: false
  worlds: mainland|mainland_nether
  events:
    on player right clicks block with:grappling_hook:
      - determine passively cancelled
      - if !<context.item.has_flag[durability]>:
        - inventory flag slot:<player.held_item_slot> durability:75
      - if !<script[grappling_hook_events].data_key[worlds].contains[<player.world.name>]>:
        - narrate "<&c>You cannot use that here."
        - stop
      - if <player.has_flag[grappling]>:
        - narrate "<&c>You can only fire one grappling hook at a time."
        - stop
      - if <context.item.has_flag[grappleInUse]>:
        - narrate "<&4>ERROR, PLEASE REPORT WITH <&B>/GITHUB<&4> AND SAY GHOOK30"
        - stop
      - inventory flag slot:<player.held_item_slot> grappleInUse
      - shoot arrow shooter:<player> speed:3 script:grappling_hook_pull save:hook
      - run grappling_hook_remover def.hook:<entry[hook].shot_entity>
      - playsound sound:ENTITY_ARROW_SHOOT <player.location>
      - flag player grappling:true duration:5s
      - wait 1t
      - flag <entry[hook].shot_entity> no_trail:true duration:30s
      - while <server.entity_is_spawned[<entry[hook].shot_entity>]> || <player.has_flag[grappling]>:
        - if <entry[hook].shot_entity.is_spawned>:
          - playeffect redstone at:<player.eye_location.above[0.4].points_between[<entry[hook].shot_entity.location>].distance[0.5]> quantity:5 special_data:0.5|white offset:0.01
          - wait 2t
    on player shoots block flagged:grappling bukkit_priority:LOWEST:
      - flag player grappling:<context.location.add[<context.hit_face>].center>

grappling_hook_remover:
  type: task
  debug: false
  definitions: hook
  script:
  - wait 40t
  - if <[hook].is_spawned||false>:
    - remove <[hook]>

grappling_hook_pull:
 type: task
 debug: false
 definitions: durability
 script:
  - if !<[hit_entities].is_empty>:
    - wait 1t
    - define group <yaml[claims].read[<[hit_entities].first.location.chunk.world>.<[hit_entities].first.location.chunk.x>.<[hit_entities].first.location.chunk.z>]||null>
    - if <[group]> != null && !<yaml[claims].read[groups.<[group]>.members.<player.uuid>.kill-animals]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.kill-animals]>:
        - narrate "<&c>You do not have permission to interact with animals here."
        - stop
  - else if <[location].find.blocks.within[3].filter[material.name.is[!=].to[air]].is_empty> || !<player.can_see[<[last_entity]>]||true>:
    - narrate "<&c>Unable to grapple to this location from here."
    - flag <player> grappling:!
    - define failed true
    - inject grappling_hook_durability_task
    - if <[hook].is_spawned||null> != null:
      - remove <[hook]>
  - else if <player.has_flag[grappling]>:
    - push <player> d:<player.flag[grappling]>
    - playsound sound:ENTITY_PHANTOM_flap pitch:1 targets:<player>
    - wait 1t
    - inject grappling_hook_durability_task
    - flag <player> grappling:!
  - else:
    - narrate "<&c>Unable to grapple to this location from here."
    - flag player grappling:!
    - define failed true
    - inject grappling_hook_durability_task

##Removed because it didnt work, and didnt seem neccesary anymore.
#grappling_hook_sanity:
#  type: task
#  debug: false
#  definitions: loc
#  script:
#    - flag player grappling:!
#    - if <[loc]||null> == null:
#      - stop
#    - wait 1t
#    - teleport <player> <[loc].with_pitch[<player.location.pitch>].with_yaw[<player.location.yaw>]>
#    - narrate teleport targets:<player>

hook_no_pickup:
  type: world
  debug: false
  events:
    on player picks up launched arrow:
      - if <context.arrow.has_flag[no_trail]>:
        - determine passively cancelled
        - wait 1t
        - remove <context.arrow>

hook_no_damage:
  type: world
  debug: false
  events:
    on entity damaged by projectile:
      - if !<context.projectile.has_flag[no_trail]>:
        - stop
      - define player <context.projectile.shooter>
      - determine passively 0
      - wait 1t
      - flag <[player]> grappling:!
      - if <context.entity.location.distance[<[player].location>]||0> < 4:
        - narrate "<&c>This target is too close to be grappled with a hook." targets:<[player]>
        - define failed true
        - inject grappling_hook_durability_task
        - stop
      - if !<context.entity.can_see[<[player]>]>:
        - narrate "<&c>Unable to grapple this mob from here." targets:<[player]>
        - define failed true
        - inject grappling_hook_durability_task
        - stop
      - define group <yaml[claims].read[<context.entity.location.chunk.world>.<context.entity.location.chunk.x>.<context.entity.location.chunk.z>]||null>
      - if <[group]> != null && !<yaml[claims].read[groups.<[group]>.members.<[player].uuid>.kill-animals]||false> && !<yaml[claims].read[groups.<[group]>.members.everyone.kill-animals]>:
        - narrate "<&c>You do not have permission to interact with animals here." targets:<[player]>
        - define failed true
        - inject grappling_hook_durability_task
        - stop
      - else:
        - adjust <context.entity> velocity:<[player].location.backward.sub[<[player].location>].normalize.mul[<context.entity.location.distance[<[player].location>].div[5]>]>
        - inject grappling_hook_durability_task

hook_no_knockback:
  type: world
  debug: false
  events:
    on entity knocks back entity:
      - if !<context.damager.has_flag[grappling]>:
        - stop
      - else:
        - determine passively cancelled

grappling_hook_durability_exploit_prevention:
  type: world
  debug: false
  events:
    on player drops grappling_hook:
      - if !<player.has_flag[grappling]>:
        - stop
      - else:
        - determine cancelled

grappling_hook_durability_task:
  type: task
  debug: false
  script:
    - define player <player.if_null[<context.projectile.shooter>]>
    - define hook_slot <player.inventory.find_item[item_flagged:grappleInUse]>
    - wait 1t
    - define durability <[player].inventory.slot[<[hook_slot]>].flag[durability]||0>
    - wait 1t
    - if <[failed]||false>:
      - inventory flag slot:<[hook_slot]> grappleInUse:!
      - stop
    - else if <[durability]> > 1:
      - inventory flag slot:<[hook_slot]> durability:--
      - wait 1t
      - inventory flag slot:<[hook_slot]> grappleInUse:!
      - inventory adjust slot:<[hook_slot]> "lore:<&6>Use this to grapple a block|<&6>and pull yourself to it.|<&6>Uses remaining: <&e><[player].inventory.slot[<[hook_slot]>].flag[durability]>"
    - else:
      - inventory flag slot:<[hook_slot]> grappleInUse:!
      - take slot:<[hook_slot]>
      - playsound sound:ITEM_SHIELD_BREAK <player.location>
      - playeffect effect:ITEM_CRACK special_data:tripwire_hook <player.eye_location.below[1].forward[1]> offset:0.25 quantity:10
