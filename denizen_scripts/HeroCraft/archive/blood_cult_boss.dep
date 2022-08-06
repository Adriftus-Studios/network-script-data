blood_cult_boss_start:
  type: task
  debug: false
  script:
    - flag server blood_cult_boss.player:<player>
    - spawn armor_stand[visible=false;marker=true] <location[blood_cult_boss_center].above[1]> save:ent
    - flag server blood_cult_boss_data.center:<entry[ent].spawned_entity>
    - flag <player> dwisp.active.location:<location[blood_cult_boss_blood_altar]>
    - flag <player> "dwisp.data.name:<&4>Blood Wisp"
    - flag <player> dwisp.data.color1:#990000
    - flag <player> dwisp.data.color2:#FF0000
    - flag <player> dwisp.data.behaviour.heal:self
    - flag player dwisp.data.target:monster if:<player.has_flag[dwisp.data.target].not>
    - define targets <player.location.find_players_within[100]>
    - spawn dwisp_armor_stand[custom_name=<player.flag[dwisp.data.name]>] <location[blood_cult_boss_blood_altar]> save:wisp
    - title "title:<&4>Boss Engaged" subtitle:Survival targets:<[targets]>
    - flag <entry[wisp].spawned_entity> on_shot:blood_cult_boss_wisp_shot
    - flag player dwisp.active.entity:<entry[wisp].spawned_entity>
    - flag <entry[wisp].spawned_entity> on_entity_added:cancel
    - flag <entry[wisp].spawned_entity> owner:<player>
    - define points <proc[define_curve1].context[<location[blood_cult_boss_blood_altar]>|<server.flag[blood_cult_boss_data.center].location.above[3].backward[3]>|4|90|0.5]>
    - define targets <player.location.find_players_within[100]>
    - foreach <[points]> as:point:
      - teleport <player.flag[dwisp.active.entity]> <[point].below[0.5]>
      - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - flag player dwisp.active.location:<[point]>
      - wait 2t
    - flag player dwisp.active.follow_target:<server.flag[blood_cult_boss_data.center]>
    - flag player dwisp.active.task:far_idle
    - run dwisp_run_movement
    - run dwisp_run_behaviour
    - run blood_cult_boss_phase_1


blood_cult_boss_phase_1:
  type: task
  debug: false
  script:
    - flag server blood_cult_boss.phase:1
    - define targets <player.location.find_players_within[100]>
    - title "title:<&4>Phase 1" "subtitle:Blood Skeletons" targets:<[targets]>
    - flag <player> dwisp.data.behaviour.attack:off
    - flag <player> dwisp.data.behaviour.spawn:blood_cult_boss_mob_1
    - wait 1m
    - run blood_cult_boss_phase_2
    - wait 2m
    - flag server blood_cult_boss.phase:3

blood_cult_boss_mob_1:
  type: entity
  debug: false
  entity_type: skeleton
  mechanisms:
    health_data: 100/100
    custom_name: <&c>Blood Skeleton
    custom_name_visible: true
  flags:
    on_targetting: blood_cult_boss_mob_targetting
    on_shoots_bow: blood_cult_boss_bow_shoot

blood_cult_boss_mob_targetting:
  type: task
  debug: false
  script:
    - if <context.target.entity_type> != PLAYER:
      - determine cancelled
    - if <context.target> == <server.flag[blood_cult_boss.player]>:
      - determine cancelled

blood_cult_boss_bow_shoot:
  type: task
  debug: false
  script:
    - wait 1t
    - flag <context.projectile> on_hit_entity:blood_cult_boss_bow_damage
    - while <context.projectile.is_spawned>:
      - playeffect at:<context.projectile.location> effect:redstone special_data:5|#990000 offset:0 quantity:2 targets:<server.online_players>
      - wait 1t
      - if <[loop_index]> > 80:
        - while stop

blood_cult_boss_bow_damage:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - if <context.hit_entity.has_Flag[blood_drain]> || <context.hit_entity> == <server.flag[blood_cult_boss.player]>:
      - stop
    - flag <context.hit_entity> blood_drain
    - repeat 5:
      - if !<context.hit_entity.is_spawned>:
        - repeat stop
      - hurt <context.hit_entity> 2
      - wait 1s
    - flag <context.hit_entity> blood_drain:!

blood_cult_boss_phase_2:
  type: task
  debug: false
  script:
    - flag <player> dwisp.data.behaviour.spawn:off
    - flag <player> dwisp.data.behaviour.attack:PLAYER
    - flag <player> dwisp.data.damage:2
    - flag server blood_cult_boss.phase:2
    - define targets <player.location.find_players_within[100]>
    - title "title:<&4>Phase 2" "subtitle:Blood Assault" targets:<[targets]>
    - while <server.flag[blood_cult_boss.phase]> == 2:
      - foreach <server.flag[blood_cult_boss_data.points]>:
        - flag player dwisp.active.queued_actions:->:stay
        - flag player dwisp.active.task:!
        - flag player dwisp.active.stay_target:<[value]>
        - wait 2s
    - run blood_cult_boss_phase_3

