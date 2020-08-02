combat_handler:
  type: world
  events:
    on player damaged by player bukkit_priority:HIGHEST:
      - determine <context.final_damage.mul[<context.entity.health>].div[20]>

combat_log_events:
  type: world
  debug: false
  events:
    on player damages player bukkit_priority:HIGHEST:
      - flag <context.damager> combat duration:45s
      - flag <context.entity> combat duration:45s
    on player quits:
      - if <player.has_flag[combat]>:
        - hurt <player.health> <player>
    on delta time secondly every:1:
      - foreach <server.list_online_players.filter[has_flag[combat]]||<list>> as:player:
        - adjust <queue> linked_player:<[player]>
        - if <player.flag[combat].expiration.in_seconds||0> < 1:
          - wait 1s
          - narrate "<&b>You are no longer in combat."

# can use earth, fire, ender, air, or water
calculate_damage:
  type: procedure
  definitions: damager|damaged|damage|type
  script:
    - define armor:<[damaged].armor_bonus>
    - define damage_modifier:1
    - define defence_modifier:1
    - if <[damager].type> == player:
      - define damage_modifier:<yaml[player.<[damager].uuid>].read[stats.damage_modifier.<[type]>]||1>
    - else if <[damager].type> == entity:
      - if <[damager].script||null> != null:
        - define damage_modifier:<[damager].script.yaml_key[custom.damage_modifier.<[type]>]||1>
    - if <[damaged].type> == player:
      - define defence_modifier:<yaml[player.<[damaged].uuid>].read[stats.defence_modifier.<[type]>]||1>
    - else if <[damaged].type> == entity:
      - if <[damaged].script||null> != null:
        - define defence_modifier:<[damaged].script.yaml_key[custom.defence_modifier.<[type]>]||1>
    - define damage:<[damage].mul[<[damage_modifier]>].div[<[defence_modifier]>]>
    - define final_damage:<[damage].mul[<el@1.sub[<el@20.mul[<[armor].div[5]>].div[25]>]>]>
    - if <[final_damage]> < 0.5:
      - define final_damage:0.5
    - determine <[final_damage]>
  
# initial in seconds, reduction (percent subtracted) in integers
calculate_burn:
  type: procedure
  definitions: initial|reduction
  script:
    - determine <[initial].*[<element[100].-[<[reduction]>]>]>

logout_quit_command:
  type: command
  name: logout
  description: Safely logout of the server.
  usage: /logout
  aliases:
  - quit
  tab complete:
  script:
  - if <player.has_flag[combat]>:
    - narrate "<&c>You must wait another <&4><player.flag[combat].expiration.as_duration.formatted> <&c>seconds before logging out safely."
  - else:
    - define move_check:<player.location.simple>
    - flag <player> logging_out duration:10s
    - repeat 10:
      - if <player.location.simple> == <[move_check]>:
        - playeffect dragon_breath <player.location> quantity:50
        - narrate "<&a>Safely logging out in <&2><player.flag[logging_out].expiration.as_duration.formatted>"
        - wait 1s
      - else:
        - narrate "<&c>Logout cancelled. Please stand still."
        - stop
    - flag player combat:!
    - kick <player> "reason:<&a>----------------------------------------------------<&nl><&nl><&a>You have been safely removed from the server.<&nl><&nl><&a>----------------------------------------------------"
    