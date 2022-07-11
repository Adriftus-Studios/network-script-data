custom_object_fixer:
  type: task
  debug: false
  definitions: object
  script:
    - define object <context.entity> if:<[object].exists.not>
    - if <[object].has_flag[barriers]>:
      - flag <[object].has_flag[barriers]> on_right_click:<context.entity.flag[right_click_script]>

custom_object_place:
  type: task
  debug: false
  definitions: type|location
  script:
    - determine passively cancelled
    - ratelimit <player> 5t
    - if !<context.location.exists> && !<[location].exists>:
      - stop
    - define type <context.item.flag[custom_object]> if:<[type].exists.not>
    - define location <context.location.center.above[0.51].with_yaw[<player.location.yaw.round_to_precision[90]>]> if:<[location].exists.not>
    # Solid ground check
    - if !<[location].below.material.is_solid> || <[location].below.material.name> == barrier:
      - narrate "<&c>Must be placed on solid ground."
      - stop
    # Check for script
    - if !<script[custom_object_<[type]>].exists>:
      - narrate "<&c>This item seems to be broken? Please report this and turn the item over to moderation."
      - stop

    - define script <script[custom_object_<[type]>]>
    - define barriers <[script].parsed_key[barrier_locations]>

      # Check barrier locations for blocks
    - if <[barriers].filter[material.name.contains_text[air].not].size> >= 1:
      - narrate "<&c>Not enough room."
      - stop

    # Custom Object Checks
    - inject <[script].data_key[place_checks_task]>

      # Continue with defines
    - define interaction <[script].parsed_key[interaction]>
    - define entity_type <[script].parsed_key[entity]>
    - define item <[script].parsed_key[item]>
    - define place <[script].parsed_key[on_place_task].if_null[null]>
    - define remove <[script].parsed_key[on_remove_task].if_null[null]>
    - spawn <[entity_type]> <[location]> save:object
    - define entity <entry[object].spawned_entity>
    - modifyblock <[barriers]> barrier
    - flag <[barriers]> on_right_click:<[interaction]>
    - flag <[barriers]> custom_object:<entry[object].spawned_entity>
    - flag <entry[object].spawned_entity> barriers:<[barriers]>
    - flag <entry[object].spawned_entity> item:<[item]>
    - take iteminhand quantity:1
    # Custom Object Checks
    - inject <[script].data_key[after_place_task]>

custom_object_remove:
  type: task
  debug: false
  definitions: object
  script:
    - define object <context.item.flag[entity]> if:<[object].exists.not>
    - flag <[object].flag[barriers]> on_right_click:!
    - flag <[object].flag[barriers]> custom_object:!
    - modifyblock <[object].flag[barriers]> air
    - give <[object].flag[item]>
    - remove <[object]>

custom_object_handler_cleanup:
  type: world
  debug: false
  events:
    on server start:
      - flag server custom_objects.active:!

custom_object_update:
  type: task
  debug: false
  definitions: object
  script:
    - wait 1t
    - announce to_console "Custom Object<&co> <context.entity> (<context.entity.script.name>) added to world"