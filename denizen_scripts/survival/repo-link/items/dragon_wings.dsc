dragon_wings_settings:
  type: data
  debug: false
  settings:
    worlds: mainland

dragon_wings:
  type: item
  debug: false
  material: elytra
  display name: <&5>Dragon Wings
  lore:
    - "<&d>Power<&co> <&a>100<&pc>"
    - <&a>
    - "<&6>Taken from the <&d>Ender Dragon<&6>!"
  mechanisms:
    nbt: power/1
    unbreakable: true
    hides: all

dragon_wings_end:
  type: task
  debug: false
  script:
    - flag player Dragon_Wings_Fly:!
    - if <player.has_flag[Dragon_Wings_Recover]>:
      - stop
    - flag player Dragon_Wings_Recover:<queue>
    - adjust <player> gravity:true
    - while <player.has_flag[Dragon_Wings_Recover]> && <player.equipment_map.get[chestplate].scriptname||null> == dragon_wings && !<player.has_flag[Dragon_Wings_Fly]>:
      - if <player.equipment_map.get[chestplate].nbt[power]> >= 1 || <player.has_flag[Dragon_Wings_Fly]>:
        - flag player Dragon_Wings_Recover:!
        - stop
      - inventory adjust slot:39 nbt:power/<player.equipment_map.get[chestplate].nbt[power].add[0.01]>
      - inventory adjust slot:39 "lore:<list[<&b>Power<&co> <list[<&c>|<&e>|<&a>|<&a>].get[<player.equipment_map.get[chestplate].nbt[power].abs.add[.001].mul[3].round_up>]><player.equipment_map.get[chestplate].nbt[power].mul[100]><&b><&pc>].include[<player.equipment_map.get[chestplate].lore.get[2].to[3]>]>"
      - actionbar "<&d>Power Remaining<&co> <list[<&c>|<&e>|<&a>|<&a>].get[<player.equipment_map.get[chestplate].nbt[power].abs.add[.001].mul[3].round_up>]><player.equipment_map.get[chestplate].nbt[power].mul[100]><&b><&pc>"
      - wait 10t


dragon_wings_liftoff:
  type: task
  debug: false
  script:
    - if <player.location.above.material.name> == water:
      - stop
    - if <player.has_flag[Dragon_Wings_Fly]>:
      - adjust <player> gravity:false
    - while <player.has_flag[Dragon_Wings_Fly]>:
      - adjust <player> velocity:0,0.5,0
      - inventory adjust slot:39 nbt:power/<player.equipment_map.get[chestplate].nbt[power].sub[0.01]>
      - inventory adjust slot:39 "lore:<list[<&b>Power<&co> <list[<&c>|<&e>|<&a>|<&a>].get[<player.equipment_map.get[chestplate].nbt[power].abs.add[.001].mul[3].round_up>]><player.equipment_map.get[chestplate].nbt[power].mul[100]><&b><&pc>].include[<player.equipment_map.get[chestplate].lore.get[2].to[3]>]>"
      - actionbar "<&d>Power Remaining<&co> <list[<&c>|<&e>|<&a>|<&a>].get[<player.equipment_map.get[chestplate].nbt[power].mul[3].round_up>]><player.equipment_map.get[chestplate].nbt[power].mul[100]><&b><&pc>"
      - if <player.equipment_map.get[chestplate].nbt[power]> <= 0:
        - inject dragon_wings_end
      - repeat 5:
        - playeffect dragon_breath at:<player.eye_location.below[0.4].backward[0.4].left[0.25]> offset:0.25 quantity:15 targets:<player.location.world.players>
        - playeffect dragon_breath at:<player.eye_location.below[0.4].backward[0.4].right[0.25]> offset:0.25 quantity:15 targets:<player.location.world.players>
        - if !<player.has_flag[Dragon_Wings_Fly]>:
          - inject dragon_wings_end
        - if <player.gliding>:
          - adjust <player> gravity:true
          - run dragon_wings_boost
          - stop
        - wait 2t

