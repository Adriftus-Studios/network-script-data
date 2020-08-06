
define_curve1:
  type: procedure
  definitions: start|end|intensity|angle|between
  script:
  - define a:<[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment:<element[40].div[<[a].size>]>
  - foreach <[a]> as:point:
    - define b:<element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset:<proc[find_offset].context[<[b]>|<[angle]>]>
    - define points:|:<[point].up[<[offset].first>].right[<[offset].get[2]>]>
  - determine <[points]>
  
define_curve2:
  type: procedure
  definitions: start|end|intensity|angle|between
  script:
  - define a:<[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment:<element[40].div[<[a].size>]>
  - foreach <[a]> as:point:
    - define b:<element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset:<proc[find_offset].context[<[b]>|<[angle]>]>
    - define points:|:<[point].up[<[offset].first>].right[<[offset].get[2]>]>
  - determine <[points]>
  
define_cone1:
  type: procedure
  definitions: start|end|angle|blocks_between
  script:
  - define points1:<[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - foreach <[points1]> as:point:
    - define radius:<[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir:<[radius].mul[<util.pi>].mul[2]>
    - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define points:|:<[point].up[<[offset].first>].right[<[offset].get[2]>]>
  - determine <[points]>

define_cone2:
  type: procedure
  definitions: start|end|angle|blocks_between
  script:
  - define points1:<[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - foreach <[points1]> as:point:
    - define radius:<[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir:<[radius].mul[<util.pi>].mul[2]>
    - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - define layer:!
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define layer:|:<[point].up[<[offset].first>].right[<[offset].get[2]>]>
    - define layers:|:<[layer].escaped>
  - determine <[layers]>

define_sphere1:
  type: procedure
  definitions: location|radius|blocks_between
  script:
  - define blocks_between:<[blocks_between]||0.4>
  - define location:<[location].with_pitch[90].with_yaw[0]>
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[180].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - define between2:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - repeat <[cir].div[<[blocks_between]>].round>:
    - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>].add[90]>]>
    - if <[offset].first> < 0:
      - define A:<[offset].first.mul[-1]>
    - else:
      - define A:<[offset].first.mul[-1]>
    - if <[offset].get[2]> < 0:
      - define B:<[offset].get[2].mul[-1]>
    - else:
      - define B:<[offset].get[2]>
    - define location2:<[location].above[<[A]>]>
    - repeat <[cir].div[<[blocks_between]>].round> as:value2:
      - define offset2:<proc[find_offset].context[<[B]>|<[value2].mul[<[between2]>]>]>
      - define points:|:<[location2].up[<[offset2].first>].right[<[offset2].get[2]>]>
  - determine <[points]>

define_sphere2:
  type: procedure
  definitions: location|radius|blocks_between
  script:
  - define blocks_between:<[blocks_between]||0.4>
  - define location:<[location].with_pitch[90].with_yaw[0]>
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[180].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - define between2:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - repeat <[cir].div[<[blocks_between]>].round>:
    - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>].add[90]>]>
    - if <[offset].first> < 0:
      - define A:<[offset].first.mul[-1]>
    - else:
      - define A:<[offset].first.mul[-1]>
    - if <[offset].get[2]> < 0:
      - define B:<[offset].get[2].mul[-1]>
    - else:
      - define B:<[offset].get[2]>
    - define location2:<[location].above[<[A]>]>
    - define layer:!
    - repeat <[cir].div[<[blocks_between]>].round> as:value2:
      - define offset2:<proc[find_offset].context[<[B]>|<[value2].mul[<[between2]>]>]>
      - define layer:|:<[location2].up[<[offset2].first>].right[<[offset2].get[2]>]>
    - define layers:|:<[layer].escaped>
  - determine <[layers]>

define_circle:
  type: procedure
  definitions: location|radius
  script:
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - repeat <[cir].div[0.2].round>:
    - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
    - define points:|:<[location].up[<[offset].first>].right[<[offset].get[2]>]>
  - determine <[points]>

define_star2:
  type: procedure
  definitions: location|radius|rotation|num
  script:
  - repeat <[num]>:
    - define t:<element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset:<proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points:|:<[location].up[<[offset].first>].right[<[offset].get[2]>]>
  - define distance:<[points].first.points_between[<[points].get[2]>].distance[0.2].size>
  - repeat <[distance]>:
    - define x:<[value]>
    - repeat <[num]>:
      - define new_points:|:<[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].first>>].distance[0.4].get[<[x]>]>
  - determine <[new_points]>

define_star:
  type: procedure
  definitions: location|radius|rotation|num
  script:
  - repeat <[num]>:
    - define t:<element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset:<proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points:|:<[location].up[<[offset].first>].right[<[offset].get[2]>]>
  - repeat <[num]>:
    - foreach <[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].first>>].distance[0.4]> as:point:
      - define new_points:|:<[point]>
  - determine <[new_points]>

