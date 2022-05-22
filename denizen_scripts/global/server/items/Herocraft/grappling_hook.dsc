grappling_hook_basic:
  type: item
  material: tripwire_hook
  display name: <script.parsed_key[data.tier]> Grappling Hook
  data:
    tier: <&7>Basic
    range: 15
    cooldown: 20s
  lore:
    - "<&e>Tier: <script.parsed_key[data.tier]>"
    - "<&e>Range<&co> <&f><script.data_key[data.range]>"
    - "<&e>Cooldown<&co> <&f><script.data_key[data.cooldown]>"
  flags:
    right_click_script: grappling_hook_shoot
    uuid: <util.random_uuid>
  mechanisms:
    custom_model_data: 3

grappling_hook_better:
  type: item
  material: tripwire_hook
  display name: <script.parsed_key[data.tier]> Grappling Hook
  data:
    tier: <&a>Better
    range: 20
    cooldown: 15s
  lore:
    - "<&e>Tier: <script.parsed_key[data.tier]>"
    - "<&e>Range<&co> <&f><script.data_key[data.range]>"
    - "<&e>Cooldown<&co> <&f><script.data_key[data.cooldown]>"
  flags:
    right_click_script: grappling_hook_shoot
    uuid: <util.random_uuid>
  mechanisms:
    custom_model_data: 3

grappling_hook_advanced:
  type: item
  material: tripwire_hook
  display name: <script.parsed_key[data.tier]> Grappling Hook
  data:
    tier: <&e>Advanced
    range: 25
    cooldown: 10s
  lore:
    - "<&e>Tier: <script.parsed_key[data.tier]>"
    - "<&e>Range<&co> <&f><script.data_key[data.range]>"
    - "<&e>Cooldown<&co> <&f><script.data_key[data.cooldown]>"
  flags:
    right_click_script: grappling_hook_shoot
    uuid: <util.random_uuid>
  mechanisms:
    custom_model_data: 3

grappling_hook_master:
  type: item
  material: tripwire_hook
  display name: <script.parsed_key[data.tier]> Grappling Hook
  data:
    tier: <&6>Master
    range: 30
    cooldown: 10s
  lore:
    - "<&e>Tier: <script.parsed_key[data.tier]>"
    - "<&e>Range<&co> <&f><script.data_key[data.range]>"
    - "<&e>Cooldown<&co> <&f><script.data_key[data.cooldown]>"
  flags:
    right_click_script: grappling_hook_shoot
    uuid: <util.random_uuid>
  mechanisms:
    custom_model_data: 3

grappling_hook_divine:
  type: item
  material: tripwire_hook
  display name: <script.parsed_key[data.tier]> Grappling Hook
  data:
    tier: <&b>Divine
    range: 80
    cooldown: 5s
  lore:
    - "<&e>Tier: <script.parsed_key[data.tier]>"
    - "<&e>Range<&co> <&f><&f><script.data_key[data.range]>"
    - "<&e>Cooldown<&co> <&f><script.data_key[data.cooldown]>"
  flags:
    right_click_script: grappling_hook_shoot
    uuid: <util.random_uuid>
  mechanisms:
    custom_model_data: 3


grappling_hook_shoot:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - ratelimit <player> 1t
    - if <context.item.has_flag[last_used]>:
      - narrate "<&c>This item has not recharged"
      - narrate "<&e>Cooldown Remaining<&co> <&f><duration[<context.item.script.data_key[data.cooldown]>].sub[<context.item.flag[last_used].from_now>].formatted>"
      - stop
    - define range <context.item.script.data_key[data.range]>
    - define target <player.eye_location.precise_cursor_on[<[range]>].if_null[null]>
    - define start <player.eye_location.forward[0.5]>
    - if <[target]> == null || !<[target].with_pose[<player>].forward[0.05].material.is_solid>:
      - narrate "<&c>You have no target in range"
      - stop
    - spawn snowball[item=tripwire_hook[custom_model_data=3];gravity=false] <[start]> save:ent
    - if !<entry[ent].spawned_entity.is_spawned>:
      - narrate "<&c>INTERNAL ERROR - REPORT Grappling0001"
      - stop
    - adjust <entry[ent].spawned_entity> velocity:<[target].sub[<[start]>].normalize>
    - inventory flag slot:<player.held_item_slot> last_used:<util.time_now> expire:<context.item.script.data_key[data.cooldown]>
    - flag <entry[ent].spawned_entity> on_hit_block:grappling_hook_pull
    - flag <entry[ent].spawned_entity> user:<player>
    - flag <entry[ent].spawned_entity> target:<[target]>
    - wait 1t
    - define targets <player.location.find_players_within[100]>
    - while <entry[ent].spawned_entity.is_spawned> && <player.is_online>:
      - adjust <entry[ent].spawned_entity> velocity:<[target].sub[<[start]>].normalize>
      - playeffect at:<player.eye_location.below[0.45].right[0.3].points_between[<entry[ent].spawned_entity.location>].distance[0.33]> quantity:2  offset:0 special_data:1|#FFFFFF effect:redstone targets:<[targets]>
      - wait 4t

grappling_hook_pull:
  type: task
  debug: false
  script:
    - adjust <queue> linked_player:<context.projectile.flag[user]>
    - define target <context.projectile.flag[target]>
    - define targets <context.location.find_players_within[100]>
    - define vector <[target].sub[<player.eye_location>].normalize>
    - adjust <player> gravity:false
    - while <[target].sub[<player.eye_location>].normalize.distance[<[vector]>]> < 1 && <player.is_online>:
      - playeffect at:<player.eye_location.below[0.45].right[0.3].points_between[<[target]>].distance[0.33]> quantity:2 offset:0 special_data:1|#FFFFFF effect:redstone targets:<[targets]>
      - adjust <player> velocity:<[target].sub[<player.location>].normalize>
      - wait 4t
      - if <[loop_index]> > 35:
        - while stop
    - adjust <player> fall_distance:0
    - if <player.location.pitch> < -15 && <[target].above.material.name.advanced_matches[*air]>:
      - adjust <player> velocity:<player.location.direction.vector.with_y[0.5]>
    - else:
      - adjust <player> velocity:0,0,0
    - adjust <player> gravity:true