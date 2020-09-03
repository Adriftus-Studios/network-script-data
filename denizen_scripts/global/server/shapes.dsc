
define_curve1:
  type: procedure
  definitions: start|end|intensity|angle|between
  script:
<<<<<<< HEAD
  - define a:<[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment:<element[40].div[<[a].size>]>
  - foreach <[a]> as:point:
    - define b:<element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset:<proc[find_offset].context[<[b]>|<[angle]>]>
    - define points:|:<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
  - determine <[points]>
  
=======
  - define a <[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment <element[40].div[<[a].size>]>
  - define points <list>
  - foreach <[a]> as:point:
    - define b <element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset <proc[find_offset].context[<[b]>|<[angle]>]>
    - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
define_curve2:
  type: procedure
  definitions: start|end|intensity|angle|between
  script:
<<<<<<< HEAD
  - define a:<[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment:<element[40].div[<[a].size>]>
  - foreach <[a]> as:point:
    - define b:<element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset:<proc[find_offset].context[<[b]>|<[angle]>]>
    - define points:|:<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
  - determine <[points]>
  
=======
  - define a <[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment <element[40].div[<[a].size>]>
  - define points <list>
  - foreach <[a]> as:point:
    - define b <element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset <proc[find_offset].context[<[b]>|<[angle]>]>
    - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
define_cone1:
  type: procedure
  definitions: start|end|angle|blocks_between
  script:
<<<<<<< HEAD
  - define points1:<[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - foreach <[points1]> as:point:
    - define radius:<[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir:<[radius].mul[<util.pi>].mul[2]>
    - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define points:|:<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
=======
  - define points1 <[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - define points <list>
  - foreach <[points1]> as:point:
    - define radius <[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir <[radius].mul[<util.pi>].mul[2]>
    - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[points]>

define_cone2:
  type: procedure
  definitions: start|end|angle|blocks_between
  script:
<<<<<<< HEAD
  - define points1:<[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - foreach <[points1]> as:point:
    - define radius:<[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir:<[radius].mul[<util.pi>].mul[2]>
    - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - define layer:!
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define layer:|:<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
    - define layers:|:<[layer].escaped>
=======
  - define points1 <[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - define layers <list>
  - foreach <[points1]> as:point:
    - define radius <[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir <[radius].mul[<util.pi>].mul[2]>
    - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - define layer <list>
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define layer <[layer].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
    - define layers <[layers].include_single[<[layer]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[layers]>

define_sphere1:
  type: procedure
  definitions: location|radius|blocks_between
  script:
<<<<<<< HEAD
  - define blocks_between:<[blocks_between]||0.4>
  - define location:<[location].with_pitch[90].with_yaw[0]>
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - repeat <[cir].div[<[blocks_between]>].round>:
    - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>].add[90]>]>
    - if <[offset].get[1]> < 0:
      - define A:<[offset].get[1].mul[-1]>
    - else:
      - define A:<[offset].get[1].mul[-1]>
    - if <[offset].get[2]> < 0:
      - define B:<[offset].get[2].mul[-1]>
    - else:
      - define B:<[offset].get[2]>
    - define location2:<[location].above[<[A]>]>
    - repeat <[cir].div[<[blocks_between]>].round> as:value2:
      - define offset2:<proc[find_offset].context[<[B]>|<[value2].mul[<[between]>]>]>
      - define points:|:<[location2].up[<[offset2].get[1]>].right[<[offset2].get[2]>]>
=======
  - define blocks_between <[blocks_between]||0.4>
  - define location <[location].with_pitch[90].with_yaw[0]>
  - define cir <[radius].mul[<util.pi>].mul[2]>
  - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - define points <list>
  - repeat <[cir].div[<[blocks_between]>].round>:
    - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>].add[90]>]>
    - if <[offset].get[1]> < 0:
      - define A <[offset].get[1].mul[-1]>
    - else:
      - define A <[offset].get[1].mul[-1]>
    - if <[offset].get[2]> < 0:
      - define B <[offset].get[2].mul[-1]>
    - else:
      - define B <[offset].get[2]>
    - define location2 <[location].above[<[A]>]>
    - repeat <[cir].div[<[blocks_between]>].round> as:value2:
      - define offset2 <proc[find_offset].context[<[B]>|<[value2].mul[<[between]>]>]>
      - define points <[points].include_single[<[location2].up[<[offset2].get[1]>].right[<[offset2].get[2]>]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[points]>

define_sphere2:
  type: procedure
  definitions: location|radius|blocks_between
  script:
<<<<<<< HEAD
  - define blocks_between:<[blocks_between]||0.4>
  - define location:<[location].with_pitch[90].with_yaw[0]>
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - repeat <[cir].div[<[blocks_between]>].round>:
    - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>].add[90]>]>
    - if <[offset].get[1]> < 0:
      - define A:<[offset].get[1].mul[-1]>
    - else:
      - define A:<[offset].get[1].mul[-1]>
    - if <[offset].get[2]> < 0:
      - define B:<[offset].get[2].mul[-1]>
    - else:
      - define B:<[offset].get[2]>
    - define location2:<[location].above[<[A]>]>
    - define layer:!
    - repeat <[cir].div[<[blocks_between]>].round> as:value2:
      - define offset2:<proc[find_offset].context[<[B]>|<[value2].mul[<[between]>]>]>
      - define layer:|:<[location2].up[<[offset2].get[1]>].right[<[offset2].get[2]>]>
    - define layers:|:<[layer].escaped>
=======
  - define blocks_between <[blocks_between]||0.4>
  - define location <[location].with_pitch[90].with_yaw[0]>
  - define cir <[radius].mul[<util.pi>].mul[2]>
  - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
  - define layers <list>
  - repeat <[cir].div[<[blocks_between]>].round>:
    - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>].add[90]>]>
    - if <[offset].get[1]> < 0:
      - define A <[offset].get[1].mul[-1]>
    - else:
      - define A <[offset].get[1].mul[-1]>
    - if <[offset].get[2]> < 0:
      - define B <[offset].get[2].mul[-1]>
    - else:
      - define B <[offset].get[2]>
    - define location2 <[location].above[<[A]>]>
    - define layer <list>
    - repeat <[cir].div[<[blocks_between]>].round> as:value2:
      - define offset2 <proc[find_offset].context[<[B]>|<[value2].mul[<[between]>]>]>
      - define layer <[layer].include_single[<[location2].up[<[offset2].get[1]>].right[<[offset2].get[2]>]>]>
    - define layers <[layers].include_single[<[layer]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[layers]>

define_circle:
  type: procedure
  definitions: location|radius
  script:
<<<<<<< HEAD
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - repeat <[cir].div[0.2].round>:
    - define offset:<proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
    - define points:|:<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>
=======
  - define cir <[radius].mul[<util.pi>].mul[2]>
  - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - define points <list>
  - repeat <[cir].div[0.2].round>:
    - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
    - define points <[points].include_single[<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[points]>

define_star2:
  type: procedure
  definitions: location|radius|rotation|num
  script:
<<<<<<< HEAD
  - repeat <[num]>:
    - define t:<element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset:<proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points:|:<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>
  - define distance:<[points].get[1].points_between[<[points].get[2]>].distance[0.2].size>
  - repeat <[distance]>:
    - define x:<[value]>
    - repeat <[num]>:
      - define new_points:|:<[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].get[1]>>].distance[0.4].get[<[x]>]>
=======
  - define points <list>
  - repeat <[num]>:
    - define t <element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset <proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points <[points].include_single[<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - define distance <[points].get[1].points_between[<[points].get[2]>].distance[0.2].size>
  - define new_points <list>
  - repeat <[distance]>:
    - define x <[value]>
    - repeat <[num]>:
      - define new_points <[new_points].include[<[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].get[1]>>].distance[0.4].get[<[x]>]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[new_points]>

define_star:
  type: procedure
  definitions: location|radius|rotation|num
  script:
<<<<<<< HEAD
  - repeat <[num]>:
    - define t:<element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset:<proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points:|:<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>
  - repeat <[num]>:
    - foreach <[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].get[1]>>].distance[0.4]> as:point:
      - define new_points:|:<[point]>
=======
  - define points <list>
  - repeat <[num]>:
    - define t <element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset <proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points <[points].include_single[<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - define new_points <list>
  - repeat <[num]>:
    - foreach <[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].get[1]>>].distance[0.4]> as:point:
      - define new_points <[new_points].include_single[<[point]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[new_points]>

define_spiral:
  type: procedure
  definitions: start|end|radius|angle_offset
  script:
<<<<<<< HEAD
  - define start:<[start].face[<[end]>]>
  - define cir:<[radius].mul[<util.pi>].mul[2]>
  - define between:<element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - foreach <[start].points_between[<[end]>].distance[0.4]> as:point:
    - define offset:<proc[find_offset].context[<[radius]>|<[between].mul[<[loop_index]>].add[<[angle_offset]>]>]>
    - define points:|:<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
=======
  - define start <[start].face[<[end]>]>
  - define cir <[radius].mul[<util.pi>].mul[2]>
  - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - define points <list>
  - foreach <[start].points_between[<[end]>].distance[0.4]> as:point:
    - define offset <proc[find_offset].context[<[radius]>|<[between].mul[<[loop_index]>].add[<[angle_offset]>]>]>
    - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[points]>

define_zigzag:
  type: procedure
  definitions: start|end|radius
  script:
<<<<<<< HEAD
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
      - define new_point:<[new_point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
      - define points:|:<[current].points_between[<[new_point]>].distance[0.4]>
    - define current:<[new_point]>
=======
  - define start <[start].face[<[end]>]>
  - define current <[start]>
  - define distance_needed <[start].distance[<[end]>]>
  - define points <list>
  - while true:
    - define new_point <[current].forward[<util.random.int[5].to[10]>]>
    - if <[start].distance[<[new_point]>]> > <[distance_needed]>:
      - define points <[points].include[<[current].points_between[<[end]>].distance[0.4]>]>
      - while stop
    - else:
      - define offset <proc[find_offset].context[<[radius]>|<util.random.int[0].to[360]>]>
      - define new_point <[new_point].up[<[offset].get[1]>].right[<[offset].get[2]>]>
      - define points <[points].include[<[current].points_between[<[new_point]>].distance[0.4]>]>
    - define current <[new_point]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <[points]>

test_effects_command:
  type: command
  debug: false
<<<<<<< HEAD
  name: test_effects
  tab complete:
  - if <context.raw_args.split[].count[<&sp>]> == 0:
    - determine <list[curve1|curve2|star1|star2|circle|spiral|zigzag|sphere1|sphere2].filter[starts_with[<context.args.get[1]>]]||<list[curve|star1|star2|circle|spiral|zigzag|sphere1|sphere2]>>
  - else if <context.raw_args.split[].count[<&sp>]> == 1:
    - determine <server.list_particles.parse[to_lowercase].filter[starts_with[<context.args.get[2]||<server.list_particles>>]]>
  script:
  - define particle:<context.args.get[2]||spell_witch>
  - if <context.args.get[1]> == zigzag:
    - define points:<proc[define_zigzag].context[<player.location>|<player.location.forward[20]>|2]>
=======
  description: does fancies
  usage: /test_effects
  name: test_effects
  tab complete:
  - if <context.args.is_empty>:
    - determine <list[curve1|curve2|star1|star2|circle|spiral|zigzag|sphere1|sphere2].filter[starts_with[<context.args.get[1]>]]||<list[curve|star1|star2|circle|spiral|zigzag|sphere1|sphere2]>>
  - else:
    - determine <server.particle_types.parse[to_lowercase].filter[starts_with[<context.args.get[2]||<server.particle_types>>]]>
  script:
  - define particle <context.args.get[2]||spell_witch>
  - if <context.args.get[1]> == zigzag:
    - define points <proc[define_zigzag].context[<player.location>|<player.location.forward[20]>|2]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
    - foreach <[points]>:
      - playeffect <[particle]> at:<[value]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == curve1:
<<<<<<< HEAD
    - define start:<player.location>
    - define end:<player.location.forward[20]>
    - repeat 90:
      #- define points:<proc[define_curve1].context[start|end|intensity|angle|between]>
      - define points:<proc[define_curve1].context[<[start]>|<[end]>|5|<[value].mul[4]>|1]>
      - playeffect <[particle]> at:<[points]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == curve2:
    - define start:<player.location>
    - define end:<player.location.forward[20]>
    - narrate "not done yet"
  - if <context.args.get[1]> == star1:
    - define points:<proc[define_star].context[<player.location.forward[4]>|3|90|5]>
=======
    - define start <player.location>
    - define end <player.location.forward[20]>
    - repeat 90:
      #- define points <proc[define_curve1].context[start|end|intensity|angle|between]>
      - define points <proc[define_curve1].context[<[start]>|<[end]>|5|<[value].mul[4]>|1]>
      - playeffect <[particle]> at:<[points]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == curve2:
    - define start <player.location>
    - define end <player.location.forward[20]>
    - narrate "not done yet"
  - if <context.args.get[1]> == star1:
    - define points <proc[define_star].context[<player.location.forward[4]>|3|90|5]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
    - repeat <[points].size>:
      - playeffect <[particle]> at:<[points].get[<[value]>]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == star2:
    - define num:5
<<<<<<< HEAD
    - define points:<proc[define_star2].context[<player.location.forward[4]>|3|90|<[num]>]>
=======
    - define points <proc[define_star2].context[<player.location.forward[4]>|3|90|<[num]>]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
    - repeat <[points].size.div[<[num]>]>:
      - repeat <[num]>:
        - playeffect <[particle]> at:<[points].get[<[value].mul[<[num]>].add[<[value]>]>]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == sphere1:
<<<<<<< HEAD
    - define points:<proc[define_sphere1].context[<player.location.forward[4]>|2|0.5]>
    - playeffect redstone <[points]> offset:0 visibility:300 quantity:1 special_data:1|<co@255,0,0>
  - if <context.args.get[1]> == sphere2:
    - define layers:<proc[define_sphere2].context[<player.location.above>|2|0.5]>
    - define center:<player.location>
    - repeat 5:
      - repeat <[layers].size>:
        - define offset:<[center].sub[<player.location>]>
        - define points:<[layers].get[<[value]>].unescaped>
        - define points:|:<[layers].get[<[layers].size.sub[<[value]>]>].unescaped>
        - playeffect redstone at:<[points].parse[sub[<[offset]>]]> quantity:1 offset:0 visibility:100 special_data:1|<co@91,225,245>
        - wait 2t
  - if <context.args.get[1]> == circle:
    - define points:<proc[define_circle].context[<player.location.forward[4]>|3]>
=======
    - define points <proc[define_sphere1].context[<player.location.forward[4]>|2|0.5]>
    - playeffect redstone <[points]> offset:0 visibility:300 quantity:1 special_data:1|<color[255,0,0]>
  - if <context.args.get[1]> == sphere2:
    - define layers <proc[define_sphere2].context[<player.location.above>|2|0.5]>
    - define center <player.location>
    - repeat 5:
      - repeat <[layers].size>:
        - define offset <[center].sub[<player.location>]>
        - define points <[layers].get[<[value]>]>
        - define points <[points].include_single[<[layers].get[<[layers].size.sub[<[value]>]>]>]>
        - playeffect redstone at:<[points].parse[sub[<[offset]>]]> quantity:1 offset:0 visibility:100 special_data:1|<color[91,225,245]>
        - wait 2t
  - if <context.args.get[1]> == circle:
    - define points <proc[define_circle].context[<player.location.forward[4]>|3]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
    - foreach <[points]>:
      - playeffect <[particle]> at:<[value]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == spiral:
<<<<<<< HEAD
    - define points:<proc[define_spiral].context[<player.location>|<player.location.forward[20]>|0.5|0]>
=======
    - define points <proc[define_spiral].context[<player.location>|<player.location.forward[20]>|0.5|0]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
    - foreach <[points]> as:point:
      - playeffect <[particle]> at:<[point]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == cone1:
<<<<<<< HEAD
    - define start:<player.location>
    - define end:<player.location.forward[20]>
    - define points:<proc[define_cone1].context[<[start].above>|<[end]>|20|1]>
=======
    - define start <player.location>
    - define end <player.location.forward[20]>
    - define points <proc[define_cone1].context[<[start].above>|<[end]>|20|1]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
    - narrate <[points].size>
    - repeat 1:
      - playeffect <[particle]> at:<[points]> quantity:5 offset:0 visibility:100
      - wait 1t
  - if <context.args.get[1]> == cone2:
<<<<<<< HEAD
    - define start:<player.location>
    - define end:<player.location.forward[20]>
    - define layers:<proc[define_cone2].context[<[start].above>|<[end]>|20|1]>
    - narrate <[layers].size>
    - foreach <[layers]> as:layer:
      - playeffect <[particle]> at:<[layer].unescaped> quantity:5 offset:0 visibility:100
=======
    - define start <player.location>
    - define end <player.location.forward[20]>
    - define layers <proc[define_cone2].context[<[start].above>|<[end]>|20|1]>
    - narrate <[layers].size>
    - foreach <[layers]> as:layer:
      - playeffect <[particle]> at:<[layer]> quantity:5 offset:0 visibility:100
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
      - wait 1t

find_offset:
  type: procedure
  definitions: C|degrees
  script:
  - while <[degrees]> > 360:
<<<<<<< HEAD
    - define degrees:<[degrees].sub[360]>
  - define hyp:<[degrees].to_radians.sin.mul[<[C]>]>
  - define adj:<[C].power[2].sub[<[hyp].power[2]>].sqrt>
  - if <[degrees]> > 89 && <[degrees]> < 270:
    - define adj:<[adj].mul[-1]>
=======
    - define degrees <[degrees].sub[360]>
  - define hyp <[degrees].to_radians.sin.mul[<[C]>]>
  - define adj <[C].power[2].sub[<[hyp].power[2]>].sqrt>
  - if <[degrees]> > 89 && <[degrees]> < 270:
    - define adj <[adj].mul[-1]>
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
  - determine <list[<[hyp]>|<[adj]>]>

play_animation:
  type: task
  definitions: points|particle
  script:
<<<<<<< HEAD
  - define points:<[points].unescaped>
  - repeat <[points].size>:
    - playeffect <[particle]> <[points].get[<[value]>]> offset:0 visibility:300 quantity:2
    - wait 1t
=======
  - define points <[points]>
  - repeat <[points].size>:
    - playeffect <[particle]> <[points].get[<[value]>]> offset:0 visibility:300 quantity:2
    - wait 1t
>>>>>>> 485fb67762c81d88735438a7dca13bc98ebabba8