define_spiral:
  type: procedure
  definitions: start|end|radius|angle_offset
  script:
  - define start:<[start].face[<[end]>]>
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - foreach <[start].points_between[<[end]>].distance[0.4]> as:point:
    - define offset:<proc[find_offset].context[<[radius]>|<[between].mul[<[loop_index]>].add[<[angle_offset]>]>]>
    - define points:|:<[point].up[<[offset].first>].right[<[offset].get[2]>]>
  - determine <[points]>

define_zigzag:
  type: procedure
  definitions: start|end|radius
  script:
  - define start:<[start].face[<[end]>]>
  - define current:<[start]>
  - define distance_needed:<[start].distance[<[end]>]>
  - while true:
    - define new_point:<[current].forward[<util.random.int[5].to[10]>]>
    - if <[start].distance[<[new_point]>]> > <[distance_needed]>:
      - define points:|:<[current].points_between[<[end]>].distance[0.4]>
      - while stop
    - else:
      - define offset:<proc[find_offset].context[<[radius]>|<util.random.int[0].to[360]>]>
      - define new_point:<[new_point].up[<[offset].first>].right[<[offset].get[2]>]>
      - define points:|:<[current].points_between[<[new_point]>].distance[0.4]>
    - define current:<[new_point]>
  - determine <[points]>

cosmetic_command:
  type: command
  name: cosmetic
  tab complete:
  - if <context.raw_args.split[].count[<&sp>]> == 0:
    - determine <list[curve1|sphere2].filter[starts_with[<context.args.first||>]]>
  - else:
    - determine <list>
  script:
  - if <player.has_flag[cosmetic]>:
    - if <context.args.first> == sphere2:
      - define layers:<proc[define_sphere2].context[<player.location.above>|1.5|0.3]>
      - define center:<player.location>
      - flag player sphere2:true
      - if <player.has_flag[sphere]>:
        - narrate "<&b>Deactivated cosmetic effect sphere2"
        - flag player sphere:!
      - else:
        - narrate "<&b>Activated cosmetic effect sphere2"
        - flag player sphere
      - while <player.has_flag[sphere]||false>:
        - repeat <[layers].size>:
          - define offset:<player.location.sub[<[center]>]>
          - define points:<[layers].get[<[value]>].unescaped>
          - define points:|:<[layers].get[<[layers].size.sub[<[value]>]>].unescaped>
          - playeffect redstone at:<[points].parse[add[<[offset]>].with_world[<player.location.world>]]> quantity:1 offset:0 visibility:100 special_data:1|<co@91,225,245>
          - wait 1t
    - else if <context.args.first> == curve1:
      - define sphere:<proc[define_sphere1].context[<player.location>|1.5|1]>
      - define center:<player.location>
      - if <player.has_flag[curve]>:
        - narrate "<&b>Deactivated cosmetic effect curve1"
        - flag player curve:!
      - else:
        - narrate "<&b>Activated cosmetic effect curve1"
        - flag player curve
      - while <player.has_flag[curve]||false>:
        - if <player.is_spawned||false> == false:
          - stop
        - define point:<[sphere].random>
        - define offset:<player.location.sub[<[center]>]>
        - run cosmetic_command_curve1_animation def:<player.location>|<[offset].add[<[point]>].with_world[<player.location.world>]>
        - wait 3t
  - else:
    - narrate "<&c>You do not have permission for this command."

cosmetic_command_curve1_animation:
  type: task
  definitions: start|end
  script:
  - define points:<proc[define_curve1].context[<[start]>|<[end]>|1|0|0.1]>
  - foreach <[points]> as:point:
    - playeffect spell_witch <[point]> offset:0 visibility:300 quantity:1
    - wait 1t

