
define_curve1:
  type: procedure
  debug: false
  definitions: start|end|intensity|angle|between
  script:
  - define a <[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment <element[40].div[<[a].size>]>
  - define points <list>
  - foreach <[a]> as:point:
    - define b <element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset <proc[find_offset].context[<[b]>|<[angle]>]>
    - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

define_curve2:
  type: procedure
  debug: false
  definitions: start|end|intensity|angle|between
  script:
  - define a <[start].face[<[end]>].points_between[<[end]>].distance[<[between]>]>
  - define increment <element[40].div[<[a].size>]>
  - define points <list>
  - foreach <[a]> as:point:
    - define b <element[1].add[<element[1].div[20].mul[<[loop_index].mul[<[increment]>].sub[20]>].power[2].mul[-1]>].mul[<[intensity]>]>
    - define offset <proc[find_offset].context[<[b]>|<[angle]>]>
    - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

define_cone1:
  type: procedure
  debug: false
  definitions: start|end|angle|blocks_between
  script:
  - define points1 <[start].points_between[<[end]>].distance[<[blocks_between]>]>
  - define points <list>
  - foreach <[points1]> as:point:
    - define radius <[angle].to_radians.tan.mul[<[blocks_between].mul[<[loop_index]>]>]>
    - define cir <[radius].mul[<util.pi>].mul[2]>
    - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[<[blocks_between]>]>]>
    - repeat <[cir].div[<[blocks_between]>].round>:
      - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
      - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

define_cone2:
  type: procedure
  debug: false
  definitions: start|end|angle|blocks_between
  script:
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
  - determine <[layers]>

define_sphere1:
  type: procedure
  debug: false
  definitions: location|radius|blocks_between
  script:
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
  - determine <[points]>

define_sphere2:
  type: procedure
  debug: false
  definitions: location|radius|blocks_between
  script:
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
  - determine <[layers]>

define_circle:
  type: procedure
  debug: false
  definitions: location|radius
  script:
  - define cir <[radius].mul[<util.pi>].mul[2]>
  - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - define points <list>
  - repeat <[cir].div[0.2].round>:
    - define offset <proc[find_offset].context[<[radius]>|<[value].mul[<[between]>]>]>
    - define points <[points].include_single[<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

define_star2:
  type: procedure
  debug: false
  definitions: location|radius|rotation|num
  script:
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
  - determine <[new_points]>

define_star:
  type: procedure
  debug: false
  definitions: location|radius|rotation|num
  script:
  - define points <list>
  - repeat <[num]>:
    - define t <element[360].div[<[num]>].mul[<[num].div[2].round_down>]>
    - define offset <proc[find_offset].context[<[radius]>|<[t].mul[<[value]>].add[<[rotation]>]>]>
    - define points <[points].include_single[<[location].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - define new_points <list>
  - repeat <[num]>:
    - foreach <[points].get[<[value]>].points_between[<[points].get[<[value].add[1]>]||<[points].get[1]>>].distance[0.4]> as:point:
      - define new_points <[new_points].include_single[<[point]>]>
  - determine <[new_points]>

define_spiral:
  type: procedure
  debug: false
  definitions: start|end|radius|angle_offset
  script:
  - define start <[start].face[<[end]>]>
  - define cir <[radius].mul[<util.pi>].mul[2]>
  - define between <element[360].div[<[radius].mul[<util.pi>].mul[2].div[0.2]>]>
  - define points <list>
  - foreach <[start].points_between[<[end]>].distance[0.4]> as:point:
    - define offset <proc[find_offset].context[<[radius]>|<[between].mul[<[loop_index]>].add[<[angle_offset]>]>]>
    - define points <[points].include_single[<[point].up[<[offset].get[1]>].right[<[offset].get[2]>]>]>
  - determine <[points]>

define_zigzag:
  type: procedure
  debug: false
  definitions: start|end|radius
  script:
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
  - determine <[points]>

find_offset:
  type: procedure
  debug: false
  definitions: C|degrees
  script:
  - while <[degrees]> > 360:
    - define degrees <[degrees].sub[360]>
  - define hyp <[degrees].to_radians.sin.mul[<[C]>]>
  - define adj <[C].power[2].sub[<[hyp].power[2]>].sqrt>
  - if <[degrees]> > 89 && <[degrees]> < 270:
    - define adj <[adj].mul[-1]>
  - determine <list[<[hyp]>|<[adj]>]>

play_animation:
  type: task
  debug: false
  definitions: points|particle
  script:
  - define points <[points]>
  - repeat <[points].size>:
    - playeffect <[particle]> <[points].get[<[value]>]> offset:0 visibility:300 quantity:2
    - wait 1t