blood_cult_boss_phase_3:
  type: task
  debug: false
  script:
    - define targets <player.location.find_players_within[100]>
    - title "title:<&4>Phase 3" "subtitle:Shoot The Wisp" targets:<[targets]>
    - flag player dwisp.active.stay_target:<server.flag[blood_cult_boss_data.center]>
    - flag player dwisp.active.queued_actions:->:stay
    - flag player dwisp.active.task:!

blood_cult_boss_wisp_shot:
  type: task
  debug: false
  script:
    - if <server.flag[blood_cult_boss.phase]> == 3:
      - flag <server.flag[blood_cult_boss.player]> dwisp.active.queued_actions:<list[immediate_despawn]>
      - flag <server.flag[blood_cult_boss.player]> dwisp.active.task:!

blood_cult_boss_stage_4:
  type: task
  debug: false
  script:
    - define curry <server.match_player[Curry].if_null[null]>
    - if <[curry]> == null:
      - stop
    - define targets <player.location.find_players_within[100]>
    - define points <location[blood_cult_boss_blood_altar].points_between[<location[blood_cult_boss_blood_altar].above[5]>].distance[0.25]>
    - foreach <[points]> as:point:
      - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 2t
    - repeat 120:
      - playeffect effect:redstone at:<location[blood_cult_boss_blood_altar].above[5]> offset:0.05 quantity:5 special_data:1.5|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<location[blood_cult_boss_blood_altar].above[5]> offset:0.1 quantity:5 special_data:0.75|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 2t
    - adjust <[curry]> gravity:false
    - teleport <[curry]> <server.flag[blood_cult_boss_data.center].above[2]>
    - wait 2t
    - rotate <[curry]> yaw:10 infinite
    - repeat 60:
      - playeffect effect:redstone at:<location[blood_cult_boss_blood_altar].above[5]> offset:0.05 quantity:5 special_data:2|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<location[blood_cult_boss_blood_altar].above[5]> offset:0.1 quantity:5 special_data:1|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - run blood_cult_stage_4_beam def:<[curry].eye_location>
      - wait 5t
    - wait 2s
    - flag server blood_cult_boss.beam_count:!
    - rotate <[curry]> cancel
    - adjust <[curry]> gravity:true
    - heal <[curry]>
    - feed <[curry]>
    - flag server blood_cult_boss:!
    #- run mask_wear def:

blood_cult_stage_4_beam:
  type: task
  debug: false
  definitions: target
  script:
    - define points <proc[define_curve1].context[<location[blood_cult_boss_blood_altar].above[5]>|<server.flag[blood_cult_boss_data.center].above[3]>|3|<util.random.int[1].to[359]>|0.5]>
    - define targets <player.location.find_players_within[100]>
    - foreach <[points]> as:point:
      - playeffect effect:redstone at:<[point]> offset:0.05 quantity:5 special_data:1|<player.flag[dwisp.data.color1]> targets:<[targets]>
      - playeffect effect:redstone at:<[point]> offset:0.1 quantity:5 special_data:0.5|<player.flag[dwisp.data.color2]> targets:<[targets]>
      - wait 1t
    - run blood_cult_stage_4_beam_impact

blood_cult_stage_4_beam_impact:
  type: task
  debug: false
  script:
    - if <server.has_flag[blood_cult_boss.beam_count]>:
      - flag server blood_cult_boss.beam_count:+:1
    - else:
      - flag server blood_cult_boss.beam_count:+:1
      - while <server.has_flag[blood_cult_boss.beam_count]>:
        - define targets <player.location.find_players_within[100]>
        - playeffect effect:redstone at:<server.flag[blood_cult_boss_data.center].above[3]> offset:0.5,1,0.5 quantity:<server.flag[blood_cult_boss.beam_count].div[2].round_up> special_data:3|<player.flag[dwisp.data.color1]> targets:<[targets]>
        - wait 4t

blood_cult_boss_death:
  type: world
  debug: false
  events:
    on player dies server_flagged:blood_cult_boss:
    - if <player> == <server.flag[blood_cult_boss.player]>:
      - flag server blood_cult_boss.phase:4
      - define targets <player.location.find_players_within[100]>
      - title "title:<&4>Blood Cult Defeated..." subtitle:...Right? targets:<[targets]>
      - wait 10s
      - title "title:<&4>The Blood Altar Stirs" "subtitle:Prepare Yourselves..." targets:<[targets]>
      - run blood_cult_boss_stage_4
    - else if <server.flag[blood_cult_boss.player].location.distance[<player.location>]> < 100:
      - determine passively cancelled
      - title title:<&color[#FFFFFF]><&font[adriftus:overlay]><&chr[0004]><&chr[F801]><&chr[0004]> "subtitle:<&color[#000000]>It is not your time yet..." fade_in:10t stay:1s fade_out:10t targets:<player>
      - wait 10t
      - teleport <server.flag[blood_cult_boss_data.respawn]>