dragon_wings_boost:
  type: task
  debug: false
  script:
    - if <player.location.above.material.name> == water:
      - stop
    - while <player.has_flag[Dragon_Wings_Fly]>:
      - adjust <player> velocity:<player.location.direction.vector.mul[2]>
      - inventory adjust slot:39 nbt:power/<player.equipment_map.get[chestplate].nbt[power].sub[0.02]>
      - inventory adjust slot:39 "lore:<list[<&b>Power<&co> <list[<&c>|<&e>|<&a>|<&a>].get[<player.equipment_map.get[chestplate].nbt[power].abs.add[.001].mul[3].round_up>]><player.equipment_map.get[chestplate].nbt[power].mul[100]><&b><&pc>].include[<player.equipment_map.get[chestplate].lore.get[2].to[3]>]>"
      - actionbar "<&d>Power Remaining<&co> <list[<&c>|<&e>|<&a>|<&a>].get[<player.equipment_map.get[chestplate].nbt[power].abs.add[.001].mul[3].round_up>]><player.equipment_map.get[chestplate].nbt[power].mul[100]><&b><&pc>"
      - if <player.equipment_map.get[chestplate].nbt[power]> <= 0 || <player.location.material.name> == water:
        - inject dragon_wings_end
      - if !<player.gliding>:
        - run dragon_wings_liftoff
        - stop
      - repeat 10:
        - playeffect dragon_breath at:<player.location.forward> offset:0.25 quantity:25 targets:<player.location.world.players>
        - playeffect dragon_breath at:<player.location.forward> offset:0.25 quantity:25 targets:<player.location.world.players>
        - if !<player.has_flag[Dragon_Wings_Fly]>:
          - inject dragon_wings_end
        - wait 1t

dragon_wings_toggle_glow:
  type: task
  debug: false
  script:
    - if <player.has_flag[dragon_wings_glow]>:
      - flag player dragon_wings_glow:!
    - else:
      - flag player dragon_wings_glow:yeeeee
      - while <player.has_flag[dragon_wings_glow]>:
        - playeffect portal at:<player.eye_location.with_pitch[0].below[1.25].backward[0.5].left[0.25]> offset:0.25 quantity:15 targets:<player.location.world.players>
        - playeffect portal at:<player.eye_location.with_pitch[0].below[1.25].backward[0.5].right[0.25]> offset:0.25 quantity:15 targets:<player.location.world.players>
        - wait 2t

dragon_wings_events:
  type: world
  debug: false
  events:
    on player starts sneaking:
      - if <player.is_flying>:
        - stop
      - if <player.equipment_map.get[chestplate].scriptname||null> == dragon_wings:
        - if !<script[dragon_wings_settings].data_key[settings.worlds].contains[<player.location.world.name>]>:
          - inject dragon_wings_toggle_glow
          - stop
        - if <player.equipment_map.get[chestplate].nbt[power]> <= 0:
          - inject dragon_wings_end
          - stop
        - if <player.has_flag[Dragon_Wings_Recover]>:
          - queue <player.flag[Dragon_Wings_Recover]> clear
          - flag player Dragon_Wings_Recover:!
        - flag player Dragon_Wings_Fly:yeeeeee
        - if !<player.gliding>:
          - inject dragon_wings_liftoff
        - else:
          - inject dragon_wings_boost
    on player stops sneaking flagged:Dragon_Wings_Fly:
      - inject dragon_wings_end
    on player equips dragon_wings:
      - if !<player.has_flag[Dragon_Wings_Recover]> && !<player.has_flag[Dragon_Wings_Fly]>:
        - inject dragon_wings_end
    after player unequips dragon_wings flagged:dragon_wings_recover:
      - if <player.equipment_map.get[chestplate].script.name||null> != dragon_wings:
        - flag player dragon_wings_recover:!
    on player unequips dragon_wings flagged:dragon_wings_glow:
      - flag player dragon_wings_glow:!
    on player changes world from spawn flagged:dragon_wings_glow:
      - flag player dragon_wings_glow:!
    on player damaged by FALL:
      - if <player.equipment_map.get[chestplate].scriptname||null> == dragon_wings:
        - determine cancelled
    on player quits flagged:Dragon_Wings_Recover:
      - flag player Dragon_Wings_Recover:!
    on player quits flagged:Dragon_Wings_Fly:
      - flag player Dragon_Wings_Fly:!
    on player quits flagged:dragon_wings_glow:
      - flag player dragon_wings_glow:!
    on player right clicks block with:firework_rocket flagged:Dragon_Wings_Fly:
      - determine cancelled
    on player starts gliding in:spawn:
      - determine cancelled