test_effects_command:
  type: command
  debug: false
  name: test_effects
  tab complete:
  - if <context.raw_args.split[].count[<&sp>]> == 0:
    - determine <list[curve1|curve2|star1|star2|circle|spiral|zigzag|sphere1|sphere2].filter[starts_with[<context.args.first>]]||<list[curve|star1|star2|circle|spiral|zigzag|sphere1|sphere2]>>
  - else if <context.raw_args.split[].count[<&sp>]> == 1:
    - determine <server.particle_types.parse[to_lowercase].filter[starts_with[<context.args.get[2]||<server.particle_types>>]]>
  script:
  - define particle:<context.args.get[2]||spell_witch>
  - choose <context.args.first>:
    - cast zigzag:
      - define points:<proc[define_zigzag].context[<player.location>|<player.location.forward[20]>|2]>
      - foreach <[points]>:
        - playeffect <[particle]> at:<[value]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case curve1:
      - define start:<player.location>
      - define end:<player.location.forward[20]>
      - repeat 90:
        #- define points:<proc[define_curve1].context[start|end|intensity|angle|between]>
        - define points:<proc[define_curve1].context[<[start]>|<[end]>|5|<[value].mul[4]>|1]>
        - playeffect <[particle]> at:<[points]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case curve2:
      - define start:<player.location>
      - define end:<player.location.forward[20]>
      - narrate "not done yet"
    - case star1:
      - define points:<proc[define_star].context[<player.location.forward[4]>|3|90|5]>
      - repeat <[points].size>:
        - playeffect <[particle]> at:<[points].get[<[value]>]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case star2:
      - define num:5
      - define points:<proc[define_star2].context[<player.location.forward[4]>|3|90|<[num]>]>
      - repeat <[points].size.div[<[num]>]>:
        - repeat <[num]>:
          - playeffect <[particle]> at:<[points].get[<[value].mul[<[num]>].add[<[value]>]>]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case sphere1:
      - define points:<proc[define_sphere1].context[<player.location.forward[4]>|2|0.5]>
      - playeffect <[particle]> at:<[points]> quantity:1 offset:0 visibility:100
    - case sphere2:
      - define layers:<proc[define_sphere2].context[<player.location.above>|2|0.5]>
      - define center:<player.location>
      - repeat 5:
        - repeat <[layers].size>:
          - define offset:<[center].sub[<player.location>]>
          - define points:<[layers].get[<[value]>].unescaped>
          - define points:|:<[layers].get[<[layers].size.sub[<[value]>]>].unescaped>
          - playeffect redstone at:<[points].parse[sub[<[offset]>]]> quantity:1 offset:0 visibility:100 special_data:1|<co@91,225,245>
          - wait 2t
    - case circle:
      - define points:<proc[define_circle].context[<player.location.forward[4]>|3]>
      - foreach <[points]>:
        - playeffect <[particle]> at:<[value]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case spiral:
      - define points:<proc[define_spiral].context[<player.location>|<player.location.forward[20]>|0.5|0]>
      - foreach <[points]> as:point:
        - playeffect <[particle]> at:<[point]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case cone1:
      - define start:<player.location>
      - define end:<player.location.forward[20]>
      - define points:<proc[define_cone1].context[<[start].above>|<[end]>|20|1]>
      - narrate <[points].size>
      - repeat 1:
        - playeffect <[particle]> at:<[points]> quantity:5 offset:0 visibility:100
        - wait 1t
    - case cone2:
      - define start:<player.location>
      - define end:<player.location.forward[20]>
      - define layers:<proc[define_cone2].context[<[start].above>|<[end]>|20|1]>
      - narrate <[layers].size>
      - foreach <[layers]> as:layer:
        - playeffect <[particle]> at:<[layer].unescaped> quantity:5 offset:0 visibility:100
        - wait 1t

find_offset:
  type: procedure
  definitions: C|degrees
  script:
  - while <[degrees]> > 360:
    - define degrees:<[degrees].sub[360]>
  - define hyp:<[degrees].to_radians.sin.mul[<[C]>]>
  - define adj:<[C].power[2].sub[<[hyp].power[2]>].sqrt>
  - if <[degrees]> > 89 && <[degrees]> < 270:
    - define adj:<[adj].mul[-1]>
  - determine <list[<[hyp]>|<[adj]>]>

play_animation:
  type: task
  definitions: points|particle
  script:
  - define points:<[points].unescaped>
  - repeat <[points].size>:
    - playeffect <[particle]> <[points].get[<[value]>]> offset:0 visibility:300 quantity:2
    - wait 1t
