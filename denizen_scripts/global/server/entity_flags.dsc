## List of generic flags for entities to use
# no_damage - no damage taken
# no_fall_damage - negates all damage from falling

## You may append _once to any flag above for it to only negate the next time it applies

# no_fly_kick - disable getting "kicked for flying"

entity_flags:
  type: world
  debug: false
  events:
    on entity_flagged:no_fall_damage damaged by FALL:
      - determine cancelled
    on entity_flagged:no_fall_damage_once damaged by FALL:
      - flag <context.entity> no_fall_damage_once:!
      - determine cancelled
    on entity_flagged:no_damage damaged:
      - determine cancelled
    on entity_flagged:no_damage_once damaged:
      - flag <context.entity> invulnerable_once:!
      - determine cancelled
    on entity_flagged:no_heal heals:
      - determine cancelled
    on entity_flagged:no_heal_once heals:
      - flag <context.entity> no_heal_once:!
      - determine cancelled
    on entity_flagged:on_next_damage damaged:
      - foreach <context.entity.flag[on_next_damage]>:
        - if <script[<[value]>].exists>:
          - inject <[value]>
      - flag <context.entity> on_next_damage:!
    on entity_flagged:on_next_hit damages entity:
      - foreach <context.damager.flag[on_next_hit]>:
        - if <script[<[value]>].exists>:
          - inject <[value]>
      - flag <context.damager> on_next_hit:!
    on entity targets entity_flagged:on_target:
        - if <context.location.flag[on_target].object_type> == List:
          - foreach <context.location.flag[on_target]>:
            - inject <[value]>
        - else:
          - inject <context.location.flag[on_target]>
    on player kicked for flying flagged:no_fly_kick:
      - determine passively FLY_COOLDOWN:<player.flag_expiration[no_fly_kick].duration_since[<util.time_now>]>
      - determine cancelled
    on player right clicks entity_flagged:right_click_script:
      - if !<player.is_sneaking>:
        - determine passively cancelled
        - inject <context.entity.flag[right_click_script]>
    on player right clicks entity_flagged:shift_right_click_script:
      - if <player.is_sneaking>:
        - determine passively cancelled
        - inject <context.entity.flag[shift_right_click_script]>
    on material falls:
      - if <context.entity.has_flag[showfake]>:
        - determine passively cancelled
        - showfake <context.entity.fallingblock_material> <context.location> players:<context.location.find_players_within[40]> duration:1m
      - else if <context.entity.has_flag[on_fall]>:
        - inject <context.entity.flag[on_fall]>
    on entity_flagged:on_hit_entity hits entity bukkit_priority:LOWEST:
      - inject <context.projectile.flag[on_hit_entity]>
    on entity_flagged:on_hit_block hits block bukkit_priority:LOWEST:
      - inject <context.projectile.flag[on_hit_block]>
    on player damaged by suffocation flagged:no_suffocate bukkit_priority:LOWEST:
      - determine cancelled
    # Player Flag and Server Flag, with preference on Player
    # Player Flag "join_location" - will teleport the player on join, clear flag afterwards
    # Server Flag "join_location" - will teleport the player on join, if no player flag is present
    after player joins bukkit_priority:LOWEST priority:-100 server_flagged:join_location:
        - if <server.has_flag[join_location.<player.uuid>]>:
          - teleport <player> <server.flag[join_location.<player.uuid>].parsed>
          - flag server join_location.<player.uuid>:!
        - else if <server.has_flag[join_location.location]>:
          - teleport <server.flag[join_location.location].parsed>
        - else:
          - flag server join_location:!
    on entity_flagged:on_entity_added added to world:
      - inject <context.entity.flag[on_entity_added]>
    on entity_flagged:on_dismount exits vehicle:
      - if <context.entity.flag[on_dismount].object_type> == List:
        - foreach <context.entity.flag[on_dismount]>:
          - inject <[value]>
      - else:
        - inject <context.entity.flag[on_dismount]>
    on entity exits entity_flagged:on_dismount:
      - if <context.vehicle.flag[on_dismount].object_type> == List:
        - foreach <context.vehicle.flag[on_dismount]>:
          - inject <[value]>
      - else:
        - inject <context.vehicle.flag[on_dismount]>
    on entity_flagged:on_mount exits vehicle:
      - inject <context.entity.flag[on_mount]>
    on player right clicks fake entity:
      - stop if:<context.entity.has_flag[right_click_script].not>
      - inject <context.entity.flag[right_click_script]>
    on player right clicks block flagged:player_right_clicks:
      - inject <player.flag[player_right_clicks]>
    on player right clicks block flagged:shift_player_right_clicks:
      - if <player.is_sneaking>:
        - if <player.flag[shift_player_right_clicks].object_type> == List:
          - foreach <player.flag[shift_player_right_clicks]>:
            - inject <[value]>
        - else:
          - inject <player.flag[shift_player_right_clicks]>
    on entity_flagged:on_damaged damaged:
      - if <context.entity.flag[on_damaged].object_type> == List:
        - foreach <context.entity.flag[on_damaged]>:
          - inject <[value]>
      - else:
        - inject <context.entity.flag[on_damaged]>
    on entity_flagged:on_death dies:
      - if <context.entity.flag[on_death].object_type> == List:
        - foreach <context.entity.flag[on_death]>:
          - inject <[value]>
      - else:
        - inject <context.entity.flag[on_death]>
    on entity_flagged:on_breed breeds:
      - if <context.entity.flag[on_breed].object_type> == List:
        - foreach <context.entity.flag[on_breed]>:
          - inject <[value]>
      - else:
        - inject <context.entity.flag[on_breed]>
    on entity_flagged:on_break breaks:
      - if <context.hanging.flag[on_break].object_type> == List:
        - foreach <context.hanging.flag[on_break]>:
          - inject <[value]>
      - else:
        - inject <context.hanging.flag[on_break]>
    on entity_flagged:on_item_pickup picks up item:
      - if <context.entity.flag[on_item_pickup].object_type> == List:
        - foreach <context.entity.flag[on_item_pickup]>:
          - inject <[value]>
      - else:
        - inject <context.hangientityng.flag[on_item_pickup]>